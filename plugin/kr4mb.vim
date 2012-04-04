" Provide the interface of KeyRemap4MacBook CLI.
" Version: 0.2.0
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




" Commands {{{1

command! -nargs=+ -complete=customlist,kr4mb#complete_identifiers KR4MBEnable
      \ call kr4mb#enable(split(<q-args>))

command! -nargs=+ -complete=customlist,kr4mb#complete_identifiers KR4MBDisable
      \ call kr4mb#disable(split(<q-args>))

command! -nargs=+ -complete=customlist,kr4mb#complete_identifiers KR4MBToggle
      \ call kr4mb#toggle(split(<q-args>))




" Epilogue {{{1

let g:loaded_kr4mb = 1

let &cpoptions = s:save_cpoptions
unlet s:save_cpoptions




" __End__ {{{1
" vim: et ts=2 sts=2 sw=2 fen foldmethod=marker:
