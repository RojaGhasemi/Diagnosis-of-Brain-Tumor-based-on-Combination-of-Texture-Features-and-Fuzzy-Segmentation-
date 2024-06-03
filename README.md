# Project Title : Diagnosis of Brain Tumor based on Combining of DWT and Zernike moment and Fuzzy Segmentation 

## Abstract
The steps of performing proposed method can be divided into three categories: tumor segmentation, feature extraction, and classification. In this study, Zernike moments combination and discrete wavelet transform have been used to extract the feature, which is a powerful method for extracting image texture. The ACO algorithm is used to select useful features. Finally, the SVM cluster was used to classify the extracted features and tumor diagnosis. Fuzzy logic is also used to segment the tumor area. The results of our experiments on the clinical database show that the proposed method is more efficient and accurate than previous methods. Also the proposed method has been tested with two categories SVM and K-NN and we have shown that SVM category has about 88% accuracy and it has higher accuracy than K-NN category.

## Proposed Method
1- Pre-processing breast images
•	Convert image to grayscale

•	Denoising using medial filter

•	Resizing to 300×300




2- Feature extraction using DWT ( discrete wavelet transform) and Zernike moment

3- Feature selection using ACO (Ant Colony Optimization)

4- Classification using SVM ( support vector machine)




## Dataset

•	Clinical dataset  (2500 MRI normal images, 2500 MRI abnormal images, 70% for training, 30% for testing)


## How to Use

•	First click on run.m ftle and then run it

•	Secondly click on ‘train database’

•	Then after train, click on ‘select image for test’ button

•	Click on ‘tashkhis’ button

•	Finally click on ‘segmentation’ button, you can see ‘Mmalignant’ or ‘Benign’ 





## Project History
This project was originally completed in 2020. The commit history has been adjusted to reflect the original dates of the work.

## Code explanation video
https://drive.google.com/file/d/17-gl7JL5i9bjDscx8OtmkmH5E-KGCirK/view?usp=drive_link

