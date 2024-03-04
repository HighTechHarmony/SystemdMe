# SystemdMe

Simple bash script to handle the all too common scenario of configuring a system so that a given daemon will startup automatically. This script is intended for those who lament the lost simplicity of adding something to rc.local, i.e.:

`echo "/path/to/daemon" >> /etc/rc.local `

Can now be done with:

`systemdme.sh /path/to/daemon daemon_name`

## Compatibility

Linux, and possibly other OS that uses systemd to manage services

## Usage

### Creation

As in the description above, the basic usage to create a systemd unit is:
`systemdme.sh /path/to/daemon daemon_name`

A systemd unit file is created in the current directory. It will then ask you if you would like it to be installed and enabled. Replying 'y' will cause the file to be moved to the systemd unit library and enabled so that it will run on the next bootup.

### Deletion

It also supports deletion of a systemd unit that was previously created:
`systemdme.sh --delete daemon_name`

or

`systemdme.sh -d daemon_name`
