# load library
library(variancePartition)
library(tidyverse)
library(lme4)
library(DESeq2)
library(GEOquery)
library(limma)
library(oligo)
library(EnrichmentBrowser)
library(affy)   
library(gcrma)

## Downloaded gse object ###
celfile.path="data/GSE56035_RAW/"
geo = "GSE56035"
form <- ~ Age + (1|CellType) + (1|Batch) + (1|Sex)
