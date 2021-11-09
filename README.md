
#Epipolar Rectification Toolkit

### Andrea Fusiello, 2020

This toolkit is a collection of Matlab functions implementing
epipolar rectification both in the calibrated and uncalibrated
case.  It requires functions contained in the [Computer Vision
Toolkit]
(http://www.diegm.uniud.it/fusiello/demo/toolkit/ComputerVisionToolkit.zip)
by the same author and the [VLfeat toolbox] (http://www.vlfeat.org)
by A. Vedaldi, for the SIFT implementation.

After installing the abovementioned dependencies, cd to the
toolkit main directory and type `runMe`.

The `rectify()` function contained here calls either
`rectifyP()` (calibrated) or `rectifyF()` (uncalibrated) according to
the case. Then it calls `imrectify()` which perforn the image
warping and takes care of bounding boxes and centering.

Please note that the functions: `rectifyP(), rectifyF(),
imrectify()` are *not* contained in this toolkit as they are now
part of the [Computer Vision Toolkit]
(http://www.diegm.uniud.it/fusiello/demo/toolkit/ComputerVisionToolkit.zip).

The data is in the `examples` folder. It should be easy to
replace it with your own images. The 3x4 camera matrix
is contained in a text file with extension `.pm`.

While in the calibrated case results are always correct, 
in the uncalibrated case they depend on the matches computed
by RANSAC and on the success of the non-linear minimization.  
As a consequence, results are not guaranteed may differ from
run to run.

Reference papers:

	@Article{FusTruVer99,
	 author = 	 {A. Fusiello and E. Trucco and A. Verri},
	  title = 	 {A Compact Algorithm for Rectification of Stereo Pairs},
	  year = 	 {2000},
	  journal =  {Machine Vision and Applications},
	  volume = 	 {12},
	  number = 	 {1},
	  pages = 	 {16-22},
	  pdf =      {http://profs.sci.univr.it/\~fusiello/papers/00120016.pdf}
	}

	@Article{FusIrs10,
	  author =	 {A. Fusiello and L. Irsara},
	  title =	 {Quasi-Euclidean epipolar rectification of uncalibrated images},
	  journal =	 {Machine Vision and Applications},
	  year =	 2011,
	  volume =	 22,
	  number =	 4,
	  pages =	 {663 - 670},
	  doi =		 {10.1007/s00138-010-0270-3},
	  Webpdf =	 {http://www.diegm.uniud.it/fusiello/papers/mva10.pdf}
	}
	


---
Andrea Fusiello                
Dipartimento Politecnico di Ingegneria e Architettura (DPIA)  
Università degli Studi di Udine, Via Delle Scienze, 208 - 33100 Udine  
email: <andrea.fusiello@uniud.it>

---
