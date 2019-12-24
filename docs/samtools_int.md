# Split Bam

```
$ samtools view -b myfile.bam chr1:10000-20000 > chr1.myfile.bam
$ ls
myfile.bam  chr1.myfile.bam
```

# Indexing
- It generates index files with *bai* filename extension.
```
$ for i in *.bam;do samtools index $i;done
$ ls
myfile.bam  myfile.bam.bai
```

```
$ parallel  samtools index ::: *.bam
```
