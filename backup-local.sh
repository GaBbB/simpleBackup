#!/bin/bash

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

EMAILBODY="BACKUP COMPLETED: \n\n";

# Function to log messages to the log file
log() {
	echo "$(date +"%Y-%m-%d %H:%M:%S") $1"
	echo "$(date +"%Y-%m-%d %H:%M:%S") $1" >> "$LOG_FILE"
}

# Function to perform the backup
backup() {
	# Get the current day of the week
	current_day_of_week=$(date +"%w")
	log "starting backup"
	
	# Create a backup directory with the current date
	backup_dir="${DESTINATION}/incremental/$(date +"%Y-%m-%d")"

	if [ ! -d $backup_dir ]; then
	   mkdir -p $backup_dir
	fi
	log "Creating incremental backup..."
	rsync -avz --ignore-errors --delete --link-dest="../$(date -d "yesterday" +"%Y-%m-%d")" "$SOURCE" "$backup_dir"
	INCREMENTALSIZEMAIL=$(du -hs $backup_dir)
	# Check if it's the day for a full backup
	if [ "$current_day_of_week" -eq "$FULL_BACKUP_DAY_OF_WEEK" ]; then
		backup_dir="${DESTINATION}/full/$(date +"%Y-%m-%d")"
		if [ ! -d $backup_dir ];then
		   mkdir -p $backup_dir
		fi
		log "Creating full backup... $backup_dir"
		rsync -avz --ignore-errors --delete "$SOURCE" "${backup_dir}"
		FULLSIZEMAIL=$(du -hs $backup_dir)
	else
		FULLSIZEMAIL="Not necessary today"
	fi
	
	log "${EMAILBODY} INCREMENTAL: ${INCREMENTALSIZEMAIL}\n\n FULL: ${FULLSIZEMAIL}\n\n"
	#sending emails
	for recipient in ${EMAILADRESSES[@]}; do
		printf "To:${$recipient}\nSubject: BACKUP REPORT: $(date +"%Y-%m-%d")\n\n${EMAILBODY} INCREMENTAL: ${INCREMENTALSIZEMAIL}\n\n FULL: ${FULLSIZEMAIL}\n\n" | ssmtp $recipient
	done
	log "Backup completed."
}

# Remove old incremental backups
remove_old_incremental_backups() {
	# Find and delete backups older than specified days
	for folder in "${DESTINATION}"/incremental/*; do
		if [ -d $folder ]; then
			dirdate=$(basename $folder)
			let difference=($(date +'%s')-$(date +'%s' -d $dirdate))/86400
			if [ $difference -gt $INCREMENTAL_KEEP_DAYS ]; then
				if [ -d $folder ]; then
					log "$folder must delete, its in $INCREMENTAL_KEEP_DAYS days"
					rm -rf $folder
				fi
			else
				log "$folder must keep, its in $INCREMENTAL_KEEP_DAYS days"
			fi
		else
			log "There is no folder currently in ${DESTINATION}/full/"
		fi
	done
}

# Remove old full backups
remove_old_full_backups() {
	# Find and delete backups older than specified days
	for folder in "${DESTINATION}"/full/*; do
		if [ -d $folder ]; then
			dirdate=$(basename $folder)
			let difference=($(date +'%s')-$(date +'%s' -d $dirdate))/86400
			if [ $difference -gt $FULL_BACKUP_KEEP_COUNT ]; then
				if [ -d $folder ]; then
					log "$folder must delete, its in $FULL_BACKUP_KEEP_COUNT days"
					rm -rf $folder
				fi
			else
				log "$folder must keep, its in $FULL_BACKUP_KEEP_COUNT days"
			fi
		else
			log "There is no folder currently in ${DESTINATION}/full/"
		fi
	done
}

# Main backup function
main() {
	backup
	remove_old_incremental_backups
	remove_old_full_backups
}

# Run the backup
main
