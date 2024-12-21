# Wazuh Deployment on Ubuntu: A Comprehensive Guide

## Table of Contents
1. [Introduction](#introduction)
2. [Prerequisites and Setup](#prerequisites-and-setup)
3. [Custom Configuration Challenges](#custom-configuration-challenges)

## Introduction
Welcome to our Wazuh deployment guide. This document outlines our journey and methods in implementing Wazuh, an open-source security monitoring solution, within our network infrastructure on an Ubuntu-based server. Wazuh helps organizations monitor their systems for security threats, integrity checking, incident response, and compliance.

## Prerequisites and Setup
**Tools Used**: VirtualBox, Ubuntu Server, Wazuh Manager, Wazuh Agent

### Required Hardware and Software
- **VirtualBox**: Hosts our Ubuntu virtual machines.
- **Ubuntu Server**: The chosen operating system for hosting the Wazuh Manager.
- **Windows Server ISO**: For creating a controlled client environment to monitor.

|                | **Ubuntu Virtual Machine**[^1] |                |
|----------------|----------------------------|----------------|
| **Wazuh Indexer**[^2] | **Wazuh Server**[^3]    | **Wazuh Dashboard**[^4] |
| Honeypot Machine 1[^5] | Honeypot Machine 2[^5] | Honeypot Machine 3[^5] |

[^1]: Hosts all core infrastructure for Wazuh. It should be set up in bridge mode for external communication.
[^2]: Functions as your SIEM data source, collecting and aggregating log data from various sources.
[^3]: Analyzes data to detect potential threats.
[^4]: Provides a user interface to visualize alerts and logs.
[^5]: Azure virtual machines that simulate potential target systems for intrusion detection testing.

**For full details for installing each component, visit the [Wazuh installation page](https://documentation.wazuh.com/current/installation-guide/wazuh-dashboard/index.html).**


## Troubleshooting / Common Issues

### 1. SSL Certificate Issue with Loopback IP Address
I could not host the services on my loopback IP address as I ran into issues with the SSL certificate.

---

### 2. Port Forwarding for Locally Hosted Virtual Machines
When setting up on a locally hosted virtual machine and not a cloud environment, ensure you have access to port forwarding. 

The Wazuh host server listens for its log forwarders on **port 1514**, so without port forwarding, it can be challenging to safely expose your virtual machine to the internet.

---

### 3. Wazuh Indexer Timeout Issue
Occasionally, I encountered a Wazuh Indexer timeout issue. To address this, I created a short bash script that increases the timeout and ensures the Wazuh server starts automatically.

Here is the bash script:

```bash
# Create the directory for the Wazuh Indexer service configuration (if it doesn't exist)
if [ ! -d /etc/systemd/system/wazuh-indexer.service.d ]; then
    sudo mkdir /etc/systemd/system/wazuh-indexer.service.d
fi

# Add the timeout configuration
echo -e "[wazuh-indexer]\nTimeoutStartSec=180" | sudo tee /etc/systemd/system/wazuh-indexer.service.d/override.conf

# Reload systemd to apply changes
sudo systemctl daemon-reload

#Wazuh startup script   
sudo systemctl enable wazuh-dashboard 

sudo systemctl start wazuh-manager
sudo systemctl start wazuh-dashboard
sudo systemctl start wazuh-indexer 
---


