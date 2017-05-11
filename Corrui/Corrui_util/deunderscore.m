% --- Remove underscores
function txt = deunderscore(txt)

nocell = 0;
if ( ~iscell(txt) )
    txt = {txt};
    nocell=1;
end

for i =1:length(txt)
    for j=1:length(txt{i})
        if txt{i}(j) == '_'
            txt{i}(j) = ' ';
        end
    end
end


if(nocell)
    txt = txt{1};
end