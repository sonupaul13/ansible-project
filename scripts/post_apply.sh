#!/bin/bash
set -e

SSH_KEY="/home/atlantis/.atlantis/ssh_key"
TF_OUTPUT_FILE="../vm_ips.json"

echo "[Atlantis] Generating Ansible inventory..."
terraform output -json vm_public_ips > "$TF_OUTPUT_FILE"

cd ../ansible
rm -f inventory.txt

# Create role-based temp files
touch mongo.txt solr.txt postgres.txt

jq -c '.[]' "$TF_OUTPUT_FILE" | while read -r vm; do
  ip=$(echo "$vm" | jq -r '.ip')
  username=$(echo "$vm" | jq -r '.username')
  role=$(echo "$vm" | jq -r '.role')

  ssh-keygen -R "$ip" || true

  echo "$ip ansible_user=$username ansible_ssh_private_key_file=$SSH_KEY ansible_ssh_common_args='-o StrictHostKeyChecking=no'" >> "$role.txt"
done

# Combine into inventory.txt
for role in mongo solr postgres; do
  if [ -s "$role.txt" ]; then
    echo "[$role]" >> inventory.txt
    cat "$role.txt" >> inventory.txt
    echo "" >> inventory.txt
  fi
done

rm -f mongo.txt solr.txt postgres.txt

echo "[Atlantis] Inventory generated:"
cat inventory.txt

ansible-playbook -i inventory.txt site.yml --tags os_update