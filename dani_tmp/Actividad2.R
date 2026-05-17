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

if (!requireNamespace("BiocManager", quietly = TRUE)) {
  install.packages("BiocManager")
}

for (p in paquetes) {
  if (!require(p, character.only = TRUE)) {
    BiocManager::install(p)
    library(p, character.only = TRUE)
  }
}

archivos_sf <- c(
  "Quantified/SelmaBouvier/quant.sf",
  "Quantified/PattyBouvier/quant.sf",
  "Quantified/MargeSimpson/quant.sf",
  "Quantified/HomerSimpson/quant.sf",
  "Quantified/AbrahamSimpson/quant.sf"
)

# Assign a clean name to each file.
names(archivos_sf) <- paste0("Muestra_", 1:5)



# Load the mapping file.
tx2gene <- read.table("TallerGrupal_ficheros/Transcrito_a_Gen.tsv", header = FALSE, sep = "\t")
colnames(tx2gene) <- c("TXNAME", "GENEID")

# Run tximport to consolidate everything.
txi <- tximport(archivos_sf, type = "salmon", tx2gene = tx2gene)


matriz_conteos_genes <- txi$counts
tabla_datos <- as.data.frame(matriz_conteos_genes) %>%
  rownames_to_column(var = "Gen")

tabla_count <- flextable(tabla_datos) %>%
  theme_vanilla() %>%
  set_header_labels(
    Gen = "Gen",
    Muestra_1 = "Muestra 1",
    Muestra_2 = "Muestra 2",
    Muestra_3 = "Muestra 3",
    Muestra_4 = "Muestra 4",
    Muestra_5 = "Muestra 5"
  ) %>%
  autofit()

tabla_count



metadata_muestras <- data.frame(
  muestra_id = paste0("Muestra_", 1:5),
  group = c("Obeso2", "Obeso2", "Obeso2", "Obeso1", "Obeso1"),
  name = c("Selma Bouvier", "Patty Bouvier", "Marge Simpson", "Homer Simpson", "Abraham Simpson")
)

metadata_muestras$group = factor(metadata_muestras$group, levels=c("Obeso1", "Obeso2"))

matriz_conteos_genes <- round(matriz_conteos_genes)

dds <- DESeqDataSetFromMatrix(countData=matriz_conteos_genes, colData=metadata_muestras, design=~group)

dds <- DESeq(dds)

res = results(dds, contrast=c("group", "Obeso1", "Obeso2"), alpha=1e-3) 
res

EnhancedVolcano(res, lab=rownames(res), x='log2FoldChange', y='pvalue', labSize = 3, axisLabSize = 10)


vsd <- varianceStabilizingTransformation(dds, blind = FALSE)
mat <- assay(vsd)[(rownames(res)), ]
rownames(mat) <- rownames(res)
mat <- mat[apply(mat, 1, var) > 0, ]
mat_scaled <- t(scale(t(mat)))
df_anotacion <- as.data.frame(colData(dds)[, c("group","sizeFactor")])
pheatmap(mat_scaled,
         cluster_rows = TRUE,
         cluster_cols = TRUE,
         annotation_col = df_anotacion,
         show_rownames = TRUE,
         show_colnames = TRUE,
         fontsize_row = 8,
         fontsize_col = 8,
         color = colorRampPalette(c("blue", "white", "red"))(50))


# ------------------------------------------------------------------------------
# 7. Análisis de enriquecimiento
# ------------------------------------------------------------------------------

## Creamos un conjunto de datos con símbolos únicos y los resultados de significancia
genes_df <- unique(data.frame(symbol = rownames(res),
                              log2FC = res$log2FoldChange,
                              padj = res$padj,
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

# ------------------------------------------------------------------------------
### ORA: enrichGO (Biological Process)
# ------------------------------------------------------------------------------

ego_bp <- enrichGO(gene = sig_genes$ENTREZID,
                   OrgDb = org.Hs.eg.db,
                   keyType = "ENTREZID",
                   ont = "BP",
                   pAdjustMethod = "BH",
                   minGSSize = 2,
                   maxGSSize = 800,
                   pvalueCutoff = 1,
                   qvalueCutoff = 1)

e_reactome <- enrichPathway(gene = sig_genes$ENTREZID,
                            organism = "human",
                            pvalueCutoff = 1,
                            pAdjustMethod = "BH",
                            minGSSize = 2,
                            qvalueCutoff = 1)
plot_bp <- dotplot(ego_bp, showCategory = 20) + ggtitle("GO:BP enrichment (ORA)") + theme(axis.text.y=element_text(size=8))
plot_bp

plot_reactome <- dotplot(e_reactome, showCategory = 20) + ggtitle("Reactome enrichment (ORA)") + theme(axis.text.y=element_text(size=6))
plot_reactome

ego_bp_symbol <- setReadable(ego_bp, OrgDb = org.Hs.eg.db, keyType = "ENTREZID")
plot_cnet <- cnetplot(ego_bp_symbol, showCategory = 20)
plot_cnet
