" File: dubs_rest_fold/after/ftplugin/rst.vim
" Author: Landon Bouma (landonb &#x40; retrosoft &#x2E; com)
" Project Page: https://github.com/landonb/dubs_rest_fold
" Summary: Additional reST syntax highlighting
" License: GPLv3
" vim:tw=0:ts=2:sw=2:et:norl:
" -------------------------------------------------------------------
" Copyright © 2017-2018 Landon Bouma.
"
" This file is part of Dubs Vim.
"
" Dubs Vim is free software: you can redistribute it and/or
" modify it under the terms of the GNU General Public License
" as published by the Free Software Foundation, either version
" 3 of the License, or (at your option) any later version.
"
" Dubs Vim is distributed in the hope that it will be useful,
" but WITHOUT ANY WARRANTY; without even the implied warranty
" of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See
" the GNU General Public License for more details.
"
" You should have received a copy of the GNU General Public License
" along with Dubs Vim. If not, see <http://www.gnu.org/licenses/>
" or write Free Software Foundation, Inc., 51 Franklin Street,
"                     Fifth Floor, Boston, MA 02110-1301, USA.
" ===================================================================

" 2018-12-07: See the reST syntax file included with Vim:
"   /srv/opt/bin/share/vim/vim81/syntax/rst.vim
" And the more current upstream source of the same:
"   https://github.com/marshallward/vim-restructuredtext

if exists("b:did_dubs_rest_fold_after_syntax_rst")
  finish
endif
let b:did_dubs_rest_fold_after_syntax_rst = 1

" +----------------------------------------------------------------------+

" reST header syntax can use any of the 32 punctation keys found on a US keyboard:
"
"   ! " # $ % & ' ( ) * + , - . / : ; < = > ? @ [ \ ] ^ _ ` { | } ~
"
" The documentation recommends using a subset of those, because "some characters
" are more suitable than others":
"
"   = - ` : . ' " ~ ^ _ * + #
"
" Omitted from included rst syntax runtime:
"
"   ! $ % & ( ) , / ; < > ? @ [ \ ] { | }
"
" Although I'd respond that that's really user preference, and that the syntax
" plugin should honor what reST itself honors. (I'd concede this might not be
" the case if certain punctuation is used in a way that's not for headerizing,
" but that might be interpreted as such, e.g., a merge conflict uses angle
" brackets in such a way:
"
"   <<<<<<<<<<<<<<
"   some code
"   ==============
"   other code
"   >>>>>>>>>>>>>>
"
" and we wouldn't want any of this to be interpreted as headerization.
" (But such code would most likely be in a block quote, anyway.)
"
" I'm adding in the missing punctuation and we'll see how it goes.
"
" (What I really want is a few more 'Big' symbols that'll look good
" as the main, top-level section. I currently use '#', which is the
" character that uses the most ink of all available characters. But
" I think '$', '@', and '&' could also work to convey main-sectionness.)

syn clear rstSections

