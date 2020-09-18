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


***dev***

***prod***

**Configure Environment**
`<content>`

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
