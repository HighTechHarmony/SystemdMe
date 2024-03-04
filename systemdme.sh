# Script to automatically generate a systemd service unit for the daemon with specified path
# Usage: bash SystemdMe.sh /path/to/daemon name_of_service_unit
# Author: Scott McGrath
# Date: 2024-03-03

# Get the current user
CURRENT_USERNAME=$(whoami)
# Get the current group
CURRENT_GROUPNAME=$(id -gn)

# Get the path from the first argument into a variable
daemon_path=$1

# Get the name of the service unit from the second argument into a variable
service_unit_name=$2

# If the first argument is empty, print usage and exit
if [ -z "$daemon_path" ]; then
    echo "Usage: bash SystemdMe.sh /path/to/daemon name_of_service_unit"
    exit 1
fi

# See if the first argument is --delete
if [ "$daemon_path" == "--delete" ]; then
    # If the specified service unit exists, delete it
    if [ -f /etc/systemd/system/${service_unit_name}.service ]; then
        echo "Deleting systemd service unit..."
        sudo systemctl stop ${service_unit_name}.service
        sudo systemctl disable ${service_unit_name}.service
        sudo rm /etc/systemd/system/${service_unit_name}.service
        sudo systemctl daemon-reload
        echo "Systemd service unit deleted."
        exit 0
    else
        echo "The specified systemd service unit does not exist."
        exit 1
    fi
fi

# Derive the working directory from the daemon path
working_directory=$(dirname $daemon_path)



# Generate a systemd service unit based on the current directory and user
echo "Generating systemd service unit for  $service_unit_name $daemon_path..."
echo "[Unit]" > ${service_unit_name}.service
echo "Description=Systemd service unit generated by SystemdMe" >> ${service_unit_name}.service
echo "After=multi-user.target" >> ${service_unit_name}.service
echo "[Service]" >> ${service_unit_name}.service
echo "Type=simple" >> ${service_unit_name}.service
echo "User=$CURRENT_USERNAME" >> ${service_unit_name}.service
echo "Group=$CURRENT_GROUPNAME" >> ${service_unit_name}.service
echo "Restart=always" >> ${service_unit_name}.service
echo "WorkingDirectory=$working_directory" >> ${service_unit_name}.service
echo "ExecStart=${daemon_path}" >> ${service_unit_name}.service
echo "[Install]" >> ${service_unit_name}.service
echo "WantedBy=multi-user.target" >> ${service_unit_name}.service

echo "The systemd service unit has been generated at ${service_unit_name}.service"
echo "Do you want to install the systemd service unit and enable it? (Y/n)"
read -r INSTALL_SYSTEMD
# examine the response in a case insensitive manner
INSTALL_SYSTEMD=$(echo "$INSTALL_SYSTEMD" | tr '[:upper:]' '[:lower:]')
if [ "$INSTALL_SYSTEMD" != "n" ]; then
    echo "Installing systemd service unit..."
    sudo mv ${service_unit_name}.service /etc/systemd/system
    sudo systemctl daemon-reload
    sudo systemctl enable ${service_unit_name}.service
    sudo systemctl start ${service_unit_name}.service
else
    echo "Skipping systemd service unit installation..."
fi
