# work


## Rgi

```bash
cd cd ~/data/bacteria/plasmid/rgi

parallel -j 4 '
  prefix=$( basename {1} | sed 's/\.fa//' )
  rgi main -i {1} -o $prefix -t contig -a DIAMOND -n 4 --clean
' ::: $( ls ../data/*.fa )
```

## prokka

```bash
cd ~/data/bacteria/plasmid/prokka

parallel -j 6 '
    prefix=$( echo {1} | xargs basename |sed 's/\.fa//' )
    prokka {1} --outdir ${prefix} --prefix prokka --kingdom Bacteria
' ::: $( ls ../data/*.fa )
```

