# Wazuh Deployment on Ubuntu: A Comprehensive Guide 🚀

## Table of Contents
1. [Introduction](#introduction)
2. [Prerequisites and Setup](#prerequisites-and-setup)
3. [Troubleshooting / Common Issues](#troubleshooting--common-issues)

---

## Introduction
Welcome to our Wazuh deployment guide! This document outlines our journey and methods in implementing **Wazuh**, an open-source security monitoring solution, within an Ubuntu-based network infrastructure. 

🔍 **Why Wazuh?**
Wazuh helps organizations:
- Monitor systems for **security threats**.
- Perform **integrity checking**.
- Respond to **incidents**.
- Ensure **compliance** with regulations.

---

## Prerequisites and Setup
**Tools Used**: VirtualBox 🖥️, Ubuntu Server 🐧, Wazuh Manager, Wazuh Agent

### Required Hardware and Software
|                | **Ubuntu Virtual Machine**[^1] |                |
|----------------|----------------------------|----------------|
| **Wazuh Indexer**[^2] | **Wazuh Server**[^3]    | **Wazuh Dashboard**[^4] |
| Honeypot Machine 1[^5] | Honeypot Machine 2[^5] | Honeypot Machine 3[^5] |

[^1]: Hosts all core infrastructure for Wazuh. It should be set up in bridge mode for external communication.
[^2]: Functions as your SIEM data source, collecting and aggregating log data from various sources.
[^3]: Analyzes data to detect potential threats.
[^4]: Provides a user interface to visualize alerts and logs.
[^5]: Azure virtual machines simulate potential target systems for intrusion detection testing.

💡 **Pro Tip**: For detailed installation steps, visit the [Wazuh Installation Page](https://documentation.wazuh.com/current/installation-guide/wazuh-dashboard/index.html).

---

## Troubleshooting / Common Issues

### SSL Certificate Issues with Loopback IP Address
If you try hosting services on the loopback IP (`127.0.0.1`), you may encounter SSL certificate issues.  
**Solution**: Use a non-loopback IP (e.g., your VM’s private IP). Update your service configuration accordingly to avoid validation errors.

---

### Port Forwarding for Locally Hosted Virtual Machines
When setting up Wazuh on a locally hosted virtual machine (not in a cloud environment), ensure you have port forwarding configured. The Wazuh server listens for log forwarders on **port 1514**, and this port must be externally accessible.  
**Solution**:
1. Configure your router to forward **port 1514 (TCP)** to your VM’s private IP.
2. Assign a **static IP** to your VM to prevent connectivity issues after reboots.
3. Test the port using tools like `nc` or `telnet` from an external device.

---

### Wazuh Indexer Timeout
The Wazuh Indexer might time out during startup due to insufficient timeout settings.  
**Solution**: Use this bash script to increase the timeout and ensure all Wazuh services start automatically:

```bash
# Create the directory for the Wazuh Indexer configuration (if it doesn't exist)
if [ ! -d /etc/systemd/system/wazuh-indexer.service.d ]; then
    sudo mkdir /etc/systemd/system/wazuh-indexer.service.d
fi

# Add the timeout configuration
echo -e "[Service]\nTimeoutStartSec=180" | sudo tee /etc/systemd/system/wazuh-indexer.service.d/override.conf

# Reload systemd to apply the changes
sudo systemctl daemon-reload

# Enable and start Wazuh services
sudo systemctl enable wazuh-dashboard
sudo systemctl start wazuh-manager
sudo systemctl start wazuh-dashboard
sudo systemctl start wazuh-indexer
