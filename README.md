![Conda](https://img.shields.io/badge/Env-Conda-3498DB?style=for-the-badge&logo=anaconda&logoColor=white)
![FastQC](https://img.shields.io/badge/QualityControl-FastQC-blue?style=for-the-badge)
![Fastp](https://img.shields.io/badge/Filtering-Fastp-blue?style=for-the-badge)
![MultiQC](https://img.shields.io/badge/Report-MultiQC-green?style=for-the-badge)
![Salmon](https://img.shields.io/badge/Quantification-Salmon_1.10.3-orange?style=for-the-badge)
![R Language](https://img.shields.io/badge/Language-R-276DC3?style=for-the-badge&logo=r&logoColor=white)
![DESeq2](https://img.shields.io/badge/Analysis-DESeq2-purple?style=for-the-badge)
![EnhancedVolcano](https://img.shields.io/badge/Plot-Volcano-red?style=for-the-badge)
![ClusterProfiler](https://img.shields.io/badge/Enrichment-clusterProfiler-brightgreen?style=for-the-badge)
![Bioconductor](https://img.shields.io/badge/Bioconductor-3.20-blueviolet?style=for-the-badge&logo=bioconductor&logoColor=white)


# Expresión diferencial de genes relacionados con obesidad​

Este repositorio proporciona la infraestructura y el soporte técnico necesario para el análisis de expresión génica diferencial. El flujo de trabajo implementado permite procesar datos de secuenciación (RNA-seq) con el objetivo de identificar genes y rutas metabólicas que definan perfiles genéticos asociados a distintos estados de obesidad.

El estudio se centra en:
* **Análisis comparativo:** Evaluación de la expresión diferencial entre grupos de sujetos.
* **Identificación funcional:** Detección de genes clave y rutas metabólicas relevantes.
* **Procesamiento de datos:** Implementación de pipelines para el manejo de datos de RNA-seq a nivel de individuo.

## 📂 Estructura del Proyecto

El repositorio está organizado en las siguientes carpetas principales:

* **[Muestras](file:///Users/danielresende/Documents-copy/workspace/ACTIVIDAD2_GRUPO15_Secuenciacion_y_Omicas/Muestras):** Contiene los datos crudos de secuenciación pareada (`.fastq.gz`) de los individuos bajo estudio y el archivo de mapeo `Transcrito_a_Gen.tsv`, indispensable para tximport en la conversión a nivel de gen.
* **[Referencias](file:///Users/danielresende/Documents-copy/workspace/ACTIVIDAD2_GRUPO15_Secuenciacion_y_Omicas/Referencias):** Almacena la secuencia FASTA del genoma de referencia y una base de datos local organizada por genes, con secuencias completas y reportes asociados a los 37 genes de obesidad evaluados.
* **[Scripts](file:///Users/danielresende/Documents-copy/workspace/ACTIVIDAD2_GRUPO15_Secuenciacion_y_Omicas/Scripts):** Alberga las directrices de ejecución de control de calidad, filtrado y conteo (`control_calidad_y_conteo.md`) y el código R para análisis estadístico de expresión diferencial y enriquecimiento (`visualizacion_genes.R`).
* **[Gráficos](file:///Users/danielresende/Documents-copy/workspace/ACTIVIDAD2_GRUPO15_Secuenciacion_y_Omicas/Gra%CC%81ficos):** Reúne las salidas visuales del análisis, tales como diagramas de volcán (Volcano Plot), mapas de calor (Heatmap) y gráficos de puntos de enriquecimiento (Dotplot).
