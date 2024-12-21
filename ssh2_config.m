function ssh2_struct = ssh2_config(hostname, username, password, port)
% SSH2_CONFIG   creates a structure for an SSH2 connection with the
%               specified hostname, username, and password
%               (this does not create the connection and is no handle)
%
%   SSH2_CONFIG(HOSTNAME,USERNAME,PASSWORD, [PORT])
%   Configures a connection to the host, HOSTNAME with user USERNAME and
%   password, PASSWORD.
%
%   OPTIONAL INPUTS:
%   -----------------------------------------------------------------------
%   PORT  to specify a non-standard SSH TCP/IP port. Default is 22.
%
% 
%see also ssh2_config_publickey, ssh2, ssh2_command, scp_get, scp_put
%
% (c)2011 Boston University - ECE
%    David Scott Freedman (dfreedma@bu.edu)
%    Version 2.0

ssh2_struct = struct(); % empty config
if (nargin >= 3)
    ssh2_struct.hostname = hostname;
    ssh2_struct.username = username;
    ssh2_struct.password = password;
    if nargin >= 4
        ssh2_struct.port = port; %#ok<STRNU>
        error('Port not implemented yet in the other functions')
    end
else
    help ssh2_config
end