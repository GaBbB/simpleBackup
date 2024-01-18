# simpleBackup
Simple backup script using rsync, ssmtp

# Set source directory to be backed up
SOURCE="/path/to/source"

# Set destination directory for backups
DESTINATION="/path/to/destination"

# Set log file name and path
LOG_FILE="/path/to/logfile"

# Set number of days to keep incremental backups
INCREMENTAL_KEEP_DAYS=30

# Set day of the week for full backups (0 = Sunday, 1 = Monday, etc.)
FULL_BACKUP_DAY_OF_WEEK=6

# Set number of full backups to keep (months * weeks per month)
FULL_BACKUP_KEEP_COUNT=60

EMAILADRESSES=("example1@gmail.com" "example2@gmail.com")
