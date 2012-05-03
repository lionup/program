set more 1

* calculate the rank of value added per value

forvalues i = 1948/2010 {
  egen y`i'rank = rank(y`i'), field
}



