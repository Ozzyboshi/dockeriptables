# dockeriptables
Manage iptables for docker container orchestrated by fig

This bash script queries Docker for running containers and launches other bash script according to the project and containers name passing data read from docker inspect to form new iptables rules.
