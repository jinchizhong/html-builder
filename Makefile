all: build

build: clean
	gem build *.gemspec

install: build
	sudo gem install ./*.gem

uninstall: 
	sudo gem uninstall html-builder

clean:
	rm -rf *.gem

upload: build
	gem push *.gem
