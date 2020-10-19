//MISCELLANEOUS//

****RANDOM SAMPLES/SIMULATIONS*****

gen y = runiform()
*generates random number between 0 & 1

gen y = rnormal(10,2)
*random numbers, normally distributed with mean 10 & std dev 2

sample 10
*select random sample of your data set (10%)

sample 53, count 
*select 53 obs at random

gen y = runiform()
gen treat = 1
replace treat = 0 if y<0.05
*assign obs randomly to 2 treatments 

gen y = runiform()
sort y
*sort in random sequence

*****GENERATE ARTIFICIAL DATASETS*****

clear
set seed 654321
set obs 10000
*gen empty observations
gen x0 = rnormal(50,20)
*SD between individuals is 20
gen x1 = rnormal(x0,10)
gen x2 = rnormal(x0,10)
*SD within individuals is 10
gen dif = x2 - x1
*difference between the 2 measurements
sum
