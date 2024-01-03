
# download FuSeq_WES_v1.0.0/
#wget https://github.com/nghiavtr/FuSeq_WES/releases/download/v1.0.0/FuSeq_WES_v1.0.0/.tar.gz -O FuSeq_WES_v1.0.0/.tar.gz
#tar -xzvf FuSeq_WES_v1.0.0/.tar.gz

#configure FuSeq_WES
#cd FuSeq_WES_v1.0.0/
#bash configure.sh
#cd ..

# download test data
#wget https://www.meb.ki.se/sites/biostatwiki/wp-content/uploads/sites/4/2022/04/FuSeq_WES_testdata.tar.gz
#tar -xzvf FuSeq_WES_testdata.tar.gz

# download reference 
#wget https://www.meb.ki.se/sites/biostatwiki/wp-content/uploads/sites/4/2022/04/UCSC_hg19_wes_contigSize3000_bigLen130000_r100.tar.gz
#tar -xzvf UCSC_hg19_wes_contigSize3000_bigLen130000_r100.tar.gz

input="list.txt"

while IFS= read -r line
do
	echo "Starting ${line}"
	bamfile="/home/basecare/basespace/Projects/HCG_Samples_October_23/AppResults/${line}/Files/${line}.bam"
	ref_json="/home/basecare/Programs/FuSeq_WES_v1.0.0/UCSC_hg19_wes_contigSize3000_bigLen130000_r100/UCSC_hg19_wes_contigSize3000_bigLen130000_r100.json"
	gtfSqlite="/home/basecare/Programs/FuSeq_WES_v1.0.0/UCSC_hg19_wes_contigSize3000_bigLen130000_r100/UCSC_hg19_wes_contigSize3000_bigLen130000_r100.sqlite"

	output_dir="${line}_fusions"
	mkdir $output_dir

	#extract mapped reads and split reads
	python3 /home/basecare/Programs/FuSeq_WES_v1.0.0/fuseq_wes.py --bam $bamfile  --gtf $ref_json --mapq-filter --outdir $output_dir

	#process the reads
	fusiondbFn="/home/basecare/Programs/FuSeq_WES_v1.0.0/Data/Mitelman_fusiondb.RData"
	paralogdb="/home/basecare/Programs/FuSeq_WES_v1.0.0/Data/ensmbl_paralogs_grch37.RData"
	Rscript /home/basecare/Programs/FuSeq_WES_v1.0.0/process_fuseq_wes_test.R in=$output_dir sqlite=$gtfSqlite fusiondb=$fusiondbFn paralogdb=$paralogdbFn 	out=$output_dir
	Rscript /home/basecare/Programs/FuSeq_WES_v1.0.0/bedpeconvert.R $output_dir
	echo "Ending ${line}"
	
done < "$input"

echo "########## ALL FILES DONE ############"


#Rscript /home/bioinfoa/FuSeq_WES_v1.0.0/bedpeconvert.R 

# Fusion genes discovered by FuSeq_WES are stored in a file named FuSeq_WES_FusionFinal.txt
# the other information of split reads and mapped reads are also founded in the output folder

