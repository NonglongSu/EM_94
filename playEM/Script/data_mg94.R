#Data analysis of 90 species 
suppressPackageStartupMessages(library(Biostrings))
suppressPackageStartupMessages(library(stringr))
suppressPackageStartupMessages(library(seqinr))
suppressPackageStartupMessages(library(R.utils))
suppressPackageStartupMessages(library(plyr))
suppressPackageStartupMessages(library(Matrix))
suppressPackageStartupMessages(library(expm))
suppressPackageStartupMessages(library(SQUAREM))
suppressPackageStartupMessages(library(jsonlite))
suppressPackageStartupMessages(library(matlib))

#getwd()
#setwd("~/Dropbox (ASU)/ZIQI_github/EMziqi/playEM")

#create 64*64 N->N matrix
countN = function(file,num,codonstrs){
  seq  = readDNAStringSet(file, format="fasta")
  seqs = str_split(seq,'') 
  
  #codon trans matrix  
  nmat = matrix(0,num,num)
  i=1
  while(i<width(seq)[1]) {
    c1 = paste0(seqs[[1]][i:(i+2)], collapse = '')
    c2 = paste0(seqs[[2]][i:(i+2)], collapse = '')
    coor1 = which(codonstrs %in% c1)
    coor2 = which(codonstrs %in% c2)
    nmat[coor1,coor2] = nmat[coor1,coor2] + 1
    i=i+3
  }
  
  print(sum(nmat)*3)
  return(nmat)
}



##########################################PARTII: main funcs
#inF = "fasta/example.fa"

main = function(inF,ouF,n){
  
  sub = "Script/sources/"
  source(paste0(sub,"codon_call.R"))
  source(paste0(sub,"gtr.R"))
  source(paste0(sub,"mg94.R"))
  source(paste0(sub,"omega_coor.R"))
  source(paste0(sub,"sigma_coor.R"))
  source(paste0(sub,"pseudo_data.R"))
  source(paste0(sub,"init_f.R"))
  source(paste0(sub,"LL.R"))
  source(paste0(sub,"init_sigma.R"))
  source(paste0(sub,"init_omega.R"))
  source(paste0(sub,"phylo_em.R"))
  
  #61 or 64?
  #n = '61'
  num = as.numeric(n)
  print(num)
  
  #>set up codon table
  cdc = codon_call(num)
  cod = cdc[[1]]
  codonstrs = cdc[[2]]
  syn = cdc[[3]]
  
  #>set up omega/sigma tag
  omega.id = omega_coor(cod, codonstrs, syn, num)
  sigma.id = sigma_coor(cod, num)
  
  #>>>>>>>>>>>>>>>>>>>>>>>>>Read data
  #generate codon matrix
  dat = countN(inF,num,codonstrs)
  
  nuc_codon_freq = init_f(cod,dat,num)
  f0  = nuc_codon_freq[[1]]
  cf0 = nuc_codon_freq[[2]]
  print(sum(f0))
  print(sum(cf0))
  
  #pick intial value
  s = init_sigma(syn,dat)
  w = init_omega(cod,codonstrs,syn,dat,f0,s,omega.id,num)
  
  
  #>>>>>>>>>>>>>>>>>>>
  #setup global
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


#######################
args = commandArgs(trailingOnly = TRUE)
main(args[1],args[2],args[3])

