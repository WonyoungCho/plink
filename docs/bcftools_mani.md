**BCFtools** is a set of utilities that manipulate variant calls in the Variant Call Format (VCF) and its binary counterpart BCF. All commands work transparently with both VCFs and BCFs, both uncompressed and BGZF-compressed.

<http://samtools.github.io/bcftools/bcftools.html>

# Variant classification
<https://genome.sph.umich.edu/wiki/Variant_classification>

**Simple Biallelic Examples**
```
   SNP

   REF  A       
   ALT  G     #SNP, 1 ts  
```
```
   MNP

   REF  AT     
   ALT  GC    #MNP, 2 ts
```
```
   INDEL

   REF  AT      
   ALT  A     #INDEL, 1 del
```
```
   INDEL

   REF  AT      
   ALT  T     #INDEL, 1 del
              #Note that although the padding base differs - A vs T, this is actually a simple indel because it is simply a deletion of a A base.  
              #If you right align this instead of left aligning, then the padding will be T on both the reference and alternative alleles.
              #Simple Indel classification should be invariant whether it is left or right aligned.
```
```
   SV

   REF  A    
   ALT <DEL>  #SV
```



**Complex Biallelic Examples**
```
   SNP|INDEL

   REF  AT           
   ALT  G           #SNP, INDEL, 1 ts
                    #Note that it is ambiguous as to which pairing should be a SNP, as such, the transition or transversion contribution is actually
                    #not defined.  In this case, assuming it is a A/G SNP, we get a transition, but we may also consider this as a T/G SNP which
                    #is a transversion.  In such ambiguous cases, we simply consider the aligned bases after left alignment to get the transition
                    #and transversion contribution.  But please be very clear that this is an ambiguous case.  It is better to consider this simply
                    #as a complex variant.
```
```
   MNP|INDEL

   REF  ATT          
   ALT  GG          #MNP, INDEL, 1 ts, 1 tv, 1 del
```
```
   MNP|CLUMPED

   REF  ATTTT        
   ALT  GTTTC       #MNP, CLUMPED, 2 ts
                    #since all the alleles are of the same length, classified as MNP too.
```
```
   INDEL|CLUMPED

   REF  ATTTTTTTT    
   ALT  GTTTC       #INDEL, CLUMPED, 2 ts, 1 del
```

**Simple Multiallelic Examples**
```
   SNP

   REF  A       
   ALT  G           #SNP, 1 ts
   ALT  C           #SNP, 1 tv
```
```
   MNP

   REF  AG      
   ALT  GC          #MNP, 1 ts, 1 tv
   ALT  CT          #MNP, 2 tv 
```
```
   INDEL

   REF  ATTT    
   ALT  ATT         #INDEL, 1 del
   ALT  ATTTT       #INDEL, 1 ins
```

**Complex Multiallelic Examples**
```
   SNP|MNP

   REF  AT    
   ALT  GT          #SNP, 1 ts
   ALT  AC          #SNP, 1 ts
                    #since all the alleles are of the sample length, classified as MNP too.
```
```
   SNP|MNP|CLUMPED

   REF  ATTTG    
   ALT  GTTTC       #CLUMPED, 1 ts, 1 tv
   ALT  ATTTC       #SNP, 1 tv, note that we get the SNP after truncating the bases ATTT to reveal a G/C transversion SNP
                    #since all the alleles are of the sample length, classified as MNP too.
```
```
   SNP|MNP|INDEL

   REF  GT    
   ALT  CT          #SNP, 1 tv
   ALT  AG          #MNP, 2 tv
   ALT  GTT         #INDEL, 1 ins
```
```
   SNP|MNP|INDEL|CLUMPED

   REF  GTTT    
   ALT  CG          #MNP, INDEL, 2 tv, 1 del
   ALT  AG          #MNP, INDEL, 1 ts, 1 tv
   ALT  GTGTG       #SNP, INDEL, CLUMPED, 1 tv, 1 ins
```

**Structured Variants Examples**
```
   SV

   REF  G    
   ALT <INS:ME:LINE1>    #SV
```
```
   SV

   REF  G    
   ALT <CN4>             #SV
   ALT <CN12>            #SV
```

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

