
volcano_plot_label_Y_capped <- function(x, title) {
    
    #x <- dplyr::filter(x, PValue < 0.05)
    
    # x <- DE_b1 
    # title = "Batch_1"
    
    test <- ifelse(x$PValue, "Non significant")
    test <- ifelse(x$logFC > 0 & x$PValue <0.05, "PValue < 0.05 & logFC > 0", test)
    test <- ifelse(x$logFC < 0 & x$PValue <0.05, "PValue < 0.05 & logFC < 0", test)
    test <- ifelse(x$logFC > 0 & x$FDR <0.1, "FDR < 0.1 & logFC > 0", test)
    test <- ifelse(x$logFC < 0 & x$FDR <0.1, "FDR < 0.1 & logFC < 0", test)
    
    plotDat <- data.frame(x, Group=test)
    
    plotDat$logFC <- ifelse(plotDat$logFC > 1.5, 1.5, plotDat$logFC)
    plotDat$logFC <- ifelse(plotDat$logFC < -1.5, -1.5, plotDat$logFC)
    
    
    p <- ggplot(plotDat, aes(x = logFC, y=ifelse(-log10(PValue) > 6, 6, -log10(PValue)), label = gene_id, fill=Group, col = Group)) +
        geom_point(aes(text=gene_id), size=1, pch=21, alpha=0.7, stroke = 0.5)+
        theme_light()+
        geom_text_repel(aes(label=ifelse(FDR < 0.1, gene_id, "")))+
        scale_fill_manual(values=c("Non significant"="grey30", 
                                   "PValue < 0.05 & logFC > 0"="#eb5e60", 
                                   "PValue < 0.05 & logFC < 0"="#62a0ca", 
                                   "FDR < 0.1 & logFC > 0" = "#960304", 
                                   "FDR < 0.1 & logFC < 0" = "#01538a"))+
        scale_color_manual(values=c("Non significant"="grey30", 
                                    "PValue < 0.05 & logFC > 0"="#eb5e60", 
                                    "PValue < 0.05 & logFC < 0"="#62a0ca", 
                                    "FDR < 0.1 & logFC > 0" = "#960304", 
                                    "FDR < 0.1 & logFC < 0" = "#01538a"))+
        labs(title= title, y="-log10(PValue)", x="log2FC")+
        theme(plot.title = element_text(size = rel(2), hjust=0.5))+
        theme(legend.text=element_text(size=10))+
        theme(axis.text=element_text(size=14))+
        theme(legend.title=element_blank())+
        theme(axis.text=element_text(size=14))+
        theme(axis.title = element_text(size=14, face = "bold"))+
        theme(legend.position="bottom")+
        coord_cartesian(xlim = c(-1.7, 1.7))+
        geom_hline(yintercept = -log10(0.05), linetype=2)+
        scale_x_continuous(breaks=c(-1.5, -1, 0, 1, 1.5), labels=c("<-1.5", "-1", "0", "1", ">1.5"))+
        scale_y_continuous(breaks=c(0, 2, 4, 6), labels=c("0", "2", "4", ">6"))+
        theme(panel.grid.major = element_blank(),
              panel.grid.minor = element_blank())
    
    
    p
    
}