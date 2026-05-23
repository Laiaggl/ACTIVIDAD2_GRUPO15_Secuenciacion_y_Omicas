# Guía de Ejecución de los Scripts de Análisis

Este directorio contiene las herramientas y flujos de trabajo necesarios para procesar los datos de secuenciación crudos de RNA-seq hasta la obtención de perfiles de expresión diferencial y su posterior análisis de enriquecimiento funcional.

> [!WARNING]
Estos comandos fueron desarrollados para seren ejecutados en cadena, de una forma en que la salida del comando actual suele ser la entrada del próximo. De la misma manera, la salida de las instrucciones del archivo [`control_calidad_y_conteo.md`](./control_calidad_y_conteo.md) es la entrada para el script [`visualizacion_genes.R`](./visualizacion_genes.R). Por lo tanto, es fundamental ejecutarlos en orden.

---

## Flujo de Trabajo y Contenido

El análisis se divide en dos fases consecutivas y complementarias:

### Fase 1: Control de Calidad, Filtrado y Cuantificación
* **Instrucciones:** [`control_calidad_y_conteo.md`](./control_calidad_y_conteo.md)
* **Objetivo:** Preparar los datos crudos y cuantificar los transcritos.
* **Herramientas utilizadas (Entorno Conda):**
  * `FastQC`: Control de calidad visual de las lecturas crudas y filtradas.
  * `fastp`: Filtrado de adaptadores, eliminación de bases de baja calidad y lecturas cortas.
  * `MultiQC`: Agregación de todos los reportes de calidad en un único informe interactivo HTML.
  * `Salmon` (versión recomendada `1.10.3`): Creación de índice de transcriptoma y pseudoalineamiento rápido para cuantificar niveles de expresión (*transcripts abundance estimation*).

### Fase 2: Análisis Estadístico y Visualización en R
* **Script:** [`visualizacion_genes.R`](./visualizacion_genes.R)
* **Objetivo:** Determinar los genes con expresión diferencial significativa y analizar sus implicaciones biológicas.
* **Paquetes R claves:**
  * `tximport`: Importa las cuantificaciones de Salmon (`quant.sf`) y las agrupa a nivel de gen utilizando el mapa de referencia `Transcrito_a_Gen.tsv`.
  * `DESeq2`: Modelado estadístico y normalización de conteos para identificar genes diferencialmente expresados (DEGs) entre las condiciones del estudio (e.g., `obeso1` vs `obeso2`).
  * `EnhancedVolcano` & `pheatmap`: Generación de gráficos volcán y mapas de calor interactivos/estáticos con los genes y el top 10 de expresión diferencial.
  * `clusterProfiler` & `ReactomePA`: Análisis de enriquecimiento funcional mediante sobre-representación (ORA) para procesos biológicos (Gene Ontology - BP) y rutas metabólicas (Reactome).
  * `flextable` & `dplyr`: Formateo de tablas elegantes y manipulación ágil de datos biológicos.