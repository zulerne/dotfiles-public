PACKAGES := $(filter-out manual/ go60/ iterm/ brave/,$(wildcard */))

.PHONY: stow delete restow brave-policies brave-policies-delete

stow:
	stow $(PACKAGES)

restow:
	stow --restow $(PACKAGES)

delete:
	stow --delete $(PACKAGES)

# macOS manages persistent policies through an installed configuration profile.
brave-policies:
	/usr/bin/plutil -lint "brave/brave.mobileconfig"
	/usr/bin/open "$(CURDIR)/brave/brave.mobileconfig"
	@echo 'Finish installing Brave — Minimal in System Settings > General > Device Management, then quit and reopen Brave.'

brave-policies-delete:
	@echo 'Remove Brave — Minimal in System Settings > General > Device Management, then quit and reopen Brave.'
	/usr/bin/open -a "System Settings"
