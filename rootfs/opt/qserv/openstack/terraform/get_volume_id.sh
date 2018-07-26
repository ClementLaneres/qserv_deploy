#!/bin/bash

# Number of first volume
echo "first_volume = 100" >> ../terraform.tfvars
# Get volume list
openstack volume list | grep vol-qserv >> volume.txt

# Add volume in variables.tf
echo "# volume id
volume_id = {">> terraform.tfvars

nb_ligne=`wc -l volume.txt| grep -o "^[0-9]\+"`
for i in `seq 1 ${nb_ligne}`
do
	ligne=`sed -n "${i} p" volume.txt`
	ID=${ligne:2:36}
	nb_volume=${ligne:40}
	nb_volume=`echo ${nb_volume} | cut -d'|' -f1 | grep -o "[0-9]\+"`
	echo "\"${nb_volume}\"=\"${ID}\"" >> ../terraform.tfvars
done
echo "}" >> ../terraform.tfvars

rm volume.txt

