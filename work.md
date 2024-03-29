# work


## rgi

+ run rgi

```bash
cd ~/data/bacteria/plasmid/rgi

parallel -j 4 '
  prefix=$( basename {1} | sed 's/\.fa//' )
  rgi main -i {1} -o $prefix -t contig -a DIAMOND -n 4 --clean
' ::: $( ls ../data/*.fa )
```

+ merge rgi result

```
cd ~/data/bacteria/plasmid/result
mkdir rgi
cd rgi

perl ../../src/rgi_to_dataframe.pl -i ../../rgi -o ./result.tsv
```

## prokka

```bash
cd ~/data/bacteria/plasmid/prokka

parallel -j 6 '
    prefix=$( echo {1} | xargs basename |sed 's/\.fa//' )
    prokka {1} --outdir ${prefix} --prefix prokka --kingdom Bacteria
' ::: $( ls ../data/*.fa )
```

## merge rgi and prokka data

+ do something to the annotation

discard annotation two times gene( keep rgi gene ), but the name between the rgi and prokka is different. So it depend on the gene scale to decide.

```bash

```

## clust

```
~/Applications/biosoft/MeShClust/bin/meshclust \
  total.fa \
  --kmer 3 \
  --id 0.90 \
  --delta 20 \
  --output ./MeShClust/out.clstr \
  --sample 5000 \
  --threads 14
```
