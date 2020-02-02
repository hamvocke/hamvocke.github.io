---
layout: post
title: Distraction-free writing with vim
tags:
    - command line
excerpt: Want to write without distractions and don't feel like buying an extra app for that? Here's how.
summary: Want to write in a beautiful, distraction-free setting without ever leaving your command line? Here's how.
image: /assets/img/uploads/goyo-vim.png
comments: true
---

I'm a sucker for aesthetics.

And for command line tools.

And for things that just do their damn job.

From time to time, I feel like writing down my thoughts. That's why this blog is a thing. My tool of choice is **vim**, a notorious command line editor that stood the test of time. It's free, ridiculously fast (if you don't slow it down with reckless plugins) and command-line based. This puts vim _very_ close to my personal sweet spot.

A few years ago, _distraction-free writers_ became a thing, beautifully designed applications with the sole purpose of letting you write stuff down. No frills. No gimmick. No distraction. Everything is presented to you, the writer, in a minimalistic design. Much like sitting in front of a typewriter, just you and the blank page. Scary!

I don't know if distraction-free writing is really going to be the game changer for you to write the next best-seller novel - or even your first blog post for what it's worth. But I do know that they're fun to use.

With vim being my editor of choice, I didn't want to switch to a different tool just to do what I could already perfectly do with vim, just in a more pleasurable design.

Luckily, vim has a good plugin system and there are some talented plugin writers out there. [Junegunn Choi](https://github.com/junegunn) has written [**goyo.vim**](https://github.com/junegunn/goyo.vim), a plugin that turns vim into a distraction-free writer as soon as you type `:Goyo`:

[![goyo.vim in action](/assets/img/uploads/goyo-vim.png)_goyo.vim in action_](/assets/img/uploads/goyo-vim.png){:target="_blank"}

If you need some distraction for your distraction-free writing, go and check out [**limelight.vim**](https://github.com/junegunn/limelight.vim), written by the same author. limelight.vim will highlight the region around your cursor and display everything else in a more dim color. Just type `:Limelight` to get let your current paragraph shine in the spotlight.

[![limelight.vim and goyo.vim in action](/assets/img/uploads/goyo-limelight-vim.apng)_goyo.vim with limelight.vim enabled_](/assets/img/uploads/goyo-limelight-vim.apng){:target="_blank"}

Install either plugin using your favourite plugin manager. You'll find instructions and more details in the respective repository on GitHub.
There you go. Distraction-free writing that's hitting the sweet spot between aesthetics, command line efficiency and doing one job well.


