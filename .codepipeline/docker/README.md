# Pipeline for building a Cmfive docker image

This directory contains a collection of tools and resources for building and managing the Docker image for Cmfive.

## Dev tools

In this directory you'll find the dev tools script. This provides testing tools that are used across CI, local development and codespaces.

To install the dev tools for a local environment, run the following command:

```sh
cd /path/to/cmfive-boilerplate/.codepipeline/docker
./install_dev_tools.sh
```
## Testing out changes for the docker image

You can test out how your changes would look by building a new image with the same tag as what is defined in the docker-compose.yml file. Eg:

```sh
cd /path/to/cmfive-boilerplate
docker build -t ghcr.io/2pisoftware/cmfive:develop .
```

Then once you do a `docker compose up` it will use the image you just built.

Note that this image is only stored locally and the final image can only be built by the GitHub workflow.

## Github workflow

1. Push to a branch and open a PR
2. The workflow **.github/workflows/docker-image.yml** is triggered
3. The workflow builds the docker image as above and pushes it to the GitHub Container Registry
4. The image is now available at `ghcr.io/2pisoftware/cmfive:pr-<pr-number>`
5. Once the PR is merged, the image is built again and pushed to `ghcr.io/2pisoftware/cmfive:develop` or `ghcr.io/2pisoftware/cmfive:latest` depending on the branch that was merged to.

