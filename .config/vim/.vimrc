"" General parameters
let mapleader = " "
syntax on

set noerrorbells
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
set number
set nowrap
set smartcase
set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile
set incsearch
set list
set listchars=tab:>-,trail:~,extends:>,precedes:<


"" Plugins
call plug#begin('~/.vim/plugged')

Plug 'itchyny/lightline.vim'
Plug 'morhetz/gruvbox'
Plug 'scrooloose/nerdtree'
Plug 'mbbill/undotree'

call plug#end()


"" Plugins settings

" `lightline`
set laststatus=2

" `gruvbox`
colorscheme gruvbox
set background=dark

" `nerdtree`
map <C-n> :NERDTreeToggle<CR>

" `undotree`
nnoremap <leader>u :UndotreeToggle<CR>
nnoremap <leader>uf :UndotreeFocus<CR>

"" Other

" Disable arrow keys
map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>
imap <up> <nop>
imap <down> <nop>
imap <left> <nop>
imap <right> <nop>

" Basic movement
nnoremap <leader>h :wincmd h<CR>
nnoremap <leader>j :wincmd j<CR>
nnoremap <leader>k :wincmd k<CR>
nnoremap <leader>l :wincmd l<CR>

