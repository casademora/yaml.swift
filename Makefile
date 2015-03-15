module-name = Yaml
sources = Operators.swift Result.swift Regex.swift Tokenizer.swift Parser.swift Yaml.swift
sdk = $$(xcrun --show-sdk-path --sdk iphonesimulator)
target = x86_64-apple-ios8.3
flags =

debug:   flags += -g
release: flags += -O

all: build/libyaml.dylib build/Yaml.swiftmodule

debug:   all
release: all

build/libyaml.dylib: $(sources) | build
	@echo Build lib...
	@xcrun swiftc \
		-emit-library \
		-module-name $(module-name) \
		-sdk $(sdk) \
		-target $(target) \
		-o $@ \
		$(flags) \
		$^

build/Yaml.swiftmodule: build/libyaml.dylib
	@echo Build swiftmodule...
	@xcrun swiftc \
		-emit-module \
		-module-name $(module-name) \
		-sdk $(sdk) \
		-target $(target) \
		-o $@ \
		$(sources)

build/test: Test.swift build/Yaml.swiftmodule
	@echo Build test...
	@xcrun swiftc \
		-target $(target) \
		-emit-executable \
		-sdk $(sdk) \
		-I build \
		-L build \
		-lyaml \
		-o $@ \
		$<

build:
	@mkdir -p $@

test: build/test
	@echo Testing...
	@build/test

clean:
	@rm -rf build

.PHONY: clean test
