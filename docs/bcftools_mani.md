# Preparation
```
$ bgzip -c data.vcf > data.vcf.gz && tabix -p vcf data.vcf.gz
```

# BCFtools
```
$ bcftools view -I data.vcf.gz > data_remove_indels.vcf.gz


```
