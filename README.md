
# Lobster notes

## lobster bin

in `lobster/dev`

### build

`cmake -DCMAKE_BUILD_TYPE=Release && make -j12`

## lsp

in: `lobster/dev/lsp`

### build

npm install

### install

npm run webpack

## vscode extension

[guide](https://github.com/aardappel/lobster/tree/master/dev/vscode-ext)

### deps

in `lobster/dev/vscode-ext`

npm install -g @vscode/vsce
npm install

### build

`vsce package`

### install

`ctrl+shift+p` -> Install from VSIX
