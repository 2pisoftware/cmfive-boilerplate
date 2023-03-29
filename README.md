# cmfive-boilerplate ![Build Status](https://travis-ci.org/adam-buckley/cmfive-boilerplate.svg?branch=master)
A boilerplate project layout for Cmfive

### Local hosting/deployment with docker-compose
Requirements:
- docker
- mkcert

Install the root CA on your machine so that the SSL certificate is trusted (you can skip this and opt to go through the warning pages that browsers will give you):
run from the boilerplate directory
```bash
cd .build/certs
mkcert -install
```

Once done you can start the containers. For development we recommend the Docker plugin by Microsoft for VS Code. To run it on the CLI:
```bash
docker-compose up
```

Ensure you also have MySQL running, to set up one in a container:
```bash
docker run mysql:5.7 --net=host
```

Once everything is running alter the config.php to point at your mysql instance and run:
```bash
php cmfive.php install core
php cmfive.php install migrations
```

Then seed an admin user:
```
php cmfive.php
[select option 3 and fill in the prompts]
```

From there, navigate to [https://localhost:9002](https://localhost:9002) and log in with your admin account.