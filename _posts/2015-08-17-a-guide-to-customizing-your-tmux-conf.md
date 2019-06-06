---
layout: post
title: Making tmux Pretty and Usable - A Guide to Customizing your tmux.conf
tags:
  - command line
excerpt: tmux certainly has its flaws when you use its vanilla configuration. I'll show you how you can customize tmux so that it fits your needs, is a little more comfortable to use and pretty to look at.
summary: Customize the look and feel of tmux
image: /assets/img/uploads/tmux_custom.jpg
comments: true
---

In my [previous blog post](/blog/a-quick-and-easy-guide-to-tmux) I gave a quick and easy introduction to tmux and explained how to use tmux with a basic configuration.

If you've followed that guide you might have had a feeling that many people have when working with tmux for the first time: "These key combinations are really awkward!". Rest assured, you're not alone. Judging from the copious blog posts and dotfiles repos on GitHub there are many people out there who feel the urge to make tmux behave a little different; to make it more comfortable to use.

And actually it's quite easy to customize the look and feel of tmux. Let me tell you something about the basics of customizing tmux and share some of the configurations I find most useful.

## Customizing tmux
Customizing tmux is as easy as editing a text file. tmux uses a file called `tmux.conf` to store its configuration. If you store that file as `~/.tmux.conf` (**Note:** there's a period as the first character in the file name. It's a hidden file) tmux will pick this configuration file for your current user. If you want to share a configuration for multiple users (e.g. if you should feel the urge to start tmux as super user (please think about this carefully!)) you can also put your tmux.conf into a system-wide directory. The location of this directory will be different accross different operating systems. The man page (`man tmux`) will tell you the exact location, just have a look at documentation for the `-f` parameter.

### Less awkward prefix keys
Probably the most common change among tmux users is to change the **prefix** from the rather awkward `C-b` to something that's a little more accessible. Personally I'm using `C-a` instead but note that this might interfere with bash's "go to beginning of line" command[^1]. On top of the `C-a` binding I've also remapped my Caps Lock key to act as Ctrl since I'm not using Caps Lock anyways. This allows me to nicely trigger my prefix key combo.

To change your prefix from `C-b` to `C-a`, simply add following lines to your tmux.conf:

    # remap prefix from 'C-b' to 'C-a'
    unbind C-b
    set-option -g prefix C-a
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

