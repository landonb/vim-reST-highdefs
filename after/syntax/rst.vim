" Nonstandard syntax highlights so you can manage notes in Vim with reST
" Author: Landon Bouma (landonb &#x40; retrosoft &#x2E; com)
" Project: https://github.com/landonb/vim-reST-highdefs#🎨
" License: GPLv3
"  vim:tw=0:ts=2:sw=2:et:norl:

" +----------------------------------------------------------------------+

" REF: See complementary reST highlights plugins from this author
"      (pairs well with this plugin to help you take notes in Vim):
"
"   https://github.com/landonb/vim-reSTfold#🙏
"   https://github.com/landonb/vim-reST-highdefs#🎨
"   https://github.com/landonb/vim-reST-highfive#🖐
"   https://github.com/landonb/vim-reST-highline#➖

" REF: See the reST syntax file included with Vim.
" - E.g.:
"     /usr/share/vim/vim81/syntax/rst.vim
"   Or maybe:
"     ${HOME}/.local/share/vim/vim81/syntax/rst.vim
" See also the most current upstream source of the same:
"   https://github.com/marshallward/vim-restructuredtext

" +----------------------------------------------------------------------+

" *** DEV. UTIL. FCN.: Log message to file (b/c `echom` doesn't work from syntax).

" 2018-12-07: Log to file, inspired by lervag@github: b/c cannot echom from syntax file?
"   https://github.com/lervag/dotvim/blob/master/personal/plugin/log-autocmds.vim
function! s:log(message)
  silent execute '!echo "'
    \ . strftime('%T', localtime()) . ' - ' . a:message . '"'
    \ '>> /tmp/vim_log_dubs_after_syntax_rst'
endfunction

" NOTE: [lb]: I can `call s:log('...')` and `tail -F /tmp/vim_log_dubs_after_syntax_rst`
"       successfully. But I cannot `echom '...'` anything. Not sure why.

" +----------------------------------------------------------------------+

" *** SYNTAX HIGHLIGHT: Passwords.

" 2018-12-07: Syntax Profiling: Top performance drag: PasswordPossibly.
"
" [lb]: On a 7k-line file that takes 5.5 secs. to parse, PasswordPossibly eats 1.75 s!
" (To test: `:syntime clear`, `:syntime on`, open the reST document, read the results
" using `:TabMessage syntime report`.)
"
" USAGE: 16-24 character word with at least 1 each: lower, upper, 0-9.
"        - Special characters allowed (encouraged!) but don't matter.
"          - It's assumed you're unlikely to use 16-24 character-long
"            camelCase l33t words for anything else (or let us know if
"            you do).
"        - Caveat: Ignores strings that start with `` (two ticks), which is a reST ``code snip``.
"
function! s:DubsSyn_PasswordPossibly()
  " Match password-looking sequences (not that we expect you to have passwords
  " in plain text files, so consider the highlight as a warning — that, or the
  " highlight is being used by a `pass edit` command, in which case a password
  " highlight is a nicety).
  " - Inspired by:
  "     https://dzone.com/articles/use-regex-test-password
  "   var strongRegex = new RegExp(
  "     "^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#\$%\^&\*])(?=.{8,})"
  "   );
  " But completely Vimified! E.g., Perl's look-ahead (?=) is Vim's \(\)\@=
  " HINT: To test, run `syn clear`, then try the new `syn match`.
  " NOTE: \@= is Vim look-ahead. I also tried \@<= look-behind but it didn't work for me.
  " NOTE: Do this before EmailNoSpell, so that we don't think emails are passwords.
  " NOTE: Trying {15,16} just to not match too much.
  " CUTE: If I misspell a normal FIXME/YYYY-MM-DD comment, e.g.,
  "       "FiXME/2018-03-21", then it gets highlighted as a password! So cute!!
  " TRYME:
  "  :echo matchstr('IamONElongP4sSWoRd', '\%(^\|[[:space:]]\|\n\)\zs\%([^`]\{2\}\)\@=\%([^[:space:]]*[a-z]\)\@=\%([^[:space:]]*[A-Z]\)\@=\%([^[:space:]]*[0-9]\)\@=[^[:space:]]\{16,24\}\%([[:space:]]\|\n\|$\)\@=')
  syn match PasswordPossibly '\%(^\|[[:space:]]\|\n\)\zs\%([^`]\{2\}\)\@=\%([^[:space:]]*[a-z]\)\@=\%([^[:space:]]*[A-Z]\)\@=\%([^[:space:]]*[0-9]\)\@=[^[:space:]]\{16,24\}\%([[:space:]]\|\n\|$\)\@=' contains=@NoSpell
  " NOTE: We don't need a Password15Best to include special characters unless
  "       we wanted to color them differently; currently, such passwords will
  "       match PasswordPossibly.
  hi def PasswordPossibly term=reverse guibg=DarkRed guifg=Yellow ctermfg=1 ctermbg=6
