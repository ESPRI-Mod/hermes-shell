# Login as root.
su

# Goto working directory.
cd /opt

# Ensure that git is available.
yum install git

# Clone prodiguer shell.
git clone https://github.com/momipsl/prodiguer-shell.git prodiguer

# Run boostrapper.
./prodiguer/exec.sh bootstrap

# Run postgresql installer.
# Note - to be executed only if pgres is not already installed.
./prodiguer/exec.sh run-centos-db-server-pginstall

# Run db server setup.
./prodiguer/exec.sh run-centos-db-server-setup

# Install stack.
./prodiguer/exec.sh install

# Install db.
./prodiguer/exec.sh run-db-install

# Verify by running db tests.
./prodiguer/exec.sh run-tests db