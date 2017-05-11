function patch_handle = patch_error_function(ax, x_values, mean_data, error_data, color, transparency_value )
axes(ax); 
set(ax, 'nextplot', 'add')
xind_double = [x_values   x_values(end:-1:1)];

err_plus = mean_data + error_data;
err_minus =  mean_data - error_data;

 err =	[err_plus   err_minus(end:-1:1)]; 
 
 
 idxNan = isnan(err);

patch_handle = patch( xind_double(~idxNan), err(~idxNan), '-', 'FaceColor', color, 'LineStyle', 'none','FaceAlpha','flat','FaceVertexAlphaData', transparency_value,'AlphaDataMapping','none');
