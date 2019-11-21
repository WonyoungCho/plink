**Gviz** is a viasualizing genomic data tool in R.

# Required library
```
$ sudo yum install -y libcurl-devel openssl-devel libxml2-devel
```

# Installation
```
if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")

BiocManager::install("Gviz")
```
- <https://bioconductor.org/packages/release/bioc/html/Gviz.html>
- <https://bioconductor.riken.jp/packages/3.0/bioc/html/Gviz.html>

# Data
```
BiocManager::install("BSgenome.Hsapiens.UCSC.hg38")
BiocManager::install("BSgenome.Hsapiens.UCSC.hg38.masked")
```

# User Guide
- <https://www.bioconductor.org/packages/devel/bioc/vignettes/Gviz/inst/doc/Gviz.html>
