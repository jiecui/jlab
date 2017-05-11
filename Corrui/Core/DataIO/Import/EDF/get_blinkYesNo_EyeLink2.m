function blinkYesNo = get_blinkYesNo_EyeLink( sampledat, blinktimes, blinkGap, SEMIBLINK_TH )
% blinkYesNo get_blinkYesNo( blinktimes, nSamples)
% transform two vectors with the begnings and endings of the blinks to
% another one with 0 if te sample is not in a blink and 1 if yes. The
% samples of this vector correspond with the timestamps given.

LEFT = ~ (length(sampledat(:,3)) == sum(isnan(sampledat(:,3))));
RIGHT = ~ (length(sampledat(:,2)) == sum(isnan(sampledat(:,2))));

if ( size(sampledat,2) > 5 ) % if pupil is present
    SEMIBLINK_TH = -50;
    if ( LEFT && RIGHT)
        issemiblink = diff(sampledat(:,6)) < SEMIBLINK_TH | diff(sampledat(:,7)) < SEMIBLINK_TH;
    elseif ( LEFT )
        issemiblink = diff(sampledat(:,6)) < SEMIBLINK_TH;
    elseif ( RIGHT )
        issemiblink = diff(sampledat(:,7)) < SEMIBLINK_TH;
    end
else
    issemiblink = false(size(sampledat(:,1)));
end

%% get NaNs
if ( LEFT && RIGHT)
    sampledat(issemiblink,2) = nan;
    sampledat(issemiblink,3) = nan;
    sampledat(issemiblink,4) = nan;
    sampledat(issemiblink,5) = nan;
    isnanvector =  isnan(sampledat(:,2)) | isnan(sampledat(:,3)) | isnan(sampledat(:,4)) | isnan(sampledat(:,5));
elseif ( LEFT )
    sampledat(issemiblink,2) = nan;
    sampledat(issemiblink,4) = nan;
    isnanvector =  isnan(sampledat(:,2))  | isnan(sampledat(:,4));
elseif ( RIGHT )
    sampledat(issemiblink,3) = nan;
    sampledat(issemiblink,5) = nan;
    isnanvector =  isnan(sampledat(:,3)) | isnan(sampledat(:,5));
end
loidx	= max( find( diff(isnanvector) > 0 ) - blinkGap , 1);
hiidx	= min( find( diff(isnanvector) < 0 ) + blinkGap, length(isnanvector));

% if there is nan at the end add the last low
if ( isnanvector(end) == 1 )
    hiidx(end+1,1) = length(isnanvector);
end
% if there is nan at the begining add the first hi
if ( isnanvector(1) == 1 )
    loidx = [1;loidx];
end

nans = zeros(size(sampledat(:,1),1),1);
nans(lohi2idx(loidx,hiidx)) = 1;

%% get blinks
blinks = zeros(length(sampledat(:,1)),1);

if ~isempty(blinktimes)
    blinktimes = [blinktimes(:,1)-blinkGap blinktimes(:,2)+blinkGap];
    bstart = binscr(double(sampledat(:,1)'),double(blinktimes(:,1)'));
    bend = binscr(double(sampledat(:,1)'),double(blinktimes(:,2)'));
    % get index of samples inside the blinks
    blinks_idx = lohi2idx(bstart,bend);
    blinks(blinks_idx) = 1;
end

% the final result, eyelink blinks plus NaNs that have not been detected
%
blinkYesNo = blinks | nans ;
