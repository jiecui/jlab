function [session, armstruct] = dana_calc_arm(session, singletrial, sample)

% [session] = dana_calc_arm(session) calculates entire session
% [session, armstruct] = dana_calc_arm(session, singletrial, sample) returns the arm data for one timeslice

% envFlag semantics
% 0 -- no envelope, so means wristdat is on back of hand
% 1 -- Left Handed envelope
% 2 -- Right Handed envelope
% 3 -- Left "side of wrist" sensor for telemed supination-pronation RWT
% 4 -- Right "side of wrist" sensor for telemed supination-pronation RWT

% get old variables
raw_data = session.data;
trial_start = session.trial_start;
trial_end = session.trial_end;

% defaults
if nargin == 1
    singletrial = [];
    sample = [];
    armstruct = [];
end

if nargin == 2
    sample = 1;
end

if ~isempty(sample)
    % then in single sample mode
    singletrial = min(singletrial,length(session.trial_start));
    firsttrial = singletrial;
    lasttrial = singletrial;
else
    firsttrial = 1;
    lasttrial = length(trial_start);
end


for t = firsttrial:lasttrial,
    s1dat = raw_data(trial_start(t)+find(raw_data(trial_start(t)+1:trial_end(t)-1,1)==1),:);
    s2dat = raw_data(trial_start(t)+find(raw_data(trial_start(t)+1:trial_end(t)-1,1)==2),:);
    s3dat = raw_data(trial_start(t)+find(raw_data(trial_start(t)+1:trial_end(t)-1,1)==3),:);
    if ~isempty(sample)
        s1dat = s1dat(min(sample,size(s1dat,1)),:);
        s2dat = s2dat(min(sample,size(s2dat,1)),:);
        s3dat = s3dat(min(sample,size(s3dat,1)),:);
    end
    if isempty(s2dat) | isempty(s3dat)
        session.has_arm = 0;
        armstruct = [];
        return;
    else
        % check if we should set envelopeFlag, do something about parms!!
        
        switch session.scene_names{t}
        case {'RmailctrRWT.VR', 'RmailabdRWT.VR', 'RmailaddRWT.VR', 'SupineMailDiagR.VR', 'RRWTtelemedMAILCENTERdiag.VR', 'RRWTtelemedMAILCENTERhoriz.VR', 'RRWTtelemedMAILCENTERhoriz_glove.VR'}
            envFlag = 2;
            LRhand = 1;
            % convert to gl
            wristdat = pol2gl(s1dat);
            elbdat = pol2gl(s2dat);
        case {'LmailctrRWT.VR', 'LmailabdRWT.VR', 'LmailaddRWT.VR', 'SupineMailDiagL.VR', 'LRWTtelemedMAILCENTERdiag.VR', 'LRWTtelemedMAILCENTERhoriz.VR', 'LRWTtelemedMAILCENTERhoriz_glove.VR'}
            envFlag = 1;
            LRhand = 0;
            wristdat = pol2gl(s1dat);
            elbdat = pol2gl(s2dat);
        case {'LRWTtelemedSUP_PRON.VR', 'LRWTtelemedRepSUP_PRON.VR'}
            envFlag = 3;
            LRhand = 0;
            wristdat = pol2gl(s1dat);
            handdat = pol2gl(s3dat);
            elbdat = pol2gl(s2dat);
        case {'RRWTtelemedSUP_PRON.VR', 'RRWTtelemedRepSUP_PRON.VR'}
            envFlag = 4;
            LRhand = 1;
            wristdat = pol2gl(s1dat);
            handdat = pol2gl(s3dat);
            elbdat = pol2gl(s2dat);
        case {'RRWTtelemedSLEEVEPULL.VR'}
            envFlag = 0;
            LRhand = 1;
            wristdat = pol2gl(s1dat);
            elbdat = pol2gl(s2dat);
        case {'LRWTtelemedSLEEVEPULL.VR'}
            envFlag = 0;
            LRhand = 0;
            wristdat = pol2gl(s1dat);
            elbdat = pol2gl(s2dat);
        otherwise
            scn = session.scene_names{t};
            scn = scn(1:findstr(scn, '.')-1);
            envFlag = 0;
            if scn(1) == 'L' | scn(1) == 'l' | findstr(scn,'lft') | scn(length(scn)) == 'L' | findstr(scn, 'Left')
                LRhand = 0;
            else
                LRhand = 1;
            end
            %convert to gl transforms
            wristdat = pol2gl(s3dat);
            elbdat = pol2gl(s2dat);
        end
        % now calculate for entire trial
        if isempty(sample)
            for s=1:size(wristdat,3)
                armstruct = arm_model(wristdat(:,:,s),elbdat(:,:,s),envFlag,LRhand);
                armdat(t).raw_wrist(:,:,s) = armstruct.raw_wrist;
                armdat(t).raw_elbow(:,:,s) = armstruct.raw_elbow;
                armdat(t).shoulder(:,:,s) = armstruct.shoulder;
                armdat(t).elbow(:,:,s) = armstruct.elbow;
                armdat(t).forearm(:,:,s) = armstruct.forearm;
                armdat(t).wrist(:,:,s) = armstruct.wrist;
                armdat(t).wrist_angle(s) = armstruct.wrist_angle;
                armdat(t).rot_wrist(s,:) = armstruct.rot_wrist;
                armdat(t).forearm_elbow(:,:,s) = armstruct.forearm_elbow;
                armdat(t).pshoulder(s,:) = armstruct.pshoulder;
                armdat(t).eshoulder(s,:) = armstruct.eshoulder;
                armdat(t).eelbow(s,:) = armstruct.eelbow;
                armdat(t).ewrist(s,:) = armstruct.ewrist;
                armdat(t).env1(:,:,s) = armstruct.env1;
                armdat(t).env2(:,:,s) = armstruct.env2;
                armdat(t).env3(:,:,s) = armstruct.env3;
                if envFlag == 3 | envFlag == 4
                    % run again with hand data to get wrist angles
                    armstruct = arm_model(handdat(:,:,s),elbdat(:,:,s),0,LRhand);
                    armdat(t).raw_wrist(:,:,s) = armstruct.raw_wrist;
                    armdat(t).wrist(:,:,s) = armstruct.wrist;
                    armdat(t).wrist_angle(s) = armstruct.wrist_angle;
                    armdat(t).rot_wrist(s,:) = armstruct.rot_wrist;
                    armdat(t).ewrist(s,:) = armstruct.ewrist;
                end
            end
        else
            armstruct = arm_model(wristdat,elbdat,envFlag,LRhand);
        end
    end
end

if isempty(sample)
    session.has_arm = 1;
    session.arm_data = armdat;
end
