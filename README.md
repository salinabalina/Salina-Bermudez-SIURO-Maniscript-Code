# Salina-Bermudez-SIURO-Manuscript-Code (fix title)

This repository contains the code used to conduct experiments described in the research paper titled "Learning the Truncation Index of the Kronecker Product SVD for Image Restoration" authored by Salina Bermudez and project advisor Rosemary Renaut. The paper addresses the challenge of recovering high-quality images from noisy or compromised inputs, a common problem in image processing. To accomplish this, the codes main purpose is to facilitate the experimentation and evaluation of two key methods for determining a crucial parameter, the truncation index (k), which influences the quality of image recovery. The first is a supervised learning method, which requires the knowledge of true images and assesses based on the average relative error, and the second an unsupervised learning method, which utilizes the generalized cross-validation technique and does not rely on the knowledge of the true images. 

## Getting Started
### Dependencies
To use this code for your own experiments, these prerequisites must be met. 
* Installation of MATLAB version R2022a (comment: do we say this version OR at least the most recent?) running on a 2021 MacBook Pro with Apple M1 Max chip and 32GB memory (comment: doesn't feel reasonable to say this but i feel we should mention it somewhere?) .
* The 40 numerical images used in the experiments are selected from MATLAB® and multiple online sample image databases including NASA’s California Institute of Technology, the University of Southern California, and Stanford University. The selected testing and training images are available to the public and can be found in the references of our paper [11, 13, 14]. The names of all 40 images needed for these experiments can be found in the Function directory in 'namesofimages.m'.
* Installation of the Image Processing Toolbox within MATLAB. (comment: was this used?)
* Consider any specific modifications that need to be made to files/folders 

### Executing program

## Help
think of any common problems or issues that's helpful to address

Some templates mention adding sections for Authors, Version History, License, and Acknowledgements. See if we want these too. 




