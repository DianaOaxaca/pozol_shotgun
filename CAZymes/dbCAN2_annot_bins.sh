#####CAZYME DBCAN2 ANNOTATION ON BINS############
# !/usr/bin/bash
# Rafael López-Sánchez
#March 18 2021
Original Recipe made by DBCAN2 and Diana H. Oaxaca. Modifications made by Rafael López Sánchez
######################################## dbCAN HMMdb release 9.0 #########################################################################################################################################################################
# 08/04/2020
# total 681 CAZyme HMMs (434 family HMMs + 3 cellulosome HMMs + 244 subfamily HMMs)
# data based on CAZyDB released on 07/30/2020
# New family models (total 15): CBM86, CBM87, GH166, GH167, GH168, GT108, GT109, GT110, GT111, PL38, PL39, PL40, CE17, CE18, CBM35inCE17 (CBM35 co-exist with CE17, classic CBM35 model can't find the CBM in CE17 proteins or find with very marginal e-value, may deserve a new CBM fam number) 
# New subfamily models (total 27): GH16_10, GH16_11, GH16_12, GH16_13, GH16_14, GH16_15, GH16_16, GH16_17, GH16_18, GH16_19, GH16_1, GH16_20, GH16_21, GH16_22, GH16_23, GH16_24, GH16_25, GH16_26, GH16_27, GH16_2, GH16_3, GH16_4, GH16_5, GH16_6, GH16_7, GH16_8, GH16_9
# Deleted: CE10, GT46
# Updated: CBM35
# questions/comments to Yanbin Yin: yanbin.yin@gmail.com
###########################################################################################################################################################################################################################################
Cols in hmmer.out:
1. Family HMM
2. HMM length
3. Query ID
4. Query length
5. E-value (how similar to the family HMM)
6. HMM start
7. HMM end
8. Query start
9. Query end
10. Coverage

** About what E-value and Coverage cutoff thresholds you should use (in order to further parse yourfile.out.dm.ps file), we have done some evaluation analyses using arabidopsis, rice, Aspergillus nidulans FGSC A4, Saccharomyces cerevisiae S288c and Escherichia coli K-12 MG1655, Clostridium thermocellum ATCC 27405 and Anaerocellum thermophilum DSM 6725. Our suggestion is that for plants, use E-value < 1e-23 and coverage > 0.2; for bacteria, use E-value < 1e-18 and coverage > 0.35; and for fungi, use E-value < 1e-17 and coverage > 0.45.
** We have also performed evaluation for the five CAZyme classes separately, which suggests that the best threshold varies for different CAZyme classes (please see http://www.ncbi.nlm.nih.gov/pmc/articles/PMC4132414/ for details). Basically to annotate GH proteins, one should use a very relax coverage cutoff or the sensitivity will be low (Supplementary Tables S4 and S9); (ii) to annotate CE families a very stringent E-value cutoff and coverage cutoff should be used; otherwise the precision will be very low due to a very high false positive rate (Supplementary Tables S5 and S10)
** On our dbCAN2 website, we use E-value < 1e-15 and coverage > 0.35, which is more stringent than the default ones in hmmscan-parser.sh

# 1. Filter data.

1.1 Cut columns 1,3 for the hmmer.out file
$ for cosa in $(cat list.txt);do(cd $cosa/ && cut -f1,3 hmmer2.txt  | sort -n > proteins.txt );done


# 1.2 Remove the .hmm from the CAZy modules
$ for cosa in $(cat list.txt);do(cd $cosa/ && sed -i 's/\.hmm//' proteins.txt );done


# 1.3 Cut the first column of the proteins.txt file.
$ for cosa in $(cat list.txt);do(cd $cosa/ && cut -f1 proteins.txt > proteins.only.txt);done


# 1.4 Make the proteins.count file with uniq counts. 
$ for cosa in $(cat list.txt);do(cd $cosa/ && uniq -c proteins.only.txt > proteins.count);done


# 1.5  Concatenate all only.txt files in all.only.txt.
$ for cosa in $(cat list.txt);do(cd $cosa/ && cat *.only.txt > all.only.txt);done


# 1.6 Make a for loop to sort all.only.txt files and get the uniq counts.
$ for cosa in $(cat list.txt);do(cd $cosa/ && sort all.only.txt |  uniq -c  > all.uniq.count);done


# 1.7 Get all uniq modules.
$ for cosa in $(cat list.txt);do(cd $cosa/ && sort all.only.txt |  uniq   > all.uniq);done


# 1.8 Get the full module count.
$ for cosa in $(cat list.txt);do(cd $cosa/ && for s in $(cat all.uniq); do (grep -c -w $s proteins.only.txt >> proteins.full_count);done;)done


# 1.9 Get the file with the module and count.
$ for cosa in $(cat list.txt);do(cd $cosa/ && paste all.uniq proteins.full_count > cazy_counts.txt);done


#2. Create count matrix.
for cosa in $(cat ../list.txt); do (ln -s /dos/rafaells/Pozol_2021/dbCAN2/$cosa/cazy_counts.txt $cosa);done

#2.1 Integrate all bin matrixes in one. We do this with Alejandra's Escobar Zepeda matrix_integrator_bmk.pl script and a list with all the metagenomes.
$ ~/scripts/matrix_integrator_bmk.pl ../list.txt

