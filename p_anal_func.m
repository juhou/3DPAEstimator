function [ result ] = p_anal_func(model_path, mesh_name, degree_z )
%P_ANAL_FUNC Summary of this function goes here



%   Detailed explanation goes here
depth_img=mesh_thk_mex(strcat(model_path, mesh_name),compute_rotation([1 0 0], degree_z*pi/180),0);

% Highpass filter generation
PQ = paddedsize(size(depth_img));
D0 = 0.1*PQ(1);
H = hpfilter('gaussian', PQ(1), PQ(2), D0);

% hamming window generation
[r,c]=size(depth_img); 
w=window2(r,c,@hann); 

%% Filtering process for artifact amplification
F=fft2(double(depth_img.*w),size(H,1),size(H,2));  
HPF_depth_img=real(ifft2(H.*F)); 
HPF_depth_img=HPF_depth_img(1:size(depth_img,1), 1:size(depth_img,2))+0.5; 

% normalize histogram
HPF_depth_img1 = imadjust(HPF_depth_img, stretchlim(HPF_depth_img),[]);  
HPF_depth_img1 = HPF_depth_img1 + (0.5 - mean(mean(HPF_depth_img1)));

% histogram cut
tau = 0.3;
HPF_depth_img1((HPF_depth_img1 < (0.5-tau)) ) = 0.5-tau;
HPF_depth_img1((HPF_depth_img1 > (0.5+tau))) = 0.5+tau;
HPF_depth_img2 = imadjust(HPF_depth_img1, stretchlim(HPF_depth_img1),[]);   
% HPF_depth_img2=HPF_depth_img1;



% BW = edge(HPF_depth_img2,'canny', 0.9);
% figure, imshow(BW)
% HPF_depth_img2 = imfilter(HPF_depth_img2, [1,1,1;1,4,1;1,1,1]/12);
% figure, imshow(HPF_depth_img2)
% Options.kernelratio = 5;
% Options.windowratio = 5;
% HPF_depth_img3=NLMF(HPF_depth_img2, Options);
% figure; imshow(HPF_depth_img3);
% resi = HPF_depth_img2 - HPF_depth_img3;
% resi2=  imadjust(resi, stretchlim(resi),[]);  
% figure; imshow(resi2, []);



% final high-pass filtering
F=fft2(double(HPF_depth_img2.*w),size(H,1),size(H,2));
S1=abs(fftshift(F));
PQ = paddedsize(size(S1))/2;
H2 = fftshift(hpfilter('gaussian', PQ(1), PQ(2), 0.1*PQ(1)));
S1 = H2.*S1;

% polar mapping
rmin = 1; 
rmax = round(size(S1, 2)/2)-2; 
nr = rmax;
nw = 360;
PMresult = polarmapping(S1, rmin, rmax, round(size(S1, 2)/2), round(size(S1, 1)/2), nr, nw);

[vS1, I] = max(PMresult(:));
[iS1r,iS1t] = ind2sub(size(PMresult) , I);

%% data save
result.peak_x = iS1r;
result.peak_y = iS1t;
result.peak_v = vS1;
result.depth_img =  depth_img;
result.amp_depth =  HPF_depth_img2; 
result.peakmap =  PMresult; 


imwrite(imresize(depth_img, 0.5), sprintf('./data_%s/im_depth0_%03d.jpeg', mesh_name,degree_z+90), 'jpeg');
imwrite(imresize(HPF_depth_img1, 0.5) , sprintf('./data_%s/im_depthHP_HSST_%03d.jpeg', mesh_name,degree_z+90), 'jpeg');    
imwrite(imresize(HPF_depth_img2, 0.5) , sprintf('./data_%s/im_depthHP_HSST3_%03d.jpeg', mesh_name,degree_z+90), 'jpeg');    
imwrite(imresize(S1/max(S1(:)), 0.5) ,sprintf('./data_%s/im_depth_FQ_%03d.jpeg', mesh_name,degree_z+90), 'jpeg');

end

