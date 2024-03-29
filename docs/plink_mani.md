# Data

- Data file : [test_set2.csv](data/test_set2.csv) (<https://github.com/EpistasisLab/scikit-mdr/tree/master/data>)

## Liftover
If the data made by old version sych as hg19, refer below link and transform to latest version.

<https://shicheng-guo.github.io/bioinformatics/2017/08/01/hapmap3>

## vcf to bed
```
$ bgzip -c data.vcf > data.vcf.gz && tabix -p vcf data.vcf.gz
$ plink --vcf data.vcf.gz --make-bed --out data --double-id (or --const-fid)
$ plink --vcf data.vcf.gz --make-bed --out data --pheno data_pheno.txt --update-sex data_sex.txt
```
- When you convert vcf to bed, there could be a sample ordering problem.
```
$ plink --vcf data.vcf --keep-allele-order --indiv-sort file SampleOrder.lst --vcf-idspace-to _ --const-fid --make-bed --out data 
```

## bed to vcf
```
$ plilnk2 --bfile data --recode vcf --out data.vcf
```

## Update variant informatino
```
$ plink2 --bfile data --set-all-var-ids @_#_\$r_\$a --make-bed --out data_up
or
$ plink2 --bfile data --set-missing-var-ids @_#_\$r_\$a --make-bed --out data_up # only for missing variants
```
<https://www.cog-genomics.org/plink/2.0/data#set_all_var_ids>


## Genetic map
- insert cM in bim file
<https://www.cog-genomics.org/plink/1.9/input#cm_map>
```
$ plink --vcf data.vcf.gz --cm-map genetic_map_chr@_combined_b37.txt --make-bed --out data
or 
$ plink --bfile data --cm-map genetic_map_chr@_combined_b37.txt --make-just-bim --out data
```
<https://zzz.bwh.harvard.edu/plink/data.shtml#map>
- Most analyses do not require a genetic map to be specified in any case; specifying a genetic (cM) map is most crucial for a set of analyses that look for shared segments between individuals. For basic association testing, the genetic distance column can be set at 0.

## Recode allele type
<http://zzz.bwh.harvard.edu/plink/dataman.shtml>
```
$ plink --bfile mydata --recode --alleleACGT # 1234 to AGCT
$ plink --bfile mydata --recode --allele1234 # AGCT to 1234
$ plink --bfile mydata --recodeAD # Additive and dominance components, plink.raw
$ plink --bfile mydata --recode-rlist # Listing by minor allele count, plink.rlist
```

## Extract from samples
<https://www.cog-genomics.org/plink/1.9/filter>
```
$ plink --bfile mydata --keep sampleList.txt --make-bed --out mydata_sample
```
- In sampleList.txt, it should include **FamilyID** and **IndividualID**.
```
$ less sampleList.txt
HG00096	HG00096
HG00097	HG00097
HG00099	HG00099
HG00100	HG00100
HG00101	HG00101
HG00102	HG00102
HG00103	HG00103
```

## Adjust other phenotype
- case/control data
```
$ plink -bfile mydata --pheno phenotype.txt --make-bed --out mydata_gene
```
- In phenotype.txt, it should include **FamilyID**, **IndividualID** and **case/control_Phenotype**.
```
$ less phenotype.txt
HG00096	HG00096	1
HG00097	HG00097	2
HG00099	HG00099	2
HG00100	HG00100	2
HG00101	HG00101	1
HG00102	HG00102	2
HG00103	HG00103	1
```
If 'phenotype.txt has more than 1 phenotype in columns, then use --mpheno.
```
$ plink -bfile mydata --pheno phenotype.txt --mpheno 4 --make-bed --out mydata_gene # 4th phenotype is used.
$ cat phenotype.txt
fid iid pheno1 pheno2 pheno3 pheno4 pheno5
```

## Extract from genes
<https://www.cog-genomics.org/plink/1.9/filter#gene>
```
$ plink --bfile mydata --gene geneList.txt --make-bed --out mydata_gene
```
<https://www.cog-genomics.org/plink/1.9/formats#set>
```
$ less geneList.txt
GENE1
rs123456
rs10912
rs66222
END

GENE2 rs66222 rs929292
rs288222 END
```

## Extract from ranges
```
$ plink --bfile mydata --extract rangeList.txt --range --make-bed --out mydata_range
```
```
The format of myrange.txt should be, one range per line, whitespace-separated:

CHR Chromosome code (1-22, X, Y, XY, MT, 0)
BP1 Start of range, physical position in base units
BP2 End of range, as above
LABEL Name of range/gene

For example,
2 30000000 35000000 R1
2 60000000 62000000 R2
X 10000000 20000000 R3
```
<https://www.cog-genomics.org/plink/1.9/filter#snp>

## Make contig
```
$ awk '!/^#/ { a[$1]++ } END {for (i in a) print i,a[i]}' data.vcf|sort -V|awk '{print "##contig=<ID="$1",length="$2">"}'
```
