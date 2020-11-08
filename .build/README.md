# Summary
The `.build` directory contains all the source and configuration files required for continuous delivery and deployment.

**Directory Structure:**
***infrastructure***
`<add content>`

***common***

This directory contains common cmfive configs used by the various environments.

***environment***

This directory contains a sub-directory per environment, `default`, `dev` and `prod`; each sub-directory contain environment specific docker and cmfive configuration files.

***setup***

This directory contains the Python source code that exposes a command line interface. 

The command line interface provides several commands to configure a docker environment and cmfive installation for both developers and automated processes.

**Environments**

***default***

The intent of the default environment is to provide a mechanism whereby the developer can provision a docker environment with `docker-compose up` from a fresh clone of the boilerplate repository. 

Further `cmfive` setup steps are manual.

The root directory contains `docker-compose.yml`, and the `default` environment folder contains a `config.yml`, `Docker` file and a `stage` directory.

The `config.yml` has configuration values used to regenerate the `docker-compose.yml`, `Docker` file and `stage` directory via the `cmfive cli` utility - *see section cmfive commands*.

***dev***

The intent of this environment is to provide a mechanism whereby a developer can provision a fully configured containerized instance of cmfive via the cmfive cli utility; web and database container.

The `cmfive cli` command `provision-dev` uses the config values in `config.yml` within the `dev` environment folder to customize docker-compose and cmfive.

The first step the provision performs is stage the `dev` environment for docker-compose to successfully run. This is achieved by replacing the `docker-compose.yml` file in the root directory, and generates the `Docker` file and `stage` directory within the `dev` environment folder.

The second step the provision performs is issue a `docker-compose up`. As a consequence if the web image does not exist, the `Dockerfile` file in the `dev` environment folder is used to create the image. All configs for the image build reside in the `stage` directory.

The third step the provision performs once the docker-compose environment is up is configure the `web` and `database` containers. All configs used by this step reside in the `stage` directory.

***prod***

`<add content>`

- add contnet about prod/deploy dir, referenced by cmfive-cicd cdk project

# Setup
The following steps describe how to set up and activate a Python Virtual Environment to run the `install.py` script. This script is the entry point for the cmfive CLI.

*Prerequisites:*

 - Python Version >= 3.6
 - Docker
 - Docker Compose

*Installation:*
Change directory
```
cd .build/setup
```

Create Python Virtual Environment
```
python3 --version
python3 -m venv venv
```

Activate and verify Python Virtual Environment
```
source venv/bin/activate
which python
which pip
```
Install Python packages into Virtual Environment
```
pip install -r requirements.txt
```

Display cmfive command line options
```
python install.py --help
```

# CLI Commands
