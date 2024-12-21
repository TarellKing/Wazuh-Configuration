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
