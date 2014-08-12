# Login as root.
su

# Goto working directory.
cd /opt

# Ensure that git is available.
yum install git

# Clone prodiguer shell.
git clone https://github.com/Prodiguer/prodiguer-shell.git prodiguer

# Run boostrapper.
./prodiguer/exec.sh bootstrap

# Run db server setup.
prodiguer setup-centos-mq-server

# Install stack.
./prodiguer/exec.sh install
