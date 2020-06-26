#################
# Configuration #
#################

# Assembleur options
ASSEMBLER=wla-gb
LINKER=wlalink
AFLAGS=
LFLAGS=-d -v -s

#Emulator
EMULATOR=vbam#visualboyadvance-m
EFLAGS=

# Folders
SRC=src
BIN=bin
INCLUDE=src ##TODO : separate include from SRC (read wla doc)
INSTALL="/media/B009-9376/1 Game Boy/5 Team Rocket"

# Files
TARGET=rocket
SOURCE_FILES = \
	main.s

##############
# Directives #
##############
OBJECT_FILES = $(SOURCE_FILES:%.s=$(BIN)/%.o)
TARGET_FILE = $(BIN)/$(TARGET).gb
LINK_FILE = $(BIN)/linkfile

all: clean directories $(TARGET_FILE)

run: all
	$(EMULATOR) $(EFLAGS)$(TARGET_FILE)

install: all
	cp $(TARGET_FILE) $(INSTALL)


clean:
	rm -rf $(BIN)

directories:
	@mkdir -p $(BIN)

.PHONY: build clean directories

$(TARGET_FILE): $(OBJECT_FILES) $(LINK_FILE)
	echo "Building $(OBJECT_FILES)"
	$(LINKER) $(LFLAGS) -r $(LINK_FILE) $(TARGET_FILE)

$(BIN)/%.o: $(SRC)/%.s
	$(ASSEMBLER) $(AFLAGS) -I $(INCLUDE) -o $@ $<

$(LINK_FILE):
	echo "[objects]" > $(LINK_FILE)
	printf "%s\n" $(OBJECT_FILES) >> $(LINK_FILE)
