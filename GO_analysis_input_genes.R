GO_analysis_input_genes <- function(q, b, c) {
    
    #q <- DE_of_batches
    #b <- c("Th", "Sox9")
    #c = 8744
    
    library(topGO)
    background.genes <- q$gene_id
    geneUniverse <- background.genes
    
    #if(b=="upregulated"){
    #    test.genes <- dplyr::filter(q, FDR < 1e-100, logFC > 0)$gene_id
    #} else if (b=="downregulated"){
    #    test.genes <- dplyr::filter(q, FDR < 1e-100, logFC < 0)$gene_id
    #} else {
    #    print("Incorect fold change parameter")
    #    stop()
    #}
    
    test.genes <- b
    
    genesOfInterest <- test.genes
    geneList <- factor(as.integer(geneUniverse %in% genesOfInterest))
    names(geneList) <- geneUniverse
    myGOdata <- new("topGOdata", description="My project", ontology="BP", allGenes=geneList,  annot=annFUN.org,    mapping="org.Rn.eg.db", ID = "alias", nodeSize=5)
    print(myGOdata)
    
    resultFisher <- runTest(myGOdata, algorithm = "weight01", statistic = "fisher")
    #resultKS <- runTest(myGOdata, algorithm = "classic", statistic = "ks")
    #resultKS.elim <- runTest(myGOdata, algorithm = "elim", statistic = "ks")
    #classicKS = resultKS, elimKS = resultKS.elim, - add later
    
    allRes <- GenTable(myGOdata, classicFisher = resultFisher, orderBy = "classicFisher", topNodes = c)
    
    #showSigOfNodes(myGOdata, score(resultKS.elim), firstSigNodes = 5, useInfo = 'all')
    #nodes_plot <- recordPlot(showSigOfNodes(myGOdata, score(resultKS.elim), firstSigNodes = 5, useInfo = 'all'))
    
    #Building a df of DE genes belonging to top 20 GO BP caegories
    DE_genes_in_top_GO_cat <- function(r){
        #r = 1
        fisher.go <- allRes[r,1]
        #print(allRes[x,c(1,2)])
        fisher.ann.genes <- genesInTerm(myGOdata, whichGO=fisher.go)
        df <- data.frame(GO.ID = allRes[r,c(1)], Term = allRes[r,c(2)], 
                         gene_id=intersect(as.character(fisher.ann.genes[[1]]), q$gene_id))
        df <- dplyr::filter(df, gene_id %in% test.genes)
        df
    }
    
    list(allRes, lapply(1:50, function(r) DE_genes_in_top_GO_cat(r)))
}