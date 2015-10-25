---
layout: post
title: Fun and Useless Tools for Your Command Line
tags: terminal
excerpt: There are a couple of really great tools out there that can help you getting more fun out of your day-to-day command line use. These are some of my favorites.
comments: true
---

Ah, the command line. Home of ancient powertools with text-only interfaces, loved by geeks, avoided by everyone else. Did I already mention, that I love the command line? (Oh yes, [most certainly](/blog/a-quick-and-easy-guide-to-tmux/)). Superficially the command line looks plain and boring and I can totally understand why people are reluctant spending any time there while everything else is nice and shiny these days. But behold! There are some really nice gimmicks to make your command line experience more fun. Don't ask for the value of these, there probably is none. But maybe that's why it's so fun. These are some of my favorite useless command line applications that I keep showing to people who actually don't want to know.

## Cowsay
This is a real classic. **Cowsay** uses ASCII art to create a nice cow with a speech bubble that's filled with any text you like. Cowsay is available for Linux and Mac and can easily be installed with your favorite package manager. After that your ASCII cow fun is only a `cowsay yourTextHere` away: 

![Cowsay in action](/assets/img/uploads/cowsay.jpg)

If you feel extra fancy you can make cowsay display other stuff than just plain cows. Cowsay uses _cowfiles_ that serve as templates for your cowsay output. Using `cowsay -f <cowfile> yourText` you can tell cowsay to use a different template. To see which cowfiles are available simply run `cowsay -l` and see what's available. You want Tux instead of a cow? `cowsay -f tux` is here to save your day.

Did you know that [Ansible](http://www.ansible.com) automatically detects if you have cowsay installed? If it finds a cowsay installation on your system it will use it by default for all its log messages. [Here's how](https://github.com/ansible/ansible/blob/86de1429e57c0ec3c40a6c5bd2c1808ce78b48a4/lib/ansible/utils/display.py#L82-L105) they're doing it. Awesome stuff, Ansible!

## sl -- the command line steamlok
Ever felt like being too productive? Or maybe you want to annoy some of your colleagues? **sl** is here to save your day. This little command is invoked by typint `sl` into your command line. Looks pretty similar to mistyping `ls`, huh? Well, that's the point. If you have sl installed (again, available through your package manager), mistyping `ls` as `sl` will no longer show an error message but present you a slowly moving ASCII art steamlok driving smoothly through your terminal window. Want to interrupt it using `Ctrl c`? Nope, not gonna happen.

![sl](/assets/img/uploads/sl.gif)

## lolcat -- like `cat` but with rainbows
I know the feeling, sometimes your command line simply lacks color. What could be better to fight this feeling than lovely rainbows? **[lolcat](https://github.com/busyloop/lolcat)** has you covered. `lolcat` acts exactly like `cat` which you can use to print text to your command line. The difference: lolcat will make all your text rainbow colored.

![lolcat](/assets/img/uploads/lolcat.jpg)

Of course you can also use it in combination with pipes. A simple `gem install lolcat` will bring this piece of rainbow-awesomeness to your machine.


## figlet - create ASCII banners from your command line
I have a knack for ASCII art. Seriously. That's why I love to play around with **figlet** so much. Figlet creates big ASCII art characters from your input text. You can choose between many different fonts and create something really awesome in no time. Once again available through your favorite package manager, figlet will simply take your desired text as input an create beautiful ASCII art out of it.

![figlet](/assets/img/uploads/figlet.jpg)

