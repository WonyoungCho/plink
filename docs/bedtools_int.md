# Bedtools
**bedtools** : a powerful toolset for genome arithmetic

<https://bedtools.readthedocs.io/en/latest/>

- Souce code : <https://github.com/arq5x/bedtools2>

- bedtools merge combines overlapping or “book-ended” features in an interval file into a single feature which spans all of the combined features.

<https://bedtools.readthedocs.io/en/latest/content/tools/merge.html>


- Bed files

<https://github.com/AstraZeneca-NGS/reference_data/tree/master/hg38/bed>

```
$ less data.bed
chr1    13259210        13259717        PRAMEF5
chr1    13259262        13259307        PRAMEF5
chr1    13259547        13259624        PRAMEF5

$ bedtools merge -i data.bed -c 4 -o collapse
chr1    13259210        13259717        PRAMEF5,PRAMEF5,PRAMEF5

$ bedtools merge -i data.bed -c 4 -o distinct
chr1    13259210        13259717        PRAMEF5
```
