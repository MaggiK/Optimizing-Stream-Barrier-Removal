# CombineINPUT_PATH_UP

This folder contains the R script to combine the 4 csv files (input_path_up_csv1of4.csv ... input_path_up_csv4of4.csv) into the file
INPUT_PATH_UP.xlsx needed to run the optimization model. Each csv file is ~ 20 MB and provided individually because the 
combined file (~100 MB) is too large to provide on Github.

A precombined version of the file can also be found at Kraft, M., and S.E. Null. (2017). "Optimizing Barrier Removal in
Utah’s Weber Basin." HydroShare. https://doi.org/10.4211/hs.fa37f35610c34a278042d7fc93e8c47f.

Directions:
1. Download and install R/Rstudio versions X and 1.1.456
2. In the file browser, double click Optimizing-Strea-Barrier-Removal.R project. The R studio should open. 
3. Open the file CombineInputPaths.R
4. Select all the code and run it. 
5. The program will write out files INPUT_PATH_UP.csv and INPUT_PATH_UP.xlsx to the same folder
6. Move the INPUT_PATH_UP.xlsx file one folder up to the main folder where the optimization model lies
7. To automate step #6, uncomment line 55 in the R script.
