*DO FILES****

clear 
set mem 200m
cd "FOLDERNAME"
use FILENAME, type
log using FILENAME, text replace
....commands...
log close

*change directory
cd FOLDERNAME

clear //before openning new file
use FILENAME //inside directory
////
import delimited using OForm_New_PatientREfNo.csv //non dta file
////

pwd //view current directory
mkdir //make new directory

*Add memory
clear
set memory 25m [,permanently] //25 MB
memory

*(sample dataset)
sysuse auto.dta 
*sample data from internet
webuse filename.dta

codebook, compact //overview

*browse commands
browse in 1/5 
*(all vars, first 5 observations)
browse make weight length 
*(view those 3 vars)
browse make in 23 
*(23rd observation of the var)
browse mpg if foreign==1 
*(view var, foreign only)
browse sex-weight in -5/-1 (see last 5 obs)

help COMMAND
*to define command

search KEYWORD
findit KEYWORD
*find a command you don't know by keyword

diagt 
*sensitivity & specificity 

list, clean
*list obs of all vars, nothing else

summarize
*summary of variable
sum VAR, detail (more details)
summarize if foreign==1
*summarize subset of data (foreign cars only)
sum age if foreign!=1
*exclude foreigners
sum sex-weight (range)
sum pro* (all vars starting w/ pro)

sort VAR (sort data set by variable)
by VAR: sum VAR2 (separate table for each, must sort 1st)
*or in a single commad:
bysort sex: sum age height weight 

*, = option
*| = OR
*! = NOT
*& = AND 

_all (varlist all variables)
scatter VARy VARx
scatter VAR1 VAR2, ylabel(0(10)40)
*label y axis from 0-40 by 10

tab1 (tabulalate 1 variable)
tab2 VARrow VARcolumn
recode age (45/max=3)(25/45=2)(0/25=1), gen(agegr)
*generate age groups with ranges for each value 1-3
 
**FILE NAMES & TYPES
use filename.dta (stata dataset)
do filename.do (exectute do file)
.ado = program
.gph = graph

**COMPUTING VARS
gen heavy=0
replace heavy=1 if sex==1 & weight>90
replace heavy=1 if sex==2 & weight>80
replace heavy=. if missing(weight) 
*exlcude if weight is missing, otherwise 0

gen bmi = weight/(height^2) //will be rejected if already exists; if so, must...
replace bmi = weight/(height^2)

//RECODING VARS/////
recode bmi (2=0) (4=1) (*=.), gen(obese) //(OLD=NEW) *ALL ELSE=MISSING

detstring, replace //str to numeric 
detstring, gen(newvar)

//RENAMING//
rename gender sex //old to new

help renvars //also helpful for renaming systematically 

//REORDERING//

order id age-weight //id goes first
order _all, alphabetic //alphabetical order

*DROPPING VARS OR OBS
drop VARIABLE if ... 
drop if VAR=x //drop an obs


*qualifiers
replace obese=1 if bmi>=30 & !missing(bmi) //& not missing
*or ... 
if !missing(bmi) //if bmi is not missing

*string vars
gen nation = "Danish" if ph==45

label variable heavy "Is this person fat?"
label define sex 1 "male" 2 "female" 9 "missing" //label val lab

recode sex (1=1 "male") (0=2 "female"), gen(gender) //(old=new)
label variable gender "sex of respondent"
tab2 sex gender //to check

recode age (55/max=4 "55+") (35/55=3 "35-34")..., gen(agecat) //info taken by 
*1st command when values overlap
numlabel, add
sort age
list age agegr [,nolabel] //to check 
*or
list age agegr, sepby(agegr)
*or
tabstat age, by(agegr) stat(min max)

