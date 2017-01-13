#!/bin/bash


BUILDDIR=/home/fox/buildenv/root/
WEBDIR=/var/www
BASEDIR=dists/jessie
WORKDIR=$BASEDIR/main/binary-armhf
GPG_KEY=1234ABCD	# Your GPG Fingerprint

echo -e "# \e[32mSign new files...\e[0m"
cd $BUILDDIR
dpkg-sig -k $GPG_KEY --cache-passphrase --sign builder *.deb

echo -e "# \e[32mCopy new files...\e[0m"
for i in *.deb; do
	echo -e "Copying \e[32m$i\e[0m..."
	mkdir -p $WEBDIR/$WORKDIR/${i:0:1}
	cp -u $i $WEBDIR/$WORKDIR/${i:0:1}/
done

echo -e "# \e[32mCreating Packages...\e[0m"
cd $WEBDIR
apt-ftparchive packages $BASEDIR/main > $WORKDIR/Packages

echo -e "# \e[32mCreating Packages.gz...\e[0m"
gzip -c $WORKDIR/Packages > $WORKDIR/Packages.gz

echo -e "# \e[32mCreating Release...\e[0m"
cat <<EOF > $BASEDIR/Release
Origin: Debian
Label: Debian
Suite: stable
Version: 8.0
Codename: jessie
Architectures: armhf
Components: main
EOF

apt-ftparchive release $BASEDIR >> $BASEDIR/Release
rm $BASEDIR/Release.gpg
gpg --armor --detach-sign --output $BASEDIR/Release.gpg $BASEDIR/Release
#cp -u $BASEDIR/Release $BASEDIR/main/

echo -e "# \e[32mDone!\e[0m"
echo -e "# \e[32mPackages in repo: \e[33m`find $WORKDIR -name '*.deb' | wc -l`\e[0m"
