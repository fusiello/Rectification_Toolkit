% Rectification example. The CV Toolkit is required
% Author: A. Fusiello (andrea.fusiello@uniud.it), 2019

%% Calibrated rectification. 
% Camera matrices are provided in the same folder as the images, 
% with the same base-name and extension .pm (see example)

%  s = RandStream('mt19937ar','Seed',1); % for reproducibility
%  RandStream.setGlobalStream(s);


[I1r, I2r]  = rectify('examples/IMG_0011.JPG','examples/IMG_0012.JPG','Calibrated');

figure;imshow(I1r,[],'InitialMagnification','fit');
figure;imshow(I2r,[],'InitialMagnification','fit');
drawnow;

%% Uncalibrated rectification. The VLFEAT toolbox is required for SIFT

[I1r, I2r]  = rectify('examples/cporta0.png','examples/cporta1.png','Uncalibrated');

figure;imshow(I1r,[],'InitialMagnification','fit');
figure;imshow(I2r,[],'InitialMagnification','fit');
drawnow;

