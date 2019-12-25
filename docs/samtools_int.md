# Split Bam

```
$ samtools view -b myfile.bam chr1:10000-20000 > chr1.myfile.bam
$ ls
myfile.bam  chr1.myfile.bam
```
```
parallel samtools view -b {} chr1 ">" chr1.{/} ::: *.bam
```
```
for i in {1..22} X Y; do mkdir chr$i; parallel samtools view -b {} chr$i ">" chr$i.{/} ::: ../*.bam; done
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

# Sorting
```
$ samtools sort myfile.bam -o myfile.sorted.bam
```


