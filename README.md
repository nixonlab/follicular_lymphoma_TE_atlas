# Follicular Lymphoma TE Atlas

TE quantification (Telescope) pipeline for Follicular Lymphoma bulk RNA-seq samples

**Project:** CGCI: Non-Hodgkin Lymphoma (SRA: SRP020237, BioProject: PRJNA172563)

**To get DAG:** 

``` snakemake --profile profiles/aws  --forceall --dag | dot -Tpdf > dag.pdf   ```

**To get rule graph:** 

``` snakemake --profile profiles/aws  --forceall --rulegraph | dot -Tpdf > rulegraph.pdf   ```

**To get file graph:** 

``` snakemake --profile profiles/aws  --forceall --filegraph | dot -Tpdf > filegraph.pdf   ```

**To run pipeline:**

``` snakemake --profile profiles/aws/ all ```

**To modify pipeline:**

Change sample download table. 
