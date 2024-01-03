input="list.txt"
while IFS= read -r line
do
echo ">------BEDTOOLS INTERSECTION STARTING FOR SAMPLE ${line}------->"

intersectBed -abam /home/basecare/Programs/FuSeq_WES_v1.0.0/BAM_intersect/basespace/Projects/Somatic_Patient_Samples_July_23/AppResults/${line}/Files/${line}.bam -b knowngeneFusions.bed -f 1 > ${line}_intersected.bam

samtools index ${line}_intersected.bam

echo ">-----${line}_intersected.bam CREATED------<"

done < "$input"
echo "################## ALL FILES ARE DONE ###########################"
