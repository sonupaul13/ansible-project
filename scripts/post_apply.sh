# #!/bin/bash
# set -e
# set -x
# SSH_KEY_PATH="/home/atlantis/.atlantis/ssh_key"

# echo "[Atlantis] Running post-apply script..."

# echo "[Atlantis] Fetching VM IPs from Terraform output..."
# terraform output -json vm_public_ips > ../vm_ips.json

# cd ../ansible

# rm -f inventory.txt

# echo "[web]" > inventory.txt

# mkdir -p ~/.ssh
# touch ~/.ssh/known_hosts

# for ip in $(jq -r '.[]' ../vm_ips.json); do
#   echo "[Atlantis] Waiting for SSH to become available on $ip..."
#   for i in {1..12}; do  # Wait up to 60 seconds (12 * 5s)
#     if ssh -i "$SSH_KEY_PATH" -o StrictHostKeyChecking=no -o ConnectTimeout=5 sandeeppaul@$ip "echo SSH ready" >/dev/null 2>&1; then
#       echo "[Atlantis] SSH is ready on $ip"
#       break
#     else
#       echo "[Atlantis] SSH not ready on $ip, retrying in 5 seconds..."
#       sleep 5
#     fi
#   done

#   ssh-keygen -R "$ip" || true
#   echo "$ip ansible_user=sandeeppaul ansible_ssh_private_key_file=\"$SSH_KEY_PATH\" ansible_ssh_common_args='-o StrictHostKeyChecking=no'" >> inventory.txt
# done

# echo "[Atlantis] Generated inventory:"
# cat inventory.txt

# echo "[Atlantis] Running Ansible playbook..."
# ansible-playbook -i inventory.txt main.yml

#!/bin/bash
set -e
set -x

SSH_KEY_PATH="/home/atlantis/.atlantis/ssh_key"

echo "[Atlantis] Running post-apply script..."

echo "[Atlantis] Fetching VM IPs from Terraform output..."
terraform output -json vm_public_ips > ../vm_ips.json

cd ../ansible

rm -f inventory.txt
echo "[web]" > inventory.txt

mkdir -p ~/.ssh
touch ~/.ssh/known_hosts

jq -c '.[]' ../vm_ips.json | while read -r vm; do
  ip=$(echo "$vm" | jq -r '.ip')
  username=$(echo "$vm" | jq -r '.username')

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
  echo "$ip ansible_user=$username ansible_ssh_private_key_file=\"$SSH_KEY_PATH\" ansible_ssh_common_args='-o StrictHostKeyChecking=no'" >> inventory.txt
done



echo "[Atlantis] Generated inventory:"
cat inventory.txt

echo "[Atlantis] Running Ansible playbook..."
ansible-playbook -i inventory.txt main.yml
