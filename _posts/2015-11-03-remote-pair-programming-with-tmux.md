---
layout: post
title: Remote Pair Programming Made Easy with SSH and tmux
tags: terminal programming
excerpt: For many developers pair programming is the way to go. But pairing often becomes challenging as soon as people are working remotely. With a simple SSH and tmux setup you can have a very simple but effective setup for collaborating remotely using nothing but your command line.
comments: true
---

[Pair Programming](https://en.wikipedia.org/wiki/Pair_programming) has found wide adoption in software development ever since it became popular with the rise of Extreme Programming and other agile development approaches. This practice where two developers are working on the same machine and the same task has some really neat advantages over working all by yourself. Working in pairs results in higher quality, spreads knowledge between your team members and ultimately leads to higher satisfaction. Sounds cool? Well, it is!

However, pair programming often becomes difficult as soon as the development team is spread accross different locations. People might be working from home. Parts of your team might be located at a different office, maybe even in an entirely different country. 

It's 2015, the idea of pair programming has been around for more than a decade by now. This remote pair programming thing should be a solved problem. And luckily it is. There are different solutions for different needs. From fully fledged screen sharing solutions with integrated voice chat (like [Screenhero](https://screenhero.com/)) over shared [VNC](https://en.wikipedia.org/wiki/Virtual_Network_Computing) to IDE and editor plugins like [Floobits](https://floobits.com/), there seems to be a nearly endless amount of solutions to enable remote collaboration. 

Those are a lot of services and tools, trying to solve multiple of your problems at once. Personally, I like to keep it simple. I like to keep control over what I'm doing. I like to have tools that do one job and do that job right. And, like many other developers, I like to work in my terminal and hack away in vim/emacs/nano (I'm not gonna start an editor war here!). Luckily, I have everything I need at my disposal. And most likely so do you!

A simple combination of **SSH** and **tmux**[^1] is all we need to setup a really effective and lightweight remote pair programming environment. We can use all of our beloved command line tools with finely tuned dotfiles and pat ourselves on the backs for working on our hacker credibility.

## What are we going to do?
Let's imagine we have two developers, _Alice_ and _Bob_. They want to collaborate on a task and since they both are comfortable using the command line they decide to set up a shared terminal environment to work together.

Alice and Bob connect to the same machine using SSH. They decide to use a dedicated pairing server that both of them `ssh` into. Setting up a server with SSH access on [DigitalOcean](https://www.digitalocean.com/) or [AWS](https://aws.amazon.com/) is a no-brainer nowadays. They simply add their _public keys_ to the `~/.ssh/authorized_keys` file and then can connect securely without needing a password.

Alternatively they cold also designate Alice's or Bob's machine as the pairing host. In this case the respective other person has to `ssh` into the other dev's machine and they're set.

Once they are connected to the same machine, they can use tmux for a shared environment. tmux's client-server architecture allows multiple clients to connect to the same sessions on a server (we've got all that session handling stuff covered in the [intro guide](/blog/a-quick-and-easy-guide-to-tmux/)). That's perfect for our plans. We can have one session that holds all the windows and panes and can connect one client for each developer.

<img class="space-bottom" src="/assets/img/uploads/ssh_tmux_simple.png" alt="synchronized session sharing with tmux">

## Sharing a tmux session
The simplest setup is using the exact same session with multiple tmux client instances. The following steps will get us there:

<div class="highlight">
<ol>
  <li>Alice and Bob <code>ssh</code> into the same server</li>
  <li>Alice creates a new tmux sesssion: <code>tmux new -s shared</code></li>
  <li>Bob connects to that session: <code>tmux attach -t shared</code></li>
</ol>
</div>

Please note that _"shared"_ will be the name of the session, feel free to give it any name you like. 

From here Alice and Bob can happily hack away on their terminal and make use of all the fancy features offered by tmux. They can create panes and windows, launch different command line applications and pair happily on their tasks. They can even detach from that session and return at any later point. Both will see the exact same output in their respective terminal window. 

This is what it will look like in action:

<video src="/assets/video/ssh_tmux_simple.webm" autoplay controls></video>

But somehow Alice and Bob feel that this is not quite perfect. There are situations where they want to work on different stuff while still being in that session. But as soon as Alice switches to a different window to work on her tasks, Bob's terminal will also switch along.  

## Independent window switching
Instead of sharing the exact same session between multiple tmux clients, we can also create multiple session within the same window group. The result is similar to what we've seen above with one difference: Each developer can switch tmux windows independently. 

All contents of the windows will be synchronized between all clients. But each client can decide individually which window's content should be shown at the moment. This allows Alice and Bob to work independently on different tasks if they feel the need to do so. Whenever they want to go back to normal pairing they can switch back to the same tmux window and will see the same content again. 

This is how independent window switching will look like in action:
<video src="/assets/video/ssh_tmux_advanced.webm" autoplay controls></video>

The steps for this setup are a little different:

<div class="highlight">
<ol>
  <li>Again, Alice and Bob <code>ssh</code> into the same server</li>
  <li>Alice, as before, creates a new tmux session: <code>tmux new -s alice</code>. tmux will implicitly create a new <strong>window group</strong></li>
  <li>Bob does not join that same session. Instead he starts a <strong>new session</strong> and connects that session to the same <strong>window group</strong> as Alice’s <em>“shared”</em> session: <code>tmux new -s bob -t alice</code></li>
</ol>
</div>
That's it. Now both can move between tmux windows independently. The content (including panes) within those windows will be synchronized between all clients.


If you want to get a feeling for what's happening behind the scenes you can simply look up what sessions and window groups have been created after Alice has created her session. A simple `tmux ls` will reveal what's happening:

    bob: 2 windows (created Mon Nov  2 22:51:24 2015) [80x23] (group 0) (attached)
    alice: 2 windows (created Mon Nov  2 22:50:36 2015) [80x23] (group 0) (attached)

As you can see, there are two sessions with their respective name. Both sessions are in the same group `(group 0)` and therefore share the same windows.

<img class="space-bottom" src="/assets/img/uploads/ssh_tmux_advanced.png" alt="independent shared sessions with tmux">

## Benefits and drawbacks
To me this is a really nice and lightweight solution if you want to collaborate remotely. You can use it for pair programming, to troubleshoot issues on your servers together and much more. However, you need to be aware that this is a solution with a lot of restrictions. You're completely bound to the command line and its tools, there's no way around it. You also need to have a separate channel to talk to each other 

If you are looking for a fully-fledged solution that allows you to use tools outside of the command line and also includes audio and video conferencing, one of the previously mentioned tools and services might be better suited for you. But if you need something really lightweight that you can control completely on your own and are not afraid of the command line, this setup might be perfect for you.

One last honorable mention goes out to [tmate.io](http://tmate.io/). Tmate is a service that creates the setup I've just described to you in an ad-hoc fashion. If you want to avoid the (quite small) hassle of setting up your own ssh server, tmate might be interesting for you.

If you have any further experience or opinions feel free to share them with us in the comments section!

<hr>
**Footnotes**

[^1]: If you don't feel familiar with tmux or need a quick refresh take a look at my [introductory guide to tmux](/blog/a-quick-and-easy-guide-to-tmux/).
