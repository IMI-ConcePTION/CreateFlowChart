% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/CreateFlowChart.R
\name{CreateFlowChart}
\alias{CreateFlowChart}
\title{'CreateFlowChart'}
\usage{
CreateFlowChart(dataset, listcriteria, weight, strata, flowchartname)
}
\arguments{
\item{dataset}{input dataset to work with}

\item{listcriteria}{list of boolean/binary variables}

\item{weight}{(optional) weight variable: in the input dataset each row may represent multiple unit of observations, if this is the case weight contains the weight of each row}

\item{strata}{(optional) categorical variable representing strata}

\item{flowchartname:}{filename (possibly with path) of the output dataset containing the flowchart}
}
\description{
CreateFlowChart takes as input a dataset where a list of exclusion criteria is represented as binary or boolean variables. The output are two datasets (a)	the input dataset itself, restricted to the sole rows which don't match any exclusion criterion; this dataset is returned at the end of the function, and (b) the flowchart representing how many units were discarded by each criterion; this dataset is saved in the R environment. Criteria are considered to be hierarchical. As an option, the count is performed across strata of a categorical variable.
}