**Update for tmux 2.1**:  
As Jon Lillie pointed out in the comments, mouse mode has been [rewritten in tmux 2.1](https://github.com/tmux/tmux/blob/master/CHANGES#L6-L13). Once you are on tmux 2.1 (or later) you can activate the new mouse mode with a single command:

    # Enable mouse mode (tmux 2.1 and above)
    set -g mouse on

The new mode is a combination of all the old mouse options and fixes the text selection issues as well.

### Stop renaming windows automatically
I like to give my tmux windows custom names using the `,` key. This helps me naming my windows according to the context they're focusing on. By default tmux will update the window title automatically depending on the last executed command within that window. In order to prevent tmux from overriding my wisely chosen window names I want to suppress this behavior:

    # don't rename windows automatically
    set-option -g allow-rename off

## Changing the look of tmux
Changing the colors and design of tmux is a little more complex than what I've presented so far. You'll want tmux to give a consistent look which is why you most likely have to change the looks of quite a lot of elements tmux displays. This is why changes to the design often result in plenty of lines in your config. I can only recommend to put these into their own identifiable section within your tmux.conf to be able to change this block of config without accidentaly ripping out some of your precious custom key bindings. I'm using comments, starting with a `#` character to make it visible where the design changes start.

**Credit where credit is due:** I did not create the following design. [/u/dothebarbwa](https://www.reddit.com/user/dothebarbwa) was so kind to [publish](https://www.reddit.com/r/unixporn/comments/3cn5gi/tmux_is_my_wm_on_os_x/) it on [/r/unixporn](https://www.reddit.com/r/unixporn) so it's his effort and all thanks have to go out to him. Thanks!

Depending on your color scheme (I'm using [base16-ocean-dark](https://github.com/chriskempson/base16)) your resulting tmux will look something like this:

![themed tmux](/assets/img/uploads/tmux_custom.jpg)

    ######################
    ### DESIGN CHANGES ###
    ######################

    # loud or quiet?
    set -g visual-activity off
    set -g visual-bell off
    set -g visual-silence off
    setw -g monitor-activity off
    set -g bell-action none

    #  modes
    setw -g clock-mode-colour colour5
    setw -g mode-style 'fg=colour1 bg=colour18 bold'

    # panes
    set -g pane-border-style 'fg=colour19 bg=colour0'
    set -g pane-active-border-style 'bg=colour0 fg=colour9'

    # statusbar
    set -g status-position bottom
    set -g status-justify left
    set -g status-style 'bg=colour18 fg=colour137 dim'
    set -g status-left ''
    set -g status-right '#[fg=colour233,bg=colour19] %d/%m #[fg=colour233,bg=colour8] %H:%M:%S '
    set -g status-right-length 50
    set -g status-left-length 20

    setw -g window-status-current-style 'fg=colour1 bg=colour19 bold'
    setw -g window-status-current-format ' #I#[fg=colour249]:#[fg=colour255]#W#[fg=colour249]#F '

    setw -g window-status-style 'fg=colour9 bg=colour18'
    setw -g window-status-format ' #I#[fg=colour237]:#[fg=colour250]#W#[fg=colour244]#F '

    setw -g window-status-bell-style 'fg=colour255 bg=colour1 bold'

    # messages
    set -g message-style 'fg=colour232 bg=colour16 bold'


## A Word of Caution
I took care of explaining and documenting all suggested changes in this post to make it easy for you to understand what they do and to decide if this is something you want for your tmux.conf as well.

If you do your amount of research on the web you will find plenty of heavily customized tmux configurations. It's really tempting to just copy those and call it a day. Please, for your own sake, don't do that. Trust me, I've been there. I can only recommend that you start out with a plain tmux configuration and add modifications one by one. This is the only way to ensure that you are fully conscious of all the changes you have made. And this is the only way you will actually learn something about tmux along the way. That said: go ahead and look up config files others have published. Take these as source of inspiration and choose wisely what you want to take for your own config.

There is some really interesting stuff out there. I've seen people doing pure magic with their status bars, displaying all kinds of system information that might be interesting. To apply those changes you'll most likely exceed the simple one-liners I've presented in this post. Often there are special scripts involved that need to be loaded, accompanied by multiple lines of configuration changes. I don't want to discourage you from using these. Just be aware that this is a more advanced topic where you can certainly screw some stuff up. Make sure to backup your config accordingly.


## Further resources
As I've already told you, there are plenty of resources out there where you can find people presenting their tmux.confs in a similar fashion to what I've done here. Feel free to browse and search for inspiration. Personally I love reading other people's blog posts about their tmux configs.

GitHub is also a great source. Simply search for *"tmux.conf"* or repos called *"dotfiles"* to find a vast amount of configurations that are out there.

If you're especially looking for theming options, I can also recommend having a look at [/r/unixporn](https://reddit.com/r/unixporn) (SFW, in spite of its title). It's a great place where people showcase their fine-tuned and heavily themed unix environments. Some stuff is really nice, some other stuff is only pretty but mostly dysfunctional. From time to time you find people sharing their tmux.conf as well, you can also deliberately search for the term "tmux.conf" to find what you're looking for.

You can also find my complete tmux.conf (along with other configuration files I'm using on my systems) on my personal [dotfiles repo](https://github.com/hamvocke/dotfiles) on GitHub.

<hr>
**Footnotes**

[^1]: although you can still invoke "go to beginning of line" by typing `C-a C-a`
