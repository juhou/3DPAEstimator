% function [est_param, Resmp_data] = p_axis_est( vertex0, model_h, sampling_rate)
% projection based Stair stepping effect detector

model_h = 50;

model_path = 'C:\Users\jonguk\Desktop\Mesh code (2)\model';
mesh_name = 'MD1.ctm';
mkdir(sprintf('./data_%s', mesh_name));

for degree_z = -90:1:90
    
    % periodicty estimation 
    result = p_anal_func(model_path, mesh_name, degree_z );
    disp(degree_z);
    
    %% data save
    Resmp_data(degree_z+91).peak_x = result.peak_x;
    Resmp_data(degree_z+91).peak_y = result.peak_y;
    Resmp_data(degree_z+91).peak_v = result.peak_v;
    Resmp_data(degree_z+91).depth_img =  result.depth_img;
    Resmp_data(degree_z+91).amp_depth =  result.amp_depth; 
    Resmp_data(degree_z+91).peakmap =  result.peakmap; 
end


%% parameter estimation
for degree_z = -90:1:90
    val_r(degree_z+91) = Resmp_data(degree_z+91).peak_v;
end

figure;
plot(val_r);

[vr, ir] = max(val_r);
theta = ir;
varphi = Resmp_data(ir).peak_x;
radius = Resmp_data(ir).peak_y;

model_h_norm = 0.63; % fix later

freq = (radius-1)/2 * model_h_norm;
slice_height = model_h / freq;


est_param.theta = theta
est_param.varphi = varphi
est_param.radius = radius
est_param.slice_height = slice_height;

% save('Resmp_data.mat', 'Resmp_data');



figure, imshow(Resmp_data(ir).depth_img,[]) ;
figure, imshow(Resmp_data(ir).amp_depth,[]) ;
figure, imshow(Resmp_data(ir).peakmap,[]) ;

% imwrite(imrotate(Resmp_data(ir).depth_img,varphi,'bicubic','crop')  , strcat(strcat('./data_result/',name), '_depth.bmp'), 'bmp');
% imwrite(imrotate(Resmp_data(ir).amp_depth,varphi,'bicubic','crop'), strcat(strcat('./data_result/',name), '_amp.bmp'), 'bmp');
% imwrite(Resmp_data(ir).peakmap/max(Resmp_data(ir).peakmap(:)) , strcat(strcat('./data_result/',name), '_peak.bmp'), 'bmp');

%save(strcat('./data_result/resample_data_',name), 'Resmp_data','-v7.3');
% save(strcat('./data_result/estimation_data_',name),  'theta','varphi','radius','freq','slice_height','model_h','model_h_norm','-v7.3');

% end

