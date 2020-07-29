# Picard
<https://broadinstitute.github.io/picard/>

# remove duplicate
```
$ java -jar picard.jar MarkDuplicates I=myfile.bam O=myfile.dup.bam M=myfile.bam.met
```

```
$ find *.bam > bamList.txt
$ awk -F. '{print $1}' bamList.txt > bam.lst
$ while read line;do echo picard MarkDuplicates I=${line}.bam O=${line}.dup.bam M=${line}.bam.met;done < bam.lst > picard.cmd
$ parallel --bar -j 2 {} < picard.cmd
```
