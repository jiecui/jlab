function dat = edf_read_multi_files(edfnames)
% function dat = incrthresh_read_files(fname)
% use the given string to read fname.edf and the associated .ctx file, then
% put all the data in dat

dat = [];
dat.edfSamples = [];
dat.edfBlinks = [];
dat.edfButtons = [];
dat.edfSaccades = [];
numSamples = 0;
numColumns = 1;
for edfname=edfnames
    [dat.samples,dat.blinks,dat.buttons,dat.saccades]=edf_read_file2(char(edfname));
    save([char(edfname) '.mat'],'dat');
    numSamples = numSamples + size(dat.samples,1);
    numColumns = size(dat.samples,2);
    clear dat
end 
dat = [];

% pre-allocate
dat.samples = zeros(numSamples,numColumns);
dat.blinks = [];
dat.buttons = [];
dat.saccades = [];

curRow = 0;
for edfname=edfnames
    data = load([char(edfname) '.mat'],'dat');
    data = data.dat;
    delete([char(edfname) '.mat']);
    dat.samples(curRow+1:curRow+size(data.samples,1),:) = data.samples;
    curRow = curRow + size(data.samples,1);
    dat.blinks = [dat.blinks;data.blinks];
    dat.buttons = [dat.buttons;data.buttons];
    dat.saccades = [dat.saccades;data.saccades];
end

