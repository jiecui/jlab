function [sampledat blinx] = interpolate_blinks( sampledat, blinktimes, blinkGap )

% get the yes/no vector for the blinks
blinx = get_blinkYesNo_EyeLink( sampledat, blinktimes ,blinkGap);
if ( sum(~blinx) == 0 )
    sampledat = sampledat;
    return;
end
% interpolate the blinks
% new_sampledat = sampledat;


% LEFT = ( sum(isnan(sampledat(:,2))) < length(sampledat(:,2)) );
% RIGHT = ( sum(isnan(sampledat(:,3))) < length(sampledat(:,3)) );

LEFT = ( sum(sampledat(:,2)==9999) < length(sampledat(:,2)) );
RIGHT = ( sum(sampledat(:,3)==9999) < length(sampledat(:,3)) );

%% -- left eye ------------------------------------------------------------
if ( LEFT )
    left_x = double(fixnans(sampledat(:,2)));
    left_y = double(fixnans(sampledat(:,4)));
    left_x(left_x==9999)=nan;
    left_y(left_y==9999)=nan;
    blinx(1) = 0;
    blinx(end) = 0;
    
    if ( length(left_x) > sum(isnan(left_x)))
        left_x(blinx>0) = interp1( find( blinx==0 ), left_x(blinx==0), find( blinx>0 ), 'linear' );
        left_y(blinx>0) = interp1( find( blinx==0 ), left_y(blinx==0), find( blinx>0 ), 'linear' );
    end
    
    sampledat(:,2) = left_x;
    sampledat(:,4) = left_y;
end
clear left_x left_y
%% -- right eye -----------------------------------------------------------
if ( RIGHT )
    right_x = double(fixnans(sampledat(:,3)));
    right_y = double(fixnans(sampledat(:,5)));
    right_x(right_x==9999) = nan;
    right_y(right_y==9999) = nan;
    
    if ( length(right_x) > sum(isnan(right_x)))
        right_x(blinx>0) = interp1( find( blinx==0 ), right_x(blinx==0), find( blinx>0 ), 'linear' );
        right_y(blinx>0) = interp1( find( blinx==0 ), right_y(blinx==0), find( blinx>0 ), 'linear' );
    end
    
    sampledat(:,3) = right_x;
    sampledat(:,5) = right_y;
end



function x = fixnans(x)

% if ( isnan(x(1)) )
%     x(1) = x(min(find(~isnan(x))));
% end
% if ( isnan(x(end)) )
%     x(1) = x(max(find(~isnan(x))));
% end
if ( x(1)==9999 )
    x(1) = x(min(find(x~=9999)));
end
if ( isnan(x(end)) )
    x(1) = x(max(find(x~=9999)));
end
