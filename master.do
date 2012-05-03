* set your working directory in the folder "/program";
* add your R program in the shell: $module add r/2.13.1
* make sure R package "copula" was installed, otherwise, first run R and type >install.packages("copula") 

set more 1
* generate monthly wage percentiles
do pctile
clear

* merge 2 consecutive CEPR CPS ORG Uniform Extracts
do matchorg
clear

* generate transition between wage deciles from merged files 
do transition
clear

* estimate the parameters of the copula between hourly wages of t and t+1, and seasonally adjust them
do copula1
clear
shell cat copula2.r | R --vanilla
clear
do copula3
clear

* generate all series relating cps basic monthly files* 
do match_master  
clear

* merge the data series together
do combine


