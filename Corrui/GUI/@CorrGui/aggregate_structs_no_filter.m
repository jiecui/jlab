function [mn se] = aggregate_structs_no_filter( sessions, curr_exp, structs_LRavg, fields_for_structs_LRavg, structs_avg, fields_for_structs_avg,...
    structs_LRadd, fields_for_structs_LRadd, structs_LRconcat, fields_for_structs_LRconcat, structs_concat, fields_for_structs_concat, new_session_name)


mn = [];
se = [];
%% for structs_LRavg
%initialize
if ~isempty(structs_LRavg)
    all_fields = cell(length(structs_LRavg),1);
    
    for istruct=1:length(structs_LRavg)
        struct_left = sessdb( 'getsessvar', sessions{1}, ['left_' structs_LRavg{istruct} ] );
        if isempty(struct_left)
            all_fields{istruct} = fields_for_structs_LRavg{istruct};
        else
            all_fields{istruct} = fieldnames(struct_left);
        end
        fields = all_fields{istruct};
        
        for ifield=1:length(fields)
            comp.(structs_LRavg{istruct}).(fields{ifield}) = [];
        end
    end
    
    
    %get all data
    
    for istruct=1:length(structs_LRavg)
        for isubj=1:length(sessions)
            struct_left = sessdb( 'getsessvar', sessions{isubj}, ['left_' structs_LRavg{istruct} ] );
            struct_right = sessdb( 'getsessvar', sessions{isubj}, ['right_' structs_LRavg{istruct}] );
            if isempty(struct_left) || isempty(struct_right)
                continue
            end
            fields = all_fields{istruct};
            for ifield=1:length(fields)
                if  isfield(struct_left,fields{ifield})&& isfield(struct_right,fields{ifield}) && all(size(struct_left.([fields{ifield}])) == size(struct_right.([fields{ifield}])))
                    if ~isnumeric(struct_right.([fields{ifield}]))
                        continue
                    end
                    data = nanmean(cat(3,struct_right.([fields{ifield}]),struct_left.([fields{ifield}])),3);
                    current_size = size(comp.(structs_LRavg{istruct}).(fields{ifield}));
                    if all(current_size(1:2) == size(data)) || all(current_size == 0)
                        comp.(structs_LRavg{istruct}).(fields{ifield}) = cat(3,comp.(structs_LRavg{istruct}).(fields{ifield}),data);
                    end
                else
                    %                                             disp(['Variable ' structs_LRavg{istruct} ' does not exist for one or more subjects, could not average']);
                    continue;
                end
            end
        end
    end
    
    
    %average data which has variables for each subject
    for istruct=1:length(structs_LRavg)
        fields = all_fields{istruct};
        for ifield=1:length(fields)
            if size(comp.(structs_LRavg{istruct}).(fields{ifield}),3) > 1
                mn.([structs_LRavg{istruct} ]).(fields{ifield}) = nanmean(comp.(structs_LRavg{istruct}).(fields{ifield}),3);
                se.([structs_LRavg{istruct} ]).(fields{ifield}) = nanstd(comp.(structs_LRavg{istruct}).(fields{ifield}),0,3)./...
                    sqrt( sum( ~isnan(comp.(structs_LRavg{istruct}).(fields{ifield})), 3) );
                if ifield == length(fields)
                    disp(['Variable ' structs_LRavg{istruct} ': num = ' num2str(size(comp.(structs_LRavg{istruct}).(fields{ifield}),3)) ])
                end
            end
        end
    end
    
