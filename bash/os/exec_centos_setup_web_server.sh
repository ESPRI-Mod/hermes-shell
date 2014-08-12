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

# Run web server setup.
prodiguer setup-centos-web-server

# Install stack.
./prodiguer/exec.sh install

# Restart nginx.
nginx -s reload
