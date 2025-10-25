nextflow.enable.dsl=2

include { COSINE_WITH_FILTER } from '../subworkflows/cosine_with_filter'

params.method = 'cosine'
params.min_gene_mean = 0.0
params.sample_cols = 'auto'
params.use_matrixfilter = true

workflow {
    expr_file = Channel.fromPath('tests/input/test_expression.csv')
    COSINE_WITH_FILTER(
        expr_file,
        params.method,
        params.min_gene_mean,
        params.sample_cols
    )
}
