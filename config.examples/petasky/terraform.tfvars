# Use this file to tune your cluster parameters
# For a complete reference of all variables, see variables.tf
# Commented lines are optionnal parameters at default value

# Flavor of the cluster nodes
flavor = "q1.large"

# Snapshot to use in the cluster nodes
snapshot = "k8s-anf"

# OpenStack network name of the cluster
network = "petasky-net"

# Prefix for all instances names
instance_prefix = "kube-"

# Number of workers node
nb_worker = 78 

# Number of k8s master
# nb_orchestrator = 1

# Private key used to ssh on nodes
ssh_private_key = "~/.ssh/id_rsa_anf"

# Security group to add to nodes
security_groups = ["default"]

# OpenStack ip pool name for floating ip
ip_pool = "ext-publicnet"

# Docker registry ip
docker_registry_host = "192.168.56.109"

# Docker registry port
# docker_registry_port = 5000

# Amout of memory which can be locked in container (in Bytes)
# Defaut to 'infinity'
limit_memlock = "10737418240"
