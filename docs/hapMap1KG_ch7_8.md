This analysis is based on HapMap 1000 genome data which is downloaded from below link :

<http://hgdownload.cse.ucsc.edu/gbdb/hg19/1000Genomes/phase3/>

- Data file : [ch78work.map](data/ch78work.map) , [ch78work.ped](data/ch78work.ped)

# Data manipulation

- Replace some column values to other values.
```
import pandas as pd
import numpy as np

bfile='out1.ped'

a=pd.read_csv(bfile,header = None,sep='\s+|\t+', index_col=0,engine='python')

add=np.array(range(1,a.shape[0]+1))
a[1]=add

print(a.head())

outFile='out_re.ped'
a.to_csv(outFile,sep='\t', header=False)

a=pd.read_csv(outFile,header = None,sep='\s+|\t+',engine='python')
print(a.head())
```

- Penetrance
```
import numpy as np
import matplotlib.pyplot as plt

beta1,beta2 = 0,0
beta0,beta3 = -5,0.75

g2=1
g1 = np.array([3,2,1])

logit = beta0 + beta1*g1 + beta2*g2 + beta3*g1*g2
prob = 1/(1+np.exp(-logit))

x=np.array(range(-10,1))
y=1/(1+np.exp(-x))

plt.plot(x,y)
plt.plot(logit,prob,'ro')
plt.show()

print('Probability =',prob)
print('x =',x)
print('y =',y)
```
![Penetrance](image/penetrance.png)

```
Probability = [0.06008665 0.02931223 0.01406363]
x = [-10  -9  -8  -7  -6  -5  -4  -3  -2  -1   0]
y = [4.53978687e-05 1.23394576e-04 3.35350130e-04 9.11051194e-04
 2.47262316e-03 6.69285092e-03 1.79862100e-02 4.74258732e-02
 1.19202922e-01 2.68941421e-01 5.00000000e-01]
```

- Frequency
```
import pandas as pd
import numpy as np

def countSample(n,data,name,rs,loc):
    b=[]
    for i in range(n):
        b.append(data[i][loc+5])
    c=pd.DataFrame(np.array([name,rs,loc,b.count(1)/(2*n),b.count(2)/(2*n),b.count(3)/(2*n),b.count(4)/(2*n)]).reshape((1,7)),columns=['name','rsID','loc','A','C','G','T'])
    return c

def main(bfile):
    a=pd.read_csv(bfile+'.ped',header = None,sep='\s+|\t+', index_col=0,engine='python')
    b=pd.read_csv(bfile+'.map',header = None,sep='\s+|\t+', index_col=0,engine='python')
    a_case=a[a[5]==2]
    a_control=a[a[5]==1]

    a=np.array(a)
    n=a.shape[0]
    p=int((a.shape[1]-5)/2)
    print('sample :',n,', variant :',p)
    '''
    for j in range(5):
        print(j, np.count_nonzero(a[0][5:] == j))
    '''

    loc=1619
    c=countSample(n,a,'DSL1 ',b.iloc[loc,0],loc*2)
    c=c.append(countSample(n,a,'DSL1 ',b.iloc[loc,0],loc*2+1))
    print(c)
    
if __name__=='__main__':
    main('out_1234')
```
```
sample : 2000 , variant : 1751
    name        rsID   loc        A        C    G    T
0  DSL1   rs10956767  3238  0.18875  0.31125  0.0  0.0
0  DSL1   rs10956767  3239  0.41725  0.08275  0.0  0.0
```
