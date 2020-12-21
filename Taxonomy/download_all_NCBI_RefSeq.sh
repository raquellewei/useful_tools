###### Information:
# Aim: downloaod all COMPLETE bacteria genome/protein sequences from the NCBI database
# Input: none
# Output: a folder named NCBI_database at your current workdir 
# Note: this script would take ~10 hours and ~40GB storage with one thread.
# Programmer: Shaopeng Liu, sml6467@psu.edu
######



### some useful notes:
# database annotation file: README_assembly_summary.txt
# lots of species are imcomplete, check this condition if needed "{if($12=="Complete Genome" && $11=="latest")"



### pipe start
#!/bin/bash
date
echo "Downloading NCBI database, it may take several hours and ~40GB space!!!"

if [ -d NCBI_database ]; then
        echo "Resource folder NCBI_database already exists, please double check!"
else
        mkdir -p NCBI_database/genomes
        mkdir NCBI_database/proteins
        cd NCBI_database
        # download the annotation file
        wget -q ftp://ftp.ncbi.nlm.nih.gov/genomes/README_assembly_summary.txt
        # download the NCBI GenBank bacteria database
        wget -q -O NCBI_GenBank_bacteria_assembly_summary.txt ftp://ftp.ncbi.nlm.nih.gov/genomes/genbank/bacteria/assembly_summary.txt
        # clean the ref file for easy download in the future
        # only complete and latest genomes would be kept
        awk -F '\t'  '{if($12=="Complete Genome" && $11=="latest") print $20}' NCBI_GenBank_bacteria_assembly_summary.txt \
                > NCBI_GenBank_download_link.txt
        # complete list for quick search
        awk -F '\t' -v OFS='\t'  '{if($12=="Complete Genome" && $11=="latest") print $1,$5,$6,$7,$8}' NCBI_GenBank_bacteria_assembly_summary.txt | cat <(echo -e "accession\tref_category\ttaxid\tspecies_taxid\tname") - > NCBI_complete_genome_quick_list.txt
        # full record list for quick ref
        awk -F '\t' -v OFS='\t'  '{print $1,$5,$6,$7,$8}' NCBI_GenBank_bacteria_assembly_summary.txt | cat <(echo -e "accession\tref_category\ttaxid\tspecies_taxid\tname") - > NCBI_full_record_quick_ref.txt
        # download all genome files and protein files
        for file in $(cat NCBI_GenBank_download_link.txt); do
                suffix=$(echo ${file##*/})
                echo "downloading $suffix"
                wget -q ${file}/${suffix}_genomic.fna.gz 2>/dev/null
                wget -q ${file}/${suffix}_protein.faa.gz 2>/dev/null
        done
        mv *_genomic.fna.gz ./genomes
        mv *_protein.faa.gz ./proteins
        rm wget-log* 2>/dev/null
fi

echo "Downloading finished"
date
