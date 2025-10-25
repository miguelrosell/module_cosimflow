#!/bin/bash -ue
Rscript /home/miguelito/Documentos/module_cosimflow/tests/bin/compute_cosine.R \
    --input test_expression.csv \
    --out_prefix similarity \
    --method cosine \
    --min_gene_mean 0.0 \
    --sample_cols "auto"
