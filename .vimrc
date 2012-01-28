syntax on
"set background=light
"let g:solarized_termcolors=256
colorscheme wombat256
set number
set smartindent
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
"set textwidth=79
filetype plugin on
let NERDTreeWinPos='right'
"let NERDTreeQuitOnOpen=1
autocmd VimEnter * MiniBufExplorer
autocmd VimEnter * NERDTreeToggle
autocmd VimEnter * wincmd p
map BN :bn!<CR>
let Tlist_Auto_Open=1
map BP :bp!<CR>
set gfn=Inconsolata\ 10
