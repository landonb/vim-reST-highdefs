" Nonstandard syntax highlights so you can manage notes in Vim with reST
" Author: Landon Bouma (landonb &#x40; retrosoft &#x2E; com)
" Project: https://github.com/landonb/vim-reST-highdefs#🎨
" License: GPLv3
"  vim:tw=0:ts=2:sw=2:et:norl:

" +----------------------------------------------------------------------+

" *** SYNTAX HIGHLIGHT: Acronyms.

function! s:DubsSyn_AcronymNoSpell()
  " Thanks!
  "   http://www.panozzaj.com/blog/2016/03/21/
  "     ignore-urls-and-acroynms-while-spell-checking-vim/

  " WEIRD: [lb]: Why did I make this filter? Oh! Because that new Vim syntax
  "   code I tried (vim-restructuredtext) was not highlighting URLs? Or was
  "   it working, but I just didn't notice? In any case, the Vim system
  "   rst.vim syntax highlighter has a rstStandaloneHyperlink group, which
  "   we don't want to override. Which means don't do this:
  "     " `Don't mark URL-like things as spelling errors`
  "     syn match UrlNoSpell '\w\+:\/\/[^[:space:]]\+' contains=@NoSpell

  " Do not mark acronyms or abbreviations with a spelling error highlight
  " (where an acrobbreviation is all upper-case, at least 3 letters long).
  " - Nor spell check an acronym with an 's' at the end.

  " TRYME:
  "  :echo matchstr(' I speak often of FIVERs, ',  '\%(\u\|\d\)\{3,}\%(\%(e\?s\)\|ed\)\?:\?\>')
  "  :echo matchstr(' Lass candidly of SIXESes; ', '\%(\u\|\d\)\{3,}\%(\%(e\?s\)\|ed\)\?:\?\>')
  "  :echo matchstr(' I am told not to YIPPEe; ',  '\%(\u\|\d\)\{3,}\%(\%(e\?s\)\|ed\)\?:\?\>')
  "  :echo matchstr(' last night I was FIVERed; ', '\%(\u\|\d\)\{3,}\%(\%(e\?s\)\|ed\)\?:\?\>')
  "  :echo matchstr(' today I feel FU/NDERFUL: ',  '\%(\u\|\d\)\{3,}\%(\%(e\?s\)\|ed\)\?:\?\>')
  "  :echo matchstr(' colon to double you FUNs: ', '\%(\u\|\d\)\{3,}\%(\%(e\?s\)\|ed\)\?:\?\>')
  syn match AcronymNoSpell                         '\%(\u\|\d\)\{3,}\%(\%(e\?s\)\|ed\)\?:\?\>' contains=@NoSpell
endfunction

" +----------------------------------------------------------------------+

function! s:DubsRestWireBasic()
  let l:redrawtimeout = &rdt
  " MAGIC: Vim's rdt default is 2000 (2 secs.).
  let l:defaultRedrawTimeout = 2000
  " MAGIC: SYNC_ME: All the vim-reST* plugins use the same redrawtime
  "        logic: skip special highlights if rdt <= 4999 but not 2000.
  let l:syntaxEnableIfGreater = 4999

  if (l:redrawtimeout == l:defaultRedrawTimeout)
     \ || (l:redrawtimeout > l:syntaxEnableIfGreater)
    " Acronyms first, which is loosest pattern, so that syntax highlights
    " defined in after/syntax/rst.vim files have precedence (otherwise,
    " e.g., fiver words (from vim-reST-highfive) will be not highlighted
    " properly).
    call s:DubsSyn_AcronymNoSpell()
  endif
endfunction

" +----------------------------------------------------------------------+

call s:DubsRestWireBasic()

