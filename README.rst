###############################################################
``vim-reST-highdefs`` |em_dash| Extended reST Syntax Highlights
###############################################################

.. |em_dash| unicode:: 0x2014 .. em dash

About This Plugin
=================

This plugin extends reStructuredText file types with syntax
highlights that this author finds useful.

Install this plugin to make it easier to manage
notes in Vim using reStructuredText markup.

Why You Might Want to Use This Plugin
=====================================

If you manage (or want to manage) your notes in Vim using
reStructuredText syntax, this plugin highlights commonly
used items (like emails) and disables spell checking on
items that shouldn't be spell checked (like emails!).

Features: Extended Highlights
=============================

The following syntax is recognized by this plugin.

Highlight: Email addresses
--------------------------

Email addresses are highlighted, and spell checking is disabled. E.g.::

  foo@bar.com

The email address domain must be one of::

  .com | .org | .edu | .us | .io

Edit the ``EmailNoSpell`` syntax rule if you'd like to add additional domains.

Highlight: Host names
---------------------

I sometimes write host names in my notes, so any word that starts with
an at sign is highlighted and not spell checked. E.g.,::

  @bingo

NoSpell: Acronyms
-----------------

I got tired of adding capitalized acronyms to the Vim dictionary, so
I created a rule to disable spell checking on any all-caps alphanumeric
word that's three or more characters long. E.g.,::

  DONTSPELLCHECKMEBRO

.. We'll see if I find that ref. funny the next time I review this doc.

Highlight: Passwords
--------------------

Anything that looks like a long, strong password will be highlighted.
We're talking 16 to 24 characters long, and contains at least one each
of lowercase, uppercase, and numeric characters (I had punctuation in
there at one point, but it makes the matching a lot slower). E.g.,::

  abcdEFGH1234wxyz

Note that you definitely don't want to store passwords in your notes,
so this highlight can be used to warn you if you accidentally do.

But really you might also find this highlight useful if you've |wired-pass-edit|_
to open `password store <https://www.passwordstore.org/>`__ entries in Vim.

.. |wired-pass-edit| replace:: wired ``pass edit``
.. _wired-pass-edit: https://github.com/landonb/password-store

Highlight: Browser config hyperlinks
------------------------------------

Pretty basic. The following URL formats will be highlighted::

  chrome://<foo>

  about:config

Usage: Set ``redrawtime``, maybe
================================

This plugin has no configuration, but you might need to configure
Vim's ``redrawtime``.

For large reST documents, you might want to add a modeline that
sets a higher timeout than the default (2000, or 2 seconds),
otherwise highlighting is stopped when the timeout is reached.

E.g., atop each reST file, add the commented modeline::

  .. vim:rdt=10000

You could also apply the setting globally from your ``~/.vimrc``
or similar.

Usage: Use magic ``redrawtime=4999`` to disable highlights
==========================================================

If you'd like to disable the extended highlights, set the
``redrawtime`` to 4999 or below (but not the default, 2000).

E.g., atop the reST file you'd like to disable the extra
highlighting on, add the commented modeline::

  .. vim:rdt=4999

This will also disable a few of the standard reST syntax
highlights that tend to take longer to process, including
citation, footnote, and substitution references, and
inline internal targets.

Tips: Related supercharged reST plugins
=======================================

Consider these complementary reST highlights plugins that pair
well with this plugin to help you take notes in Vim:

- Advanced reST document section folder.

  `https://github.com/landonb/vim-reSTfold#🙏
  <https://github.com/landonb/vim-reSTfold#🙏>`__

  Supercharge your notetaking and recordkeeping!

  Add section folding to your reST notes so you can,
  e.g., collapse a 10,000-line-long TODO file and get a
  nice high-level view of all the things you wanna do.

- Special so-called *FIVER* syntax rules.

  `https://github.com/landonb/vim-reST-highfive#🖐
  <https://github.com/landonb/vim-reST-highfive#🖐>`__

  Highlight action words.

  E.g., "FIXME" is emphasized (in bright, bold yellow), and so is
  "FIXED" (crossed-out and purple), and so are "MAYBE", "LEARN",
  "ORDER", and "CHORE", and a few other choice five-letter words.

  Why five letters? So you can use action words in section headings,
  and then the heading titles align nicely when folded.
  (So, really, it's important that the action words are all the same
  width, and not necessarily five in length, but *FIXME* is the
  uttermost developer action word, so might as well be five.)

- Simple horizontal rule highlight.

  `https://github.com/landonb/vim-reST-highline#➖
  <https://github.com/landonb/vim-reST-highline#➖>`__

  Repeat the same punctuation character 8 or more times on
  a line, and it'll be highlighted.

  Useful for adding a visual separation to your notes without
  using a reST section heading.

Installation
============

Installation is easy using the packages feature (see ``:help packages``).

To install the package such that it automatically loads on Vim startup,
use a ``start`` directory, e.g.,
::

    mkdir -p ~/.vim/pack/landonb/start
    cd ~/.vim/pack/landonb/start

Or, if you want to test the package first, make it optional instead
(see ``:help pack-add``)::

    mkdir -p ~/.vim/pack/landonb/opt
    cd ~/.vim/pack/landonb/opt

Next, clone the project to the path you chose::

    git clone https://github.com/landonb/vim-reST-highdefs.git

If you installed to the optional path, tell Vim to load the package::

   :packadd! vim-reST-highdefs

Just once, tell Vim to build the online help::

   :Helptags

Then whenever you want to reference the help from Vim, run::

   :help vim-reST-highdefs

License
=======

Copyright (c) Landon Bouma. This work is distributed
wholly under CC0 and dedicated to the Public Domain.

https://creativecommons.org/publicdomain/zero/1.0/

