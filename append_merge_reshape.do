///APPEND/MERGE DATA///

**APPENDING DATA FILES - use a do file, then run
*gen_combined.do
cd FOLDERNAME
use file1.dta
append using file2.dta, gen(source)
label variable source "Partial Dataset"
label define source 0 "domestic" 1 "foreign"
label values source source
save combined.dta

**MERGING DATA (1 to 1)
cd FILENAME
use file1.dta, clear  //master
merge 1:1 id using file2.dta //using
save file1n2.dta

**many-to-many merge on specified key variables
cd "FILENAME"
use OForm_16OCT2014.dta, clear  //master
merge m:m tformnumber using T20_TForm_16OCT2014.dta //using
save O+TForms_merged1.dta


**RESHAPE DATA

use metricauto.dta
contract mweightgr foreign // new data set w/ an obs for each combination of
//values in the varlist 
*_freq = frequency of each combo

tab2 mweightgr foreign [fweight=_req] //must use frequency weighting w/ this 
//data

expand _freq //creates data set w/ that can be analysed without weighting 

**LONG TO WIDE & VISE VERSA**

use anklebp2.dta
list in 1/3

reshape long adp, i(id) j(measmnt)
list in 1/6, sepby(id)

reshape wide adp, i(id) j(measmnt)
list in 1/3


**SPLIT VARIABLES

sysuse auto.dta, clear

separate mpg, by(foreign)
list foreign mpg*, nolabel sepby(foreign)

twoway (scatter mpg weight if foreign==0) (scatter mpg weight if foreign==1)
//OR
twoway (scatter mpg0 mpg1 weight)
*plot relationship between mileage & weight for foreign vs domestic 


**CREATE A CONTRACTED DATASET**

input expos case pop
1 1 21
1 10 30
0 1 23
0 0 100
end

tab2 expos case [fweight=pop], chi2 //2way table using weights

expand pop
tab2 expos case, chi2 //expand to full observations 

