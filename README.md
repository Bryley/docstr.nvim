
# docstr.nvim

docstr.nvim is a simple plugin for neovim that auto generates documentation for functions.

## Languages

- [ ] Python
    - [X] numpy
    - [ ] google
    - ...
- [ ] LUA
- [ ] Javascript
- [ ] Typescript
- [ ] C
- [ ] C++
- [ ] Java
- ...

## Requirements

Neovim 0.6 and Treesitter

## Setup

This setup is optional, the plugin will still work with default configs if the setup function is not called.

```lua
require("docstr").setup({
    indent_key = '>',
    down_key = 'j',
    visual_mode = "v",
    templates = {
        python = {
            default = "numpy",
            numpy = {
                place_above = false,
                indent = 1,
                content = require("src.templates.python.numpy")
            }
        }
    }
})
```

## Configs

### `indent_key`

This is the key(s) that are pressed to indent text in vim (By default it is '>' if you havn't reconfigured it)

### `down_key`

This is the key(s) that are pressed to move down in vim (By default it is 'j' if you havn't reconfigued it)

### `visual_mode`

This is the key(s) that are pressed to go into visual mode in vim (By default it is 'v' if you havn't reconfigued it)

### `templates`

This is where you can create your own templates. Each key in this table coresponds to a filetype.

If you are unsure about what filetype you have type in `:lua print(vim.bo.filetype)` while editing the file to see.

Within each filetype there must be a `default` parameter to specify the default template for the filetype. The rest of the keys are the templates.

Each template has 3 options to set:

- `place_above` : If the docstr should be placed above the function declaration
- `indent`      : How many indents should the docstr have.
- `content`     : A function that will be called with 3 parameters: `(function_name, parameters, return_type)`

The `content` option will return a table list of each lines it should insert (for examples check `lua/src/templates`).


## Usage

Once in a file to generate a docstring for the function your cursor is in, simply type:

`:lua require'docstr'.docstr('numpy')`

This will generate the docstring for the tempalte 'numpy' (note if it is left out then it will go with the default specified in the config).

# Editors Notes:

Any ideas for this plugin let me know!

For quick testing:
`vim --cmd "set rtp+=/home/bryley/Documents/coding/lua/nvim-plugins/docstr.nvim" app.py`

TODO:
[ ] Use regex to read current comment so that it doesn't create new ones
