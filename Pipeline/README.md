# Pipeline de Preprocesamiento de RNA-Seq (Nextflow)

Este directorio contiene un flujo de trabajo automatizado con **Nextflow** y **Docker** para realizar el control de calidad, filtrado y cuantificación de lecturas de RNA-Seq.

## Flujo del Pipeline
Los pasos abajo son ejecutados en cadena a través del archivo [`main.nf`](./main.nf). 

1. **`fastp`**: Control de calidad, filtrado de adaptadores y lecturas de baja calidad.
2. **`fastqc`**: Análisis de calidad visual de las lecturas filtradas.
3. **`multiqc`**: Agregación de informes de calidad en un único reporte interactivo HTML.
4. **`quantification` (Salmon)**: Creación del índice de transcriptoma y cuantificación de expresión (pseudoalineamiento).

---

## Instrucciones de Ejecución (Makefile)

Hemos incluido un `Makefile` para simplificar la ejecución del pipeline desde la consola. Puedes ejecutar las siguientes tareas:

*   **`make run`**: Limpia cualquier ejecución previa (caché e informes) y lanza el pipeline completo desde cero.
*   **`make resume`**: Reanuda la ejecución del pipeline desde el último paso completado con éxito (útil si se interrumpió o si cambiaste algún parámetro menor).
*   **`make clean`**: Borra los archivos temporales generados por Nextflow (`work/` y `.nextflow/`), los cuales pueden ocupar mucho espacio en disco.
*   **`make clean-results`**: Elimina la carpeta `Resultados/` generada por el pipeline.

---

## Parámetros y Cambio de Máquina (`nextflow.config`)

Si ejecutas este pipeline en una máquina diferente (con más o menos capacidad), debes revisar y ajustar los siguientes valores en el archivo `nextflow.config`:

1.  **Recursos del Sistema:**
    *   `cpus`: Número de hilos de CPU asignados a cada proceso (por defecto `4`).
    *   `memory`: Memoria RAM asignada a los procesos (por defecto `4.GB` globales, y `8.GB` para Salmon). Ajusta estos límites según la capacidad de tu equipo o servidor.

2.  **Motor de Contenedores:**
    *   Por defecto, el pipeline está configurado para ejecutarse utilizando **Docker** (`docker.enabled = true`). Asegúrate de tener el motor de Docker activo en tu sistema antes de lanzar el pipeline.
