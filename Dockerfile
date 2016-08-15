
# A container for the Trump Tweets blog posted

# https://github.com/rocker-org/rocker/blob/master/r-base/Dockerfile
FROM r-base:latest

MAINTAINER mcburton <matt@mcburton.net>


USER root

# installing the jupyter notebook from pip
# because I prefer pip to conda
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        apt-utils \
        build-essential \
        libcurl4-openssl-dev \
        libssl-dev \
        python3 \
        python3-dev \
        python3-pip \
        python3-setuptools \
    && pip3 install jupyter \
    && apt-get clean \
    && rm -rf /tmp/downloaded_packages/ /tmp/*.rds \
    && rm -rf /var/lib/apt/lists/*


# install the R packages for running the notebook
# and for installing the R jupyter kernel
# https://irkernel.github.io/installation/
RUN install2.r --error \
    ggplot2 \
    dplyr \
    purrr \
    tidyr \
    lubridate \
    stringr \
    scales \
    tidytext \
    broom \
    httr \
    git2r \
    repr \
    IRdisplay \
    evaluate \
    crayon \
    pbdZMQ \
    devtools \
    uuid \
    digest \
    && r -e "devtools::install_github('IRkernel/IRkernel')" \
    && r -e "IRkernel::installspec(user = FALSE)"  # to register the kernel in the current R installation


# copy data files into home directory
# I know we are the docker user by looking at r-base
WORKDIR /home/docker

COPY ./trump-tweets.ipynb trump-tweets.ipynb
COPY ./trump_tweets_df.rda trump_tweets_df.rda
RUN chown -Rh docker:docker trump-tweets.ipynb trump_tweets_df.rda

USER docker

# I should probably use tini or something so stopping the container is more elegant
CMD jupyter notebook --ip=0.0.0.0
