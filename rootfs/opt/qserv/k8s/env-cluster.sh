# Directory containing infrastructure specification
# (ssh credentials, machine names)

# Can be used on bare-metal
CLUSTER_CONFIG_DIR="${QSERV_CFG_DIR:-/qserv-deploy/config}"
export KUBECONFIG="${CLUSTER_CONFIG_DIR}/kubeconfig"

# ssh credentials, optional
SSH_CFG="$CLUSTER_CONFIG_DIR/ssh_config"

# ssh option for using configuration file
if [ -r "$SSH_CFG" ]; then
    SSH_CFG_OPT="-F $SSH_CFG"
else
    SSH_CFG_OPT=
fi

# Machine names
ENV_INFRASTRUCTURE_FILE="$CLUSTER_CONFIG_DIR/env-infrastructure.sh"
if [ -r "$ENV_INFRASTRUCTURE_FILE" ]; then
    . "$ENV_INFRASTRUCTURE_FILE"
else
    echo "ERROR: $ENV_INFRASTRUCTURE_FILE is not readable"
    exit 1
fi

if [ ! $CI ]; then
    # GNU parallel ssh configuration
    PARALLEL_SSH_CFG="$CLUSTER_CONFIG_DIR/sshloginfile"
    if [ -z "$CREATE_PARALLEL_SSH_CFG" -a ! -r "$PARALLEL_SSH_CFG" ]; then
        echo "ERROR: $PARALLEL_SSH_CFG is not readable"
        exit 1
    fi
fi
