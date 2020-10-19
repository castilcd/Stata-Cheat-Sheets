/////STANDARDIZATION: STRATIFIED ANALYSIS////

*INDIRECT STANDARDIZATION= incidence of study pop compared w/ incidence of ref
//pop. 
*STRATUM WEIGHTS =  defined by distribution of time at risk in study pop; result
//expressed as STANDARD MORTALITY RATIO or STANDARDIZED INCIDENCE RATIO

*example: use oppatients1.dta //study data

codebook, compact

use dk1991-95.dta //population reference data
list, sepby(sex)

*gen_oppatients2b.do
use oppatients1.dta, clear

*-stset- data; age is time axis
stset enddate, enter(begdate) origin(bdate) failure(died==1) scale(365.25) 
>id(patid)

*split information in age bands (agegr)
stsplit agegr, at(0 1 5(5)100)
label variable agegr "Age band"

*merge age- and sex-specific reference mortality rates to data
sort sex agegr
merge m:1 sex agegr using "dk1991-95.dta"
drop if _merge<3  //some age bands in ref pop file had no match in study dataset 
drop _merge       //they are droppped.

label data "Patient Data, stsplit and merged with population rates"
save oppatients2b.dta

strate sex, smr(mrate) //calculates SMR for each sex

*other useful cammands to calc SMR:
stptime //handy
istdize //needs data prep


*DIRECT STANDARDIZATION = ref pop is real or hypothetical; characterized by
//relative age distribution; standardized rates calculated using weights from
//ref pop 

*information is weighted/adjusted by distribution in a real/hypothetical pop.

*example: use stdpops.dta & dk1975-2004.dta

use stdpops.dta
tab1 standard
list if standard==10, separator(0) //list european only

use dk1975-2004.dta //danish mortality data
sum 

//PERFORM DIRECT STANDARDIZATION TO EUROPEAN STANDARD POP/////

*gen_std_europe2.do

cd foldername
use stdpops.dta
keep if standard==10
save std_europe2.dta

*key variables in both datasets (age & pop) have same var names. 

use dk1975-2004.dta
dstdize deaths pop age, by(year) using(std_europe2.dta) 
*crude rates didnt change much over 30 years, ut adjusted rates did.
**comparing crude rates=misleading--> confounded by changing age structure.


