# Re-window.vim
This plugin reopens the last closed window in vim.

This is released under the MIT License, see LICENSE .

# Usage
You can reopen the last closed window by `rewindow#reopen()` or the following keymaps.
The window is opened by splitting.

This plugin detects closed windows by `QuitPre`, so for example, the window closed by `:tabclose` or `:only` is not detected.
You can use `:call rewindow#tabclose()`, `:call rewindow#only()` or the following keymaps instead of these commands.

```vim
" Reopen the window to left of the current window.
" This is same as ":call rewindow#reopen('h')".
nmap <Leader>h <Plug>(rewindow-reopen-h)

" Reopen the window to under of the current window.
" This is same as ":call rewindow#reopen('j')".
nmap <Leader>j <Plug>(rewindow-reopen-j)

nmap <Leader>k <Plug>(rewindow-reopen-k)
nmap <Leader>l <Plug>(rewindow-reopen-l)

" Reopen the window to the far left.
" This is same as ":call rewindow#reopen('H')".
nmap <Leader>H <Plug>(rewindow-reopen-H)

nmap <Leader>J <Plug>(rewindow-reopen-J)
nmap <Leader>K <Plug>(rewindow-reopen-K)
nmap <Leader>L <Plug>(rewindow-reopen-L)

" Reopen the window to right or under of the current window according to the size of the current window.
" This is same as ":call rewindow#reopen()".
nmap <Leader>w <Plug>(rewindow-reopen)


" ":only" for rewindow.
" This is same as ":call rewindow#only()".
nmap <C-W>o <Plug>(rewindow-only)
xmap <C-W>o <Plug>(rewindow-only)

" ":tabclose" for rewindow.
" This is same as ":call rewindow#tabclose()".
nmap <C-W>tc <Plug>(rewindow-tabclose)
xmap <C-W>tc <Plug>(rewindow-tabclose)
```
