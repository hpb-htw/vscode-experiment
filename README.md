# Architecture Description

## Tasks and project-directories


S. Calc file `Task-in-project.ods`

## Release Build

These projects must be built in the following order. The variable
`TOP_LEVEL` points to the parent directory of this file.

### Project `dxtionary-db`


```
cd $TOP_LEVEL/dxtionary-db
# use clang compiler or gcc compiler as below
./clang-build.sh
cd clang-build; cmake --build .

# GCC like this:
# ./gcc-build.sh
# cd gcc-build; cmake --build .
```

### Project `de-wiktionary-parser`

```
cd $TOP_LEVEL/de-wiktionary-parser
npm run compile

```

### Project `wikinary-eintopf`

```
cd $TOP_LEVEL
make all
cd wikinary-eintopf
npm run compile
```


### Project `dxtionary`
(TODO)


## Debugs


