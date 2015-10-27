---
layout: post
title: Remote Pair Programming Made Easy - Using SSH and tmux
tags: terminal programming
excerpt: Pair Programming is helpful in many situations but often becomes hard when people working remotely come into the mix. With a simple SSH and tmux setup you can have a very simple but effective remote pair programming setup.
comments: true
---

## The simple way -- share the same session
1. SSH into a common server
   - have a remote server that's allowed for both OR
   - allow your pair to login to your machine using SSH
2. User A: start tmux `tmux new -s shared`
3. User B: connect to that session: `tmux attach -t shared`
4. Hack away, you're done. But everything's completely synchronized

## A little more advanced -- create separate sessions in the same window group
1. SSH into a common server
2. User A: start tmux: `tmux new-session -s shared` and a new window group
3. User B: start new session, connect to the same window group of the _shared_ session: `tmux new-session -t shared`
4. Done, now you can move independently into new tmux windows


