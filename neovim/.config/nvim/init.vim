set encoding=utf-8
scriptencoding utf-8

set nocompatible

map <space> <leader>

""" General reminders
""" - Shortcuts
"""   - ctrl<C> and alt<A> shortcuts cannot be case sensitive (ctrl-f and ctrl-F are the same)
"""   - only plain shift key shortcut (also with leader) can be case sensitive (ie f and F, or <leader>f and <leader>F )
""" - Augroups
"""   - augroups namespace autocommands together, autocmd! clears all commands in the namespace first
"""   - remaps using FileType and <buffer> will only be active for that given buffer and FileType
"""   - all other remaps apply to all filetypes and buffers

" ============================================================================
" VIM-PLUG
" ============================================================================
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.config/nvim/plugged')

Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'editorconfig/editorconfig-vim'

" fuzzy file/line/text searching, use leading ' (single quote) to do exact searches
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'

" project explorer because netrw sucks
let g:NERDTreeQuitOnOpen=3
let g:NERDTreeShowHidden=1
let g:NERDTreeMinimalUI=0
let g:NERDTreeWinSize=50
Plug 'scrooloose/nerdtree'
nnoremap - :NERDTreeToggle<CR>

" color theme
Plug 'gruvbox-community/gruvbox'

" :GV git viewer
Plug 'junegunn/gv.vim'

" turns mouse on, focus, cursor shape, and paste support for terminal mode
Plug 'wincent/terminus'

Plug 'nvim-treesitter/nvim-treesitter'
" TODO autocmd to run this on startup?
" :TSInstall all
" :TSUpdate

" visual undo tree
let g:undotree_SetFocusWhenToggle = 1
let g:undotree_CustomUndotreeCmd  = 'topleft vertical 35 new'
let g:undotree_CustomDiffpanelCmd = 'botright 15 new'
Plug 'mbbill/undotree'
nnoremap <leader>u :UndotreeToggle<CR>

" nicer status bar
let g:airline_theme='gruvbox'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline_powerline_fonts = 1
let g:airline_section_c = '%<%F%m %#__accent_red#%{airline#util#wrap(airline#parts#readonly(),0)}%#__restore__#' " show full filepaths
Plug 'vim-airline/vim-airline'

" let me close buffer without closing window
Plug 'moll/vim-bbye'
function! DeleteBuffer()
    if &buftype ==# 'terminal'
        bwipeout!
    else
        Bwipeout
    endif
endfunction
nnoremap <leader>d :call DeleteBuffer()<CR>

" gc helper
Plug 'tpope/vim-commentary'

"work demandware syntax stuffs
Plug 'clavery/vim-dwre'

" :Git command
Plug 'tpope/vim-fugitive'
" Delete Fugitive buffers when I leave them so they don't pollute BufExplorer
augroup FugitiveCustom
    autocmd!
    autocmd BufReadPost fugitive://* set bufhidden=delete
augroup END

" repeat extra stuff with .
Plug 'tpope/vim-repeat'

" csiw '
Plug 'tpope/vim-surround'

" allow ctrl+jkl; to navigate both vim and tmux together
let g:tmux_navigator_save_on_switch = 1
Plug 'christoomey/vim-tmux-navigator'

Plug 'tpope/vim-unimpaired'

" allow <leader>ww to mark and swap windows
let g:windowswap_map_keys = 0 "prevent default bindings
Plug 'wesQ3/vim-windowswap'
nnoremap <leader>ww :call WindowSwap#EasyWindowSwap()<CR>

call plug#end()

" ============================================================================
" GENERAL VIM SETTINGS
" ============================================================================
" let vim overwrite/use system clipboard
if has("clipboard") " yank to clipboard
  set clipboard=unnamed " copy to the system clipboard
  if has("unnamedplus") " X11 support
    set clipboard+=unnamedplus
  endif
endif

set history=10000          " undo history to x items

set nomodeline             " don't read first few lines of files for ex commands

if !exists("g:loaded_matchit") && findfile("plugin/matchit.vim", &runtimepath) ==# ""
  runtime! macros/matchit.vim " matchit responsible for % matching
endif

set shortmess=I           " don't show startup message, shorten prompt on long messages to avoid Enter
set cmdheight=2
set updatetime=300         " time until swap file writes, additionally how long until CursorHold fires
set signcolumn=yes         " always show column to left of line number

set timeoutlen=1000        " wait 1000 ms for mapping delay
set ttimeoutlen=10         " wait 10 ms for keycodes

set nrformats-=octal       " treat leading 007 as not octal numbers for increment <C-a> and decrement <C-x>

