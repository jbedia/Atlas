####################################
## script for loading EWEMBI data ##
####################################
# ewembi (UDG) -------------------------------------------------------
library(loadeR)
library(transformeR)
# library(loadeR, lib.loc="/vols/abedul/software/meteo/R/library/3.3")
# library(transformeR, lib.loc="/vols/abedul/software/meteo/R/library/3.3")
loginUDG(username = "rodri", password = "summerwind")
dataset = "PIK_Obs-EWEMBI"
# diro = "/oceano/gmeteo/WORK/rodri/DATA/ewembi"
diro= "/home/rodri/work/IPCC_WG1/AR6_regions/data/ewembi"
# di = dataInventory(dataset)
var = c("pr", "tas")
var = "tas"
# sea = list(c(12,1,2), 6:8)
# xlim = c(-20, 54)
# ylim = c(-38, 40)
year = 1979:2013
# year = 1985:2013
xlim =  c(-179.75, 179.75)
ylim = c(-89.75, 89.75)
for (ivar in var) {
  for (iyear in year) {
    print(sprintf("... loading %s, %d ...", ivar, iyear))
    if (ivar == "pr") {
      data = lapply(1:12, function(imonth) {
        print(sprintf("... %s ...", month.abb[imonth]))
        loadGridData(dataset = dataset,
                     var = "pr", lonLim = xlim, latLim = ylim,
                     time = "DD", aggr.d = "sum", aggr.m = "sum", 
                     years = iyear,
                     season = imonth)
      })
    } else if (ivar == "tas") {
      data = lapply(1:12, function(imonth) {
        print(sprintf("... %s ...", month.abb[imonth]))
        loadGridData(dataset = dataset,
                     var = "tas", lonLim = xlim, latLim = ylim,
                     time = "DD", aggr.d = "mean", aggr.m = "mean", 
                     years = iyear,
                     season = imonth)
      })
    }
    data = bindGrid(data, dimension = "time")
    save(data, file = sprintf("%s/%s_%d_monthly.rda", diro, ivar, iyear))
    rm(data)
  }
}
