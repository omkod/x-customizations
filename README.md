#Redmine customizations

**Functions:**

1) Adds avatar for anonymous user.
2) Winmail.dat converstion into initial attachments.

**Installation:**

```
ssh -p 222 localhost
cd /home/r/riteil/.local
wget http://sourceforge.net/projects/tnef/files/tnef/v1.4.7/tnef-1.4.7.tar.gz/download
tar -xzvf tnef-1.4.7.tar.gz
cd tnef-1.4.7
./configure --prefix=/home/r/riteil/.local
make
make check
make install
whereis tnef

// Get tnef bin path

// Go to redmine root and make
bundle update

``

To make TNEF (winmail.dat conversion) working set path to tnef bin here /settings/plugin/x_customizations

