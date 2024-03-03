# cmfive-boilerplate Configuration Support
This folder contains variations of configuration files and scripts for purpose.

## Maintained:

### EC2

Assists AWS Codepipeline deployment, via appspec.yml in this repository.

### ECS

Assists on demand deployment into AWS, via containerisation.

### Docker

Contains setup for a complete cmfive installation with a production build of the theme, via Dockerfile in this repository.

## Test Agent

Used by Github actions for a consistent test environment on branch activity, via ci.yml in cmfive-core.
  
## Custom Environments

When rolling your own environment, consider the resources in Local Dev as a common baseline.
For concerns related to Production release, EC2 and ECS reflect a more constrained running system.

