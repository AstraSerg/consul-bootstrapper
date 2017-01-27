# Consul bootstrapper
Helps to bootstrap [Consul](https://www.consul.io/intro/) cluster with many client and server nodes without the need to care about multiple IP addresses.

---

## Requirements


1. [docker-engine](https://www.docker.com/) 
2. [docker-compose](https://docs.docker.com/compose/)
3. [docker-machine](https://docs.docker.com/machine/)
4. At least 3 docker machines with the resolvable names. I will hostA.example.com, hostB.example.com, hostC.example.com in the example. A custom resolver IP may be set in docm_start_consul.sh

---

## Installation

A Consul cluster [requires](https://www.consul.io/docs/guides/bootstrapping.html) to start the first node with the special flag `-bootstrap` (or `-bootstrap-expect`) . It must be converted to the ordinar server node at the end.

**For the first node in cluster follow the steps below:**

1. Download git clone https://github.com/AstraSerg/consul-bootstrapper.git
2. Uncomment the bootstrap command in the docker-compose.yml file and comment out the main command (at the very end of file)
3. Run `./docm_start_consul.sh hostA.example.com server`

Your first node is done.

**For other nodes in cluster follow these steps:**

1. Comment out bootstrap command and uncomment main command
2. Start the second node `./docm_start_consul.sh hostB.example.com server`
3. Start the third node `./docm_start_consul.sh hostC.example.com server`
4. Convert the first node to the ordinar server node:
4.1. Switch to the first node: `eval $(docker-machine env hostA.example.com)`
4.2. Stop the consul on it: `docker stop consul`
4.3. Remove the container: `docker rm consul`
4.4. Start the server node `./docm_start_consul.sh hostA.example.com server`

The cluster is bootstraped. Now you can add a server node like this:
`./docm_start_consul.sh hostC.example.com server`

or a client node like this:
`./docm_start_consul.sh hostC.example.com client`


---

Written with [StackEdit](https://stackedit.io/).
