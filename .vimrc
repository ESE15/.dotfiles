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

"" Ctrl+A / Ctrl+E 를 Home / End 처럼 동작시키기
"" Normal / Visual
"nnoremap <C-a> ^
"nnoremap <C-e> $
"vnoremap <C-a> ^
"vnoremap <C-e> $

"" Insert
"inoremap <C-a> <Home>
"inoremap <C-e> <End>



set nocompatible
set ttimeout
set ttimeoutlen=50          " ESC 시퀀스를 하나로 묶어 인식 (leak 방지의 핵심)

" ===== 물리 Home/End 키 정상화 =====
" 터미널이 보내는 두 변형(^[[H / ^[OH 등)을 모든 모드에서 <Home>/<End>로 매핑.
" '가끔 되고 가끔 안 되던' 건 vim이 insert 모드에서 application-cursor 변형(^[O*)을
" 인식 못 해서 ESC가 분리되던 문제 → 아래로 양쪽 변형을 다 잡아주면 해결됩니다.
"noremap  <Esc>[H <Home>
"noremap  <Esc>OH <Home>
"noremap  <Esc>[F <End>
"noremap  <Esc>OF <End>
"inoremap <Esc>[H <Home>
"inoremap <Esc>OH <Home>
"inoremap <Esc>[F <End>
"inoremap <Esc>OF <End>
"cnoremap <Esc>[H <Home>
"cnoremap <Esc>OH <Home>
"cnoremap <Esc>[F <End>
"cnoremap <Esc>OF <End>
" ===== Ctrl+A / Ctrl+E (insert 모드 전용) =====
" insert 모드에선 <Home>/<End>가 vim 내부 키라 escape 시퀀스를 안 거쳐 안전합니다.
" normal/visual에는 매핑하지 않습니다 → 거긴 이미 0/^/$가 있고,
" 무엇보다 normal 모드 Ctrl+A(숫자 증가) 기능을 그대로 살립니다.
"inoremap <C-a> <Home>
"inoremap <C-e> <End>
"--------------------
"

" ===== 물리 Home/End (vim 안에선 application 모드라 escape 시퀀스로 들어옴) =====
noremap  <Esc>[H <Home>
noremap  <Esc>OH <Home>
noremap  <Esc>[F <End>
noremap  <Esc>OF <End>
inoremap <Esc>[H <Home>
inoremap <Esc>OH <Home>
inoremap <Esc>[F <End>
inoremap <Esc>OF <End>
cnoremap <Esc>[H <Home>
cnoremap <Esc>OH <Home>
cnoremap <Esc>[F <End>
cnoremap <Esc>OF <End>

" ===== Ctrl+A / Ctrl+E (^A/^E로 들어오는 경우도 커버) =====
inoremap <C-a> <Home>
inoremap <C-e> <End>
nnoremap <C-a> 0
nnoremap <C-e> $
vnoremap <C-a> 0
vnoremap <C-e> $

" ===== 숫자 증가/감소 키 이전 =====
nnoremap + <C-a>
nnoremap - <C-x>

