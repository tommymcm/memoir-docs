all:
	mdbook build

serve:
	mdbook serve --open

clean:
	rm -rf docs/

.PHONY: all
