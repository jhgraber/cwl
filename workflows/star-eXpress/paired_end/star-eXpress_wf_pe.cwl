cwlVersion: v1.0
class: Workflow

inputs:
  ## Common input
  nthreads: int

  ## Inputs for download_sra
  repo: string?
  run_ids: string[]

  ## Inputs for star_mapping
  genomeDir: Directory

  ## Inputs for eXpress
  target_fasta: File

outputs:
  express_result:
    type:
      type: array
      items: File
    outputSource: express/express_result

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
      sraFiles: download_sra/sraFiles
      nthreads: nthreads
    out:
      [forward, reverse]

  star_mapping:
    run: star_mapping.cwl
    in:
      nthreads: nthreads
      genomeDir: genomeDir
      readFilesIn: [pfastq-dump/forward, pfastq-dump/reverse]
    out:
      [output_bam]

  samtools_sort:
    run: samtools_sort.cwl
    in:
      input_bam: star_mapping/output_bam
      nthreads: nthreads
    out: [sorted_bamfile]

  express
    run: eXpress.cwl
    in:
      input_bam: samtools_sort/sorted_bamfile
      target_fasta: target_fasta
    out: [express_result]
