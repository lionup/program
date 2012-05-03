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

**Generat consistent education and industry code 
do match_edu
clear
do match_ind
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





