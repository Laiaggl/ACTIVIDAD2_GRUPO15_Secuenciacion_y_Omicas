rm(list = ls())

set.seed(123)

paquetes <- c(
  "tximport",
  "dplyr",
  "DESeq2",
  "EnhancedVolcano",
  "pheatmap",
  "clusterProfiler", 
  "org.Hs.eg.db", 
  "ReactomePA", 
  "enrichplot",
  "flextable",
  "tibble"
)


for (p in paquetes) {
  library(p, character.only = TRUE)
}

if (!requireNamespace("BiocManager", quietly = TRUE)) {
  install.packages("BiocManager")
}

for (p in paquetes) {
  if (!require(p, character.only = TRUE)) {
    BiocManager::install(p)
    library(p, character.only = TRUE)
  }
}




##### PEPARACIÓN DE DATOS

# Leer archivos sf Laia
rnaseq_sf <- c(
  "Quantified/AbrahamSimpson/quant.sf",
  "Quantified/HomerSimpson/quant.sf",
  "Quantified/MargeSimpson/quant.sf",
  "Quantified/PattyBouvier/quant.sf",
  "Quantified/SelmaBouvier/quant.sf"
)

# Leer archivos sf Sara
rnaseq_sf <- c(
  "Salmon/AbrahamSimpson/quant.sf",
  "Salmon/HomerSimpson/quant.sf",
  "Salmon/MargeSimpson/quant.sf",
  "Salmon/PattyBouvier/quant.sf",
  "Salmon/SelmaBouvier/quant.sf"
)


# Asignar nombre de muestra a cada fila
names(rnaseq_sf) <- c("AbrahamSimpson", "HomerSimpson", "MargeSimpson", "PattyBouvier", "SelmaBouvier")


# Importar diseño del experimento
getwd()
setwd("/Users/sara/Desktop/SeqOAct2")
tx2gene <- read.table("Transcrito_a_Gen.tsv", header = FALSE, sep = "\t")
colnames(tx2gene) <- c("txname", "geneid")

# Importar archivos sf
txi <- tximport(rnaseq_sf, type = "salmon", tx2gene = tx2gene)


# Generar matriz conteos resultados RNAseq
matrix_counts <- txi$counts
data_table <- as.data.frame(matrix_counts) %>%
  rownames_to_column(var = "genid")

# Generar metadatos (diseño) 
metadata <- data.frame(
  sample_id = c("AbrahamSimpson", "HomerSimpson", "MargeSimpson", "PattyBouvier", "SelmaBouvier"),
  condition = factor(
    c("obeso1", "obeso1", "obeso2", "obeso2", "obeso2"),
    levels = c("obeso1", "obeso2")
  ),
  age = c(80, 40, 38, 40, 40),
  sex = factor(
    c("M", "M", "F", "F", "F"),
    levels = c("M", "F")
  )
)




##### DESEQ 

# Redondear datos del conteo de RNAseq
matrix_counts <- round(matrix_counts)

# Generar DESeq por condición
dds <- DESeqDataSetFromMatrix(countData=matrix_counts, colData=metadata, design=~condition)

# Filtramos genes con bajo conteo para mejorar la calidad del análisis
dds <- dds[rowSums(counts(dds)) > 10, ]

# Otención de resultados
dds <- DESeq(dds)
resultadodeseq = results(dds, contrast=c("condition", "obeso1", "obeso2"), alpha=1e-3) 
resultadodeseq
resultadodeseq_df <- as.data.frame(resultadodeseq)


# MA Plot (al haber tan pocos datos no creo que sea muy útil la verdad)
plotMA(resultadodeseq)


# Volcano Plot 
EnhancedVolcano(
  resultadodeseq,
  lab = rownames(resultadodeseq),
  x = 'log2FoldChange',
  y = 'pvalue',
  title = "Expresión diferencial",
  subtitle = "",
  labSize = 8,
  pointSize = 6,
  axisLabSize = 16
) +
  theme(
    plot.title = element_text(size = 25 ,hjust = 0.5),
    axis.title = element_text(size = 16),
    axis.text = element_text(size = 14)  
  )



##### HEATMAP

