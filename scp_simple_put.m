function ssh2_struct = scp_simple_put(hostname, username, password, localFilename, remotePath, localPath, remoteFilename)
% SCP_SIMPLE_PUT   creates a simple SSH2 connection and send a remote file
%
%   SCP_SIMPLE_PUT(HOSTNAME,USERNAME,PASSWORD,LOCALFILENAME,[REMOTEPATH][LOCALPATH],REMOTEFILENAME)
%   Connects to the SSH2 host, HOSTNAME with supplied USERNAME and
%   PASSWORD. Once connected the LOCALFILENAME is uploaded from the
%   remote host using SCP. The connection is then closed.
%
%   LOCALFILENAME can be either a single string, or a cell array of strings. 
%   If LOCALFILENAME is a cell array, all files will be downloaded
%   sequentially.
%
%   OPTIONAL INPUTS:
%   -----------------------------------------------------------------------
%   REMOTEPATH specifies a specific path to upload the file to. Otherwise, 
%   the default (home) folder is used.
%   LOCALPATH specifies the folder to find the LOCALFILENAME in the file
%   is outside the working directory.
%   REMOTEFILENAME can be specified to rename the file on the remote host.
%   If LOCALFILENAME is a cell array, REMOTEFILENAME must be too.
% 
%   SCP_SIMPLE_PUT returns the SSH2 structure for detailed information.
%
%see also scp_get, scp_put, scp, ssh2, ssh2_simple_command
%
% (c)2011 Boston University - ECE
%    David Scott Freedman (dfreedma@bu.edu)
%    Version 2.0

if nargin < 4
    ssh2_struct = [];
    help scp_simple_put
else
    if nargin < 5
        remotePath = '';
    end
    
    if nargin < 6
        localPath = pwd();
    elseif isempty(localPath)
        localPath = pwd();   
    end    

    ssh2_struct = ssh2_config(hostname, username, password);

    if nargin >= 7
        ssh2_struct.remote_file_new_name = remoteFilename;
    else 
        remoteFilename = [];
    end
    
    ssh2_struct = ssh2_config(hostname, username, password);
    ssh2_struct = scp_put(ssh2_struct, localFilename, remotePath, localPath, remoteFilename);
end


    
