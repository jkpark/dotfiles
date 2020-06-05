" 2019-12-04    jkpark (https://jkpark.github.io)
silent! if plug#begin('~/.vim/plugged')

let $GIT_SSL_NO_VERIFY = 'true'

Plug 'junegunn/seoul256.vim'
"Plug 'junegunn/goyo.vim'
"Plug 'junegunn/limelight.vim'
Plug 'junegunn/fzf', { 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'AndrewRadev/splitjoin.vim'
"let g:undotree_WindowLayout = 2
Plug 'Yggdroot/indentLine'
Plug 'scrooloose/nerdcommenter'
"Plug 'neoclide/coc.nvim', {'do': { -> coc#util#install() }}
Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
let g:airline#extensions#tabline#enabled = 1 " turn on buffer list
let g:airline_theme='hybrid'

Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
"close vim if only NERDTree open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
Plug 'ryanoasis/vim-devicons'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'majutsushi/tagbar'
let g:tagbar_sort = 0
Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }

" Lint
Plug 'w0rp/ale'
let g:ale_sign_column_always = 1

" git diff in the left side of window
Plug 'airblade/vim-gitgutter'

Plug 'haya14busa/incsearch.vim'
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)

call plug#end()
endif

" ====================
" General
" ====================
if !has('gui_running')
    set t_Co=256
endif

" Interface Options
colorscheme seoul256
set number                  " display line numbers on the left
"set lines=50 columns=120   " console mode
set laststatus=2            " Always display the status bar
set ruler                   " Always show cursor position
set wildmenu                " Display tab completions as a menu
set wildmode=full           " Complete the next full match
set wildignore=.swp         " Ignore file matching
set cursorline              " Highlight the line currently under cursor.
"set visualbell             " refresh screen if press wrong key
"set mouse=a                " enable mouse click to move cursor

" Text Rendering Options
set fencs=utf-8,euc-kr,cp949,cp932,big5,latin1,urs-2le,shift-jis,euc-jp
"set encoding=utf-8
"set fileencoding=utf-8
set scrolloff=5             " the number of lines to keep above and below the cursor
set sidescrolloff=5         " the number of columns to keep left and right of the cursor

" Indention Options
set autoindent              " new lines inherit the dentation of prev lines.
set cindent
"set expandtab              " convert tabs to spaces
set tabstop=4               " tab space
set shiftwidth=4            " Shift Width

" Search Options
set hlsearch                " highlighe searching  word
set ignorecase              " ignore case when searching
set nowrapscan              " no loop when searching
set sm                      " show matches

" Performance Options
set lazyredraw              " not be redrawn while executing macros and scripts
set complete-=i             " Limit files searched for auto-completes

" Others Options
"set nobackup                " no backup
"set backupdir=/tmp/vim/
"set dir=~/.cache/vim/
set backspace=eol,start,indent " backspace continue
"set spell                   " enable spell check
filetype plugin on

"write as root
cmap w!! w !sudo tee > /dev/null %

" ----- 80 chars/line -----
"set textwidth=0
"if exists('&colorcolumn')
"  set colorcolumn=80
"endif

" ====================
" Mappings
" ====================
" Moving lines
nnoremap <silent> <C-k> :move-2<cr>
nnoremap <silent> <C-j> :move+<cr>
nnoremap <silent> <C-h> <<
nnoremap <silent> <C-l> >>

" Movement in insert mode
inoremap <C-l> <C-o>a
inoremap <C-j> <C-o>j
inoremap <C-k> <C-o>k
" many terminals emit a <C-h>(0x08) key when you press <backspace>,
" remap this key cause backspace not to work
"inoremap <C-h> <C-o>h 

" qq to record, Q to replay
nnoremap Q @q


" Windows style select all
nnoremap <C-a> gg<S-v>G

" Buffers navigation
map ,1 :b!1<CR>
map ,2 :b!2<CR>
map ,3 :b!3<CR>
map ,4 :b!4<CR>
map ,5 :b!5<CR>
map ,6 :b!6<CR>
map ,7 :b!7<CR>
map ,8 :b!8<CR>
map ,9 :b!9<CR>
map ,0 :b!0<CR>
map ,w :bw<CR>            " remove current bufferfile
nmap [b :bprev<CR>
nmap ]b :bnext<CR>
nmap <tab> :bprev<CR>
nmap <S-tab> :bnext<CR>

" Windows navigation
"nnoremap <tab>   <c-w>w
"nnoremap <S-tab> <c-w>W

nmap ,v :vertical resize +5<CR>

nmap <F1> :NERDTreeToggle<cr>
nmap <F2> :TagbarToggle<CR>
nmap <F3> :UndotreeToggle<CR>
nmap <F4> :FZF<CR>

"map <F5> :!%<
"map <f6> :w<CR>:!gcc -W -Wall % -o %<<CR>
"map <F7> :!clear<CR>:w<CR>:make<CR>
"map <F8>

au BufWinEnter *.c
			\ nmap <F9> :!ctags -R --c-kinds=+p --fields=+iaS --extra=+q -f.tags_cpp<CR>
au BufWinEnter *.cpp
			\ nmap <F9> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q -f.tags_cpp<CR>
au BufWinEnter *.java
			\ nmap <F9> :!ctags -R --java-kinds=+l --fields=+iaS --extra=+q -f.tags_java<CR>

map <F10> <C-]>                         " tag search
map <F11> <C-T>                         " tag go back
"map <F12>

nmap <PageUp> <C-B>
nmap <PageDown> <C-F>

" ====================
" Ctags
" ====================
set tags=tags,.tags

" Filetype specific tag files (This is used for global IDE tags)
autocmd FileType c              set tags+=.tags_cpp,$HOME/.vim/tags/cpp
autocmd FileType cpp            set tags+=.tags_cpp,$HOME/.vim/tags/cpp
autocmd FileType css            set tags+=.tags_css,$HOME/.vim/tags/css
autocmd FileType java           set tags+=.tags_java,$HOME/.vim/tags/java
autocmd FileType javascript     set tags+=.tags_js,$HOME/.vim/tags/js
autocmd FileType html           set tags+=.tags_html,$HOME/.vim/tags/html
autocmd FileType php            set tags+=.tags_php,$HOME/.vim/tags/php
autocmd FileType sh             set tags+=.tags_sh,$HOME/.vim/tags/sh

" ====================
" Plugins
" ====================
" --------------------
" splitjoin
" --------------------
let g:splitjoin_split_mapping = ''
let g:splitjoin_join_mapping = ''
nnoremap gss :SplitjoinSplit<cr>
nnoremap gsj :SplitjoinJoin<cr>

" --------------------
" coc.vim 
" --------------------
" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
			\ pumvisible() ? "\<C-n>" :
			\ <SID>check_back_space() ? "\<TAB>" :
			\ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
	let col = col('.') - 1
	return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

