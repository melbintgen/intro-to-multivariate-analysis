## ----01-install-bioc, eval = FALSE----------------------------
# if (!requireNamespace("BiocManager", quietly = TRUE))
#     install.packages("BiocManager")
#  BiocManager::install("mixOmics")


## ----01-load, message=FALSE-----------------------------------
library(mixOmics)


## ----01-read-data, eval = FALSE-------------------------------
# # from csv file
# data <- read.csv("your_data.csv", row.names = 1, header = TRUE)
# 
# # from txt file
# data <- read.table("your_data.txt", header = TRUE)


## ----01-load-nutrimouse---------------------------------------
data(nutrimouse)       #load data
X <- nutrimouse$gene    #store data in object called X


## ----01-pca-nutrimouse, fig.show='hide'-----------------------
MyResult.pca <- pca(X)  # 1 Run the method PCA on X
plotIndiv(MyResult.pca) # 2 Plot the samples from a PCA result
plotVar(MyResult.pca)   # 3 Plot the variables from a PCA result


## ----01-spca-nutrimouse, fig.show='hide'----------------------
MyResult.spca <- spca(X, keepX=c(5,5)) # 1 Run the method
plotIndiv(MyResult.spca)               # 2 Plot the samples
plotVar(MyResult.spca)                 # 3 Plot the variables


## ----results = 'hide', message=FALSE--------------------------
library(mixOmics)
data(srbct)
X <- srbct$gene
dim(X)  # check dimension


## ----01-plsda-pca, fig.cap='(ref:01-plsda-pca)', fig.show='hide', results = 'hide'----
pca.srbct <- pca(X, ncomp = 10, scale = TRUE)

pca.srbct

plot(pca.srbct)

# simple version
plotIndiv(pca.srbct, 
          pch = 1,    # pch is to show symbols
          title = 'SRBCT, PCA comp 1 - 2')

# advanced version
plotIndiv(pca.srbct, 
          group = srbct$class, # asking to color according to class of tumour
          ind.names = FALSE,   # not showing the sample names
          legend = TRUE, 
          title = 'SRBCT, PCA comp 1 - 2')


## ----results = 'hold', message=FALSE, results='hide'----------
Y <- srbct$class 
length(Y)


## ----01-plsda, results = 'hide', fig.show='hide'--------------
plsda.srbct <- plsda(X,Y, ncomp = 3)

plotIndiv(plsda.srbct, ind.names = FALSE, legend=TRUE,
          comp=c(1,2), 
          title = 'PLS-DA on SRBCT comp 1-2')

plotLoadings(plsda.srbct, 
             contrib = 'max',  # max = which class has maximum mean (median) expression (vs. min)
             method = 'mean',  # choose either mean or median
             comp = 1,
             ndisplay = 50)

plotVar(plsda.srbct, cutoff = 0.7)  # variable plot (correlation circle plot)

biplot(plsda.srbct, cutoff = 0.7)   # we set a correlation cutoff to only show the most contributing variables   

boxplot(X[, 'g1932']~ Y)


## ----02-splsda, results = 'hide', fig.show='hide'-------------
splsda.srbct <- splsda(X,Y, ncomp = 3,
                       keepX = c(20, 10, 10) # select 20 genes on the first component, 10 on the second, and 10 on the third component
                       )

plotIndiv(splsda.srbct, ind.names = FALSE, legend=TRUE,
          comp=c(1,2), 
          title = 'PLS-DA on SRBCT comp 1-2')

plotLoadings(splsda.srbct, 
             contrib = 'max',  # max = which class has maximum mean (median) expression (vs. min)
             method = 'mean',  # choose either mean or median
             comp = 1)

plotVar(splsda.srbct)  # variable plot (correlation circle plot)

selectVar(splsda.srbct) #extracts the list of variables selected, and their loading weights


## ----03-load-data, message=FALSE, warning=FALSE---------------
data(breast.TCGA)

# Extract training data and name each data frame
# Store as list
X <- list(mRNA = breast.TCGA$data.train$mrna, 
          miRNA = breast.TCGA$data.train$mirna, 
          protein = breast.TCGA$data.train$protein)

# Outcome
Y <- breast.TCGA$data.train$subtype
summary(Y)


## ----03-design------------------------------------------------
design <- matrix(0.1, ncol = length(X), nrow = length(X), 
                dimnames = list(names(X), names(X)))
diag(design) <- 0
design 


## ----03-final, message = TRUE, results='hide', fig.show='hide'----
# number of variables to select per dataset and per component (here 2 comps)
list.keepX <- list( mRNA = c(8, 25), miRNA = c(14,5), protein = c(10, 5))

diablo.tcga <- block.splsda(X, Y, ncomp = 2, 
                            keepX = list.keepX, design = design)
# the message tells us that each data set will be linked to the outcome Y for maximal discrimination

# sample plots:
plot(diablo.tcga) # pairs of components across datasets and their correlation

plotIndiv(diablo.tcga, ind.names = FALSE, legend = TRUE)

# variable plots:
plotVar(diablo.tcga, legend = TRUE)

circosPlot(diablo.tcga, , cutoff = 0.7)

plotLoadings(diablo.tcga, contrib = 'max',  # max = which class has maximum mean (median) expression (vs. min)
             method = 'mean',  # choose either mean or median
             comp = 1)

# variable selection
selectVar(diablo.tcga)


## ----03-predict, message = FALSE, results='hide', fig.show='hide'----
# Prepare test set data: here one block (proteins) is missing
data.test.tcga <- list(mRNA = breast.TCGA$data.test$mrna, 
                      miRNA = breast.TCGA$data.test$mirna)

predict.diablo.tcga <- predict(diablo.tcga, newdata = data.test.tcga)
# The warning message will inform us that one block is missing

predict.diablo.tcga # Lists the different outputs


## -------------------------------------------------------------
confusion.mat.tcga <- get.confusion_matrix(truth = breast.TCGA$data.test$subtype, 
                     predicted = predict.diablo.tcga$WeightedVote$centroids.dist[,2]) # 2nd component
confusion.mat.tcga


## -------------------------------------------------------------
get.BER(confusion.mat.tcga)


## -------------------------------------------------------------
sessionInfo()

