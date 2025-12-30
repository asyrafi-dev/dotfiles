#!/usr/bin/env bash
set -euo pipefail
trap 'echo "Podman installer error on line $LINENO" >&2; exit 1' ERR

ASSUME_YES=${ASSUME_YES:-0}
DRY_RUN=${DRY_RUN:-0}
CI=${CI:-}

echo "[podman] Installing Podman and Kubernetes tools"

# Check if Podman already installed
if command -v podman >/dev/null 2>&1; then
  CURRENT_VERSION=$(podman --version | awk '{print $3}')
  echo "Podman already installed: v$CURRENT_VERSION"
  
  if [ "${ASSUME_YES:-0}" -eq 0 ] && [ -z "${CI:-}" ]; then
    read -rp "Do you want to reinstall/update Podman? [y/N] " reinstall
    if [[ ! $reinstall =~ ^[Yy]$ ]]; then
      echo "Skipping Podman installation."
      # Still check kubectl
      if ! command -v kubectl >/dev/null 2>&1; then
        echo "kubectl not found, will install..."
      else
        echo "kubectl already installed: $(kubectl version --client --short 2>/dev/null || kubectl version --client | head -1)"
        exit 0
      fi
    fi
  else
    echo "Podman already installed, skipping."
    if command -v kubectl >/dev/null 2>&1; then
      echo "kubectl already installed, skipping."
      exit 0
    fi
  fi
fi

if [ "$DRY_RUN" -eq 1 ]; then
  echo "DRY-RUN: would install Podman"
  echo "DRY-RUN: would install podman-compose"
  echo "DRY-RUN: would install kubectl"
  echo "DRY-RUN: would configure rootless mode"
  exit 0
fi

# Update package lists
echo "Updating package lists..."
sudo apt-get update

# Install Podman if not installed
if ! command -v podman >/dev/null 2>&1; then
  echo "Installing Podman..."
  sudo apt-get install -y podman

  # Install podman-compose for docker-compose compatibility
  echo "Installing podman-compose..."
  sudo apt-get install -y podman-compose

  # Enable and configure rootless mode
  echo "Configuring rootless Podman..."

  # Enable user namespaces if not already enabled
  if [ -f /proc/sys/kernel/unprivileged_userns_clone ]; then
    if [ "$(cat /proc/sys/kernel/unprivileged_userns_clone)" != "1" ]; then
      echo "Enabling unprivileged user namespaces..."
      echo 'kernel.unprivileged_userns_clone=1' | sudo tee /etc/sysctl.d/99-podman.conf
      sudo sysctl --system
    fi
  fi

  # Configure subuid and subgid for rootless containers
  if ! grep -q "^$(whoami):" /etc/subuid 2>/dev/null; then
    echo "Configuring subuid/subgid..."
    sudo usermod --add-subuids 100000-165535 --add-subgids 100000-165535 "$(whoami)"
  fi

  # Create registries config for Docker Hub compatibility
  mkdir -p ~/.config/containers
  if [ ! -f ~/.config/containers/registries.conf ]; then
    cat > ~/.config/containers/registries.conf << 'EOF'
[registries.search]
registries = ['docker.io', 'quay.io', 'ghcr.io']

[registries.insecure]
registries = []
EOF
  fi
fi

# Install kubectl
if ! command -v kubectl >/dev/null 2>&1; then
  echo "Installing kubectl..."
  
  # Download latest stable kubectl
  KUBECTL_VERSION=$(curl -L -s https://dl.k8s.io/release/stable.txt)
  echo "Downloading kubectl $KUBECTL_VERSION..."
  
  curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl"
  
  # Download checksum
  curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl.sha256"
  
  # Verify checksum
  echo "Verifying kubectl checksum..."
  if echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check; then
    echo "Checksum verified"
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
    rm -f kubectl kubectl.sha256
  else
    echo "ERROR: kubectl checksum verification failed"
    rm -f kubectl kubectl.sha256
    exit 1
  fi
  
  # Enable kubectl autocompletion
  if [ -f ~/.bashrc ]; then
    if ! grep -q "kubectl completion bash" ~/.bashrc; then
      echo "Adding kubectl autocompletion to ~/.bashrc..."
      cat >> ~/.bashrc << 'EOF'

# kubectl autocompletion
if command -v kubectl >/dev/null 2>&1; then
  source <(kubectl completion bash)
  alias k=kubectl
  complete -o default -F __start_kubectl k
fi
EOF
    fi
  fi
fi

# Verify installation
echo
echo "Installation complete!"
echo "================================"

if command -v podman >/dev/null 2>&1; then
  PODMAN_VERSION=$(podman --version | awk '{print $3}')
  echo "Podman version: v$PODMAN_VERSION"
fi

if command -v podman-compose >/dev/null 2>&1; then
  echo "podman-compose: installed"
fi

if command -v kubectl >/dev/null 2>&1; then
  KUBECTL_VERSION=$(kubectl version --client -o yaml 2>/dev/null | grep gitVersion | awk '{print $2}' || kubectl version --client | head -1)
  echo "kubectl version: $KUBECTL_VERSION"
fi

echo
echo "Podman commands:"
echo "  podman run hello-world       - Test installation"
echo "  podman ps                    - List running containers"
echo "  podman images                - List images"
echo "  podman-compose up -d         - Start compose services"
echo
echo "Kubernetes commands:"
echo "  kubectl version              - Show version"
echo "  kubectl cluster-info         - Cluster info"
echo "  kubectl get pods             - List pods"
echo "  kubectl get nodes            - List nodes"
echo "  k get pods                   - Short alias"
echo
echo "Note: Podman runs rootless by default (no sudo needed)"
echo "Note: Restart terminal or run 'source ~/.bashrc' for kubectl autocompletion"
