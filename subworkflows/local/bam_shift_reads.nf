include { SAMTOOLS_SORT            } from '../../modules/nf-core/samtools/sort/main'
include { SAMTOOLS_INDEX           } from '../../modules/nf-core/samtools/index/main'
include { DEEPTOOLS_ALIGNMENTSIEVE } from '../../modules/local/deeptools_alignmentsieve'

workflow BAM_SHIFT_READS {
    take:
    ch_bam_bai                   // channel: [ val(meta), [ bam ], [bai] ]

    main:
    ch_versions = Channel.empty()

    //
    // Shift reads
    //
    DEEPTOOLS_ALIGNMENTSIEVE (
        ch_bam_bai
    )
    ch_versions = ch_versions.mix(DEEPTOOLS_ALIGNMENTSIEVE.out.versions)

    //
    // Sort reads
    //
    SAMTOOLS_SORT (
        DEEPTOOLS_ALIGNMENTSIEVE.out.bam
    )
    ch_versions = ch_versions.mix(SAMTOOLS_SORT.out.versions)

    //
    // Index reads
    //
    SAMTOOLS_INDEX (
        SAMTOOLS_SORT.out.bam
    )
    ch_versions = ch_versions.mix(SAMTOOLS_INDEX.out.versions)

    emit:
    bam = SAMTOOLS_SORT.out.bam                     // channel: [ val(meta), [ bam ] ]
    bai = SAMTOOLS_INDEX.out.bai                    // channel: [ val(meta), [ bai ] ]
    versions = ch_versions                          // channel: [ versions.yml ]
}
