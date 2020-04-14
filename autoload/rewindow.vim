let s:quit_file_info_stack = []

let s:split_pos_cmds = {
\   'k' : 'leftabove',
\   'j' : 'rightbelow',
\   'h' : 'vertical leftabove',
\   'l' : 'vertical rightbelow',
\   'K' : 'topleft',
\   'J' : 'botright',
\   'H' : 'vertical topleft',
\   'L' : 'vertical botright'
\}

function! rewindow#_pre_quit() abort
    let l:quit_file_path = expand('<afile>:p')
    let l:same_as_last_file = (len(s:quit_file_info_stack) > 0)
                         \ && (l:quit_file_path == s:quit_file_info_stack[-1].filepath)

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

    for l:win_id in gettabinfo(l:pre_tab_id)[0].windows
        call win_gotoid(l:win_id)
        let l:pre_file_info[l:win_id] = s:current_file_info(expand('%:p'))
    endfor
    call win_gotoid(l:current_win_id)

    execute a:close_cmd

    if tabpagenr() == l:pre_tab_id
        for l:win_id in gettabinfo(tabpagenr())[0].windows
            if exists('l:pre_file_info[l:win_id]')
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

function! rewindow#reopen(...) abort
    if !s:is_quit_file_openable()
        return
    endif

    let l:file_info = remove(s:quit_file_info_stack, -1)

    if l:file_info.is_help
        call s:open_help(l:file_info.filepath, s:split_type(get(a:000, 0)))
    else
        call s:open_file(l:file_info.filepath, s:split_type(get(a:000, 0)))
    endif

    call winrestview(l:file_info.win_info)
endfunction

function! s:split_type(arg) abort
    if has_key(s:split_pos_cmds, a:arg)
        return s:split_pos_cmds[a:arg]
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

    let l:filepath = s:quit_file_info_stack[-1].filepath
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
