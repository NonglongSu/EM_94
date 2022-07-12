## Synopsis
EMfun is for you to play.

## Dependencies
* [R 4.0 +]  (https://www.r-project.org/) and libraies `Biostrings`, `stringr`, `seqinr`, `R.utils`, `plyr`, `Matrix`, `expm`, `SQUAREM`, `jsonlite`, `matlib`, `ggplot2`, `tidyverse`, `stats`, `dfoptim`, `purrr`
* [GNU Make] (https://www.gnu.org/software/make/)

## Download
git clone -b EMfun --single-branch https://github.com/NonglongSu/EM_94.git  
cd playEM


## Usage
EM algo.    (https://en.wikipedia.org/wiki/Expectation%E2%80%93maximization_algorithm)   
Nmkb algo.  (https://rdrr.io/cran/dfoptim/man/nmkb.html)  
```
Usage: make target [OPTIONS]   

By default, if you don't have inputs, we have the default input in Makefile, and save the output file under Results/. 
  
**EM method**   
Simulation:  
  make par      [output]                                 generate a random parameter set (12) as the true value.  
  make sim_mg94 [input] [output] [codon length] [num]    obtain the parameter estimates using EM.    
    --input/output: a text file of one line of 12 parameters.   
    --codon length: the length of the codons, gaps excluded.  
    --num:          the number of codons, only two options (61 or 64).  
                       
Real data:  
make data_mg94  [input] [output] [num]                   obtain the parameter estimates using EM.  
  --input:  a fasta file of pairwise alignment (the alignment legnth must be multiple of three)
  --output: a text file of one line of 12 parameters. 
  --num:    the number of codons, 64/61.  

**Nmkb method** 
make sim_nmkb  [input] [output] [codon length] [num]      obtain the parameter estimates using nmkb.   
make data_nmkb [input] [output] [num]                     obtain the parameter estimates using nmkb.
 
make help                                                print this help message with all commands.   
```


## Sample runs
```
**Using default input**
make par    
make sim_mg94  
make data_mg94  


**set your your own input**
make par       ouF="yourownpara.txt"       
make sim_mg94  inF1="yourownpara.txt" ouF1="Results/est1.txt" len="1e+4" num="61"   
make data_mg94 inF2="yourownfasta.fa" ouF2="Results/est2.txt" num="61"   
make sim_nmkb  inF1="yourownpara.txt" ouF3="Results/est3.txt" len="1e+4" num="61"  
make data_nmkb inF2="yourownpara.txt" ouF4="Results/est4.txt" num="61"  
```