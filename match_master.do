*Program: match_basic.do
*Date 5/April/2012

*********************************************************************
* THIS PROGRAM GENERATES ALL SERIES RELATING CPS BASIC MONTHLY FILES* 
*********************************************************************

set more 1
clear

**Exract the data from the raw CPS files
do match_extract
clear

**Generate consistent education, industry, and occupation code 
do match_edu
clear
do match_ind
clear
do match_occ
clear

**Rank vind7090 in cps basic extracts by value added per worker
do match_rank
clear

**Match consecutive monthly files when possible
do match_merge
clear

**Create E2U, U2E, and J2J, and seasonally adjust them using ratio-to-moving-average
do match_flows_basic
clear
do match_flows_j2j
clear

**Generates unemployment rate and employment to population ratio by education*
do match_edu_ur
clear

**Generates monthly E2U, U2E, and J2J rates by education*
do match_edu_basic
clear
do match_edu_j2j
clear

**Generates monthly 1,2,3-digit industry employment share by education*
do match_ind1
clear
do match_ind2
clear
do match_ind3
clear

**Generates ranked BEA industry employment share by education and the contour plots*
do match_indv
clear
do match_indv_graph
clear

*Generates employment share by ranked BEA industry, 1-digit occupation, and education*
do match_indv_occ1
clear

*Generates transition between ranked BEA industry*
do match_flows_indv
clear

*Generates transition between 1-digit occupation*
do match_flows_occ1
clear

*Generates transition between ranked BEA industry by education*
do match_edu_indv
clear

*Generates transition between 1-digit occupation by education*
do match_edu_occ1
clear


