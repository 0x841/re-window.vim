if exists('g:loaded_rewindow')
    finish
endif
let g:loaded_rewindow = 1

if !has('windows')
    finish
endif

let s:save_cpo = &cpo
set cpo&vim

nnoremap <silent> <Plug>(rewindow-reopen)   :<C-U>call rewindow#reopen()<CR>
xnoremap <silent> <Plug>(rewindow-reopen)   :<C-U>call rewindow#reopen()<CR>
nnoremap <silent> <Plug>(rewindow-reopen-h) :<C-U>call rewindow#reopen('h')<CR>
xnoremap <silent> <Plug>(rewindow-reopen-h) :<C-U>call rewindow#reopen('h')<CR>
nnoremap <silent> <Plug>(rewindow-reopen-j) :<C-U>call rewindow#reopen('j')<CR>
xnoremap <silent> <Plug>(rewindow-reopen-j) :<C-U>call rewindow#reopen('j')<CR>
nnoremap <silent> <Plug>(rewindow-reopen-k) :<C-U>call rewindow#reopen('k')<CR>
xnoremap <silent> <Plug>(rewindow-reopen-k) :<C-U>call rewindow#reopen('k')<CR>
nnoremap <silent> <Plug>(rewindow-reopen-l) :<C-U>call rewindow#reopen('l')<CR>
xnoremap <silent> <Plug>(rewindow-reopen-l) :<C-U>call rewindow#reopen('l')<CR>
nnoremap <silent> <Plug>(rewindow-reopen-H) :<C-U>call rewindow#reopen('H')<CR>
xnoremap <silent> <Plug>(rewindow-reopen-H) :<C-U>call rewindow#reopen('H')<CR>
nnoremap <silent> <Plug>(rewindow-reopen-J) :<C-U>call rewindow#reopen('J')<CR>
xnoremap <silent> <Plug>(rewindow-reopen-J) :<C-U>call rewindow#reopen('J')<CR>
nnoremap <silent> <Plug>(rewindow-reopen-K) :<C-U>call rewindow#reopen('K')<CR>
xnoremap <silent> <Plug>(rewindow-reopen-K) :<C-U>call rewindow#reopen('K')<CR>
nnoremap <silent> <Plug>(rewindow-reopen-L) :<C-U>call rewindow#reopen('L')<CR>
xnoremap <silent> <Plug>(rewindow-reopen-L) :<C-U>call rewindow#reopen('L')<CR>
nnoremap <silent> <Plug>(rewindow-only)     :<C-U>call rewindow#only()<CR>
xnoremap <silent> <Plug>(rewindow-only)     :<C-U>call rewindow#only()<CR>
nnoremap <silent> <Plug>(rewindow-tabclose) :<C-U>call rewindow#tabclose()<CR>
xnoremap <silent> <Plug>(rewindow-tabclose) :<C-U>call rewindow#tabclose()<CR>

augroup rewindow
    autocmd!
    autocmd QuitPre * call rewindow#_pre_quit()
augroup END

let &cpo = s:save_cpo
unlet s:save_cpo
