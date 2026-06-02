# --- Makefile --------------------------------------------------------

# This Makefile is a little complex for such a simple project, but the
# goal was to enable easily building, testing, and benchmarking any
# single problem with ease.

LANGS := hs scm  # Languages extensions to search for
BIN   := .build
BENCH := hyperfine --warmup=3 --shell=none
.DEFAULT_GOAL := help

# --- Discovery -------------------------------------------------------

# `SRCS` are all the individual source files across the project
SRCS       := $(foreach lang,$(LANGS),$(wildcard src/by-problem/*/*.$(lang)))
# `TARGETS` are all the final build products of each source
TARGETS    := $(patsubst src/by-problem/%,$(BIN)/%,$(SRCS))
TARGETDIRS := $(sort $(dir $(TARGETS)))
# `PROBLEMS` are the actual problems, e.g. p001
PROBLEMS   := $(notdir $(patsubst %/,%,$(sort $(dir $(SRCS)))))

# --- Phony targets ---------------------------------------------------

.PHONY: help clean
.PHONY: build/all test/all bench/all
.PHONY: $(addprefix build/, $(PROBLEMS))
.PHONY: $(addprefix test/,  $(PROBLEMS))
.PHONY: $(addprefix bench/, $(PROBLEMS))

help:
	@echo "Targets:"
	@echo "  build/<p###>   compile all language impls for one problem"
	@echo "  test/<p###>    run all impls and check expected output"
	@echo "  bench/<p###>   benchmark all impls"
	@echo "  build/all, test/all, bench/all"
	@echo "  clean"

clean:
	rm -rf $(BIN)

# --- Build targets ---------------------------------------------------

# `problem_rules` is a macro that expands out on every valid target,
# enabling calls to `build/<p###>`.
define problem_rules
build/$(1): $$(filter $$(BIN)/$(1)/%,$$(TARGETS))
test/$(1):  $$(filter $$(BIN)/$(1)/%,$$(TARGETS))
	@./check.sh $(1) $$^
bench/$(1): $$(filter $$(BIN)/$(1)/%,$$(TARGETS))
	@echo "--- BENCHMARKING $(1) ---"
	@$$(BENCH) $$^
	@echo
endef

$(foreach p,$(PROBLEMS),$(eval $(call problem_rules,$(p))))

# Targets for *all* problems
build/all: $(addprefix build/, $(PROBLEMS))
test/all:  $(addprefix test/,  $(PROBLEMS))
bench/all: $(addprefix bench/, $(PROBLEMS))

# Ensure that directories are made for every target build.
$(TARGETS): | $(TARGETDIRS)
$(TARGETDIRS):
	@mkdir -p $@

# --- Per-language build rules (each defined once) ---------------------

# Haskell
$(BIN)/%.hs: src/by-problem/%.hs
	@echo "--- (Haskell) Compiling $@ ---"
	@ghc -O2 -no-keep-hi-files -no-keep-o-files -o $@ $<

# Scheme (Guile/interpreted)
$(BIN)/%.scm: src/by-problem/%.scm
	@echo "--- (Guile) Linking $@ ---"
	@ln -sf "$(abspath $<)" $@
