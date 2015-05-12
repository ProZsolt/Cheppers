## Project Summary:
* Launch a production-grade Drupal hosting cluster on the cloud
* Document everything you do (including your code) and your learnings along the way
* Present your solution architecture & learnings at an interview

## High Level TODOs:
1. Obtain an AWS account.
   * Use an existing account of yours 
   * Or sign up for an Amazon AWS account to be able to launch a t2.micro (t2.micros are free for the first year)
2. Write a Ruby CLI script that will launch/suspend the server(s). Your Ruby script should use the AWS SDK or 3rd party Ruby code (gems) to talk to Amazon to control your server
3. Install Puppet or another configuration management system (Chef, Ansible, etc.) on your server(s)
4. Have the configuration management system install the basic LAMP stack (PHP, Apache, MySQL, etc.)
5. Have your Ruby CLI script or the configuration management system install Drupal
6. Add a method to your Ruby script to test that Drupal is running (returns a 200 response code and some HTML content from the Drupal page)

## Project Goals:
* Show familiarity with AWS
* Show familiarity with Linux
* Show being able to pick up new skills (Ruby, LAMP technologies, Drupal, etc.)
* Show capability to use configuration management
* Show capability to use version control
* Show attention to detail and documentation skills

## Bonus Points:
* Ensure the stack is Highly Available (no SPOFs)
* Have your CLI script simulate an outage and prove the site is still responsive
* Utilize AWS tech such as CloudFormation or autoscaling for setting up the HA cluster
* Utilize AWS tech such as RDS or ElasticCache for MySQL and Memcache connectivity
* Have a working persistent filesystem for Drupal (GlusterFS, Ceph, S3 Drupal integration, etc.)
* Have your Ruby CLI script also work as a REST API
* Use technologies such as Docker in your solution
* Package up your solution in working GitHub projects or Vagrant/Docker images