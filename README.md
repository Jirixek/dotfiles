# Dotfiles

My config files.
I'm in currently state that I'm experimenting and as a result constantly change these.
However, I think you can get inspiration from some of these.

## For CTU students

There are a few interesting paths for you:

### .local/share/Anki2/addons21/

This is the folder with Anki addons I'm currently using.

### .local/bin/

This is place for scripts. **g++.sh** will be most interesting to you.
It's a wrapper around g++, but with progtest flags and memory debugger enabled.
You can also provide folder with tests in format: **_in.txt* files as input and **_ref.txt* as reference.
To compile file automatically when changed, use `entr -c g++.sh -x <<<"$compileFile"`.

## Filters

Local git filters I use in order to exclude volatile stuff in config files.

```[bash]
dfl config filter.okularpartrc.clean "sed -e '/^BuiltinAnnotationTools.*/d' -e '/^QuickAnnotationTools.*/d'"
dfl config filter.pkglist.clean "sed '/^linux-custom.*/d'"
```
