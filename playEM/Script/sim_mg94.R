suppressPackageStartupMessages(library(Biostrings))
suppressPackageStartupMessages(library(stringr))
suppressPackageStartupMessages(library(seqinr))
suppressPackageStartupMessages(library(R.utils))
suppressPackageStartupMessages(library(plyr))
suppressPackageStartupMessages(library(expm))
suppressPackageStartupMessages(library(purrr))
suppressPackageStartupMessages(library(matlib))
suppressPackageStartupMessages(library(jsonlite))
suppressPackageStartupMessages(library(SQUAREM))

main = function(inF,ouF,l,n){

  #setwd("~/Dropbox (ASU)/ZIQI_github/EMziqi/playEM")

  source("Script/sources/codon_call.R")
  source("Script/sources/gtr.R")
  source("Script/sources/mg94.R")
  source("Script/sources/omega_coor.R")
  source("Script/sources/sigma_coor.R")
  source("Script/sources/pseudo_data.R")
  source("Script/sources/init_f.R")
  source("Script/sources/LL.R")
  source("Script/sources/init_sigma.R")
  source("Script/sources/init_omega.R")
  source("Script/sources/phylo_em.R")


  #example
  #inF  = "Results/rand_para.txt"
  tP = unlist(read.table(inF, header=F, sep=""))
  #True parameters, unnormalized
  Pi    = tP[1:4]
  Sigma = tP[5:10]
  omega = tP[11]
  Tau   = tP[12]


  #61 or 64?
  #n = '61'
  #l = '1e+5'
  len = as.numeric(l)
  num = as.numeric(n)

  #>codon table
  cdc = codon_call(num)
  cod = cdc[[1]]
  codonstrs = cdc[[2]]
  syn = cdc[[3]]

  #>GTR matrix
  gtr = GTR(Sigma,Pi)

  #>MG94 matrix
  mg94 = MG94(gtr,omega,cod,codonstrs,syn,num)

  #>
  omega.id = omega_coor(cod, codonstrs, syn, num)
  sigma.id = sigma_coor(cod, num)

  ##generate pmat
  Pi2 = sapply(seq(num), function(x){prod(Pi[match(cod[x, ], DNA_BASES)])})
  Pi2 = Pi2/sum(Pi2)

  o   = outer(sqrt(Pi2),1/sqrt(Pi2))
  s94 = mg94*o        #symmetric matrix
  p94 = expm(s94)*t(o)
  P94 = p94*Pi2
  print(sum(P94))


  #>generate data
  set.seed(8088)
  dat = pseudo_data(len,P94,num)

  #>
  nuc_codon_freq = init_f(cod,dat,num)
  f0  = nuc_codon_freq[[1]]
  cf0 = nuc_codon_freq[[2]]
  print(sum(f0))
  print(sum(cf0))

  #test if sim.LL<emp.LL
  ll.sim = sum(log(expm(mg94)*Pi2)*dat)
  ll.emp = LL(cod,codonstrs,syn,c(Sigma,omega),f0,cf0,dat,num)
  if(ll.sim<ll.emp){
    print("Yes!")
  }else{
    print("come on man!")
  }

  #>init value choice
  s = init_sigma(syn,dat)
  w = init_omega(cod,codonstrs,syn,dat,f0,s,omega.id,num)

  #running SQUAREM
  num      <<- num
  cod      <<- cod
  codonstrs<<- codonstrs
  syn      <<- syn
  f0       <<- f0
  cf0      <<- cf0
  dat      <<- dat
  omega.id <<- omega.id
  sigma.id <<- sigma.id


  p0   = c(s,w)
  tm4b = system.time({
    ps4b = fpiter(par=p0, fixptfn=phylo_em, control=list(tol=1e-4, trace=TRUE, intermed=TRUE))
  })

  pd      = ps4b$par
  rmat    = GTR(pd[1:6],f0)
  tnew    = -sum(diag(rmat)*f0)
  par.est = c(f0,pd,tnew)

  #print its value
  print(par.est)
  write(par.est,ouF,sep="\t",ncolumns=12)
}

############################
args=commandArgs(trailingOnly=T)
main(args[1],args[2],args[3],args[4])
