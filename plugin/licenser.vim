" MIT License
"
" Copyright (c) 2019 Kirill
"
" Permission is hereby granted, free of charge, to any person obtaining
" a copy of this software and associated documentation files
" (the "Software"), to deal in the Software without restriction,
" including without limitation the rights * to use, copy, modify,
" merge, publish, distribute, sublicense, and/or sell copies of the Software,
" and to permit persons to whom the Software is furnished to do so,
" subject to the following conditions:
"
" The above copyright notice and this permission notice shall be
" included in all copies or substantial portions of the Software.
"
" THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
" IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
" FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
" AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
" LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
" ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
" OTHER DEALINGS IN THE SOFTWARE.

let g:licenser#loaded = 'yes'

" License comment formats
if !exists('g:licenser#format')
  let g:licenser#format = {
    \ 'java': {
      \ 'start': '/*',
      \ 'end': ' */',
      \ 'line': ' * ',
      \ 'empty_line': ' *',
    \ },
    \ 'bash': {
      \ 'line': '# ',
      \ 'empty_line': '#',
    \ },
    \ 'py': {
      \ 'line': '# ',
      \ 'empty_line': '#',
    \ },
    \ 'vim': {
      \ 'line': '" ',
      \ 'empty_line': '"',
    \ },
    \ 'yaml': {
      \ 'line': '# ',
      \ 'empty_line': '#',
      \ 'end': '---',
    \ },
    \ 'js': {
      \ 'start': '/*',
      \ 'end': ' */',
      \ 'line': ' * ',
      \ 'empty_line': ' *',
    \ },
  \ }
endif

" File type aliases
if !exists('g:licenser#aliases')
  let g:licenser#aliases = {
        \ 'yml': 'yaml',
        \ 'bash': 'sh',
        \ 'zsh': 'sh',
  \ }
endif

" Enable debugging
if !exists('g:licenser#debug')
  let g:licenser#debug = 0
endif
func! licenser#Debug(msg)
  if g:licenser#debug
    echo "[DEBUG] licenser: " . a:msg
  endif
endfun

" Licenses lookup
if !exists('g:licenser#licenses_lookup')
  let g:licenser#licenses_lookup = [
    \ 'LICENSE',
    \ 'LICENSE.txt',
    \ 'licsense',
    \ 'license.txt'
  \ ]
endif

" Find license and insert if found
fun! licenser#FindAndInsert()
  let l:ext = expand('%:e')
  if has_key(g:licenser#aliases, ext)
    let l:ext = g:licenser#aliases[ext]
  endif
  call licenser#Debug("Searching format for filetype: " . ext)
  if !has_key(g:licenser#format, ext)
    call licenser#Debug("Format `" . ext . "` was not found;"
      \ . " supported formats: " . string(keys(g:licenser#format)))
    return 0
  endif
  let l:fmt = g:licenser#format[ext]
  let l:success = 0
  for license in g:licenser#licenses_lookup
    if filereadable(license)
      call licenser#InsertLicense(license, fmt)
      let l:success = 1
      break
    endif
  endfor
  return success
endfun

" Insert license from file
fun! licenser#InsertLicense(license, fmt)
  let l:license = a:license "license file name
  let l:fmt = a:fmt "license format
  call licenser#Debug(
    \ "InsertLicense() license=" . license .
    \ " fmt=".string(fmt)
  \ )
  if empty(fmt)
    return
  endif
  let l:pos = 0
  if has_key(fmt, 'start')
    call append(pos, fmt['start'])
    let l:pos += 1
  endif
  for lic_line in readfile(license)
    if len(lic_line) > 0
      call append(pos, fmt['line'] . lic_line)
    else
      call append(pos, fmt['empty_line'])
    endif
    let l:pos += 1
  endfor
  if has_key(fmt, 'end')
    call append(pos, fmt['end'])
  endif
endfun

augroup licenser
  au!
  au BufNewFile * call licenser#FindAndInsert()
  au BufRead * if getfsize(expand('%'))==0|call licenser#FindAndInsert()|endif
augroup END

call licenser#Debug('plugin loaded')
