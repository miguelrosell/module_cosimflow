nextflow.enable.dsl=2

include { COSINE_WITH_FILTER } from '../subworkflows/cosine_with_filter/main.nf'

workflow {
    expr_file = Channel.fromPath('tests/input/test_expression.csv')
    COSINE_WITH_FILTER(expr_file)
}
