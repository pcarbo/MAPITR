#' @useDynLib MAPITR
#'
#' @importFrom Rcpp evalCpp
#' 
#' @import doParallel
#'
RunMAPITR.Base <- function (PhenotypeMatrix, Genotypes, Pathways.Full, cores, LogFile) {

	RunMAPITR.Base.Output <- list()

	#MAPITR expects a n x r phenotype matrix, a p x n genotype matrix, and a list of SNP indices for each pathway
	RunMAPITR.Base.Output.temp1 <- MAPITRBase(t(as.matrix(Genotypes)),as.matrix(PhenotypeMatrix),Pathways.Full,cores=cores)

	return(list(Est=RunMAPITR.Base.Output.temp1$Est, Eigenvalues=RunMAPITR.Base.Output.temp1$Eigenvalues, PVE=RunMAPITR.Base.Output.temp1$PVE, LogFile=LogFile))

}

#' @useDynLib MAPITR
#' 
#' @import doParallel
#' 
#RunMAPITR.wCovs <- function (PhenotypeMatrix, Genotypes, Pathways.Full, Covariates, cores, LogFile) {
#
#	RunMAPITR.wCovs.Output <- list()
#	
#	#MAPITR.wCovs expects a n x r phenotype matrix, a p x n genotype matrix, a z x n covariate matrix, and a list of SNP indices for each pathway
#	RunMAPITR.wCovs.Output.temp2 <- MAPITRBaseCovs(t(as.matrix(Genotypes.Pathway)),as.matrix(PhenotypeMatrix),Pathways.Full,t(as.matrix(Covariates)),cores=cores)
#
#	return(list(Est=RunMAPITR.wCovs.Output.temp2$Est, Eigenvalues=RunMAPITR.wCovs.Output.temp2$Eigenvalues, PVE=RunMAPITR.wCovs.Output.temp2$PVE, LogFile=LogFile))
#
#}

#RunMAPITR.GRMsProvided <- function ( ) {
#
#	RunMAPITR.GRMsProvided.Output <- list()
#
#	return(RunMAPITR.GRMsProvided.Output)
#
#}

#' @importFrom CompQuadForm davies
GetMAPITRpValues <- function (Est, Eigenvalues, acc=1e-8) {

	pValues <- c()
	for (i in 1:length(Est)) { 
		Lambda <- sort(Eigenvalues[,i], decreasing=TRUE)
		Davies.Output <- CompQuadForm::davies(Est[i], lambda=Lambda, acc=acc)
		pValues <- c(pValues, 2*min(1-Davies.Output$Qq, Davies.Output$Qq))
	}

	return(pValues)

}
