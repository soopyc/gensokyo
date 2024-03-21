<!--
  vim:fileencoding=utf-8:foldmethod=marker
-->

## using sops-nix or other stuff to pass big chungus files to services with DynamicUser=true

afaik this is not possible.

The option that makes the most sense, LoadCredentials only supports files up to 1 MB in size.
([relevant documentation (`systemd.exec(5)`)](https://www.freedesktop.org/software/systemd/man/systemd.exec.html#LoadCredential=ID:PATH:~:text=Currently%2C%20an,is%20enforced))

Without that option, we are only left with giving a user access to the file somehow.

Doing that directly via systemd is not possible either. We cannot get the dynamic user's id in a ExecStartPre hook with the `+` prefix to `chown` the file.
The user is ran with root privileges and there are no signs of the final ephemeral user id. the same happens with
ones prefixed with `!`.

```admonish note
While the `!` syntax do preallocate a dynamic user, we cannot use it to change any permissions. (at least per my last attempt)
```

<!--
  This is a vim fold. press z+o to open, z+c to close.
  Terminal output {{{
-->
~~~admonish tldr title="Terminal Output" collapsible=true
```ShellSession
cassie in marisa in ~ took 1s
✗ 1 ➜ systemd-run -pPrivateTmp=true -pDynamicUser=true --property="SystemCallFilter=@system-service ~@privileged ~@resources" -pExecStartPre="+env" -pPrivateUsers=true -t bash

Running as unit: run-u1196.service
Press ^] three times within 1s to disconnect TTY.
LANG=en_US.UTF-8
PATH=/usr/local/sbin:/usr/local/bin:/usr/bin
LOGNAME=run-u1196
USER=run-u1196
[...]
^C%

cassie in marisa in ~ took 2s
➜ systemd-run -pPrivateTmp=true -pDynamicUser=true --property="SystemCallFilter=@system-service ~@privileged ~@resources" -pExecStartPre="\!env" -pPrivateUsers=true -t bash

Running as unit: run-u1200.service
Press ^] three times within 1s to disconnect TTY.
LANG=en_US.UTF-8
PATH=/usr/local/sbin:/usr/local/bin:/usr/bin
LOGNAME=run-u1200
USER=run-u1200
[...]
^C%

cassie in marisa in ~ took 2s
➜ systemd-run -pPrivateTmp=true -pDynamicUser=true -pSystemCallFilter=@system-service -pSystemCallFilter=~@privileged -pSystemCallFilter=~@resources -pExecStartPre="\!bash -c 'echo \$UID'" -pPrivateUsers=true -t bash -c "ls"

Running as unit: run-u1236.service
Press ^] three times within 1s to disconnect TTY.
0
^C%

cassie in marisa in ~ took 4s
➜ systemd-run -pPrivateTmp=true -pDynamicUser=true -pSystemCallFilter=@system-service -pSystemCallFilter=~@privileged -pSystemCallFilter=~@resources -pExecStartPre="+bash -c 'echo \$UID'" -pPrivateUsers=true -t bash -c "ls"

Running as unit: run-u1241.service
Press ^] three times within 1s to disconnect TTY.
0
^C%
```
~~~
<!--
  }}}
-->

So now, we are left with the only option, which is to create a non-ephemeral user, assign it to the unit and disable DynamicUser.
This step is a little involved, you will have to add a user option to the service and forcibly disable DynamicUser.

I opted to replace the entire module file with my own under a different name, as I had to fix a mistake in it anyways.
Here's the link to [the modified source file.](https://github.com/soopyc/mystia/blob/a999736/modules/fixups/nitter.nix)
For clarity's sake, [this is the diff of the changes made.](https://github.com/soopyc/mystia/compare/3be5eef..a999736)
