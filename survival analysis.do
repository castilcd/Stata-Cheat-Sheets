/// INCIDENCE, MORTALITY, AND SURVIVAL//////////

*Example: use compliance1.dta

*gen_complaince2.do

*Age at randomization from birthdate and date of randomization
gen ranage = (randate-birthdate)/365.25
label variable ranage "Age at randomization"

*Age at randomization in 2-year age groups
egen ranagr = cut(ranage), at(64(2)100)
label variable ranagr "Age group at randomization"

*sort by id to make listing more presentable
sort id

label data "Compliance data with age at randomization added"
save compliance2b.dta

stset enddate, failure(died==1) enter(randate) origin(randate) scale(365.25)
> id(id) 
*must decide:
*1 which variable contains the time at end of follow-up (enddate)
*2 which contains info on the event/failure and how is it defined (died==1)
*3 when does a person enter into study/does time at risk start (randate)
*4 what is relevent time scale: calendar time/age/time since inception/time
**since recruitment? (time since randomization here)
*5 what is start of time scale (randate)
**if we had chosen age, then this would have been (birthdate)
*6 measurement of time (scale down by factor of 365.25-> days into years)
//RESULT: 2634 PERSON YEARS; LONGEST FOLLOW UP = 5.7 YEARS

slist if inlist(id,254,8702), id(id) //look at data on subjects 254 & 8702
//_st (1= contains valid survival info)
// _t (time at observation end)
//_t0 (time at observation start)

*exit option: allows for specifying exit time; 
exit(time(randate+365.25*3)) //if we want all survivors to be censored 3 years
//after date of inclusion


/////KAPLAN-MEIER SURVIVAL FUNCTION////////

sts graph, by(particip) //graph of proportion surviving (y) vs years since 
//randomization (x) 
sts graph, by(particip) failure ylabel(0(0.05)0.30) risktable 
//failure option = plots cumulative incidence proportion instead(1-survival)
//ylabel defined values on y axis (wihtout it, it would be 0-1)

sts list, failure by(particip) at(0(1)5) //detailed info on cumulative incidence
//for first 5 years
*Beg, Total = # of persons at risk just before latest failure
*Fail = # of failures since last time point
stci, by(particip) p(10) //time until specific percentile of pop has experienced
//the event of interest
*Ex: 10% of non-participants died after 1.17 years, while 10% of participants
//dies after almost 4 years

sts test particip //log-rank testfor identical incidence btween groups
*ex: reject hypothesis that mortality is the same among groups; it was lower
//among participants


/////COX PROPORTIONAL HAZARD REGRESSION///////////

*hazard=instantaneous rate of event
**use post-estimation commands for categorical variables & interactions

stcox b0.particip //assuming proportional hazards
*hazard ratio associated w/ participation = 0.45
*mortality is lower among participants 
*can also include other explanatory variables (like age) & interaction terms

stcox b0.particip i.ranagr, noshow nolog 
*noshow = suppress summary of settings
*nolog = suppress logging of iterations
**mortality increases with age: hazard = 3.1 times as large for age 72+ compared
// w/ 64-65 (base) at randomization
**age adjusted hazard ratio for participation is 0.48

///////POST ESTIMATION COMMANDS///////

stcurve, survival at1(ranagr=64 particip=0) at2(ranagr=66 particip=0) at3(ranagr=66 
> particip=1) //plot of estimated survival based on preceding model for 3 types
//of subjects

lincom 1.particip + 66.ranagr, hr //hazard ratio between participants aged 66-67
//compared w/ non-participants in youngest age group
*hr = hazard ratio option(default = log hazard)

testparm i.ranagr //test hypothesis of no overall diff between hazard ratios of 
//age groups

*COMPARISON OF TWO MODELS////////////

. quietly: stcox b0.particip i.ranagr
. estimates store modelA
. quietly: stcox b0.particip
. estimates store modelB
. lrtest modelA modelB

//only valid if one model is nexted within the other (i.e., modelB nested within
//modelA)

stcox b0.particip, strata(ranagr) noshow nolog //stratification by agr group
*allow baseline hazards for the age groups to be different
**can stratify by up to 5 categorical vars
***no estimate of effect of age, just participation


