## Deploying Sinatra
###### This will walk you through deploying sinatra app from AssemblyPayments repo to the instance provisioned using the CloudFormation template provided

### Usage
#### Deploy CloudFormation Template
Upload the template in cfn-template/simple-asg.json to your AWS account and wait for the instance to be in-service. The template includes installation of the dependencies of sinatra app such as ruby and ruby-bundler. Installation is ran everytime an intance boots up the first time. It is also created with an AutoScalingGroup to persist the instance count whenever the current instance terminates or becomes unavailable.
###### Server details
```
Distributor ID:	Ubuntu
Description:	Ubuntu 16.04.2 LTS
Release:	16.04
Codename:	xenial
```
#### Deploy Sinatra app
Use ```deploy.sh``` using the parameters REF and IP

```
# sh deploy.sh master 1.1.1.1
```
The first parameter checkouts the branch/tag that is to be deployed while the second parameter is the public IP of the instance that is created when the CloudFormation stack is deployed.
