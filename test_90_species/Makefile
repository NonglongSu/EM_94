#!/bin/bash
#EM analysis of 100 simulations and 90 real species pairs

default: all
all:    


.PHONY:  default all clean help
.PHONY:  para100  em100_5e em100_6e em100_7e plotEM100 plotRmse em90 boot90 plotEM plotCI nmkb100.1

RSCRIPT = Rscript --vanilla
MAFFT   = mafft --maxiterate 1000 --globalpair
RM      = rm -i
SCR     = Script

###########################################################PART III:EM study
#EM 100 simulations

#setup parameter space(true value)
para100:$(SCR)/para_space.R 
	$(RSCRIPT) $<



namelist:=$(shell test -f Results/simuList.txt && cat Results/simuList.txt)
#generate 100 simulations for sample size of {5e,6e,7e}
Results/est100:  em100_5e em100_6e em100_7e
em100_5e:      $(patsubst %, Results/est100/%.5e.json, $(namelist))
em100_6e:      $(patsubst %, Results/est100/%.6e.json, $(namelist))
em100_7e:      $(patsubst %, Results/est100/%.7e.json, $(namelist))


#5e
Results/est100/%.5e.json:$(SCR)/dumbEm_simu_100.R Results/truePar_100.txt  
	$(RSCRIPT) $< $@ $(word 2,$^) 
.INTERMEDIATE:Results/est100/%.5e.json
#6e
Results/est100/%.6e.json:$(SCR)/dumbEm_simu_100.R Results/truePar_100.txt  
	$(RSCRIPT) $< $@ $(word 2,$^) 

#7e
Results/est100/%.7e.json:$(SCR)/dumbEm_simu_100.R Results/truePar_100.txt  
	$(RSCRIPT) $< $@ $(word 2,$^) 

#plot true~est
plotEM100:$(SCR)/em_100_est.R Results/truePar_100.txt Results/est100 
	for num in 5e 6e 7e; do \
		$(RSCRIPT) $< $(word 2,$^) $(word 3,$^) Figure/est100.$${num}.pdf Figure/qqplot.$${num}.pdf Results/rmse.$${num}.txt $${num}; \
	done

#plot sample size~rms
plotRmse:$(SCR)/plot_rmse.R Results 
	$(RSCRIPT) $< $(word 2,$^) Figure/rmse_size.pdf




namelist1:=$(shell test -f Results/specList.txt && cat Results/specList.txt)
Results/est90:	em90
Results/boot90: boot90
em90:	$(patsubst %, Results/est90/%.json,    $(namelist1))	
boot90: $(patsubst %, Results/boot90/%.10.json, $(namelist1))	

#EM 90 species
Results/est90/%.json:$(SCR)/dumbEm_90.R Raw_data/concat 
	$(RSCRIPT) $< $@ $(word 2,$^) 

#bootstrapping 90 ests
Results/boot90/%.json:$(SCR)/dumbEm_boot_90.R Raw_data/concat Results/est90 
	$(RSCRIPT) $< $@ $(word 2,$^) $(word 3,$^) 


#Plot 90 EM ests.
plotEM: $(SCR)/em90_est.R Results/est90 
	$(RSCRIPT) $< $(word 2,$^) Figure/est90.pdf Figure/omega_tau.pdf


plotCI: $(SCR)/em90_CI.R Results/boot90 Results/specList.txt Results/CI90 
	$(RSCRIPT) $< $(word 2,$^) $(word 3,$^) $(word 4,$^)  Figure/omega_tau_CI.pdf



#################################################################
#nmkb(Nelder-Mead  algorithm  for  derivative-free  optimization)

#generate 100 simulations for sample size of 5e
#modify the nmkb package
Results/nmkb100.1:nmkb100.1
nmkb100.1:$(patsubst %, Results/nmkb100.1/%.5e.json, $(namelist))
Results/nmkb100.1/%.5e.json:$(SCR)/nmkb_100_1.R Results/truePar_100.txt  
	$(RSCRIPT) $< $@ $(word 2,$^) 


clean: 
	@rm -i Figure/*
	@rm -i Results/boot90/*
	@rm -i Results/CI90/*
	@rm -i Results/est90/*
	@rm -i Results/est100/*
	@rm -i Results/nmkb100.1/*
	@rm -i Results/rmse*.txt


help:
	@echo "make para100:	setup 100 true parameters."
	@echo "make em100_5e:	run em on 100 samples with sample size 10^5e."
	@echo "make em100_6e:	run em on 100 samples with sample size 10^6e."
	@echo "make em100_7e:	run em on 100 samples with sample size 10^7e."
	@echo "make plotEM100:	generate qqplot of true values~para estimates."
	@echo "make plotRmse:	generate correaltion plot of rmse~sample sizse."
	@echo "make em90:	run em on 90 species pairs."
	@echo "make boot90:	bootstrapping on 90 species pairs."
	@echo "make plotEM:	generate distribution plot of 8 paras of 90 species pairs."
	@echo "make plotCI:	generate correaltion plot of omega~tau with CI of 90 species pairs."
	@echo "make nmkb100.1:	run nmkb method on 100 samples with sample size of 10^5e."

