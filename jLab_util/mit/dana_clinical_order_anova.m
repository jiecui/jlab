% do the anova on the clinical data grouped by order
% first the Fugl-Meyer

%class = {'early', 'early', 'early', 'middle', 'middle', 'middle', 'early', 'middle'};
class = {'early', 'middle', 'middle', 'late', 'late', 'late', 'early', 'middle'};
improv = [95 95 92 81 82 115 96 118]  - [75 88 85 75 76.5 113.5 100.5 114];
p_fmtotal = anova1(improv,class,'off')
improv = [45 44 37 25 29 57 48 58] - [32 40.5 32 19 25 55 46.5 55];
p_fmmotor = anova1(improv,class,'off')

% now emory
%class = {'middle','middle', 'middle', 'early', 'early', 'early', 'middle', 'early'};
class = {'middle','late', 'late', 'middle', 'middle', 'middle', 'middle', 'early'};
improv = [552.1	52.7	517.3	1088.5	966.2	47.0	518.8	33.0] - ...
[863.3	311.5	819.1	1158.3	967.6	82.1	640.4	42.5];


p_emory = anova1(improv,class)
