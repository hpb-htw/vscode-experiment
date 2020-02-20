# Makefile to join every thing to dxtionary directory
#
#
#

# Runtime dependency
dxtionary-db = dxtionary-db/clang-build/src/dxtionary-db

# Dictionary file generator
import-raw-dict = dxtionary-db/clang-build/src/import-raw-dict
wiktionary-dump = big-file/dewiktionary-20191020-pages-articles.xml

delimiter = '<separator>'
wikiparser = de-wiktionary-parser/lib/index.js 
# devlopment targets
dewiktionary = big-file/dewiktionary.csv.gz
dict.sqlite = big-file/dict.sqlite

# pre-release targets
# (TODO)


# rules:
#

.PHONY: all
all: $(dict.sqlite)

$(dewiktionary): $(wikiparser) $(wiktionary-dump)
	node $(wikiparser) $(wiktionary-dump) $(delimiter) | gzip -f - > $(dewiktionary)

$(dict.sqlite): $(dewiktionary) $(import-raw-dict)
	rm -f $(dict.sqlite)
	$(import-raw-dict) $(dict.sqlite) $(dewiktionary)


