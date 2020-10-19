//STRATIFIED ANALYSIS
help epitab //table for epidemiologists
*NOTE: in cc and cs, unexposed non-cases must be coded 0


///COHORT STUDY///
cs VAR1 VAR2 ///RISK RATIO AND DIFFERENCE

//example: use neonatal.dta
codebook, compact
tab1 bmi

*computed obese dummy var

cs died obese //study risk of perinatal death in relation to maternal obesity
*divide number in RISK col by 1000 to get overall risk of being in each row
//# per 1,000 events
***RISK RATIO = relative risk estimate 
****Attr. frac. ex. = among exposed, the % of cases that could have been avoided
//if they were not exposed.
*** Attr. frec. pop = proportion of cases that would have been avoided if the
//exposed were all not exposed. 
**decimals should all de interpreted as %s

table died obese, by(parity) row col //stratify by parity
cs died obese, by(parity) 
*shows test of homogeneity between the categories in (parity)
**if significant, then cats are significantly different and would be evidence of
//effect modification



//INCIDENCE-RATE DATA//////
//example: use compliance2.dta

*compute variable = each individual's time at risk in person-years
gen pyr = (enddate-randate)/365.25
label variable pyr "Person-years"
ir died particip pyr, by(ranagr)

*Crude = crude incidence rate ratio estimate
*M-H combined = adjusted estimate for ranagr (somewhat reduced in example) 
**test of homogeneity shows that theres no diff in in association by age (i.e.
//effect modification or interaction) 

*if survival data:
stir particip, by(ranagr) //same analysis as above

//CASE-CONTROL DATA/////
*calculates approx relative risk using the Odds-ratio estimate

//example: use lbw1.dta

cc low smoke //crude analysis of asociation without stratification
*OR = crude association 
**attributable fraction among the exposed: among exposed, 51% of cases could
//have been avoided in absence of the exposure
**attributable fraction among the population: in absesnce of the exposure, 26% 
 //of all cases would have been avoided, provided that association is causal
 
table low smoke, by(race) row col stubwidth(15) //inspect race as confounder
cc low smoke, by(race) 
*Crude = odds ratio without stratification
*M-H comb = with stratification; and tests whether its significantly diff from 1
//at the bottom  
*test of homogeneity = refers to hypothesis that categories represent a common 
//odds ratio (question of interaction or effect modification) 

//can only stratify by 1 var, but can compute combinations of variables to use
egen htrace = group(ht race), label //compute variable with value for each comb-
//ination of the categories
tab1 htrace

cc low smoke, by(htrace) //since some cateogies provide very little info,
//logistic regression is preferable to calc odds ratios
logistic low smoke ht i.race


///MULTIPLE EXPOSURE LEVELS///
*study effect of multiple exposure levels in case-control study
//example: use esoph.dta

 tabodds case alcohol, or
 *or= displays odds ratios, otherwise absolute odds default
 **tests of homogeneity/trends refer to diffs in risk between exposure levels
 tabodds case alcohol, adjust(tobacco) base(2) 
 *stratified by tobacco, with exposure group 2 as reference 
 
 ///MATCHED CASE-CONTROL DATA////
 *Example: use lowbirth.dta
 
 keep pairid low smoke //keep subset of dataset
 list in 1/6, sepby(pairid) //lists obs 1-6 by pairid for each variable
 *note: originally in long format where each case is on top of its pair
 
 reshape wide smoke, i(pairid) j(low) //change to wide format, based on pairid
 list in 1/3 //list first 3 obs for eachvariable
 *where smoke0 = info on exposure of control 
 *smoke1 = info on exposure of case
 mcc smoke1 smoke0 //performs mcnemar's test for matched pairs 
 *odds ratio most informative = 22/8= 2.75
 
 
 


 
 




