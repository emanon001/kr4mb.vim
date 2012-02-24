" Provide the interface of KeyRemap4MacBook.
" Version: 0.0.1
" Author:  emanon001 <emanon001@gmail.com>
" License: DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE, Version 2 {{{
"     This program is free software. It comes without any warranty, to
"     the extent permitted by applicable law. You can redistribute it
"     and/or modify it under the terms of the Do What The Fuck You Want
"     To Public License, Version 2, as published by Sam Hocevar. See
"     http://sam.zoy.org/wtfpl/COPYING for more details.
" }}}

" Prologue {{{1

scriptencoding utf-8

if exists('g:loaded_kr4mb')
  finish
endif

let s:save_cpoptions = &cpoptions
set cpoptions&vim




" Options {{{1

function! s:set_default_option(name, value)
  if !exists('g:kr4mb#' . a:name)
    let g:kr4mb#{a:name} = a:value
  endif
endfunction

call s:set_default_option('command_path', 
      \ '/Library/org.pqrs/KeyRemap4MacBook/app/KeyRemap4MacBook_cli.app/Contents/MacOS/KeyRemap4MacBook_cli')
call s:set_default_option('identifier_aliases', {})




" Commands {{{1

command! -nargs=+ -complete=customlist,kr4mb#complete_identifiers KR4MBEnable
      \ call kr4mb#enable_some(split(<q-args>))

command! -nargs=+ -complete=customlist,kr4mb#complete_identifiers KR4MBDisable
      \ call kr4mb#disable_some(split(<q-args>))

command! -nargs=+ -complete=customlist,kr4mb#complete_identifiers KR4MBToggle
      \ call kr4mb#toggle_some(split(<q-args>))




" Epilogue {{{1

let g:loaded_kr4mb = 1

let &cpoptions = s:save_cpoptions
unlet s:save_cpoptions




" __End__ {{{1
" vim: et ts=2 sts=2 sw=2 fen foldmethod=marker:
