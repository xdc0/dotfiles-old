syntax on
set background=dark
let g:solarized_termcolors=256
set number
set smartindent
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set textwidth=79
filetype plugin on
let NERDTreeWinPos='right'
let NERDTreeQuitOnOpen=1
autocmd VimEnter * MiniBufExplorer
autocmd VimEnter * wincmd p
map BN :bn!<CR>
let Tlist_Auto_Open=1
map BP :bp!<CR>
