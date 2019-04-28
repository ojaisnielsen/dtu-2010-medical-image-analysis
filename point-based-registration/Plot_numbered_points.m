function mask=Plot_numbered_points(input_image, points)


%% Create the text mask 
% Make an image the same size and put text in it 
im = input_image;
nPoints = size(points, 1);
hf = figure('color','white','units','normalized','position',[.1 .1 .8 .8]); 
image(ones(size(im)));
mask = ones(size(im));
set(gca,'units','pixels','position',[5 5 size(im,2)-1 size(im,1)-1],'visible','off')

% Text 
% for k=1:nPoints
% text('units','pixels','position',[points(k,1) points(k,2)],'fontsize',30,'string',k) 
% end

% Capture the text image 
% Note that the size will have changed by about 1 pixel 
tim = getframe(gca); 
close(hf) 

% Extract the cdata
tim2 = tim.cdata;

% Make a mask with the negative of the text 
% tmask = tim2==0; 

% imagesc(tmask);

% Place white text 
% Replace mask pixels with UINT8 max 

imshow(im);
% hold on;
% for k=1:nPoints
% plot(points(k,1),points(k,2), 'or', 'linewidth', 3);
% end