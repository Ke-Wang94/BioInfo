version 1.0

workflow FastqQCWorkflow {
    input {
        File fastq_r1
        File fastq_r2
        String sample_name
    }

    call FastQC {
        input:
            fastq_files = [fastq_r1, fastq_r2],
            sample_name = sample_name
    }
}

task FastQC {
    input {
        Array[File] fastq_files
        String sample_name
    }

    command {
        # Run FastQC on each FASTQ file
        for fastq in ~{sep=' ' fastq_files}; do
            fastqc ${fastq} --outdir=./
        done
    }

    output {
        Array[File] qc_reports = glob("*.html")
        Array[File] qc_zip_files = glob("*.zip")
    }

    runtime {
        docker: "biocontainers/fastqc:v0.11.9_cv7"
        memory: "2G"
        cpu: 2
    }
}
