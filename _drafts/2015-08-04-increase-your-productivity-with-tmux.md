---
layout: post
title: Increase your terminal productivity with tmux
tags: terminal
excerpt: Tmux is a tool that can help you to be more productive using the terminal. Think of it as a window manager in your terminal with some extra fanciness on top. This post gives you a brief introduction to tmux and explains its benefits.
comments: true
---

A good way to become more productive on your Mac or Linux system is to get familiar with the terminal and the applications that come along with it. Sure, it takes some time and dedication to get used to these applications which seem rather archaic at first glance. But sooner or later you'll figure out that once you got the hang of it there's hardly anything faster than your newly acquired terminal-fu skills. 

To get the most out of your terminal experience you might want to streamline your command line experience. Instead of opening multiple windows of your terminal emulator of choice you want to try something better. This is where [tmux](https://tmux.github.io/) comes in. Tmux -- a so-called terminal multiplexer -- helps you to get the most out of your terminal by acting as a kind of window manager within your command line (and even more on top of that). If you are familiar with [GNU Screen](https://www.gnu.org/software/screen/) you can think of tmux as an easier-to-use and a little more powerful alternative to Screen. 


## Window Management
With its window management features tmux can create multiple *windows* in your terminal and one or more *panes* within each window. This allows you to organize your terminal session into different workspaces and panes as you might be used to from your regular window manager. Following screenshot should help visualizing what I'm talking about:

![Tmux in action](/assets/img/uploads/tmux.png)

The screenshot shows tmux with a very basic two-pane layout. There's a left pane showing system information (using [screenFetch](https://github.com/KittyKatt/screenFetch) for those who are interested) and a right pane giving a simple `ls` output. Each pane sports an independent terminal prompt so you can have long-running tasks in one pane while doing stuff in a pane next to it.

At the bottom you see the (slightly modified -- mostly colors) status bar. The status bar is an integral part of tmux and shows you the different windows that are open. In this case I've created two windows. In one window I'm showing off my system stats because thats what the cool kids do nowadays. The other window, titled *"code"* has different panes in which I'm managing the code of my blog. That window is currently invisible but everything that's happening in there is still running in the background. Apart from the currently opened windows the status bar also shows some system information like date and time. This can also be customized and I've seen some really fancy stuff around (upcoming calendar events, battery status, to name a few).

## Session Management
Tmux is more than only window management. Tmux is based on the concept of sessions. As soon as you start tmux it will either create a new session or re-open an old session that you have saved. When starting tmux you can specify an old session that you want to re-attach to or just start a new one. When you're done with your session you can then persist that session to pick it up later on. 

Session management is extremely helpful when you're working on a remote machine over *ssh* (e.g. when working on a remote server or a Raspberry Pi): You can start with a tmux session, arrange your workspace neatly with windows and panes and start hacking on your project. When you're done or want to take a break you can simply detach from that session and close the ssh connection. The next time you want to pick it up again you can ssh back to the remote server and simply re-attach to the previous session. Everything will be exactly like when you left off. No need to re-create that workspace all over again. 

Note that tmux sessions are not persistent. This means that once your machine (your local machine, your server, your Raspberry Pi) does a rebbot, it's gone.

## Getting Started
A little hands-on guide should get you up and running with tmux pretty quickly. Simply open your terminal and follow these instructions.

### Installation

Fortunately installing tmux is pretty straightforward on most distributions a simple `sudo apt-get install tmux` (Ubuntu and derivatives) or `brew install tmux` (Mac) should be sufficient.

### Sarting Your First Session
For your first session simply start tmux with a new session:

    tmux

This will open a new tmux session with a nice all-green status bar at the bottom.

### Creating and Navigating Panes
Now that we've created our first session we can get familiar with window and pane creation. Tmux has already created a single window with a single pane on startup. Let's split this pane in two panes. 

All commands in tmux are triggered by a **prefix key** followed by a **command key** (quite similar to emacs). By default, tmux uses `C-b` as prefix key. This notation might read a little weird if you're not used to it. `C-b` means nothing else but pressing the `Ctrl` and `b` keys at the same time.

We can split our pane either vertically (`C-b "`) or horizontally (`C-b %`). Remember, tmux commands always consist of a sequence of **prefix** and **command key**. This means to split your pane vertically (`C-b "`) you type `Ctrl` and `b` at the same time first, release both, and then type the `"` key. Voilà! You've just invoked your first tmux command and split your pane in two.

Now let's switch between those two panes. Switching is fairly straightforward: It's just your prefix (`C-b`) followed by an arrow key pointing to the direction you want to switch to. This now depends on whether you've split your pane horizontally or vertically. Just type `Ctrl` and `b` followed by the `up` arrow key to get to the pane on top. Type `Ctrl` and `b` followed by the `left` arow key to get to the pane on the left of the current pane. You get it.

You can now go ahead and split each of your new panels even further. Feel free to experiment and split your panes like a maniac to get a feeling for it.

Closing a pane is as simple as closing a regular terminal session. Either type `exit` or hit `Ctrl-d` and it's gone.

### Creating Windows
Windows in tmux can be compared to creating new virtual desktops; if you've ever worked with one of the major Linux deskop environments (KDE, Gnome) you'll hopefully find this analogy helpful.

Creating new windows is as easy as typing `C-b c` (one last time: that's `Ctrl` and `b` at once, then `c`). The new window will then be presented to you in tmux's status bar.

You can now divide the pane in your new window as you like. Or don't. That's up to you.

To switch to the previous window use `C-b p`, to switch to the next window (according to your status bar) use `C-b n`. If you've created many windows you might find it helpful to go to a window directly by providing its number (the status bar will tell you which window has which number), just use `C-b <number>` where &lt;number> is the number in front of the window's name in your status bar.

### More Commands
Just type `C-b ?` to see a list of commands available. Feel free to experiment around.

## Benefits of tmux

But what's the fuzz all about? [iTerm](http://iterm2.com/) for Mac supports tabs and panes as well and for Linux there's [Terminator](http://gnometerminator.blogspot.com/p/introduction.html), why would anyone feel the urge to learn some archaic technology in this day and age?

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


**TODO: Extract into extra post**  
## The problem with over-customizing
There are basically two schools of thought out there. Those who customize the shit out of their environment and those who try to keep it basic. I think the truth lies somewhere in between. Sure, customizing your command line tools like tmux (but also bash, zsh, vim, emacs, you name it) can maximize your personal productivity. You can use aliases and custom key bindings to execute some really fancy commands in a wink. Even better: you don't have to memorize all those complex commands and parameters.

The downside becomes apparent when you're working with others. All of a sudden you're used to your heavily customized environment and struggle using anything else. And now think about those poor souls who will find themselves in a situation where they need to use your setup and have to give up on some basic tasks just because your "well-crafted" config is standing in their way. Some of my colleagues are very good at letting me know when my urge to customize my configs is getting out of hand by simply refusing to do pair programming on my machine as long as I dont "fix" something they can't use. And rightly so!

There are lots of heavily modified configs out there (TODO: link awesome vim) that surely are handy when you know how to use them. However, it takes lots of time to learn the ins and outs of those configs and chances are you're never going to use nearly close of all the features those configs will provide.

My advice for you is to start simple and basic. Learn how your tools are meant to be used in their basic configs, find out about their striking downsides and fix them along the way. Feel free to research on more ways to improve and optimize your config but always keep in mind that the next poor soul that feels helpless being confronted with your system might just be sitting next to you. Keep a sane middle ground, try stuff out but make sure that nothing gets in the way of actually using your tools without having to read through 500 lines of manuals and configs first.

## What else?
There are plenty of resources out there, you can find people sharing their dotfiles on Github, read the Pragmatic Press book specifically about tmux. But it's easiest to simply try it for yourself and get started using it.

Find my config on [the next blog post](/2015/08/04/pairing-friendly-tmux-conf.html)
