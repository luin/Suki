REPORTER = spec

test:
	@NODE_ENV=test ./node_modules/.bin/mocha \
		--reporter $(REPORTER) \
		--compilers coffee:coffee-script

test-w:
	@NODE_ENV=test ./node_modules/.bin/mocha \
		--reporter $(REPORTER) \
		--compilers coffee:coffee-script \
		--growl \
		--watch

.PHONY: test test-w
