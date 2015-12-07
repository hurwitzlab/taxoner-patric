#Script to annotate and see species that are changed
#This is official NCBI species

setwd("~/Dropbox/Hurwitz Lab/NCBI-taxoner-species")

library(genomes)

DNA_1<-read.table('DNA_1_taxa_to_count.txt',col.names=c("taxid","DNA_1_count"))
DNA_2<-read.table('DNA_2_taxa_to_count.txt',col.names=c("taxid","DNA_2_count"))
DNA_3<-read.table('DNA_3_taxa_to_count.txt',col.names=c("taxid","DNA_3_count"))
DNA_4<-read.table('DNA_4_taxa_to_count.txt',col.names=c("taxid","DNA_4_count"))

temp<-merge(DNA_1,DNA_2,all = T)
temp2<-merge(DNA_3,DNA_4,all=T)
all_counts<-merge(temp,temp2,by="taxid",all=T)
all_counts[is.na(all_counts)]<-0
rm(temp,temp2)

# data(proks)
# data(euks)
# data(virus)
# just_names<-proks[,c("name","taxid")]
# just_names<-rbind(just_names,euks[,c("name","taxid")])
# just_names<-rbind(just_names,virus[,c("name","taxid")])

# all_counts_annot<-merge(all_counts,just_names,by="taxid",all.x=T)

lineage<-read.delim("genome_lineage")

#library(xlsx)
#write.xlsx(x = all_counts_annot,file = "counts_to_NCBI_taxonomy.xlsx")
