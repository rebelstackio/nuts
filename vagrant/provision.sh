#!/bin/bash -e
set -a
SCRIPTS_DIR=${SCRIPTS_DIR:-'scripts/'}
#. ${SCRIPTS_DIR}pgconfig.sh
LOG=/vagrant/tmp/log/boot.log
set +a

mkdir -p $(dirname $LOG)

NODE_VER=${NODE_VER:-7.x}

chown vagrant /etc/hosts
echo "$GUEST_IP   $FQDN" >> /etc/hosts

display() {
	echo -e "\n-----> "$0": "$*
}

print_db_usage () {
  echo "Your NUTS environment has been setup"
	echo "  Host: $GUEST_IP  [ $FQDN ]"
	echo "  Guest IP: $GUEST_IP"
	echo "    added:   \"$GUEST_IP   $FQDN\"   to /etc/hosts"
  echo ""
  echo " Getting into the box (terminal):"
  echo "  vagrant ssh"
  echo ""
}

(
export DEBIAN_FRONTEND=noninteractive

PROVISIONED_ON=/etc/vm_provision_on_timestamp
#if [ -f "$PROVISIONED_ON" ]
#then
#  echo "VM was already provisioned at: $(cat $PROVISIONED_ON)"
#  echo "To run system updates manually login via 'vagrant ssh' and run 'apt-get update && apt-get upgrade'"
#  echo ""
#  print_db_usage
#  exit
#`fi

display Installing node
apt update
apt install build-essential -y
curl -sL "https://deb.nodesource.com/setup_$NODE_VER" | sudo -E bash -
sudo apt-get install -y nodejs
# npm needs to be latest version
npm install npm@latest -g


# Update Apt repos
sudo apt-get update

display Installing jq
apt-get -y install jq

#install openssl dependency
apt-get -y install libssl-dev

# Tag the provision time:
date > "$PROVISIONED_ON"

cd ./nuts
npm install

display "Successfully created postgres dev virtual machine with Postgres"
echo ""
print_db_usage

exit 0

) 2>&1 | tee -a $LOG
