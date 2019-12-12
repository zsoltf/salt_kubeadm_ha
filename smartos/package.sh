#
# Copy and paste the lines below to install the latest 64-bit tools set.
#
BOOTSTRAP_TAR="bootstrap-trunk-tools-20190317.tar.gz"
BOOTSTRAP_SHA="7a17d30ee4fbd1203497ae424dcd64c40ccf5503"

# Ensure you are in a directory with enough space for the bootstrap download,
# by default the SmartOS /root directory is limited to the size of the ramdisk.
cd /var/tmp

# Download the bootstrap kit to the current directory.  Note that we currently
# pass "-k" to skip SSL certificate checks as the GZ doesn't install them.
curl -kO https://pkgsrc.joyent.com/packages/SmartOS/bootstrap/${BOOTSTRAP_TAR}

# Verify the SHA1 checksum.
[ "${BOOTSTRAP_SHA}" = "$(/bin/digest -a sha1 ${BOOTSTRAP_TAR})" ] || echo "ERROR: checksum failure"

# Verify PGP signature.  This step is optional, and requires gpg.
curl -kO https://pkgsrc.joyent.com/packages/SmartOS/bootstrap/${BOOTSTRAP_TAR}.asc
curl -ksS https://pkgsrc.joyent.com/pgp/DE817B8E.asc | gpg --import
gpg --verify ${BOOTSTRAP_TAR}{.asc,}

# Install bootstrap kit to /opt/tools
tar -zxpf ${BOOTSTRAP_TAR} -C /

# Add to PATH/MANPATH.
PATH=/opt/tools/sbin:/opt/tools/bin:$PATH
MANPATH=/opt/tools/man:$MANPATH
