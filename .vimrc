syntax on
set nowrap
colorscheme darkblue
set autoindent
set modifiable
set expandtab
set softtabstop=4
set tabstop=4
set shiftwidth=4
set ignorecase
set incsearch
set hlsearch
set clipboard=unnamed
set showmatch
set number
set laststatus=2
set statusline=%t\ (%n)\ %r%m%=\ %c\ \ \ \ %l\/%L
set guioptions-=T
set guioptions-=m
set hidden
set paste
"set ruler
"lang ctype Russian_Russia.1251

nmap <F1> :TagExplorer<CR>
imap <F1> <Esc>:TagExplorer<CR>

nmap <F2> :Hexmode<CR>
imap <F2> <Esc>:Hexmode<CR>
vnoremap <F2> :<C-U>Hexmode<CR>

nmap <F4> :e!<CR>G
imap <F4> <Esc>:e!<CR>G

nmap <F5> :set encoding=UTF8<CR>:set syntax=xml<CR>:1,$!xmllint --format --recover --encode UTF-8 - 2>/dev/null<CR>
imap <F5> <Esc>:set encoding=UTF8<CR>:set syntax=xml<CR>:1,$!xmllint --format --recover --encode UTF-8 - 2>/dev/null<CR>

nmap <F7> <C-W>k<C-W>_
imap <F7> <Esc><C-W>k<C-W>_a

nmap <F8> <C-W>j<C-W>_
imap <F8> <Esc><C-W>j<C-W>_a

nmap <F12> :let Tlist_Show_One_File=1<CR>:TlistOpen<CR>
imap <F12> <Esc>:let Tlist_Show_One_File=1<CR>:TlistOpen<CR>


nmap Bl :buffers<CR>:buffer  
nmap Bp :MBEbp<CR>  
nmap Bn :MBEbn<CR>  
nmap Bd :call Kwbd(1)<CR> 
nmap K i<CR><ESC>
nmap gc <C-]> 
nmap ff *
vmap > >gv
vmap < <gv

nmap <C-b> :tselect <C-R><C-W><CR>
imap <C-b> <ESC>:tselect<C-R><C-W><CR>

"nmap <S-t> :!translate <cWORD><CR>
"imap <S-t> <ESC>:!translate <cWORD><CR>

map <C-space> <C-n>
map! <C-space> <C-n>
map <C-S-space> <C-p>
map! <C-S-space> <C-p>

vmap <C-c> "+yi
vmap <C-x> "+c
vmap <C-v> c<ESC>"+p
imap <C-v> <ESC>"+pa

inoremap <C-\> \c 
vmap <C-\> \c 

nnoremap <C-m> :let Tlist_Show_One_File=0<CR>:TlistOpen<CR>
nnoremap ys :let @*=@/<CR>

highlight Comment ctermfg=darkgreen

let Tlist_Use_Right_Window=1
let Tlist_Close_On_Select=1
let Tlist_Exit_Only_Window=1
"let Tlist_Show_One_File=1
let Tlist_Sort_Type='name'
let Tlist_File_Fold_Auto_Close=1

let g:miniBufExplMapWindowNavVim = 1
let g:miniBufExplMapWindowNavArrows = 1
let g:miniBufExplMapCTabSwitchBufs = 1
let g:miniBufExplModSelTarget = 1 
"let g:miniBufExplForceSyntaxEnable = 1
let g:miniBufExplorerMoreThanOne = 1

let TE_Exclude_Dir_Pattern = '\.svn\|\.cvs'
let TE_Exclude_File_Pattern = '\.classpath\|\.project\|.iml\|.ipr\|.iws'
let TE_Adjust_Winwidth=20

let g:EnhCommentifyMultiPartBlocks = 'yes' 

function Kwbd(kwbdStage)
    if(a:kwbdStage == 1)
        let g:kwbdBufNum = bufnr("%")
        let g:kwbdWinNum = winnr()
        windo call Kwbd(2)
        execute "bd! " . g:kwbdBufNum
        execute "normal " . g:kwbdWinNum . ""
    else
        if(bufnr("%") == g:kwbdBufNum)
            let prevbufvar = bufnr("#")
            if(prevbufvar > 0 && buflisted(prevbufvar) && prevbufvar != g:kwbdBufNum)
                b #
            else
                bn
            endif
        endif
    endif
endfunction

set diffexpr=MyDiff()
function MyDiff()
  let opt = '-a --binary '
  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  let arg1 = v:fname_in
  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  let arg2 = v:fname_new
  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  let arg3 = v:fname_out
  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  if &sh =~ '\<cmd'
    silent execute '!""C:\Program Files\Vim\vim63\diff" ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . '"'
  else
    silent execute '!C:\Program" Files\Vim\vim63\diff" ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3
  endif
endfunction
\

silent! call repeat#set("\<Plug>MyWonderfulMap",v:count) 

" {{{ Locale settings
" if we have BOM => this is BOM
if &fileencodings !~? "ucs-bom"
	set fileencodings^=ucs-bom
endif
if &fileencodings !~? "utf-8"
	let g:added_fenc_utf8 = 1
	set fileencodings+=utf-8
endif
if &fileencodings !~? "default"
	set fileencodins+=default
endif
" }}}

command -bar Hexmode call ToggleHex()

" helper function to toggle hex mode
function ToggleHex()
  " hex mode should be considered a read-only operation
  " save values for modified and read-only for restoration later,
  " and clear the read-only flag for now
  let l:modified=&mod
  let l:oldreadonly=&readonly
  let &readonly=0
  let l:oldmodifiable=&modifiable
  let &modifiable=1
  if !exists("b:editHex") || !b:editHex
    " save old options
    let b:oldft=&ft
    let b:oldbin=&bin
    " set new options
    setlocal binary " make sure it overrides any textwidth, etc.
    let &ft="xxd"
    " set status
    let b:editHex=1
    " switch to hex editor
    %!xxd
  else
    " restore old options
    let &ft=b:oldft
    if !b:oldbin
      setlocal nobinary
    endif
    " set status
    let b:editHex=0
    " return to normal editing
    %!xxd -r
  endif
  " restore values for modified and read only state
  let &mod=l:modified
  let &readonly=l:oldreadonly
  let &modifiable=l:oldmodifiable
endfunction

:command -range Cz :silent :<line1>,<line2>w !xsel -i -b
:command -range Cx :silent :<line1>,<line2>w !xsel -i -p
:command -range Cv :silent :<line1>,<line2>w !xsel -i -s
:cabbrev cv Cv
:cabbrev cz Cz
:cabbrev cx Cx

:command -range Pz :silent :r !xsel -o -b
:command -range Px :silent :r !xsel -o -p
:command -range Pv :silent :r !xsel -o -s

:cabbrev pz Pz
:cabbrev px Px
:cabbrev pv Pv
