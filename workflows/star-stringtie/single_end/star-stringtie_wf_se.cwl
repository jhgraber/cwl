cwlVersion: v1.0
class: Workflow

inputs:
  ## Common input
  nthreads: int

  ## Inputs for download_sra
  repo: string?
  run_ids: string[]

  ## Inputs for fastq-dump
  gzip:
    type: boolean
    default: false

  ## Inputs for star_mapping
  genomeDir: Directory

  ## Inputs for stringtie
  annotation: File

outputs:
  assemble_output:
    type: File
    outputSource: stringtie_assemble/assemble_output

steps:
  download-sra:
    run: download-sra.cwl
    in:
      repo: repo
      run_ids: run_ids
    out:
      [sraFiles]

  pfastq-dump:
    run: pfastq-dump.cwl
    in:
      sraFiles: download-sra/sraFiles
      nthreads: nthreads
      gzip: gzip
    out:
      [fastqFiles]

  star_mapping:
    run: star_mapping_se.cwl
    in:
      nthreads: nthreads
      genomeDir: genomeDir
      fq: pfastq-dump/fastqFiles
    out:
      [output_bam]

  samtools_sort:
    run: samtools_sort.cwl
    in:
      input_bam: star_mapping/output_bam
      nthreads: nthreads
    out: [sorted_bamfile]

  stringtie_assemble:
    run: stringtie_assemble.cwl
    in:
      input_bam: samtools_sort/sorted_bamfile
      nthreads: nthreads
      annotation: annotation
    out: [assemble_output]
