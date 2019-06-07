This vim plugin automatically adds license header from repo root,
when you have [`LICENSE` file](https://github.com/g4s8/vim-licenser/blob/master/LICENSE)
(or `LICENSE.txt`) and create new file with `vim`
this plugin will transform license text into comment header and put it at the beginning
of the new file like here: https://github.com/g4s8/vim-licenser/blob/5ebf741e17e9ceb5045a7cac3b453397e843040a/plugin/licenser.vim#L1-L22

You may configure this plugin but it's not required, just install it with
any plugin management tool in you `.vimrc`, e.g.:
```vim
Plug 'g4s8/vim-licenser'
```
that's all.
