
# File format reference
<a href="https://www.cog-genomics.org/plink/1.9/formats" target="_blank"> https://www.cog-genomics.org/plink/1.9/formats </a>

## .bed (PLINK binary biallelic genotype table)
Primary representation of genotype calls at biallelic variants. Must be accompanied by .bim and .fam files.


## .bim (PLINK extended MAP file)
Extended variant information file accompanying a .bed binary genotype table.

A text file with no header line, and one line per variant with the following six fields:

1. Chromosome code (either an integer, or 'X'/'Y'/'XY'/'MT'; '0' indicates unknown) or name
1. Variant identifier
1. Position in morgans or centimorgans (safe to use dummy value of '0')
1. Base-pair coordinate (1-based; limited to 231-2)
1. Allele 1 (corresponding to clear bits in .bed; usually minor)
1. Allele 2 (corresponding to set bits in .bed; usually major)

## .fam (PLINK sample information file)
Sample information file accompanying a .bed binary genotype table. 

A text file with no header line, and one line per sample with the following six fields:

1. Family ID ('FID')
1. Within-family ID ('IID'; cannot be '0')
1. Within-family ID of father ('0' if father isn't in dataset)
1. Within-family ID of mother ('0' if mother isn't in dataset)
1. Sex code ('1' = male, '2' = female, '0' = unknown)
1. Phenotype value ('1' = control, '2' = case, '-9'/'0'/non-numeric = missing data if case/control)
