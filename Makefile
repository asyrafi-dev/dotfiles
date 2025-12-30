.PHONY: help install dry-run verify test clean shellcheck setup-git rollback uninstall update

help:
	@echo "Dotfiles Makefile"
	@echo ""
	@echo "Available targets:"
	@echo "  make install     - Run full installation"
	@echo "  make dry-run     - Preview installation without changes"
	@echo "  make verify      - Verify installation"
	@echo "  make setup-git   - Configure Git user information"
	@echo "  make rollback    - Rollback to previous configuration"
	@echo "  make uninstall   - Remove dotfiles from system"
	@echo "  make update      - Update system and tools"
	@echo "  make test        - Run tests"
	@echo "  make shellcheck  - Run ShellCheck on all scripts"
	@echo "  make clean       - Remove generated files"
	@echo "  make help        - Show this help message"

install:
	@chmod +x install.sh scripts/*.sh
	@./install.sh

dry-run:
	@chmod +x install.sh scripts/*.sh
	@./install.sh --dry-run

verify:
	@chmod +x scripts/verify-install.sh
	@bash scripts/verify-install.sh

setup-git:
	@chmod +x scripts/setup-git-user.sh
	@bash scripts/setup-git-user.sh

rollback:
	@chmod +x scripts/rollback.sh
	@bash scripts/rollback.sh

uninstall:
	@chmod +x scripts/uninstall.sh
	@bash scripts/uninstall.sh

update:
	@chmod +x home/bin/update-system.sh
	@bash home/bin/update-system.sh

test:
	@chmod +x install.sh scripts/*.sh
	@bats tests/basic.bats

shellcheck:
	@shellcheck install.sh scripts/*.sh

clean:
	@rm -f *.log stow-preview.txt
	@echo "Cleaned generated files"
