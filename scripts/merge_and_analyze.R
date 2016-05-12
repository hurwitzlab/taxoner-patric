#Script to annotate and see species that are changed
#This is PATRIC species/strain
#Now modified for higher quality reads

setwd("~/Google Drive/Hurwitz Lab/PATRIC-taxoner-species/now-with-fastq/")

library(genomes)
library(xlsx)

DNA_1<-read.table('DNA_1_taxonomy_counts.txt',col.names=c("taxid","DNA_1_count"))
DNA_2<-read.table('DNA_2_taxonomy_counts.txt',col.names=c("taxid","DNA_2_count"))
DNA_3<-read.table('DNA_3_taxonomy_counts.txt',col.names=c("taxid","DNA_3_count"))
DNA_4<-read.table('DNA_4_taxonomy_counts.txt',col.names=c("taxid","DNA_4_count"))

#Species diversity####

#Taxid is for mycoplasma pumonis which should not be there at all (or undetectable levels). The cages are tested for this pathogen by Lab services

DNA_1[which(DNA_1$taxid=="272635"),]$DNA_1_count->a #161
DNA_1[which(DNA_1$DNA_1_count>a),]->DNA_1_filtered
DNA_2[which(DNA_2$taxid=="272635"),]$DNA_2_count->b #139
DNA_2[which(DNA_2$DNA_2_count>b),]->DNA_2_filtered
DNA_3[which(DNA_3$taxid=="272635"),]$DNA_3_count->c #132
DNA_3[which(DNA_3$DNA_3_count>c),]->DNA_3_filtered
DNA_4[which(DNA_4$taxid=="272635"),]$DNA_4_count->d #120
DNA_4[which(DNA_4$DNA_4_count>d),]->DNA_4_filtered

#Plotting####

sp_norm_1<-(length(unique(DNA_1_filtered$taxid))/sum(DNA_1_filtered$DNA_1_count))
sp_norm_2<-(length(unique(DNA_2_filtered$taxid))/sum(DNA_2_filtered$DNA_2_count))
sp_norm_3<-(length(unique(DNA_3_filtered$taxid))/sum(DNA_3_filtered$DNA_3_count))
sp_norm_4<-(length(unique(DNA_4_filtered$taxid))/sum(DNA_4_filtered$DNA_4_count))

barplot(c(length(unique(DNA_1$taxid)),
        length(unique(DNA_2$taxid)),
        length(unique(DNA_3$taxid)),
        length(unique(DNA_4$taxid))),
        names=c("DNA_1","DNA_2","DNA_3","DNA_4"),
        main="Number of species per group",
        sub="Alignment score >= 130")

barplot(c(length(unique(DNA_1_filtered$taxid)),
          length(unique(DNA_2_filtered$taxid)),
          length(unique(DNA_3_filtered$taxid)),
          length(unique(DNA_4_filtered$taxid))),
        names=c("DNA_1","DNA_2","DNA_3","DNA_4"),
        main="Number of species per group",
        sub="Alignment score >= 130 AND filtered using mycoplasma pulmonis")

barplot(c(sp_norm_1,sp_norm_2,sp_norm_3,sp_norm_4),
        names=c("DNA_1","DNA_2","DNA_3","DNA_4"),
        main="Number of species per group / Total number of counts",
        sub="Alignment score >= 130 AND filtered using mycoplasma pulmonis")

#Merging####

temp<-merge(DNA_1,DNA_2,all = T)
temp2<-merge(DNA_3,DNA_4,all=T)
all_counts<-merge(temp,temp2,by="taxid",all=T)
all_counts[is.na(all_counts)]<-0
rm(temp,temp2)

#OR

temp<-merge(DNA_1_filtered,DNA_2_filtered,all = T)
temp2<-merge(DNA_3_filtered,DNA_4_filtered,all=T)
all_counts<-merge(temp,temp2,by="taxid",all=T)
all_counts[is.na(all_counts)]<-0
rm(temp,temp2)

#sort of official NCBI taxonomy (I write "sort of" because on their website they disclaim their officialness and write, "Disclaimer: The NCBI taxonomy database is not an authoritative source for nomenclature or classification - please consult the relevant scientific literature for the most reliable information.")

#Annotating with NCBI####

data(proks)
update(proks)
data(virus)
update(virus)
data(euks)
update(euks)
just_names<-proks[,c("name","taxid")]
just_names<-rbind(just_names,euks[,c("name","taxid")])
just_names<-rbind(just_names,virus[,c("name","taxid")])

all_counts_annot<-merge(all_counts,just_names,by="taxid",all.x=T)
#Remove duplicates, duplicates come from the fact that there are multiple strains mapping to the same taxid
all_counts_annot<-all_counts_annot[!duplicated(all_counts_annot),]

#write.xlsx(x = all_counts_annot,file = "counts_to_PATRIC_taxonomy_NCBIannotation.xlsx")

#Annotating with PATRIC####

#Now using taxonomy from PATRIC, which includes full lineage
lineage<-read.delim("../genome_lineage")
lineageSmall<-lineage[,c("taxon_id","kingdom","phylum","class","order","family","genus","species","genome_name")]

all_counts_annot<-merge(all_counts,lineageSmall,by.x="taxid",by.y="taxon_id",all.x=T)
#Remove duplicates
all_counts_annot<-all_counts_annot[!duplicated(all_counts_annot),]

#write.xlsx(x = all_counts_annot,file = "counts_to_PATRIC_taxonomy_strain_level.xlsx")

#species level
lineage<-read.delim("../genome_lineage")
lineageSmall<-lineage[,c("taxon_id","kingdom","phylum","class","order","family","genus","species")]
all_counts_annot<-merge(all_counts,lineageSmall,by.x="taxid",by.y="taxon_id",all.x=T)
#Remove duplicates
all_counts_annot<-all_counts_annot[!duplicated(all_counts_annot),]

#write.xlsx(x = all_counts_annot,file = "counts_to_PATRIC_taxonomy_species_level.xlsx")

# Stuff with 1K genomes and fetching genome fastas ####

all_filtered_tax_id<-union(DNA_1_filtered$taxid,DNA_2_filtered$taxid)
all_filtered_tax_id<-union(all_filtered_tax_id,DNA_3_filtered$taxid)
all_filtered_tax_id<-union(all_filtered_tax_id,DNA_4_filtered$taxid)
lineage<-read.delim("../genome_lineage",colClasses="character")
lineage_just_ids<-lineage[,c(1:3)]
tax_ids_to_lineage_ids<-lineage_just_ids[(lineage_just_ids$taxon_id %in% all_filtered_tax_id),]
write.table(tax_ids_to_lineage_ids,"tax_ids_to_lineage_ids.txt",sep ="\t",quote = F,row.names = F)

#The End####
