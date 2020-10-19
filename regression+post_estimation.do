//LINEAR REGRESSION///////

//example: use lbw1.dta
// regresison equation: bwt = B0 + (B1 x lwt) + error

reg bwt lwt //linear regression

quietly reg bwt lwt age //runs regression with no output
cisd //shows confidence interval (must be preceded by reg command)
*shows CI aorund the standard dev of the error term (Root MSE) 

twoway (scatter bwt lwt) (lfit bwt lwt) //scatter plot of bwt(y) & lwt(x) with 
// regression line

reg bwt lwt age //MULTIPLE REGRESSION


//POST-ESTIMATION COMMANDS////////

quietly: reg bwt lwt age //runs regression w/out output

predict rbwt if e(sample), residual //generates new variable (rbwt) conatining 
//residuals 

histogram rbwt, normal name(p1) //histogram of residuals around bwt
qnorm rbwt, name(p2) //Q-Q plot of residuals
graph combine p1 p2 // presents both side by side

//more diagnostic plots//

**residual plots**
rvfplot, name(p3) yline(0) //fitted values(x) vs residuals(y)
rvpplot lwt, name(p4) yline(0) // lwt vs residuals
rvpplot age, name(p5) yline(0) // age vs residuals
lvr2plot, name(p6) // leverage vs residual plot 
graph combine p3 p4 p5 p6 //displays all 4 graphs at once
* if only minor deviations from expected, then we can assume reg model is valid.

lincom _cons + lwt*125 + age*25 //calculates linear combinations of parameters
**ex: expected bwt of child born to 25 yr old woman weighing 125 lb. 

lincom _cons + lwt*125 + age*25 - 3000 //test the hypothesis that the expected 
//bwt is 3000

lincom lwt*15 + age*7 // estimate diff between 2 babies: lwt of one mother being
//15 more and age being 7 years older than other.

//CATEGORICAL VARIABLES////

list race i.race in 1/3 //list first 3 observations of each categoties of race

reg bwt i.race lwt //use lowest category as default reference for race
reg bwt b2.race lwt //uses 2nd category as reference for race
reg bwt bn.race lwt, noconstant //shows no base level for race; needs noconstant

fvset base 2 race //sets 2nd category as base from then on
fvset report //tells you what the base category is set to
fvset clear race //resets to default 

set showbaselevels on, permanently //displays a line for base levels in output

gen lwt130 = lwt-130 //centered lwt at 130 to have sensible interpretation of
//the constant (_cons) in the model

 reg bwt b2.race lwt130 //predict bwt with race ref being cat 2 and lwt centered
 //at 130
 lincom 1.race - 3.race //calculate difference between coefficients of cat 1 & 2
 
 testparm i.race //test hypothesis of no overall difference between categories
 
 reg bwt bn.race lwt130, noconstant //bn= no reference
lincom 1.race - 2.race //calculate diff between cats 1 & 2

testparm i.race, equal //test hypothesis of no diff btween lines corresponding
//to each category of race
*without the equal option in regressions w/ noconstant: tests hypothesis that 
//all lines = 0 (meaningless)

//////////INTERACTIONS IN REGRESSION////////////////

reg bwt b2.race c.lwt130 b2.race#c.lwt130 
*b2 = base is cat 2
*c. = specifies lwt130 as a continuous predictor
*# = interaction between 2 vars
reg bwt b2.race##c.lwt130 //alternative 
**example: for women weighing 130lb, expected bwt = 414g higher for whites than
//blacks.
**estimated slope (grams per lb) for blacks = 2.43
**for whites = 2.43 + 2.56 = 4.99
lincom lwt130 + 1.race#c.lwt130 //calculate slope for cat 1 of race

testparm i.race#c.lwt130 //test hypothesis of no interaction

reg bwt bn.race bn.race#c.lwt130, noconstant //see equations for all categories
**Ex: line for white would be 4.99*(lwt-130) + 3092
lincom 1.race#c.lwt130 - 2.race#c.lwt130 //calc difference between the 2 slopes
testparm i.race#c.lwt130, equal //test hypothesis that all lines are parallel

****INTERACTION BTWEEN 2 CATEGORICAL VARS*********

tab2 smoke race //6 categories of women

reg bwt lwt130 b0.smoke#b2.race //is bwt different for the 6 groups? 
testparm i.smoke#i.race //overall, is there a diff btween these groups?

reg bwt lwt130 bn.smoke#bn.race, noconstant //run reg without ref categories
testparm i.smoke#i.race, equal //test of equal bwt (at a given level of lwt130)
//for all regression lines


reg bwt lwt130 b0.smoke##b2.race //is there evidence of an interaction?
testparm i.smoke#i.race //test hypothesis of additivity between race/smoke or 
//hypothesis of no interaction 

*Note:
**indicate categorical by i. or b#. where #=value of the category u want as base
**c. indicates continuous var: only needed when variable is part of interaction
//term.
**# indicates interaction without main effects
**## indicates interaction with main effects
*# can also be used to compute product of 2 continuous variables:
//c.age#c.lwt130 
** (i.race i.smoke)##c.lwt130 = i.race#c.lwt130 i.smoke#c.lwt130
**i.smoke##i.race##c.lwt130 = higher order interaction 


xi: reg bwt i.race i.smoke //creates new variables... not as pretty.
char race[omit] 2 //makes 2 the future ref category
 
xi: reg bwt i.race*i.smoke //same regression with interaction 


///////LOGISTIC REGRESSION////////////

**the [logistic VAR] and [logit VAR, or] do the same thing- display odds ratio
** [logit VAR] without [or] displays log odds-ratio 

tab2 low race 
tabodds low race, base(2) or //displays odds ratio of low with race cat 2 
//as base 
*Ex: for whites (OR=0.43) and others (OR=0.81), estimated risk of lbw is lower 
//than for blacks (however, not significant as seen in equal odds test). 

logistic low b2.race //also obtain odds ratios from logistic regression w/ 
//race cat 2 as base
logit low b2.race, or //accomplishes same as above
logit low b2.race //shows log-odds-ratio instead of odds-ratio; _cons= log odds
//of base/ref category 
*odds-ratio = exp(log-odds)
*_cons = baseline = log odds of lbw for black  mothers; corresponding odds = 
// exp(-0.3102)= 0.7333; corresponding risk = 0.7333/(1+0.7333)=0.42
lincom _cons //displays baseline odds/constant of regression if not initially 
//shown

testparm i.race //Wald test of hypothesis of no diff between the categories 


logit low lwt130 b2.race //multiple logistic regression showing log-odds 
logistic low lwt130 b2.race //same thing in odds-ratios 
lincom 10*lwt130, or //expresses lwt130 association as odds per 10 lbs weight diff (instead of 1 lb) =
// 0.9849^10 (to the power of 10) = 0.86 

lincom 40*lwt130 + 1.race, or //compare white vs black woman's risk of having 
//small baby: white woman weighing 40 lbs more 

///other POST-ESTIMATION COMMANDS FOR LOGISTIC REGRESSION//////
*note: after fitting logistic reg model.

*predict: pr option calculates estimated probability for each subject
*lrtest compares 2 models (one nested within the other) using likelihood ratio 
*estat gof: calculates Pearson goodness of fit test
*estat gof, group(10): calculates H-L goodness of fit test based on 10 intervals
*lroc: graphs ROC curve and calculates area under curve 

//MODELS FOR NON-INDEPENDENT DATA///////////////

*example use clslowbwt.dta

logistic low age lwt smoke //naive regression 
logistic low age lwt smoke, vce(cluster id) //accounting for clustering based on
//mother's id since sibling weights are correlated



