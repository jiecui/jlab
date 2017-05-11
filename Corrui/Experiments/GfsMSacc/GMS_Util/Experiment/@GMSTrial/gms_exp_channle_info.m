function [area_code, electrode_num, grid_idx] = gms_exp_channle_info(this)
% GMSTRIAL.GMS_EXP_CHANNLE_INFO get GMS exp channel/electrode info
%
% Syntax:
%   [area_code, electrode_num, grid_idx] = gms_exp_channle_info(this)
% 
% Input(s):
%   this    - class of GMSTrial
%
% Output(s):
%   area_code       - code of cortical areas where the electrode was placed
%                     0 = unknown area; 1 = V1; 2 = V2; 3 = not defined; 4
%                     = V4; 10 = maybe in V1, but probably too deep (in
%                     V2); 20 = maybe in V2, but probably too deep (in V4);
%                     40 = may be in V4, but probably too deep; -100 =
%                     unknown area; -4 = V4 but not secured; -2 = V2 but no
%                     secured; -3 = not defined; -1 = V1 but not secured.
%   electrode_num   - index number of the electrode
%   grid_idx        - index of grid of electrode placement
%
% Example:
%
% See also .

% Copyright 2016 Richard J. Cui. Created: Tue 03/29/2016  5:03:35.634 AM
% $Revision: 0.2 $  $Date: Thu 03/31/2016  2:44:29.818 AM $
%
% 3236 E Chandler Blvd Unit 2036
% Phoenix, AZ 85048, USA
%
% Email: richard.jie.cui@gmail.com

% get session name
sname = this.sname;
snm = upper(sname(1:(end - 1)));     % not include the last letter

