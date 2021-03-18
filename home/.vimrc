"""" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""" ~/.vimrc
""""
"""" Vim on Debian ( Linux / WLS )
""""
"""" NOTE: Ensure text files have linux line endings ( :w ++ff=unix )
""""       dos2unix <file to convert>
"""" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""" Get default settings.

source $VIMRUNTIME/defaults.vim
if has( "vms" )
    set nobackup    ""do not keep a backup file, use versions instead
endif

if &t_Co > 2 || has( "gui_running" )
    """" Switch on highlighting the last used search pattern.
    set hlsearch
endif

"""" Add optional packages.
"""" The matchit plugin makes the % command work better,
"""" but it is not backwards compatible.
if has( 'syntax' ) && has( 'eval' )
    packadd matchit
endif

"" Blue color scheme
"" :colorscheme [space] [Ctrl-d]
"colorscheme blue
"colorscheme gruvbox

"" Syntax highlighting
syntax on

"""" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""" set temp swap files in a custom dir
"""" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""" Set swapfile cache

silent !mkdir ~/.backup/ > /dev/null 2>&1
silent !mkdir ~/.swp/ > /dev/null 2>&1
silent !mkdir ~/.undo/ > /dev/null 2>&1

set backupdir=.backup/,~/.backup/,/tmp//
set directory=.swp/,~/.swp/,/tmp//
set undodir=.undo/,~/.undo/,/tmp//
"""" Prevent automatic backup files
"set nobackup

if v:progname =~? "evim"
    finish
endif

"""" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""" Automatically display line numbers
"""" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set number
set linebreak
set autoindent

"""" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""" Indent fold presets
"""" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""" za   toggles fold
"""" zM   fold all
"""" zR   unfold all
"""" xo   open fold

set foldmethod=manual
"set foldmethod=indent
"set foldmethod=syntax
"set foldnestmax=10
"set foldlevel=2

"set nofoldenable

"""" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""" Tabs
"""" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""" Use 4 spaces for tabs
set tabstop=4
set shiftwidth=4
set expandtab
set smarttab

"""" "" Unicode Decoration
"""" Ctrl+v u2002 for a "blank space"
"""" u21D2  ⇒  Rightwards Double Arrow
"""" u21E2  ⇢  Rightwards Dashed Arrow
"""" u21A6  ↦  Rightwards Arrow From Bar
"""" u2192  →  Rightwards Arrow
"""" u21E5  ⇥  Rightwards Arrow To Bar
"""" u21E8  ⇨  Rightwards White Arrow
"""" u21F0  ⇰  Rightwards White Arrow From Wall
"""" u21FE  ⇾  Rightwards Open-Headed Arrow
"""" u21F6  ⇶  Three Rightwards Arrows
"""" u25B6  ▶  BLACK RIGHT-POINTING TRIANGLE
"""" u2506  ┆  Box Drawings Light Triple Dash Vertical
"""" u2507  ┇  Box Drawings Heavy Triple Dash Vertical
"""" u250A  ┊  Box Drawings Light Quadruple Dash Vertical
"""" u250B  ┋  Box Drawings Heavy Quadruple Dash Vertical
"""" u00B7  ·  Middle Dot

"set listchars=tab:\|\
"set listchars=tab:\┊ 
set listchars=tab:\┊·
set list

"""" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""" Long line markers
"""" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set colorcolumn=80,120
highlight ColorColumn guibg=red

"set cursorcolumn
set cursorline

"""" Center cursor line by 100 visible lines
set scrolloff=100

"""" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""" copy and paste into vim terminal
"""" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set paste

"""" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""" split divide char to nothing
"""" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set fillchars+=vert:\ 

"""" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""" Word processing
"""" activate :Spell
"""" goto misspelled word ]s or [s
"""" list spelling options z=
"""" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! EnableSpellCheck()
    """" movement changes
    map j gj
    map k gk

    """" formatting text
    setlocal formatoptions=1
    setlocal noexpandtab
    setlocal wrap
    setlocal linebreak

    """" spelling and thesaurus
    setlocal spell spelllang=en_us

    """" Download and Use a Pre-defined Thesaurus
    """" wget http://www.gutenberg.org/dirs/etext02/mthes10.zip
    "set thesaurus+=/home/test/.vim/thesaurus/mthesaur.txt
    " complete+=s makes autocompletion search the thesaurus
    "set complete+=s
endfunction
com! Spell call EnableSpellCheck()

"""" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""" Html Tidy
"""" Install: sudo apt install tidy
"""" activate :Tidy
"""" About: It just auto indents html files
"""" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! HtmlTidy()
    "" command string
    :%!tidy -qicbn -asxhtml
endfunction
com! Tidy call HtmlTidy()

