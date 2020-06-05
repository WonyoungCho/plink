**BCFtools** is a set of utilities that manipulate variant calls in the Variant Call Format (VCF) and its binary counterpart BCF. All commands work transparently with both VCFs and BCFs, both uncompressed and BGZF-compressed.

<http://samtools.github.io/bcftools/bcftools.html>


# Preparation
```
$ bgzip -c data.vcf > data.vcf.gz && tabix -p vcf data.vcf.gz
```

# Manipulation
```
$ bcftools view -I data.vcf.gz -Oz -o data_remove_indels.vcf.gz
$ bcftools view -v snps data.vcf.gz -Oz -o data_only_snps.vcf.gz
$ bcftools norm -d all data.vcf.gz -Oz -o data_remove_duplicate.vcf.gz  # snps|indels|both|all|exact
$ bcftools reheader -h heads.txt data.vcf.gz|bcftools view|less

```

# vcf-validator
<https://github.com/EBIvariation/vcf-validator/releases>
```
Usage: vcf-validator [OPTIONS] file.vcf.gz
Options:
   -d, --duplicates                 Warn about duplicate positions.
   -u, --unique-messages            Output all messages only once.
   -h, -?, --help                   This help message.
```

# vcf-compare
```
About: Compare bgzipped and tabix indexed VCF files. (E.g. bgzip file.vcf; tabix -p vcf file.vcf.gz)
Usage: vcf-compare [OPTIONS] file1.vcf file2.vcf ...
       vcf-compare -p plots chr1.cmp chr2.cmp ...
Options:
   -a, --apply-filters                 Ignore lines where FILTER column is anything else than PASS or '.'
   -c, --chromosomes <list|file>       Same as -r, left for backward compatibility. Please do not use as it will be dropped in the future.
   -d, --debug                         Debugging information. Giving the option multiple times increases verbosity
   -g, --cmp-genotypes                 Compare genotypes, not only positions
       --ignore-indels                 Exclude sites containing indels from genotype comparison
   -m, --name-mapping <list|file>      Use with -g when comparing files with differing column names. The argument to this options is a
                                           comma-separated list or one mapping per line in a file. The names are colon separated and must
                                           appear in the same order as the files on the command line.
       --INFO <string> [<int>]         Calculate genotype errors by INFO. Use zero based indecies if field has more than one value. Can be
                                           given multiple times.
   -p, --plot <prefix>                 Create plots. Multiple files (e.g. per-chromosome outputs from vcf-compare) can be given.
   -R, --refseq <file>                 Compare the actual sequence, not just positions. Use with -w to compare indels.
   -r, --regions <list|file>           Process the given regions (comma-separated list or one region per line in a file).
   -s, --samples <list|file>           Process only the listed samples. Excluding unwanted samples may increase performance considerably.
   -t, --title <string>                Title for graphs (see also -p)
   -w, --win <int>                     In repetitive sequences, the same indel can be called at different positions. Consider
                                           records this far apart as matching (be it a SNP or an indel).
   -h, -?, --help                      This help message.
```


# Plug fill-tags
<https://samtools.github.io/bcftools/howtos/plugin.fill-tags.html>

- AN .. Total number of alleles in called genotypes
- AC .. Allele count in genotypes
- NS .. Number of samples with data
- AC_Hom .. Allele counts in homozygous genotypes
- AC_Het .. Allele counts in heterozygous genotypes
- AC_Hemi .. Allele counts in hemizygous genotypes (haploid)
- AF .. Allele frequency
- MAF .. Minor Allele frequency
- HWE .. HWE test (PMID:15789306)

<https://github.com/samtools/bcftools/blob/develop/doc/bcftools.txt>

# Add allele frequency
```
$ bcftools +fill-tags data.vcf.gz -Ov -o out.vcf -- -t AF
```

# Remove by missing rate
- Remove variants which have missing values less than 10%.
```
$ bcftools view -i 'F_MISSING < 0.1' data.vcf.gz -Ov -o out.vcf
```
- Remove by number of missing values. (n*2)
```
$ bcftools view -i 'N_MISSING < 800' data.vcf.gz -Ov -o out.vcf
```

# Query
- Check samples
```
$ bcftools query -l data.vcf.gz
```
- Check chromosomes
```
$ bcftools index -s data.vcf.gz
```
- Check number of variants
```
$ bcftools index -n data.vcf.gz
```
