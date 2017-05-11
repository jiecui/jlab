%% == get_plot_title
function tit = get_plot_title( sessname, title, which_eye)

which_eye_string = '';
if ( exist( 'which_eye' ) )
	switch(which_eye)
		case 'Left'
			which_eye_string = ', left eye';
		case 'Right'
			which_eye_string = ', right eye';
		case 'Both'
			which_eye_string = ', both eyes';
	end
end
tit = [sessname(3:end) '-' title which_eye_string];
%tit = [title which_eye_string];
