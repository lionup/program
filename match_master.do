*Program: match_master.do
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

**Rank BEA industry code in cps basic extracts by value added per worker
**Then generates jobs based on ranked BEA industry and 1-digit occupation pair
do match_rank
clear

**Match consecutive monthly files when possible
do match_merge
clear

***********************************************************************
**Create E2U, U2E, and J2J, and seasonally adjust them using ratio-to-moving-average
do match_flows_basic
clear
do match_flows_j2j
clear

**Generates monthly E2U, U2E, and J2J rates by education group*
do match_edu_basic
clear
do match_edu_j2j
clear

**Generates unemployment rate and employment to population ratio by education group*
do match_edu_ur
clear

**Generates the labor force share of workers employed in jobs (ranked BEA industry and 1-digit occupation pair) by all workers; and also seperately by education group
do match_er
clear

***********************************************************************
**Generates ranked BEA industry employment share by education group, and plot contour graphs*
do match_indv
clear
do match_indv_graph
clear

*Generates employment share for each job by all workers and also seperately by education group
do match_job
clear
do match_edu_job
clear

*Generates transition rate between jobs by all workers and also seperately by education group*
do match_flows_job
clear
do match_edu_flows_job
clear




