# plink

plink is a whole genome association analysis toolset.

This site contains the way to genome analysis and related things.

---

**Wonyoung Cho**.

<bourbaki10@gmail.com>

---

# Installation

- plink 파일을 다운 : <a href="https://www.cog-genomics.org/plink2" target="_blank"> https://www.cog-genomics.org/plink2 </a>

- plink 파일을 실행 가능한 파일로 만들어준다.
```
$ sudo chmod u+x plink
```

- 만약 사용권한이 제한된어 실행되지 않을 경우, 소유자를 사용자로 바꾸어 준다 (change owner).
```
$ sudo chown user1:user1 plink
```

Conda를 이용한 다른 방법 : <a href="https://anaconda.org/search?q=plink" target="_blank"> https://anaconda.org/search?q=plink </a>
```
$ conda install -c bioconda plink
```
