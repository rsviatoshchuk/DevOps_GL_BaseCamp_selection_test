#!/bin/bash

name='Rostyslav Sviatoshchuk'
pathToHTML='/var/www/html/index.html'

if ! [ $(id -u) = 0 ]; then
   echo "The script need to be run as root." >&2
   exit 1
fi

# Installing Apache
apt update && apt install apache2 -y
if [ $? != 0 ]; then
  echo "Error while installing apache2. Please check connection and apt!"
  exit 1
fi

systemctl enable apache2.service
systemctl restart apache2.service
systemctl is-active apache2.service
if [ $? != 0 ]; then
  echo "Error: apache2 service inactive!"
  exit 1
fi


# Saving previous default version of a file if backup not exists
cp -n /var/www/html/index.html{,.backup}


# Changing index HTML
if [ ! -f "$pathToHTML" ]; then
  echo "Error: $pathToHTML doesn\'t exist!"
  exit 1
fi

cat > $pathToHTML << EOF
<!DOCTYPE html>
<html>
    <head>
        <title>Test server</title>
    </head>
    <body>
        <p>$name</p>
    </body>
</html>
EOF

echo "Done"
