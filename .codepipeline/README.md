# cmfive-boilerplate Configuration Support
This folder contains variations of configuration files and scripts for purpose.

## Maintained:

### EC2

Assists AWS Codepipeline deployment, via appspec.yml in this repository.

### ECS

Assists on demand deployment into AWS, via containerisation.

## Local Dev

Assists containerised setup for local use, or other container friendly environments like Github Codespaces.

## Test Agent

Used by Github actions for a consistent test environment on branch activity, via ci.yml in cmfive-core.
  
## Custom Environments

When rolling your own environment, consider the resources in Local Dev as a common baseline.
For concerns related to Production release, EC2 and ECS reflect a more constrained running system.

