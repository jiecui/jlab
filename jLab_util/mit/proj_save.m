% save scene to .prj file
sp = current_proj;
save(strcat(sp.pathname, sp.filename), 'current_proj');
clear sp;