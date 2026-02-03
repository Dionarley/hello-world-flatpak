APP=hello-world
MANIFEST=com.example.HelloWorld.yml

test:
	shellcheck app/bin/$(APP)
	bats tests/

flatpak-build:
	flatpak-builder --force-clean --sandbox build-dir $(MANIFEST)

flatpak-run:
	flatpak-builder --run build-dir $(MANIFEST) $(APP)
