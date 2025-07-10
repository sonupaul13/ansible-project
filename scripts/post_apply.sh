#!/bin/bash
set -e
set -x

SSH_KEY_PATH="/home/atlantis/.atlantis/ssh_key"

echo "[Atlantis] Running post-apply script..."

echo "[Atlantis] Fetching VM IPs from Terraform output..."
terraform output -json vm_public_ips > ../vm_ips.json

cd ../ansible

mkdir -p ~/.ssh
touch ~/.ssh/known_hosts

TAGS_TO_RUN=("mongo" "postgres" "solr")

for TAG in "${TAGS_TO_RUN[@]}"; do
  INVENTORY_FILE="inventory_${TAG}.txt"
  echo "" > "$INVENTORY_FILE"

  jq -c '.[]' ../vm_ips.json | while read -r vm; do
    ip=$(echo "$vm" | jq -r '.ip')
    username=$(echo "$vm" | jq -r '.username')
    tags=$(echo "$vm" | jq -r '.tags | join(",")')

    echo "[Atlantis][DEBUG] VM: $ip | Tags: $tags"

    if echo "$tags" | grep -q "$TAG"; then
      echo "[Atlantis][$TAG] Waiting for SSH to become available on $ip..."
      for i in {1..12}; do
        if ssh -i "$SSH_KEY_PATH" -o StrictHostKeyChecking=no -o ConnectTimeout=5 "$username@$ip" "echo SSH ready" >/dev/null 2>&1; then
          echo "[Atlantis][$TAG] SSH is ready on $ip"
          break
        else
          echo "[Atlantis][$TAG] SSH not ready on $ip, retrying..."
          sleep 5
        fi
      done

      ssh-keygen -R "$ip" || true

      echo "$ip ansible_user=$username ansible_ssh_private_key_file=$SSH_KEY_PATH ansible_ssh_common_args='-o StrictHostKeyChecking=no'" >> "$INVENTORY_FILE"
    fi
  done

  echo "[Atlantis][$TAG] Final Inventory:"
  cat "$INVENTORY_FILE"

  if [[ -s "$INVENTORY_FILE" ]]; then
    LOG_DIR="../ansible_logs"
    mkdir -p "$LOG_DIR"
    LOG_FILE="$LOG_DIR/ansible_$(date +%Y%m%d_%H%M%S)_${TAG}.log"

    echo "[Atlantis][$TAG] Running Ansible playbook..."
    ansible-playbook -i "$INVENTORY_FILE" site.yml --tags "$TAG" | tee "$LOG_FILE"
  else
    echo "[Atlantis][$TAG] No matching hosts for tag $TAG, skipping..."
  fi
done
