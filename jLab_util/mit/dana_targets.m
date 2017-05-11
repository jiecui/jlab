function session = dana_targets(session)


old_setup = 0;
keylock_flipped = 0;

try
   if session.old_setup
      old_setup = 1;
   end
catch
   old_setup = 0;
end

try
   if session.keylock_flipped
      keylock_flipped = 1;
   end
catch
   keylock_flipped = 0;
end

slot_offset = 8.75;
handsh_offset = 5.25;
handsh_z_offset = 5.00;
reach_sr_offset = 5.0;
beg_offset = 3.5;
key_hand_offset = 8.0;
key_forward_offset = 12.0;
key_right_offset = 11.0;

% get old variables
raw_data = session.data;
trial_start = session.trial_start;
trial_end = session.trial_end;

% signflags indicates whether the resulting error values should be mult. by -1 or
% not, so that e.g. roll error in a mail scene is consistent between left and right

if isfield(session, 'signflags'),
    signflags = session.signflags;
else
    signflags = ones(length(trial_start),3);
end


% offset_matrix is a set of 4x4's that describe a common orientation offset to be applied to both target and sensor-1
% orientations before taking the euler angles so that discontinuities can be avoided
for i=1:length(trial_start)
   offset_matrix(:,:,i)=eye(4,4);
   emethods(i) = 'B';
end

% DEBUG length(trial_start)