"""" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""" My macros EXAMPLES
"""" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"let @h="iHello World!\<CR>bye\<Esc>"
"let @f="\<esc>o\<esc>ifor ( int i = 0; i < 10; i++ ) {\<esc>o    // do stuff\<esc>o}\<esc>o \<esc>"
"let @i="\<esc>o\<esc>iif ( 1 ) {\<esc>o    \<esc>o}\<esc>o \<esc>"
"let @c="\<esc>o\<esc>i/* \<esc>76i*\<esc>o *\<esc>o\<esc>i * \<esc>76i*\<esc>i*/ \<esc>D\<esc>o\<esc>"

"" fold lines between "{" and "}"
let @f="\<esc>f{v%zf"

"""" copy line to register variable "q"
"" useful for copying bash 1-liners to the vim terminal
let @q="\<esc>0\"qy$"

"""" """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""" Yank To Global Clipboard
"""" activate :Y2C
"""" Select highlight chars and yank from Vim
"""" Place cursor in some other window application, like Firefox, Ctrl+v paste
""""
"""" Note:
""""     Yank word to register q:    "q    yw
""""     Put contents of q:          "q    p
"""" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! YankToClipboard()
    call system("xclip -selection clipboard", @")
endfunction
com! Y2C call YankToClipboard()

"""" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""" Nerdtree
""""
"""" Install:
"""" git clone https://github.com/preservim/nerdtree.git ~/.vim/pack/vendor/start/nerdtree
"""" vim -u NONE -c "helptags ~/.vim/pack/vendor/start/nerdtree/doc" -c q
"""" """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""" Toggle Nerdtree
"" :NERDTreeToggle

"""" Open a NERDTree automatically when vim starts up
"autocmd vimenter * NERDTree

"""" open a NERDTree automatically when vim starts up if no files were specified
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

"""" Close vim if the only window left open is a NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

"""" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""" Decorative Status Line
"""" help: statusline
"""" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""" Set status line ruler
"set laststatus=2

"function! GitBranch()
"  return system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
"endfunction

"function! StatuslineGit()
"  let l:branchname = GitBranch()
"  return strlen(l:branchname) > 0?'  '.l:branchname.' ':''
"endfunction

"set statusline=%f%m%r%h%w\ [%Y]\ [0x%02.2B]%<\ %F\ %=(col:%4v,\ row:%4l/%4L)\ %3p%%\ 
"set statusline=%{StatuslineGit()}\ %f%m%r%h%w\ [%Y]\ [0x%02.2B]%<\ %F\ %=(col:%4v,\ row:%4l/%4L)\ %3p%%\ 

"""" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""" Notes and reminders
"""" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""" VIM Search and replace syntax

"" :%s/Search/Replace/CommandFlag
"" ## Whole Document ##
"" :%s/Search-Word/Replace-Word/g
"" :%s/Search-Word/Replace-Word/gc
"" ## Search and replace in the current line only ##
"" :s/Find-Word/Replace-Word/gc
"" ## Change each 'Unix' to 'Linux' for all lines from line 36 to line 42 ##
"" :36,42s/Unix/Linux/g

"""" ## Auto complete suggestions
"" Ctrl+c

"""" ## Regex notes

"" ## Search & Replace  :range s[ubstitute]/pattern/string/cgiI
"" For each line in the range replace a match of the pattern with the string where:
"" c    Confirm each substitution
"" g    Replace all occurrences in the line (without g - only first).
"" i    Ignore case for the pattern.
"" I    Don't ignore case for the pattern.
"" ## Range of Operation, Line Addressing and Marks
"" number     an absolute line number
"" .    the current line
"" $    the last line in the file
"" %    the whole file. The same as 1,$
"" 't   position of mark "t"
"" /pattern[/]  the next line where text "pattern" matches.
"" ?pattern[?]  the previous line where text "pattern" matches
"" \/   the next line where the previously used search pattern matches
"" \?   the previous line where the previously used search pattern matches
"" \&   the next line where the previously used substitute pattern matches
"" ## "Escaped" characters or metacharacters
"" .    any character except new line 
"" \s   whitespace character
"" \S   non-whitespace character
"" \d   digit
"" \D   non-digit
"" \x   hex digit
"" \X   non-hex digit
"" \o   octal digit
"" \O   non-octal digit
"" \h   head of word character (a,b,c...z,A,B,C...Z and _)
"" \H   non-head of word character
"" \p   printable character
"" \P   like \p, but excluding digits
"" \w   word character
"" \W   non-word character
"" \a   alphabetic character
"" \A   non-alphabetic character
"" \l   lowercase character
"" \L   non-lowercase character
"" \u   uppercase character
"" \U   non-uppercase character
