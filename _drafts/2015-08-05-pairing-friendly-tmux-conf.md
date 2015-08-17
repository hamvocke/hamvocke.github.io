---
layout: post
title: How to Customize tmux
tags: programming linux terminal
excerpt: tmux certainly has its flaws when you use its vanilla configuration. I'll show you how you can customize tmux so that it better fits your needs and is a little more comfortable to use.
comments: true
---

In my [previous blog post](/blog/a-quick-and-easy-guide-to-tmux) I gave a quick and easy introduction to tmux and explained how to use tmux with a basic configuration. 

If you've followed that guide you might have had a feeling that many people have when working with tmux for the first time: "These key combinations are really awkward!". Rest assured, you're not alone. Judging from the copious blog posts and dotfiles repos on GitHub there are many people out there who feel the urge to make tmux behave a little different; to make it more comfortable to use.

And actually it's quite easy to customize the look and feel of tmux. Let me tell you something about the basics of customizing tmux and share some of the configurations I find most useful.

## Customizing tmux
Customizing tmux is as easy as editing a text file. tmux uses a file called `tmux.conf` to store its configuration. If you store a file as `~/.tmux.conf` then tmux will use this configuration file for your user. If you want to share a configuration for multiple users (e.g. if you should feel the urge to start tmux as super user (please think about this carefully!)) you can also put your tmux.conf into a system-wide directory. The location of this directory will be different accross different operating systems. The man page (`man tmux`) will tell you the exact location, just have a look at documentation for the `-f` parameter.

### Sane key bindings
Probably the most common change among tmux users is to change the **prefix** from the rather awkward `C-b` to something that's a little more accessible. Personally I'm using `C-a` instead but note that this might interfere with bash's "go to beginning of line" command[^1]. On top of the `C-a` binding I've also remapped my Caps Lock key to act as Ctrl since I'm not using Caps Lock anyways. This allows me to nicely trigger my prefix key combo.

To change your prefix from `C-b` to `C-a`, simply add following lines to your tmux.conf:

    # remap prefix from 'C-b' to 'C-a'
    unbind C-b
    set option -g prefix C-a
    bind-key C-a send-prefix

Another thing I personally find quite difficult to remember is the pane splitting commands. I mean, seriously? `"` to split vertically and `%` to split horizontally? Who's supposed to memorize that? I find it helpful to have the characters as a visual representation of the split, so I chose `|` and `-` for splitting panes:

    # split panes using | and -
    bind | split-window -h
    bind - split-window -v
    unbind '"'
    unbind %

Since I'm experimenting quite often with my tmux.conf I want to reload the config easily. This is why I have a command to reload my config on `r`:

    # reload config file (change file location to your the tmux.conf you want to use)
    bind r source-file ~/.tmux.conf

Switching between panes is one of the most frequent tasks when using tmux. Therefore it should be as easy as possible. I'm not quite fond of triggering the prefix key all the time. I want to be able to simply say `M-<direction>` to go where I want to go (remember: `M` is for `Meta`, which is usually your `Alt` key). With this modification I can simply press `Alt-left` to go to the left pane (and other directions respectively):

    # switch panes using Alt-arrow without prefix
    bind -n M-Left select-pane -L
    bind -n M-Right select-pane -R
    bind -n M-Up select-pane -U
    bind -n M-Down select-pane -D

### Mouse mode
Although tmux clearly focuses on keyboard-only usage (and this is certainly the most efficient way of interacting with your terminal) it can be helpful to enable mouse interaction with tmux. This is especially helpful if you find yourself in a situation where others have to work with your tmux config and naturally don't have a clue about your key bindings or tmux in general. Pair Programming might be one of those occasions where this happens quite frequently.

Enabling mouse mode allows you to select windows and different panes by simply clicking on them. I've found that this might mess a little bit with simply selecting text in your terminal using the mouse. You might experience the same, depending on your environment. So you should consider if this configuration is something that's worth it for your use case:

    # Enable mouse control (clickable windows, panes, resizable panes)
    set -g mouse-select-window on
    set -g mouse-select-pane on
    set -g mouse-resize-pane on

### Stop renaming windows automatically
I like to give my tmux windows custom names using the `,` key. This helps me naming my windows according to the context they're focusing on. By default tmux will update the window title automatically depending on the last executed command within that window. In order to prevent tmux from overriding my wisely chosen window names I want to suppress this behavior:

    # don't rename windows automatically
    set-option -g allow-rename off

## A Word of Caution
I took care of explaining and documenting all suggested changes in this post to make it easy for you to understand what they do and to decide if this is something you want for your tmux.conf as well.

If you do your amount of research on the web you will find plenty of heavily customized tmux configurations. It's really tempting to just copy those and call it a day. Please, for your own sake, don't do that. Trust me, I've been there. I can only recommend that you start out with a plain tmux configuration and add modifications one by one. This is the only way to ensure that you are fully conscious of all the changes you have made. And this is the only way you will actually learn something about tmux along the way. That said: go ahead and look up config files others have published. Take these as source of inspiration and choose wisely what you want to take for your own config.



You can also find my complete tmux.conf (along with other configuration files I'm using n my systems) on my [dotfiles repo](https://github.com/hamvocke/dotfiles)

## Further resources
- dotfiles repos
- reddit.com/r/unixporn (beware, don't get sidetracked; and beware of the useless overcustimzations)

<hr>
**Footnotes**

[^1]: although you can still invoke "go to beginning of line" by typing `C-a C-a`
