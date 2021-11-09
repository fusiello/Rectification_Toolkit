function  [I1r, I2r, bb1, bb2, Pn1, Pn2]  = rectify(img_file1, img_file2, varargin)
    %RECTIFY Epipolar rectification outmost wrapper
    %
    % img1 and img2 are the filenames of the two images to be rectified
    % an option defines whether the rectification should
    % use the camera matrices provided in the same folder
    % (same name as the images with extension .pm) or the image
    % matches obtained with SIFT (** vlfeat toolbox required **)
    % Outputs are: the rectified images, the boundinx boxes and the
    % camera matrices
    
    % Rectify first calls either rectifyP or rectifyF according
    % to the case, which returns the homographies to be applied in
    % order to get the images rectified. Then the imrectify function
    % is called which perform the image warping and takes care of  
    % bounding boxes and centering. Rectified camera matrices are
    % also returned, Euclidean in the calibrated case and projective
    % in the uncalibrated one.   
    
    opts = parse_lm_options(varargin);

    I1 = imread(img_file1); [a1,b1,~] = fileparts(img_file1);
    I2 = imread(img_file2); [a2,b2,~] = fileparts(img_file2);
      
    % if calibrated
    if opts.calibrated && exist([a1,'/',b1,'.pm'],'file') == 2  &&...
            exist([a2,'/',b2,'.pm'],'file') == 2
        disp('Calibrated: loading PPMs')
        
        P1 = load([a1,'/',b1,'.pm']);
        P2 = load([a2,'/',b2,'.pm']);
        
        [H1,H2,Pn1,Pn2] = rectifyP(P1,P2);
        
        % The F matrix induced by Pn1,Pn2 shoud be skew([1 0 0])
        fprintf('Rectification algebraic error:\t\t %0.5g \n',  ...
            norm (abs(fund(Pn1,Pn2)/norm(fund(Pn1,Pn2))) - abs(skew([1 0 0]))));
        
    else % uncalibrated
        
        %% vl_setup and save the path
        % comment these lines if you already run vl_setup
        oldpath = path;
        addpath('/Users/andrea/LibMatlab/vlfeat-0.9.21/toolbox/');
        vl_setup
        
        matches_th = 25; % minimum number of matches after RANSAC
        
        %%
        disp('Uncalibrated: computing F from SIFT matches')
        
        [f1,d1] = vl_sift(single(rgb2gray(I1))) ;
        [f2,d2] = vl_sift(single(rgb2gray(I2))) ;
        
        % Each column of fa is a feature frame and has the format [X;Y;S;TH]
        % Each column of D is the descriptor of the corresponding frame in F
        
        % match
        match = vl_ubcmatch(d1, d2) ;
        
        ml = f1(1:2,match(1,:)); mr = f2(1:2,match(2,:));
        
        [F, in]  = fund_rob(mr,ml,'MSAC',2);
        fprintf('MSAC: F-matrix Sampson RMSE: %0.5g pixel\n',...
          rmse(sampson_fund(F,ml(:,in),mr(:,in))) );
        
        fprintf('Found %d inlier matches \n', sum(in));
        if sum(in) <  5.9 + 0.22*size(match,2) ||  sum(in) < matches_th
            warning('Not enough inliers');
        end
         
        ml = ml(1:2,in);   mr = mr(1:2,in);

        % principal point in the centre and f = (w+h)/2.
        % If one has a better estimate of f, it should be plugged here     
        [H1,H2, K] = rectifyF(ml, mr, [size(I1,2),size(I1,1)],(size(I1,2)+size(I1,1))/2);
              
        % transform left and right points
        mlx = htx(H1,ml); mrx = htx(H2,mr);
        
        % Sampson error wrt to F=skew([1 0 0])
        fprintf('Rectification Sampson RMSE: %0.5g pixel \n',...
             rmse(sampson_fund(skew([1 0 0]),mlx,mrx)));
           
        % projective MPP (Euclidean only if K is guessed right)
        Pn1=[K,[0;0;0]]; Pn2=[K,[1;0;0]];
       
        fprintf('Diagonal view angle estimate: %0.5g deg \n',...
            2*180*atan2(sqrt( (2*K(1,3))^2+(2*K(2,3))^2 )/2,abs(K(1,1)+K(2,2))/2)/pi);
        
        %% restore path
        path(oldpath);
    end
    
    [I1r,I2r, bb1, bb2] = imrectify(I1,I2,H1,H2,'crop');
    
    % fix the MPP after centering
    Pn1 = [1 0 -bb1(1);  0 1 -bb1(2); 0 0 1] *Pn1;
    Pn2 = [1 0 -bb2(1);  0 1 -bb2(2); 0 0 1] *Pn2;
    
end


function opts = parse_lm_options(options)
    % parse options for LM and produce an opts struct
    
    % default parameters
    opts.calibrated = false;
    opts.verbose    = false;
    
    % parse optional parameters, if any
    i = 1;
    while i <=  length(options)
        switch options{i}
            case 'Calibrated'
                opts.calibrated = true;
            case 'Uncalibrated'
                opts.calibrated = false;
            case 'Verbose'
                opts.verbose = true;
            otherwise
                error('Rectify: unrecognised option');
        end
        i = i + 1;
    end
end





