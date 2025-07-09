
# set -e
# set -x

# SSH_KEY_PATH="/home/atlantis/.atlantis/ssh_key"

# echo "[Atlantis] Running post-apply script..."

# echo "[Atlantis] Fetching VM IPs from Terraform output..."
# terraform output -json vm_public_ips > ../vm_ips.json

# cd ../ansible

# rm -f inventory.txt
# echo "[solr]" > inventory.txt

# mkdir -p ~/.ssh
# touch ~/.ssh/known_hosts

# jq -c '.[]' ../vm_ips.json | while read -r vm; do
#   ip=$(echo "$vm" | jq -r '.ip')
#   username=$(echo "$vm" | jq -r '.username')

#   echo "[Atlantis] Waiting for SSH to become available on $ip..."
#   for i in {1..12}; do
#     if ssh -i "$SSH_KEY_PATH" -o StrictHostKeyChecking=no -o ConnectTimeout=5 "$username@$ip" "echo SSH ready" >/dev/null 2>&1; then
#       echo "[Atlantis] SSH is ready on $ip"
#       break
#     else
#       echo "[Atlantis] SSH not ready on $ip, retrying in 5 seconds..."
#       sleep 5
#     fi
#   done



#   ssh-keygen -R "$ip" || true
#   echo "$ip ansible_user=$username ansible_ssh_private_key_file=\"$SSH_KEY_PATH\" ansible_ssh_common_args='-o StrictHostKeyChecking=no'" >> inventory.txt
# done



# echo "[Atlantis] Generated inventory:"
# cat inventory.txt

# echo "[Atlantis] Running Ansible playbook..."
# ansible-playbook -i inventory.txt site.yml --tags install_solr

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

ansible-playbook -i inventory.txt site.yml