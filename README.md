# Trump Tweets: Dockerized and Jupytered


This repository is an experiment in thinking about Docker containers *as media objects.* As a test I have taken [David Robinson's](https://twitter.com/drob) recent blog post analyzing [Trump's Tweets](http://varianceexplained.org/r/trump-tweets/), converted it to a Jupyter Notebook, and then wrapped it in a Docker container. The idea is someone could easily pull down the Docker image, run it, and interact with the narrative, data, code, and infrastructure as a portable and contained document-like thing.

I haven't pushed this image to DockerHub yet so to play with this you will need to download or clone this repository, build the image, and then run it.

From within the repository directory run:
```
docker build -t trump-tweets .
```
If you haven't already downloaded the [Project Jupyter Docker stacks](https://github.com/jupyter/docker-stacks/) the docker process will download them. They are big so it might take a while.

Once the build process has finished you can run the container:
```
docker run -p 8888:8888 trump-tweets
```
Now if you visit [http://localhost:8888/notebooks/trump-tweets.ipynb](http://localhost:8888/notebooks/trump-tweets.ipynb) you should see a live version of the Trump Tweets notebook!


## misc thoughts

I am not in love with the composition of this Dockerfile for a couple reasons:
- Installing R packages from the command line is weird and needs a third-party library (littler).
- I don't love the fact I had to us `chown` to set the right user permissions. Even when I had the `USER jovyan` command before the `COPY` the Notebo0k and Data files were copied with root permissions. I'm not sure why.
- I feel like I could do a better job preparing the image so that it doesn't have as many layers.

I am purposefully putting content files (`trump-tweets.ipynb`, trump_tweets_df.rda) *into* the image to make it easy to just pull the image down from Dockerhub, but I am not sure how people will feel about this decision. I think my uneasiness speaks to the gaps in how to manage data in Docker containers. That said, this decision is part of some experiments in thinking about Docker containers as *media*.
