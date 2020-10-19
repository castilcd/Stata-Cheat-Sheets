//GRAPHS//

//TYPES:

graph bar
graph box
graph dot
graph matrix
graph pie
graph twoway

graph twoway scatter
graph twoway line

//example 
*gph_fig17_1.do

sysuse auto.dta
set scheme lean1

twoway (scatter mpg weight if foreign==0) (scatter mpg weight if foreign==1), 
> title("Title: Figure 17.1")
> subtitle("Subtitle: The Anatomy of a Graph")
> ytitle("y-axis title") xtitle("x-axis title") 
> legend(title("Legend", size(*0.8)) order(1 "First plot" 2 "Second plot"))
> note("Note: xsize() and ysize() define the entire graph size")
> caption("Caption: Figure 17.1: Anatomy of a Graph")
> text(35 3400 "Plot area", size(*1.5))
> graphregion(lpattern(dash) lcolor(black) lwidth(*0.5))
> xsize(4.4) ysize(3.3)

//example
sysuse uslifeexp.dta
describe
*default is wide data structure (for each obs/year, there are results for
//a group)
list year le_male le_wfemale le_bmale le_bfemale if year<1903, abbreviate(10)

//GRAPH SIZE

*Example: 

sysuse auto.dta
set scheme s2mono //sets default graph size
twoway (scatter mpg weight) 

twoway (scatter mpg weight), xsize(3) ysize(2.2) //custom size
twoway (scatter mpg weight), xsize(3) ysize(2.2) scale(1.4) //enlarge text &
//marker size

//SCHEMES

sysuse auto.dta
set scheme s1mono
twoway (scatter mpg weight), xsize(3) ysize(2.2) scale(1.4) //diff style

*other schemes:
s1color
s2color
s2mono
lean1
lean2
(findit lean schemes if not installed)

twoway (scatter mpg weight, msymbol(T) mcolor(blue) mfcolor(red)), ...
twoway (scatter mpg weight, ms(T) mlcolor(blue) mfcolor(red)), ...

set scheme lean1, permanently //permanent change

graph query, schemes //see list of schemes installed

net from http://www.stata-press.com/data/vgsg2 *installed

*gph_fig17_9.do
sysuse uslifeexp.dta
set scheme lean2

*original
twoway (line le year), 
> xlabel(1900(25)2000) xmtick(##5) //tick & label every 25 yrs, 5 major interval
> ylabel(40(10)80)
> xsize(3.1) ysize(2.2) scale(1.4) 

*horizontal lines off, vertical lines on
twoway (line le year), 
> xlabel(1900(20)2000, grid) xmtick(##5)
> ylabel(, nogrid)
> xsize(3.1) ysize(2.2) scale(1.4)


//log-scaled axes
* gph_fig17_10.do
use agemort.dta
set scheme lean2

twoway (line mort age)                                                      ///
  ,                                                                         ///
  plotregion(margin(l=0))                                                   ///
  yscale(log)                                                               ///
  ylabel(0.1 "0.1" 0.2 "0.2" 0.5 "0.5" 1 2 5 10 20 50 100 200 500, nogrid)
 *specify ticks explicitly
  yline(0.1 1 10 100, lwidth(*0.3))                                         ///
  xsize(3.1) ysize(2.2) scale(1.4)

  
 ///MULTIPLE AXES////
 
 * gph_fig17_12.do

set scheme lean1

input year tobacco cancer
1900  .4   .5
1907  .7   .6
1912  .9  1.0
1924 1.9  1.9
1930 2.4  4.0
1936 2.8  7.5
1947 4.2 22.5
end

generate cigarettes = 454*tobacco       // (1 lb = 454 grams)

twoway                                                               ///
  (line cancer year, yaxis(1) lpattern(l))                           ///
  (line cigarettes year, yaxis(2) lpattern(dash))                    ///
  ,                                                                  ///
  xtitle("Year")                                                     ///
  ytitle("Annual lung cancer" "mortality per 100,000", axis(1))      ///
  ytitle("Cigarettes per person per year", axis(2))                  ///
  legend(order(2 "Cigarette consumption" 1 "Lung cancer mortality")) ///
  plotregion(margin(b=0))                                            ///
  xsize(5) ysize(2) aspectratio(0.75) scale(1.4)

  
///2 SCATTER PLOTS IN 1 GRAPH///

* gph_fig17_13.do

sysuse auto.dta
set scheme s1mono

twoway						///
  (scatter mpg weight if foreign==0)            ///
  (scatter mpg weight if foreign==1)            ///
  ,                                             ///
  xsize(3.1) ysize(2.2) scale(1.4)

  **including legend
  
  * gph_fig17_14.do

sysuse auto.dta
set scheme lean1

twoway							    ///
  (scatter mpg weight if foreign==0)                        ///
  (scatter mpg weight if foreign==1)                        ///
  ,                                                         ///
  legend(title("Origin") order(1 "Domestic" 2 "Foreign"))   ///
  xsize(3.1) ysize(2.2) scale(1.4)


***alternative style
* gph_fig17_15.do

sysuse auto.dta
set scheme lean1

twoway 					    ///
  (scatter mpg weight if foreign==0)        ///
  (scatter mpg weight if foreign==1)        ///
  ,                                         ///
  legend(title("Origin", size(*0.8))        ///
    order(1 "Domestic" 2 "Foreign"))        ///
  xsize(3.8) ysize(2.2) scale(1.4)

  

///HISTOGRAMS///

* gph_fig17_20.do   default histogram
*basic
sysuse auto.dta
set scheme lean2
histogram weight, xsize(3.1) ysize(2.2) scale(1.4)

**improved
* gph_fig17_21.do   modified histogram

sysuse auto.dta
set scheme lean2

histogram weight                  ///
  ,                               ///
  frequency                       ///
  normal                          ///
  kdensity                        ///
  start(1000) width(500)          ///
  xsize(3.1) ysize(2.2) scale(1.4)
*normal and kernel density curve overlay

///BOX&WHISKER PLOTS///

* gph_fig17_22.do [HORIZONTAL]
use lbw1.dta
set scheme lean2

graph hbox bwt                  ///
  ,                             ///
  over(smoke) over(race)        ///
  xsize(3.8) ysize(2.2) scale(1.4)
  
  
* gph_fig17_23.do [VERTICAL]

sysuse auto.dta
set scheme lean1

dotplot weight                    ///
  ,                               ///
  over(foreign) center msymbol(O) ///
  nx(14) ny(20)                   ///
  xsize(2.8) ysize(2.2) scale(1.4)

  
//BAR GRAPHS////

* gph_fig17_24.do

input str5 age diabm diabf
16-24  0.9  0.2
25-44  0.8  0.8
45-66  3.8  2.9
67-79  8.2  5.4
80+    9.1  7.2
end

set scheme lean2

graph bar (asis) diabm diabf           /// asis = 1 obs per group (m & f)
  ,                                    ///
  over(age)                            ///
  b1title("Age")                       ///
  ytitle("Prevalence (percent)")       ///
  legend(order(1 "Males" 2 "Females")) ///
  blabel(bar, format(%03.1f))          ///
  xsize(4.4) ysize(2.2) scale(1.4)
*constructed from tabular data


**long format

* gph_fig17_25.do (basic)
use lbw1.dta
set scheme lean2

graph bar (mean) bwt              ///
  ,                               ///
  over(smoke) over(race)          /// 2 layers
  xsize(3.3) ysize(2.2) scale(1.4)
 
 * gph_fig17_26.do (improved labels)
  label define yesno 0 "Nonsmokers" 1 "Smokers", modify
label define race 1 "Whites" 2 "Blacks" 3 "Others", modify

graph bar (mean) bwt                  ///
  ,                                   ///
  over(smoke) over(race) asyvars      ///
  ytitle("Mean birthweight (grams)") ///
  xsize(3.9) ysize(2.2) scale(1.4)

  
**comparing between groups of ordinal variable****
*STACKED BARS*

* gph_fig17_27.do

sysuse auto.dta
set scheme lean2
generate x=1								/// created help var to
graph bar (count) x                            /// reflect # of cars
  ,                                            ///
  over(rep78) over(foreign)                    ///
  asyvars percent stack                        ///
  bar(1, fcolor(gs0))                          ///
  bar(2, fcolor(gs6))                          ///
  bar(3, fcolor(gs10))                         ///
  bar(4, fcolor(gs13))                         ///
  bar(5, fcolor(gs16))                         ///
  legend(title("Repair" "record", size(*0.8))  ///
    order(5 4 3 2 1))                          ///
  ytitle("Percent")                            ///
  b1title("Origin")                            ///
  xsize(2.8) ysize(2.2) scale(1.4)

  


