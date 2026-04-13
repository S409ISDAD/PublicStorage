#!/bin/bash

# Interactive systemctl service creator

echo "=== Systemctl Service Creator ==="
echo ""

# Ask for path
read -p "Enter the working directory path (press Enter for current directory): " WORK_DIR

# Use current directory if empty
if [ -z "$WORK_DIR" ]; then
    WORK_DIR=$(pwd)
fi

# Validate path exists
if [ ! -d "$WORK_DIR" ]; then
    echo "Error: Directory '$WORK_DIR' does not exist!"
    exit 1
fi

# Get the service name from the last folder
SERVICE_NAME=$(basename "$WORK_DIR")

echo "Working Directory: $WORK_DIR"
echo "Service Name: $SERVICE_NAME"
echo ""

# Ask for the command
read -p "Enter the command to run: " COMMAND

if [ -z "$COMMAND" ]; then
    echo "Error: Command cannot be empty!"
    exit 1
fi

echo ""
echo "Creating service file..."

# Create the systemd service file
SERVICE_FILE="/etc/systemd/system/${SERVICE_NAME}.service"

sudo tee "$SERVICE_FILE" > /dev/null <<EOF
[Unit]
Description=$SERVICE_NAME service
After=network.target

[Service]
Type=simple
WorkingDirectory=$WORK_DIR
ExecStart=$COMMAND
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

echo "Service file created at: $SERVICE_FILE"
echo ""

# Reload and enable the service
echo "Reloading systemd daemon..."
sudo systemctl daemon-reexec
sudo systemctl daemon-reload

echo "Enabling service..."
sudo systemctl enable "$SERVICE_NAME"

echo "Starting service..."
sudo systemctl start "$SERVICE_NAME"

echo ""
echo "=== Service '$SERVICE_NAME' has been created and started ==="
echo ""
echo "Opening logs (Ctrl+C to exit)..."
sleep 2

# Open journalctl to follow logs
sudo journalctl -u "${SERVICE_NAME}.service" -n 100 -f
