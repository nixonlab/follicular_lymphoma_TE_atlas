rule sample_complete:
    output:
        touch("results/completed/{samid}_completed.txt")
    input:
        rules.basic_complete.output
