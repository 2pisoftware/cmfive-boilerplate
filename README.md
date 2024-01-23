# cmfive-boilerplate ![Build Status](https://travis-ci.org/adam-buckley/cmfive-boilerplate.svg?branch=master)
A boilerplate project layout for Cmfive

## Deploying a development environment with docker-compose

### Requirements

- docker
- docker-compose

### Setting up

For development we recommend the Docker plugin by Microsoft for VS Code. Simply right click on the **docker-compose.yml** file and select **Compose Up**.

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

## Logging in

From there, navigate to: [http://localhost:3000](http://localhost:3000) and log in with your admin account. For development it is:

- Username: admin
- Password: admin

## HTTPS

If you need to test on HTTPS it's available on [https://localhost:3443](https://localhost:3443). It's configured with a self-signed certificate, ignore the browser warning.
  
## Changing the cmfive-core branch

When you work on the system directory you may need to change the branch. To do this you can run this command:

```sh
# Replace develop with your desired branch
docker exec -it cmfive ./cmfive.php install core develop
```