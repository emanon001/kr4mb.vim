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

let s:save_cpoptions = &cpoptions
set cpoptions&vim




" Constants {{{1

let s:TRUE = 1
let s:FALSE = !s:TRUE
let s:PLUGIN_NAME = expand('<sfile>:t:r')

lockvar! s:TRUE s:FALSE s:PLUGIN_NAME




" Variables {{{1

" Entity of the plugin
let s:kr4mb = {}

" Preparation of initialization. {{{2

function! s:kr4mb.__init__() " {{{3
  call self.__init_variables__()
  call self.__init_accessor__()
endfunction

function! s:kr4mb.__init_variables__() " {{{3
  let self._variables_ = {
        \  'command_path': g:kr4mb#command_path,
        \  'identifier_aliases': g:kr4mb#identifier_aliases
        \ }
endfunction

function! s:kr4mb.__init_accessor__() " {{{3
  call self._define_accessor('accessor', 'command_path')
  call self._define_accessor('getter', 'identifier_aliases')
endfunction




" Interface {{{1

function! kr4mb#list() " {{{2
  return s:kr4mb.get_configuration_names()
endfunction


function! kr4mb#get_configuration_names() " {{{2
  return kr4mb#list()
endfunction


function! kr4mb#selected() " {{{2
  return s:kr4mb.get_index_of_selected_configuration()
endfunction


function! kr4mb#get_index_of_selected_configuration() " {{{2
  return kr4mb#selected()
endfunction


function! kr4mb#select(idx) " {{{2
  call s:kr4mb.select_configuration_by_index(a:idx)
endfunction


function! kr4mb#select_configuration_by_index(idx) " {{{2
  call kr4mb#select(a:idx)
endfunction


function! kr4mb#select_configuration_by_name(name) " {{{2
  call s:kr4mb.select_configuration_by_name(a:name)
endfunction


function! kr4mb#changed() " {{{2
  return s:kr4mb.get_changed_settings()
endfunction


function! kr4mb#get_changed_settings() " {{{2
  return kr4mb#changed()
endfunction


function! kr4mb#enable(identifier) " {{{2
  call s:kr4mb.enable_remap(a:identifier)
endfunction


function! kr4mb#enable_some(identifiers) " {{{2
  for _ in a:identifiers
    call s:kr4mb.enable_remap(_)
  endfor
endfunction


function! kr4mb#disable(identifier) " {{{2
  call s:kr4mb.disable_remap(a:identifier)
endfunction


function! kr4mb#disable_some(identifiers) " {{{2
  for _ in a:identifiers
    call s:kr4mb.disable_remap(_)
  endfor
endfunction


function! kr4mb#toggle(identifier) " {{{2
  call s:kr4mb.toggle_remap(a:identifier)
endfunction


function! kr4mb#toggle_some(identifiers) " {{{2
  for _ in a:identifiers
    call s:kr4mb.toggle_remap(_)
  endfor
endfunction




" Core {{{1

function! s:kr4mb.get_configuration_names() " {{{2
  return split(system(self.get_command_path() . ' list'), '\n')
endfunction


function! s:kr4mb.get_index_of_selected_configuration() " {{{2
  return str2nr(system(self.get_command_path() . ' selected'))
endfunction


function! s:kr4mb.get_name_of_selected_configuration() " {{{2
  let idx = system(self.get_command_path() . ' selected')
  return self.get_configuration_list()[idx]
endfunction


function! s:kr4mb.select_configuration_by_index(idx) " {{{2
  call system(self.get_command_path() .' select ' . a:idx)
endfunction


function! s:kr4mb.select_configuration_by_name(name) " {{{2
  let config_list = self.get_configuration_names()
  let idx = index(config_list, a:name)
  if idx == -1
    throw s:create_exception_message('"' . a:name . '" dose not exist in configuration list.')
  endif
  call self.select_configuration_by_index(idx)
endfunction


function! s:kr4mb.get_changed_settings() " {{{2
  let settings = split(system(self.get_command_path() . ' changed'), '\n')
  let ret = []
  for setting in settings
    let _ = matchlist(setting, '^\(.*\)=\(.*\)$')
    call add(ret, {'id': _[1], 'value': _[2]})
  endfor
  return ret
endfunction


function! s:kr4mb.enable_remap(identifier) " {{{2
  let identifier = self.reflect_alias(a:identifier)
  call system(self.get_command_path() . ' enable ' . identifier)
