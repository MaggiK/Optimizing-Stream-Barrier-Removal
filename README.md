# Optimizing-Stream-Barrier-Removal
A dual objective optimization model was developed to restore habitat connectivity while considering water scarcity losses. The model was applied to Utah's Weber River Basin but the model is generalizable to other watersheds. 


This folder contains the following:
- Optimization_Model.gms: The model code to run in GAMS. Change the directory paths as necessary. 
- Input: this file contains the input data for running the model. 
- Input_path_up_csv1of(1-4): The possible stream reach combinations and barriers located between each set of barriers. These 4 files need to be combined into one large csv before running the model. 

The Input Parameters:
Parameter distance(j,i) The distance between the two barriers in km ;
parameter cost(k)  the cost of removing the barriers in $;
Parameter IICnum_month(months) the precalcualted IICnumerator value for the entire basin for each month  (unitless) ;
parameter A(j, months) the habitat or area associated with each barrier. The quality weighted habitat * the penalty ;
Parameter links(j,i) The topological distance between the barriers (unitless) ;
Parameter path_up(j,j,k) The barriers located between two barriers as well as the upward path marked (unitless);
Parameter economic_costs(k, months) The normalized economic losses (between 0 and 1) (unitless/month);
Parameter dam_costs(k, months) The actual economic losses($) of the barriers ($/month) ;
Parameter objweights(w) The weights to be applied on the objectives (0-1) (unitless) ;
Parameter habitat(k, months) the monthly habitat without the penalty (km/month)  ;
Parameter Rem_Budget(scenarios) Maximum budget for barrier removal ($/month) ;
Parameter R(rad_infl) limit the distance from a single reach which the model will consider connectivity(km)    ;
Parameter area(months) the total quality weighted habitat area by month (km/month);
Parameter trib(i,j) giving the tributary reaches a bonus (unitless) ;

Additional descriptions of variables are available in the GAMS file. 
