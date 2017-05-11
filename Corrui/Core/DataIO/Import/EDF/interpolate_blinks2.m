function [sampledat blinx] = interpolate_blinks2( sampledat, blinktimes, blinkGap, enum )
%enum: should contain the fields left_x, left_y, right_x, right_y
% get the yes/no vector for the blinks
blinx = get_blinkYesNo_EyeLink2( sampledat, blinktimes ,blinkGap);
if ( sum(~blinx) == 0 )
    sampledat = sampledat;
    return;
end
% interpolate the blinks
% new_sampledat = sampledat;


LEFT = ~ (length(sampledat(:,enum.left_x)) == sum(isnan(sampledat(:,enum.left_x))));
RIGHT = ~ (length(sampledat(:,enum.right_x)) == sum(isnan(sampledat(:,enum.right_x))));

%% -- left eye ------------------------------------------------------------
if ( LEFT )
    left_x = double(fixnans(sampledat(:,enum.left_x)));
    left_y = double(fixnans(sampledat(:,enum.left_y)));
    blinx(1) = 0;
    blinx(end) = 0;
    
    if ( length(left_x) > sum(isnan(left_x)))
        left_x(blinx>0) = interp1( find( blinx==0 ), left_x(blinx==0), find( blinx>0 ), 'linear' );
        left_y(blinx>0) = interp1( find( blinx==0 ), left_y(blinx==0), find( blinx>0 ), 'linear' );
    end
    
    sampledat(:,enum.left_x) = left_x;
    sampledat(:,enum.left_y) = left_y;
end
clear left_x left_y
%% -- right eye -----------------------------------------------------------
if ( RIGHT )
    right_x = double(fixnans(sampledat(:,enum.right_x)));
    right_y = double(fixnans(sampledat(:,enum.right_y)));
    
    if ( length(right_x) > sum(isnan(right_x)))
        right_x(blinx>0) = interp1( find( blinx==0 ), right_x(blinx==0), find( blinx>0 ), 'linear' );
        right_y(blinx>0) = interp1( find( blinx==0 ), right_y(blinx==0), find( blinx>0 ), 'linear' );
    end
    
    sampledat(:,enum.right_x) = right_x;
    sampledat(:,enum.right_y) = right_y;
end



function x = fixnans(x)

if ( isnan(x(1)) )
    x(1) = x(min(find(~isnan(x))));
end
if ( isnan(x(end)) )
    x(1) = x(max(find(~isnan(x))));
end