endfunction

" +----------------------------------------------------------------------+

" *** SYNTAX HIGHLIGHT: Browser config hyperlinks.

" Copied rstStandaloneHyperlink from marshallward/opt/vim-restructuredtext/syntax/rst.vim
" and made it work on URLs like chrome://extensions/shortcuts and about:config.
function! s:DubsSyn_rstStandaloneHyperlinkExtended()
  syn match rstStandaloneHyperlinkExtendedChrome contains=@NoSpell
      \ "\<chrome://[^[:space:]'\"<>]\+"
  hi def link rstStandaloneHyperlinkExtendedChrome Identifier

  syn match rstStandaloneHyperlinkExtendedFirefox contains=@NoSpell
      \ "\<about:config\>"
  hi def link rstStandaloneHyperlinkExtendedFirefox Identifier
endfunction

" +----------------------------------------------------------------------+

" *** SYNTAX HIGHLIGHT: Email Addys, Without Spelling Error Highlight.

" Syntax Profiling: EmailNoSpell takes second longest, behind DubsSyn_PasswordPossibly.
" (From a 7K line reST that takes 3.76 secs. to load, EmailNoSpell consumes 0.21 secs.)

function! s:DubsSyn_EmailNoSpell()
  " (lb) added this to ignore spelling errors on words such as `emails@somewhere.com`.
  " NOTE: Look-behind: \(^\|[[:space:]]\|\n\|<\)\zs
  "         ensures start of line, space, newline, or  left angle precedes match.
  "   Profiling: Vim docs suggest using \zs to start match, and not look-behind.
  " NOTE: Look-ahead:  \([^[:alnum:]]\|\n\)\@=
  "         ensures not an alphanum or newlinefollows match.
  "   Profiling: I tested \ze to end match, replacing look-ahead \@=, but not faster.
  " TRYME:
  "  :echo matchstr( 'user@domain.com',  '\%(^\|[[:space:]]\|\n\|<\|\[\|(\|{\)\zs\<[^[:space:]]\+@[^[:space:]]\+\.\%(com\|org\|edu\|us\|io\)\%([^[:alnum:]]\|\n\|$\)\@=')
  "  :echo matchstr(' user@domain.com ', '\%(^\|[[:space:]]\|\n\|<\|\[\|(\|{\)\zs\<[^[:space:]]\+@[^[:space:]]\+\.\%(com\|org\|edu\|us\|io\)\%([^[:alnum:]]\|\n\|$\)\@=')
  "  :echo matchstr('<user@domain.com>', '\%(^\|[[:space:]]\|\n\|<\|\[\|(\|{\)\zs\<[^[:space:]]\+@[^[:space:]]\+\.\%(com\|org\|edu\|us\|io\)\%([^[:alnum:]]\|\n\|$\)\@=')
  "  :echo matchstr('[user@domain.com]', '\%(^\|[[:space:]]\|\n\|<\|\[\|(\|{\)\zs\<[^[:space:]]\+@[^[:space:]]\+\.\%(com\|org\|edu\|us\|io\)\%([^[:alnum:]]\|\n\|$\)\@=')
  "  :echo matchstr('(user@domain.com)', '\%(^\|[[:space:]]\|\n\|<\|\[\|(\|{\)\zs\<[^[:space:]]\+@[^[:space:]]\+\.\%(com\|org\|edu\|us\|io\)\%([^[:alnum:]]\|\n\|$\)\@=')
  "  :echo matchstr('{user@domain.com}', '\%(^\|[[:space:]]\|\n\|<\|\[\|(\|{\)\zs\<[^[:space:]]\+@[^[:space:]]\+\.\%(com\|org\|edu\|us\|io\)\%([^[:alnum:]]\|\n\|$\)\@=')
  syn match EmailNoSpell '\%(^\|[[:space:]]\|\n\|<\|\[\|(\|{\)\zs\<[^[:space:]]\+@[^[:space:]]\+\.\%(com\|org\|edu\|us\|io\)\%([^[:alnum:]]\|\n\|$\)\@=' contains=@NoSpell
  hi def EmailNoSpell guifg=LightGreen
