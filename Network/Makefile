OBJ := $(patsubst %.s,%.o,$(notdir $(shell find . -name \*.s)))

NASMFLAGS=-f elf
INCLUDE=-I ../Macros/

all: $(OBJ)

%.o: %.s
	nasm $(NASMFLAGS) $(INCLUDE) -o $@ $^

clean:
	rm -f $(OBJ)

.PHONY: all clean
