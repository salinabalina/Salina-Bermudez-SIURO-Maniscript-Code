# Code for the paper "Learning the Truncation Index of the Kronecker Product SVD for Image Restoration" 

This repository contains the code used to conduct experiments described in the research paper titled "Learning the Truncation Index of the Kronecker Product SVD for Image Restoration" authored by Salina Bermudez and project advisor Rosemary Renaut. The paper addresses the challenge of recovering high-quality images from noisy or compromised inputs, a common problem in image processing. To accomplish this, the codes main purpose is to facilitate the experimentation and evaluation of two key methods for determining a crucial parameter, the truncation index (k), which influences the quality of image recovery. The first is a supervised learning method, which requires the knowledge of true images and assesses based on the average relative error, and the second an unsupervised learning method, which utilizes the generalized cross-validation technique and does not rely on the knowledge of the true images. 

## Getting Started
### Dependencies
To use this code for your own experiments, these prerequisites must be met. 
* The code works on MATLAB version R2023b running on a 2023 MacBook Pro with Apple M2 Pro chip and 16GB memory and we cannot promise resultsit on later versions.
* The 40 numerical images used in the experiments are selected from MATLAB® and multiple online sample image databases including NASA’s California Institute of Technology, the University of Southern California, and Stanford University. The selected testing and training images are available to the public and can be found in the references of our paper [11, 12, 14, 15]. The names of all 40 images needed for these experiments can be found in the Function directory in 'namesofimages.m'.
* This code requires the MATLAB Add-On 'Image Processing Toolbox'.
* All of the tables generated are in '.tex' files and require the appropriate tool to properly open.

### Executing program
* Download all files in 'Functions' folder, 'GenerateAllFiguresforpaper.m', and 'GenerateAllTablesforpaper.m'.
* Download all 40 numerical images shown in 'namesofimages.m' from their respective websites as .tiff images.

Some templates mention adding sections for Help, Authors, Version History, License, and Acknowledgements. See if we want these too. 

## Help
think of any common problems or issues that's helpful to address

## Authors
* Salina Bermudez, School of Mathematical and Statistical Sciences, Arizona State University, AZ, (smbermu1@asu.edu, ).
* Rosemary Renaut, School of Mathematical and Statistical Sciences, Arizona State University, AZ, (renaut@asu.edu).

## Version History
* 0.1
  * Initial Release