////////CHECK PROPORTIONALITY ASSUMPTION////////

stcox b0.particip i.ranagr //remember: assumes proportionality = hazard ratios
//are constant over time

xi i.ranagr //generate indicator variables
*plots of survival curves - visual examination
stphplot, strata(particip) adjust( _Iranagr*) nolntime name(p1)
stphplot, strata(ranagr) adjust(particip) nolntime name(p2)
*strata = specify covariates to examine
*adjust = other covariates in the model
graph combine p1 p2

. quietly: stcox b0.particip i.ranagr 
. estat phtest, detail //formal test of hypothesis of porportional hazards
*p-val <0.05 = potential problems 


/////PREP FOR ADVANCED SURVIVAL ANALYSIS//////////

*ex: use compliance2b.dta

//using age as the time scale instead of time since randomization
stset enddate, failure(died==1) enter(randate) origin(birthdate) scale(365.25)
> id(id) //set up for survival analysis

slist if inlist(id,254,8702), id(id)
*(_st=1) both have relevant survival info
*(_d=1) dead at follow up
*origin = birthdate
*(_t0) age at randomization
*(_t) age at end of follow up


//generating time-varying variables///////////////////
*use current age (which varies throughout) instead of age of randomization as an
//explanatory variable

*gen_compliance3b.do
**stset the data from randate to enddate
stset enddate, failure(died==1) enter(randate) origin(randate)scale(365.25)
> id(id)

*generate current age in groups
stsplit curagegr, at(64(3)100) after(birthdate) //requires 2b preceded by stset
label variable curagegr "Current age in groups"
*check that it went well
list id ranage curagegr _t0 _t _d if id==254
*curagegr contains info on current age where 73 =  73</= age </= 76

*generate time-varying "time since randomization" variable
stsplit fromran, at(0 1 3) after(randate) //time since rand in 3 groups
label variable fromran "Time since randomization"
list id curagegr fromran _t0 _t _d if id==254
*first 2 lines = first year of randomization
*third line = next 2 years
*last 2 lines = period after first 3 years

*****MUST SAVE TO FILE AFTER CHANGES************


////COX MODEL W/ TIME-VARYING COVARIATES/////

stcox b0.particip i.curagegr

//ALLOW HAZARD RATIO TO VARY WITH TIME/// by including interaction between 
//particip and time since randomization 

stcox b0.fromran b0.fromran#b0.particip i.curagegr 
*hazard ratio assoc w/ particip is .15 the 1st year, .52 during next 2 years, 
// .67 during following years. 
**tendency toward decreasing mortality difference between 2 groups
testparm i.fromran#i.particip, equal 
*difference is marginally significant 

stcox particip i.curagegr, tvc(particip) nohr
*nohr = coefficients in log hazard scale
//log hazard ratio: -1.405 + (0.242xt) --> so increases with time
stcox particip i.curagegr, tvc(particip) //same thing in hazard ratios
*a hazard ratio less than 1 would mean a decrease over time

//if we don't assume that the hazard ratio changes linearly, then ...
stcox particip i.curagegr, tvc(particip) texp(_t>1)
*texp(_t>1) = produces model with one HR for the first year after start, and 
//another for the rest. 
**association with participation in the 1st year: HR = 0.153
**association with particip after first year: HR = 3.956 
**closer to 1 = larger

lincom [main]particip + [tvc]particip, hr //find hazard ratio for last period
*smaller hazard among participants: HR = 0.61


//////TABULATING RATES///////////

stset enddate, failure(died==1) enter(randate) origin(randate) scale(365.25) 
> id(id)
*count # of events + calculate total person-time at risk (assuming constant
//hazard)
stptime, by(particip) per(1000) dd(4) //express incidence of events by a rate
*person-time at risk
*# of events: among participants - 30 deaths/1000 person years; 68 among non. 
*corresponding rates (per 1000 years, 4 decimals)
stptime, by(particip) at(0(1)5) per(1000) dd(4) //lists rates in selected time
//intervals. 

**comparison of rates using ir and stir commands 
stir particip, by(ranagr)
