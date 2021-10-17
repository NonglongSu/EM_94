#EM-MG94 is demonstration workflow for using the Expectation-Maximization algorithm
#for training the hidden substituion models **(GTR, EM94)**
#to find the to find maximum-likelihood estimates for model parameters.

RSCRIPT = Rscript --vanilla
RM      = rm -i

default: all
all:
.PHONY: default all clean help
.PHONY: par sim_mg94 data_mg94 sim_nmkb data_nmkb



#######################################

#setup parameter space(true value)
override ouF  ?= "Results/rand_para.txt"

override inF1 ?= "Results/rand_para.txt"
override ouF1 ?= "Results/sim94_est.txt"
override len  ?= "1e+5"
override num  ?= "64"

override inF2 ?= "fasta/example.fa"
override ouF2 ?= "Results/data94_est.txt"

override ouF3 ?= "Results/sim_nmkb_est.txt"
override ouF4 ?= "Results/data_nmkb_est.txt"


#Genreate random true parameters
par:Script/para_space.R
	$(RSCRIPT) $< $(ouF)

#Simulation with MG94 model
sim_mg94:Script/sim_mg94.R
	$(RSCRIPT) $< $(inF1) $(ouF1) $(len) $(num)

#Real data analysis with MG94 model
data_mg94:Script/data_mg94.R
	$(RSCRIPT) $< $(inF2) $(ouF2) $(num)

#nmkb optimization
sim_nmkb:Script/sim_nmkb.R
	$(RSCRIPT) $< $(inF1) $(ouF3) $(len) $(num)

data_nmkb:Script/data_nmkb.R
	$(RSCRIPT) $< $(inF2) $(ouF4) $(num)

clean:
	@rm -i Results/*






help:
	@echo "make par:	create a single random parameter set".
	@echo "make sim_mg94	obtain all 12 parameter ests of simulated data using EM"
	@echo "make sim_mg94	obtain all 12 parameter ests of real data using EM"
	@echo "make sim_nmkb	obtain all 12 parameter ests of real data using nmkb"
	@echo "make data_nmkb	obtain all 12 parameter ests of real data using nmkb"
