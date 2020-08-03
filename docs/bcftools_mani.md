**BCFtools** is a set of utilities that manipulate variant calls in the Variant Call Format (VCF) and its binary counterpart BCF. All commands work transparently with both VCFs and BCFs, both uncompressed and BGZF-compressed.

- GitHub : <https://github.com/samtools/bcftools>
- Manual : <http://samtools.github.io/bcftools/bcftools.html>
- Document : <https://samtools.github.io/bcftools/howtos/index.html>
- Download : <http://www.htslib.org/download/>

# Preparation
```
$ bgzip -c data.vcf > data.vcf.gz && tabix -p vcf data.vcf.gz # data.vcf.gz.tbi
$ bcftools view data.vcf -Oz -o data.vcf.gz && bcftools index data.vcf.gz (-c) # default : -c, data.vcf.gz.csi
$ bcftools view data.vcf -Oz -o data.vcf.gz && bcftools index data.vcf.gz -t # data.vcf.gz.tbi
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

# Filter
- Filter variants by a list file
```
$ bcftools filter -e 'ID=@varList.txt' data.vcf.gz
```

# Add gene
<https://www.biostars.org/p/122690/>
```
$ bcftools annotate data.vcf.gz -a genes.bed.gz -c CHROM,FROM,TO,GENE -h <(echo '##INFO=<ID=GENE,Number=1,Type=String,Description="Gene name">')
```
A few things to note:
- vcf and bed must have same format on chromosome and position (vcf : 1 6264553, bed : 1 6264487 6264607 ACOT7)
- genes.bed.gz must be a standard BED file that has been zipped using bgzip (bgzip genes.bed)
- genes.bed.gz must indexed using tabix (tabix -p bed genes.bed.gz)
- genes.bed.gz does not need a header (we define this with the -c option instead)
- 'CHROM', 'FROM', and 'TO' are required to be passed to the -c option, but these columns do not actually get added to your VCF (only the 'GENE' will get added)
- Because we're not annotating from a VCF/BCF file, the -h option is required (it will not work otherwise)
- Whatever we pass to the -h option will simply get added to the VCF meta-information

# Checks sample identity
<http://www.htslib.org/doc/bcftools.html#gtcheck>
```
$ bcftools gtcheck -G 1 data.vcf.gz
```
- CN, discordance : number of different genotypes
- ERR, error rate : number of differences divided by the total number of comparisons. (CN/totla genotypes)

# Multiallele
```
$ bcftools norm -m + data.vcf.gz
1 14356 A T
1 14356 A G
into
1 14356 A T,G

$ bcftools norm -m - data.vcf.gz # reverse way
```

# Add ID
```
$  bcftools annotate --set-id +'%CHROM\_%POS\_%REF\_%FIRST_ALT' data.vcf.gz
```

# Rename CHRM
```
$ for i in {1..22} X Y;do echo "chr${i} ${i}";done > rename_chrm.txt
$ bcftools annotate data.vcf.gz --rename-chrs rename_chrm.txt -Oz -o data_renamed.vcf.gz
```