%targets will be place-holders
% I am going to calculate the targets here now, depending on the scene name
for i = 1:length(trial_start),
   % get data
   trial_data = raw_data(trial_start(i)+find(raw_data(trial_start(i)+1:trial_end(i)-1,1)==1),:);
   % get the 4th sensor data
   s4data = raw_data(trial_start(i)+find(raw_data(trial_start(i)+1:trial_end(i)-1,1)==4),:);
   % is s4 going to be empty...
   if isempty(s4data)
      session.orient_valid = 0;
      spat = [];
      orient = [];
      return;
   else
      session.orient_valid = 1;
	   % get average of samples' x-y-z location
   	targets(i, :) = mean(s4data);
   	% prepare for conversion to transform matrices
   	targets(i, 6:14) = [targets(i, 6:8)./repmat(sqrt(sum(targets(i, 6:8)'.^2))', 1,3) ...
         targets(i, 9:11)./repmat(sqrt(sum(targets(i, 9:11)'.^2))', 1,3) ...
         targets(i, 12:14)./repmat(sqrt(sum(targets(i, 12:14)'.^2))', 1,3)];
   end
end;

% convert to transforms
targets = pol2gl(targets);

for i = 1:length(trial_start),
   % check scene name
   switch session.scene_names{i},
   	case{'RmailctrRWT.VR', 'RmailabdRWT.VR', 'RmailaddRWT.VR', 'SupineMailDiagR.VR' }
         % target is 45 deg.
         targets(1:3,4,i) = targets(1:3,4,i) + targets(1:3,1,i).*(ones(1,3)*slot_offset)';
         targets(:,:,i) = targets(:,:,i) * rotz(pi/2);
         targets(:,:,i) = targets(:,:,i) * roty(pi/2);
         signflags(i,:) = [-1 -1 1];
      case{'LmailctrRWT.VR', 'LmailabdRWT.VR', 'LmailaddRWT.VR', 'SupineMailDiagL.VR', 'LRWTtelemedMAILCENTERhoriz.VR', 'LRWTtelemedMAILCENTERdiag.VR'}
         targets(1:3,4,i) = targets(1:3,4,i) + targets(1:3,1,i).*(ones(1,3)*slot_offset)';
         targets(:,:,i) = targets(:,:,i) * rotz(-pi/2);
         targets(:,:,i) = targets(:,:,i) * roty(pi/2);
         % below is suspect, since L905 showed positive errors for under-rotation
         signflags(i,:) = [1 1 -1];
         %if strcmp(session.scene_names{i},'LmailabdRWT.VR')
         %   emethods(i) = 'A';
         %end
      case{'RhandshakeRWT.VR' }
         if old_setup
            %disp('got to old_setup');
            % just translate up, rotate some axis(es) by 90 deg.
   	      targets(1:3,4,i) = targets(1:3,4,i) + targets(1:3,3,i).*(ones(1,3)*handsh_offset)';
            targets(:,:,i) = targets(:,:,i) * rotz(-pi/4);
            targets(:,:,i) = targets(:,:,i) * rotx(pi/2);
            %targets(:,:,i) = targets(:,:,i) * roty(pi/2);
         else
	         % just translate up, rotate some axis(es) by 90 deg.
            targets(1:3,4,i) = targets(1:3,4,i) + targets(1:3,1,i).*(ones(1,3)*handsh_offset)';
            targets(1:3,4,i) = targets(1:3,4,i) + targets(1:3,3,i).*(ones(1,3)*handsh_z_offset)';
      	   targets(:,:,i) = targets(:,:,i) * rotz(pi/2);
            targets(:,:,i) = targets(:,:,i) * roty(pi/2);
         end
      case{'LhandshakeRWT.VR'}
         if old_setup
            %disp('got to old_setup');
            % just translate up, rotate some axis(es) by 90 deg.
   	      targets(1:3,4,i) = targets(1:3,4,i) + targets(1:3,3,i).*(ones(1,3)*handsh_offset)';
            targets(:,:,i) = targets(:,:,i) * rotz(pi/4);
            targets(:,:,i) = targets(:,:,i) * rotx(-pi/2);
            %targets(:,:,i) = targets(:,:,i) * roty(pi/2);
         else
         	% just translate up, rotate some axis(es) by 90 deg.
            targets(1:3,4,i) = targets(1:3,4,i) + targets(1:3,1,i).*(ones(1,3)*handsh_offset)';
            targets(1:3,4,i) = targets(1:3,4,i) + targets(1:3,3,i).*(ones(1,3)*handsh_z_offset)';
        	   targets(:,:,i) = targets(:,:,i) * rotz(-pi/2);
            targets(:,:,i) = targets(:,:,i) * roty(pi/2);
         end
         signflags(i,:) = [1 -1 -1];
      case{'R30ReachSideRightRWT.VR', 'R45ReachSideRightRWT.VR', 'R60ReachSideRightRWT.VR', 'R75ReachSideRightRWT.VR', 'RSupineReachexactRWT.VR'}
      	% translate up, maybe rotate by variable degrees - Maureen?
         targets(1:3,4,i) =  targets(1:3,4,i) + targets(1:3,3,i).*(ones(1,3)*reach_sr_offset)';
         targets(:,:,i) = targets(:,:,i) * rotz(-pi/2);
      case{'L30ReachSideLeftRWT.VR', 'L45ReachSideLeftRWT.VR', 'L60ReachSideLeftRWT.VR', 'L75ReachSideLeftRWT.VR', 'LSupineReachexactRWT.VR', ...
            'L30ReachSideRightRWT.VR', 'L45ReachSideRightRWT.VR', 'L60ReachSideRightRWT.VR', 'L75ReachSideRightRWT.VR'}
      	% translate up, maybe rotate by variable degrees - Maureen?
         targets(1:3,4,i) =  targets(1:3,4,i) + targets(1:3,3,i).*(ones(1,3)*reach_sr_offset)';
         targets(:,:,i) = targets(:,:,i) * rotz(pi/2);
         signflags(i,:) = [-1 1 -1];
   	case{'LReachBegRWT.VR'}
      	% translate up, flip 180?
         targets(1:3,4,i) = targets(1:3,4,i) + targets(1:3,3,i).*(ones(1,3)*beg_offset)';
         targets(:,:,i) = targets(:,:,i) * rotz(pi/4);
         targets(:,:,i) = targets(:,:,i) * rotx(pi);
         %signflags(i,:) = [1 1 1];
         offset = eye(4,4);
         offset = offset * rotz(-pi/2);
         offset_matrix(:,:,i) = offset';
         emethods(i) = 'B';
      case{'RReachBegRWT.VR'}
      	% translate up, flip 180?
         targets(:,:,i) = targets(:,:,i) * rotz(-pi/4);
         targets(1:3,4,i) = targets(1:3,4,i) + targets(1:3,3,i).*(ones(1,3)*beg_offset)';
         targets(:,:,i) = targets(:,:,i) * rotx(pi);
         %targets(:,:,i) = targets(:,:,i) * rotz(-pi/2);
         %offset = eye(4,4);
         %offset = offset * -roty(pi/4);
         %offset_matrix(:,:,i) = offset;
         signflags(i,:) = [1 1 -1];
         %emethods(i) = 'A';
   	case{'LkeylockboxRWT.VR','LkeylockRWT.VR'}
         % translate up (towards patient), forward, then right, then rotate along z axis some amount
         targets(1:3,4,i) = targets(1:3,4,i) + targets(1:3,3,i).*(ones(1,3)*key_hand_offset)';
         targets(1:3,4,i) = targets(1:3,4,i) + targets(1:3,1,i).*(ones(1,3)*key_forward_offset)';
         if keylock_flipped
            targets(1:3,4,i) = targets(1:3,4,i) - targets(1:3,2,i).*(ones(1,3)*key_right_offset)';
         else
            targets(1:3,4,i) = targets(1:3,4,i) + targets(1:3,2,i).*(ones(1,3)*key_right_offset)';
         end
         targets(:,:,i) = targets(:,:,i) * rotz(-pi/2);
         targets(:,:,i) = targets(:,:,i) * roty(pi/4);
			targets(:,:,i) = targets(:,:,i) * rotx(-pi/12);
         signflags(i,:) = [1 -1 -1];
         offset = eye(4,4);
         offset = offset * rotz(-pi/4);
         offset_matrix(:,:,i) = offset;
      case{'RkeylockboxRWT.VR','RkeylockRWT.VR'}
      	% translate up (towards patient), forward, then left, then rotate along z axis some amount
         targets(1:3,4,i) = targets(1:3,4,i) + targets(1:3,3,i).*(ones(1,3)*key_hand_offset)';
         targets(1:3,4,i) = targets(1:3,4,i) + targets(1:3,1,i).*(ones(1,3)*key_forward_offset)';
         if keylock_flipped
            targets(1:3,4,i) = targets(1:3,4,i) + targets(1:3,2,i).*(ones(1,3)*key_right_offset)';
			else
            targets(1:3,4,i) = targets(1:3,4,i) - targets(1:3,2,i).*(ones(1,3)*key_right_offset)';
         end
         targets(:,:,i) = targets(:,:,i) * rotz(pi/2);
         targets(:,:,i) = targets(:,:,i) * roty(pi/4);
			targets(:,:,i) = targets(:,:,i) * rotx(pi/12);         
         signflags(i,:) = [1 1 1];
		case{'RhandLumbarRWT.VR'}
			targets(:,:,i) = targets(:,:,i) * rotx(pi);
         targets(:,:,i) = targets(:,:,i) * rotz(-pi/2);
      case{'LhandLumbarRWT.VR'}
		    targets(:,:,i) = targets(:,:,i) * rotx(pi);
         targets(:,:,i) = targets(:,:,i) * rotz(pi/2);
         signflags(i,:) = [-1 1 -1];
      case{'RsleevepullRWT.VR'}
      case{'LsleevepullRWT.VR'}
         signflags(i,:) = [-1 1 -1];
      	% no translation, just average
    case{'LRWTtelemedSUP_PRON.VR', 'LRWTtelemedRepSUP_PRON.VR'}
       targets(:,:,i)= eye(4,4);
       targets(:,:,i) = targets(:,:,i) * rotz(pi);
       targets(:,:,i) = targets(:,:,i) * rotx(pi/2);
       signflags(i,:) = [1 1 -1];
   case{'RRWTtelemedSUP_PRON.VR', 'RRWTtelemedRepSUP_PRON.VR'}
       targets(:,:,i)= eye(4,4);
       targets(:,:,i) = targets(:,:,i) * rotz(pi);
       targets(:,:,i) = targets(:,:,i) * rotx(-pi/2);
	end
end;

orients = targets;
session.orient_targets = orients;

% re-calculating is BULLSHIT! I should just take x,y,z and put into targets
for i = 1:length(trial_start),
   spats(i,1:3) = orients([2 1 3],4,i)';
end
spats(:,3) = -spats(:,3);
session.spatial_targets = spats;
session.emethods = emethods;
session.offset_matrices = offset_matrix;
session.signflags = signflags;

