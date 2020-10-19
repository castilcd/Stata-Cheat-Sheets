///POISSON REGRESSION////

*rates are assumed to be constant

//ex: use compliance3b.dta

//is stsplit by curaggr & fromran; _t0 & _t contain start & end of the period 
//on each line; and _d = whether period ended by death or censoring

. gen event=_d
*died? y/no
. gen pyr=(_t-_t0)
*end time - start time (stratified by age group)= time at risk
. list id curagegr fromran _t0 _t _d event pyr if id==254

poisson event b0.particip i.fromran i.curagegr, exposure(pyr) ir
*exposure(time at risk)
*participation is associated with a rate ratio of 0.48 when adjusted for current
//age and time since study start
* the oldest men had a mortality rate that was between 1.44 and 14.5 (CI) times
// as high as the youngest
*ir option = rate ratios
lincom _cons, eform
*_cons = estimated rate for a reference person (AKA, man who did not participate
//, was between 64-66 yrs old, and in 1st year of randomization)
*estimated rate is 27 deaths per 1,000 person-years for ref persons

//DOES RATE RATIO ASSOCIATED W/ PARTICIPATION CHANGE W/ TIME SINCE RANDOMIZATION

poisson event b0.fromran#b0.particip i.curagegr, exposure(pyr) ir
*RRs for particip = close to Cox reg hazard ratios w/ time varying covariates
//from prev survival analysis 

**compliance3b.dta has been stsplit twice; original sample of 555 expanded to 
//2408.

///REDUCE DATASET TO A TABLE//////
collapse (sum) event pyr, by(particip curagegr fromran)
list
save compliance3b_table.dta

poisson event b0.fromran#b0.particip i.curagegr, exposure(pyr) ir 
*will produce same results as expanded dataset

////OTHER POISSON POST-ESTIMATION COMMANDS/////

predict
lincom
testparm
lrtest




 