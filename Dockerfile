
# A container for the Trump Tweets blog posted

# https://github.com/jupyter/docker-stacks/blob/master/r-notebook/Dockerfile
FROM jupyter/r-notebook

MAINTAINER mcburton <matt@mcburton.net>


USER root

# References:
# https://blog.jessfraz.com/post/r-containers-for-data-science/
# https://github.com/rocker-org/rocker/blob/master/r-base/Dockerfile
# https://github.com/jupyter/docker-stacks/blob/master/r-notebook/Dockerfile

# Installing litter to get the Rscript command
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        littler \
    && rm -rf /tmp/downloaded_packages/ /tmp/*.rds \
    && rm -rf /var/lib/apt/lists/*

COPY ./packages.R /tmp/packages.R
RUN  Rscript /tmp/packages.R


# COPY isn't copying w/ correct permissions
# even when I put USER jovyan before the COPY
COPY ./trump-tweets.ipynb /home/jovyan/work/trump-tweets.ipynb
COPY ./trump_tweets_df.rda /home/jovyan/work/trump_tweets_df.rda
RUN chown jovyan:users trump-tweets.ipynb trump_tweets_df.rda

# I had this before the COPY but it wasn't working. Bug?
USER jovyan
