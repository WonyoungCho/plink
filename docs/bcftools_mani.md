# Variant classification
<https://genome.sph.umich.edu/wiki/Variant_classification>

**Simple Biallelic Examples**

- SNP   :  REF  A   /  ALT  G     #SNP, 1 ts
- MNP   :  REF  AT  /  ALT  GC    #MNP, 2 ts
- INDEL :  REF  AT  /  ALT  A     #INDEL, 1 del
- INDEL :  REF  AT  /  ALT  T     #INDEL, 1 del
- SV    :  REF  A   /  ALT <DEL>  #SV

**Complex Biallelic Examples**

- SNP|INDEL      :  REF  AT         /  ALT  G           #SNP, INDEL, 1 ts
- MNP|INDEL      :  REF  ATT        /  ALT  GG          #MNP, INDEL, 1 ts, 1 tv, 1 del
- MNP|CLUMPED    :  REF  ATTTT      /  ALT  GTTTC       #MNP, CLUMPED, 2 ts
- INDEL|CLUMPED  :  REF  ATTTTTTTT  /  ALT  GTTTC       #INDEL, CLUMPED, 2 ts, 1 del

**Simple Multiallelic Examples**

- SNP   :  REF  A
> - ALT  G           #SNP, 1 ts
> - ALT  C           #SNP, 1 tv
- MNP   :  REF  AG
> - ALT  GC          #MNP, 1 ts, 1 tv
> - ALT  CT          #MNP, 2 tv 
- INDEL :  REF  ATTT    
> - ALT  ATT         #INDEL, 1 del
> - ALT  ATTTT       #INDEL, 1 ins

**Structured Variants Examples**

- SV  :  REF  G
> - ALT <INS:ME:LINE1>    #SV
- SV  :  REF  G
> - ALT <CN4>             #SV
> - ALT <CN12>            #SV


# Preparation
```
$ bgzip -c data.vcf > data.vcf.gz && tabix -p vcf data.vcf.gz
```

# BCFtools
```
$ bcftools view -I data.vcf.gz -Oz -o data_remove_indels.vcf.gz
$ bcftools view -v snps data.vcf.gz -Oz -o data_only_snps.vcf.gz
$ bcftools norm -d all data.vcf.gz -Oz -o data_remove_duplicate.vcf.gz  # snps|indels|both|all|exact
```
