syntax on
set number
set smartindent
set tabstop=4
set shiftwidth=4
set expandtab
filetype plugin on
let NERDTreeWinPos='right'
let NERDTreeQuitOnOpen=1
autocmd VimEnter * MiniBufExplorer
autocmd VimEnter * wincmd p
map BN :bn!<CR>
let Tlist_Auto_Open=1
map BP :bp!<CR>
