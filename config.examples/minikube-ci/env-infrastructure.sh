# Parameters related to Openstack instructure
# WARN: automatically generated by provisionning script, do not edit

# Used for ssh access
# Use '-MK-' for minikube
MASTER="-MK-"

# Used for ssh access
# Use one '-MK-' per node for minikube
WORKERS="-MK- -MK-"

# Used for ssh access to Kubernetes master
ORCHESTRATOR="$HOSTNAME"
