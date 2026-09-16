#perl step1.prepare_gene.pl whole_gene_region.hg38.bed > whole_gene_region.hg38.uniq.bed
#bigWigAverageOverBed ./0.source_eCLIP/K562.RBM15-human.GRCh38.merge.minus.bw whole_gene_region.hg38.uniq.bed out1.RBM15.minus.tab
#bigWigAverageOverBed ./0.source_eCLIP/K562.RBM15-human.GRCh38.merge.plus.bw whole_gene_region.hg38.uniq.bed out1.RBM15.plus.tab
#bigWigAverageOverBed ./0.source_eCLIP/input.K562.minus.bw whole_gene_region.hg38.uniq.bed out1.input.minus.tab
#bigWigAverageOverBed ./0.source_eCLIP/input.K562.plus.bw whole_gene_region.hg38.uniq.bed out1.input.plus.tab

perl step2.sort_gene_by_enrichment.pl whole_gene_region.hg38.uniq.bed out1.RBM15.plus.tab out1.RBM15.minus.tab out1.input.plus.tab out1.input.minus.tab > out2.gene_RBM15ratio.xls
