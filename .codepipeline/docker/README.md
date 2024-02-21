# Pipeline for building a cmfive docker image

This directory builds an image that contins a complete cmfive installation with a production build of the theme.

## Manual steps for building a docker image locally:

```sh
# Change to the boilerplate repo
cd /path/to/cmfive-boilerplate

# Build the boilerplate image (required)
docker build -t cmfive-boilerplate:latest .

# Build the cmfive image
docker build -t cmfive:latest .codepipeline/docker
```

You will now to have a docker image called `cmfive:latest` that you can run. Eg:

```sh
docker run -p 3000:80 cmfive:latest
```

## Github workflow

1. Push to repo
2. The workflow **.github/workflows/docker-image.yml** is triggered
3. The workflow builds the docker image as above and pushes it to the GitHub Container Registry
4. The image is now available at `ghcr.io/2pisoftware/cmfive`

