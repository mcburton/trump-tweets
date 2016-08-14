
# A container for the Trump Tweets blog posted

# https://github.com/rocker-org/hadleyverse/blob/master/Dockerfile
FROM rocker/hadleyverse

MAINTAINER mcburton <matt@mcburton.net>


USER root

# References:
# https://irkernel.github.io/installation/
# https://github.com/rocker-org/hadleyverse/blob/master/Dockerfile
# https://github.com/rocker-org/rocker/blob/master/rstudio/Dockerfile
# Installing litter to get the Rscript command
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        apt-utils \
        build-essential \
        python3 \
        python3-dev \
        python3-pip \
        python3-setuptools \
    && pip3 install jupyter \
    && apt-get clean \
    && rm -rf /tmp/downloaded_packages/ /tmp/*.rds \
    && rm -rf /var/lib/apt/lists/*

#COPY ./packages.R /tmp/packages.R
#RUN  Rscript /tmp/packages.R
RUN install2.r --error \
    repr \
    IRdisplay \
    evaluate \
    crayon \
    pbdZMQ \
    devtools \
    uuid \
    digest

# COPY isn't copying w/ correct permissions
# even when I put USER jovyan before the COPY
COPY ./trump-tweets.ipynb /home/rstudio/trump-tweets.ipynb
COPY ./trump_tweets_df.rda /home/rstudio/trump_tweets_df.rda
RUN chown rstudio:rstudio /home/rstudio/trump-tweets.ipynb /home/rstudio/trump_tweets_df.rda

WORKDIR ['/home/rstudio']
# I had this before the COPY but it wasn't working. Bug?
USER rstudio