endfunction


function! s:kr4mb.disable_remap(identifier) " {{{2
  let identifier = self.reflect_alias(a:identifier)
  call system(self.get_command_path() . ' disable ' . identifier)
endfunction


function! s:kr4mb.toggle_remap(identifier) " {{{2
  let identifier = self.reflect_alias(a:identifier)
  if self.enable_p(identifier)
    call self.disable_remap(identifier)
  else
    call self.enable_remap(identifier)
  endif
endfunction




" Misc {{{1

function! s:create_exception_message(message) " {{{2
  return printf('%s: %s', s:PLUGIN_NAME, a:message)
endfunction


function! s:kr4mb.reflect_alias(identifier) " {{{2
  return get(self.get_identifier_aliases(), a:identifier, a:identifier)
endfunction


function! kr4mb#complete_identifiers(arg_lead, cmd_line, cursor_pos) " {{{2
  let comp_list = keys(s:kr4mb.get_identifier_aliases())
  let input_identifiers = split(a:cmd_line)[1:]
  call filter(comp_list, '!s:has_value_p(input_identifiers, v:val)')
  call filter(comp_list, 'v:val =~# a:arg_lead')

  return comp_list
endfunction


function! s:has_value_p(var, val) " {{{2
  let _ = copy(a:var)
  if type(_) == type({}) || type(_) == type([])
    return !empty(filter(_, 'v:val == a:val'))
  endif
  throw s:create_exception_message('Variable type is incorrect.')
endfunction


function! s:kr4mb.enable_p(identifier) " {{{2
  let enable_settings = self.get_changed_settings()
  let _ = map(enable_settings, 'v:val.id')
  return s:has_value_p(_, a:identifier)
endfunction


" Variable operation . {{{2

function! s:kr4mb._get_value(property, ...) " {{{3
  let ctx = exists('a:1') ? a:1 : self._variables_
  return get(ctx, a:property)
endfunction

function! s:kr4mb._set_value(property, value, ...) " {{{3
  let ctx = exists('a:1') ? a:1 : self._variables_
  let ctx[a:property] = a:value
endfunction

function! s:kr4mb._define_accessor(type, property, ...) " {{{3
  let optional_args = exists('a:1') ? copy(a:1) : {}
  let optional_args_default_values = {
        \  'is_hide': s:FALSE,
        \  'is_pred': s:FALSE,
        \  'args': '',
        \  'access_property': '',
        \  'ctx': ''
        \ }
  let options = extend(optional_args_default_values, optional_args)

  if a:type ==# 'accessor'
    call self.__define_getter(a:property, options)
    call self.__define_setter(a:property, options)
  elseif a:type ==# 'getter'
    call self.__define_getter(a:property, options)
  elseif a:type ==# 'setter'
    call self.__define_setter(a:property, options)
  endif
endfunction

function! s:kr4mb.__define_getter(property, options) " {{{3
  execute printf("function! s:kr4mb.%s%s(%s)\n
        \   return self._get_value(%s%s)\n
        \ endfunction",
        \
        \ a:options.is_hide ? '_' : '',
        \ a:options.is_pred ? substitute(a:property, '^is_\(.*\)$', '\1_p', '') : 'get_' . a:property,
        \ !empty(a:options.args) ? join(a:options.args, ', ') : '',
        \ a:options.access_property != '' ? a:options.access_property :  "'" . a:property . "'",
        \ a:options.ctx != '' ? ', ' . a:options.ctx : '')
endfunction

function! s:kr4mb.__define_setter(property, options) " {{{3
  execute printf("function! s:kr4mb.%sset_%s(%svalue)\n
        \   return self._set_value(%sa:value%s)\n
        \ endfunction",
        \
        \ a:options.is_hide ? '_' : '',
        \ a:options.is_pred ? substitute(a:property, '^is_\(.*\)$', '\1', '') : a:property,
        \ !empty(a:options.args) ? join(a:options.args, ', ') . ', ' : '',
        \ a:options.access_property != '' ? a:options.access_property . ', ' :  "'" . a:property . "', ",
        \ a:options.ctx != '' ? ', ' . a:options.ctx : '')
endfunction




" Init {{{1

call s:kr4mb.__init__()




" Epilogue {{{1

let &cpoptions = s:save_cpoptions
unlet s:save_cpoptions




" __END__ {{{1
" vim: foldmethod=marker
