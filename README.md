# simpleBackup
Simple backup script using rsync, ssmtp

##  Set source directory to be backed up
```
SOURCE="/path/to/source"
```

##  Set destination directory for backups
```
DESTINATION="/path/to/destination"
```

##  Set log file name and path
```
LOG_FILE="/path/to/logfile"
```

##  Set number of days to keep incremental backups
```
INCREMENTAL_KEEP_DAYS=30
```

##  Set day of the week for full backups (0 = Sunday, 1 = Monday, etc.)
```
FULL_BACKUP_DAY_OF_WEEK=6
```

##  Set number of full backups to keep (months * weeks per month)
```
FULL_BACKUP_KEEP_COUNT=60
```

## add email addresses to get report
```
EMAILADRESSES=("example1@gmail.com" "example2@gmail.com")
```

## Im using gmail & ssmtp to send reports

### Google account needs to be enable 2FA and need a custom Appliaction password

### Install ssmtp
```
apt install ssmtp
```
### Edit ssmtp config
```
nano /etc/ssmtp/ssmtp.conf
```
###Add the following lines:
```
FromLineOverride=YES
root=example@gmail.com
mailhub=smtp.gmail.com:587
hostname=myhostname
AuthUser=example@gmail.com
AuthPass=googlegenerated16charpassword
FromLineOverride=YES
UseSTARTTLS=YES
```

## License

[MIT](https://choosealicense.com/licenses/mit/)
then run the backupscript
```
./backup-local.sh
```
