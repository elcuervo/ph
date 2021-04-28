.PHONY: *

default: test

build:
	rm -f *.gem
	gem build ph.gemspec

publish: build
	gem push *.gem

console:
	irb -Ilib -rph

test:
	ruby -Ilib:spec spec/*_spec.rb
