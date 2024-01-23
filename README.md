# cmfive-boilerplate ![Build Status](https://travis-ci.org/adam-buckley/cmfive-boilerplate.svg?branch=master)
A boilerplate project layout for Cmfive

### Local hosting/deployment with docker-compose
Requirements:
- docker
- mkcert

Install the root CA on your machine so that the SSL certificate is trusted (you can skip this and opt to go through the warning pages that browsers will give you):
run from the boilerplate directory:

```bash
cd .build/certs
mkcert -install
```

Once done you can start the containers. For development we recommend the Docker plugin by Microsoft for VS Code. Simply right click on the **docker-compose.yml** file and select **Compose Up**.

Alternatively to run it on the CLI:

```bash
docker-compose up -d
```

Give it a few minutes. You can check the status in VS Code on the Docker tab. Important containers will report "healthy". 


Alternatively you can check on the CLI:
```bash
docker ps
```

NOTE: The compiler will always start after cmfive is running.

From there, navigate to: [http://localhost:3000](http://localhost:3000) and log in with your admin account. For development it is:

- Username: admin
- Password: admin
  