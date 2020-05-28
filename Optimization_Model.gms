$ontext
Maggi Kraft    (12/2017)
maggikraft4@gmail.com
Developed as part of my M.S. Thesis work at Utah State University

This code contains the code for the dual objective optimization model in the Weber River Basin but the model is generalizable to other stream networks. The goal of the model is to maximize quality-weighted fish habitat while minimizing  water scarcity costs.
The model is constrained by a budget for barrier removal. The weighted sum method is used to create the Pareto Optimal front between the tradeoffs.

-passability: used as a penalty to nudge the program to remove barriers that are less passable/ more of an impact
  To do this each barrier receives a score between 0 to 1 where 0 is fully passable and 1 is not. This way
  the barriers that are not passable keep their full distance. While passable barriers distance are reduced.
-Optimizing the habitat connectivity: The index is the IIC(integral index of connectivity).
The IIC is calculated with and without the set of nodes present in the calculation to come up with maximum habitat connectivity.

- currently I am looping through- 12 months. Also different weights (w) for each objective. And finally each scenario
or budget level.

-economic costs (water scarcity) were calculated with the Ogden area economic loss curves (Null unpublished). The equation constructing the curves was used to estimate the cost of water with the dam
and without the dam. I used the average of previous months/years inflow/ outflow data for the dam. With the dam the flows are the outflow, without they are the inflow.

- Aquatic habitat is defined as the intersection between Discharge, water temperature, geomorphic condition, and gradient

sets:
j- represent barriers at location j(or alias i).
k- barriers between two sets of barriers j (i)

months The months to model each scenario where  /1*12/

*S17 is $100M   S8 is $1.5M
scenarios Budget scenarios to loop through /S1*S22/

w the weights on the objective function to cycle through each scenario and month /w1*w48/

rad_infl the dispersal thresholds or radius of influences to cycle through /r1* r4/

BINARY VARIABLES
CR_up(i,j) The binary choice of choosing reach a reach.  1 when connected reach between patch i and patch j is free of barriers 0 if there is one or more barriers
B(k) binary removal decision of barriers on path i to j (1 is remove 0 is not)
 ;
