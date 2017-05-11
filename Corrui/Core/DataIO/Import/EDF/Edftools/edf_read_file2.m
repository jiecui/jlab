function [samples,blinks,buttons,saccades]=edf_read_file2(fname)
%%  [samples,blinks,buttons] = edf_read_file2(fname)
%%
%% Returns arrays of sample data, buttons and blinks given a
%% name of an .EDF file

% old stuff trying to use their classes directly....
import com.neuralcorrelate.eyelinkaccess.*
efr = javaObject('com.neuralcorrelate.eyelinkaccess.EdfReader',fname);

% get the arrays out
samples=double(efr.getSamples);
blinks=double(efr.getBlinks);
buttons=double(efr.getButtons);
saccades=double(efr.getSaccades);

