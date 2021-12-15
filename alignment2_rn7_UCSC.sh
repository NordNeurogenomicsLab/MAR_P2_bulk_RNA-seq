#!/bin/sh

current_sample=$1

# Create directories

out_dir="/mnt/disks/data2/MAR"
bam_dir="${out_dir}/bam_UCSC"
mkdir -p ${out_dir}
mkdir -p ${bam_dir}

# STAR #

reads=/mnt/disks/data2/MAR/fastq/MAR2
star_index=/mnt/disks/data2/genomes/Rat/rn7_UCSC/STAR_index

STAR \
	--runMode alignReads \
	--runThreadN 16 \
	--genomeDir $star_index \
	--readFilesCommand gunzip -c \
	--outFileNamePrefix $bam_dir/"$current_sample"_ \
	--outSAMtype BAM SortedByCoordinate \
	--readFilesIn \
	$reads/"$current_sample"_1.fq.gz \
	$reads/"$current_sample"_2.fq.gz


