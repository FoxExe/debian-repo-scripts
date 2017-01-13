# Script for generate simple debian packages repository from .deb files
----------

### Notes:
- Install dependencies:
`apt install gpg dpkg-sing`
- Generate your gpg key:
`gpg --gen-key`
- Upload your public key to gpg server (12345678 - fingerprint of your key)
`gpg --send-keys 12345678`
- Export public key to file:
`gpg --armor --export 12345678 --output key_public.gpg`
- Export private key to file (Make a backup!):
`gpg --export-secret-key -a 12345678 --output key_private.key`
- Export gpg key to apt-key:
`gpg -a --export 12345678 | apt-key add -`
- Sign all deb archives in current folder:
`dpkg-sig -b -k 12345678 --sign builder *.deb`