" NOTE: `-` must come last so it is not interpreted as range.
"
" NOTE: `+` does not highlight when used both below and above,
"             because it's interpreted as rstTableLines.
"
" This adds the missing punctuation: !@$%&()[]{}<>/\|,;?
"
" :h pattern-overview
" |/\v|  \v  \v  the following chars in the pattern are "very magic"
" \%(\)	A pattern enclosed by escaped parentheses.	*/\%(\)* */\%(* *E53*
" 	Just like \(\), but without counting it as a sub-expression.  This
" 	allows using more groups and it's a little bit faster.
"
"syn match rstSections "\v^%(([=`:.'"~^_*+#!@$%&()[\]{}<>/\\|,;?-])\1+\n)?.{1,2}\n([=`:.'"~^_*+#!@$%&()[\]{}<>/\\|,;?-])\2+$" contains=@Spell

let s:expensiveSectionRegex = '\v^%(([=`:.''"~^_*+#!@$%&()[\]{}<>/\\|,;?-])\1{2,}\n)?.{3,}\n([=`:.''"~^_*+#!@$%&()[\]{}<>/\\|,;?-])\2{2,}$'
" 2018-09-19: Without dash "-" in first word of reST section title, before any whitespace, not matching! WTF!!
execute 'syn match rstSections "' . s:expensiveSectionRegex . '" contains=@Spell'
" 2018-09-19: Without dash "-" in first word of reST section title, before any whitespace, not matching! WTF!!
execute 'autocmd BufEnter,BufRead *.rst syn match rstSections "' . s:expensiveSectionRegex . '" contains=@Spell'

" +----------------------------------------------------------------------+

" 2018-02-01: NOICE! Ignore spelling of URLs and ACRONYMs. And highlight PWDs?

" *** Passwords first, so URL and Email matches override.

" Match "passwords" (why would you have those in a text file??).
" Inspired by:
"   https://dzone.com/articles/use-regex-test-password
"   var strongRegex = new RegExp(
"     "^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#\$%\^&\*])(?=.{8,})"
"   );
" But completely Vimified! E.g., Perl's look-ahead (?=) is Vim's \(\)\@=
" HINT: To test, run ``syn clear``, then try the new ``syn match``.
" NOTE: \@= is Vim look-ahead. I also trie \@<= look-behind but it didn't work for me.
" NOTE: Do this before EmailNoSpell, so that we don't think emails are passwords.
" NOTE: Trying {15,16} just to not match too much.
" CUTE: If I misspell a normal FIXME/YYYY-MM-DD comment, e.g.,
"       "FiXME/2018-03-21", then it gets highlighted as a password! So cute!!
syn match Password15Good '\([[:space:]\n]\)\@<=\([^[:space:]]*[a-z][^[:space:]]*\)\@=\([^[:space:]]*[A-Z][^[:space:]]*\)\@=\([^[:space:]]*[0-9][^[:space:]]*\)\@=\<[^[:space:]]\{15,16\}\([[:space:]\n]\)\@=' contains=@NoSpell
" NOTE: We don't need a Password15Best to include special characters unless
"       we wanted to color them differently; currently, such passwords will
"       match Password15Good.
hi def Password15Good term=reverse guibg=DarkRed guifg=Yellow ctermfg=1 ctermbg=6

" *** URLs, Acronyms, Emails

" Thanks!
"   http://www.panozzaj.com/blog/2016/03/21/
"     ignore-urls-and-acroynms-while-spell-checking-vim/

" WEIRD: Why did I make this filter? Oh! Because that new Vim syntax code I
"   tried (vim-restructuredtext) was not highlighting URLs? Or was it, and I
"   just did notnotice? In any case, the Vim system rst.vim syntax
"   highlighter hsa a rstStandaloneHyperlink group, which we don't want
"   to override.
" `Don't mark URL-like things as spelling errors`
"syn match UrlNoSpell '\w\+:\/\/[^[:space:]]\+' contains=@NoSpell

" `Don't count acronyms / abbreviations as spelling errors
"  (all upper-case letters, at least three characters)
"  Also will not count acronym with 's' at the end a spelling error
"  Also will not count numbers that are part of this`
syn match AcronymNoSpell '\<\(\u\|\d\)\{3,}s\?\>' contains=@NoSpell

" (lb) added this one to ignore emails@somewhere.com.
" NOTE: Look-behind: \([[:space:]\n]\)\@<= ensures space or newline precedes match.
" NOTE: Look-ahead:  \([[:space:]\n]\)\@=  ensures space or newline follows  match.
syn match EmailNoSpell '\([[:space:]\n]\)\@<=\<[^[:space:]]\+@[^[:space:]]\+\.com\([[:space:]\n]\)\@=' contains=@NoSpell
hi def EmailNoSpell guifg=LightGreen

" +----------------------------------------------------------------------+

" 2018-01-30: NUTS!
"
"   This is pretty cool. And it only serves one purpose:
"     Making me color-happy when reSTing.
"   That is, if I repeat the same character 8 or more times
"     on its own line, it'll be highlighted!
"   You can fiddle with the highlights for specific characters
"     below.
"   In this way, you can create more visually appealing reST
"     documents, and you can more easily highlight section
"     headers, as well as section delimiters!

" - Our match interferes with rstSections, whether it's defined before or
"   after, and I'm not sure what's up, so only highlight when HR is followed
"   by newlines, to avoid conflict.
"   - (And note that `\n\n` sorta works, but the highlight only works if
"      there are two trailing blank lines; whereas using just `\n` works,
"      but then the top line of a real section header gets hijack-highlighted
"      (the top line of the header should be rstSections like the header
"      title and the bottom line of the header, but instead the top line
"      gets a rstFakeHRAll match).
"
" - Note that the captured (.) character \1 matches case-insensitively.
"   - E.g., `e` will match `E`, so
"       EEeeeeEEEEEEeee
"     will match.
"   - There's probably a way to match case-sensitively but meh.
"
" Match lines with the same character repeating 8 or more times,
" with optional preceding and trailing whitespace.
syn match rstFakeHRAll   '^\s*\(.\)\1\{8,}\s*\n$'
" Match lines of repeating `|`s.
syn match rstFakeHRPipes '^\s*|\{8,}\s*\n$'
" Match lines of repeating `$`s.
syn match rstFakeHRBills '^\s*\$\{8,}\s*\n$'
" Match lines of repeating `*`s.
syn match rstFakeHRStars '^\s*\*\{8,}\s*\n$'
" Match lines of repeating `(`s or `)`s.
syn match rstFakeHRParns '^\s*[()]\{8,}\s*\n$'
" Match lines of repeating `%`s.
syn match rstFakeHRPercs '^\s*%\{8,}\s*\n$'

" Orange-yellow: Statement, or Keyword
hi! def link rstFakeHRAll   Statement
" More orangy (darker than orange-yellow)
hi! def link rstFakeHRStars Delimiter
" Light pinkish-orangish-reddish
hi! def link rstFakeHRPercs String
" Green: Type, or Question
hi! def link rstFakeHRPipes Question
" White on baby blue
hi! def link rstFakeHRParns MatchParen
" Black on baby blue
hi def rstHorizRuleUser01 term=reverse guibg=DarkCyan guifg=Black ctermfg=1 ctermbg=6
hi! def link rstFakeHRBills rstHorizRuleUser01

" 2018-09-24: (lb): Hmmm. Syntax highlighting randomly “not working”,
" appears to be that it's not enabled on load. I cannot find anything in Dubs,
" or in any plugin that's calling `syntax on|off|enable`. So I'm guessing
" Vim does it automatically, but if syntax highlighting is taking too long,
" it abandons the operation. / I tried hooking BufRead to enable syntax
" highlighing, but that did nothing; and I tried using BufEnter, e.g.,
"   autocmd BufEnter *.rst syn enable
" but that causes a long “pause” when switching buffers into a long, few
" K lines- long reST file. So that's not an option. (And I don't think it's a
" slow syntax parse operation, because running "syn on" on its own does not
" take as long as a BufEnter syn-on. Something else fishy is happening.) /
" Finally, I'm not sure what changed; syntax highlighting had been working
" fine and fast on reST files up to 10K lines, but today I've noticed these
" issues! / Trying what ":help syntax" suggests: map syntax enable, for when
" it's not automatic. But not the toggle version:
"   map <F7> :if exists("g:syntax_on") <Bar>
"   	\   syntax off <Bar>
"   	\ else <Bar>
"   	\   syntax enable <Bar>
"   	\ endif <CR>
"map <F7> :syn on<CR>
map <F7> :syn enable<CR>
" NOTE: A trick for reload syntax highlighting: ":e", to edit the file anew.

