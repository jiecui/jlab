% scatter all the times
cube = crunchcube(crunch, '2 4:10');
% limit the measures to those interesting ones
meas = [1:9 16:23];
cube = cube(:,meas,:,:);
meas_labels = crunch.measures(meas);
meas_labels(6) = cellstr('Average Velocity');
tl = crunch.subjects(2).slice_labels;
time_labels = [tl(length(tl)) tl(1:length(tl)-1) cellstr('All')];
figure;
% cube is cond x meas x time x subj
for j=1:size(cube,2),
    for i=1:size(cube,1),
        scatdat = [];
        for k=1:size(cube,3),
            scatdat = [scatdat;k*ones(size(cube,4),1) squeeze(cube(i,j,k,:))];
        end
        % make the last column a composite of all -- worry about coloring later
        scatdat = [scatdat;scatdat];
        scatdat(size(scatdat,1)/2+1:size(scatdat,1),1) = k+1;
        % now plot
        %subplot(4,2,i);
        scatter(scatdat);
        set(gca, 'XTickLabels', char(time_labels));
        titl=sprintf('%s %s', char(meas_labels(j)), char(crunch.conditions(i)));
        title(titl);
        set(gcf, 'Name', titl);
        saveas(gcf, titl, 'jpg');
    end
%     % second round
%     for i=i:size(cube,1),
%         scatdat = [];
%         for k=1:size(cube,3),
%             scatdat = [scatdat;k*ones(size(cube,4),1) squeeze(cube(i,j,k,:))];
%         end
%         % make the last column a composite of all -- worry about coloring later
%         scatdat = [scatdat;scatdat];
%         scatdat(size(scatdat,1)/2+1:size(scatdat,1),1) = k+1;
%         % now plot
%         subplot(3,2,i-8);
%         scatter(scatdat);
%         set(gca, 'XTickLabels', char(time_labels));
%         titl=sprintf('%s', char(crunch.conditions(i)));
%         title(titl);
%     end
%     titl=sprintf('Scatter2 %s', char(meas_labels(j)));
%     set(gcf, 'Name', titl);
%     saveas(gcf, titl, 'jpg');
end
