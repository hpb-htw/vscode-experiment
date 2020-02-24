# Makefile to join every thing to dxtionary directory

# Excutatble Binaries 
DX_DB           = dxtionary-db
DXTIONARARY     = $(DX_DB)/clang-build/src/dxtionary-db
IMPORT_RAW_DICT = $(DX_DB)/clang-build/src/import-raw-dict

# XML Dump file Parser
PARSER     = de-wiktionary-parser
PARSER_SRC = $(wildcard $(PARSER)/src/*.ts)
PARSER_XML = $(PARSER)/lib/index.js
## result of PARSER
RAW_CSV_GZ   = big-file/dewiktionary.csv.gz
DICT_SQLITE  = big-file/dict.sqlite 


# Inject generated file to dxtionary or alpha-dixtionary
VS_EXTENSION     = alpha-dxtionary
## inject binaries into alpha-dxtionary/bin
BIN_FILE   = dxtionary-db import-raw-dict
BIN_DIR    = $(VS_EXTENSION)/bin
NIX        = Linux Darwin
NIX_ARCH   = x86_64
WIN        = Windows
WIN_ARCH   = AMD64
NIX_BIN    = $(foreach p, $(NIX), $(foreach b, $(BIN_FILE), $(BIN_DIR)/$(p)-$(NIX_ARCH)/$(b)     ) )
WIN_BIN    = $(foreach p, $(WIN), $(foreach b, $(BIN_FILE), $(BIN_DIR)/$(p)-$(WIN_ARCH)/$(b).exe ))
ALL_BIN    = $(NIX_BIN) $(WIN_BIN)

## inject dewiktionary.csv.gz into alpha-dxtionary/data
DATA_DIR = $(VS_EXTENSION)/data

# wiktionary-eintopf
EINTOPF      = wikinary-eintopf
EINTOPF_MAIN = $(EINTOPF)/lib/main.js
EINTOPF_SRC  = $(wildcard $(EINTOPF)/src/*.ts)


.PHONY:all
all: inject-bin inject-data eintopf


.PHONY:bin
bin:$(DXTIONARARY) $(IMPORT_RAW_DICT)

$(DXTIONARARY) $(IMPORT_RAW_DICT):
	cd $(DX_DB) ; ./clang-build.sh ; cd ..
	
.PHONY:csv
csv: $(PARSER_XML) $(RAW_CSV_GZ)

$(PARSER_XML) $(RAW_CSV_GZ): $(PARSER_SRC)
	$(MAKE) -C $(PARSER)


.PHONY:sqlite-dict
sqlite-dict: $(DICT_SQLITE)

$(DICT_SQLITE): $(IMPORT_RAW_DICT) $(RAW_CSV_GZ)
	rm -f $(DICT_SQLITE)
	$(IMPORT_RAW_DICT) $(DICT_SQLITE) $(RAW_CSV_GZ)

.PHONY:inject-bin
inject-bin:$(ALL_BIN)

$(ALL_BIN):.download-bin

.download-bin:
	@echo "========================================================"
	@echo "* Make sure to deploy project $(DX_DB) in AppVoyer *"
	@echo "========================================================"
	curl -L -o /tmp/Release.tar.gz https://github.com/hpb-htw/dxtionary-db/raw/bin/bin/Release.tar.gz
	@mkdir -p $(BIN_DIR)
	tar xfz /tmp/Release.tar.gz -C $(BIN_DIR) --strip 1
	rm -f /tmp/Release.tar.gz

.PHONY:inject-data
inject-data: $(RAW_CSV_GZ)
	@mkdir -p $(DATA_DIR)
	cp -v $(RAW_CSV_GZ) $(DATA_DIR)/

.PHONY:eintopf
eintopf: $(EINTOPF_MAIN)

$(EINTOPF_MAIN): $(EINTOPF_SRC)
	$(MAKE) -C $(EINTOPF) 



.PHONY:clean
clean:	
	rm -rfv $(BIN_DIR)
	rm -fv $(RAW_CSV_GZ)
	rm -fv $(DATA_DIR)/*
	rm -f $(DICT_SQLITE)

.PHONY:clean-all
clean-all:
	make clean
	$(MAKE) -C $(EINTOPF) clean
	$(MAKE) -C $(PARSER) clean-all
	@echo "No clean task for C++ Project"




.PHONY:debug
debug: $(ALL_BIN)