set viminfo+=!             " persist upper case variables and marks 'A to viminfo

" ============================================================================
" WINDOW
" ============================================================================
set display+=lastline " always show whole last line in document instead of @ symbol

set laststatus=2      " window always has status line

set number            " always show current line number
"set relativenumber    " show number relative to current line

set report=0          " always show 'x lines yanked'

set showcmd           " show current leader command in bottom right

if exists(':AirlineRefresh')
  set noshowmode      " airline already shows the mode
else
  set ruler             " always show cursor position in bottom right, only used when airline is off
endif

set splitbelow        " default vertical splits to be down
set splitright        " default horizontal splits to be right

" open all :h in new tab, allow tab to close with esc
function! s:helptab()
  if &buftype == 'help'
    wincmd T
    nnoremap <buffer> q :q<cr>
  endif
endfunction
augroup help_tab
  autocmd!
  autocmd BufEnter *.txt call s:helptab()
augroup END

" Set all non-netrw buffers to bufhidden=hide
set nohidden
augroup netrw_buf_hidden_fix
  autocmd!

  autocmd BufWinEnter *
        \  if &ft != 'netrw'
        \|     set bufhidden=hide " let buffers move out of focus without annoying warning to save
        \| endif

augroup END

" ============================================================================
" TEXT DISPLAY AND COLORS
" ============================================================================
" allows for coloring based on syntax words
syntax on

" allow colors to work inside tmux
set termguicolors
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
set background=dark " tells VIM colorscheme has dark background

let g:gruvbox_italic=1
let g:gruvbox_contrast_dark='hard'
colorscheme gruvbox

" transparency
hi! Normal ctermbg=NONE guibg=NONE
hi! NonText ctermbg=NONE guibg=NONE guifg=NONE ctermfg=NONE

"use a taller pipe and slash symbol
set fillchars=vert:│,stl:\ ,stlnc:\

" nicer symbols for whitespace characters
set list
set listchars=tab:→\ ,trail:·,extends:↷,precedes:↶,nbsp:·
set showbreak=↪\

set showmatch " highlights matching {([
set matchtime=3 "300ms to show paren match

set cursorline " show horizontal highlight on active line

set ttyfast " faster redrawing
set lazyredraw " dont redraw during macro
set regexpengine=1 " use old engine for speed

set nowrap
" set whichwrap=b,s " allow backspace and space to traverse wrapped lines
" set formatoptions+=1 " don't break on one character word
" set wrap linebreak nolist " wrap lines only at linebreak
" if has('patch-7.4.338')
"   set breakindent
"   set breakindentopt=sbr
" endif

