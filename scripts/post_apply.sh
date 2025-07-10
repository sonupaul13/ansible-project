#!/bin/bash
set -e
set -x

SSH_KEY_PATH="/home/atlantis/.atlantis/ssh_key"

echo "[Atlantis] Running post-apply script..."

echo "[Atlantis] Fetching VM IPs from Terraform output..."
terraform output -json vm_public_ips > ../vm_ips.json

cd ../ansible

rm -f inventory.txt
touch inventory.txt

mkdir -p ~/.ssh
touch ~/.ssh/known_hosts

# Loop over each VM entry in the output
jq -c '.[]' ../vm_ips.json | while read -r vm; do
  ip=$(echo "$vm" | jq -r '.ip')
  username=$(echo "$vm" | jq -r '.username')
  tags=$(echo "$vm" | jq -r '.tags | join(",")')

  # Check for any matching tags (mongo, postgres, solr)
  if echo "$tags" | grep -q -E "mongo|postgres|solr"; then
    echo "[Atlantis] Waiting for SSH to become available on $ip..."
    for i in {1..12}; do
      if ssh -i "$SSH_KEY_PATH" -o StrictHostKeyChecking=no -o ConnectTimeout=5 "$username@$ip" "echo SSH ready" >/dev/null 2>&1; then
        echo "[Atlantis] SSH is ready on $ip"
        break
      else
        echo "[Atlantis] SSH not ready on $ip, retrying in 5 seconds..."
        sleep 5
      fi
    done

    ssh-keygen -R "$ip" || true

    echo "$ip ansible_user=$username ansible_ssh_private_key_file=$SSH_KEY_PATH ansible_ssh_common_args='-o StrictHostKeyChecking=no'" >> inventory.txt
  else
    echo "[Atlantis] Skipping $ip — no required tags found: $tags"
  fi
done

echo "[Atlantis] Generated inventory:"
cat inventory.txt

LOG_DIR="../ansible_logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/ansible_$(date +%Y%m%d_%H%M%S).log"

echo "[Atlantis] Running Ansible playbook..."
ansible-playbook -i inventory.txt site.yml --tags mongo,postgres | tee "$LOG_FILE"
