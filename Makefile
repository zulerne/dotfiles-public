PACKAGES := $(filter-out manual/,$(wildcard */))

.PHONY: stow delete restow

stow:
	stow $(PACKAGES)

restow:
	stow --restow $(PACKAGES)

delete:
	stow --delete $(PACKAGES)