vsd <- varianceStabilizingTransformation(dds, blind = FALSE) ## Aplica la transformación vst() (variance-stabilizing transformation) de DESeq2 al objeto dds
mat <- assay(vsd)[(rownames(resultadodeseq)), ] ## Extrae la matriz de expresión transformada (filas = genes, columnas = muestras)
rownames(mat) <- rownames(resultadodeseq_df) ## Reemplaza los identificadores de fila por nombres de genes
mat <- mat[apply(mat, 1, var) > 0, ]
mat_scaled <- t(scale(t(mat))) # Escala y transpone la matriz

pheatmap(mat_scaled,
         cluster_rows = TRUE,
         cluster_cols = TRUE,
         annotation_col = as.data.frame(colData(dds)[, "condition", drop = FALSE]),
         show_rownames = TRUE,
         show_colnames = TRUE,
         fontsize_row = 8,
         fontsize_col = 8,
         color = colorRampPalette(c("blue", "white", "red"))(50),
         main = "HeatMap All Genes")


##### HEATMAP TOP 10 GENES 
res_orderedv1 <- resultadodeseq[order(resultadodeseq$padj), ]
top10_genesv1 <- rownames(head(res_orderedv1, 10))
mat_subsetv1 <- mat_scaled[top10_genesv1, ]
colnames(mat_subsetv1) <- c("Abraham","Homer","Marge","Patty","Selma")

pheatmapv1 <- pheatmap(
  mat_subsetv1,
  cluster_rows = TRUE,
  cluster_cols = TRUE,
  annotation_col = as.data.frame(colData(dds)[, "condition", drop = FALSE]),
  show_rownames = TRUE,
  show_colnames = TRUE,
  fontsize_row = 14,
  fontsize_col = 15,
  frontsize_main = 35,
  color = colorRampPalette(c("navy", "white", "firebrick3"))(100),
  border_color = NA,
  angle_col = 45,
  cellwidth = 80, 
  cellheight = 30, 
  main = "Top 10 genes diferencialmente expresados"
)


##### ENRIQUECIMIENTO

## Creamos un conjunto de datos con símbolos únicos y los resultados de significancia
genes_df <- unique(data.frame(symbol = rownames(resultadodeseq_df),
                              log2FC = resultadodeseq_df$log2FoldChange,
                              padj = resultadodeseq_df$padj,
                              stringsAsFactors = FALSE))

## Eliminamos aquellos genes que no tienen nomenclatura, podríamos eliminar incluso con algún valor faltante
genes_df <- genes_df[!is.na(genes_df$symbol) & genes_df$symbol != "", ]

## Asociamos cada nombre de gen con el identificador de la base de datos ENTREZID
map <- bitr(genes_df$symbol,
            fromType = "SYMBOL",
            toType   = c("ENTREZID"),
            OrgDb    = org.Hs.eg.db)
## Unimos ambos datos
genes_mapped <- merge(genes_df, map, by.x = "symbol", by.y = "SYMBOL")
nrow(genes_df); nrow(genes_mapped) # Comprobamos duplicados: un nombre puede mapear a >1 ENTREZ (rara vez)
universe_entrez <- unique(map$ENTREZID) # Creamos el objeto de elementos únicos para los análisis

## Over-Representation Analysis (ORA)
sig_genes <- genes_mapped
length(sig_genes$ENTREZID)


### ORA: enrichGO (Biological Process)
ego_bp <- enrichGO(gene = sig_genes$ENTREZID,
                   OrgDb = org.Hs.eg.db,
                   keyType = "ENTREZID",
                   ont = "BP",
                   pAdjustMethod = "BH",
                   minGSSize = 2,
                   maxGSSize = 800,
                   pvalueCutoff = 1,
                   qvalueCutoff = 1)

plot_bp <- dotplot(ego_bp, showCategory = 10) + 
  ggtitle("Procesos biológicos asociados") +
  theme(
    plot.title = element_text(
      hjust = 0.5,
      face = "bold",
      size = 16
    ),
    axis.text.y=element_text(size=12))
plot_bp

BiocManager::install("reactome.db")
library("ReactomePA")

e_reactome <- enrichPathway(gene = sig_genes$ENTREZID,
                            organism = "human",
                            pvalueCutoff = 1,
                            pAdjustMethod = "BH",
                            minGSSize = 2,
                            qvalueCutoff = 1)
plot_reactome <- dotplot(e_reactome, showCategory = 20) + ggtitle("Reactome enrichment (ORA)") + theme(axis.text.y=element_text(size=6))
plot_reactome








