cwlVersion: v1.0
class: CommandLineTool

baseCommand: [/path/to/prefetch_pfastq-dump.sh]

requirements:
  - class: InlineJavascriptRequirement

inputs:
  run_id:
    type: string
    inputBinding:
      position: 1
  read_type:
    type: string
    inputBinding:
      position: 2
  thread:
    type: int?
    inputBinding:
      position: 3

outputs:
  pfastq-dump_version:
    type: File?
    outputBinding:
      glob: "pfastq-dump_version"
  dump_fq:
    type: File?
    outputBinding:
      glob: $((inputs.run_id).split(',')[0] + ".fastq")
  dump_fq1:
    type: File?
    outputBinding:
      glob: $((inputs.run_id).split(',')[0] + "_1.fastq")
  dump_fq2:
    type: File?
    outputBinding:
      glob: $((inputs.run_id).split(',')[0] + "_2.fastq")
