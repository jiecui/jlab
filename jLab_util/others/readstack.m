function img = readstack(fname, varargin)
%READSTACK read either a list of 2D images (slices), or a 3D image
%
%  IMG = readstack(FNAME)
%  FNAME: base filename of images, without end number (string)
%  IMG: a 3-dimensional array of type uint8, size : X*Y*Z;
%    or a 4 dimensional array for color images (X*Y*C*Z).
%
%
%  IMG = readstack(FNAME, INDICES)
%  forces the number of dimensions of resulting array (slices images)
%  FNAME: base filename of images, without end number (string)
%  INDICES: indices of images to put for result. ex : 0:39
%
%  IMG = readstack(FNAME, TYPE, DIM)
%  forces the type and number of dimensions of resulting array.
%  FNAME: name of the single stack file
%  TYPE : matlab type of data ('uint8', 'double', ...)
%  DIM: size of final stack. Ex : [256 256 50].
%  There is no support for binary raw stacks.
%
%  IMG = readstack(..., 'verbose')
%  gives some information on the files 
%
%  IMG = readstack(..., 'silent')
%  does not display anything. This is the default mode.
%
%
%   See also : SAVESTACK
%   ---------
%
%   author : David Legland 
%   INRA - TPV URPOI - BIA IMASTE
%   created the 10/09/2003.
%

%   HISTORY : 
%   16/02/2004 : adapt to read image with name containing several '00'
%       Example : '~/images/avril2003/collees/cm1500.bmp'
%       In this case, consider only the last one.
%   19/02/2004 : don't allocate memory prior to load. This allows the
%       function to return an image appropriate with stored type.
%   04/06/2004 : automatically detect the number of files to read, and
%       reorganize structure 
%   14/10/2004 : correct bug for specifying range in slices images
%   17/10/2004 : add support for importing raw single files stacks
%   22/10/2004 : add support for verbose or silent modes
%   27/10/2004 : correct bug for color images in bundles/stacks


% select 'verbose' or 'silent' option  ----------------

% verbose by default
verbose = 0;

% check each input argument
for i=1:length(varargin)
    var = varargin{i};
    if ~ischar(var)
        continue;
    end
    
    % check the verbose option, and remove it from input variables
    if strcmp(var, 'verbose')
        verbose = 1;
        t = 1:length(varargin);
        varargin = varargin(t(t~=i));
        break;
    end

    % check the silent option, and remove it from input variables
    if strcmp(var, 'silent')
        verbose = 0;
        t = 1:length(varargin);
        varargin = varargin(t(t~=i));
        break;
    end
end

% import a raw file. First argument is type of image ('uint8' usually), 
% and second argument contains size of image to load.
if length(varargin)>1
    type = varargin{1};
    dim = varargin{2};
    
    img = zeros(dim, type);
    f = fopen(fname, 'r');
    img(:) = fread(f, dim(1)*dim(2)*dim(3), type);
    
    return;
end

% get image dimensions
info = imfinfo(fname);

if length(info)>1
    % Image stored in one bundle file --------------------------
    
    % If input argument is found, it is used as the number of slices to
    % read. Anyway, read all the slices.
    range = 1:length(info);
    if length(varargin)>0
        range = varargin{1};
    end

    if verbose
        disp(sprintf('read %d slices in a stack', length(range)));
    end
    
    % read each slice of the 3D image
    img = imread(fname, 1);
    
    if length(size(img))==2
        % read gray scale images
        
        % pre-allocate memory
        img(1, 1, length(range)) = 0;
        
        % add each slice
        if strcmp(fname(end-2:end),'gif')
            img = imread(fname, range);
            img = squeeze(img);
        else
            for i=2:length(range)
                img(:,:,i) = imread(fname, range(i));
            end
        end
    else
        % read color images
        
        % pre-allocate memory
        img(1, 1, 1, length(range)) = 0;
        
        % add each slice
        for i=2:length(range)
            img(:,:,:,i) = imread(fname, range(i));
        end
    end 
else
    % images stored in several 2D files ------------------------
    % -> need to know numbers of slices to read.

    % first identify number of '0' in file name
    for n=5:-1:1
        index = strfind(fname, repmat('0', [1 n]));
        if length(index)>0 
            break;
        end
    end
    
    % In the case of several '00' parts, consider only the last one 
    index = index(length(index));
        
    % create file basename and endname
	len = length(fname);
    basename = fname(1:index-1);
    endname = fname(index+n:len);

    % compute number of slices to read
    if length(varargin)>0
        % slice indices are given as parameters
        range=varargin{1};
    else            
        % identify slices to read by detecting last index of slices
        i=0;
        while true
            % check existence of file for given index
            imgname = sprintf(['%s' sprintf('%%0%dd', n) '%s'], basename, i, endname);
            if ~exist(imgname, 'file')
                break;
            end
            i = i+1;
        end
        % read slices from the first one to the last existing one
        range = 0:i-1;
    end
    if verbose
        disp(sprintf('read slices from %d to %d', range(1), range(length(range))));
    end
    
    % read slice for each range index
    string = [basename sprintf('%%0%dd', n)  endname];
	for i=1:length(range);
        img(:,:,i) = imread(sprintf(string, range(i)));
    end     
end

