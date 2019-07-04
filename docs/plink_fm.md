
# File format reference
<a href="https://www.cog-genomics.org/plink/1.9/formats" target="_blank"> https://www.cog-genomics.org/plink/1.9/formats </a>

## .bed (PLINK binary biallelic genotype table)
Primary representation of genotype calls at biallelic variants. Must be accompanied by .bim and .fam files.


## .bim (PLINK extended MAP file)
Extended variant information file accompanying a .bed binary genotype table. (--make-just-bim can be used to update just this file.)

A text file with no header line, and one line per variant with the following six fields:

1. Chromosome code (either an integer, or 'X'/'Y'/'XY'/'MT'; '0' indicates unknown) or name
1. Variant identifier
1. Position in morgans or centimorgans (safe to use dummy value of '0')
1. Base-pair coordinate (1-based; limited to 231-2)
1. Allele 1 (corresponding to clear bits in .bed; usually minor)
1. Allele 2 (corresponding to set bits in .bed; usually major)

## .fam
