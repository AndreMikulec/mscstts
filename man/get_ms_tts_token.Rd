% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ms_tts_auth.R
\name{get_ms_tts_token}
\alias{get_ms_tts_token}
\title{Get Microsoft Text To Speech (TTS) or Cognitive
Services Token from API Key}
\usage{
get_ms_tts_token(api_key = NULL, token_url = NULL)
}
\arguments{
\item{api_key}{Microsoft Cognitive Services API key}

\item{token_url}{authorization token URL
(if different or custom from the default)}
}
\value{
A list of the request, and token
}
\description{
Get Microsoft Text To Speech (TTS) or Cognitive
Services Token from API Key
}
\examples{
if (valid_ms_tts_key()) {
   token = get_ms_tts_token()
}
}
