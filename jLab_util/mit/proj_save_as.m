% save to a particular name
sap = current_proj;
[sap.newfilename, sap.newpathname] = uiputfile(sap.filename, 'Save Project As');
if (sap.newfilename == 0),
   % 'cancel' condition
   return
else
	save(strcat(sap.newpathname,sap.newfilename), 'current_proj');
   clear sap;
end;
