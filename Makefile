#################
# Configuration #
#################

# Assembleur options
ASSEMBLER=./wla-dx/build/binaries/wla-gb
LINKER=./wla-dx/build/binaries/wlalink
AFLAGS=
LFLAGS=-d -v -s

#Emulator
EMULATOR=mgba-qt
EFLAGS=#-f 17 

# Folders
SRC=src
BIN=bin
INCLUDE=src ##TODO : separate include from SRC (read wla doc)
INSTALL="${HOME}/mnt/0043-D7F0/Game Boy/rocket.gb"

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
