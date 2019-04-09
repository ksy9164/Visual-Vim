set hlsearch " 검색어 하이라이팅
set nu " 줄번호
set autoindent " 자동 들여쓰기
set scrolloff=2
set wildmode=longest,list
set ts=4 "tag select
set sts=4 "st select
set sw=1 " 스크롤바 너비
set autowrite " 다른 파일로 넘어갈 때 자동 저장
set autoread " 작업 중인 파일 외부에서 변경됬을 경우 자동으로 불러옴
set cindent " C언어 자동 들여쓰기
set bs=eol,start,indent
set history=256
set laststatus=2 " 상태바 표시 항상
set shiftwidth=4 " 자동 들여쓰기 너비 설정
set showmatch " 일치하는 괄호 하이라이팅
set smartcase " 검색시 대소문자 구별
set smarttab
set smartindent
set expandtab
set softtabstop=4
set tabstop=4
set ruler " 현재 커서 위치 표시
set incsearch
set statusline=\ %<%l:%v\ [%P]%=%a\ %h%m%r\ %F\
set tags=./tags,/usr/src/linux/tags,/usr/include/tags
set cst
set csto=0
set encoding=utf-8
set fileencodings=utf-8,cp949

"C, C++ Linux coding style
" autocmd FileType c setlocal ts=8  shiftwidth=8 softtabstop=8 tabstop=8
" autocmd FileType cpp setlocal ts=8  shiftwidth=8 softtabstop=8 tabstop=8

if filereadable("./cscope.out")
	cs add ./cscope.out
else
	cs add ~/cscope.out
endif

function! LoadCscope()
  let db = findfile("cscope.out", ".;")
  if (!empty(db))
    let path = strpart(db, 0, match(db, "/cscope.out$"))
    set nocscopeverbose " suppress 'duplicate connection' error
    exe "cs add " . db . " " . path
    set cscopeverbose
  " else add the database pointed to by environment variable 
  elseif $CSCOPE_DB != "" 
    cs add $CSCOPE_DB
  endif
