# Preparation
```
$ bgzip -c data.vcf > data.vcf.gz && tabix -p vcf data.vcf.gz
```

# BCFtools
```
$ bcftools view -I data.vcf.gz > data_remove_indels.vcf.gz
$ bcftools view -v snps data.vcf.gz > data_only_snps.vcf.gz
$ bcftools norm -d all data.vcf.gz -Oz -o data_remove_duplicate.vcf.gz  # snps|indels|both|all|exact
```
