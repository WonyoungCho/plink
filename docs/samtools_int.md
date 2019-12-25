# Split Bam

```
$ samtools view -b myfile.bam chr1:10000-20000 > chr1.myfile.bam
$ ls
myfile.bam  chr1.myfile.bam
```
```
parallel samtools view -b {} chr1 ">" chr1.{/} ::: *.bam
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