egen agegr = cut(age, at(0 5(10)85 200) label //create intervals
egen agegr = cut(age), group(4) label //4 age groups 


//SORTING//

sort mpg weight //ascending only
gsort mpg -weight // mpg ascend, weight descending 


//EXTENSIONS ACROSS OBSERVATIONS//

egen meanage=mean(age) //mean age across observations
by sex: egen meanage=mean(age) //mean age across obs for each sex

egen racesex = group(race sex), label //new variable w/ all combinations
cc low smoke, by(racesex)

*gen date
gen bdate = mdy(bm,bd,by) 
*combines 3 vars into 1
format bdate %td 
*format will be 18sep1987

*length of time
gen days = date2 - date1
gen years = (date2 - date1)/365.25

*extract day/mo/year from var bdate
gen bday = day(bdate)
gen bmonth = month(bdate)
gen byear = year(bdate)

*%tw = weeks

*remove time stamp from date
gen cycledate2 = date(cycledate, "DMYhm")
format cycledate2 %td
label variable cycledate2 "Cycle Date"

*remove hyphens from dates
gen str9 dedashed_embtransdate = subinstr(embryotransferdate,"-","/", .) 
gen embryotransdate2 = .
replace embryotransdate2=date(dedashed_embtransdate,"DM20Y")
format embryotransdate2 %td

//find dates within a range
gen after1mar2006=(b1deldate3>date("01mar2006","DMY"))


save FILENAME //save dataset as
savold FILENAME //save as version 12
 
 **IMPORT DATA
clear
insheet using Book1.csv,comma //COMMA DELIMITED
 
*mathematical functions
help functions

*random sampling
sample 10 //10% random sample
sample 57, count //exactly 57 observations

sort mpg weight //ascending only
sort mpg -weight //mpg ascending weight descending


*scatterplot by groups
twoway (scatter mpg weight if foreign==0) (scatter mpg weight if foreign==1)

*histogram
histogram VAR

//missing value table
misstable patterns, frequency
//include missing values in table
tab1 sex, missing

*identifying weird values
list id sex if sex<1 | sex>2


///CATEGORICAL VARIABLES///////

desribe //descrobes all vars 
label list //shows variable labels for cat vars
codebook VAR //details about VAR
summarize //another overview of data

list VAR1-VAR2 in 1/5, nolabel clean noobs //lists VAR1 to VAR2, first 5 obs 
											//just values

//example: data inspection
sort race smoke //sort by these vars
list race smoke bwt if bwt<1800, sepby(race) N mean(bwt) 
*results in table separated by race that shows observations for IDs with BW<1800

list in 1/2, nolabel //list first two rows of data in 2 tables or...
slist //alternative type of list
slist in 1/2, id(make) decimal(2) //shows make at beg of each line, adds decimal
									//places



browse VAR1-VAR3 in 1/5 //pulls up data browser for selected vars

tab1 VAR, missing //freq table
tab1 VAR1 VAR3-VAR5, missing //can specify which ones you want
*options: missing (shows missing values); nolabel (only values)

tab2 VAR1 VAR2, column chi2 exact nolog //cross-tab 
*column = column %
*row = row %
*chi2 = Pearson's chi-sq test
*nolog = resticts output from test
*missing = includes tabulation of missing values
*exact = Fisher's exact test

bysort smoke: tab2 VAR1 VAR2 //2 cross tabs of according to smoking (yes/no) 
								//sub-groups

table VAR1 VAR2 VAR3 //creates a 3-way table
table VAR1 VAR2, by(smoke) row col stubwidth(20) //2 tables for smokers and non-
						//smokers, row/col totals and adjusted width of table
count //# of obs in dataset
count if smoke==1 //number of smokers

tabm rater* //creates a table of the values assigned by each rater

//CONTINUOUS VARIABLES////////////

sum VAR, detail //additional details to summary
centile VAR, cetile (25 50 75) //specific percentiles

histogram VAR, freq normal //histogram w/ normal curve
qnorm VAR //Q-Q plot for departure from normal distrib
 
//TRANSFORMATIONS//

gen lnVAR = ln(VAR) //log
gen sqrtVAR = sqrt(VAR) //sq-rt
gen invVAR = 1/VAR //inverse of VAR

//CUMULATIVE DISTR OF VAR//
cumul bwt, gen(cumbwt)
sort cumbwt
twoway line cumbwt bwt
*results in generation of new VAR representing cumulative distrib of bwt and 
*makes 2-way plot of the 2 vars.

graph box bwt, over(smoke) //box+whisker plot of bwt for smokers/non-smokers
*shows interquartile range (25th/75thpercentile) and median

tabstat age lwt bwt, by(race) //another version of sum (mean = default)
*shows average age/lwt/bwt for each race
tabstat age lwt bwt, by(race) stat(n mean sd cv semean median) longstub
tabstat age lwt bwt, stat(n mean sd median) col(stat) format(%8.2f) //alternat
**other options: count, sum, max, min, range, sd, variance, semean (std err of
*mean), p1 (1st %), median(same as p50), iqr (int-q-range), q (quartiles)

table race smoke, contents(mean bwt) format(%9.1f) //simple table of avg bwt
									//by race for smokers & non 
									
gen y=_n //observation number
gen y=_N //number of observations in dataset

//GIVING #'S TO OBSERVATIONS//

*gen patnumbers2.do
use admissions.dta

*sort by patient & date of admission, generate observation #
sort patid admdate
gen obsno = _n
label variable obsno "Observation Number"

*give each patient a #
egen patno = group(patid) //creates a # per patid (as a group)
label variable patno "Patient Number"

*generate admission number & total admissions for each patient
by patid: gen admo = _n //observation #
label variable admo "Patient's Admission Number"
by patid: gen admtot = _N //# of obs
label variable admtot "Patient's Number of Admissions"

save patnumbers2.dta

anycommand if admo==1 //study first admissions
anycommand if admo==admtot //study final admissions
tab1 admtot if admo==1 //distribution of patients' # of admissions

//remove duplicates

//based on name variable
sort name
quietly by name:  gen dup = cond(_N==1,0,_n)

duplicates drop var1 var2, force //forcefully removes duplicate combos of vars

//reshape wide to long

reshape varlist, i(id) j(reference variable)

//change string to numeric

replace bmi2="" if bmi1=="NA" //remove missing values
destring bmi2, replace 

//----------DROPPING DUPLICATES BASED ON DATE---------//

sort hfea_t //sort by tform number
by hfea_t (formsubmitdate), sort: keep if _n==_N
// for each tform number, keep obs with latest date










