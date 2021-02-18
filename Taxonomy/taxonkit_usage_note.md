### Readme
---
Last update: Shaopeng@2021.2.17

taxonkit is a fast and convenient tool to extract information from NCBI taxdump database, it's frequently used for 
   1. transfer between taxid <-> scientific name
   2. find linage of a given taxon label
   3. find the subtree (within the phylogenetic tree) of a given taxon label
   
references:
   1. [Github](https://github.com/shenwei356/taxonkit)
   2. [Manual](https://bioinf.shenwei.me/taxonkit/download/)
   
   
### Install
---
   1. install the software
      - by conda (recommended): `conda install -y -c bioconda taxonkit`
      - **OR** directly download the executive from [here](https://github.com/shenwei356/taxonkit/releases) and then untar it
   2. download and untar the NCBI taxdump file (this is necessary!) `wget ftp://ftp.ncbi.nih.gov/pub/taxonomy/taxdump.tar.gz`
   3. link those taxdump databases to "taxonkit"
      - by default, taxonkit assumes `~/.taxonkit` as the folder containing those files; however, we need to make our home folder clean.
      - taxonid has a flag "--data-dir" to change the default location, below is my example to use it:
      ```
      mkdir -p /data/sml6467/software/taxonkit_ref
      mv taxdump.tar.gz /data/sml6467/software/taxonkit_ref
      cd /data/sml6467/software/taxonkit_ref
      tar -xzf taxdump.tar.gz
      alias tk="taxonkit --data-dir /data/sml6467/software/taxonkit_ref"
      ```
      Then the cmd "tk" is called to run taxonkit
    
    
### Usage example (bash below, they also have python API, which is very lovely!)
---
   1. scientific name to taxid by `taxonkit name2taxid`.
   ```
   # simple example
   echo "Bacillus cereus" | tk name2taxid
   
   # try this cmd for a file in our server:
   awk '{print $1"\t"$2}' /data/sml6467/github/Koslicki_lab_metagenomic_analysis/3_mini_analysis/20210130_CAMISIM_errorfree_simulation/input_species.txt | tk name2taxid
   ```
   2. list subtree by `taxonkit list` (find sci name, subtree, species under a given taxid)
   ```
   # list all microbes:
   # 2 for bacteria, 2157 for archaea, 10239 for virus
   taxonkit list --ids 2,4751,10239 --indent "" > microbe.taxid.txt
   
   # find all phylum/family/genus in bacteria
   tk list --ids 2 --show-name --show-rank > all_bacteria.txt
   grep '\[phylum\]' all_bacteria.txt | sed 's/^[ \t]*//g' > all_phylum_record.txt
   grep '\[family\]' all_bacteria.txt | sed 's/^[ \t]*//g' > all_family_record.txt
   grep '\[genus\]' all_bacteria.txt | sed 's/^[ \t]*//g' > all_genus_record.txt
   
   # find all species under a given id: change "genus" to "species" in the cmd above
   ```
   3. generate linage information of a given taxid by `taxonkit lineage`
   ```
   echo 6656 | tk lineage
   ```
   4. try to play it : )
   
