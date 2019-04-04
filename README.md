## Deploying Sinatra
This will walk you through deploying sinatra app from AssemblyPayments repo to the instance provisioned using the CloudFormation template provided
Prerequisites:
  - ssh access to the application Server
  - access to port 9292 on the instances
  - access to AssemblyPayments repository
  - access to https://github.com/dabidpaolo/zigzagtest

### Usage
##### Deploy CloudFormation Template
Upload the template in cfn-template/simple-asg.json to your AWS account and wait for the instance to be in-service. The template includes installation of the dependencies of sinatra app such as ruby and ruby-bundler. Installation is ran everytime an intance boots up the first time. It is also created with an AutoScalingGroup to persist the instance count whenever the current instance terminates or becomes unavailable.
###### Server details
```
Distributor ID:	Ubuntu
Description:	Ubuntu 16.04.2 LTS
Release:	16.04
Codename:	xenial
```
##### Deploy Sinatra app
Use ```deploy.sh``` using the parameters REF and IP
```
# sh deploy.sh master 1.1.1.1
```
The first parameter checkouts the branch/tag that is to be deployed while the second parameter is the public IP of the instance that is created when the CloudFormation stack is deployed.

Improvement: Upload the tarball created from ```deploy.sh``` to a S3 bucket or a similar storage that is accessible from the instance. From there, we can add a function on the cloudformation's launch config user-data to download and run the code during start up. This way, we can minimize , if not totally iradicate, the downtime of the app whenever the instance terminates or becomes unavailable.

##### Decisions
1. Code is checkedout/cloned locally first before transferring to the server to make sure that only users with access to the repository can deploy changes to the app.
2. Dependency installation is only added during the startup to maximize the use of cloudformation for the configuration-as-a-code platform
3. Instance access is controlled via security group so that we can easily allow users to access the ports needed without going through configuration changes on the server.
