#!/bin/sh

current_sample=$1

### Step 0 ###
# Create directories
out_dir="/mnt/disks/data2/MAR"

bam_dir="${out_dir}/bam_UCSC"
bam_sorted_dir="${out_dir}/bam_sorted_dir_UCSC"
bam_sorted_dedup_dir="${out_dir}/bam_sorted_dedup_dir_UCSC"

#mkdir -p ${out_dir}
mkdir -p ${bam_sorted_dir}
mkdir -p ${bam_sorted_dedup_dir}


### Step 1 ###
# Build bam index 1#
java -Xmx100g -jar ~/bin/picard.jar BuildBamIndex \
	--INPUT $bam_dir/"$current_sample"_Aligned.sortedByCoord.out.bam

# Sorting w picard - probably unnecessary, but doesn't hurt#
java -Xmx100g -jar ~/bin/picard.jar SortSam \
	--INPUT $bam_dir/"$current_sample"_Aligned.sortedByCoord.out.bam \
	--OUTPUT $bam_sorted_dir/$current_sample.bam \
	--SORT_ORDER coordinate

# Build bam index 2 #
java -Xmx100g -jar ~/bin/picard.jar BuildBamIndex \
	--INPUT $bam_sorted_dir/"$current_sample".bam


### Step 2 ###
# Deduplicate #
java -Xmx100g -jar ~/bin/picard.jar MarkDuplicates REMOVE_DUPLICATES=true \
	INPUT= $bam_sorted_dir/"$current_sample".bam \
	OUTPUT= $bam_sorted_dedup_dir/"$current_sample".bam \
	METRICS_FILE= $bam_sorted_dedup_dir/"$current_sample".txt

# Build bam index 3 #
java -Xmx100g -jar ~/bin/picard.jar BuildBamIndex \
	--INPUT $bam_sorted_dedup_dir/"$current_sample".bam
# Remove files from Step 1
rm $bam_sorted_dir/$current_sample.bam
rm $bam_sorted_dir/$current_sample.bai

### Step 4 ###
featureCounts \
	-a /mnt/disks/data2/genomes/Rat/rn7_UCSC/refGene.gtf \
	-o $bam_sorted_dedup_dir/"$current_sample"_featureCount.txt \
	-T 1 \
	-t exon \
	-g gene_id \
	$bam_sorted_dedup_dir/"$current_sample".bam
# Remove files from Step 2
rm $bam_sorted_dedup_dir/"$current_sample".bam
rm $bam_sorted_dedup_dir/"$current_sample".bai
rm $bam_sorted_dedup_dir/"$current_sample".txt
