Para iniciar con el control de calidad yo utilice la carpeta de TallerGrupal_Ficheros, que contienen las carpetas de Genes, Fastqs y los archivos de Referencia.fasta y Transcrito a Gen.tsv. 
En la carpeta de Fastqs organice solamente las carpetas de Abraham, Homer, Marge, Patty y Selma (en zip) y se inicio con el control de calidad. 

# Control de Calidad
En esta etapa se realizó el filtrado y control de calidad.

## 1. Creación y Activación del Entorno 
Primero se creó el entorno de trabajo y se activó.

*conda create -vv -n Actividad2 -c bioconda -c conda-forge -c defaults -c r fastqc fastp multiqc*

*conda activate Actividad2* 

## 2. Creación de las Carpetas necesarias
Posteriormente se ingresa a al directorio donde queremos que se creen las carpetas y se crean las carpetas Quality, Raw Filtered y Trimmed 

*cd "/mnt/c/Users/hp/Desktop/Primer Cuatrimestre/Secuenciacion/Actividades/Actividad2/mubio03_act2/TallerGrupal_Ficheros/Fastqs"* 

(En mi caso esta es la direccion donde lo tengo guardado)

*mkdir -p Quality/Raw Quality/Filtered Trimmed*

## 3. Se realiza el control de calidad con FastQC

fastqc *fastq.gz -o Quality/Raw/ -t 32

## 4. Creación del archivo txt de las muestras y filtrado con bucle 
Se creó un archivo para incluir todos los nombres de las muestras en un fichero, por (muestras.txt), un identificador por línea y ejecutar el bucle:

ls *fastq.gz | cut -d _ -f 1 | sort -u > muestras.txt

for i in $(cat muestras.txt); do fastp --in1 $i*R1* --in2 $i*R2* --out1 Trimmed/$i"_R1_filtered.fastq.gz" --out2 Trimmed/$i"_R2_filtered.fastq.gz" --detect_adapter_for_pe --cut_front --cut_tail --cut_window_size 12 --cut_mean_quality 30 --length_required 35 --json Trimmed/$i.json --html Trimmed/$i.html --thread 32; done

## 5. Segundo Control de Calidad
Ejecutamos de nuevo un segundo control de calidad para corroborar que hemos realizado correctamente el filtrado.

fastqc Trimmed/*fastq.gz -o Quality/Filtered/ --threads 32

## 6. Generación de un Informe 
Generamos un informe resumen de los pasos que hemos realizado con multiqc .

*multiqc .*

# Alineamiento y Cuantificación con Salmon

En esta etapa del análisis de RNA-seq se realizó el pseudoalineamiento y la cuantificación transcriptómica utilizando Salmon. El objetivo fue obtener los archivos quant.sf para cada muestra, los cuales posteriormente fueron utilizados en R con tximport y DESeq2.

## 1. Acceso a la carpeta principal
Primero se ingresó a la carpeta principal donde se encontraba el archivo de referencia transcriptómica (Referencia.fasta).

cd "/mnt/c/Users/hp/Desktop/Primer Cuatrimestre/Secuenciacion/Actividades/Actividad2/mubio03_act2/TallerGrupal_Ficheros"

## 2. Creación del índice de Salmon
Posteriormente se creó el índice de Salmon a partir del archivo de referencia. 

salmon index -t Referencia.fasta -i salmon_index

## 3. Acceso a la carpeta FASTQ
Luego se ingresó a la carpeta donde estaban almacenadas las lecturas filtradas de FASTQ.

cd "/mnt/c/Users/hp/Desktop/Primer Cuatrimestre/Secuenciacion/Actividades/Actividad2/mubio03_act2/TallerGrupal_Ficheros/Fastqs/Trimmed"

## 4. Creación de carpeta de resultados
Se creó una carpeta para almacenar los resultados generados por Salmon.

mkdir -p resultados_salmon

## 5. Cuantificación con Salmon
Se ejecutó Salmon utilizando lecturas paired-end (R1 y R2) para cada muestra. (verificar la ruta de donde se guardó el índice)

__Abraham__

salmon quant -i ../../salmon_index -l A -1 AbrahamSimpson_R1_filtered.fastq.gz -2 AbrahamSimpson_R2_filtered.fastq.gz -p 4 -o resultados_salmon/Abraham

__Homer__

salmon quant -i ../../salmon_index -l A -1 HomerSimpson_R1_filtered.fastq.gz -2 HomerSimpson_R2_filtered.fastq.gz -p 4 -o resultados_salmon/Homer

__Marge__

salmon quant -i ../../salmon_index -l A -1 MargeSimpson_R1_filtered.fastq.gz -2 MargeSimpson_R2_filtered.fastq.gz -p 4 -o resultados_salmon/Marge

__Patty__

salmon quant -i ../../salmon_index -l A -1 PattyBouvier_R1_filtered.fastq.gz -2 PattyBouvier_R2_filtered.fastq.gz -p 4 -o resultados_salmon/Patty

__Selma__

salmon quant -i ../../salmon_index -l A -1 SelmaBouvier_R1_filtered.fastq.gz -2 SelmaBouvier_R2_filtered.fastq.gz -p 4 -o resultados_salmon/Selma

## 6. Archivos generados
Cada muestra generó un archivo quant.sf, utilizado posteriormente en el análisis diferencial.

resultados_salmon/Abraham/quant.sf

resultados_salmon/Homer/quant.sf

resultados_salmon/Marge/quant.sf

resultados_salmon/Patty/quant.sf

resultados_salmon/Selma/quant.sf

## 7. Uso posterior en R
Los archivos quant.sf fueron importados posteriormente en R mediante tximport y analizados con DESeq2 para realizar el análisis de expresión diferencial. Abrimos RStudio y creamos un nuevo script. (ver script en la carpeta de Trimmed)
