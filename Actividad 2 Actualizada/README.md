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

