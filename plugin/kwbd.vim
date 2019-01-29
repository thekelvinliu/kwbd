" only load once
if exists('g:loaded_kwbd')
  finish
endif
let g:loaded_kwbd = 1

" ex command
command! KWBD call s:kwbd()

" plug mapping
noremap <silent> <plug>(kwbd) :call <sid>kwbd()<cr>

" change current buffer to alternate or next if it matches the given target
function! s:alt_or_next_buf(target)
  if (bufnr('%') ==# a:target)
    let alt = bufnr('#')
    if (alt > 0 && buflisted(alt) && alt !=# a:target)
      buffer #
    else
      bnext
    endif
  endif
endfunction

" current window buffer listed
function! s:cwbl()
  return buflisted(winbufnr(0))
endfunction

" keep window buffer delete
function! s:kwbd()
  " just delete when the current window's buffer is not listed
  if !s:cwbl()
    bdelete!
    return
  endif

  " save buffer and window at time of invocation
  let savedbuf = bufnr('%')
  let savedwin = winnr()

  " make all windows with the saved buffer swtich and then move to saved window
  windo call s:alt_or_next_buf(savedbuf)
  execute savedwin . 'wincmd w'

  " loop variables
  let count = 0
  let jumpbufnr = 0
  let i = 1

  " iterate over buffers except for the saved one
  while i <=# bufnr('$')
    if i !=# savedbuf
      " count listed buffers
      if buflisted(i)
        let count += 1
      " set jump buffer to first unlisted no name buffer
      elseif bufexists(i) && !strlen(bufname(i)) && !jumpbufnr
        let jumpbufnr = i
      endif
    endif
    let i += 1
  endwhile

  " no other listed buffers
  if !count
    " create empty buffer when no jump buffer was found
    if !jumpbufnr
      enew
      let jumpbufnr = bufnr('%')
    endif

    " make all windows with a listed buffer go to the jump buffer and then
    " move to saved window
    windo if s:cwbl() | execute jumpbufnr . 'buffer!' | endif
    execute savedwin . 'wincmd w'
  endif

  " delete buffer
  if buflisted(savedbuf) || savedbuf == bufnr("%")
    execute savedbuf . 'bdelete!'
  endif

  " adjust settings when there are no other listed buffers
  if !count
    setlocal bufhidden=delete
    setlocal buflisted
    setlocal buftype=
    setlocal noswapfile
  endif
endfunction
