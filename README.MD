# SSH/SCP wrapper for Matlab using the system command

This repository provides functions to run SSH and SCP commands from within Matlab. It can be used to run commands on remote computers and to copy files to and from remote computers.

The file structure and function arguments are based on the [Matlab-SSH2 repository from David Scott Freedman](https://github.com/davidfreedman/matlab-ssh2). The code is strongly simplified by removing all dependencies on Ganymed, which seems to be deprecated because it does not support newer SSH key exchange algorithms. New versions of SSH do not support this due to security issues. [Workarounds for enabling the old protocols](https://github.com/davidfreedman/matlab-ssh2/issues/4) are only possible on servers under own administration. This can not be fixed on the client side.

Instead of using Ganymed, the SSH/SCP commands are executed via the [Matlab system command](https://www.mathworks.com/help/matlab/ref/system.html).

Author: Moritz Schappler (2024); Code (functions and interfaces) based on [Matlab-SSH2 by David Scott Freedman](https://github.com/davidfreedman/matlab-ssh2).

## Installation

On Linux, the `ssh` and `scp` commands are executed via `sshpass` (which has to be installed next to ssh).
On Windows, [Putty](https://www.putty.org/) (via `plink` and `pscp`) is used, which has to be installed and added to the Windows Path.

## Security Concerns

Currently, only access via username and password is supported, no key files. The SSH password has to be accessable via plain-text from Matlab, which does not correspond to reasonable security advises.
In many lab setups or in closed university or corporate networks, where Matlab is usually used, this may be tolerable.

Unlike the Java/Ganymed-Matlab-SSH2 approach, there is no object which stores an SSH connection handle.
Therefore, a new connection has to be established by each command.
This may add load on the server by additional SSH handshakes and may pose security issues or trigger firewalls or server security rules.


## Contents

The most important functions are:
* `ssh2_config`: initialize SSH settings structure (this is no connection handle)
* `scp_put`: upload a file to a server
* `scp_get`: download a file from a server
* `ssh2_command`: Run a command on a server

