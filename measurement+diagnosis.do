///MEASUREMENT & DIAGNOSIS////

*COMPARING 2 MEASUREMENTS/////

*Example: use anklebp1.dta

codebook, compact

*quantify possible systematic/random differences between 2 measurements.

**PLOT MEASUREMENTS:
*gph_fig15_1.do
use anklebp1.dta, clear
twoway (scatter atp1 adp1) (function y=x, range(0 200) lpattern(1)), legend(on) 
> xtitle("Posterior tibial artery") ytitle("Dorsal pedal artery") ysize(2.2) 
> xsize(3) aspectratio(1) scale(1.4)

*gph_fig15_2.do

use anklebp1.dta, clear
gen diff = adp1-atp1
gen average = (adp1+atp1)/2

quietly: sum diff
local DIFMEAN = r(mean)
local PILOW = r(mean) - 1.96*r(sd)
local PIHIGH = r(mean) + 1.96*r(sd)

twoway(scatter diff average), ytitle("Difference") xtitle("Average") 
> yline(`DIFMEAN', lpattern(l)) yline(`PILOW' `PIHIGH', lpattern(dash)) 
> ylabel(-75(25)75) ysize(2.2) xsize(3.1) scale(1.4)
*notice wierd apostrophes included 
*PLOT: evaluate the difference between paired measurements; diff between 2 
//measurements plotted again their average in plot above. 
**3 horizontal lines represent mean difference and 95% prediction interval.

*is there tendency for mean diff to vary systematically w/ average?
//if so, may indicate a relative difference.
*does diff vary more w/ increasing average?
//would indicate that random disagreement is higher w/ high BP.
*systematic diffs between measurements?

***if yes, may be useful to log-transform data

///INSPECT OUTLIERS///

list if abs(adp-atp)>50

**check for normality w/ Q-Q plot or histogram 
qnorm diff, name(p1)
histogram diff, normal name(p2)
graph combine p1 p2
*patient 48 is clearly sticking out, but otherwise normal


////REPRODUCIBILITY OF RESULTS//////////

*Example: use anklebp2.dta
**ASSESS MEASUREMENT VARIATION to estimate size of random variation///

capture graph drop p1 p2
set scheme lean1
twoway                                           
  (scatter adp1 adp2)                            
  (function y=x, range(0 200) lpattern(l))       
  ,                                              
  legend(off)                                    
  xtitle("First measurement")                    
  ytitle("Second measurement")                   
  aspectratio(1) name(p1)

  ///
  
generate diff = adp1-adp2
generate average = (adp1+adp2)/2
quietly summarize diff
local DIFMEAN = r(mean)
local PILOW   = r(mean) - 1.96*r(sd)
local PIHIGH  = r(mean) + 1.96*r(sd)

///

twoway                                      
  (scatter diff average)                    
  ,                                         
  ytitle("Difference")                      
  xtitle("Average")                         
  yline(`DIFMEAN', lpattern(l))             
  yline(`PILOW' `PIHIGH', lpattern(dash)) 
  ylabel(-40(20)40)name(p2)
  
graph combine p1 p2, rows(1) xsize(5.5) ysize(2.2) iscale(1.4)
*LEFT: shows that 1st-2nd measurements are highly correclated
*RIGHT: looks like random variation across x-axis (good) 


///USING TESTS FOR DIAGNOSIS///

******DICHOTOMOUS TESTS***********

use ras.dta, clear
codebook, compact
tab2 renogram stenosis, column

bysort stenosis: ci renogram, binomial
*estimate sensitivity/specificity of renography in diagnosis
**sensitivity: 0.71; specificity: 1-0.098 = 0.9

bysort renogram: ci stenosis, binomial
*estimate pos/neg predictive values in patient pop

diagt stenosis renogram
*reports sensitivity/specificity estimates w confidence intervals

diagt stenosis renogram, prev(10%)
*how would test perform in pop with 10% prior risk of disease 
**pos predictive value decreased and neg value increased when applying test to 
**pop with lower risk of disease

*******CONTINUOUS TESTS**********

histogram crea, by(stenosis, col(1))
*distribution of crea among patients with/without stenosis
** as expected, creatinine levels are higher among ppl w stenosis

//CALCULATE CUMULATIVE DISTRIBUTIONS//

bysort stenosis : cumul crea, generate(cum) equal
replace cum = 1-cum if stenosis==1

set scheme lean1
twoway(line cum crea if stenosis==1, sort) (line cum crea if stenosis==0, sort),                                              
> legend(order(1 "Sensitivity" 2 "Specificity")) plotregion(margin(b=0 t=0))                    
> xsize(4) ysize(2.2) scale(1.4)
*sensitivity & specificity as funcitons of cutpoint

//ROC ANALYSIS: illustrate overall discriminatory potential of a continuous test
roctab stenosis crea, summary graph
*ROC area= probability that random true-pos person has a test value higher than
**random true-neg person.

label values creagrp
roctab stenosis creagrp, detail //includes table of test values  

///alternative///
*logistic regression followed by postestimation commands lroc and lsens 

