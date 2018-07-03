# Detection and evolution of repetitive proteins

Online seminar by the EMBL-EBI training on 27th June 2018:

https://www.ebi.ac.uk/training/online/course/detection-and-evolution-repetitive-proteins

This repository contains the files and scripts used during the webinar.

The [Python script](msa_to_matrix.py) is used to calculate the all-to-all matrix of pairwise sequence identities and the [R script](dup_pattern_plots.R) is used to generate the plots shown in the presentation: [similarity matrix](A0A087WZJ2_dup-pattern.pdf) and [similarity autocorrelation vector](A0A087WZJ2_atocorrelation.pdf).

### Resources

- R 3.4 with ggplot2 and dplyr packages
- Python 2 or 3

- Pfam: http://pfam.xfam.org/
- UniProt: https://www.uniprot.org/

- Dotter: https://www.sanger.ac.uk/science/tools/seqtools
- Jalview: http://www.jalview.org/

### Instructions

1. Download the protein sequence in fasta format:

```
wget "https://www.uniprot.org/uniprot/A0A087WZJ2.fasta"
```

2. Visualize the self-dot plot of the protein:

```
dotter A0A087WZJ2.fasta
```

3. Download the alignment of the domain family and select domains in the protein:

```
curl -o PF06758_full.sto "http://pfam.xfam.org/family/PF06758/alignment/full/formatformat=stockholm&alnType=full&order=a&case=l&gaps=default&download=0"

grep A0A087WZJ2 PF06758_full.sto > PF06758_A0A087WZJ2.sto
```

4. Calculate the all-to-all pairwise similarity matrix:

```
python msa_to_matrix.py
```

5. Plot the matrix and the autocorrelation vector:

```
R dup_pattern_plots.R
```

