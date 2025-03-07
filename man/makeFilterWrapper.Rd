% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/FilterWrapper.R
\name{makeFilterWrapper}
\alias{makeFilterWrapper}
\title{Fuse learner with a feature filter method.}
\usage{
makeFilterWrapper(learner, fw.method = "randomForestSRC_importance",
  fw.base.methods = NULL, fw.perc = NULL, fw.abs = NULL,
  fw.threshold = NULL, fw.mandatory.feat = NULL, cache = FALSE, ...)
}
\arguments{
\item{learner}{(\link{Learner} | \code{character(1)})\cr
The learner.
If you pass a string the learner will be created via \link{makeLearner}.}

\item{fw.method}{(\code{character(1)})\cr Filter method. See \link{listFilterMethods}.
Default is \dQuote{randomForestSRC_importance}.}

\item{fw.base.methods}{(\code{character(1)})\cr Simple Filter methods for ensemble
filters. See \link{listFilterMethods}. Can only be used in combination with
ensemble filters. See \link{listFilterEnsembleMethods}.}

\item{fw.perc}{(\code{numeric(1)})\cr If set, select \code{fw.perc}*100 top scoring
features. Mutually exclusive with arguments \code{fw.abs} and \code{fw.threshold}.}

\item{fw.abs}{(\code{numeric(1)})\cr If set, select \code{fw.abs} top scoring features.
Mutually exclusive with arguments \code{fw.perc} and \code{fw.threshold}.}

\item{fw.threshold}{(\code{numeric(1)})\cr If set, select features whose score
exceeds \code{fw.threshold}. Mutually exclusive with arguments \code{fw.perc} and
\code{fw.abs}.}

\item{fw.mandatory.feat}{(\link{character})\cr Mandatory features which are always
included regardless of their scores}

\item{cache}{(\code{character(1)} | \link{logical})\cr Whether to use caching during
filter value creation. See details.}

\item{...}{(any)\cr Additional parameters passed down to the filter. If you
are using more than one filter method, you need to pass the arguments in a
named list via \code{more.args}. For example \code{more.args = list("FSelectorRcpp_information.gain" = list(equal = TRUE))}.}
}
\value{
\link{Learner}.
}
\description{
Fuses a base learner with a filter method. Creates a learner
object, which can be used like any other learner object. Internally uses
\link{filterFeatures} before every model fit.
}
\details{
If \code{ensemble = TRUE}, ensemble feature selection using all methods specified
in \code{fw.method} is performed. At least two methods need to be selected.

After training, the selected features can be retrieved with
\link{getFilteredFeatures}.

Note that observation weights do not influence the filtering and are simply
passed down to the next learner.
}
\section{Caching}{
 If \code{cache = TRUE}, the default mlr cache directory is used
to cache filter values. The directory is operating system dependent and can
be checked with \code{getCacheDir()}. Alternatively a custom directory can be
passed to store the cache. The cache can be cleared with
\code{deleteCacheDir()}. Caching is disabled by default. Care should be taken
when operating on large clusters due to possible write conflicts to disk if
multiple workers try to write the same cache at the same time.
}

\examples{
task = makeClassifTask(data = iris, target = "Species")
lrn = makeLearner("classif.lda")
inner = makeResampleDesc("Holdout")
outer = makeResampleDesc("CV", iters = 2)
lrn = makeFilterWrapper(lrn, fw.perc = 0.5)
mod = train(lrn, task)
print(getFilteredFeatures(mod))
# now nested resampling, where we extract the features that the filter method selected
r = resample(lrn, task, outer, extract = function(model) {
  getFilteredFeatures(model)
})
print(r$extract)

# usage of an ensemble filter
lrn = makeLearner("classif.lda")
lrn = makeFilterWrapper(lrn, fw.method = "E-Borda",
  fw.base.methods = c("FSelectorRcpp_gain.ratio", "FSelectorRcpp_information.gain"),
  fw.perc = 0.5)
r = resample(lrn, task, outer, extract = function(model) {
  getFilteredFeatures(model)
})
print(r$extract)
}
\seealso{
Other filter: \code{\link{filterFeatures}},
  \code{\link{generateFilterValuesData}},
  \code{\link{getFilteredFeatures}},
  \code{\link{listFilterEnsembleMethods}},
  \code{\link{listFilterMethods}},
  \code{\link{makeFilterEnsemble}},
  \code{\link{makeFilter}}, \code{\link{plotFilterValues}}

Other wrapper: \code{\link{makeBaggingWrapper}},
  \code{\link{makeClassificationViaRegressionWrapper}},
  \code{\link{makeConstantClassWrapper}},
  \code{\link{makeCostSensClassifWrapper}},
  \code{\link{makeCostSensRegrWrapper}},
  \code{\link{makeDownsampleWrapper}},
  \code{\link{makeDummyFeaturesWrapper}},
  \code{\link{makeExtractFDAFeatsWrapper}},
  \code{\link{makeFeatSelWrapper}},
  \code{\link{makeImputeWrapper}},
  \code{\link{makeMulticlassWrapper}},
  \code{\link{makeMultilabelBinaryRelevanceWrapper}},
  \code{\link{makeMultilabelClassifierChainsWrapper}},
  \code{\link{makeMultilabelDBRWrapper}},
  \code{\link{makeMultilabelNestedStackingWrapper}},
  \code{\link{makeMultilabelStackingWrapper}},
  \code{\link{makeOverBaggingWrapper}},
  \code{\link{makePreprocWrapperCaret}},
  \code{\link{makePreprocWrapper}},
  \code{\link{makeRemoveConstantFeaturesWrapper}},
  \code{\link{makeSMOTEWrapper}},
  \code{\link{makeTuneWrapper}},
  \code{\link{makeUndersampleWrapper}},
  \code{\link{makeWeightedClassesWrapper}}
}
\concept{filter}
\concept{wrapper}
