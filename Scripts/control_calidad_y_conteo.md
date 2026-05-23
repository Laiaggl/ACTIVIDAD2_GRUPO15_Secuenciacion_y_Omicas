> [!WARNING]
Estos comandos fueron desarrollados y probados considerando su ejecución en la raíz del proyecto. Si deseas ejecutarlos en otra carpeta, por favor, realiza los ajustes correspondientes en las rutas de los archivos y carpetas.

# Creación del entorno conda
```bash
conda create -vv -n EstudioObesidad -c bioconda -c conda-forge -c defaults -c r fastqc fastp multiqc salmon=1.10.3

conda activate EstudioObesidad
```

# Carpetas de soporte
```bash
mkdir -p Quality/Raw Quality/Filtered Trimmed
```

# Verifica calidad
```bash
fastqc *fastq.gz -o Quality/Raw/ -t 6
```

# Filtrado
```bash
ls *fastq.gz | cut -d _ -f 1 | sort -u > muestras.txt

for i in $(cat muestras.txt); do fastp --in1 $i*R1* --in2 $i*R2* --out1 Trimmed/$i"_R1_filtered.fastq.gz" --out2 Trimmed/$i"_R2_filtered.fastq.gz" --detect_adapter_for_pe --cut_front --cut_tail --cut_window_size 12 --cut_mean_quality 30 --length_required 35 --json Trimmed/$i.json --html Trimmed/$i.html --thread 6; done
```

# Verifica calidad
```bash
fastqc Trimmed/*fastq.gz -o Quality/Filtered/ --threads 6
```

# Genera informes de todo lo que se ha hecho hasta ahora
```bash
multiqc .
```

# Crear indice en Salmon basado en la referencia
```bash
salmon index -t Referencias/Referencia.fasta -i salmon_index
```

# Pseudoalineamiento + cuantificación
```bash
for i in $(cat muestras.txt); do salmon quant -i salmon_index -l A -1 "Trimmed/"$i"_R1_filtered.fastq.gz" -2 "Trimmed/"$i"_R2_filtered.fastq.gz" -o Quantified/$i; done
```