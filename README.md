# Optimizing-Stream-Barrier-Removal
A dual objective optimization model was developed to restore habitat connectivity while considering water scarcity losses. The model was applied to Utah's Weber River Basin but the model is generalizable to other watersheds. 

### Software Requirements:
- GAMS version 24.2.3 or later (http://gams.com, requires license. Use form on Downloads page to ask GAMS for a temporary license)
- Excel
- R studio (https://rstudio.com/, if you wish to combine the four csv files in CombineInput_PATH_UP yourself)

### This folder contains the following:
- CombineINPUT_PATH_UP: Subfolder with 4 raw input_path_up.csv files and R code to combine them into one file (INPUT_PATH_UP.csv) for input to the GAMS model
- Input.gdx: this file contains the input data for running the model in gdx (GAMS proprietary) format
- Input.xlsx: this file contains the input data for running the model in Excel format 
- Optimization_Model.gms: The model code to run in GAMS. Change the directory paths as necessary.
- Optimization_Model.log: log output file when running Optimization_Model.gms

A description of the model appears in Kraft et al (2019).

### Exaplanation of Model Input Parameters:
- Parameter distance(j,i) The distance between the two barriers in km ;
- parameter cost(k)  the cost of removing the barriers in $;
- Parameter IICnum_month(months) the precalcualted IICnumerator value for the entire basin for each month  (unitless) ;
- parameter A(j, months) the habitat or area associated with each barrier. The quality weighted habitat * the penalty ;
- Parameter links(j,i) The topological distance between the barriers (unitless) ;
- Parameter path_up(j,j,k) The barriers located between two barriers as well as the upward path marked (unitless);
- Parameter economic_costs(k, months) The normalized economic losses (between 0 and 1) (unitless/month);
- Parameter dam_costs(k, months) The actual economic losses($) of the barriers ($/month) ;
- parameter objweights(w) The weights to be applied on the objectives (0-1) (unitless) ;
- Parameter habitat(k, months) the monthly habitat without the penalty (km/month)  ;
- Parameter Rem_Budget(scenarios) Maximum budget for barrier removal ($/month) ;
- Parameter R(rad_infl) limit the distance from a single reach which the model will consider connectivity(km)    ;
- Parameter area(months) the total quality weighted habitat area by month (km/month);
- Parameter trib(i,j) giving the tributary reaches a bonus (unitless) ;

Additional descriptions of variables are available in the GAMS file. 

### Directions to Use
1. Download all materials to a local folder
1. If desired, use the R script in CombineINPUT_PATH_UP folder to combine the 4 csv files into a single Excel file. Move the combiend Excel file back into the main folder.
1. Alternatively, download the already combined Excel file INPUT_PATH_UP.xlsx from Kraft and Null (2018) - https://www.hydroshare.org/resource/889b9ccbb0c7407ea9a5a1b5d2bbb935/
1. Download and install GAMS version 24.2.3 from. See Older GAMS Distributions at the bottom of https://www.gams.com/download/.
1. Open the GAMS IDE
1. Select File => Project => New Project and create a new project in the folder where you downloaded materials in Step 1 (a GAMS project is a working directory)
1. Open the file Optimization_Model.gms.
1. Select the Run icon or press F9
1. GAMS will solve ~ 1*3*15*1 = 45 scenarios (about 12 hours or more of run time) the program will spit out a bunch of output .gdx and .xlsx files with the names barriers_revomoved.xlsx, Results.xlsx, etc. that are the output
1. To test everything works on just 1 run, comment out line 248 (a LOOP all statement), and uncomment line 250 (A conditional LOOP statement for one run). 
1. Postprocessing - more forecoming

### Recommended Citation
Kraft, M., Rosenberg, D. E., and Null, S. (2019). "Prioritizing Stream Barrier Removal to Maximize Connected Aquatic Habitat and Minimize Water Scarcity." Journal of the American Water Resources Association.
	https://onlinelibrary.wiley.com/doi/pdf/10.1111/1752-1688.12718.
	preprint (MS thesis): https://digitalcommons.usu.edu/etd/6885/
