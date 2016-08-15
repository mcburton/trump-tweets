# Trump Tweets: Dockerized and Jupytered


This repository is an experiment in thinking about Docker containers *as media objects.* As a test I have taken [David Robinson's](https://twitter.com/drob) recent blog post analyzing [Trump's Tweets](http://varianceexplained.org/r/trump-tweets/), converted it to a Jupyter Notebook, and then wrapped it in a Docker container. The idea is someone could easily pull down the Docker image, run it, and interact with the narrative, data, code, and infrastructure as a portable and contained document-like thing.

I haven't pushed this image to DockerHub yet so to play with this you will need to download or clone this repository, build the image, and then run it.

From within the repository directory run:
```
docker build --rm -t trump-tweets .
```
If you haven't already downloaded the [Rocker r-base image](https://github.com/rocker-org/rocker/blob/master/r-base/Dockerfile) the build process will download it. My Dockerfile installs Jupyter, the Jupyter R kernel, and a bunch of R packages so expect the build process to take a bit of time. I tried using a [more advanced image](https://hub.docker.com/r/rocker/hadleyverse/), but it didn't work quite right.

Once the build process has finished you can run the container:
```
docker run -p 8888:8888 trump-tweets
```
Now if you visit [http://localhost:8888/notebooks/trump-tweets.ipynb](http://localhost:8888/notebooks/trump-tweets.ipynb) you should see a live version of the Trump Tweets notebook!


## misc thoughts

I am not in love with the composition of this Dockerfile for a couple reasons:
- Installing R packages from the command line is weird and needs a third-party library (littler). I guess I can technically use `r -e "commdand"` but the `install2.r` command seems to be the recommended way to install R packages.
- I don't love the fact I had to use `chown` to set the right user permissions. Is that just the way Docker works these days?
- I feel like I could do a better job preparing the image so that it doesn't have as many layers.
- I should look into using R packages and  [packrat](https://rstudio.github.io/packrat/) to bundle everything together (h/t to [@benmarwick](https://twitter.com/benmarwick) and [@goldstoneandrew](https://twitter.com/goldstoneandrew)). I'd have to see how well this plays with Jupyter.

I am purposefully putting content files (`trump-tweets.ipynb`, trump_tweets_df.rda) *into* the image to make it easy to just pull the image down from Dockerhub, but I am not sure how people will feel about this decision. I think my uneasiness speaks to the gaps in how to manage data in Docker containers. That said, this decision is part of some experiments in thinking about Docker containers as *media*.
