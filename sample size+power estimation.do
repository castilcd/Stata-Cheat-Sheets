//SAMPLE SIZE & STUDY POWER ESTIMATION///

*MUST MAKE THE FOLLOWING DECISIONS:
//1. desired sig. level (default = 0.05, 2-sided)
//2. minimum relevant contrast that you do not want to miss, expressed as study
//group means/proportions
//3a. for sample size estimation: the desried power (default is 0.9)
//3b. for power estimation: sample sizes

//for comparison of means: must make assumption about std dev in each sample

//COMPARISON OF:

*proportions
sampsi 0.4 0.5
**sample size estimation
sampsi 0.4 0.5, n(60)
**power estimation

*Means
sampsi 50 60, sd(8)
**sample size estimation
sampsi 50 60, sd(8) n(60)
**power estimation

//options to sampsi
alpha(0.01) //sig. level
power(0.95) //power
ratio(2) //unequal sample sizes (ratio = n2/n1)
n1(40) n2(80) //unequal sample sizes
sd1(6) sd2(9) //unequal SDs

sampsi 50 60, sd1(14) sd2(10) ratio(2)
*comparisons of means with unequal SDs & samples sizes