end
%% for structs_avg
if ~isempty(structs_avg)
    % initialize
    comp=[];
    all_fields = cell(length(structs_avg),1);
    
    for istruct=1:length(structs_avg)
        
        struct = sessdb( 'getsessvar', sessions{1}, [structs_avg{istruct} ] );
        if isempty(struct)
            all_fields{istruct} = fields_for_structs_avg{istruct};
        else
            all_fields{istruct} = fieldnames(struct);
        end
        fields = all_fields{istruct};
        
        for ifield=1:length(fields)
            comp.(structs_avg{istruct}).(fields{ifield}) = [];
        end
    end
    
    
    % gets the data
    
    for istruct=1:length(structs_avg)
        
        
        for isubj=1:length(sessions)
            struct = sessdb( 'getsessvar', sessions{isubj}, [structs_avg{istruct} ] );
            
            if isempty(struct)
                continue
            end
            fields = all_fields{istruct};
            
            for ifield=1:length(fields)
                if isfield(struct,fields{ifield})
                    if ~isnumeric(struct.(fields{ifield}))
                        continue
                    end
                    current_size = size(comp.(structs_avg{istruct}).(fields{ifield}));
                    if all(current_size(1:2) == size(struct.(fields{ifield})))||all(current_size == 0)
                        comp.(structs_avg{istruct}).(fields{ifield}) = cat(3,comp.(structs_avg{istruct}).(fields{ifield}), struct.(fields{ifield}));
                    end
                else
                    %                     disp(['Variable ' structs_avg{istruct} ' does not exist for one or more subjects, could not average']);
                    continue;
                end
            end
        end
    end
    
    
    % calculates avgs and se
    
    for istruct=1:length(structs_avg)
        
        %         fields = fields_for_structs_avg{istruct};
        fields = all_fields{istruct};
        for ifield=1:length(fields)
            
            
            if size(comp.(structs_avg{istruct}).(fields{ifield}),3) > 1
                mn.([structs_avg{istruct} ]).(fields{ifield}) = nanmean(comp.(structs_avg{istruct}).(fields{ifield}),3);
                se.([structs_avg{istruct} ]).(fields{ifield}) = nanstd(comp.(structs_avg{istruct}).(fields{ifield}),0,3)./...
                    sqrt(  sum(~isnan( comp.(structs_avg{istruct}).(fields{ifield})), 3) );
                if ifield == length(fields)
                    disp(['Variable ' structs_avg{istruct} ': num = ' num2str(size(comp.(structs_avg{istruct}).(fields{ifield}),3))])
                end
            else
                continue;
            end
        end
    end
    
end


