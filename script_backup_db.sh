#! /bin/bash
TIMESTAMP=$(date +"%F")
BACKUP_DIR="/backup/$TIMESTAMP"
MYSQL_USER="admin"
MYSQL=/usr/bin/mysql
MYSQL_PASSWORD="`cat /etc/psa/.psa.shadow` psa"
MYSQLDUMP=/usr/bin/mysqldump
mkdir -p "$BACKUP_DIR/mysql"
databases=`$MYSQL -u$MYSQL_USER -p$MYSQL_PASSWORD -e "SHOW DATABASES;" | grep -Ev "(Database|information_schema|performance_schema)"`
for db in $databases; do
  echo "-- START DB BACKUP: $db --"
  $MYSQLDUMP --force --opt -u$MYSQL_USER -p$MYSQL_PASSWORD --databases $db | gzip > "$BACKUP_DIR/mysql/$db.gz"
  echo "-- END DB BACKUP --"
done