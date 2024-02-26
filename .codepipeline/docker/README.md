# Pipeline for building a Cmfive docker image

This directory builds an image that contins a complete Cmfive installation with a production build of the theme.

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

## Testing out changes for the docker image

You can test out how your changes would look by building a new image with the same tag as what is defined in the docker-compose.yml file. Eg:

```sh
docker build -t cmfive-boilerplate:latest .
docker build -t ghcr.io/2pisoftware/cmfive:develop ./.codepipeline/docker
```

Then once you do a `docker compose up` it will use the image you just built.

Note that this image is only stored locally and the final image can only be built by the GitHub workflow.

## Github workflow

1. Push to a branch and open a PR
2. The workflow **.github/workflows/docker-image.yml** is triggered
3. The workflow builds the docker image as above and pushes it to the GitHub Container Registry
4. The image is now available at `ghcr.io/2pisoftware/cmfive:pr-<pr-number>`
5. Once the PR is merged, the image is built again and pushed to `ghcr.io/2pisoftware/cmfive:develop` or `ghcr.io/2pisoftware/cmfive:latest` depending on the branch that was merged to.