endfunction

" +----------------------------------------------------------------------+

" *** SYNTAX HIGHLIGHT: @hostnames.

function! s:DubsSyn_AtHostNoSpell()
  " (lb) added this to ignore spelling errors on words such as `@somehost`,
  " which is a convention I've been using recently to identify what could
  " also be referred to as ``host``, but @host is cleaner.
  " NOTE: Look-behind: \([[:space:]\n]\)\@<= ensures space or newline precedes match.
  "   Profiling: Vim docs suggest using \zs to start match, and not look-behind.
  " NOTE: Look-ahead:  \([[:space:]\n]\)\@=  ensures space or newline follows match.
  " TRYME:
  "  :echo matchstr( '@host',  '\%(^\|[[:space:]]\|\n\|<\|\[\|(\|{\)\zs@[[:alnum:]]\+\%([^[:alnum:]]\|\n\|$\)\@=')
  "  :echo matchstr(' @host ', '\%(^\|[[:space:]]\|\n\|<\|\[\|(\|{\)\zs@[[:alnum:]]\+\%([^[:alnum:]]\|\n\|$\)\@=')
  "  :echo matchstr('<@host>', '\%(^\|[[:space:]]\|\n\|<\|\[\|(\|{\)\zs@[[:alnum:]]\+\%([^[:alnum:]]\|\n\|$\)\@=')
  "  :echo matchstr('[@host]', '\%(^\|[[:space:]]\|\n\|<\|\[\|(\|{\)\zs@[[:alnum:]]\+\%([^[:alnum:]]\|\n\|$\)\@=')
  "  :echo matchstr('(@host)', '\%(^\|[[:space:]]\|\n\|<\|\[\|(\|{\)\zs@[[:alnum:]]\+\%([^[:alnum:]]\|\n\|$\)\@=')
  "  :echo matchstr('{@host}', '\%(^\|[[:space:]]\|\n\|<\|\[\|(\|{\)\zs@[[:alnum:]]\+\%([^[:alnum:]]\|\n\|$\)\@=')
  syn match AtHostNoSpell '\%(^\|[[:space:]]\|\n\|<\|\[\|(\|{\)\zs@[[:alnum:]]\+\%([^[:alnum:]]\|\n\|$\)\@=' contains=@NoSpell
  " Both LightMagenta and LightRed look good here. Not so much any other Light's.
  hi def AtHostNoSpell guifg=LightMagenta
endfunction

" +----------------------------------------------------------------------+

" *** SYNTAX HIGHLIGHT: #tags.

function! s:DubsSyn_PoundTagNoSpell()
  " TRYME:
  "  :echo matchstr( '#tag',  '\%(^\|[[:space:]]\|\n\|<\|\[\|(\|{\)\zs#[[:alnum:]]\+\%([^[:alnum:]]\|\n\|$\)\@=')
  "  :echo matchstr(' #tag ', '\%(^\|[[:space:]]\|\n\|<\|\[\|(\|{\)\zs#[[:alnum:]]\+\%([^[:alnum:]]\|\n\|$\)\@=')
  "  :echo matchstr('<#tag>', '\%(^\|[[:space:]]\|\n\|<\|\[\|(\|{\)\zs#[[:alnum:]]\+\%([^[:alnum:]]\|\n\|$\)\@=')
  "  :echo matchstr('[#tag]', '\%(^\|[[:space:]]\|\n\|<\|\[\|(\|{\)\zs#[[:alnum:]]\+\%([^[:alnum:]]\|\n\|$\)\@=')
  "  :echo matchstr('(#tag)', '\%(^\|[[:space:]]\|\n\|<\|\[\|(\|{\)\zs#[[:alnum:]]\+\%([^[:alnum:]]\|\n\|$\)\@=')
  "  :echo matchstr('{#tag}', '\%(^\|[[:space:]]\|\n\|<\|\[\|(\|{\)\zs#[[:alnum:]]\+\%([^[:alnum:]]\|\n\|$\)\@=')
  syn match PoundTagNoSpell '\%(^\|[[:space:]]\|\n\|<\|\[\|(\|{\)\zs#[[:alnum:]]\+\%([^[:alnum:]]\|\n\|$\)\@=' contains=@NoSpell
  hi def PoundTagNoSpell guifg=Green
