---
layout: post
title: tmux - A Hands on Guide for Beginners
tags: terminal
excerpt: Tmux is a tool that can help you to be more productive using the terminal. Think of it as a window manager in your terminal with some extra fanciness on top. This post gives you an easy-to-follow introduction to tmux and explains its benefits over usual terminal emulators.
comments: true
---

A good way to become more productive on your Mac or Linux system is to get familiar with the terminal and the applications that come along with it. Sure, it takes some time and dedication to get used to these applications which seem rather archaic at first glance. But sooner or later you'll figure out that once you got the hang of it there's hardly anything faster than your newly acquired terminal-fu skills. 

To get the most out of your terminal experience you might want to streamline your command line experience. Instead of opening multiple windows of your terminal emulator of choice you should try something better. This is where [tmux](https://tmux.github.io/) comes in. 

This article will give you a brief introduction over the functionality of tmux. After that there'll be a hands-on guide that will give you an easy-to-follow roundtrip through tmux and its most important features. 

## What's tmux and why should I use it?

Simply speaking tmux -- a so-called terminal multiplexer -- acts as a kind of window manager within your command line. If you are familiar with [GNU Screen](https://www.gnu.org/software/screen/) you can think of tmux as an easier-to-use and a little more powerful alternative to Screen (obviously I'm being opinionated here). You can use it to create nicely ordered workspaces within your terminal. At any point you can simply freeze that workspace and come back to exactly where you left it off later.

### Window Management

Tmux's most obvious feature is its window management. With this features tmux can create multiple *windows* in your terminal and one or more *panes* within each window. This allows you to organize your terminal session into different workspaces so that you can work more efficiently without switching between multiple terminal emulator windows. Following screenshot should help visualizing what I'm talking about:

![Tmux in action](/assets/img/uploads/tmux.png)

The screenshot shows tmux with a three-pane layout. There's a left pane showing system information (using [screenFetch](https://github.com/KittyKatt/screenFetch) for those who are interested) and two right panes, one printing the output of my humans.txt file, the other one giving a simple `ls` output. Each pane sports an independent terminal prompt so you can have long-running tasks in one pane while doing stuff in a pane next to it.

At the bottom you see the status bar. The status bar is an important part of tmux and show the different windows that are open. In this case I've created two windows. In one window I'm showing off my system stats because thats what the cool kids do nowadays. The other window, titled *"code"* has different panes in which I'm managing the code of my blog. That window is currently invisible but everything that's happening in there is still running in the background. Apart from the currently opened windows the status bar also shows some system information like date and time. This can also be customized and I've seen some really fancy stuff around (upcoming calendar events, battery status, to name a few).

### Session Management
Tmux is more than just a window managemer. Tmux is based on the concept of sessions. As soon as you start tmux it will either create a new session or re-open an old session that you have saved. When starting tmux you can specify an old session that you want to re-attach to or just start a new one. When you're done with your session you can then persist that session to pick it up later on. 

Session management is extremely helpful when you're working on a remote machine over *ssh* (e.g. when working on a remote server or a Raspberry Pi): You can start with a tmux session, arrange your workspace neatly with windows and panes and start hacking on your project. When you're done or want to take a break you can simply detach from that session and close the ssh connection. The next time you want to pick it up again you can ssh back to the remote server and simply re-attach to the previous session. Everything will be exactly like when you left off. No need to re-create that workspace all over again. 

Note that tmux sessions are not persistent. This means that once your machine (your local machine, your server, your Raspberry Pi) does a rebbot, it's gone.

## Getting Started
The following hands-on guide should get you up and running with tmux pretty quickly. It will show you all the important basic features. Simply open your terminal and follow the instructions.

### Installation

Fortunately installing tmux is pretty straightforward on most distributions a simple `sudo apt-get install tmux` (Ubuntu and derivatives) or `brew install tmux` (Mac) should be sufficient.

### Sarting Your First Session
For your first session simply start tmux with a new session:

    tmux

This will open a new tmux session with a nice all-green status bar at the bottom.

### Creating and Navigating Panes
Now that we've created our first session we can get familiar with window and pane creation. Tmux has already created a single window with a single pane on startup. Let's split this pane in two panes. 

All commands in tmux are triggered by a **prefix key** followed by a **command key** (quite similar to emacs). By default, tmux uses `C-b` as prefix key. This notation might read a little weird if you're not used to it. In this emacs notation `C-` means "press and hold the `Ctrl` key"; there could also be `M-` which is the same for the `Meta` key (which is `Alt` on most keyboards). Thus `C-b` means nothing else but pressing the `Ctrl` and `b` keys at the same time. 

We can split our pane either vertically (`C-b "`) or horizontally (`C-b %`). Remember, tmux commands always consist of a sequence of **prefix** and **command key**. This means to split your pane vertically (`C-b "`) you type `Ctrl` and `b` at the same time first, release both, and then type the `"` key. Voilà! You've just invoked your first tmux command and split your pane in two.

Now let's switch between those two panes. Switching is fairly straightforward: It's just your prefix (`C-b`) followed by an arrow key pointing to the direction you want to switch to. This now depends on whether you've split your pane horizontally or vertically. Just type `Ctrl` and `b` followed by the `up` arrow key to get to the pane on top. Type `Ctrl` and `b` followed by the `left` arow key to get to the pane on the left of the current pane. You get it.

You can now go ahead and split each of your new panels even further. Feel free to experiment and split your panes like a maniac to get a feeling for it.

Closing a pane is as simple as closing a regular terminal session. Either type `exit` or hit `Ctrl-d` and it's gone.

### Creating Windows
Windows in tmux can be compared to creating new virtual desktops; if you've ever worked with one of the major Linux deskop environments (KDE, Gnome) you'll hopefully find this analogy helpful.

Creating new windows is as easy as typing `C-b c` (one last time: that's `Ctrl` and `b` at once, then `c`). The new window will then be presented to you in tmux's status bar.

You can now divide the pane in your new window as you like. Or don't. That's up to you.

To switch to the previous window (according to the order in your status bar) use `C-b p`, to switch to the next window use `C-b n`. If you've created many windows you might find it useful to go to a window directly by typing its number (the status bar will tell you which window has which number), just use `C-b <number>` where &lt;number> is the number in front of the window's name in your status bar.

### Session Handling
If you're done with your session you can either get rid of it by simply exiting all the panes inside or you can keep the session in the background for later reuse.

To detach your current session use `C-b d`. You can also use `C-b D` to have tmux give you a choice which of your sessions you want to detach.

Now that your session is detached you can pick it up from where you left it at any later point in time. To re-attach to a session you need to figure out which session you want to attach to first. Figure out which sessions are running by using

    tmux ls

This will give you a list of all running sessions, which in our example should be something like 

> 0: 2 windows (created Sat Aug 15 17:55:34 2015) [199x44] (detached)

To connect to that session you start tmux again but this time tell it which session to attach to:

    tmux attach -t 0

Note that the `-t 0` is the parameter that tells tmux which session to attach to. "0" is the first part of your `tmux ls` output.

If you prefer to give your sessions a more meaningful name (instead of a numerical one starting with 0) you can create your next session using

    tmux new -s database

This will create a new session with the name "database". 

You could also rename your existing session:

    tmux rename-session -t 0 database

The next time you attach to that session you simply use `tmux attach -t database`. If you're using multiple sessions at once this can become an essential feature. 

And that's it! You've just completed your first tmux session and got your hands dirty with its window and session management. This knowledge alone can help you immensely on you way forward and (after an initial learning time) give you a huge boost in productivity.

### But wait, there's more!
Tmux can do even more than what we've just seen in our getting started guide. Most of the stuff is quite simple to discover. Just type `C-b ?` to see a list of all available commands. 

There's some other stuff (different modes, usage of buffers) that might be a little more advanced but its fine to ignore all that for now.

Tmux takes a while to get used to and you'll probably feel slow in the very beginning. I can only encourage you to keep using it. Get a feeling for its functionality and in no time you'll find out that your terminal usage will be pure bliss and insanely fast. Feel free to mess around with tmux and figure out what else it offers. 

Just as a heads up, some other commands that I'm using myself quite often are:

  - `C-b z`: make a pane go fullscreen. Hit `C-b z` again to shrink it back to its previous size
  - `C-b C-<arrow key>`: Resize pane in direction of &lt;arrow key>
  - `C-b ,`: Rename the current window

### Customizations

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
