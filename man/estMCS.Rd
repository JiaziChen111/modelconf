% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/estMCS.R
\name{estMCS}
\alias{estMCS}
\title{Estimation of a model confidence set (MCS) using an out-of-sample loss
measure.}
\usage{
estMCS(loss, test = "t.range", B = 1000, l = 2)
}
\arguments{
\item{loss}{A matrix of size (n x m). The columns contain the estimated losses
for each of the \code{m} models.}

\item{test}{A character string. It specifies the test statistic to be used.
Available tests are "t.max", "t.range", and "t.min".}

\item{B}{A scalar, the number of bootstrap samples.}

\item{l}{A scalar, the block length used in the moving-block bootstrap.}
}
\value{
A matrix of size (m x 3). The first column enumerates the models in
the same order as they occurred in \code{loss}. The second column contains
the p-value associated with the test that removed that particular model
from the set. The third column contains the MCS p-values. These are useful
for reading off which models would be included in the estimated MCS for any
particular significance level.
The matrix will have row names equal to the column names of \code{loss}.
}
\description{
The function allows to estimate a model confidence set as described in
Hansen, Lunde and Nason (2011), i.e. a set of models that contains the best
models with a given probability. It is analogous to confidence intervals for
parameters. A matrix is returned that contains the MCS p-values of all
models.
}
\details{
Any user defined loss criterion can be used to compute the matrix of losses.
For forecasting exercises this would typically be squared or absolute
forecast errors. The computation has to be done in advance and fed to the
function via the \code{loss} argument. The models with the lowest expected
loss are defined as the best models. To remove inferior models from the
starting set, the null hypothesis that 'no inferior model is present' is
tested in a sequential manner. If the null hypothesis is rejected, a model is
removed and the null tested again. The decision which model to remove is
based on elimination rules that are implied by the test statistic and cannot
be changed by the user. When a test fails to reject the null at a pre-defined
significance level, the procedure would in principle stop and deliver the
remaining models as the estimated MCS. Here, however, all models will be
returned with their associated MCS p-values. It is up to the user to decide
on a significance level and then apply this to the outcome of this function
(see the example section).

Note that the \code{t.min} test statistic is only included for legacy reasons
and should not be used for empirical analysis as it violates a coherency
condition in Hansen, Lunde and Nason (2011). It could therefore be heavily
undersized in finite samples. See the
\href{https://docs.google.com/viewer?a=v&pid=sites&srcid=ZGVmYXVsdGRvbWFpbnxwZXRlcnJlaW5oYXJkaGFuc2VufGd4OjY1ZjQxODUxYmM1ZThhOWE}{corrigendum}
to Hansen, Lunde and Nason (2011) for details.
}
\examples{

### Reproducing the results in Hansen, Lunde and Nason (2011),
### p. 485, column 1.

library(modelconf)

data(SW_infl4cast)
data <- as.matrix(SW_infl4cast)
loss <- (data[, -1] - data[, 1])^2 # compute squared errors

# Estimate MCS same way that Hansen, Lunde, Nason (2011) did.
# Note: "t.min" should not be used in practice.

(my_MCS <- estMCS(loss, test = "t.min", B = 25000, l = 12))
# estimated 90\% model confidence set
my_MCS[my_MCS[, "MCS p-val"] > 0.1, ]

}
\references{
Hansen, P. R., Lunde, A., Nason, J. M. 2011. "The Model
Confidence Set", \emph{Econometrica}, \bold{79(2)}, 453 - 497
}
\seealso{
See \code{\link{estMCS.reg}} for the MCS methodology applied to
linear regression models and \code{\link{estMCS.quick}} for an implementation
of this function which only returns the MCS (instead of all models). See
\code{\link{np::b.star}} for choosing the block length \code{l}.
}
\author{
Niels Aka
}
