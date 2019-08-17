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

- as `function`
```
import time

def combinations(iterable, r):
    # combinations('ABCD', 2) --> AB AC AD BC BD CD
    # combinations(range(4), 3) --> 012 013 023 123
    pool = tuple(iterable)
    n = len(pool)
    if r > n:
        return
    indices = list(range(r))
    yield tuple(pool[i] for i in indices)
    while True:
        for i in reversed(range(r)):
            if indices[i] != i + n - r:
                break
        else:
            return
        indices[i] += 1
        for j in range(i+1, r):
            indices[j] = indices[j-1] + 1
        yield tuple(pool[i] for i in indices)
        
start=time.time()
print(len(list(combinations(range(1000),3))))
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


||python3 (itertools)|python3 (function)|python3 (loop)|pypy3 (itertools)|pypy3 (function)|pypy3 (loop)|
|-|-|-|-|-|-|-|
|sec|42.61518836021423|319.5462818145752|520.963995218277|99.43208312988281|193.73589968681335|244.8389551639557|
