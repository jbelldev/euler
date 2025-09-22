BENCHMARK ?= hyperfine
SOLUTIONS := $(wildcard p001.*)

.PHONY: all
.DEFAULT: all

all: $(SOLUTIONS)
	$(BENCHMARK) $(foreach file, $^, $(addprefix ./, $(file)))