% get info
SI = struct('electrodes', [], 'gridhole', [], 'Areasynth', []);
switch snm
    % ---------
    % Ernst - E
    % ---------
    case {'E020503'}
        SI.electrodes   = [1 2 4 5 6 7 9 10 11 12 13 14 15];
        SI.gridhole     = [208 222 205 206 171 196 210 142 106 194 190 176 140];
        SI.Areasynth    = [40 40 10 40 20 30 1 2 4 -3 30 20 -100];

    case {'E030603'}
        SI.electrodes   = [1 2 3 4 6 7 9 10 12 13 14 15];
        SI.gridhole     = [208 223 235 205 171 196 210 142 161 190 176 140];
        SI.Areasynth    = [40 1 1 40 40 40 40 2 20 3 20 -100];
                
    case {'E040603'}
        SI.electrodes   = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15];
        SI.gridhole     = [103 222 235 205 139 171 196 208 210 224 211 162 190 176 177];
        SI.Areasynth    = [4 1 1 1 -100 40 40 -1 10 40 40 2 40 40 2];
        
    case {'E060603'}
        SI.electrodes   = [2 3 4 5 8 9 10 11 12 13 14 15];
        SI.gridhole     = [210 207 85 103 87 194 209 178 144 173 158 159];
        SI.Areasynth    = [40 40 4 4 4 30 1 2 2 2 -2 -2];
        
    case {'E110403'}
        SI.electrodes   = [3 5 6 7 9 10 11 13 14];
        SI.gridhole     = [121 100 137 174 179 142 105 38 50];
        SI.Areasynth    = [-100 4 -100 2 2 2 4 4 4];
        
    case {'E120403'}
        SI.electrodes   = [3 5 7 8 9 10 11 12 13 14 15];
        SI.gridhole     = [139 118 191 223 196 160 123 86 52 66 81];
        SI.Areasynth    = [-100 -100 3 1 3 2 -100 4 4 4 4];
        
    case {'E130403'}    % filename=130403_ernst_gfs_13mini05_grat_p2_4
        SI.electrodes   = [3 5 7 8 9 10 11 12 13 14 15];
        SI.gridhole     = [103 82 156 192 161 124 87 53 24 35 48];
        SI.Areasynth    = [4 4 2 3 2 -100 4 4 4 4 4];
                
    case {'E140303'}    % filename=140403_ernst_gfs_3455_1min05_pr2_disk
        SI.electrodes   = [3 5 6 7 8 9 10 11 13 14 15];
        SI.gridhole     = [121 100 137 174 208 179 143 181 49 36 52];
        SI.Areasynth    = [-100 4 -100 2 1 2 2 2 4 4 4];
        
    case {'E150403'}    % 150403_ernst_gfs_pr2_3455_1min1_grat
        SI.electrodes   = [3 5 6 7 8 9 10 11 12 13 14 15];
        SI.gridhole     = [122 82 174 117 208 179 143 181 13 49 36 52];
        SI.Areasynth    = [-100 4 2 -100 10 2 2 20 4 4 4 4];
        
    case {'E160403'}
        SI.electrodes   = [3 6 7 8 9 10 11 12 14 15];
        SI.gridhole     = [157 173 153 160 195 179 177 36 67 85];
        SI.Areasynth    = [2 2 3 2 3 2 2 4 4 4];
        
    case {'E170403'}
        SI.electrodes   = [3 4 5 7 8 9 10 11 12 13 14 15];
        SI.gridhole     = [234 173 137 101 66 227 210 211 209 193 206 46];
        SI.Areasynth    = [1 2 3 4 4 1 1 1 1 1 1 4];
        
    case {'E180403'}
        SI.electrodes   = [3 4 5 7 8 9 10 11 12 13 14 15];
        SI.gridhole     = [245 190 155 119 22 240 225 226 96 210 221 62];
        SI.Areasynth    = [10 3 2 -100 4 1 1 1 -100 1 1 4];
        
    case {'E190403'}
        SI.electrodes   = [3 4 8 9 10 11 12 13 14 15];
        SI.gridhole     = [221 155 23 212 194 195 61 177 190 18];
        SI.Areasynth    = [1 2 4 1 3 3 4 2 3 4];
        
    case {'E200403'}    % filename=200403_ernst_gfs_6789_disk_pr1_4 %UNKLAR, EINE ELEKTRODE ZU WENIG AUSGENOMMEN. CHECKEN!
        SI.electrodes   = [3 4 5 7 9 10 12 13 14 15];
        SI.gridhole     = [234 224 22 25 227 179 80 193 206 31];
        SI.Areasynth    = [1 1 4 4 1 2 4 3 1 4];
        
    case {'E210403'}    % filename=210403_ernst_gfs_6789_pr1_4_07min1
        SI.electrodes   = [2 3 4 7 8 9 10 11 12 13 14];
        SI.gridhole     = [31 233 45 20 12 227 225 61 80 193 205];
        SI.Areasynth    = [4 1 4 4 4 1 1 4 4 3 10];
        
    case {'E220403'}
        SI.electrodes   = [2 3 4 5 7 8 9 10 11 12 13 14];
        SI.gridhole     = [];
        SI.Areasynth    = [4 -100 4 4 4 4 1 1 4 4 1 10];
        
    case {'E230403'}
        SI.electrodes   = [3 4 5 7 9 11 12 13];
        SI.gridhole     = [134 63 49 35 227 80 79 213];
        SI.Areasynth    = [30 4 4 4 1 4 4 1];
        
    case {'E240403'}
        SI.electrodes   = [2 3 4 5 7 8 9 10 11 12 13 14];
        SI.gridhole     = [239 232 61 47 33 221 108 72 78 71 174 54];
        SI.Areasynth    = [1 10 4 4 4 1 4 4 4 4 2 4];
        
    case {'E250403'}
        SI.electrodes   = [3 4 7 9 10 11 12];
        SI.gridhole     = [221 80 16 74 58 128 57];
        SI.Areasynth    = [10 4 4 4 4 4 4];
        
    case {'E260403'}
        SI.electrodes   = [3 4 5 7 8 10 11 12 13 14];
        SI.gridhole     = [202 204 206 208 210 47 49 51 53 55];
        SI.Areasynth    = [1 1 1 1 1 4 4 4 4 4];
        
    case {'E270403'}
        SI.electrodes   = [2 3 4 5 9 10 12 13 14];
        SI.gridhole     = [169 211 209 207 161 177 174 172 77];
        SI.Areasynth    = [30 10 1 1 20 20 20 20 4];
        
    case {'E280403'}
        SI.electrodes   = [2 3 4 9 10 13 14];
        SI.gridhole     = [161 202 204 196 195 189 187];
        SI.Areasynth    = [-100 -1 1 2 3 30 30];
        
    case {'E290403'}
        SI.electrodes   = [2 3 4 5 7 10 11 13 14];
        SI.gridhole     = [];
        SI.Areasynth    = [40 -1 3 -100 -100 1 2 -3 -3];
            
    case {'E230503'}    % new Sessions Ernst ab 23.05 (als 1 eingeordnet, was im 1.Cortex war (kann auch V1 sein))
        SI.electrodes   = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15];
        SI.gridhole     = [180 178 176 162 160 158 144 142 104 106 108 122 124 126 140];
        SI.Areasynth    = [2 2 -2 2 -2 -2 2 -2 4 4 4 -100 -100 4 3];
        
    case {'E240503'}    % gute electrodes        
        SI.electrodes   = [1 2 3 4 8 9 12 13 14 15];
        SI.gridhole     = [];
        SI.Areasynth    = [2 1 1 2 -100 -100 -100 2 -100 4];
        
    case {'E250503'}
        SI.electrodes   = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15];
        SI.gridhole     = [238 210 177 141 237 209 176 180 227 196 161 125 198 181 127];
        SI.Areasynth    = [40 40 -2 -100 -1 1 -2 -2 10 -3 2 4 30 2 4];
        
    case {'E260503'}    % keine daten vom 26.06.2003
        SI.electrodes   = [1 2 3 5 6 9 10 12 14];
        SI.gridhole     = [];
        SI.Areasynth    = [-100 -100 -100 -100 -100 -100 -100 -100 -100];
        
    case {'E270503'}
        SI.electrodes   = [1 2 3 5 7 9 10 13 14 15];
        SI.gridhole     = [223 196 208 181 224 213 180 -100 142 175];
        SI.Areasynth    = [10 3 10 20 10 -1 20 -100 -2 20];
        
    case {'E300503'}
        SI.electrodes   = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15];
        SI.gridhole     = [208 175 139 103 68 156 120 84 210 177 141 105 160 142 179];
        SI.Areasynth    = [-1 -2 -100 4 4 2 -100 4 10 2 -100 4 2 -2 -2];
        
    case {'E310503'}
        SI.electrodes   = [1 2 5 9 14];
        SI.gridhole     = [205 219 203 207 141];
        SI.Areasynth    = [40 40 10 10 -100];
        
    case {'E080603'}    % filename=080603_ermst_gfs_6789_disk_pr2
        SI.electrodes   = [2 3 4 6 7 8 9 10 11 12 14 15];
        SI.gridhole     = [223 219 211 207 156 226 178 176 174 195 140 123];
        SI.Areasynth    = [1 40 10 40 2 10 2 2 2 -3 -100 -100];
        
    case {'E100603'}    % filename=100603_ernst_gfs_gratnm
        SI.electrodes   = [1 2 4 5 7 8 10 11 12 14 15];
        SI.gridhole     = [210 206 211 209 156 194 176 195 160 140 123];
        SI.Areasynth    = [1 1 1 10 2 40 40 40 -2 -100 -100];
        
    case {'E120603'}
        SI.electrodes   = [2 3 5 7 8 11 12 13 14];
        SI.gridhole     = [188 153 173 156 -100 236 239 208 206];
        SI.Areasynth    = [-3 30 40 20 -100 40 10 10 40];
        
    case{'E200903'}    % keine target response???!!!!!!! uberall 0 oder -100 ?????
        SI.electrodes   = [1 2 3 5 6 7 8 9 10 11 13 14];
        SI.gridhole     = [63 62 64 65 99 100 101 173 68 141 120 121];
        SI.Areasynth    = [4 4 4 4 -100 4 4 2 4 -100 -100 -100];
        
    case{'E220903'}     % noch keine Daten!!!!
        SI.electrodes   = [1 2 3 4 5 7 8 9 11 12 13 14];
        SI.gridhole     = [98 97 78 79 80 62 61 102 140 138 171 172];
        SI.Areasynth    = [-100 -100 4 4 4 4 4 4 3 3 3 3];
        
    case{'E250903'}     % nur channel 4 alle anderen -100 oder 0 da kein response????
        SI.electrodes   = [2 3 4 5 6 7 9 11 12 13 15];
        SI.gridhole     = [173 159 177 51 192 103 175 139 99 100 82];
        SI.Areasynth    = [2 20 2 4 3 4 2 3 -100 4 4];
        
    case{'E270903'}
        SI.electrodes   = [10 4 7 8 9 11 13 14 15];
        SI.gridhole     = [157 174 177 159 158 156 83 101 190];
        SI.Areasynth    = [3 2 2 2 2 -100 4 4 3];
        
    case{'E300903'}     % Exelfile leider nur bis 27.09.03
        SI.electrodes   = [1 2 3 4 5 6 7 8 9 11 12 13 14 15];
        SI.gridhole     = [211 209 207 178 176 196 139 141 195 161 194 -100 -100 160];
        SI.Areasynth    = [1 1 1 2 2 3 0 0 3 2 3 -100 -100 2];%noch nicht ueberprueft, da keine daten im exelfile
        
    case{'E011003'}
        SI.electrodes   = [2 3 4 5 6 7 8  9 11 12 13 14 15];
        SI.gridhole     = [190 191 192 193 194 177 179  211 209 208 207 206 205];
        SI.Areasynth    = [3 3 3 3 3 2 2 1 1 1 1 1 1];
        
        
    case{'E031003'}
        SI.electrodes   = [3 5 6 7 9 11 12 13 14];
        SI.gridhole     = [194 190 -100 161 211 209 208 207 206];
        SI.Areasynth    = [3 3 -100 2 1 1 1 1 1];
                
    % ---------
    % Wally - W
    % ---------
    case{'W020104'}     % filename=020104_wally_gfs %!!!!!surface recording wally / al  %2 == Elek 16 und 14 == Elek 13 pha omega/vermutlich alle V4, aber noch nicht klar (siehe collect)
        SI.electrodes   = [2 3 4 5 7 11 12 13 14];
        SI.gridhole     = [];
        SI.Areasynth    = [4 4 4 4 4 4 4 4 4];
                
    case{'W030104'}     %!!!!!surface recording wally / al  %2 == Elek 16
        SI.electrodes   = [2 5 6 7 8 9 11 12 13];
        SI.gridhole     = [];
        SI.Areasynth    = [4 4 4 4 4 4 4 4 4];
        
    case{'W050104'}     % CASE 04.01.04 ausgeschlossen, da adf und dgz absolut unterschiedliche Laengen haben %!!!!!surface recording wally / al  %2 == Elek 16 %channel 2 = elek16
        SI.electrodes   = [2 4 7 8 9 10 12 14];
        SI.gridhole     = [];
        SI.Areasynth    = [4 4 4 4 4 4 4 4];
        
    case{'W190104'}     % filename=190104_wally_gfs_prot_grat1 %!!!!!deep recording wally
        SI.electrodes   = [3 4 6 14];
        SI.gridhole     = [];
        SI.Areasynth    = [4 4 4 4];
        
    case{'W210104'}     %perfect----- %!!!!!deep recording wally / %channel 2 = elek16
        SI.electrodes   = [4 6 7 8 9 14];
        SI.gridhole     = [];
        SI.Areasynth    = [4 4 4 4 4 4];
        
    case{'W230104'}     %perfect-----, %!!!!!deep recording wally /%channel 2 = elek16
        SI.electrodes   = [4 6 9 10];
        SI.gridhole     = [];
        SI.Areasynth    = [4 4 4 4];
        
    case{'W250104'}     %perfect----- %!!!!!deep recording wally /%channel 2 = elek16
        SI.electrodes   = [4 6 9 14];
        SI.gridhole     = [];
        SI.Areasynth    = [4 4 4 4];
        
    case{'W270104'}     % deep recordings pres. V4
        SI.electrodes   = [3 5 8];
        SI.gridhole     = [];
        SI.Areasynth    = [4 4 4];
        
    case{'W300104'}     % deep recordings pres. V4
        SI.electrodes   = [3 5 6 9 10];
        SI.gridhole     = [];
        SI.Areasynth    = [4 4 4 4 4];
        
    case{'W010204'}     % filename=010204_wally_stimdur %deep recordings pres. V4
        SI.electrodes   = [5 6 9 14];
        SI.gridhole     = [];
        SI.Areasynth    = [4 4 4 4 4];
        
    case{'W020204'}     % deep recordings pres. V4
        SI.electrodes   = [1 2 3 4];
        SI.gridhole     = [];
        SI.Areasynth    = [4 4 4 4];
        
    case{'W030204'}    % deep recordings pres. V4
        SI.electrodes   = [3 5 7 10 11 14];
        SI.gridhole     = [];
        SI.Areasynth    = [4 4 4 4 4 4];
        
    case{'W040104'}     % eigentlich 04.02.04 %deep recordings pres. V4
        SI.electrodes   = [3 5 7 10 11];
        SI.gridhole     = [];
        SI.Areasynth    = [4 4 4 4 4];
        
    case{'W060204'}     % deep recordings pres. V4
        SI.electrodes   = [4 5 10 11];
        SI.gridhole     = [];
        SI.Areasynth    = [4 4 4 4];
        
    case{'W070204'}     % deep recordings pres. V4
        SI.electrodes   = [4 5 9 10];
        SI.gridhole     = [];
        SI.Areasynth    = [4 4 4 4];
        
    case{'W090204'}     % deep recordings pres. V4
        SI.electrodes   = [4 5 6 10 11];
        SI.gridhole     = [];
        SI.Areasynth    = [4 4 4 4 4];
        
    case{'W100204'}     % filename=100204_wally_stimdur %deep recordings pres. V4 or V3 (pretty foveal)
        SI.electrodes   = [4 5 8];
        SI.gridhole     = [];
        SI.Areasynth    = [4 4 4];
        
    case{'W170204'}     % deep recordings pres. V4
        SI.electrodes   = [5 7 10 11];
        SI.gridhole     = [];
        SI.Areasynth    = [4 4 4 4];

    case{'W010404'}
        SI.electrodes   = [2 3 5 8 9 11];
        SI.gridhole     = [1 1 1 1 1 1];
        SI.Areasynth    = [4 4 4 4 4 4];
        
    case{'W040404'}
        SI.electrodes   = [1 8 11 12 14];
        SI.gridhole     = [1 1 1 1 1];
        SI.Areasynth    = [4 4 4 4 4];
                
    % ---------
    % Dali - D
    % ---------        
    case{'D120304'}     % !!!!!surface recording bert / alpha omega
        SI.electrodes   = [1 4 5 6 8 9 10 11 14];
        SI.gridhole     = [221 173 175 -100 -100 211 195 178 141];
        SI.Areasynth    = [1 1 1 1 1 1 1 1 1];
        
    case{'D130304'}     % !!!!!surface recording dali / alpha omega
        SI.electrodes   = [1 2 4 5 8 9 10 11 13 14];
        SI.gridhole     = [221 220 173 222 119 161 -100 141];
        SI.Areasynth    = [1 -100 1 -100 1 -100 -100 1 -100 -100];
        
    case{'D150304'}     % !!!!!surface recording dali / alpha omega
        SI.electrodes   = [1 3 4 8 10 11 12 13 14];
        SI.gridhole     = [187 218 174 208 175 80 139 158];
        SI.Areasynth    = [-100 1 1 1 1 1 1 1 -100];
        
    case{'D160304'}     % !!!!!surface recording dali/ alpha omega
        SI.electrodes   = [3 4 6 8 10 11 12 13 14];
        SI.gridhole     = [203 187 170 186 219 204 -100 188 -100];
        SI.Areasynth    = [1 1 1 1 1 1 1 1 1 1];
        
    case{'D170304'}     % !!!!!surface recording dali/ alpha omega
        SI.electrodes   = [1 6 10 11 12 13 14];
        SI.gridhole     = [];
        SI.Areasynth    = [1 1 1 1 1 1 1];
        
    case{'D180304'}     % !!!!!surface recording dali/ alpha omega
        SI.electrodes   = [1 3 4 6 7 8 10 11 13 14];
        SI.gridhole     = [202 187 171 167 169 150 221 222 136 120];
        SI.Areasynth    = [1 1 1 1 1 1 1 1 1 1];
        
    case{'D190304'}     % !!!!!surface recording dali / alpha omega
        SI.electrodes   = [3 4 6 8 9 11 12 14];
        SI.gridhole     = [124 122 120 114 -100 202 98 -100];
        SI.Areasynth    =  [2 1 1 1 1 1 1 -100];
        
    case{'D200304'}     % !!!!!surface recording dali/ alpha omega
        SI.electrodes   = [1 3 4 6 8 10 14];
        SI.gridhole     = [204 186 169 132 152 223 225];
        SI.Areasynth    = [2 2 2 2 2 1 -100];
        
    case{'D210304'}     % !!!!!surface recording dali/ alpha omega
        SI.electrodes   = [3 5 6 7 8 10 11 14];
        SI.gridhole     = [219 190 188 189 -100 235 207 -100];
        SI.Areasynth    = [2 2 2 2 1 1 1 1 1];
        
    case{'D220304'}     % !!!!!surface recording dali/ alpha omega
        SI.electrodes   = [2 3 4 5 6 10 11 12 14];
        SI.gridhole     = [134 168 150 132 114 202 186 169 203];
        SI.Areasynth    = [1 2 2 1 2 1 1 1 1];
        
    case{'D230403'}     % !!!!!surface recording dali/ alpha omega
        SI.electrodes   = [1 2 3 4 6 7 8 10 13 14];
        SI.gridhole     = [201 -100 185 167 149 131 113 217 132 114];
        SI.Areasynth    = [1 1 1 1 1 1 1 1 1 -100];
        
    case{'D240304'}     % !!!!!surface recording dali/ alpha omega
        SI.electrodes   = [1 3 4 9 10 12 14];
        SI.gridhole     = [200 184 167 149 201 168 132];
        SI.Areasynth    = [1 1 1 1 1 1 1];
        
    case{'D250304'}     % !!!!!surface recording dali/ alpha omega
        SI.electrodes   = [1 3 4 10 11 14];
        SI.gridhole     = [201 185 168 202 186 133];
        SI.Areasynth    = [1 1 1 1 1 1 1];
        
    otherwise
        % error( 'GMSTRIAL:GMS_EXP_CHANNLE_INFO', 'No channel information for this session.' )
        SI.electrodes   = [];
        SI.gridhole     = [];
        SI.Areasynth    = [];
        cprintf('Errors', '\nNo channel information for session %s.\n', snm)

end

area_code = SI.Areasynth;
electrode_num = SI.electrodes;
grid_idx = SI.gridhole;

end % function

% [EOF]