" ============================================================================
" COMPLETION
" ============================================================================
set complete-=i                                            " do not scan included files, .tags is more performant
set completeopt=noinsert,menuone,noselect                  " Autocomplete behavior, always show menu, don't
set infercase                                              " case sensitive ins-completion when uppercase present
set pumheight=10                                           " limit popup result height
set wildignore+=*swp,*.class,*.pyc,*.png,*.jpg,*.gif,*.zip " ignore these files
set wildignore+=*/tmp/*,*.o,*.obj,*.so                     " Unix
set wildmenu                                               " cmd (:) completion
set wildmode=list:longest,full                             " bash like behavior

filetype plugin indent on " turn on filetype analysis allows file specific plugins, indentation, and completion

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

" <cr> selects currently selected item
" <cr> also selects first item in dropdown if none are selected
" otherwise <cr> simply acts like <cr> and adds a carriage return
inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : pumvisible() ? "\<C-n>\<C-y>" : "<cr>"

" close preview window when completion done
autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

" ============================================================================
" SEARCHING
" ============================================================================
set hlsearch    " show highlighed searches by default
set ignorecase  " case insensitive search
if has('reltime')
  set incsearch " allow incremental search per letter typed
endif
set smartcase   " case sensitive search when uppercase present

if executable('rg')
  "use ripgrep for :grep searches
  set grepprg=rg\ --no-heading\ --vimgrep
  set grepformat=%f:%l:%c:%m
endif

" ============================================================================
" INDENTATION
" ============================================================================
set autoindent   " copies indentation from previous line
set expandtab    " tab inserts x spaces in insert mode
set shiftwidth=2 " tab inserts x spaces when using >>
set smarttab     " let tab behave like >> or <<
set tabstop=2    " tab counts as x spaces when reading

" ============================================================================
" FILE SAVING AND READING
" ============================================================================
set autoread " reread files modified outside of vim, https://unix.stackexchange.com/a/383044
augroup auto_read
  autocmd!
  autocmd CursorHold,CursorHoldI * :checktime
  autocmd FocusGained,BufEnter * :checktime
augroup END

set backup " put all backup/undo/swap files into ~/.vim
if !isdirectory($HOME.'/.vim')
  call mkdir($HOME.'/.vim', '', 0770)
endif
if !isdirectory($HOME.'/.vim/_backup')
  call mkdir($HOME.'/.vim/_backup', '', 0700)
endif
if !isdirectory($HOME.'/.vim/_swp')
  call mkdir($HOME.'/.vim/_swp', '', 0700)
endif
set backupdir=~/.vim/_backup//
set directory=~/.vim/_swp//

if has('persistent_undo')
  if !isdirectory($HOME.'/.vim/_undo')
    call mkdir($HOME.'/.vim/_undo', '', 0700)
  endif
  set undodir=~/.vim/_undo
  set undofile
  set undolevels=1000 "number of changes to store
  set undoreload=10000 "number of lines to undo
endif

set sessionoptions-=options "don't store options that will just be set by vimrc anyway

augroup savecursorposition
  autocmd!
  " When editing a file, always jump to the last known cursor position.
  autocmd BufReadPost *
        \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
        \ |   exe "normal! g`\""
        \ | endif
augroup END

" automatically close location list when buffer closes
augroup CloseLoclistWindowGroup
  autocmd!
  autocmd QuitPre * if empty(&buftype) | lclose | endif
augroup END

" quicksave current buffer with double space
nnoremap <leader><space> :wa<CR>

" ============================================================================
" EDITING
" ============================================================================

" allow backspace to go backwards normally
set backspace=indent,eol,start

" do not automatically comment next line after hitting enter
augroup comment
  autocmd!
  autocmd BufNewFile,BufRead * setlocal formatoptions-=cro
augroup END

set scrolloff=5
set sidescroll=1
set sidescrolloff=20

" ============================================================================
" REMAPS - FZF
" ============================================================================
" fuzzy search open buffer names
nnoremap <leader>b :Buffers<CR>

" fuzzy search file names using current working directory (:PWD)
nnoremap <leader>f :Files!<CR>
nnoremap <leader>F :Files<CR>

" fuzzy search file names using home directory
nnoremap <leader>r :FilesRoot<CR>
nnoremap <leader>R :FilesRoot!<CR>

" fuzzy search text in open buffers
nnoremap <leader>l :Lines<CR>

" fuzzy search text without restarting ripgrep on keystroke using working directory (:PWD)
nnoremap <leader>p :FuzzyRg!<CR>
nnoremap <leader>P :FuzzyRg<CR>

" exact grep style search text by restarting ripgrep on keystroke using working directory (:PWD)"
nnoremap <leader>g :ExactRg!<CR>
nnoremap <leader>G :ExactRg<CR>

" fuzzy search for text using current working directory (:PWD) and word under cursor
" nnoremap <leader>ew :IRgw!<CR>
" nnoremap <leader>eW :IRgw<CR>

" ============================================================================
" REMAPS - BUFFERS
" ============================================================================

" easier navigation for buffers
augroup termIgnore
    autocmd!
    if has('nvim')
      autocmd TermOpen * setlocal nobuflisted
    else
      autocmd TerminalOpen * setlocal nobuflisted
    endif
    autocmd FileType qf setlocal nobuflisted

    " exit qf with esc
    autocmd FileType qf nnoremap <buffer> q :q<CR>

    " always make quickfix window be on the bottom
    au FileType qf wincmd J
augroup END

" ============================================================================
" REMAPS - EDITING AND NAVIGATION
" ============================================================================

" allow double escape to clear highlighting from / (:set hlsearch) (single escape broken in wsl)
nnoremap <silent> <esc><esc> :nohl<cr>

" fix control u and control w during insert mode to start new undo path
" deletes last line in insert mode
inoremap <c-u> <c-g>u<c-u>

" deletes last word in insert mode
inoremap <c-w> <c-g>u<c-w>

" make Y behave like C and D
nnoremap Y y$

" easier navigation of wrapped lines
vmap j gj
vmap k gk
nmap j gj
nmap k gk

"visual shifting does not exit visual mode
vnoremap < <gv
vnoremap > >gv

" don't jump to next match right away
nnoremap * /\<<C-R>=expand('<cword>')<CR>\><CR>

" paste will not replace register with pasted over text
xnoremap <expr> p 'pgv"'.v:register.'y`>'

" vim-tmux-navigator works in terminal mode
if has('nvim')
  tnoremap <silent> <esc> <C-\><C-n>:q!<CR>
  tnoremap <silent> <c-h> <C-\><C-n>:TmuxNavigateLeft<cr>
  tnoremap <silent> <c-j> <C-\><C-n>:TmuxNavigateDown<cr>
  tnoremap <silent> <c-k> <C-\><C-n>:TmuxNavigateUp<cr>
  tnoremap <silent> <c-l> <C-\><C-n>:TmuxNavigateRight<cr>
else
  tnoremap <silent> <esc> <C-W>N
  tnoremap <silent> <c-h> <C-W>N<esc>:TmuxNavigateLeft<cr>
  tnoremap <silent> <c-j> <C-W>N<esc>:TmuxNavigateDown<cr>
  tnoremap <silent> <c-k> <C-W>N<esc>:TmuxNavigateUp<cr>
  tnoremap <silent> <c-l> <C-W>N<esc>:TmuxNavigateRight<cr>
endif


" ============================================================================
" REMAPS - OTHER
" ============================================================================
" edit vim config
nnoremap <leader>vc :e ~/.config/nvim/init.vim<CR>

" source vim config
nnoremap <leader>vs :source ~/.config/nvim/init.vim<CR>

" :W sudo saves the file
command! W w !sudo tee % > /dev/null

" Don't use Ex mode, use Q for formatting.
map Q gq

" ============================================================================
" FUNCTIONS
" ============================================================================

" true grep searching with automatic refresh as you type
function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --line-number --no-heading --color=always --hidden --follow --glob "!{.git,node_modules,.svn,*.sass-cache}" --smart-case %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--tiebreak=end', '--height=100%', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec, 'up:60%'), a:fullscreen)
endfunction
command! -nargs=* -bang ExactRg call RipgrepFzf(<q-args>, <bang>0)

" fuzzy searching feeds rg into fzf, escape sequence at end for vim in tmux
command! -bang -nargs=* FuzzyRg
      \ call fzf#vim#grep(
      \ 'rg --line-number --no-heading --color=never --smart-case --hidden --follow --glob "!{.git,node_modules,.svn,*.sass-cache}" '.shellescape(<q-args>), 0,
      \ fzf#vim#with_preview({'options': '--tiebreak=end --height=100%'}, 'up:60%'), <bang>0)

" create my own grep command that feeds the word under the cursor rg into fzf, avoid using --color always for speed, escape sequence at end for vim in tmux
" command! -bang -nargs=* IRgw
"       \ call fzf#vim#grep(
"       \ 'rg --line-number --no-headingi --color=never --smart-case --hidden --follow --glob "!{.git,node_modules,.svn,*.sass-cache,target}" '.shellescape(expand('<cword>')), 0,
"       \ <bang>0 ? fzf#vim#with_preview({'options': '--tiebreak=end --height=100%'},'up:60%')
"       \         : fzf#vim#with_preview({'options': '--tiebreak=end'},'right:40%', '?'),
"       \ <bang>0)

" uses $PWD as 
" --info=inline 27/500 displays on first line
" --layout-reverse (top to bottom display)
" --fzf#vim#with_preview uses bat command for color
" --tiebreak=end to favor matches towards end of file path
command! -bang -nargs=? -complete=dir Files
      \ call fzf#vim#files(<q-args>, fzf#vim#with_preview({'options': '--tiebreak=end --layout=reverse --info=inline --height=100%'}, 'up:60%'), <bang>0)

" uses '~' as base directory for searching
" --info=inline 27/500 displays on first line
" --layout-reverse (top to bottom display)
" --preview uses bat command for color
" --tiebreak=end to favor matches towards end of file path
command! -bang -nargs=? FilesRoot
      \ call fzf#vim#files('~', {'options': ['--tiebreak=end', '--layout=reverse', '--info=inline', '--preview', '~/.config/nvim/plugged/fzf.vim/bin/preview.sh {}']}, <bang>0)

" Zoom / Restore window.
function! s:ZoomToggle() abort
  if exists('t:zoomed') && t:zoomed
    execute t:zoom_winrestcmd
    let t:zoomed = 0
  else
    let t:zoom_winrestcmd = winrestcmd()
    resize
    vertical resize
    let t:zoomed = 1
  endif
endfunction
command! ZoomToggle call s:ZoomToggle()
nnoremap <silent> <leader>z :ZoomToggle<CR>

" ============================================================================
" LSP
" ============================================================================

lua <<EOF
  require'nvim-treesitter.configs'.setup {
    highlight = {
      enable = true
    }
  }
EOF
