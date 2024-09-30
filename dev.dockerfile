FROM ghcr.io/2pisoftware/cmfive:pr-165

# Copy dev tools installer
COPY .codepipeline/docker/cmfive_dev_tools.sh .codepipeline/docker/cmfive_dev_tools.sh

# Run dev tools installer
RUN .codepipeline/docker/cmfive_dev_tools.sh

