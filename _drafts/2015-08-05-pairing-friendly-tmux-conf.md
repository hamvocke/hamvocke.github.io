---
layout: post
title: Making tmux Pretty and Usable - A Guide to the tmux.conf
tags: programming linux terminal
excerpt: tmux certainly has its flaws when you use its vanilla configuration. I'll show you how you can customize tmux so that it better fits your needs and is a little more comfortable to use.
comments: true
---

In my [previous blog post](/blog/a-quick-and-easy-guide-to-tmux) I gave a quick and easy introduction to tmux and explained how to use tmux with a basic configuration. 

If you've followed that guide you might have had a feeling that many people have when working with tmux for the first time: "These key combinations are really awkward!". Rest assured, you're not alone. Judging from the copious blog posts and dotfiles repos on GitHub there are many people out there who feel the urge to make tmux behave a little different; to make it more comfortable to use.

And actually it's quite easy to customize the look and feel of tmux. Let me tell you something about the basics of customizing tmux and share some of the configurations I find most useful.

## Customizing tmux
Customizing tmux is as easy as editing a text file. tmux uses a file called `tmux.conf` to store its configuration. If you store a file as `~/.tmux.conf` then tmux will use this configuration file for your user. If you want to share a configuration for multiple users (e.g. if you should feel the urge to start tmux as super user (please think about this carefully!)) you can also put your tmux.conf into a system-wide directory. The location of this directory will be different accross different operating systems. The man page (`man tmux`) will tell you the exact location, just have a look at documentation for the `-f` parameter.

### Less awkward prefix keys
Probably the most common change among tmux users is to change the **prefix** from the rather awkward `C-b` to something that's a little more accessible. Personally I'm using `C-a` instead but note that this might interfere with bash's "go to beginning of line" command[^1]. On top of the `C-a` binding I've also remapped my Caps Lock key to act as Ctrl since I'm not using Caps Lock anyways. This allows me to nicely trigger my prefix key combo.

To change your prefix from `C-b` to `C-a`, simply add following lines to your tmux.conf:

    # remap prefix from 'C-b' to 'C-a'
    unbind C-b
    set option -g prefix C-a
    bind-key C-a send-prefix


### Sane Split Commands
Another thing I personally find quite difficult to remember is the pane splitting commands. I mean, seriously? `"` to split vertically and `%` to split horizontally? Who's supposed to memorize that? I find it helpful to have the characters as a visual representation of the split, so I chose `|` and `-` for splitting panes:

    # split panes using | and -
    bind | split-window -h
    bind - split-window -v
    unbind '"'
    unbind %

### Easy Config Reloads
Since I'm experimenting quite often with my tmux.conf I want to reload the config easily. This is why I have a command to reload my config on `r`:

    # reload config file (change file location to your the tmux.conf you want to use)
    bind r source-file ~/.tmux.conf

### Fast Pane-Switching
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

## Changing the look of tmux
Changing the colors and design of tmux is a little more complex than what I've presented so far. You'll want tmux to give a consistent look which is why you most likely have to change the looks of quite a lot of elements tmux displays. This is why changes to the design often result in plenty of lines in your config. I can only recommend to put these into their own identifiable section within your tmux.conf to be able to change this block of config without accidentaly ripping out some of your precious custom key bindings. I'm using comments, starting with a `#` character to make it visible where the design changes start.

Credit where credit is due: The following design is not mine. /u/<TODO> published it on /r/unixporn so it's his effort and all thanks have to go out to him. Thanks!