VARIABLES
WEIGHT Dual objective function value
IIC environmental objetive function value
D(i,j) distance variable (actual distance in km (not weighted))
AREA_MONTHS The area for each month   (the total quality-weighted habitat in the stream network for that month)
A_MONTHS(j) The habitat or area above each each barrier to loop through
IICNUMERATOR The IICnum value by month with all the barriers. The numerator of the IIC calculation for each month without any barriers removed (sum(2*(A_MONTHS.L(j)*A_MONTHS.L(i))/Lij) This is used to normalize the data so it is between 0 and 1 and comparible to the water scarcity costs in the objective function.
ECO_months(k)  to calculate the economic loss ($) of barrier removed k
ECO_LOSS_months(k) to calculate the economic loss ($) of barrier removed k
ECO_LOSS the output/actual value of economic loss of barrier removed k
QU length of quality habitat without penalty
HABITAT_MONTHS(k) the quality weighted habitat for each month above barrier k
WT the weights to cycle through (w1*w48)
BUDGET differnt budgets to loop through
ROL the different dispersal thresholds to cycle through

PARAMETERS
barriers_on_path_sum(i,j)  barriers on path in the upstream direction (path_up)
ObjFunc(months,w, scenarios, rad_infl) Objective funcation values (habitat)
Barriers_Removed(k, months,w, scenarios, rad_infl) Barriers removed in each scenario
spent(months,w, scenarios, rad_infl) how much was spent in each scenario
CR_upstream(months,i,j, w, scenarios, rad_infl) To save the output of the CR upstream value in the loop
CR_downstream(months, i, j, w, scenarios, rad_infl) To save the output of the CR downstream value in the loop
dam_economic_loss(months, w, scenarios, rad_infl)  To save the output of the economic losses
ecoObj(months,w, scenarios, rad_infl)   To save the output from the IIC objective
Quality_Length(months,w, scenarios,rad_infl) the quality length of habitat (doesn't have penalty in the function.

;
*calculate the number of barriers between i and j. This is used to determine if a reach (CRij) is an unimpeded reach or not.
barriers_on_path_sum(i,j)= sum(k, path_up(i,j,k)) ;

EQUATIONS
WEIGHTED  the objective function value
CRterm(i,j) defining the CR term so that you divide by the total barriers in the reach to count this is the upstream file
Financial the budget constraint
economic_loss the economic loss in $
qual quality habitat without passability  (no penalty incorporated)
*constrain_num_B Constraining the number of barriers that can be removed in each scenario


$offtext


sets
j barrier locations at j (downstream from i)
/1121,1120,1119,1118,1116,1107,1106,1105,1103,1102,1101,1099,1098,1097,1096,1095,1091,1090,1082,1081,1080,1078,1077,1076,1075,1070,1064,1060,1058,1057,1054,1052,1050,1049,1048,1046, 1044,1040,1039,1038,1037,1035,1034,1032,1030,1029,1027,1025,1023,1022,1021,1020,1019,1018,1015,1014,1013,1012,1011,1010,1009,1007,1006,1005,1003,1002,1000,999,998,997, 995,994,993,992,991,988,987,986,985,983,981,980,979,978,977,976,975,974,973,971,970,969,967,966,965,964,963,962,961,959,958,957,955,954,953,952,951,948,947,946,945,943,942,940,939,938, 934,933,931,930,929,928,927,926,925,924,923,921,920,919,917,915,914,913,912,911,910,907,906,905,904,902,901,893,892,890,886,883,882,881,880,876,871,869,867,866,865,864,861,859,858,857, 856,855,854,853,851,849,848,847,846,845,843,842,841,840,838,837,836,835,832,831,830,829,828,827,824,823,822,821,820,819,818,817,816,815,814,813,812,811,809,807,806,805,804,803,802,801, 800,799,798,797,796,795,794,793,792,791,790,789,788,787,785,784,782,779,778,777,776,775,774,773,770,769,766,765,763,762,761,760,759,758,757,756,755,754,752,750,746,744,743,742,738,735,734,733,732,730,728,725,723,722,721,720,719,713,712,711,710,708,707,706,704,703,702,701,700,698,697,695,694,693,691,690,689,687,686,683,681,680,678,674,673,672,671,669,668,666,664,663,662,656,650,647,645,643,641,639,636,634,632,628,625,624,617,616,615,614,611,608,602,601,600,597,596,595,593,592,590,589,588,587,585,581,577,576,574,573,572,571,570,568,567,566,564,562,560, 559/

*no economic loss dams (Turn this on and the above set off if economic loss barriers are not included in the model)
*/1121,1120,1119,1118,1116,1107,1106,1105,1103,1102,1101,1099,1098,1097,1096,1095,1091,1090,1082,1081,1080,1078,1077,1076,1075,1070,1060,1058,1057,1054,1052,1050,1049,1048,1046,1044,1040,1039,1038,1037,1035,1034,1032,1030,1029,1027,1025,1023,1022,1021,1020,1019,1018,1015,1014,1013,1012,1011,1010,1009,1007,1006,1005,1003,1002,1000,999,998,997,995,994,993,992,991,988,987,986,985,983,981,980,979,978,977,976,975,974,973,971,970,969,967,965,964,963,962,961,959,958,957,955,954,953,952,951,948,947,946,945,943,942,940,939,938,934,933,931,930,929,928,927,926,925,924,923,921,920,919,917,915,914,913,911,910,907,906,905,902,901,893,892,890,886,883,882,880,876,871,869,867,866,865,864,861,859,858,857,856,855,854,853,851,849,848,847,846,845,843,842,841,840,838,837,836,835,832,831,830,829,828,827,824,823,822,821,820,819,818,817,816,815,814,813,812,811,809,807,806,805,804,803,802,801,800,799,798,797,796,795,794,793,792,791,790,789,788,787,785,784,782,779,778,777,776,775,774,773,770,769,766,765,763,762,761,760,759,758,757,756,755,754,752,750,746,744,743,742,738,734,733,732,730,728,725,722,721,720,719,713,712,711,710,708,707,706,704,703,702,701,700,698,697,695,694,693,691,690,689,687,686,681,680,678,674,673,672,671,669,668,666,664,663,662,656,650,647,645,643,641,639,636,634,632,628,625,617,616,615,614,611,608,602,601,600,597,596,595,593,592,590,589,588,587,585,581,577,576,574,573,572,571,570,568,567,566,562,560,559/


k barrier locations at k (between i and j)
/1121,1120,1119,1118,1116,1107,1106,1105,1103,1102,1101,1099,1098,1097,1096,1095,1091,1090,1082,1081,1080,1078,1077,1076,1075,1070,1064,1060,1058,1057,1054,1052,1050,1049,1048,1046,1044,1040,1039,1038,1037,1035,1034,1032,1030,1029,1027,1025,1023,1022,1021,1020,1019,1018,1015,1014,1013,1012,1011,1010,1009,1007,1006,1005,1003,1002,1000,999,998,997,995,994,993,992,991,988,987,986,985,983,981,980,979,978,977,976,975,974,973,971,970,969,967,966,965,964,963,962,961,959,958,957,955,954,953,952,951,948,947,946,945,943,942,940,939,938,934,933,931,930,929,928,927,926,925,924,923,921,920,919,917,915,914,913,912,911,910,907,906,905,904,902,901,893,892,890,886,883,882,881,880,876,871,869,867,866,865,864,861,859,858,857,856,855,854,853,851,849,848,847,846,845,843,842,841,840,838,837,836,835,832,831,830,829,828,827,824,823,822,821,820,819,818,817,816,815,814,813,812,811,809,807,806,805,804,803,802,801,800,799,798,797,796,795,794,793,792,791,790,789,788,787,785,784,782,779,778,777,776,775,774,773,770,769,766,765,763,762,761,760,759,758,757,756,755,754,752,750,746,744,743,742,738,735,734,733,732,730,728,725,723,722,721,720,719,713,712,711,710,708,707,706,704,703,702,701,700,698,697,695,694,693,691,690,689,687,686,683,681,680,678,674,673,672,671,669,668,666,664,663,662,656,650,647,645,643,641,639,636,634,632,628,625,624,617,616,615,614,611,608,602,601,600,597,596,595,593,592,590,589,588,587,585,581,577,576,574,573,572,571,570,568,567,566,564,562,560, 559/

*no economic loss dams (Turn this on and the above set off if economic loss barriers are not included in the model)
*/1121,1120,1119,1118,1116,1107,1106,1105,1103,1102,1101,1099,1098,1097,1096,1095,1091,1090,1082,1081,1080,1078,1077,1076,1075,1070,1060,1058,1057,1054,1052,1050,1049,1048,1046,1044,1040,1039,1038,1037,1035,1034,1032,1030,1029,1027,1025,1023,1022,1021,1020,1019,1018,1015,1014,1013,1012,1011,1010,1009,1007,1006,1005,1003,1002,1000,999,998,997,995,994,993,992,991,988,987,986,985,983,981,980,979,978,977,976,975,974,973,971,970,969,967,965,964,963,962,961,959,958,957,955,954,953,952,951,948,947,946,945,943,942,940,939,938,934,933,931,930,929,928,927,926,925,924,923,921,920,919,917,915,914,913,911,910,907,906,905,902,901,893,892,890,886,883,882,880,876,871,869,867,866,865,864,861,859,858,857,856,855,854,853,851,849,848,847,846,845,843,842,841,840,838,837,836,835,832,831,830,829,828,827,824,823,822,821,820,819,818,817,816,815,814,813,812,811,809,807,806,805,804,803,802,801,800,799,798,797,796,795,794,793,792,791,790,789,788,787,785,784,782,779,778,777,776,775,774,773,770,769,766,765,763,762,761,760,759,758,757,756,755,754,752,750,746,744,743,742,738,734,733,732,730,728,725,722,721,720,719,713,712,711,710,708,707,706,704,703,702,701,700,698,697,695,694,693,691,690,689,687,686,681,680,678,674,673,672,671,669,668,666,664,663,662,656,650,647,645,643,641,639,636,634,632,628,625,617,616,615,614,611,608,602,601,600,597,596,595,593,592,590,589,588,587,585,581,577,576,574,573,572,571,570,568,567,566,562,560,559/

months The months to model each scenario where 13 is the average of all the months /8/

*S17 is $100M   S8 is $1.5M
scenarios Budget scenarios to loop through /S8, S17, S22/

w the weights to cycle through each scenario and month /w34*w48/

rad_infl the dispersal thresholds or radius of influences to cycle through /r4/
 ;


Alias (j, i);


*$CALL gdxxrw.exe I=C:\Users\Maggi\Documents\WEBER\GAMS\1_Excel\INPUT.xlsx O=C:\Users\Maggi\Documents\WEBER\GAMS\2_GDX\INPUT.gdx par=distance rng=distance!A1:MK349 Rdim=1 Cdim=1  par=cost rng=cost!A1:B348 Rdim=1 par=penalty rng=penalty!A1:MK349 Rdim=1 Cdim=1 par=A rng=A!A1:M349 Rdim=1 Cdim=1  par=economic_costs rng=economic!A1:N349 Rdim=1 Cdim=1   par=dam_costs rng=economic_cost!A1:N349 Rdim=1 Cdim=1 par=links rng=links!A1:MK349 Rdim=1 Cdim=1 par= IICnum_month rng=IICnum_month!A1:B12 Rdim=1 par= objweights rng=weights!A1:B48 Rdim=1 par=habitat rng= habitat!A1:M349 Rdim=1 Cdim=1 par=Rem_budget rng= bud_scenarios!A1:B26 Rdim =1  par= R rng=R!A1:B5 Rdim=1 par= area rng = area!A1:L2 Cdim=1 par=trib rng=trib!A1:MK349 Cdim=1 Rdim=1
$CALL gdxxrw.exe I=INPUT.xlsx O=INPUT.gdx par=distance rng=distance!A1:MK349 Rdim=1 Cdim=1  par=cost rng=cost!A1:B348 Rdim=1 par=penalty rng=penalty!A1:MK349 Rdim=1 Cdim=1 par=A rng=A!A1:M349 Rdim=1 Cdim=1  par=economic_costs rng=economic!A1:N349 Rdim=1 Cdim=1   par=dam_costs rng=economic_cost!A1:N349 Rdim=1 Cdim=1 par=links rng=links!A1:MK349 Rdim=1 Cdim=1 par= IICnum_month rng=IICnum_month!A1:B12 Rdim=1 par= objweights rng=weights!A1:B48 Rdim=1 par=habitat rng= habitat!A1:M349 Rdim=1 Cdim=1 par=Rem_budget rng= bud_scenarios!A1:B26 Rdim =1  par= R rng=R!A1:B5 Rdim=1 par= area rng = area!A1:L2 Cdim=1 par=trib rng=trib!A1:MK349 Cdim=1 Rdim=1

*$CALL gdxxrw.exe I=C:\Users\Maggi\Documents\WEBER\GAMS\1_Excel\INPUT_PATH_UP.xlsx O=C:\Users\Maggi\Documents\WEBER\GAMS\2_GDX\INPUT_PATH_UP.gdx par=path_up rng=path_up!A1:ML121105 Rdim=2 Cdim=1
$CALL gdxxrw.exe I=INPUT_PATH_UP.xlsx O=INPUT_PATH_UP.gdx par=Sheet1 rng=path_up!A1:ML121105 Rdim=2 Cdim=1

;
*the parameters imported from excel
Parameter distance(j,i) The distance betweent he two barriers in km ;
parameter cost(k)  the cost of removing the barriers in $;
Parameter penalty(j, j) the penalty or barrier passage associated with the barrier- penalty was added to the habitat (A) in excel so I am not using this (as of 10-10) ;
Parameter IICnum_month(months) the precalcualted IICnumerator value for the entire basin for each month  ;
parameter A(j, months) the habitat or area associated with each barrier. The quality weighted habitat * the penalty ;
Parameter links(j,i) The topological distance between the barriers;
Parameter path_up(j,j,k) The barriers located between two barriers as well as the upward path marked ;
Parameter economic_costs(k, months) The normalized economic losses (between 0 and 1) ;
Parameter dam_costs(k, months) The actual economic losses($) of the barriers ;
Parameter objweights(w) The weights to be applied on the objectives (0-1) ;
Parameter habitat(k, months) the monthly habitat without the penalty   ;
Parameter Rem_Budget(scenarios)  ;
Parameter R(rad_infl)     ;
Parameter area(months) the total quality weighted habitat area by month ;
Parameter trib(i,j) giving the tributary reaches a bonus ;

*$GDXIN C:\Users\Maggi\Documents\WEBER\GAMS\2_GDX\INPUT.gdx
$GDXIN INPUT.gdx
$LOAD cost
$LOAD links
$LOAD penalty
$LOAD A
$LOAD distance
$LOAD IICnum_month
$LOAD economic_costs
$LOAD objweights
$LOAD habitat
$LOAD Rem_Budget
$LOAD dam_costs
$LOAD R
$LOAD area
$LOAD trib

$GDXIN

*$GDXIN C:\Users\Maggi\Documents\WEBER\GAMS\2_GDX\INPUT_PATH_UP.gdx
$GDXIN INPUT_PATH_UP.gdx
$LOAD path_up
$GDXIN

display trib ;

BINARY VARIABLES
CR_up(i,j)  1 when connected reach between patch i and patch j is free of barriers 0 if there is one or more barriers
B(k) binary removal decision of barriers on path i to j (1 is remove 0 is not)
 ;
VARIABLES
WEIGHT Dual objective function value
IIC environmental objetive function value
D(i,j) distance variable
AREA_MONTHS The area for each month
A_MONTHS(j) The habitat or area of each each node to loop through
IICNUMERATOR The IICnum value by month with all the barriers
ECO_months(k)
ECO_LOSS_months(k)
ECO_LOSS
QU length of quality habitat without penalty
HABITAT_MONTHS(k) the quality weighted habitat for each month above barrier k
WT the weights to cycle through
BUDGET differnt budgets to loop through
ROL the different dispersal thresholds to cycle through

 ;

PARAMETERS
barriers_on_path_sum(i,j)  barriers on path in the upstream direction (path_up)
ObjFunc(months,w, scenarios, rad_infl) Objective funcation values (habitat)
Barriers_Removed(k, months,w, scenarios, rad_infl) Barriers removed in each scenario
spent(months,w, scenarios, rad_infl) how much was spent in each scenario
CR_upstream(months,i,j, w, scenarios, rad_infl) To save the output of the CR upstream value in the loop
CR_downstream(months, i, j, w, scenarios, rad_infl) To save the output of the CR downstream value in the loop
dam_economic_loss(months, w, scenarios, rad_infl)  To save the output of the economic losses
ecoObj(months,w, scenarios, rad_infl)   To save the output from the IIC objective
Quality_Length(months,w, scenarios,rad_infl) the quality length of habitat (doesn't have penalty in the function.

;
*calculate the number of barriers between i and j. This is used to determine if a reach (CRij) is an unimpeded reach or not.
barriers_on_path_sum(i,j)= sum(k, path_up(i,j,k)) ;

DISPLAY barriers_on_path_sum;

EQUATIONS
WEIGHTED  the objective function value
CRterm(i,j) defining the CR term so that you divide by the total barriers in the reach to count this is the upstream file
Financial the budget constraint
economic_loss the economic loss in $
qual quality habitat without passability aka the penalty in it
*constrain_num_B Constraining the number of barriers that can be removed in each scenario
;

*********************************************************************************
*objective function

WEIGHTED..        WEIGHT =E= ( (1 - WT.L)* (sum((i,j)$(ord(i) lt ord(j) AND (distance(i,j) le ROL.L)), [(2*(A_MONTHS.L(j)*A_MONTHS.L(i)*CR_UP(i,j)))/links(i,j)]) + sum(i,[sqr(A_MONTHS.L(i))])) / IICNUMERATOR.L ) - (WT.L * SUM(k, ECO_months.L(k)*B(k)))   ;

*********************************************************************************
*Below are different objective functions that can be turned on instead of the one above. These were for the sensitivity analyses to add or remove different variables.
*********************************************************************************

*adding a weight to barriers that are contain different tributaries. A reach with multiple tributaries receives a greater weight than a reach in only on river segment. reaches that are tributary pairs receive a bonus (multiply by 1.5). ALL other pairs receive a multiplication of 1
*WEIGHTED..        WEIGHT =E= ( (1 - WT.L)* (sum((i,j)$(ord(i) lt ord(j) AND (distance(i,j) le ROL.L)), [(2*(A_MONTHS.L(j)*A_MONTHS.L(i)*CR_UP(i,j)*trib(i,j)))/links(i,j)]) + sum(i,[sqr(A_MONTHS.L(i))])) / IICNUMERATOR.L ) - (WT.L * SUM(k, ECO_months.L(k)*B(k)))   ;

* no connectivity- optimize the quality-weighted habitat (with passage)
*WEIGHTED..        WEIGHT =E= ( (1 - WT.L)* (sum((k), A_MONTHS.L(k)*B(k)))/AREA_MONTHS.L) - (WT.L * SUM(k, ECO_months.L(k)*B(k)))   ;

*no penalty or passability
*WEIGHTED..        WEIGHT =E= ( (1 - WT.L)* (sum((i,j)$(ord(i) lt ord(j) AND (distance(i,j) le ROL.L)), [(2*( HABITAT_MONTHS.L(j)* HABITAT_MONTHS.L(i)*CR_UP(i,j)))/links(i,j)]) + sum(i,[sqr( HABITAT_MONTHS.L(i))])) / IICNUMERATOR.L ) - (WT.L * SUM(k, ECO_months.L(k)*B(k)))   ;

*one objective (no water scarcity costs)
*WEIGHTED..        WEIGHT =E= (sum((i,j)$(ord(i) lt ord(j) AND (distance(i,j) le ROL.L)), [(2*(A_MONTHS.L(j)*A_MONTHS.L(i)*CR_UP(i,j)))/links(i,j)]) + sum(i,[sqr(A_MONTHS.L(i))])) / IICNUMERATOR.L    ;

*********************************************************************************
*constraints
*********************************************************************************

CRterm(i,j)..      CR_UP(i,j)$(ord(i) lt ord(j)AND (distance(i,j) le ROL.L)) =L= sum(k, (path_up(i,j,k)*B(k)))/ barriers_on_path_sum(i,j)  ;
Financial..                BUDGET.L =G= SUM((k), cost(k) * B(k))          ;
economic_loss..            ECO_LOSS =E= sum((k), ECO_LOSS_months.L(k)* B(k)) ;
qual..                     QU =E=sum((k), HABITAT_months.L(k) * B(k)) ;
*Constraining the number of barriers that can be removed
*constrain_num_B..          1 =G= sum(k, B(k))  ;

**************************
*LOOP and SOLVE MAGIC
************************
*need to establish an alias for months because it shows up in the objective function. Also, all the loops should be mn so it loops throught he months (I think)
ALIAS(months, mn) ;

MODEL CONNECTIVITY /All/
Loop((mn, w, scenarios, rad_infl),
*change to Loop((scenarios,months),
         BUDGET.L = Rem_Budget(scenarios)   ;
         WT.L = objweights(w) ;
         A_MONTHS.L(j) = A(j, mn)  ;
         IICNUMERATOR.L = IICnum_month(mn)  ;
         AREA_MONTHS.L = area(mn)  ;
         ECO_months.L(k) = economic_costs(k, mn) ;
         ECO_LOSS_months.L(k) = dam_costs(k,mn);
         HABITAT_MONTHS.L(k) = habitat(k, mn);
         ROL.L = R(rad_infl)  ;

*resetting to a bigger resource limit
         OPTION Reslim = 9999999 ;
*setting to make each soluation optimal
         OPTION optcr=0.0 ;

         SOLVE CONNECTIVITY USING MIP MAXIMIZING WEIGHT   ;

*objfunction value saved for each scenario- objective 1. The quality weighted habitat
         ObjFunc(mn, w, scenarios, rad_infl) = WEIGHT.L  ;
*Decisions- which barriers are removed
         Barriers_Removed(k,  mn,w, scenarios, rad_infl) = B.L(k) ;
*Financial value or actual amount spent in each scenario
         spent(mn,w, scenarios, rad_infl) = FINANCIAL.L       ;
*check the CR values- which reaches the model chooses to reconnect
         CR_upstream(mn,i,j,w, scenarios, rad_infl) = CR_up.L(i,j) ;
*economic loss in $ - objective 2.
         dam_economic_loss(mn,w, scenarios, rad_infl)= ECO_LOSS.L ;
*Quality weighted habitat - objective 1.
         quality_length(mn,w, scenarios, rad_infl) = QU.L  ;
 )

Display ObjFunc, Barriers_Removed, spent, CR_upstream,  dam_economic_loss  ;



*unload results into excel- note: I need multiple excel documents for space reasons
execute_unload "C:\Users\Maggi\Documents\WEBER\GAMS\1_Excel\Results.gdx", ObjFunc   ;
execute_unload  "C:\Users\Maggi\Documents\WEBER\GAMS\1_Excel\economicloss.gdx", dam_economic_loss  ;
execute_unload  "C:\Users\Maggi\Documents\WEBER\GAMS\1_Excel\reaches.gdx", CR_upstream  ;
execute_unload  "C:\Users\Maggi\Documents\WEBER\GAMS\1_Excel\quality_length.gdx", quality_length  ;
execute_unload "C:\Users\Maggi\Documents\WEBER\GAMS\1_Excel\barriers_removed.gdx", Barriers_Removed  ;
execute_unload "C:\Users\Maggi\Documents\WEBER\GAMS\1_Excel\spent.gdx",  spent         ;


Execute "gdxxrw.exe C:\Users\Maggi\Documents\WEBER\GAMS\1_Excel\barriers_removed.gdx O=C:\Users\Maggi\Documents\WEBER\GAMS\1_Excel\barriers_removed.xlsx filter=1 par=Barriers_Removed.l rng=Barriers_Removed!A1" ;

Execute "gdxxrw.exe C:\Users\Maggi\Documents\WEBER\GAMS\1_Excel\Results.gdx O=C:\Users\Maggi\Documents\WEBER\GAMS\1_Excel\Results.xlsx filter=1 par=ObjFunc.l rng=ObjFunc!A1" ;

Execute "gdxxrw.exe C:\Users\Maggi\Documents\WEBER\GAMS\1_Excel\quality_length.gdx O=C:\Users\Maggi\Documents\WEBER\GAMS\1_Excel\quality_length.xlsx filter=1 par=Quality_Length.l rng=quality_length!A1" ;

Execute "gdxxrw.exe C:\Users\Maggi\Documents\WEBER\GAMS\1_Excel\reaches.gdx O=C:\Users\Maggi\Documents\WEBER\GAMS\1_Excel\reaches.xlsx filter=1 par=CR_upstream.l rng=reach!A1" ;

Execute "gdxxrw.exe C:\Users\Maggi\Documents\WEBER\GAMS\1_Excel\economicloss.gdx O=C:\Users\Maggi\Documents\WEBER\GAMS\1_Excel\economicloss.xlsx filter=1 par=dam_economic_loss.l rng=economic_loss!A1" ;

Execute "gdxxrw.exe C:\Users\Maggi\Documents\WEBER\GAMS\1_Excel\spent.gdx O=C:\Users\Maggi\Documents\WEBER\GAMS\1_Excel\spent.xlsx filter=1 par=spent.l rng=spent!A1"   ;
