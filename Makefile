.PHONY: stow delete restow

stow:
	stow */

restow:
	stow --restow */

delete:
	stow --delete */
