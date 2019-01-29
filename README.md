# kwbd
keep window buffer delete

## install
any package manager should do.
i use [vim-plug](https://github.com/junegunn/vim-plug).

```vim
call plug#begin()
Plug 'thekelvinliu/kwbd'
call plug#end()
```

## usage info
this plugin assumes `set hidden`.
currently, modified buffers will be closed **without confirmation**.

it can be invoked either via ex command:

```vim
:KWBD
```

or a plug mapping:

```vim
nmap <leader>a <plug>(kwbd)
```

# about
use this if you don't want a buffer's containing window to close when it is deleted.
there are already tons of scripts out there do this,
and this is mine.
based on [this](http://vim.wikia.com/wiki/Deleting_a_buffer_without_closing_the_window#Alternative_Script) vim tips wiki article.
