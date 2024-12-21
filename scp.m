function ssh2_struct = scp(ssh2_struct)
% SCP   Main SCP interface. The input struct provides all 
%       the parameters for the SSH2 function to perform a scp copy.
% 
%   SCP returns the SSH2 structure for detailed information.
%
%see also scp_get, scp_put, scp_simple_get, scp_simple_put
%
% (c)2011 Boston University - ECE
%    David Scott Freedman (dfreedma@bu.edu)
%    (initial function architecture)
% (c)2024 Leibniz University Hannover
%    Moritz Schappler (moritz.schappler@imes.uni-hannover.de)
%    (changes due to using the system command)

if nargin ~= 1
    ssh2_struct = [];
    help scp
    return
end
ssh2_struct.scp = 1;

if isfield(ssh2_struct, 'sendfiles') && ssh2_struct.sendfiles == 1      
  localfilepath = fullfile(ssh2_struct.local_target_direcory, ...
    ssh2_struct.local_file);
  if isfield(ssh2_struct, 'remote_file_new_name')
    remotefilepath = [ssh2_struct.remote_target_direcory, '/', ...
      ssh2_struct.remote_file_new_name];
  else
    remotefilepath = [ssh2_struct.remote_target_direcory, '/', ...
      ssh2_struct.local_file];
  end
  if ispc()
    cmd = sprintf('pscp -pw %s %s %s@%s:%s', ssh2_struct.password, ...
      localfilepath, ssh2_struct.username, ssh2_struct.hostname, remotefilepath);
  else
    cmd = sprintf('sshpass %s scp %s %s@%s:%s', ssh2_struct.password, ...
      localfilepath, ssh2_struct.username, ssh2_struct.hostname, remotefilepath);
  end
  [status, cmdout] = system(cmd);
elseif isfield(ssh2_struct, 'getfiles') && ssh2_struct.getfiles == 1
  remotefilepath = [ssh2_struct.remote_target_direcory, '/', ...
    ssh2_struct.remote_file];
  localfilepath = fullfile(ssh2_struct.local_target_direcory, ...
    ssh2_struct.remote_file);
  if ispc()
    cmd = sprintf('pscp -pw %s %s@%s:%s %s', ssh2_struct.password, ...
      ssh2_struct.username, ssh2_struct.hostname, remotefilepath, localfilepath);
  else
    cmd = sprintf('sshpass %s scp %s@%s:%s %s', ssh2_struct.password, ...
      ssh2_struct.username, ssh2_struct.hostname, remotefilepath, localfilepath);
  end
  [status, cmdout] = system(cmd);
else
  error('Mode not implemented yet');
end
if ispc()
  initstr = sprintf(['Keyboard-interactive authentication prompts from server:\n', ...
     'End of keyboard-interactive prompts from server']);
  if contains(cmdout, initstr)
    cmdout = cmdout(length(initstr)+2:end);
  else
    warning('Unexepected format of pscp output')
  end
end
% make each line an element of a cell array
ssh2_struct.command_result = ...
  regexp(cmdout, '(.*)', 'tokens','dotexceptnewline')';
for i = 1:numel(ssh2_struct.command_result)
   ssh2_struct.command_result{i} = char(ssh2_struct.command_result{i,1});
end
ssh2_struct.command_status = status;