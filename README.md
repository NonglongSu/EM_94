## Synopsis
There are two branches of this repo. The **main** branch -- test_90_species is  the first chapter of my thesis for using the Expectation-Maximization algorithm to train the hidden substituion models **(GTR, EM94)** to find the to find maximum-likelihood estimates for model parameters. By following the directions, you can repeat my research.   
The **EMfun** brach is created to teach you how to play on a single sample to have a better understanding of the the model setup. 

## Dependencies
* [R 4.0 +]  (https://www.r-project.org/) and libraies `Biostrings`, `stringr`, `seqinr`, `R.utils`, `plyr`, `Matrix`, `expm`, `SQUAREM`, `jsonlite`, `matlib`, `ggplot2`, `tidyverse`, `stats`, `dfoptim`, `purrr`, `ggrepel`
* [GNU Make] (https://www.gnu.org/software/make/)

## Download
git clone https://github.com/NonglongSu/EM_94  
cd test_90_species          

## Usage  
* EM-training of 100 simulated coding sequences.   
* EM-training of 90 real species pairs.  

```
Usage: make help    show all useful commands 
```
