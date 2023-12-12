---
layout: post
title: Browser Bookmarks on the Command Line
tags: command-line
excerpt: I wrote lnks, a small tool to helps you and your team to search through and open browser bookmarks from the command line
summary: I wrote lnks, a small tool to helps you and your team to search through and open browser bookmarks from the command line
image: /assets/img/uploads/lnks-post-preview.jpg
comments: false
modified_date: 2023-02-07 21:58:00 +0100
---

I wrote a small tool. It's merely more than a script, actually. This tool has been immensely helpful for me over the past few weeks and so I'm sharing it more broadly.

`lnks`[^1] is a command line tool that allows you to search through a list of bookmark and open them in your default browser.

![a screenshot of lnks in action](/assets/img/uploads/lnks.jpg)
_Search and open your bookmarks from the command line_

You can find the code and more instructions on [my GitHub repository](https://github.com/hamvocke/lnks).

## Setup
Here's all you need to do to get started:

1. [Install `fzf`](https://github.com/junegunn/fzf#installation)
2. `git clone` [the repository](https://github.com/hamvocke/lnks) or download the `.sh` and `.txt` files yourself if that's your thing
3. Edit the `bookmarks.txt` file and put your bookmarks in there (see [Managing Bookmarks](#managing-bookmarks) for details)

## Usage
Run the script from your command line.

```bash
./lnks.sh
```

Use the <kbd>↑</kbd> / <kbd>↓</kbd> arrows or <kbd>Ctrl</kbd> + <kbd>P</kbd> / <kbd>Ctrl</kbd> + <kbd>N</kbd> to navigate the list of visible bookmarks up and down.

Hit <kbd>Enter</kbd> to open a selected bookmark in your browser.

Type some text to run a fuzzy search against all your bookmarks. Delete typed characters with <kbd>Backspace</kbd>.

Exit `lnks` with <kbd>Esc</kbd> or <kbd>Ctrl</kbd> + <kbd>C</kbd>.

## Managing Bookmarks
The script will read all `.txt` files that are located in the same directory as the `lnks.sh` script itself to create your list of bookmarks. You can add all your bookmarks to a single `bookmarks.txt` file, or create multiple `.txt` files, totally up to you.

A bookmark text file needs to follow these conventions:

1. One bookmark per line
2. Each line has a searchable name and a URL
3. The URL is the last part of your line, separated from the searchable name with a `space`
4. A bookmark file needs to have the `.txt` extension
5. You can have as many bookmark files next to your `lnks.sh` script as you want

## Demo
Here's `lnks` in action.

<video src="/assets/video/lnks.webm" autoplay loop muted playsinline controls></video>

## Create an Alias for Easier Access
Here's a pro-tip: to make opening your bookmarks a little more convenient, add an alias to your `~/.bashrc`, `~/.zshrc`, or `~/.profile`:

```bash
alias lnks='~/your/directory/lnks/lnks.sh'
```

This way you can open your bookmarks from anywhere simply by typing `lnks`.

## Or Bind it to a Hotkey
You could take this one step further by binding `lnks` to a global keyboard shortcut. That way, your bookmarks will pop up by triggering a key-combo of your choice.

How to can bind custom commands to certain keyboard shortcuts depends on your operating system (and desktop environment) of choice. On Mac, you'd have to dig into [Automator](https://support.apple.com/guide/automator/welcome/mac). On Gnome on Linux, you can [set up a custom keyboard shortcut](https://help.gnome.org/users/gnome-help/stable/keyboard-shortcuts-set.html) in your keyboard settings. Other desktop environments will allow similar customization. In window managers like i3 or Sway, you can bind a custom command to a key combination in your config ([check out how I did this in my own Sway config](https://github.com/hamvocke/dotfiles/blob/f4938fb6a1e4275d06e01c2777ea85ca193d07bd/sway/.config/sway/config#L132-L133)).

You get the idea. You tell your operating system launch your terminal application of choice and then execute the `lnks.sh` script from the right directory whenever you trigger the right key combination. Depending on your terminal application the command to trigger will look slightly different, but it should be somewhat similar to one of these:

```bash
# gnome-terminal:
gnome-terminal -- bash -c ~/dev/lnks/lnks.sh
# -> replace this ^^^^ with your shell of choice if you're not a bash user

# alacritty:
alacritty -e bash -c ~/dev/lnks/lnks.sh

# foot
foot bash -c ~/dev/lnks/lnks.sh
```

This is going to be much more fun if your terminal and shell startup times are fairly snappy.

## How the Sausage is Made

`lnks` uses [`fzf` - the incredibly practical command-line fuzzy finder](https://github.com/junegunn/fzf) to do all the heavy lifting of searching and displaying stuff in a neat UI. `lnks` is merely orchestrating a few Unix tools, really.

The script simply reads all adjacent `.txt` files and passes their content over to `fzf`. `fzf` then lists each bookmark on one line. As you select a line, `fzf` shows the last segment of the line (the actual URL) in a _preview_ window at the top. The rest of a line will be used as the name of the bookmark, this is also what `fzf` runs your search query against. Finally, I configured up a key binding in `fzf` so that pressing the <kbd>Enter</kbd> key opens the bookmark's URL in your default browser.


## Why You Might Want to Use This
As software developers, we often access a lot of bookmarks and important URLs throughout our day. Production systems, staging environments, bug trackers, observability tools, CI/CD pipelines, you know what I'm talking about.

Of course you could manage these bookmarks within your browser like a normal person. But you didn't click the link to this blog post because you're looking for vanilla solutions to everyday problems, did you?

Chances are that you've got a terminal open all day so navigating bookmarks from a terminal might feel like second nature. And if you use something like `tmux` ([check out my tmux guide](/blog/a-quick-and-easy-guide-to-tmux) if you don't!) you can dedicate a small pane to keep `lnks` open at all times.

The nice thing about keeping all your bookmarks in plain `.txt` files is that you can share them easily with people you work with. Most likely they will need access to the same things as you do, so sharing these bookmarks is a great way to keep important bookmarks up to date and point people to the right places at all times. A good way to do this is to fork [the GitHub repository](https://github.com/hamvocke/lnks), check in your own bookmark files, and share your fork with your team.

I learned to love this kind of bookmark sharing when I worked with a software development team at [Otto](https://www.otto.de), a German online retailer. We did a lot of pair programming and switched machines frequently. Someone on the team had built a small bookmarks website that looked pretty much just like `lnks` and allowed you to search through important bookmarks for the team. As we were pairing, we could always rely on having quick and easy access to that bookmark website and therefore to all our test environments, logs, bug trackers, code repos, you name it.

I'm getting a lot of mileage out of this small script. I hope you find it helpful, too.

### Footnotes

[^1]: that's "links" for people who want to save a keystroke -- my contribution to the myth of German efficiency!
