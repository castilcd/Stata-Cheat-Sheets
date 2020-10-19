//use help functions to find funcitons

//STATISTICAL FUNCTIONS///

display chi2tail(df,chi2) chi2tail(1,3.84)=0.05

//ANOVA//
oneway bwt race, tab //compares 2+ means
*Bartlett's test = compares variances of groups

//ONE-WAY ANOVA: 

*example: assess level of measurement variation between observations of BP.
//requires data to be long-shaped.
use anklebp2.dta, clear
reshape long adp, i(id) j(measmnt)
list in 1/6, sepby(id)

//ESTIMATE WITHIN- AND BETWEEN-INDIVIDUAL VARIATION OF MEASUREMENTS.
loneway adp id


//T-TEST//
ttest VAR1, by(VAR2) //compares 2 groups; equal variances assumed
ttest VAR1, by(VAR2) unequal // variances unequal
ttest VAR1a==VAR1b //paired comparison of 2 Vars
ttest VAR1diff==0 //one sample t test
*example:
 ttest bwt, by(smoke) //avg BW by smokers & non
 *Output: difference between the means, 95% CI, middle p-val = result of 2 sided
 **test; smaller of the 2 others = result of 1 sided test. 
 
 //PAIRED TTEST//
*use anklebp data
ttest adp1==atp1
* the diff (adp-atp) has a mean -1.3... mean diff is small and non significant
// p=0.34
**SD is quite large (random variation): ref interval of (-1.3+/-1.96 x 13.6)


 //VARIANCE EQUALITY TEST//
 sdtest bwt, by(smoke) //if middle p-val >0.05 then variances are equal and use 
		//ordinary t-test; this accomplishes the same thing as Bartlett's test
sdpair VAR1a Var1b //paired comparison of the SDs of 2 vars

//NON-PARAMETRIC TESTS: go to HELP -> SEARCH; then type NONPARAMETRIC

//CONFIDENCE INTERVAL//
ttest bwt, by(smoke) level(99) //specifies 99% confindence interval
ci VAR, level(99) //calculates confidence int for the mean of VAR
ci VAR, binomial //estimate a proportion (must be coded 0/1) 

//IMMEDIATE COMMANDS// ... THESE END IN i
tabi 4 10 \ 7 3, chi2 exact //quick table with 4 values top row\bottom row 
*shows Pearson chi-sq and Fisher's exact tests
iri 17 23 231.5 196.4 // incidence ratio: exposed/unexposed vs cases/person-time
csi 7 12 19 21 //risk ratio: exposed/unexposed vs cases/noncases 
ttesti 32 1.35 .27 50 1.77 .33 //ttest: input # of obs, mean, SD for each VAR

