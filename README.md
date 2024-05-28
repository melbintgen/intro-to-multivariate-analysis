# MIG workshop: multivariate analysis with mixOmics

**Authors: Kim-Anh Lê Cao **

**Tutors: Saritha Kodikara**

| Audience      | Prerequisites | Duration    |
| ------------- | ------------- | ----------- |
| Biologists  & computational biologists   | [Intro to R](https://melbintgen.github.io/intro-to-r/intro_r_biologists.html)          |~ 3 hours    |
| Biologists & computational biologists    | [Intro to linear models](https://github.com/melbintgen/intro-to-linear-models)         |~ 2.5 hours    |


### Description

This repository includes material for our workshop 'Multivariate analysis for omics data'. 
This workshop will introduce the fundamental principles of multivariate analysis with hands-on applications for omics data. We will use the mixOmics R package.

### Installation Requirements

Install R first, then RStudio. Download the most recent version of R and RStudio using the links below:
- [R](https://cran.r-project.org/) (Preferably R version > 4.0)
- [RStudio](https://posit.co/download/rstudio-desktop/#download)

Install the R packages.
Type the R command lines:
``` 
# Install mixOmics using BiocManager
if (!requireNamespace("BiocManager", quietly = TRUE)) {
  install.packages("BiocManager")
}
BiocManager::install(c("mixOmics"))

# Test if the package has correctly been installed (i.e no errors messages)
library(mixOmics)

```


### Material

%[Click here](https://melbintgen.github.io/intro-to-linear-models/linear-models-master/Linear_model_slides.pdf) to access the slides.

%[Click here](https://melbintgen.github.io/intro-to-linear-models/linear_models.html) to access the HTML workshop document.

### Data
%All data used for the workshop are in [data.zip](https://melbintgen.github.io/intro-to-linear-models/data.zip).


