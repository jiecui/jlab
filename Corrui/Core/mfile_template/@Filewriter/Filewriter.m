classdef Filewriter < handle
    % Class FILEWRITER prepare m-file template
    
    % Adapted from Matlab
    % Copyright 2010-2016 Richard J. Cui. Created: 02/21/2010 11:04:03.667 AM
    % $Revision: 0.2 $  $Date: Mon 08/29/2016 12:10:05.214 PM $
    %
    % 3236 E Chandler Blvd Unit 2036
    % Phoenix, AZ 85048, USA
    %
    % Email: richard.jie.cui@gmail.com

    % Property data is private to the class
    properties (SetAccess = private, GetAccess = private)
        FileID
    end % properties
    
    methods
        % Construct an object and
        % save the file ID
        function obj = Filewriter(filename)
            obj.FileID = fopen(filename,'w');
        end
        
        function writeToFile(obj,text_str)
            fprintf(obj.FileID,'%s\n',text_str);
        end
        % Delete methods are always called before a object
        % of the class is destroyed
        function delete(obj)
            fclose(obj.FileID);
        end
    end  % methods
end % class

% [EOF]