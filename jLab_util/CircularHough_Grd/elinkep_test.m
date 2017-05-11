%eye link eye position test
k = 500; % 260;
A = read(AVIObj, k);
rawimg = A(:, :, 2); 
tic;
[accum, circen, cirrad] = CircularHough_Grd(rawimg, [10 15]);
toc;

figure
imagesc(accum); axis image;
title('Accumulation Array from Circular Hough Transform');

figure
imagesc(rawimg); colormap('gray'); axis image;
hold on;
plot(circen(:,1), circen(:,2), 'r+');
N = size(circen, 1);
acc = zeros(N, 1);
for k = 1 : N
    DrawCircle(circen(k,1), circen(k,2), cirrad(k), 32, 'b-');
    acc(k) = accum(round(circen(k,2)), round(circen(k,1)));
end
% draw the max one
[~, maxInd] = max(acc);
maxCen = circen(maxInd, :);
maxRad = cirrad(maxInd);
DrawCircle(maxCen(1), maxCen(2), maxRad, 32, 'g-');
title(['Raw Image with Circles Detected ', ...
    '(center positions and radii marked)']);

% figure
% surf(accum, 'EdgeColor', 'none'); axis ij;
% title('3-D View of the Accumulation Array');
