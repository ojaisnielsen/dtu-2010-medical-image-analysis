%% Loading of the images

load visiblehuman.mat;

%% Acquisition of the fiducial points for the cryosection (and computation of the FLE)

% cpselect(head,head)
% average=(input_points+base_points)/2;
% save ('average.ext', 'average', '-ASCII');
load average.ext;
nPoints=size(average,1);
% FLE=base_points-average;
% FLE_asl=(norm(FLE)^2)/nPoints

%% Display of the fiducial points as red circles

imshow(head);
hold on;
for k=1:nPoints
plot(average(k,1), average(k,2), 'or', 'linewidth', 3);
end

%% Acquisition of the fiducial points for the "fresh" CT scan

% figure
% imagesc(head_fresh)
% axis image
% colormap gray
% [x y]=ginput(nPoints);
% xyfresh=[x y];
% save('xyfresh.ext', 'xyfresh', '-ASCII');
load xyfresh.ext;

%% Acquisition of the fiducial points for the "frozen" CT scan

% figure
% imagesc(head_frozen)
% axis image
% colormap gray
% [x y]=ginput(nPoints);
% xyfrozen=[x y];
% save('xyfrozen.ext', 'xyfrozen', '-ASCII');
load xyfrozen.ext;

%% Acquisition of the fiducial points for the MR scan

% figure
% imagesc(head_mri)
% axis image
% colormap gray
% [x y]=ginput(nPoints);
% xymri=[x y];
% save('xymri.ext', 'xymri', '-ASCII');
load xymri.ext;


%% Computation of the transformation parameters for the MR --> "frozen" CT transformation

MR2CTtform=cp2tform(xymri,xyfrozen,'nonreflective similarity');
t_MR2CTtform=tformfwd(MR2CTtform,[0,0])
u=tformfwd(MR2CTtform, [1,0]) - t_MR2CTtform;
angle = (180/pi) * atan2(u(2), u(1))
scale = norm(u)


%% Computation of the FRE for the MR --> "frozen" CT transformation

[x_MR2CT y_MR2CT]=tformfwd(MR2CTtform,xymri);
FRE_MR2CT=[x_MR2CT y_MR2CT]-xyfrozen;
FRE_MR2CT_asl=(norm(FRE_MR2CT)^2)/nPoints

%% Computation of the transformation parameters for the "frozen" CT --> MR transformation

CT2MRtform=cp2tform(xyfrozen,xymri,'nonreflective similarity');
t_CT2MRtform=tformfwd(CT2MRtform,[0,0])
u=tformfwd(CT2MRtform, [1,0]) - t_CT2MRtform;
angle = (180/pi) * atan2(u(2), u(1))
scale = norm(u)

%% Computation of the FRE for the "frozen" CT --> MR transformation

[x_CT2MR y_CT2MR]=tformfwd(CT2MRtform,xyfrozen);
FRE_CT2MR=[x_CT2MR y_CT2MR]-xymri;
FRE_CT2MR_asl=(norm(FRE_CT2MR)^2)/nPoints

%% Creation of the superimposed image

[im_MR2CT xRange yRange]=imtransform(head_mri,MR2CTtform);
im1_Trans=im_MR2CT;
im2=head_frozen;

overLap(1:2)=max(ceil([[xRange(1) yRange(1)];[1 1]]));
overLap(3:4)=min(floor([[xRange(2) yRange(2)];[size(im2,2) size(im2,1)]]))-overLap(1:2);

im1_T_cropped=imcrop(xRange,yRange,im1_Trans,overLap);
im2_cropped=imcrop(im2,overLap);

im_RGB(:,:,1)=im2_cropped;
im_RGB(:,:,2)=im1_T_cropped;
im_RGB(:,:,3)=zeros(size(im2_cropped));
figure,imagesc(im_RGB);