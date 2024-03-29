# simpleBackup
Simple backup script using rsync, ssmtp

##  Set source directory to be backed up
```bash
SOURCE="/path/to/source"
```

##  Set destination directory for backups
```bash
DESTINATION="/path/to/destination"
```

##  Set log file name and path
```bash
LOG_FILE="/path/to/logfile"
```

##  Set number of days to keep incremental backups
```bash
INCREMENTAL_KEEP_DAYS=30
```

##  Set day of the week for full backups (0 = Sunday, 1 = Monday, etc.)
```bash
FULL_BACKUP_DAY_OF_WEEK=6
```

##  Set number of full backups to keep (months * weeks per month)
```bash
FULL_BACKUP_KEEP_COUNT=60
```

## add email addresses to get report
```bash
EMAILADRESSES=("example1@gmail.com" "example2@gmail.com")
```

## Im using gmail & ssmtp to send reports

### Google account needs to be enable 2FA and needs a custom Application password (https://support.google.com/accounts/answer/185833?hl=en)

### Install ssmtp
```bash
apt install ssmtp
```
### Edit ssmtp config
```bash
nano /etc/ssmtp/ssmtp.conf
```
###Add the following lines:
```bash
FromLineOverride=YES
root=example@gmail.com
mailhub=smtp.gmail.com:587
hostname=myhostname
AuthUser=example@gmail.com
AuthPass=googlegenerated16charpassword
FromLineOverride=YES
UseSTARTTLS=YES
```

then run the backupscript
```bash
./backup-local.sh
```

## License

[MIT](https://choosealicense.com/licenses/mit/)

