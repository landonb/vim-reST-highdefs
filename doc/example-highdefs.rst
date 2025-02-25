@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
``vim-reST-highdefs`` visual text
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

Special Punctuation
===================

TESTR: Emails, hostnames, #tags, $vars are highlighted and not spell-checked:

  user@domain.com       *EmailNoSpell*
  @host                 *AtHostNoSpell*
  #tag                  *PoundTagNoSpell*
  #1b but not #1 #2.    *PoundTagNoAllnums*
  $money-is-funny       *ISeeDollarSignsNoSpell*
  ~~ope~~               *StrikethroughNoSpell*

- For example::
    StrikethroughNoSpell ───────────────────────────────────┐
    ISeeDollarSignsNoSpell ────────────────────┐            │
    PoundTagNoSpell ─────────────────┐         │            │
    PoundTagNoAllnums ───────────────┤         │            │
    AtHostNoSpell ─────────┐         │         │            │
    EmailNoSpell ┐         │         │         │            │
  +===================+=========+========+===========+=============+
  |   EmailNoSpell_   |  AHNS_  |  PTNS_ |  ISDSNS_  |    StNS_    |
  +===================+=========+========+===========+=============+
  |  user@domain.com  |  @host  |  #tag  |  $$dolla  | ~~ sthru ~~ |
  | <user@domain.com> | <@host> | <#t-g> | <$fru-ty> | <~~sthru~~> |
  | [user@domain.com] | [@host] | [#t_g] | [$buck_t] | [~~sthru~~] |
  | (user@domain.com) | (@host) | (#t.g) | ($of.brn) | (~~sthru~~) |
  | {user@domain.com} | {@host} | {#t/g} | {$bran/z} | {~~sthru~~} |
  +-------------------+---------+--------+-----------+-------------+
  |  user@domain.fail |  @@nay  |  ##no  |  $1,000!  | ~~ nope ~   |
  |                   |         | no: #9 |  $123/mg  |  ~ nope ~~  |
  |                   |         | ✗ #99. |           |             |
  +===================+=========+========+===========+=============+

Paths and URLs
==============

TESTR: *SlashPathNoSpell*: /path ~/home </a/b> [/foo] <~/bar> {/baz}
                           /doo-doo/boo_boo ./foo ../bar .../baz ..../nope

- USAGE: For file paths that start with one of: ``/ ~/ ./ ../ .../``

TESTR: *rstStandaloneHyperlinkArbitraryHosts*: file:///URLs and host:///URLs

- But must contain three slashes, e.g., not host://URL only host:///URL

TESTR: *rstStandaloneHyperlinkExtendedChrome*: chrome://and-away-we-go

- USAGE: Highlight ``chrome://`` URLs.

TESTR: *rstStandaloneHyperlinkExtendedFirefox*: about:config

- USAGE: Very-special about:config only, not about:anything else

Special IDs
===========

TESTR: *AccountNumberNoSpell*: x123 x4567 <x123> [x123] (x123) {x123}

- USAGE: An ``x`` prefix signifies an account number (e.g., at a bank)

TESTR: *VersionNumberNoSpell*: v16.14.0 v2 v1.2.3 v4.5.6a v4.5.6-dev.

- USAGE: A ``v`` prefix starts a version, with up to 3 dotted parts.

  - For example: v1 v99 v1.2 v1.2.3 v1.2.3a123 v1.2.3-dev

    - Note the pattern isn't too savvy — it'll match the first
      part of v1.2.3.4 but leave the ".4" sitting alone, plain.

  - And without the 'v', the string is unadorned and not spell-checked.

    - For example: 1.2.3 4.5.6a 4.5.6-dev 7.8.9-mispelled

TESTR: *GitObjectIdNoSpell*: ffb02e651ef8dfdf6ba189b76c8a2615e3b35228

- USAGE: A hexadecimal string between 7 and 40 characters is highlighted.

  - For example: ffb02e6 but not ffb02e.

Keyboard Keys
=============

TESTR: *KeyComboNoSpellSuffix*: <Shift> <Ctrl> <Cmd> <Super> <Alt> <Meta> <Fn>
                                <LShift> <LCtrl> <LCmd> <LSuper> <LAlt> <LMeta>
                                <RShift> <RCtrl> <RCmd> <RSuper> <RAlt> <RMeta>
                                <Enter> <PageUp> <PageDown> <Backspace> <Esc>
                                <Home> <End> <Insert> <Delete> <Tab> <Caps>
                                <Up> <Right> <Down> <Left>
                                <F1> <F2> ... <F8> <F9> <F10> <F11> <F12>
                                  <F13> / NOT: <F0> <F14> ...

TESTR: *KeyComboNoSpellSuffix*: <Ctrl-X> <Alt-Shift-Q> <LCmd-Q> <Super-Q> <RShift-3>
                                <Just-Joking>

- USAGE: An angle-bracketed word that starts with a known keyboard
  key is highlighted, e.g., <Ctrl-Foo> but not <Foo-Ctrl>

TESTR: *DobActGoryNoSpell* This is@Not Highlighted <But This@Is High>

-------

Special Words
=============

TESTR: *AcronymNoSpell*: FIVERs SIXESes FIVERed are not spell-checked,
                         but YIPPEe is spell-checked

- USAGE: You can make FIVER plural or past tense/past participle

TESTR: *PasswordPossibly*: IamONElongP4sSWoRd [16-24 chars. mixed case + number]

- USAGE: Disabled in files >= 1k lines, per ``g:RstHighDefs_PasswordThreshold``

-------

FIVER Words
===========

.. CXREF: If vim-reST-highfive is installed in DepoXy env., see:
   ~/.kit/nvim/landonb/vim-reST-highfive/after/syntax/rst.vim

TESTR: *FIVERsPunctuated*: 12E45/ and ABCDE: alt. <WORKS/> [SAVVY:] (RECAP/) {CRIPE:}

- USAGE: Any FIVER followed by ``/`` or ``:`` is highlighted.

TESTR: *FIVERsPunctuatedNoAllnums*: Not 12345: 42069/ etc.

- USAGE: An all-numbers FIVER is ignored.

TESTR: *FIVERsAlways_Hot*: MAYBE AWAIT

- USAGE: These 2 FIVERs are always highlighted without ``/`` or ``:``.

TESTR: *FIVERWordsXXXXDs*: FIXED ANNUL NOTED COPYD ORDRD SNIPD RECVD SPOKE WAITD

- USAGE: These 8 FIVERs are always rendered with strikethrough.

