if exists("g:loaded_cppdev_ext")
    finish
end

let g:loaded_cppdev_ext = 1

command! ToggleHS call cppdev#ToggleToHeaderOrSource() 

function! s:msg(text)
    echomsg a:text
endfunction

function! s:warn(text)
    echohl WarningMsg
    echomsg a:text
    echohl None
endfunction

function! s:open_or_edit(path)
    let num = bufnr(a:path)
    if bufwinnr(num) > 0
        execute("silent buffer " . num)
    else
        execute("silent open " . a:path)
    endif
endfunction

function! cppdev#ToggleToHeader()
    let stripname = expand("%:p:h") . "/" . substitute(expand("%:p:t"), "." . expand("%:e"), "", "")

    if filereadable(stripname . ".h")
        call s:open_or_edit(stripname . ".h")
    else
        call s:warn("No header file found.")
    endif
endfunction

function! cppdev#ToggleToSource()
    let stripname = expand("%:p:h") . "/" . substitute(expand("%:p:t"), "." . expand("%:e"), "", "")

    if filereadable(stripname . ".cpp")
        call s:open_or_edit(stripname . ".cpp")
    else
        call s:warn("No source file found.")
    endif
endfunction

function! cppdev#ToggleToHeaderOrSource()
    let extension = expand("%:e")
    if extension ==? "h"
        call cppdev#ToggleToSource()
    elseif extension ==? "cpp"
        call cppdev#ToggleToHeader()
    else
        call s:warn("Unknown toggle file.")
    endif
endfunction

