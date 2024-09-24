FROM mcr.microsoft.com/playwright:v1.45.1-jammy
# Australianise things:
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y locales && \
    locale-gen en_AU.UTF-8 && \
    update-locale en_AU.UTF-8 && \
    LANG=en_AU.UTF-8 && \
    LC_ALL=en_AU.UTF-8 && \
    locale
    
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -yq tzdata && \
    ln -fs /usr/share/zoneinfo/Australia/Sydney /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata && \
    date

# Shift into test environment
WORKDIR /cmfive-boilerplate/test/playwright
