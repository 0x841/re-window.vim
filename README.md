
# Re-window.vim
This plugin reopens the last closed window.

This is released under the MIT License, see LICENSE .

# Usage
You can reopen the last closed window by `:call rewindow#reopen_window([split_way_id])`.

The window is opened by splitting.

"split\_way\_id" mean the following numbers.

In 2 to 9, splitting is done using each command.

1. ACCORDING TO THE CURRENT WINDOW SIZE
2. leftabove
3. rightbelow
4. vertical leftabove
5. vertical rightbelow
6. topleft
7. botright
8. vertical topleft
9. vertical botright

This plugin detects closed windows by `QuitPre`, so for example, the window closed by `:tabclose` or `:only` is not detected.

You can use `:call rewindow#tabclose()` and `:call rewindow#only()` instead of these commands.

