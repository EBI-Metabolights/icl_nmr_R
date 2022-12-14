% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/matchPeaksToRef2.R
\name{matchPeaksToRef2}
\alias{matchPeaksToRef2}
\title{Match Peaks to reference Spectra 2.}
\usage{
matchPeaksToRef2(
  target,
  driver_ppm,
  reference,
  tol = 0.02,
  Itol = 20,
  matchMethod = "basic",
  intensity = FALSE
)
}
\arguments{
\item{target}{target peak.}

\item{driver_ppm}{parts per million of driver peak.}

\item{reference}{reference spectral peaks as db file.}

\item{tol}{tolerance in ppm.}

\item{Itol}{tbc}

\item{matchMethod}{matching methodology as a string, defaults to 'basic'}

\item{intensity}{flag to indicate whether to factor in intensity to matching.}
}
\value{
list of resulting matches.
}
\description{
Function to match target and reference spectral peaks by chemical shift
Goncalo Graca, 16 February 2021, g.gomes-da-graca-at-imperial.ac.uk
modified on 13 May 2021
modifications added:
matches only count if driver peak is found in the reference
score is the Jaccard index for the target and reference
matched ppms counted only once
result output modified to match with other functions
}
