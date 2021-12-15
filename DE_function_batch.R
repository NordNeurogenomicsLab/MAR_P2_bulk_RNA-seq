DE_function_batch <- function(seq_batch){
    
    min.cpm <- 1 
    # seq_batch = 2
    
    test_metadata <- dplyr::filter(metadata, RNA_seq_batch %in% seq_batch)
    
    test.data <- counts[,test_metadata$Count_colnames]
    rownames(test.data) <- counts$Geneid
    
    
    #dim(test.data)
    #dim(test_metadata)
    
    group <- test_metadata$Condition 
    
    design <- model.matrix(~factor(test_metadata$Sex, levels = c("M", "F"))+
                               factor(test_metadata$RNA_seq_batch, levels = c("1", "2"))+
                               factor(test_metadata$Condition, levels = c("Ctrl", "MAR")))
    
    #design <- model.matrix(~factor(test_metadata$Condition, levels = c("Ctrl", "MAR")))
    
    y <- DGEList(counts=test.data, group=group)
    keep <- rowSums(cpm(y)>min.cpm) >=2 #keeps only genes expressed in above min.cpm in at least 2 libraries in each group 
    
    y <- y[keep, , keep.lib.sizes=FALSE]
    
    y <- estimateGLMCommonDisp(y,design)
    
    y <- estimateGLMTrendedDisp(y,design)
    y <- estimateGLMTagwiseDisp(y,design)
    fit <- glmFit(y,design) 
    lrt <- glmLRT(fit) # Genewise Negative Binomial Generalized Linear Models.
    
    glm.output <- topTags(lrt, n=Inf)
    glm.output.full <- glm.output$table
    
    glm.output.full$gene_id <- rownames(glm.output.full)
    rownames(glm.output.full) <- NULL
    glm.output.full <- glm.output.full[,c(6,1:5)]
    
    glm.output.full
    
}