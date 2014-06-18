all: build

build:
	gem build *.gemspec

install: build
	sudo gem install ./*.gem

uninstall: 
	sudo gem uninstall html-builder

clean:
	rm -rf *.gem
