This analysis is based on HapMap 1000 genome data, downloaded from below link.

<http://hgdownload.cse.ucsc.edu/gbdb/hg19/1000Genomes/phase3/>.

- Data file : [ch78work.map](data/ch78work.map) , [ch78work.ped](data/ch78work.ped)

# Data manipulation

- Replace some column values to other values.
```
import pandas as pd
import numpy as np

bfile='out1.ped'

a=pd.read_csv(bfile,header = None,sep='\s+|\t+', index_col=0,engine='python')

#for n in range(a.shape[0]):
#print(a.columns)
add=np.array(range(1,a.shape[0]+1))#.reshape(1,-1)
print(add)


a[1]=add
print(a.head())

#for n in range(a.shape[0]):
#    a.iloc[n,0]=n

#print(a)

outFile='out_re.ped'
a.to_csv(outFile,sep='\t', header=False)
a=pd.read_csv(outFile,header = None,sep='\s+|\t+',engine='python')
print(a.head())
```

