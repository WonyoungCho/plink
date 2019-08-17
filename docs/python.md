# Performance test

- `itertlools`
```
import itertools
import time

start=time.time()

cb=list(itertools.combinations(range(1000),3))

print(len(cb))
print(time.time()-start)
```

- `loop`
```
import numpy as np
import time

start=time.time()

cb=[]
rg=1000
for i in range(rg):
    for j in range(i+1,rg):
        for k in range(j+1,rg):
            cb.append([i,j,k])

print(len(cb))
print(time.time()-start)
```

||python3(itertools)|python3(loop)|pypy3(itertools)|pypy3(loop)|
|-|-|-|-|-|
|sec|42.61518836021423|520.963995218277||244.8389551639557|
