Nov 26 16:51:11 Slurm01 systemd[1]: Started Slurm REST daemon.
Nov 26 16:51:11 Slurm01 slurmrestd[201999]: [2025-11-26T16:51:11.406] error: Parse error in file /etc/slurm/jwt.key line 1: "b4b8e6e3f63399f111729b3753f78853f6e2fa918904e50d7556d2949ab45e9e"
Nov 26 16:51:11 Slurm01 slurmrestd[201999]: [2025-11-26T16:51:11.406] error: ClusterName needs to be specified
Nov 26 16:51:11 Slurm01 slurmrestd[201999]: [2025-11-26T16:51:11.406] fatal: Unable to process configuration file
Nov 26 16:51:11 Slurm01 slurmrestd[201999]: error: Parse error in file /etc/slurm/jwt.key line 1: "b4b8e6e3f63399f111729b3753f78853f6e2fa918904e50d7556d2949ab45e9e"
Nov 26 16:51:11 Slurm01 systemd[1]: slurmrestd.service: Main process exited, code=exited, status=1/FAILURE
Nov 26 16:51:11 Slurm01 slurmrestd[201999]: error: ClusterName needs to be specified
Nov 26 16:51:11 Slurm01 systemd[1]: slurmrestd.service: Failed with result 'exit-code'.
Nov 26 16:51:11 Slurm01 slurmrestd[201999]: fatal: Unable to process configuration file
[Unit]
Description=Slurm REST daemon
After=network-online.target remote-fs.target slurmctld.service
Wants=network-online.target
ConditionPathExists=/etc/slurm/slurm.conf

[Service]
Type=simple
EnvironmentFile=-/etc/sysconfig/slurmrestd
EnvironmentFile=-/etc/default/slurmrestd
# slurmrestd should never run as root or the slurm user.
# Use a drop-in to change the default User and Group to site specific IDs.
User=slurmrestd
Group=slurmrestd
ExecStart=/usr/sbin/slurmrestd  -s /var/run/slurmrestd.sock -a rest_auth/jwt -f /etc/slurm/jwt.key
# Enable auth/jwt be default, comment out the line to disable it for slurmrestd
Environment=SLURM_JWT=daemon
# Listen on TCP socket by default.
Environment=SLURMRESTD_LISTEN=:6820
ExecReload=/bin/kill -HUP $MAINPID

[Install]
WantedBy=multi-user.target
