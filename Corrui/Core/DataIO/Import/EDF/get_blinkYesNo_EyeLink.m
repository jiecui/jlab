function blinkYesNo = get_blinkYesNo_EyeLink( sampledat, blinktimes, blinkGap )
% blinkYesNo get_blinkYesNo( blinktimes, nSamples)
% transform two vectors with the begnings and endings of the blinks to
% another one with 0 if te sample is not in a blink and 1 if yes. The
% samples of this vector correspond with the timestamps given.

% timestamps = sampledat(:,1);

% if ( strcmp( eye, 'left' ) )
% 	x = sampledat(:,2);
% 	y = sampledat(:,4);
% else
% 	x = sampledat(:,3);
% 	y = sampledat(:,5);
% end
% if ( size(sampledat,2) > 5 ) % if pupil is present
%     SEMIBLINK_TH = -50;
%     if ( length(sampledat(:,3)) == sum(isnan(sampledat(:,3))))
%         issemiblink = diff(sampledat(:,6)) < SEMIBLINK_TH;
%     elseif ( length(sampledat(:,2)) == sum(isnan(sampledat(:,2))))
%         issemiblink = diff(sampledat(:,7)) < SEMIBLINK_TH;
%     else
%         issemiblink = diff(sampledat(:,6)) < SEMIBLINK_TH | diff(sampledat(:,7)) < SEMIBLINK_TH;
%     end
% else
%     issemiblink = zeros(size(timestamps));
% end
if ( size(sampledat,2) > 5 ) % if pupil is present
    SEMIBLINK_TH = -50;
    if ( length(sampledat(:,3)) == sum(sampledat(:,3)==9999))
        issemiblink = diff(sampledat(:,6)) < SEMIBLINK_TH;
    elseif ( length(sampledat(:,2)) == sum(sampledat(:,2)==9999))
        issemiblink = diff(sampledat(:,7)) < SEMIBLINK_TH;
    else
        issemiblink = diff(sampledat(:,6)) < SEMIBLINK_TH | diff(sampledat(:,7)) < SEMIBLINK_TH;
    end
else
    issemiblink = false(size(sampledat(:,1)));
end

%% get NaNs
if ( length(sampledat(:,2)) == sum(sampledat(:,2)==9999))
    sampledat(issemiblink,3) = 9999;
    sampledat(issemiblink,5) = 9999;
    isnanvector =  sampledat(:,3) == 9999 |  sampledat(:,5) == 9999;
elseif ( length(sampledat(:,3)) == sum(sampledat(:,3)==9999))
    sampledat(issemiblink,2) = 9999;
    sampledat(issemiblink,4) = 9999;
    isnanvector =  sampledat(:,2)==9999 | sampledat(:,4)==9999;
else
    sampledat(issemiblink,3) = 9999;
    sampledat(issemiblink,5) = 9999;
    sampledat(issemiblink,2) = 9999;
    sampledat(issemiblink,4) = 9999;
    isnanvector =  sampledat(:,2)==9999 | sampledat(:,3)==9999 | sampledat(:,4)==9999 | sampledat(:,5)==9999;
end
loidx	= max( find( diff(isnanvector) > 0 ) - blinkGap , 1);
hiidx	= min( find( diff(isnanvector) < 0 ) + blinkGap, length(isnanvector));

% if ( length(sampledat(:,2)) == sum(isnan(sampledat(:,2))))
%     sampledat(find(issemiblink),3) = NaN;
%     sampledat(find(issemiblink),5) = NaN;
% 	isnanvector =  isnan(sampledat(:,3)) |  isnan(sampledat(:,5));
% elseif ( length(sampledat(:,3)) == sum(isnan(sampledat(:,3))))
%     sampledat(find(issemiblink),2) = NaN;
%     sampledat(find(issemiblink),4) = NaN;
% 	isnanvector =  isnan(sampledat(:,2)) | isnan(sampledat(:,4));
% else
%     sampledat(find(issemiblink),3) = NaN;
%     sampledat(find(issemiblink),5) = NaN;
%     sampledat(find(issemiblink),2) = NaN;
%     sampledat(find(issemiblink),4) = NaN;
% 	isnanvector =  isnan(sampledat(:,2)) | isnan(sampledat(:,3)) | isnan(sampledat(:,4)) | isnan(sampledat(:,5));
% end
% loidx	= max( find( diff(isnanvector) > 0 ) - blinkGap , 1);
% hiidx	= min( find( diff(isnanvector) < 0 ) + blinkGap, length(isnanvector));


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



%
%
% %% get weird values
% isbadvector = (abs(diff(sampledat(:,2)))>500) | (abs(diff(sampledat(:,3)))>500) | (abs(diff(sampledat(:,4)))>500) | (abs(diff(sampledat(:,5)))>500);
% loidx	= max( find( diff(isbadvector) > 0 ) - blinkGap , 1);
% hiidx	= min( find( diff(isbadvector) < 0 ) + blinkGap, length(isbadvector));
%
% % if there is nan at the end add the last low
% if ( isbadvector(end) == 1 )
% 	hiidx(end+1) = length(isbadvector);
% end
% % if there is nan at the begining add the first hi
% if ( isbadvector(1) == 1 )
% 	loidx = [1;loidx];
% end
%
% bads = zeros(length(timestamps),1);
% bads(lohi2idx(loidx,hiidx)) = 1;





%% get blinks
blinks = zeros(length(sampledat(:,1)),1);

if ~isempty(blinktimes)
    blinktimes = [blinktimes(:,1)-blinkGap blinktimes(:,2)+blinkGap];
    search_start = 1;
    bstart = binscr(double(sampledat(:,1)'),double(blinktimes(:,1)'));
    bend = binscr(double(sampledat(:,1)'),double(blinktimes(:,2)'));
    % get index of samples inside the blinks
    blinks_idx = lohi2idx(bstart,bend);
    blinks(blinks_idx) = 1;
end

% the final result, eyelink blinks plus NaNs that have not been detected
%
% blinkYesNo = blinks | nans | bads;
blinkYesNo = blinks | nans ;
