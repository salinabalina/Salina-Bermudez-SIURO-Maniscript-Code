# Code for the paper "Learning the Truncation Index of the Kronecker Product SVD for Image Restoration" 

This repository contains the code used to conduct experiments described in the research paper titled "Learning the Truncation Index of the Kronecker Product SVD for Image Restoration" authored by Salina Bermudez and project advisor Rosemary Renaut. The paper addresses the challenge of recovering high-quality images from noisy or compromised inputs, a common problem in image processing. To accomplish this, the codes main purpose is to facilitate the experimentation and evaluation of two key methods for determining a crucial parameter, the truncation index (k), which influences the quality of image recovery. The first is a supervised learning method, which requires the knowledge of true images and assesses based on the average relative error, and the second an unsupervised learning method, which utilizes the generalized cross-validation technique and does not rely on the knowledge of the true images. 

## Getting Started
### Dependencies
To use this code for your own experiments, these prerequisites must be met. 
* The code was run on MATLAB version R2023b on a 2023 MacBook Pro with Apple M2 Pro chip and 16GB memory. We cannot promise results on later versions.
* The 40 numerical images used in the experiments are selected from multiple online sample image databases including NASA’s California Institute of Technology, the University of Southern California, Stanford University, and an online site bogotobogo. The selected testing and training images are available to the public and can be found in the references of our paper [11, 12, 14, 15]. The names of all 40 images needed for these experiments can be found in the Function directory in 'namesofimages.m'.
* This code requires the MATLAB Add-On 'Image Processing Toolbox'.
* All of the tables generated are in '.tex' files and require the appropriate tool to properly open.

### Executing program
* Download GenerateResults.m script.
* Download all functions and place into subfolder titled 'Functions'.
* Download all 40 numerical images shown in 'namesofimages.m' from their respective websites as .tiff images. Place in subfolder titled 'Images'.
  

### Illustrating the results
* Run the script GenerateResults.m to obtain all images and tables shown in the associated report.

## Help
* Ensure that the image names are not altered when downloaded from their websites.
* Make sure all functions and images are in their respective subfolders.

## Acknowledgment

If you use this code for your work or research, please acknowledge the GitHub repository and cite the associated paper titled "Learning the Truncation Index of the Kronecker Product SVD for Image Restoration" authored by Salina Bermudez and project advisor Rosemary Renaut for the results obtained using this code.

GitHub Repository: [https://github.com/sbermudez01/Salina-Bermudez-SIURO-Manuscript-Code.git]
<br>
Undergraduate Paper: [Insert the Citation Information for Your Paper]


## Authors
* Salina Bermudez, School of Mathematical and Statistical Sciences, Arizona State University, AZ, (smbermu1@asu.edu).
* Rosemary Renaut, School of Mathematical and Statistical Sciences, Arizona State University, AZ, (renaut@asu.edu).

## Version History
* 0.1
  * Initial Release




