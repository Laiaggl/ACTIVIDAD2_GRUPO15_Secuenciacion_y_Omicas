# Commands executed

# Entorno
conda create -vv -n Actividad2 -c bioconda -c conda-forge -c defaults -c r fastqc fastp multiqc
conda activate Actividad2

# Carpetas de soporte
mkdir -p Quality/Raw Quality/Filtered Trimmed

# Verifica calidad
fastqc *fastq.gz -o Quality/Raw/ -t 6

# Filtrado
ls *fastq.gz | cut -d _ -f 1 | sort -u > muestras.txt
# Debemos quitar el comienzo y final?
for i in $(cat muestras.txt); do fastp --in1 $i*R1* --in2 $i*R2* --out1 Trimmed/$i"_R1_filtered.fastq.gz" --out2 Trimmed/$i"_R2_filtered.fastq.gz" --detect_adapter_for_pe --cut_front --cut_tail --cut_window_size 12 --cut_mean_quality 30 --length_required 35 --json Trimmed/$i.json --html Trimmed/$i.html --thread 6; done

# Verifica calidad
fastqc Trimmed/*fastq.gz -o Quality/Filtered/ --threads 6

# Genera informes de todo lo que se ha hecho hasta ahora
multiqc .

# Create index
salmon index -t TallerGrupal_Ficheros/Referencia.fasta -i salmon_index

# Pseudoalign + quantify
for i in $(cat muestras.txt); do salmon quant -i salmon_index -l A -1 $i"_R1.fastq.gz" -2 $i"_R2.fastq.gz" -o Quantified/$i; done