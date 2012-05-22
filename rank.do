set more 1

import excel "../result/va_ind.xlsx", sheet("Sheet1") firstrow
* calculate the rank of value added per value

forvalues i = 1948/2010 {
  egen y`i'rank = rank(y`i'), track
}

order _all, seq

gen sum = 0
forvalues i = 1948/2010 {
  replace sum = sum + y`i'rank
}

replace sum = sum / 63

egen mean_rank = rank(sum), track

saveold ../result/va_ind_rank.dta



