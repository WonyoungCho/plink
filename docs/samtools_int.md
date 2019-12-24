# Split Bam

```
$ samtools view -b myfile.bam chr1:10000-20000 > chr1.myfile.bam
$ ls
myfile.bam  chr1.myfile.bam
```

# Indexing
- It generates index files with *bai*  filename extension.
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
Usage: samtools sort [options...] [in.bam]
Options:
  -l INT     Set compression level, from 0 (uncompressed) to 9 (best)
  -m INT     Set maximum memory per thread; suffix K/M/G recognized [768M]
  -n         Sort by read name
  -t TAG     Sort by value of TAG. Uses position as secondary index (or read name if -n is set)
  -o FILE    Write final output to FILE rather than standard output
  -T PREFIX  Write temporary files to PREFIX.nnnn.bam
  --no-PG    do not add a PG line
      --input-fmt-option OPT[=VAL]
               Specify a single input file format option in the form
               of OPTION or OPTION=VALUE
  -O, --output-fmt FORMAT[,OPT[=VAL]]...
               Specify output format (SAM, BAM, CRAM)
      --output-fmt-option OPT[=VAL]
               Specify a single output file format option in the form
               of OPTION or OPTION=VALUE
      --reference FILE
               Reference sequence FASTA FILE [null]
  -@, --threads INT
               Number of additional threads to use [0]
      --verbosity INT
               Set level of verbosity
```
```
$ samtools sort myfile.bam -o myfile.sorted.bam
```
