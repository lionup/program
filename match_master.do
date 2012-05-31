*Program: match_basic.do
*Date 5/April/2012

*********************************************************************
* THIS PROGRAM GENERATES ALL SERIES RELATING CPS BASIC MONTHLY FILES* 
*********************************************************************

set more 1
clear

set more 1

**Exract the data from the raw CPS files
do match_extract
clear

**Generat consistent education, industry, and occupation code 
do match_edu
clear
do match_ind
clear
do match_occ
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

**Generates BEA ranked industry employment share by education and the contour plots*
do rank
clear
do match_indv
clear
do match_indv_graph
clear

*Generates employment share by industry, occupation, and education*
do match_ind1_occ1
clear
do match_ind1_occ2
clear
do match_ind1_occ3
clear

do match_ind2_occ1
clear
do match_ind2_occ2
clear
do match_ind2_occ3
clear

do match_ind3_occ1
clear
do match_ind3_occ2
clear
do match_ind3_occ3
clear

do match_indv_occ1
clear
do match_indv_occ2
clear
do match_indv_occ3
clear

*Generates transition between industry and occupation pair*
do match_ind1_occ1_flows
clear
do match_ind1_occ2_flows
clear
do match_ind1_occ3_flows
clear

do match_ind2_occ1_flows
clear
do match_ind2_occ2_flows
clear
do match_ind2_occ3_flows
clear

do match_ind3_occ1_flows
clear
do match_ind3_occ2_flows
clear
do match_ind3_occ3_flows
clear

do match_indv_occ1_flows
clear
do match_indv_occ2_flows
clear
do match_indv_occ3_flows
clear


*Generates transition between industry and occupation pair by education level*
do match_ind1_occ1_flows_edu
clear
do match_ind1_occ2_flows_edu
clear
do match_ind1_occ3_flows_edu
clear

do match_ind2_occ1_flows_edu
clear
do match_ind2_occ2_flows_edu
clear
do match_ind2_occ3_flows_edu
clear

do match_ind3_occ1_flows_edu
clear
do match_ind3_occ2_flows_edu
clear
do match_ind3_occ3_flows_edu
clear

do match_indv_occ1_flows_edu
clear
do match_indv_occ2_flows_edu
clear
do match_indv_occ3_flows_edu
clear




