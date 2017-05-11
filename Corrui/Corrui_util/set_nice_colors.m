function set_nice_colors(ax)

icolor = 0;
if ( ~exist('ax') )
    ax = gca;
else
    if ( ~ishandle(ax) )
        icolor = ax;
        ax = gca;
    end
end

if ( ax == 0 )
    return
end

            COLORS.MEDIUM_BLUE		= [.1 .5 .8];
            COLORS.MEDIUM_RED		= [.9 .2 .2];
            COLORS.MEDIUM_GREEN		= [.5 .8 .3];
            COLORS.MEDIUM_GOLD      = [.9 .7 .1];
            COLORS.MEDIUM_PURPLE	= [.7 .4 .9];
            COLORS.MEDIUM_PINK		= [1 0.5 0.8];
            COLORS.MEDIUM_BLUE_GREEN= [.1 .8 .7];
            COLORS.MEDIUM_ORANGE	= [1 .6 .15];
            COLORS.LIGHT_BLUE		= [.1 .5 .8];
            COLORS.LIGHT_RED		= [1 .75 .75];
            COLORS.LIGHT_GREEN		= [.5 .8 .3];
            COLORS.LIGHT_ORANGE     = [.9 .7 .1];
            COLORS.DARK_GREEN		= [.0 .6 .3];
            COLORS.WHITE			= [1 1 1];
            COLORS.DARK_BLUE        = [0 20/255 80/255];
            COLORS.DARK_RED         = [130 10 0]/255;
            COLORS.MEDIUM_BROWN        = [155 102 50]/255;
            COLORS.GREY = [.5 .5 .5];
            

fields = fieldnames(COLORS);
for i=1:length(fields)
	colors_array(i,:) = COLORS.(fields{i});
end




childs = get(ax,'children');
for i=1:length(childs)
    objType = get(childs(i),'type');
    if ( isequal(objType, 'line' ) || isequal(objType, 'hggroup' )  )
        icolor = icolor+1;
        set( childs(i), 'color', colors_array(icolor,:));
    end
    if ( isequal(objType, 'patch' ) )
        set( childs(i), 'facecolor', colors_array(icolor,:));
    end
end
