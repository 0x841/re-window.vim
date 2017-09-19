" ------------------------------------------------------------------------------
" rewindow.vim
" ------------------------------------------------------------------------------

if exists('g:loaded_rewindow')
    finish
endif
let g:loaded_rewindow = 1

if !has('windows')
    finish
endif

let s:save_cpo = &cpo
set cpo&vim

augroup reopen_window
    autocmd!
    autocmd QuitPre * call <SID>quit_file()
augroup END

let s:quit_file_info_stack = []

let s:split_pos_cmds = [
\   '"ACCORDING TO THE WINDOW SIZE"',
\   'leftabove',
\   'rightbelow',
\   'vertical leftabove',
\   'vertical rightbelow',
\   'topleft',
\   'botright',
\   'vertical topleft',
\   'vertical botright'
\]

function! s:quit_file() abort
    let l:quit_file_path =  expand('<afile>:p')
    let l:same_as_last_file = (len(s:quit_file_info_stack) > 0)
                         \ && (l:quit_file_path == s:quit_file_info_stack[-1]['filepath'])

    if !l:same_as_last_file && filereadable(l:quit_file_path)
        call add(s:quit_file_info_stack, s:current_file_info(l:quit_file_path))
    endif
endfunction

function! s:current_file_info(filepath) abort
    return {
    \   'filepath' : a:filepath,
    \   'win_info' : winsaveview(),
    \   'is_help'  : &filetype == 'help'
    \}
endfunction

function! s:windows_close(close_cmd) abort
    let l:current_win_id = win_getid()
    let l:pre_tab_id = tabpagenr()
    let l:pre_file_info = {}

    for l:win_id in gettabinfo(l:pre_tab_id)[0]['windows']
        call win_gotoid(l:win_id)
        let pre_file_info[l:win_id] = s:current_file_info(expand('%:p'))
    endfor
    call win_gotoid(l:current_win_id)

    execute a:close_cmd

    if tabpagenr() == l:pre_tab_id
        for l:win_id in gettabinfo(tabpagenr())[0]['windows']
            if !exists('l:pre_file_info[l:win_id]')
                call remove(l:pre_file_info, l:win_id)
            endif
        endfor
    endif

    for l:win_id in sort(keys(l:pre_file_info))
        call add(s:quit_file_info_stack, l:pre_file_info[l:win_id])
    endfor
endfunction

function! rewindow#only() abort
    call s:windows_close('only')
endfunction

function! rewindow#tabclose() abort
    call s:windows_close('tabclose')
endfunction

function! rewindow#reopen_window(...) abort
    if !s:is_quit_file_openable()
        return
    endif

    let l:file_info = remove(s:quit_file_info_stack, -1)

    if l:file_info['is_help']
        call s:open_help(l:file_info['filepath'], s:split_type(a:000))
    else
        call s:open_file(l:file_info['filepath'], s:split_type(a:000))
    endif

    call winrestview(l:file_info['win_info'])
endfunction

function! s:split_type(args) abort
    let l:split_cmd_id = (len(a:args) > 0) ? a:args[0] - 1 : 0
    if (type(l:split_cmd_id) == v:t_number) && exists('s:split_pos_cmds[l:split_cmd_id]') && (l:split_cmd_id != 0)
        return s:split_cmd_id[l:split_cmd_id]
    endif

    let l:win_id = win_getid()
    if (winheight(l:win_id) * 5 >= winwidth(l:win_id) * 2) || !has('vertsplit')
        return &splitbelow ? 'rightbelow' : 'leftabove'
    else
        return 'vertical ' . (&splitright ? 'rightbelow' : 'leftabove')
    endif
endfunction

function! s:is_quit_file_openable() abort
    if len(s:quit_file_info_stack) <= 0
        echohl Error
        echo 'No file has been quit.'
        echohl None
        return 0
    endif

    let l:filepath = s:quit_file_info_stack[-1]['filepath']
    if !filereadable(l:filepath)
        echohl Error
        echo fnamemodify(l:filepath, ':~') 'is not exist.'
        echohl None
        return 0
    endif

    return 1
endfunction

function! s:open_file(filepath, split_cmd) abort
    if s:is_this_win_empty()
        execute 'edit'  a:filepath
    else
        execute a:split_cmd 'split' a:filepath
    endif
endfunction

function! s:open_help(filepath, split_cmd) abort
    let l:keyword = fnamemodify(a:filepath, ':t:r') . '.txt'
    if fnamemodify(a:filepath, ':e') == 'txt'
        let l:keyword .= '@en'
    endif

    let l:is_win_empty = s:is_this_win_empty()
    if l:is_win_empty
        let l:win_num = winnr('$')
    endif

    execute a:split_cmd 'help' l:keyword

    if l:is_win_empty && (winnr('$') != l:win_num)
        execute winnr('#') . 'close'
    endif
endfunction

function! s:is_this_win_empty() abort
    return !&modified && (expand('%') == '')
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