endfunction
au BufEnter /* call LoadCscope()


	if has("syntax")
	syntax on
	endif
 
	set wrap
	set nowrapscan
	set fencs=ucs-bom,utf-8,euc-kr.latin1
	set fileencoding=euc-kr
	set nobackup
	set encoding=utf-8
 
	let Tlist_Use_Right_Window=1
 
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
	map ,w :bw<CR>
 
	syntax on
	set ai
	set si
	set tabstop=4
	set hlsearch
	set bg=dark
	set ts=4
	au Bufenter *.\(c\|cpp\|h\|sh\|pl\|php\|html\) set et
 
	"--------------"
	"ctags database path
	"--------------"
	"set tags=./tags,tags;/
 
	"---------------------"
	"cscope database path"
	"---------------------"
	set csprg=/usr/bin/cscope
	set csto=0
	set cst
	set nocsverb
 
	"--------------
	"cscope DB path
	"--------------
	if filereadable("./cscope.out")
	cs add cscope.out
	else
	cs add /usr/src/linux/cscope.out
	endif
	set csverb
 
	"-----------------------
	"Tag list Configuration
	"-----------------------
	filetype on
	nmap <F9> :TlistToggle<CR>
	"let Tlist_Ctags_Cmd = '/usr/bin/ctags'
	let Tlist_Inc_Winwidth = 0
	let Tlist_Exit_OnlyWindow = 1
	let Tlist_Display_Tag_Scope = 1
	let Tlist_Auto_Open = 1
	let Tlist_Use_Right_Window = 1

	nmap <C-H> <C-W>h
	nmap <C-J> <C-W>j
	nmap <C-K> <C-W>k
	nmap <C-L> <C-W>l
 
	let g:SrcExpl_winHeight = 8
	let g:SrcExpl_refreshTime = 100
	let g:SrcExpl_jumpKey = '<ENTER>'
	let g:SrcExpl_gobackKey = '<SPACE>'
	let g:SrcExpl_isUpdateTags = 0
 
	"-------------------------------
	"NERD Tree Configuration Setting
	"-------------------------------
	
	let NERDTreeWinPos = 'left'
	nmap <F7> :NERDTreeToggle<CR>
	"NERD Tree Auto open
	" autocmd VimEnter * NERDTree | wincmd p
	
	" au WinEnter * call NoExcitingBuffersLeft()

	"auto close only NERD Tree"
	function! s:CloseIfOnlyControlWinLeft()
	  if winnr("$") != 1
		return
	  endif
	  if (exists("t:NERDTreeBufName") && bufwinnr(t:NERDTreeBufName) != -1)
			\ || &buftype == 'quickfix'
		q
	  endif
	endfunction
	augroup CloseIfOnlyControlWinLeft
	  au!
	  au BufEnter * call s:CloseIfOnlyControlWinLeft()
	augroup END
	"============== CSCOPE ==============
 
func! Sts()
	let st = expand("<cword>")
	exe "sts ".st
	endfunc
	nmap    ,st :call Sts()<cr>
 
func! Tj()
	let st = expand("<cword>")
	exe "tj ".st
	endfunc
	nmap    ,tj :call Tj()<cr>
 
func! Css()
	let css = expand("<cword>")
	exe "cs find s ".css
	if getline(1)==" "
	exe "q!"
	endif
	endfunc
	nmap    ,css :call Css()<cr>
 
func! Csd()
	let csd = expand("<cword>")
	exe "cs find d ".csd
	if getline(1)==" "
	exe "q!"
	endif
	endfunc
	nmap    ,csd :call Csd()<cr>
 
func! Csc()
	let csc = expand("<cword>")
	exe "cs find c ".csc
	if getline(1)==" "
	exe "q!"
	endif
	endfunc
	nmap    ,csc :call Csc()<cr>
 
func! Csg()
	let csg = expand("<cword>")
	exe "cs find g ".csg
	if getline(1)==" "
	exe "q!"
	endif
	endfunc
	nmap    ,csg :call Csg()<cr>
 
func! Man()
	let sm = expand("<cword>")
	exe "!man -S 2:3:4:5:6:7:8:9:tc1:n:l:p:o ".sm
	endfunc
	nmap    ,ma :call Man()<cr>
 
func! CPMan()
	let sm = expand("<cword>")
	exe "!man -S 2:3:4:5:6:7:8:9:tc1:n:l:p:o std::".sm
	endfunc
	nmap    ,k :call CPMan()<cr>
	"============== 주석 매크로 ==============
 
	func! CmtOn()    "주석 on
	exe "'<,'>norm i//"
	endfunc
 
 
	func! CmtOff()    "주석 off
	exe "'<,'>norm 2x"
endfunc
 
 
vmap <c-c> <esc>:call CmtOn() <cr>
vmap <c-x> <esc>:call CmtOff() <cr>
nmap <c-c> <esc>v:call CmtOn() <cr>\
nmap <c-x> <esc>v:call CmtOff() <cr>
 
set clipboard=unnamed
nnoremap <F3> "+y
nnoremap <F4> "+gP
vnoremap <F3> "+y
vnoremap <F4> "+gP
inoremap <F3> <esc>"+Yi 
inoremap <F4> <esc>"-gPa
nnoremap <F5> :bprevious!<Enter>
nnoremap <F6> :bnext!<Enter>
nnoremap <F8> :bp <BAR> bd! #<Enter>
 
au BufNewFile,BufRead *.cu set ft=cuda
au BufNewFile,BufRead *.cuh set ft=cuda

set nocompatible              " be iMproved, required
filetype off                  " required


let g:autoclose_vim_commentmode = 1

" 버퍼 목록 켜기
let g:airline#extensions#tabline#enabled = 1

" 파일명만 출력
let g:airline#extensions#tabline#fnamemod = ':t'

let g:airline#extensions#tabline#buffer_nr_format = '%s:' " buffer number format
set hidden
" 모든 버퍼와 각 버퍼 상태 출력
nmap <leader>bl :ls<CR>
let g:airline#extensions#tabline#buffer_nr_show = 1       " buffer number를 보여준다

"Vundle
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim

call vundle#begin()
" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
" vim-airline
Plugin 'vim-airline/vim-airline'
"taglist
Plugin 'taglist-plus'
"Nerd Tree
Plugin 'The-NERD-Tree'
"Cscope
Plugin 'ronakg/quickr-cscope.vim'
"Syntastic
Plugin 'scrooloose/syntastic'
"Git Gutter
Plugin 'airblade/vim-gitgutter'
"Git wrapping
Plugin 'tpope/vim-fugitive'
"High writing
Plugin 'kchmck/vim-coffee-script'
"Auto make
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'
"Commenter
Plugin 'scrooloose/nerdcommenter'
call vundle#end()            " required

filetype plugin indent on    " required

" vim remeber last point
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
    endif

syntax on

" Syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
 
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

let g:syntastic_loc_list_height=5 
let g:syntastic_cpp_compiler = 'g++'
let g:syntastic_cpp_compiler_options = "-std=c++11 -Wall -Wextra -Wpedantic"
let g:syntastic_c_compiler_options = "-std=c11 -Wall -Wextra -Wpedantic"
nnoremap <F10> :SyntasticCheck<CR> :SyntasticToggleMode<CR> :w<CR>

set mouse=n
set ttymouse=xterm2

" NERD Commenter
" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1
" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1
" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'
" Set a language to use its alternate delimiters by default
let g:NERDAltDelims_java = 1
" Add your own custom formats or override the defaults
let g:NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' } }
" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1
" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1
" customize keymapping
map <Leader>cc <plug>NERDComToggleComment
map <Leader>c<space> <plug>NERDComComment

