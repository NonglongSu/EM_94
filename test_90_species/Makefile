#!/bin/bash
#90 species analysis

default: all
all:    


.PHONY:  default all clean
.PHONY:  rm_gap qMark test_mul3 test_preStop filter_3 aa aaFix align mapBack \
	 update_gap sw_gap phasing phasing_eff
.PHONY:  para100  rms100 em100_5e em100_6e em100_7e plotEM100 plotRmse em90 boot90 plotEM plotCI 
.PHONY:  cutFilter nmkb100 nmkb100.1

RSCRIPT = Rscript --vanilla
MAFFT   = mafft --maxiterate 1000 --globalpair
RM      = rm -i

SCR     = ../Script/90
WINDOW  = 6
WALL    = 12 
##################################################PART I####

#Remove all gaps
rm_gap: $(SCR)/gap_rm.sh Raw_data/cds/
	bash $< $(word 2,$^)	

#Replace "?" with "N" in ambiguous codons
qMark: $(SCR)/qMark_90.sh Raw_data/cds/
	bash $< $(word 2,$^)

#Record fasta files non-multiple-of-3.
test_mul3: $(SCR)/test_mul_90.R Raw_data/cds Raw_data/QC/Non3/
	$(RSCRIPT) $< $(word 2,$^) $(word 3,$^)

#Remove files of non-multiple-of-3
filter_3: $(SCR)/filter_90.sh Raw_data/QC/Non3 Raw_data/cds
	bash $< $(word 2,$^) $(word 3,$^)

#Record fasta files with pre-stop codons.
test_preStop: $(SCR)/test_preStop_90.R Raw_data/cds Raw_data/QC/Stop/
	$(RSCRIPT) $< $(word 2,$^) $(word 3,$^)


##########
#Translate dna to aa
aa:$(SCR)/dna2aa_90.R Raw_data/cds Raw_data/aa/	 
	$(RSCRIPT) $< $(word 2,$^) $(word 3,$^)            

#Convert '*'--->'X' in pre-stop codon.
aaFix: $(SCR)/preStop_90.R Raw_data/QC/Stop Raw_data/aa/ 
	$(RSCRIPT) $< $(word 2,$^) $(word 3,$^)

#Mafft alignment 
align: $(SCR)/align_90.sh Raw_data/aa Raw_data/align
	bash $< $(word 2,$^) $(word 3,$^)


#Remove any files contains "N" only.

#Map alignment back to dna
mapBack: $(SCR)/map_cds2aa_90.R  Raw_data/align Raw_data/cds 
	$(RSCRIPT) $< $(word 2,$^) $(word 3,$^) Raw_data/mapped_cds/



##########################################################PART II:Indel_continued
#Update gaps
update_gap: $(SCR)/update_gap_90.R Raw_data/mapped_cds Data/up_cds 
	$(RSCRIPT) $< $(word 2,$^) $(word 3,$^)  $(WINDOW) $(WALL)

#Slide gaps
sw_gap: $(SCR)/sw_gap_90.R Data/up_cds Data/sw_cds 
	$(RSCRIPT) $< $(word 2,$^) $(word 3,$^)  $(WINDOW) $(WALL)

#Phasing indels
phasing:$(SCR)/phase_indel_90.R Data/sw_cds 
	$(RSCRIPT) $< $(word 2,$^) Results/Phase.txt Figure/Phase.pdf $(WINDOW)

#Phasing effective indels
phasing_eff:$(SCR)/phase_indel_eff_90.R Data/sw_cds
	$(RSCRIPT) $< $(word 2,$^) Figure/phaes.eff.pdf


###########################################################PART III:EM study
#EM 100 simulations

#setup parameter space(true value)
para100:../Script/haha_para_space.R 
	$(RSCRIPT) $<


namelist:=$(shell test -f Results/simuList.txt && cat Results/simuList.txt)

#generate a relationship between rms and 100 sample size{5e..6e..7e}. 
Results/rms:rms100
rms100:     $(patsubst %, Results/rms/%.json, $(namelist))

#generate 100 simulations for sample size of {5e,6e,7e}
Results/est100:em100_5e em100_6e em100_7e
em100_5e:      $(patsubst %, Results/est100/%.5e.json, $(namelist))
em100_6e:      $(patsubst %, Results/est100/%.6e.json, $(namelist))
em100_7e:      $(patsubst %, Results/est100/%.7e.json, $(namelist))

#fail!
Results/rms/%.json:../Script/haha_61_aitken.R Results/truePar_100.txt
	$(RSCRIPT) $< $@ $(word 2,$^)  

#5e
Results/est100/%.5e.json:$(SCR)/dumbEm_simu_100.R Results/truePar_100.txt  
	$(RSCRIPT) $< $@ $(word 2,$^) 

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

#Artifact. 
#Measuring the filtering method. 
cutFilter:$(SCR)/cut_filter_90.R Raw_data/concat Raw_data/raw_cds Results/est90 
	$(RSCRIPT) $< $(word 2,$^) $(word 3,$^) $(word 4,$^) Figure/loss_of_filter.pdf




#################################################################
#Optimization -- "nmkb"(Nelder-Mead  algorithm  for  derivative-free  optimization)

#generate 100 simulations for sample size of {5e,6e,7e}
Results/nmkb100:nmkb100
nmkb100:        $(patsubst %, Results/nmkb100/%.5e.json, $(namelist))

Results/nmkb100/%.5e.json:$(SCR)/nmkb_100.R Results/truePar_100.txt  
	$(RSCRIPT) $< $@ $(word 2,$^) 

#modified nmkb package
Results/nmkb100.1:nmkb100.1
nmkb100.1:        $(patsubst %, Results/nmkb100.1/%.5e.json, $(namelist))

Results/nmkb100.1/%.5e.json:$(SCR)/nmkb_100_1.R Results/truePar_100.txt  
	$(RSCRIPT) $< $@ $(word 2,$^) 



