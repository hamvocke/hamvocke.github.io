---
layout: post
title: Increase your terminal productivity with tmux
tags: programming linux terminal
excerpt: Tmux is a terminal multiplexer that can help you be more productive when using the terminal. The tmux config I'm presenting here has some nifty features that make it more suitable for pair programming
comments: true
---

A good way to become more productive on your Mac or Linux system is to get familiar with the terminal and applications that come along with it. [Tmux](https://tmux.github.io/), a terminal multiplexer, allows you to get the most out of your terminal. 

If you are familiar with [GNU Screen](https://www.gnu.org/software/screen/) you can think of tmux as an easier-to-use and a little more powerful alternative to Screen. 

Tmux allows you create sessions in your terminal that you can persist and re-attach to at any later point in time. Think about ssh-ing into a server and wanting to come back later to where you left off. Tmux also gives you the option to create multiple windows (think tabs) and panes (split screens) within your terminal. This allows you to organize your terminal workspace and create and arrange individual workspaces.

![Tmux in action](/assets/img/uploads/tmux.png)

But what's the fuzz all about? iTerm supports tabs and panes, Gnome Terminal supports tabs as well, why would anyone feel the urge to learn some archaic technology in this day and age?

## Tmux vs Terminal Emulators
- session persistence
- platform independent, mac and linux
- works on remote machines, servers, raspberry, beaglebone
- looks sleek
- customizable

## Customizations, a very basic config
- change modifier key binding (C-a)
- caps lock -> ctrl
- split windows vertically, horizontally
- get started from here, add your own modifications by research

## What else?
There are plenty of resources out there, you can find people sharing their dotfiles on Github, read the Pragmatic Press book specifically about tmux. But it's easiest to simply try it for yourself and get started using it.

Find my config on [the next blog post](/2015/08/04/pairing-friendly-tmux-conf.html)
