LANGS := hs scm
BIN := .build

# Fetch all sources and targets based on the languages and existing problems
SRCS       := $(foreach lang,$(LANGS),$(wildcard src/by-problem/*/*.$(lang)))
TARGETS    := $(patsubst src/by-problem/%,$(BIN)/%,$(SRCS))
TARGETDIRS := $(sort $(dir $(TARGETS)))

BENCH := guix shell hyperfine -- hyperfine --warmup=3 --shell=none

# ── Phony targets ────────────────────────────────────────────────────
.PHONY: all bench build clean

all: $(TARGETS)

bench: $(TARGETS)
	$(BENCH) $(TARGETS)

build:
	$(TARGETS)

$(TARGETS): | $(TARGETDIRS)

$(TARGETDIRS):
	@mkdir -p $@

clean:
	rm -rf $(BIN)

# ── Per-language build rules (each defined once) ─────────────────────

# Haskell
$(BIN)/%.hs: src/by-problem/%.hs
	@echo "--- (Haskell) Compiling $@ ---"
	@ghc -O2 -no-keep-hi-files -no-keep-o-files -o $@ $<

# Scheme (Guile/interpreted)
$(BIN)/%.scm: src/by-problem/%.scm
	@echo "--- (Guile) Linking $@ ---"
	@ln -sf "$(abspath $<)" $@
