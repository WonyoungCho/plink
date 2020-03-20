# Selecting 1
- Select the specific region in a Bam file.
```
$ samtools view -b myfile.bam chr1:10000-20000 > chr1.myfile.bam
$ ls
myfile.bam  chr1.myfile.bam
```
```
parallel samtools view -b {} chr1 ">" chr1.{/} ::: *.bam
```

# Selecting 2
- Select the specific region from bed file.
```
$ samtools view -b myfile.bam -L exome.bed
```

# Indexing
- It generates index files with *bai* suffix.
```
$ for i in *.bam;do samtools index $i;done
$ ls
myfile.bam  myfile.bam.bai
```
```
$ parallel samtools index ::: *.bam
```

## Selecting & indexing
```
for i in {1..22} X Y; do mkdir chr$i; parallel samtools view -b {} chr$i ">" ./chr$i/chr$i.{/} ::: ../*.bam; parallel samtools index ::: ./chr$i/*.bam; done
```


# Sorting
```
$ samtools sort myfile.bam -o myfile.sorted.bam
```

# Tview
```
$ samtools tview -p chr22 myfile.bam hg38.fa

22758816
```
- g : `goto` =10000

# Extract
```
$ samtools view -b -h myfile.bam "chr22:10000-20000" > out.bam
```