endfunction

" +----------------------------------------------------------------------+

" *** SYNTAX HIGHLIGHT: Dob <Act@Gories>.

" CXREF:
"
"   https://github.com/tallybark/dob

function! s:DubsSyn_DobActGoryNoSpell()
  " TRYME:
  "  :echo matchstr('<Dob Activity@Dob Category>', '<\zs\%([[:alnum:]]\| \)\+@\%([[:alnum:]]\| \)\+>\@=')
  syn match DobActGoryNoSpell '<\zs\%([[:alnum:]]\| \)\+@\%([[:alnum:]]\| \)\+>\@=' contains=@NoSpell
  hi def DobActGoryNoSpell guifg=Orange
endfunction

" +----------------------------------------------------------------------+

" HINT: If syntax highlighting appears disabled, even if the file has
" a Vim mode line saying otherwise, trying closing and reopening the
" file, or saving the file and running the `:e` command, or try this:
"
"     set rdt=9999
"     doautocmd Syntax
"     " Also works:
"     syn on

" 2021-01-16: This syntax plugin had been opt-in per file: you'd have
" to set redrawtimeout to something other than 2000 to enable these
" highlights. I think I was doing this because of performance issues
" with some of my reST files. But I'm no longer sure that's the case,
" or, if it was, it was probably on large files, and I've been in the
" habit recently of keeping files under 10,000 lines. Also, it's been
" annoying me that new rst files don't have these highlights enabled
" until I notice and remember to add a modeline.
"   So let's require users to opt-out instead!
"
" - tl;dr I'd rather this work on new files and without requiring modeline.
"
" YOU: To opt-out, set redrawtimeout (rdt) to something less than 4999
"      but not 2000 (the default).
"
"      - E.g., to disable these highlights (and their associated
"        computational overhead), add a modeline like this atop
"        each reST file you want to opt-out:
"
"          .. vim:rdt=2001
"
"      - Otherwise, to have syntax highlighting enabled, use either
"        the default value:
"
"          .. vim:rdt=2000
"
"        or set it 5000 or larger:
"
"          .. vim:rdt=5000
"          .. vim:rdt=9999
"
" MAGIC: The 4999 below is arbitrary. (2021-01-16: And I
"        haven't had a reason to opt-out any files yet.)

" +----------------------------------------------------------------------+

function! s:DubsRestWireBasic()
  let l:redrawtimeout = &rdt
  " MAGIC: Vim's rdt default is 2000 (2 secs.).
  let l:defaultRedrawTimeout = 2000
  " MAGIC: SYNC_ME: All the vim-reST* plugins use the same redrawtime
  "        logic: skip special highlights if rdt <= 4999 but not 2000.
  let l:syntaxEnableIfGreater = 4999

  " MAGIC: Avoid slower highlights on longer files.
  " - E.g., highlighting passwords is expensive, and really only useful
  "   for `pass edit` commands (you don't store passwords in some other
  "   text files, do you?), so only enable if fewer than, I dunno, 1k ll.
  let l:fileLineLen = line('$')
  let l:passwordThreshold = 1000

  if (l:redrawtimeout == l:defaultRedrawTimeout)
     \ || (l:redrawtimeout > l:syntaxEnableIfGreater)
    " Passwords first, so URL and Email matches override.
    if l:fileLineLen < l:passwordThreshold
      call s:DubsSyn_PasswordPossibly()
    endif
    call s:DubsSyn_rstStandaloneHyperlinkExtended()
    " Profiling: EmailNoSpell is costly.
    call s:DubsSyn_EmailNoSpell()
    call s:DubsSyn_AtHostNoSpell()
    call s:DubsSyn_PoundTagNoSpell()
    call s:DubsSyn_DobActGoryNoSpell()
  else
    silent! syn clear rstCitationReference
    silent! syn clear rstFootnoteReference
    silent! syn clear rstInlineInternalTargets
    silent! syn clear rstSubstitutionReference
  endif
endfunction

" +----------------------------------------------------------------------+

call s:DubsRestWireBasic()