Depending on your color scheme (I'm using [base16-ocean-dark](https://github.com/chriskempson/base16)) your resulting tmux will look something like this:

![themed tmux](/assets/img/uploads/tmux_custom.png)

    ######################
    ### DESIGN CHANGES ###
    ######################
    
    # panes
    set -g pane-border-fg black
    set -g pane-active-border-fg brightred
    
    ## Status bar design
    # status line
    set -g status-utf8 on
    set -g status-justify left
    set -g status-bg default
    set -g status-fg colour12
    set -g status-interval 2
    
    # messaging
    set -g message-fg black
    set -g message-bg yellow
    set -g message-command-fg blue
    set -g message-command-bg black
    
    #window mode
    setw -g mode-bg colour6
    setw -g mode-fg colour0
    
    # window status
    setw -g window-status-format " #F#I:#W#F "
    setw -g window-status-current-format " #F#I:#W#F "
    setw -g window-status-format "#[fg=magenta]#[bg=black] #I #[bg=cyan]#[fg=colour8] #W "
    setw -g window-status-current-format "#[bg=brightmagenta]#[fg=colour8] #I #[fg=colour8]#[bg=colour14] #W "
    setw -g window-status-current-bg colour0
    setw -g window-status-current-fg colour11
    setw -g window-status-current-attr dim
    setw -g window-status-bg green
    setw -g window-status-fg black
    setw -g window-status-attr reverse
    
    # Info on left (I don't have a session display for now)
    set -g status-left ''
    
    # loud or quiet?
    set-option -g visual-activity off
    set-option -g visual-bell off
    set-option -g visual-silence off
    set-window-option -g monitor-activity off
    set-option -g bell-action none

    set -g default-terminal "screen-256color"
    
    # The modes {
    setw -g clock-mode-colour colour135
    setw -g mode-attr bold
    setw -g mode-fg colour196
    setw -g mode-bg colour238

    # }
    # The panes {
    
    set -g pane-border-bg colour235
    set -g pane-border-fg colour238
    set -g pane-active-border-bg colour236
    set -g pane-active-border-fg colour51

    # }
    # The statusbar {
    
    set -g status-position bottom
    set -g status-bg colour234
    set -g status-fg colour137
    set -g status-attr dim
    set -g status-left ''
    set -g status-right '#[fg=colour233,bg=colour241,bold] %d/%m #[fg=colour233,bg=colour245,bold] %H:%M:%S '
    set -g status-right-length 50
    set -g status-left-length 20
    
    setw -g window-status-current-fg colour81
    setw -g window-status-current-bg colour238
    setw -g window-status-current-attr bold
    setw -g window-status-current-format ' #I#[fg=colour250]:#[fg=colour255]#W#[fg=colour50]#F '
    
    setw -g window-status-fg colour138
    setw -g window-status-bg colour235
    setw -g window-status-attr none
    setw -g window-status-format ' #I#[fg=colour237]:#[fg=colour250]#W#[fg=colour244]#F '
    
    setw -g window-status-bell-attr bold
    setw -g window-status-bell-fg colour255
    setw -g window-status-bell-bg colour1
    
    # }
    # The messages {
    
    set -g message-attr bold
    set -g message-fg colour232
    set -g message-bg colour166
    
    # }

## A Word of Caution
I took care of explaining and documenting all suggested changes in this post to make it easy for you to understand what they do and to decide if this is something you want for your tmux.conf as well.

If you do your amount of research on the web you will find plenty of heavily customized tmux configurations. It's really tempting to just copy those and call it a day. Please, for your own sake, don't do that. Trust me, I've been there. I can only recommend that you start out with a plain tmux configuration and add modifications one by one. This is the only way to ensure that you are fully conscious of all the changes you have made. And this is the only way you will actually learn something about tmux along the way. That said: go ahead and look up config files others have published. Take these as source of inspiration and choose wisely what you want to take for your own config.

There is some really interesting stuff out there. I've seen people doing pure magic with their status bars, displaying all kinds of system information that might be interesting. To apply those changes you'll most likely exceed the simple one-liners I've presented in this post. Often there are special scripts involved that need to be loaded, accompanied by multiple lines of configuration changes. I don't want to discourage you from using these. Just be aware that this is a more advanced topic where you can certainly screw some stuff up. Make sure to backup your config accordingly.


## Further resources
- dotfiles repos
- reddit.com/r/unixporn (beware, don't get sidetracked; and beware of the useless overcustimzations)

You can also find my complete tmux.conf (along with other configuration files I'm using n my systems) on my [dotfiles repo](https://github.com/hamvocke/dotfiles)

<hr>
**Footnotes**

[^1]: although you can still invoke "go to beginning of line" by typing `C-a C-a`
