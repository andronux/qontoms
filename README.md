# qontoms
Deployment branch featured
===================

Requirements
----------
 - 3 docker/swarms one being the manager. (I used 3 instances at scaleway since my laptop had some troubles)
 - nginx : listening on the node manager.
 - jinja2: for vhost templating
 - Dockerfile for each microservice : necessary for building and shipping the new services across the cluster.
 - A private registry: simply because the images will be pulled from each nodes.


How it works
-------------------
The deployment is done using `qontom-deploy.sh`. This script will git clone/checkout the repo, build the new docker images for each ms, generate and reload the vhost configuration and finally, update de the swarm service with the new image along with the proper MS_URL environment .

See output of a deployment in `deploy.log`


> **Note:**
I had to fix a syntax error in web.rb. In addition, I noticed that puma web server wasn't listening on 0.0.0.0.
