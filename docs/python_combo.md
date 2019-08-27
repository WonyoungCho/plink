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

- Memory occupancy : about 12Gb.

||python3 (itertools)|python3 (function)|python3 (loop)|pypy3 (itertools)|pypy3 (function)|pypy3 (loop)|
|-|-|-|-|-|-|-|
|sec|42.61518836021423|319.5462818145752|520.963995218277|99.43208312988281|193.73589968681335|244.8389551639557|

# Expand to next combo
```
import itertools
from tqdm import tqdm
import time

start=time.time()
var=1000
noCombo=3

combo=itertools.combinations(range(var),noCombo)
print(len(list(combo)))

cc=[]
for nc in tqdm(combo):
    for ac in range(var):
        if nc[1] == var-1:break
        if ac>nc[1]:
            cc.append(list(nc)+[ac])

print(len(cc))
print(time.time()-start)
```

# Multi-processing

```
import pickle
import itertools
from tqdm import tqdm
from math import factorial
from multiprocessing import Process
import itertools

def total_combo(n, r):
    return factorial(n) // factorial(r) // factorial(n-r)

'''
def cal_combo(pid,start,end):
    with open('c3_data.pkl','rb') as pkl_file:
        data = pickle.load(pkl_file)
        for i in enumerate(tqdm(data)):
            if i[0] >= start:
                if i[0] < start+10: print(i)
                if i[0] > end: break
    pkl_file.close()
'''

def cal_combo(var,noCombo,start,end):
    data = itertools.combinations(range(var),noCombo)
    for i in enumerate(tqdm(data)):
        if i[0] >= start:
            if i[0] < start+10: print(i)
            if i[0] > end: break

if __name__=='__main__':

    noCombo=3
    var=1000

    print(total_combo(var,noCombo),'combinations for',noCombo,'of',var,'variants')
    noProc=6
    interval=total_combo(var,noCombo)/noProc
    if interval%1==0:
        print(interval)

        procs=[]

        for pid in range(noProc):
            proc = Process(target=cal_combo, args=(var,noCombo, interval*pid, interval*(pid+1)))
            procs.append(proc)
            proc.start()

        for proc in procs:
            proc.join()
'''
data_raw=itertools.combinations(range(var),noCombo)

with open('c'+str(noCombo)+'_data.pkl', 'wb') as output:
    pickle.dump(data_raw, output, protocol=pickle.HIGHEST_PROTOCOL)
    output.close()
'''
```

# Multi-processing & MPI4Py

MPI4Py code:
```
if __name__=='__main__':

    noCombo=3
    var=1000

    print(total_combo(var,noCombo),'combinations for',noCombo,'of',var,'variants')

    comm = MPI.COMM_WORLD
    size = comm.Get_size()
    rank = comm.Get_rank()

    noProc=size
    interval=total_combo(var,noCombo)/size

    if interval%1==0:
        print(interval)

        cal_combo(var,noCombo, interval*rank, interval*(rank+1))
```

||Multiprocessing (python3)|Multiprocessing (pypy3)|MPI4Py (python3)|
|-|-|-|-|-|
|iterate speed(it/s)|2.7x10e6|1.5x10e7|2.7x10e6|1.5x10e7|
|time(s)|41|11|41|10|
