# Compiles the theme
FROM node:18-alpine

# First install git
RUN apk --no-cache add \
    git

# Then clone github.com/2pisoftware/cmfive-core
RUN git clone https://github.com/2pisoftware/cmfive-core

# Change to system/templates/base ready to compile
WORKDIR /cmfive-core/system/templates/base

# Create the /compiled dir
RUN mkdir -p /compiled

# Start the compile
CMD ["sh", "-c", "npm install && npm run production && cp -R dist/* /compiled/"]
