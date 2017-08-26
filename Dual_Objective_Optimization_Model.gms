$ontext
Maggi Kraft (8/2017)
squeezely44@gmail.com
Developed as part of my M.S. Thesis work at Utah State University

This code contains the code for the dual objective optimization model in the Weber River Basin but the model is generalizable to other stream networks. The goal of the model is to maximize quality-weighted fish habitat while minimizing  water scarcity costs.
The model is constrained by a budget for barrier removal. The weighted sum method is used to create the Pareto Optimal front between the tradeoffs.

-passability: used as a penalty to nudge the program to remove barriers that are less passable/ more of an impact
  To do this each barrier receives a score between 0 to 1 where 0 is fully passable and 1 is not. This way
  the barriers that are not passable keep their full distance. While passable barriers distance are reduced.
-Optimizing the node importance: The node importance is indexed (0-1) using the connectivity of quality weighted habitat. The index is the IIC(integral index of connectivity).
The IIC is calculated with and without the node present in the calculation to come up with the DIIC or node importance (0-1).
This was calculated for all the reaches using the weighted habitat quality for each month in the CONEFOR 26 program.

- currently I am looping through- 12 months and 13 is the average diic value for each barrier. Also different weights (w) for each objective. And finally each scenario
or budget level.

-economic costs (water scarcity) were calculated with the Ogden area economic loss curves (Null unpublished). The equation constructing the curves was used to estimate the cost of water with the dam
and without the dam. I used the average of previous months/years inflow/ outflow data for the dam. With the dam the flows are the outflow, without they are the inflow.

- Aquatic habitat is defined as the intersection between Discharge, water temperature, geomorphic condition, and gradient

Symbols:
i: Barriers in the network. The Barriers located above j (upstream of j)
j: Barriers in the network. The barriers located downstream from i
scenarios: These are the budget scenarios the model is looped through. The budget scenarios were defined in an excel spreadsheet
months:The model was ran at a monthly time scale. The month 13 is an average of all the months
weights: The weights cycled through the dual objective opimization model. These range between 0 and 1.

Import from excel (if it contains months it is at a monthly time scale)
distance: distance(h,j) Distance in km between each node(barrier)
cost: cost(j) cost of removing barrier j
penalty: penalty(j, months) The passabilty of the barrier. This is a penalty (.10-1) where easier passage means lower penalty (.10 is fully passable).
the penalty range low value of .10 allows those barriers to at least be worth something (they are in the water)
habitat: habitat(j, months) The habitat rating (0-1) for each reach. 1 is great habitat, .75 is Good habitat, .5 is fair habitat and .25 is poor.
if above a barrier contained multiple reaches due to river interesection, the habitat rating for the reaches was avaeraged.
diic(j, months): Each barriers degree of importance to habitat connectivity. Calculated from the Integral Index of Connectivity (Pascual-Hortal, L. & Saura, S. 2006)
economic_costs(j, months): The economic losses or water scarcity losses associated with each barrier (normalized)
dam_costs(j,months): The cost of removing each barrier not normalized
objweights(w): The weights to cycle through in the dual objective model
Rem_Budget(scenarios): The different removal budgets to loop through in the model

Binary Variables
B(j): remove barrier at location j (1 =remove 0=keep). Decision in the model
;

Variables
WEIGHT: obj. function weighted sum method
LENGTH: length of reach between nodes i and j. Objective function value
D: weighted distance
ACTLENGTH: the actual length (habitat suitability is not included)
QU: length of quality habitat without penalty
ECO: economic loss second objective function value
BUDGET: different budgets to run through
WT: the weights to cycle through
DIIC_VALUES: The node connectivity importances
T: test variable so I can see what is happening in stuff
DIIC_months(j:) The DIIC value for each month and barrier
ECO_months(j): The economic loss associated with each barrier and month (normalized as percent)
HABITAT_months(j): The quality weighted habitat for each node and month in km. (this is habitat classification * distance)
ECO_LOSS: the economic loss ($) of the dams removed (not normalized)
ECO_LOSS_months(j): Cost of removing barrier j

