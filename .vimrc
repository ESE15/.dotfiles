" General
set encoding=utf-8
set fileencoding=utf-8
set nocompatible
set textwidth=120
set scrolloff=3
set startofline
set number
set backspace=indent,eol,start
set autoread
set nowrap
set noswapfile
set nobackup
set ruler
" Tab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set smarttab
set expandtab

" Indent
set cindent
set autoindent
set smartindent

" Search
set ignorecase
set smartcase
set hlsearch
set incsearch
set nowrapscan

" Pair matching
set matchpairs+=<:>
set showmatch

" Vim plugins
call plug#begin('~/.vim/plugged')

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'editorconfig/editorconfig-vim'

Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'airblade/vim-gitgutter'

Plug 'pangloss/vim-javascript'
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'styled-components/vim-styled-components'

Plug 'vim-airline/vim-airline'

call plug#end()

" set *.tsx filetypes as typescriptreact
autocmd BufNewFile,BufRead *.tsx,*.jsx set filetype=typescriptreact

" dark red
execute 'hi tsxTagName ctermfg=168'
hi link tsxComponentName tsxTagName
execute 'hi tsxCloseTagName ctermfg=174'
hi link tsxCloseComponentName tsxCloseTagName

" orange
execute 'hi tsxCloseString ctermfg=210'
execute 'hi tsxTag ctermfg=210'
execute 'hi tsxCloseTag ctermfg=216'
execute 'hi tsxAttributeBraces ctermfg=210'
execute 'hi tsxEqual ctermfg=210'

" yellow
execute printf('hi tsxAttrib ctermfg=216')
