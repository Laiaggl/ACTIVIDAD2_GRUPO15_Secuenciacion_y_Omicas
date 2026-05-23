![Bash](https://img.shields.io/badge/Scripting-Bash-4EAA25?style=for-the-badge&logo=gnu-bash&logoColor=white)
![Conda](https://img.shields.io/badge/Env-Conda-3498DB?style=for-the-badge&logo=anaconda&logoColor=white)
![R Language](https://img.shields.io/badge/Language-R-276DC3?style=for-the-badge&logo=r&logoColor=white)
![Bioconductor](https://img.shields.io/badge/PackageManagement-Bioconductor-blueviolet?style=for-the-badge&logo=bioconductor&logoColor=white)
![FastQC](https://img.shields.io/badge/QualityControl-FastQC-blue?style=for-the-badge)
![Fastp](https://img.shields.io/badge/Filtering-Fastp-blue?style=for-the-badge)
![Salmon](https://img.shields.io/badge/Quantification-Salmon_-orange?style=for-the-badge)
![DESeq2](https://img.shields.io/badge/Analysis-DESeq2-purple?style=for-the-badge)


# Expresión diferencial de genes relacionados con obesidad​

Este repositorio proporciona la infraestructura y el soporte técnico necesario para el análisis de expresión génica diferencial. El flujo de trabajo implementado permite procesar datos de secuenciación (RNA-seq) con el objetivo de identificar genes y rutas metabólicas que definan perfiles genéticos asociados a distintos estados de obesidad.

El estudio se centra en:
* **Análisis comparativo:** Evaluación de la expresión diferencial entre grupos de sujetos.
* **Identificación funcional:** Detección de genes clave y rutas metabólicas relevantes.
* **Procesamiento de datos:** Implementación de pipelines para el manejo de datos de RNA-seq a nivel de individuo.

## Estructura del Proyecto

El repositorio está organizado en las siguientes carpetas principales:

* **Muestras:** Contiene los datos crudos de secuenciación pareada (`.fastq.gz`) de los individuos del estudio. 
* **Referencias:** Almacena la secuencia FASTA del genoma de referencia y una base de datos local organizada por genes, con secuencias completas y reportes asociados a los 37 genes de obesidad evaluados. El archivo de mapeo `Transcrito_a_Gen.tsv` es indispensable para tximport en la conversión de transcritos a nivel de gen.
* **Scripts:** Alberga las directrices de ejecución de control de calidad, filtrado y conteo y el código R para análisis estadístico de expresión diferencial y enriquecimiento. Esta carpeta tiene sus propias instrucciones en su archivo [README.md](./Scripts/README.md).
* **Gráficos:** Reúne las salidas visuales del análisis, tales como diagramas de volcán (Volcano Plot), mapas de calor (Heatmap) y gráficos de puntos de enriquecimiento (Dotplot), para una rápida visualización.

## Discussión y Resultados del estudio

La discussión y resultados obtenidos del estudio se pueden visualizar a través del [poster.pdf](./poster.pdf). 

