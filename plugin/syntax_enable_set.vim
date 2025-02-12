" vim:tw=0:ts=2:sw=2:et:norl:
" Author: Landon Bouma <https://tallybark.com/>
" Project: https://github.com/landonb/vim-reST-highdefs#🎨
" License: https://creativecommons.org/publicdomain/zero/1.0/
" Summary: Vim syntax highlights enablement.

" -------------------------------------------------------------------

" GUARD: Press <F9> to reload this plugin (or :source it).
" - Via: https://github.com/embrace-vim/vim-source-reloader#↩️

if expand('%:p') ==# expand('<sfile>:p')
  unlet! g:loaded_rest_highdefs_syntax_enable_set
endif

if exists('g:loaded_rest_highdefs_syntax_enable_set') || &cp

  finish
endif

let g:loaded_rest_highdefs_syntax_enable_set = 1

" -------------------------------------------------------------------

" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" Syntax enable
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

" Enable syntax highlighting
" ------------------------------------------------------
" Syntax is enabled by default in Windows, but not in Linux.

syntax enable

