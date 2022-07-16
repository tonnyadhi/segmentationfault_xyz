---
title: GitHub Operation via SSH
date: 2022-07-16
tags: github, ssh,  internet problem
---

At about several weeks ago, another ISP (Biznet) just expand their service into my housing area. It service definitely better and faster than that regular state owned ISP (aka IndhiHome)
So, i decided to subscribed to them and do load balance on my home Mikrotik gateway. IndiHome become my secondary gateway

I also upgraded my home WiFi from 802.11ac to 802.11ax.

Several day after that, i start experiencing hiccup on my git operation to GitHub. I didn't find out what the exact cause, but my git operation were using Git+SSH into GitHub.


Today i learned on [go-errcheck](https://github.com/kisielk/errcheck). This small utility is quite handy to check unchecked error handling in our code.
I found out this tool when refreshing my Go lesson on [Learning Go With Tests](https://quii.gitbook.io/learn-go-with-tests/go-fundamentals/pointers-and-errors) during error handling chapter.

## Solution Notes

From this [stackoverflow thread](https://stackoverflow.com/questions/15589682/ssh-connect-to-host-github-com-port-22-connection-timed-out), ssh client should be set into using port 443.
And, mostly my problem are gone after this.

`cat /etc/ssh/ssh_config`

```
Host github.com
  Hostname ssh.github.com
  Port 443
  User git
  TCPKeepAlive yes
```

