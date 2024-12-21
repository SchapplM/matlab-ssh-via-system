function ssh2_struct = ssh2(ssh2_struct, arg2)
% SSH2   main control program for issuing SSH commands via Matlab's system
%
% SSH2(SSH2_CONN) uses the SSH2_CONN to perform a SSH2 function, e.g.
% issue a command or transfer a file using SCP or SFTP. All options for the
% SSH2 connection are specified in the SSH2_CONN struct. This struct can be
% configued manually, or by using any of the SSH2 support functions
% available. 
%
% The SSH2 structure is returned, but the connection can not be reused. 
%
% The connection is closed every time due to the implementation. T
%
%see also ssh2_config, ssh2_config_publickey, ssh2_command, scp_get, scp_put
%
% (c)2011 Boston University - ECE
%    David Scott Freedman (dfreedma@bu.edu)
%    (initial function architecture)
% (c)2024 Leibniz University Hannover
%    Moritz Schappler (moritz.schappler@imes.uni-hannover.de)
%    (changes due to using the system command)

%% BEGIN CODE

input_check = 0; % have not passed the input check
if nargin < 1
    ssh2_struct = [];
else
    if (isstruct(ssh2_struct))
        if (isfield(ssh2_struct,'verified_config') || ...
           isfield(ssh2_struct,'hostname') && ...
           isfield(ssh2_struct,'username') && ...
           isfield(ssh2_struct,'password') ) % min required inputs
                input_check = 1;
                ssh2_struct.verified_config = 1;
                if (nargin == 2)
                    ssh2_struct.command = arg2;
                end
        else

        end
    else
        if nargin >= 4
            input_check = 2; %alternate use of ssh2
        end
    end
end

% do we have enough to proceed?
if (input_check == 0)
    help ssh2.m;
    %fprintf('\n\n!!Incorrect input supplied to ssh2, please try again!!\n');
    if nargout == 0
        clear ssh2_struct
    end
else
  if ispc() % Windows
    cmd = sprintf('plink -ssh %s@%s -pw %s -batch %s', ssh2_struct.username, ...
      ssh2_struct.hostname, ssh2_struct.password, ssh2_struct.command);
    [status, cmdout] = system(cmd);
    initstr = sprintf(['Keyboard-interactive authentication prompts from server:\n', ...
       'End of keyboard-interactive prompts from server']);
    if contains(cmdout, initstr)
      cmdout = cmdout(length(initstr)+2:end);
    else
      warning('Unexepected format of plink output')
    end
  else % Linux
    cmd = sprintf('sshpass %s ssh %s@%s %s', ssh2_struct.password, ...
      ssh2_struct.username, ssh2_struct.hostname, ssh2_struct.command);
    [status, cmdout] = system(cmd);
  end
  % make each line an element of a cell array
  ssh2_struct.command_result = ...
    regexp(cmdout, '(.*)', 'tokens','dotexceptnewline')';
  for i = 1:numel(ssh2_struct.command_result)
     ssh2_struct.command_result{i} = char(ssh2_struct.command_result{i,1});
  end
  ssh2_struct.command_status = status;
end