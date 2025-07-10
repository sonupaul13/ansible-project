# Ansible-Terraform VM Provisioning & Configuration Project

## Overview

This project demonstrates infrastructure automation using **Terraform** and **Ansible**. We provision **5 virtual machines** using Terraform and then configure each VM using **Ansible roles** to install required services and manage storage using LVM.

## Tools Used

- **Terraform** – For provisioning infrastructure (VMs)
- **Ansible** – For configuration management
- **Cloud Provider** – GCP
- **Operating System** – Rocky

---

## VM Configuration Summary

Each VM has a specific role and configuration:

1. **Base OS Update**
   - All VMs are updated using Ansible.
   - Task is executed using the tag: `os_update`

2. **MongoDB VM**
   - Installs **MongoDB**
   - Sets up **LVM** partitions:
     - `/data`
     - `/logs`
   - Tags: `mongo_setup`, `lvm_setup`

3. **Solr VM**
   - Installs **Apache Solr**
   - Mount Disk
   - Tags: `install_solr`, `mount_disk`

4. **PostgreSQL VM**
   - Installs **PostgreSQL**
   - Sets up **LVM** partitions:
     - `/data`
     - `/logs`
     - `/archive`
   - Tags: `install`, `partition`
