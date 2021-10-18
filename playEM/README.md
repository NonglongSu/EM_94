## Synopsis
EM-MG94 is demonstration workflow for using the Expectation-Maximization algorithm to train the hidden substituion models **(GTR, MG94)**
to find the to find maximum-likelihood estimates for model parameters.  

## Dependencies
* [R 4.0 +]  (https://www.r-project.org/) and libraies `Biostrings`, `stringr`, `seqinr`, `R.utils`, `plyr`, `Matrix`, `expm`, `SQUAREM`, `jsonlite`, `matlib`, `ggplot2`, `tidyverse`, `stats`, `dfoptim`, `purrr`
* [GNU Make] (https://www.gnu.org/software/make/)

## Download
git clone -b EMfun --single-branch https://github.com/NonglongSu/EM-mg94.git  
cd playEM


## Usage
[EM]   training of the pairwise alignment as default.   (https://en.wikipedia.org/wiki/Expectation%E2%80%93maximization_algorithm)   
[NMKB] derivative-free optimization as an alternative.  (https://rdrr.io/cran/dfoptim/man/nmkb.html)  
```
Usage: make target [OPTIONS]   

By default, if you don't type options, we already prepare the input and save the output file under Results/. However, you can also asign your own command arguments.   
  
Simulation:  
  make par      [output]                                 generate a random parameter set as the true value.  
  make sim_mg94 [input] [output] [codon length] [num]    obtain all 12 parameter ests using EM.    
    --input/output: a text file of one line seperated by tab.  
    --codon length: the length of the codon alignment, if the codon length is 1000, then the seq length is 3000.  
    --num:          the number of codons, 61 excludes stop codons.  
                       
Real data:  
make data-mg94  [input] [output] [num]                   obtain all 12 parameter ests using EM.  
  --input:  a fasta file of pairwise alignment (the alignment legnth must be multiple of three)  
  --output: a text file of one line seperated by tab.
  --num:    the number of codons, 64/61.  

NMKB optimization method  
make sim_nmkb [input] [output] [codon length] [num]      obtain all 12 parameter ests using nmkb.   
make data-nmkb [input] [output] [num]                    obtain all 12 parameter ests using nmkb.
 
make help                                                print this help message with all commands and exit  
```


## Sample runs
```
make par    
make sim_mg94  
make data_mg94  

or...  

make par  [ouF="sample.txt"]       
make sim_mg94  inF1="yourownpara.txt" ouF1="Results/est1.txt" len="1e+4" num="61"   
make data_mg94 inF2="yourownfasta.fa" ouF2="Results/est2.txt" num="61"   
make sim_nmkb  inF1="yourownpara.txt" ouF3="Results/est3.txt" len="1e+4" num="61"  
make data_nmkb inF2="yourownpara.txt" ouF4="Results/est4.txt" num="61"  
```

