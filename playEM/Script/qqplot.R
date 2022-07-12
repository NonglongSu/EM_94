
setwd("~/Dropbox (ASU)/ZIQI_github/EMziqi/playEM")

inF1 ="sample/para.txt"
inF2 ="Results/nmkb_sim_est.txt"
ouFig="Results/qqplot.pdf"
main = function(inF1,inF2,ouFig){
  dat1 = as.numeric(read.table(inF1,header=F))
  dat2 = as.numeric(read.table(inF2,header=F))
  
  pdf(ouFig,onefile=T)
  qqplot(dat1,dat2)
  abline(0,1,col="red",lwd=2)
  dev.off()
}


################################
args = commandArgs(trailingOnly=T)
main(args[1],args[2],args[3])