nextflow.enable.dsl=2

include { cosine_with_filter } from '../subworkflows/cosine_with_filter/main.nf'

workflow {
    expr_file = Channel.fromPath('tests/input/test_expression.csv')
    cosine_with_filter(expr_file)
}