PARAMETERS
objective function output values
           ObjFunc(scenarios, months, w) Objective funcation values
           ecoObj(scenarios, months, w) the economic objective value for each scenario
           envObj(scenarios, months, w) the environmental objective value for each scenario
           Quality_Length(scenarios, months,w) the quality length of habitat (doesn't have penalty in the function.
           dam_economic_loss(scenarios, months, w) The total economic loss ($) to remove the dams
all the barriers removed
           Barriers_Removed(scenarios, j, months,w) Barriers removed in each scenario
Financial Parameters- how much it spent out of the budget available
          spent(scenarios, months,w) how much was spent in each scenario
DIIC values
           diic_values_j(scenarios, months, w) the node connectivity importances
Ouput of the actual length
           Actual_Length(scenarios, months, w) The actual length output for each scenario



;



$offtext

$offlisting
SETS
i barrier locations at i(upstream) The Barriers in the stream network.
/1121,1120,1119,1118,1116,1107,1106,1105,1103,1102,1101,1099,1098,1097,1096,1095,1091,1090,1082,1081,1080,1078,1077,1076,1075,1070,1064,1060,1058,1057,1054,1052,1050,1049,1048,1046,1044,1040,1039,1038,1037,1035,1034,1032,1030,1029,1027,1025,1023,1022,1021,1020,1019,1018,1015,1014,1013,1012,1011,1010,1009,1007,1006,1005,1003,1002,1000,999,998,997,
995,994,993,992,991,988,987,986,985,983,981,980,979,978,977,976,975,974,973,971,970,969,967,966,965,964,963,962,961,959,958,957,955,954,953,952,951,948,947,946,945,943,942,940,939,938,934,933,931,930,929,928,927,926,925,924,923,921,920,919,917,915,914,913,912,911,910,907,906,905,904,902,901,893,892,890,886,883,882,881,880,876,871,869,867,866,865,864,861,859,858,857,856,855,854,853,851,849,
848,847,846,845,843,842,841,840,838,837,836,835,832,831,830,829,828,827,824,823,822,821,820,819,818,817,816,815,814,813,812,811,809,807,806,805,804,803,802,801,800,799,798,797,796,795,794,793,792,791,790,789,788,787,785,784,782,779,778,777,776,775,774,773,770,769,766,765,763,762,761,760,759,758,757,756,755,754,752,750,746,744,743,742,738,735,734,733,732,730,728,725,723,722,721,720,719,713,
712,711,710,708,707,706,704,703,702,701,700,698,697,695,694,693,691,690,689,687,686,683,681,680,678,674,673,672,671,669,668,666,664,663,662,656,650,647,645,643,641,639,636,634,632,628,625,624,617,616,615,614,611,608,602,601,600,597,596,595,593,592,590,589,588,587,585,581,577,576,574,573,572,571,570,568,567,566,564,562,560,559/

* noeconomic loss dams (Turn this on and the above set off if economic loss barriers are not included in the model)
*/1121,1120,1119,1118,1116,1107,1106,1105,1103,1102,1101,1099,1098,1097,1096,1095,1091,1090,1082,1081,1080,1078,1077,1076,1075,1070,1060,1058,1057,1054,1052,1050,1049,1048,1046,1044,1040,1039,1038,1037,1035,1034,1032,1030,1029,1027,1025,1023,1022,1021,1020,1019,1018,1015,1014,1013,1012,1011,1010,1009,1007,1006,1005,1003,1002,1000,999,998,997,
*995,994,993,992,991,988,987,986,985,983,981,980,979,978,977,976,975,974,973,971,970,969,967,965,964,963,962,961,959,958,957,955,954,953,952,951,948,947,946,945,943,942,940,939,938,934,933,931,930,929,928,927,926,925,924,923,921,920,919,917,915,914,913,911,910,907,906,905,902,901,893,892,890,886,883,882,880,876,871,869,867,866,865,864,861,859,858,857,856,855,854,853,851,849,
*848,847,846,845,843,842,841,840,838,837,836,835,832,831,830,829,828,827,824,823,822,821,820,819,818,817,816,815,814,813,812,811,809,807,806,805,804,803,802,801,800,799,798,797,796,795,794,793,792,791,790,789,788,787,785,784,782,779,778,777,776,775,774,773,770,769,766,765,763,762,761,760,759,758,757,756,755,754,752,750,746,744,743,742,738,734,733,732,730,728,725,722,721,720,719,713,
*712,711,710,708,707,706,704,703,702,701,700,698,697,695,694,693,691,690,689,687,686,681,680,678,674,673,672,671,669,668,666,664,663,662,656,650,647,645,643,641,639,636,634,632,628,625,617,616,615,614,611,608,602,601,600,597,596,595,593,592,590,589,588,587,585,581,577,576,574,573,572,571,570,568,567,566,562,560,559/


h upstream segments from barrier j (upstream from j) These are the stream segments or reaches above the barrier. This is to define the distances of the stream reach
/2805,2826,2849,2875,2901,2927,2954,2979,3113,3086,3032,3059,3329,3238,3236,3005,3328,3353,3331,3324,3325,3326,3139,3323,3239,3330,3312,3313,3316,3314,3315,3317,3357,3166,3309,3310,3311,3318,3308,3193,3307,3306,3305,3302,3301,3244,3243,3240,3241,3242,3245,3336,3246,3248,2852,2879,2906,2933,3126,3247,3343,3345,3347,3349,3220,3249,3250,3251,3252,3280,3281,3282,3286,3287,3293,3294,3296,3297,
3298,3299,3303,3304,3319,3295,3327,3300,3288,3273,3289,3290,2828,2806,3351,3291,2811,3209,3237,3264,3292,3320,2821,3153,3181,3342,2807,3350,3352,2820,2819,3348,2810,2808,3363,3364,3344,3346,2809,3284,3285,3283,3355,2817,2818,2822,2812,2813,2814,2816,2823,3332,3359,3358,3354,2815,2832,2833,3360,2911,2912,3014,3042,3098,3253,2824,2831,2827,3254,3255,3256,3257,3258,2913,2825,2829,2830,2834,2914,2915,
2835,2916,2917,2918,3070,2836,2837,2921,2972,2920,2919,2838,2839,2840,2841,2843,2844,3361,3341,3259,2842,2847,2848,2850,3366,3362,3260,3274,3275,3276,3277,3278,3279,3261,3266,3267,3268,3269,3270,3271,3272,2845,3337,3262,3263,3265,3365,2869,2846,2851,2853,2857,2868,2856,3322,2867,2877,2878,2876,2874,2855,2854,2880,2881,2873,2866,2863,2862,2872,2861,2910,2858,2859,2864,2865,2870,2871,2882,2860,2891,
2890,2889,2909,2892,2908,2907,2893,2888,2905,2904,2903,2902,2900,2899,2898,2922,2973,2897,2896,2895,2894,2886,2887,2883,2885,2884,2923,2924,2974,3137,3136,3138,3135,3140,3134,2975,2925,2926,2985,3133,2928,2929,2930,2941,3367,2938,3132,2976,2977,2978,2984,2937,3141,3143,3142,3129,2983,2942,3130,2982,3128,2931,2981,3131,2980,2943,2944,2936,2935,2932,2934,2939,2986,2987,3023,2940,2945,2946,2947,2948,
3125,3123,3124,3127,3024,3025,3028,3029,3030,3031,3033,3110,2953,3122,2949,2950,2955,2988,2951,2952,3146,2956,3147,3148,3150,3111,3145,3144,2957,3120,3121,3339,2958,2959,2961,2962,2963,2964,2969,2970,2971,2965,2966,2967,2968,3112,3119,3114,3117,3118,3116,3115,2989,3026,2990,2960,3151,3027,3034,3152,3149,3154,3155,3156,3225,3035,3157,3036,2991,2992,2993,2997,3158,2998,3037,3159,2994,2995,3338,2996,3226,
2999,3227,3038,3039,3040,3041,3045,3160,3161,3000,3001,3044,3356,3043,3162,3002,3046,3057,3058,3163,3164,3228,3003,3165,3229,3230,3231,3232,3233,3234,3235,3167,3047,3060,3061,3069,3004,3048,3049,3050,3062,3006,3063,3168,3169,3214,3064,3065,3051,3055,3007,3066,3052,3053,3054,3071,3215,3217,3221,3222,3223,3072,3067,3008,3073,3216,3074,3218,3009,3010,3013,3015,3016,3219,3017,3075,3018,3340,3076,3019,3170,
3171,3197,3077,3224,3011,3078,3068,3012,3172,3020,3079,3198,3056,3080,3021,3199,3200,3201,3081,3082,3083,3099,3022,3084,3173,3174,3175,3176,3177,3178,3184,3185,3188,3192,3196,3189,3194,3085,3087,3090,3091,3094,3202,3203,3204,3205,3335,3333,3334,3095,3096,3097,3207,3206,3208,3210,3211,3213,3092,3212,3100,3101,3105,3321,3093,3109,3102,3108,3106,3107,3179,3180,3182,3183,3089,3103,3088,3195,3104,3187,3186,3190,3191
/

j barrier locations at j (downstream from i)
/1121,1120,1119,1118,1116,1107,1106,1105,1103,1102,1101,1099,1098,1097,1096,1095,1091,1090,1082,1081,1080,1078,1077,1076,1075,1070,1064,1060,1058,1057,1054,1052,1050,1049,1048,1046,1044,1040,1039,1038,1037,1035,1034,1032,1030,1029,1027,1025,1023,1022,1021,1020,1019,1018,1015,1014,1013,1012,1011,1010,1009,1007,1006,1005,1003,1002,1000,999,998,997,
995,994,993,992,991,988,987,986,985,983,981,980,979,978,977,976,975,974,973,971,970,969,967,966,965,964,963,962,961,959,958,957,955,954,953,952,951,948,947,946,945,943,942,940,939,938,934,933,931,930,929,928,927,926,925,924,923,921,920,919,917,915,914,913,912,911,910,907,906,905,904,902,901,893,892,890,886,883,882,881,880,876,871,869,867,866,865,864,861,859,858,857,856,855,854,853,851,849,
848,847,846,845,843,842,841,840,838,837,836,835,832,831,830,829,828,827,824,823,822,821,820,819,818,817,816,815,814,813,812,811,809,807,806,805,804,803,802,801,800,799,798,797,796,795,794,793,792,791,790,789,788,787,785,784,782,779,778,777,776,775,774,773,770,769,766,765,763,762,761,760,759,758,757,756,755,754,752,750,746,744,743,742,738,735,734,733,732,730,728,725,723,722,721,720,719,713,
712,711,710,708,707,706,704,703,702,701,700,698,697,695,694,693,691,690,689,687,686,683,681,680,678,674,673,672,671,669,668,666,664,663,662,656,650,647,645,643,641,639,636,634,632,628,625,624,617,616,615,614,611,608,602,601,600,597,596,595,593,592,590,589,588,587,585,581,577,576,574,573,572,571,570,568,567,566,564,562,560/

*no economic loss dams (Turn this on and the above set off if economic loss barriers are not included in the model)
*/1121,1120,1119,1118,1116,1107,1106,1105,1103,1102,1101,1099,1098,1097,1096,1095,1091,1090,1082,1081,1080,1078,1077,1076,1075,1070,1060,1058,1057,1054,1052,1050,1049,1048,1046,1044,1040,1039,1038,1037,1035,1034,1032,1030,1029,1027,1025,1023,1022,1021,1020,1019,1018,1015,1014,1013,1012,1011,1010,1009,1007,1006,1005,1003,1002,1000,999,998,997,
*995,994,993,992,991,988,987,986,985,983,981,980,979,978,977,976,975,974,973,971,970,969,967,965,964,963,962,961,959,958,957,955,954,953,952,951,948,947,946,945,943,942,940,939,938,934,933,931,930,929,928,927,926,925,924,923,921,920,919,917,915,914,913,911,910,907,906,905,902,901,893,892,890,886,883,882,880,876,871,869,867,866,865,864,861,859,858,857,856,855,854,853,851,849,
*848,847,846,845,843,842,841,840,838,837,836,835,832,831,830,829,828,827,824,823,822,821,820,819,818,817,816,815,814,813,812,811,809,807,806,805,804,803,802,801,800,799,798,797,796,795,794,793,792,791,790,789,788,787,785,784,782,779,778,777,776,775,774,773,770,769,766,765,763,762,761,760,759,758,757,756,755,754,752,750,746,744,743,742,738,734,733,732,730,728,725,722,721,720,719,713,
*712,711,710,708,707,706,704,703,702,701,700,698,697,695,694,693,691,690,689,687,686,681,680,678,674,673,672,671,669,668,666,664,663,662,656,650,647,645,643,641,639,636,634,632,628,625,617,616,615,614,611,608,602,601,600,597,596,595,593,592,590,589,588,587,585,581,577,576,574,573,572,571,570,568,567,566,562,560,559/

scenarios Budget and month Scenarios to loop through /S1*S41/


months The months to model each scenario where 13 is the average of all the months /1*13/

w the weights to cycle through each scenario and month /w1*w50/

                  ;

********************************************
*Import from excel (if it contains months it is at a monthly time scale)
*distance: distance(h,j) Distance in km between each node(barrier)
*cost: cost(j) cost of removing barrier j
*penalty: penalty(j, months) The passabilty of the barrier. This is a penalty (.10-1) where easier passage means lower penalty (.10 is fully passable).
* the penalty range low value of .10 allows those barriers to at least be worth something (they are in the water)
*habitat: habitat(j, months) The habitat rating (0-1) for each reach. 1 is great habitat, .75 is Good habitat, .5 is fair habitat and .25 is poor.
* if above a barrier contained multiple reaches due to river interesection, the habitat rating for the reaches was avaeraged.
*diic(j, months): Each barriers degree of importance to habitat connectivity. Calculated from the Integral Index of Connectivity (Pascual-Hortal, L. & Saura, S. 2006)
*economic_costs(j, months): The economic losses or water scarcity losses associated with each barrier (normalized)
*dam_costs(j,months): The cost of removing each barrier not normalized
*objweights(w): The weights to cycle through in the dual objective model
*Rem_Budget(scenarios): The different removal budgets to loop through in the model
*

$CALL gdxxrw.exe I=C:\Users\Maggi\Documents\WEBER\GAMS\1_Excel\INPUT.xlsx O=C:\Users\Maggi\Documents\WEBER\GAMS\2_GDX\INPUT.gdx par=distance rng=distance!A1:MK564 Rdim=1 Cdim=1  par=cost rng=cost!A1:B348 Rdim=1 par=diic rng=diic!A1:N349 Rdim=1 Cdim=1  par=penalty rng=penalty!A1:B348 Rdim=1 par=habitat rng=habitat!A1:N349 Rdim=1 Cdim=1  par=economic_costs rng=economic!A1:N349 Rdim=1 Cdim=1   par=objweights rng=weights!A1:B50 Rdim=1 par=Rem_Budget rng=budget!A1:B41 Rdim=1  par=dam_costs rng=economic_cost!A1:N349 Rdim=1 Cdim=1
;
*change all the parameters to include the month?
Parameter distance(h,j)  ;
parameter cost(j)  ;
Parameter penalty(j);
parameter habitat(j, months);
parameter diic(j, months)
Parameter economic_costs(j, months)  ;
Parameter dam_costs(j, months);
Parameter objweights(w)  ;
Parameter Rem_Budget(scenarios);
$GDXIN C:\Users\Maggi\Documents\WEBER\GAMS\2_GDX\INPUT.gdx
$LOAD distance
$LOAD cost
$LOAD penalty
$LOAD habitat
$LOAD diic
$LOAD economic_costs
$LOAD objweights
$LOAD Rem_Budget
$LOAD dam_costs
$GDXIN

display habitat
       ;
*********************
*Variables

Binary Variables
B(j) remove barrier at location j (1 =remove 0=keep)
;

$offlisting
Variables
WEIGHT obj. function weighted
LENGTH length of super reach between nodes i and j. Objective function value
D weighted distance
ACTLENGTH the actual length
QU length of quality habitat without penalty
ECO economic loss- second objective function value
BUDGET different budgets to run through
WT the weights to cycle through
DIIC_VALUES The node connectivity importances
T test variable so I can see what is happening in stuff
DIIC_months(j) The DIIC value for each month and node
ECO_months(j) The economic loss associated with each node and month (normalized)
HABITAT_months(j) The quality weighted habitat for each node and month in km. (this is habitat classification * distance)
ECO_LOSS the economic loss ($) of the dams removed
ECO_LOSS_months(j)Barrier removal costs in the loop
*COST_sensitivity(j) sensitivity analysis with the costs
;

***************************
*Looping Parameters for looping different budget/constraint scenarios
PARAMETERS
*objective function output values
           ObjFunc(scenarios, months, w) Objective funcation values (habitat)
           ecoObj(scenarios, months, w) the economic objective value for each scenario
           envObj(scenarios, months, w) the environmental objective value for each scenario
           Quality_Length(scenarios, months,w) the quality length of habitat (doesn't have penalty in the function.
           dam_economic_loss(scenarios, months, w) The total economic loss ($) to remove the dams
*all the barriers removed
           Barriers_Removed(scenarios, j, months,w) Barriers removed in each scenario
*Financial Parameters- how much it spent out of the budget available
           spent(scenarios, months,w) how much was spent in each scenario
*DIIC values
           diic_values_j(scenarios, months, w) the node connectivity importances
*Ouput of the actual length
           Actual_Length(scenarios, months, w) The actual length output for each scenario


;

*double check that my loop works
Display Rem_Budget
;

********************************
Equations
WEIGHTED weighted objectives. This is what is being optimized.
maxLENGTH first objective function value
minEco Objective 2 minimize economic loss
Financial Fininancial budget constraint
*weightD(h,j) weighted distance with passability (this really slows the processing time)
acLength actual length of opened river
qual quality habitat without passability aka the penalty in it
con_index index of connectivity
economic_loss The $ amount of economic loss
*constrain_num_B constrain the number of barriers removed don't actually  need to run

;
* There are three different weighted objective functions I can run through. The first is the primary one where I didn't include any changes to the input and it was used to create my final results.
* The next two WEIGHTED equations are used for a sensitivity analysis. One includes quality weighted habitat without the connectivity index (HABITAT_months.L(j))
* One WEIGHTED equation doesn't include the penalty(j). This is the barrier passability.
WEIGHTED..         WEIGHT =E= (1-WT.L)*SUM((j), penalty(j)*B(j)*DIIC_months.L(j))- (WT.L * SUM((j), ECO_months.L(j)*B(j))) ;
*WEIGHTED..         WEIGHT =E= (1-WT.L)*SUM((j), penalty(j)*B(j)*HABITAT_months.L(j))- (WT.L * SUM((j), ECO_months.L(j)*B(j))) ;
*WEIGHTED..         WEIGHT =E= (1-WT.L)*SUM((j), B(j)*DIIC_months.L(j))- (WT.L * SUM((j), ECO_months.L(j)*B(j))) ;

* the environmental objective half of the equation
maxLENGTH..        LENGTH =E= SUM((j), penalty(j)*B(j)*DIIC_months.L(j)) ;
* the economic half of the equation
minEco..           ECO =E= Sum((j), ECO_months.L(j)*B(j)) ;
*****************
* constraints and equations to look at output
*****************
*the connectivity index associated with the barrier, j chosen for removal
con_index..                DIIC_VALUES =E= sum((j), B(j)*DIIC_months.L(j));
* The budget spent on barrier removal
Financial..                BUDGET.L =G= SUM((j),  cost(j)*B(j));
*weightD(h,j)..             D(h,j) =E= distance(h,j)* penalty(j)*habitat(h,j)  ;

*this is really gain rather tha actual length: it doesn't account for below the barrier removed
acLength..                 ACTLENGTH =E= sum((h,j), distance(h,j)*B(j));
* The sum of quality habitat gained above the barrier
qual..                     QU =E=sum((j), HABITAT_months.L(j) * B(j));
* The sum of economic loss associated with the removed barriers
economic_loss..            ECO_LOSS =E= sum((j), ECO_LOSS_months.L(j)* B(j));
*constrain_num_B..          1 =G= sum(j, B(j))  ;
;

**************************
*LOOP and SOLVE MAGIC
************************
*need to establish an alias for months because it shows up in the objective function. Also, all the loops should be mn so it loops throught he months (I think)
ALIAS(months, mn);

*To loop and record each output- the output variable needs to be included like I have done for spent, barriers, and obj function
MODEL Reach /All/
Loop((scenarios,w, mn),
*change to Loop((scenarios,months),
         BUDGET.L = Rem_Budget(scenarios)   ;
         WT.L = objweights(w) ;
         DIIC_months.L(j) = DIIC(j, mn)  ;
         ECO_months.L(j) = economic_costs(j, mn)  ;
         Habitat_months.L(j)=habitat(j, mn);
         ECO_LOSS_months.L(j)=dam_costs(j,mn);


         SOLVE Reach USING MIP MAXIMIZING WEIGHT  ;
*objfunction value saved for each scenario- objective 1. The quality weighted habitat
         ObjFunc(scenarios, mn,w) = WEIGHT.L;
*economic loss obj
         ecoObj(scenarios,  mn,w) = ECO.L  ;
*each barriers value
*         ecoObj_j(scenarios,j) = ECO_j.L(j)
*environmentalal obj
         envObj(scenarios,  mn,w) = LENGTH.L        ;
*Decisions- which barriers are removed
         Barriers_Removed(scenarios, j,  mn, w) = B.L(j) ;
*Financial value or actual amount spent in each scenario
         spent(scenarios,  mn,w) = FINANCIAL.L       ;
*The actual length of the reaches
         actual_length(scenarios, mn, w) = ACTLENGTH.L ;
*Quality weighted habitat
         quality_length(scenarios, mn, w) = QU.L  ;
*economic loss in $
         dam_economic_loss(scenarios, mn, w)= ECO_LOSS.L ;
*DIIC
         diic_values_j(scenarios, mn, w) = DIIC_VALUES.L
 )


Display   ObjFunc, Barriers_Removed, envObj, spent ;

*unload results into excel- I need multiple excel documents for space reasons
execute_unload "C:\Users\Maggi\Documents\WEBER\GAMS\1_Excel\Results.gdx", ObjFunc, ecoObj, envObj, dam_economic_loss, Quality_Length ;
execute_unload  "C:\Users\Maggi\Documents\WEBER\GAMS\1_Excel\economicloss.gdx", dam_economic_loss  ;
execute_unload  "C:\Users\Maggi\Documents\WEBER\GAMS\1_Excel\qualitylength.gdx", Quality_Length ;
execute_unload "C:\Users\Maggi\Documents\WEBER\GAMS\1_Excel\barriers_removed.gdx", Barriers_Removed  ;
execute_unload "C:\Users\Maggi\Documents\WEBER\GAMS\1_Excel\spent.gdx",  spent         ;
execute_unload "C:\Users\Maggi\Documents\WEBER\GAMS\1_Excel\otherstuff.gdx", diic_values_j, actual_length;

Execute "gdxxrw.exe C:\Users\Maggi\Documents\WEBER\GAMS\1_Excel\barriers_removed.gdx O=C:\Users\Maggi\Documents\WEBER\GAMS\1_Excel\barriers_removed.xlsx filter=1 par=Barriers_Removed.l rng=Barriers_Removed!A1" ;

Execute "gdxxrw.exe C:\Users\Maggi\Documents\WEBER\GAMS\1_Excel\Results.gdx O=C:\Users\Maggi\Documents\WEBER\GAMS\1_Excel\Results.xlsx filter=1 par=ObjFunc.l rng=ObjFunc!A1" ;
Execute "gdxxrw.exe C:\Users\Maggi\Documents\WEBER\GAMS\1_Excel\Results.gdx O=C:\Users\Maggi\Documents\WEBER\GAMS\1_Excel\Results.xlsx filter=1 par=ecoObj.l rng=ecoObj!A1" ;
Execute "gdxxrw.exe C:\Users\Maggi\Documents\WEBER\GAMS\1_Excel\Results.gdx O=C:\Users\Maggi\Documents\WEBER\GAMS\1_Excel\Results.xlsx filter=1 par=envobj.l rng=envobj!A1" ;
Execute "gdxxrw.exe C:\Users\Maggi\Documents\WEBER\GAMS\1_Excel\Results.gdx O=C:\Users\Maggi\Documents\WEBER\GAMS\1_Excel\Results.xlsx filter=1 par=Quality_Length.l rng=quality_length!A1" ;
Execute "gdxxrw.exe C:\Users\Maggi\Documents\WEBER\GAMS\1_Excel\Results.gdx O=C:\Users\Maggi\Documents\WEBER\GAMS\1_Excel\Results.xlsx filter=1 par=dam_economic_loss.l rng=economic_loss!A1" ;

Execute "gdxxrw.exe C:\Users\Maggi\Documents\WEBER\GAMS\1_Excel\qualitylength.gdx O=C:\Users\Maggi\Documents\WEBER\GAMS\1_Excel\qualitylength.xlsx filter=1 par=Quality_Length.l rng=quality_length!A1" ;

Execute "gdxxrw.exe C:\Users\Maggi\Documents\WEBER\GAMS\1_Excel\economicloss.gdx O=C:\Users\Maggi\Documents\WEBER\GAMS\1_Excel\economicloss.xlsx filter=1 par=dam_economic_loss.l rng=economic_loss!A1" ;

*Execute "gdxxrw.exe C:\Users\Maggi\Documents\WEBER\GAMS\1_Excel\finance.gdx O=C:\Users\Maggi\Documents\WEBER\GAMS\1_Excel\finance.xlsx filter=1 par=Rem_Budget.l rng=Rem_Budget!A1" ;
Execute "gdxxrw.exe C:\Users\Maggi\Documents\WEBER\GAMS\1_Excel\spent.gdx O=C:\Users\Maggi\Documents\WEBER\GAMS\1_Excel\spent.xlsx filter=1 par=spent.l rng=spent!A1"   ;

Execute "gdxxrw.exe C:\Users\Maggi\Documents\WEBER\GAMS\1_Excel\otherstuff.gdx O=C:\Users\Maggi\Documents\WEBER\GAMS\1_Excel\otherstuff.xlsx par=diic_values_j.l rng=diic_values!A1" ;
Execute "gdxxrw.exe C:\Users\Maggi\Documents\WEBER\GAMS\1_Excel\otherstuff.gdx O=C:\Users\Maggi\Documents\WEBER\GAMS\1_Excel\otherstuff.xlsx par=actual_length.l rng=actual_length!A1" ;
 ;



