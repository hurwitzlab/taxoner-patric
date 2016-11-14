dev.off()
DNA_1<-read.table("scores_DNA_1.txt")
DNA_2<-read.table("scores_DNA_2.txt")
DNA_3<-read.table("scores_DNA_3.txt")
DNA_4<-read.table("scores_DNA_4.txt")

pdf("scores_1_density.pdf")
plot(density(DNA_1$V1))
dev.off()
pdf("scores_1_histogram.pdf")
hist(DNA_1$V1)
dev.off()

pdf("scores_2_density.pdf")
plot(density(DNA_2$V1))
dev.off()
pdf("scores_2_histogram.pdf")
hist(DNA_2$V1)
dev.off()

pdf("scores_3_density.pdf")
plot(density(DNA_3$V1))
dev.off()
pdf("scores_3_histogram.pdf")
hist(DNA_3$V1)
dev.off()

pdf("scores_4_density.pdf")
plot(density(DNA_4$V1))
dev.off()
pdf("scores_4_histogram.pdf")
hist(DNA_4$V1)
dev.off()

#AFTER this, I used
#awk -F"\t" '$5 > N {print $0}' file1.tab > file2.tab
#to filter out scores that were N or lower
