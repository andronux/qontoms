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

# Swarm services running
    root@ms-qonto:~/deployment# docker service list
    ID                  NAME                MODE                REPLICAS            IMAGE                                   PORTS
    3lle7a2lndul        ms1                 replicated          3/3                 registry.ganditest.us:5000/ms1:master
    83n1j9wwbjio        ms2                 replicated          3/3                 registry.ganditest.us:5000/ms2:master

# Swarm services update history
    root@ms-qonto:~/deployment# docker service ps ms1
	ID                  NAME                IMAGE                                   NODE                DESIRED STATE       CURRENT STATE             ERROR               PORTS
	r2he7u3v86kf        ms1.1               registry.ganditest.us:5000/ms1:master   ms-qonto2           Running             Running 30 minutes ago                        *:8686->80/tcp
	hx4dc7fnvoiv         \_ ms1.1           registry.ganditest.us:5000/ms1:master   ms-qonto2           Shutdown            Shutdown 30 minutes ago
	07hc1c8bgxhr         \_ ms1.1           registry.ganditest.us:5000/ms1:master   ms-qonto2           Shutdown            Shutdown 33 minutes ago
	asebwgpdpcik         \_ ms1.1           registry.ganditest.us:5000/ms1:master   ms-qonto2           Shutdown            Shutdown 39 minutes ago
		wclrnva98pmv         \_ ms1.1           registry.ganditest.us:5000/ms1:master   ms-qonto2           Shutdown            Shutdown 41 minutes ago
	ogbvhxtq7puk        ms1.2               registry.ganditest.us:5000/ms1:master   ms-qonto3           Running             Running 30 minutes ago                        *:8686->80/tcp
	hwnyeef192i8         \_ ms1.2           registry.ganditest.us:5000/ms1:master   ms-qonto3           Shutdown            Shutdown 30 minutes ago
	vvfo1395omz1         \_ ms1.2           registry.ganditest.us:5000/ms1:master   ms-qonto3           Shutdown            Shutdown 32 minutes ago
	8ywr1ldel3ik         \_ ms1.2           registry.ganditest.us:5000/ms1:master   ms-qonto3           Shutdown            Shutdown 39 minutes ago
	qqw06zhgdhvk         \_ ms1.2           registry.ganditest.us:5000/ms1:master   ms-qonto3           Shutdown            Shutdown 40 minutes ago
	shglqsnbnsqi        ms1.3               registry.ganditest.us:5000/ms1:master   ms-qonto            Running             Running 29 minutes ago                        *:8686->80/tcp
	l7jdwfgd3yf3         \_ ms1.3           registry.ganditest.us:5000/ms1:master   ms-qonto            Shutdown            Shutdown 29 minutes ago
	gbax4lz8u4hn         \_ ms1.3           registry.ganditest.us:5000/ms1:master   ms-qonto            Shutdown            Shutdown 32 minutes ago
	4z83b0bs4o4d         \_ ms1.3           registry.ganditest.us:5000/ms1:master   ms-qonto            Shutdown            Shutdown 40 minutes ago
	7c54drgcjnpa         \_ ms1.3           registry.ganditest.us:5000/ms1:master   ms-qonto            Shutdown            Shutdown 41 minutes ago
 
    root@ms-qonto:~/deployment# docker service ps ms2
    ID                  NAME                IMAGE                                   NODE                DESIRED STATE       CURRENT STATE                ERROR               PORTS
    ix00kc0heuf6        ms2.1               registry.ganditest.us:5000/ms2:dev      ms-qonto3           Running             Running 30 seconds ago                           *:8787->80/tcp
    pzitjgze3vik         \_ ms2.1           registry.ganditest.us:5000/ms2:master   ms-qonto3           Shutdown            Shutdown 31 seconds ago
    obtbhyhx1igk         \_ ms2.1           registry.ganditest.us:5000/ms2:master   ms-qonto3           Shutdown            Shutdown 37 minutes ago
    r8lwsjq7hq5j         \_ ms2.1           registry.ganditest.us:5000/ms2:master   ms-qonto3           Shutdown            Shutdown 39 minutes ago
    ysmvrb9vgaev         \_ ms2.1           registry.ganditest.us:5000/ms2:master   ms-qonto3           Shutdown            Shutdown about an hour ago
    t2bmvet87xtk        ms2.2               registry.ganditest.us:5000/ms2:dev      ms-qonto            Running             Running 2 seconds ago                            *:8787->80/tcp
    qruq7nb6673w         \_ ms2.2           registry.ganditest.us:5000/ms2:master   ms-qonto            Shutdown            Shutdown 5 seconds ago
    j74s0ya11ox7         \_ ms2.2           registry.ganditest.us:5000/ms2:master   ms-qonto            Shutdown            Shutdown 37 minutes ago
    zmahlh2h7d29         \_ ms2.2           registry.ganditest.us:5000/ms2:master   ms-qonto            Shutdown            Shutdown 39 minutes ago
    0xjb1ch3qzmx         \_ ms2.2           registry.ganditest.us:5000/ms2:master   ms-qonto            Shutdown            Shutdown about an hour ago
    3e2m8d1gr5l5        ms2.3               registry.ganditest.us:5000/ms2:dev      ms-qonto2           Running             Running 17 seconds ago                           *:8787->80/tcp
    q9flzc9ycjs7         \_ ms2.3           registry.ganditest.us:5000/ms2:master   ms-qonto2           Shutdown            Shutdown 18 seconds ago
    b72lm2jjnfuc         \_ ms2.3           registry.ganditest.us:5000/ms2:master   ms-qonto2           Shutdown            Shutdown 36 minutes ago
    5pt5nceiwrnf         \_ ms2.3           registry.ganditest.us:5000/ms2:master   ms-qonto2           Shutdown            Shutdown 40 minutes ago
    fljohxojiwzt         \_ ms2.3           registry.ganditest.us:5000/ms2:master   ms-qonto2           Shutdown            Shutdown about an hour ago