% % % % %% for structs_LRadd right now this is only good for the *_info
% % % % %% correlations %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % % if ~isempty(structs_LRadd)
% % % %     comp=[];
% % % %     all_fields = cell(length(structs_LRadd), 1);
% % % %     for ifilter = filters_to_use
% % % %         for istruct=1:length(structs_LRadd)
% % % %
% % % %             struct_left = sessdb( 'getsessvar', sessions{1}, ['left_' structs_LRadd{istruct} '_' filters{ifilter} '_info'] );
% % % %             if isempty(struct_left)
% % % %                 all_fields{istruct,ifilter} = fields_for_structs_LRadd{istruct};
% % % %             else
% % % %                 all_fields{istruct,ifilter} = fieldnames(struct_left);
% % % %             end
% % % %             fields = all_fields{istruct,ifilter};
% % % %
% % % %             for ifield=1:length(fields)
% % % %                 comp.(structs_LRadd{istruct}).(fields{ifield}).(filters{ifilter}) = [];
% % % %             end
% % % %         end
% % % %     end
% % % %     for ifilter = filters_to_use
% % % %         for istruct=1:length(structs_LRadd)
% % % %             %         fields = fields_for_structs_LRadd{istruct};
% % % %             fields = all_fields{istruct,ifilter};
% % % %             for isubj=1:length(sessions)
% % % %                 struct_left = sessdb( 'getsessvar', sessions{isubj}, ['left_' structs_LRadd{istruct} '_' filters{ifilter} '_info'] );
% % % %                 struct_right = sessdb( 'getsessvar', sessions{isubj}, ['right_' structs_LRadd{istruct} '_' filters{ifilter} '_info'] );
% % % %                 if isempty(struct_left)||isempty(struct_right)
% % % %                     continue
% % % %                 end
% % % %                 for ifield=1:length(fields)
% % % %
% % % %                     if ~isnumeric(struct_right.([fields{ifield}]))
% % % %                         continue
% % % %                     end
% % % %                     if isfield(struct_left,fields{ifield})
% % % %                         current_size = size(comp.(structs_LRadd{istruct}).(fields{ifield}).(filters{ifilter}));
% % % %                         if all(current_size(1:2) == size(struct_left.(fields{ifield})))||all(current_size == 0)
% % % %                             comp.(structs_LRadd{istruct}).(fields{ifield}).(filters{ifilter}) = cat(3,comp.(structs_LRadd{istruct}).(fields{ifield}).(filters{ifilter}),struct_left.(fields{ifield}));
% % % %                         end
% % % %                         if isfield(struct_right,fields{ifield})
% % % %                             if all(current_size(1:2) == size(struct_right.(fields{ifield})))||all(current_size == 0)
% % % %                                 comp.(structs_LRadd{istruct}).(fields{ifield}).(filters{ifilter}) = cat(3,comp.(structs_LRadd{istruct}).(fields{ifield}).(filters{ifilter}),struct_right.(fields{ifield}));
% % % %                             end
% % % %                         end
% % % %                     else
% % % %                         %                     disp(['Variable ' structs_LRadd{istruct} ' does not exist for one or more subjects, could not average']);
% % % %                         continue;
% % % %                     end
% % % %                 end
% % % %
% % % %             end
% % % %         end
% % % %     end
% % % %     for ifilter = filters_to_use
% % % %         for istruct=1:length(structs_LRadd)
% % % %             fields = all_fields{istruct,ifilter};
% % % %             for ifield=1:length(fields)
% % % %                 if size(comp.(structs_LRadd{istruct}).(fields{ifield}).(filters{ifilter}),3) > 1
% % % %                     mn.([structs_LRadd{istruct} '_' filters{ifilter} '_info']).(fields{ifield}) = sum(comp.(structs_LRadd{istruct}).(fields{ifield}).(filters{ifilter}),3);
% % % %                     if ifield == length(fields)
% % % %                         disp(['Variable ' structs_LRadd{istruct} '_' filters{ifilter} ': num = ' num2str(size(comp.(structs_LRadd{istruct}).(fields{ifield}).(filters{ifilter}),3)/2)])
% % % %                     end
% % % %                 end
% % % %             end
% % % %         end
% % % %     end
% % % % end
% % % %
% % % % %% for structs_LRconcat (MAKE SURE THESE ARE NOT TOO BIG)
% % % % if ~isempty(structs_LRconcat)
% % % %     concat_vars	= sessdb('getsessvar',[curr_exp.prefix 'mn' new_session_name], 'concatenated_vars' );
% % % %
% % % %     %initialize
% % % %     all_fields = cell(length(structs_LRconcat),length(filters));
% % % %     for ifilter = filters_to_use
% % % %         for istruct=1:length(structs_LRconcat)
% % % %             struct_left = sessdb( 'getsessvar', sessions{1}, ['left_' structs_LRconcat{istruct} '_' filters{ifilter}] );
% % % %             if isempty(struct_left)
% % % %                 all_fields{istruct,ifilter} = fields_for_structs_LRconcat{istruct};
% % % %             else
% % % %                 all_fields{istruct,ifilter} = fieldnames(struct_left);
% % % %             end
% % % %             fields = all_fields{istruct,ifilter};
% % % %
% % % %             for ifield=1:length(fields)
% % % %                 comp.(structs_LRconcat{istruct}).(fields{ifield}).(filters{ifilter}) = [];
% % % %                 sessionflag.(structs_LRconcat{istruct}).(fields{ifield}).(filters{ifilter}) = [];
% % % %             end
% % % %
% % % %         end
% % % %     end
% % % %     %get all data
% % % %     for ifilter = filters_to_use
% % % %         for istruct=1:length(structs_LRconcat)
% % % %             % total_data = [];
% % % %             % sessionflag = [];
% % % %             for isubj=1:length(sessions)
% % % %                 struct_left = sessdb( 'getsessvar', sessions{isubj}, ['left_' structs_LRconcat{istruct} '_' filters{ifilter}] );
% % % %                 struct_right = sessdb( 'getsessvar', sessions{isubj}, ['right_' structs_LRconcat{istruct} '_' filters{ifilter}] );
% % % %                 if isempty(struct_left)||isempty(struct_right)
% % % %                     continue
% % % %                 end
% % % %                 fields = all_fields{istruct,ifilter};
% % % %                 for ifield=1:length(fields)
% % % %                     if  isfield(struct_left,fields{ifield})&& isfield(struct_right,fields{ifield})
% % % %
% % % %                         if ~isnumeric(struct_right.([fields{ifield}]))
% % % %                             continue
% % % %                         end
% % % %                         sizeL = size(struct_left.([fields{ifield}]));
% % % %                         sizeR = size(struct_right.([fields{ifield}]));
% % % %                         if any(sizeL==0)||any(sizeR==0)
% % % %                             continue
% % % %                         end
% % % %                         idx_diff = find(sizeL ~= 1);
% % % %
% % % %                         if ~isempty(idx_diff)
% % % %                             dataLR = cat(idx_diff,struct_right.([fields{ifield}]),struct_left.([fields{ifield}]));
% % % %
% % % %                             comp.(structs_LRconcat{istruct}).(fields{ifield}).(filters{ifilter})(end+1:end+max(size(dataLR))) = dataLR;
% % % %                             sessionflag.(structs_LRconcat{istruct}).(fields{ifield}).(filters{ifilter})(end+1:end+max(size(dataLR))) = isubj;
% % % %                             if size(sessionflag.(structs_LRconcat{istruct}).(fields{ifield}).(filters{ifilter})) ~= ...
% % % %                                     size(comp.(structs_LRconcat{istruct}).(fields{ifield}).(filters{ifilter}))
% % % % %                                 a=2
% % % %                             end
% % % %                         end
% % % %                     else
% % % %                         %                     disp(['Variable ' structs_LRconcat{istruct} ' does not exist for one or more subjects, could not average']);
% % % %                         continue;
% % % %                     end
% % % %                 end
% % % %             end
% % % %         end
% % % %     end
% % % %     %assmeble which has are non empty
% % % %     for ifilter = filters_to_use
% % % %         for istruct=1:length(structs_LRconcat)
% % % %             fields = all_fields{istruct,ifilter};
% % % %             for ifield=1:length(fields)
% % % %                 if ~isempty(comp.(structs_LRconcat{istruct}).(fields{ifield}).(filters{ifilter}))
% % % %                     mn.([structs_LRconcat{istruct} '_' filters{ifilter}]).(fields{ifield}) = comp.(structs_LRconcat{istruct}).(fields{ifield}).(filters{ifilter});
% % % %                     mn.concatenated_vars.( [ structs_LRconcat{istruct} ] ).(fields{ifield}).(filters{ifilter}).sessionflag = sessionflag.(structs_LRconcat{istruct}).(fields{ifield}).(filters{ifilter});
% % % %                     if ifield == length(fields)
% % % %                         disp(['Variable ' structs_LRconcat{istruct} '_' filters{ifilter} ': num = ' ...
% % % %                             num2str(length(unique(mn.concatenated_vars.( [ structs_LRconcat{istruct} ] ).(fields{ifield}).(filters{ifilter}).sessionflag)))])
% % % %                     end
% % % %                 end
% % % %             end
% % % %         end
% % % %     end
% % % %     if isfield(mn, 'concatenated_vars') && exist('concat_vars','var')
% % % %         mn.concatenated_vars = mergestructs(concat_vars, mn.concatenated_vars);
% % % %     end
% % % % end
% % % %
% % % % %% for structs_concat (MAKE SURE THESE ARE NOT TOO BIG)
% % % % if ~isempty(structs_concat)
% % % %     concat_vars	= sessdb('getsessvar',[curr_exp.prefix 'mn' new_session_name], 'concatenated_vars' );
% % % %
% % % %     %initialize
% % % %     all_fields = cell(length(structs_concat),length(filters));
% % % %     for ifilter = filters_to_use
% % % %         for istruct=1:length(structs_concat)
% % % %             struct = sessdb( 'getsessvar', sessions{1}, [ structs_concat{istruct} '_' filters{ifilter}] );
% % % %             if isempty(struct)
% % % %                 all_fields{istruct,ifilter} = fields_for_structs_concat{istruct};
% % % %             else
% % % %                 all_fields{istruct,ifilter} = fieldnames(struct);
% % % %             end
% % % %             fields = all_fields{istruct,ifilter};
% % % %
% % % %             for ifield=1:length(fields)
% % % % %                 if ifield == 1 && ifilter == 8
% % % % %                 a=2
% % % % %                 end
% % % %                 comp.(structs_concat{istruct}).(fields{ifield}).(filters{ifilter}) = [];
% % % %                 sessionflag.(structs_concat{istruct}).(fields{ifield}).(filters{ifilter}) = [];
% % % %             end
% % % %
% % % %         end
% % % %     end
% % % %     %get all data
% % % %     for ifilter = filters_to_use
% % % %         for istruct=1:length(structs_concat)
% % % %             % total_data = [];
% % % %             % sessionflag = [];
% % % %             for isubj=1:length(sessions)
% % % %                 struct = sessdb( 'getsessvar', sessions{isubj}, [ structs_concat{istruct} '_' filters{ifilter}] );
% % % %
% % % %                 if isempty(struct)
% % % %                     continue
% % % %                 end
% % % %                 fields = all_fields{istruct,ifilter};
% % % %                 for ifield=1:length(fields)
% % % %                     if  isfield(struct,fields{ifield})
% % % %
% % % %                         if ~isnumeric(struct.([fields{ifield}]))
% % % %                             continue
% % % %                         end
% % % %                         size_data = size(struct.([fields{ifield}]));
% % % %
% % % %                         if any(size_data==0)
% % % %                             continue
% % % %                         end
% % % %
% % % %                             curr_data = struct.([fields{ifield}]);
% % % %
% % % %                             comp.(structs_concat{istruct}).(fields{ifield}).(filters{ifilter})(end+1:end+max(size(curr_data))) = curr_data;
% % % %                             sessionflag.(structs_concat{istruct}).(fields{ifield}).(filters{ifilter})(end+1:end+max(size(curr_data))) = isubj;
% % % %                             if size(sessionflag.(structs_concat{istruct}).(fields{ifield}).(filters{ifilter})) ~= ...
% % % %                                     size(comp.(structs_concat{istruct}).(fields{ifield}).(filters{ifilter}))
% % % % %                                 a=2
% % % %                             end
% % % %
% % % %                     else
% % % %                         %                     disp(['Variable ' structs_concat{istruct} ' does not exist for one or more subjects, could not average']);
% % % %                         continue;
% % % %                     end
% % % %                 end
% % % %             end
% % % %         end
% % % %     end
% % % %     %assmeble which has are non empty
% % % %     for ifilter = filters_to_use
% % % %         for istruct=1:length(structs_concat)
% % % %             fields = all_fields{istruct,ifilter};
% % % %             for ifield=1:length(fields)
% % % %                 if ~isempty(comp.(structs_concat{istruct}).(fields{ifield}).(filters{ifilter}))
% % % %                     mn.([structs_concat{istruct} '_' filters{ifilter}]).(fields{ifield}) = comp.(structs_concat{istruct}).(fields{ifield}).(filters{ifilter});
% % % %                     mn.concatenated_vars.( [ structs_concat{istruct} ] ).(fields{ifield}).(filters{ifilter}).sessionflag = sessionflag.(structs_concat{istruct}).(fields{ifield}).(filters{ifilter});
% % % %                     if ifield == length(fields)
% % % %                         disp(['Variable ' structs_concat{istruct} '_' filters{ifilter} ': num = ' ...
% % % %                             num2str(length(unique(mn.concatenated_vars.( [ structs_concat{istruct} ] ).(fields{ifield}).(filters{ifilter}).sessionflag)))])
% % % %                     end
% % % %                 end
% % % %             end
% % % %         end
% % % %     end
% % % %     if isfield(mn, 'concatenated_vars') && exist('concat_vars','var')
% % % %         mn.concatenated_vars = mergestructs(concat_vars, mn.concatenated_vars);
% % % %     end
end
