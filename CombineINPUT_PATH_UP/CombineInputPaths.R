## Prepare Input_Path_Up data for Optimizating Stream Barrier removal

## Combines the spearate csv files input_path_up_csv1of4, 2of4, 3of4, and 4of4 into one Excel file INPUT_PATH_UP.xlsx
## This is needed because GitHub has a max file size of 100 MB and these four files approach that limit
##
## Run this script to generate the excel file before running GAMS!
##
## This step is added to automate and improve the reproducibility of the work
##
## Thank you to Franz Nelissen at GAMS for pointing out this issue
##
## May 18, 2020
## David E. Rosenberg
## david.rosenberg@usu.edu
##
## This script supports: Kraft, M., Rosenberg, D. E., and Null, S. (2019). "Prioritizing Stream Barrier Removal to Maximize Connected Aquatic Habitat and Minimize Water Scarcity." Journal of the American Water Resources Association. https://onlinelibrary.wiley.com/doi/pdf/10.1111/1752-1688.12718.

## General Steps
## 1. Read in the separate CSV files
## 2. Merge them
## 3. Output to a single .xlsx file named on Input_Path_Up.csv on the user's machine in the same folder as the input files

# Packages we need
install.packages("writexl", repos="http://cran.r-project.org") # https://cran.r-project.org/web/packages/writexl/writexl.pdf
library(writexl)


## 1. Read i the separate CSV files
 #List of files to read in
 sFileNames <- c("input_path_up_csv1of4.csv","input_path_up_csv2of4.csv","input_path_up_csv3of4.csv","input_path_up_csv4of4.csv")
 #Number of files to read in
 nFiles <- length(sFileNames)
 
 #Read the first file
 dfAll <- read.csv(sFileNames[1])
 #Read the remaining files
 for(sFile in sFileNames[2:(nFiles)]) {
   dfCurrFile <- read.csv(sFile)
   dfAll <- rbind(dfAll,dfCurrFile)
 }
 
 #When R reads in the csvs it adds an X infront of the numeric column header. Remove these
 #Get the column names
 cColHeads <- colnames(dfAll)
 cColHeadsClean <- stringr::str_remove(cColHeads,"X")
 
 colnames(dfAll) <- cColHeadsClean
 
 #Write out combined to CSV in same folder (incase)
 write.csv(dfAll,"INPUT_PATH_UP.csv", row.names=FALSE, quote=FALSE)
 
 #Write out to excel
 writexl::write_xlsx(dfAll, "INPUT_PATH_UP.xlsx")
 #Write out to one folder up
 #writexl::write_xlsx(dfAll, "../INPUT_PATH_UP.xlsx")
 
 