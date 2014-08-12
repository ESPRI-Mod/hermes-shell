# Login as root.
su

# Goto working directory.
cd /opt

# Ensure that git is available.
yum install git

# Clone prodiguer shell.
git clone https://github.com/Prodiguer/prodiguer-shell.git prodiguer

# Set alias.
alias prodiguer=./prodiguer/exec.sh

# Run db server setup.
prodiguer setup-centos-db-server

# Install stack.
prodiguer stack-bootstrap
prodiguer stack-install

# Install db.
prodiguer run-db-install

# Verify by running db tests.
prodiguer run-tests db