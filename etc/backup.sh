#!/bin/bash
## https://oneuptime.com/blog/post/2026-03-18-backup-podman-containers/view
## Note: Only on running containers, because `podman ps`

BACKUP_DIR="/mnt/data/backup/podz_man/$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_DIR"

for container in $(podman ps -a --format "{{.Names}}"); do
  echo "Backing up container: $container"

  # Stop container
  systemctl --user stop "$container.service"

  # Export filesystem
  podman export "$container" | gzip > "$BACKUP_DIR/${container}-filesystem.tar.gz"

  # Save metadata
  podman inspect "$container" > "$BACKUP_DIR/${container}-metadata.json"

  # Save the image reference
  podman inspect "$container" --format '{{.ImageName}}' > "$BACKUP_DIR/${container}-image.txt"

  # Restart container
  systemctl --user start "$container.service"

  echo "Done: $BACKUP_DIR/${container}-*"
done

echo "Backup complete: $BACKUP_DIR"
ls -lh "$BACKUP_DIR"


## Extra things for later

### Retention strategy
## Remove timestamped backup directories older than 30 days
#find /backups/podman -mindepth 1 -maxdepth 1 -type d -mtime +30 -exec rm -rf {} +
#
## Keep only the last 10 backups
#ls -dt /backups/podman/*/ | tail -n +11 | xargs rm -rf
##

### Off-site storage
## Sync backups to a remote server
#rsync -avz /backups/podman/ backup-server:/backups/podman/
#
## Or upload to S3-compatible storage
#aws s3 sync /backups/podman/ s3://my-backups/podman/
##

### Verifying backup `tegrity
##!/bin/bash
#
#BACKUP_FILE="$1"
#
## Test that the compressed archive is valid
#if gzip -t "$BACKUP_FILE" 2>/dev/null; then
#    echo "Archive integrity: OK"
#else
#    echo "Archive integrity: FAILED"
#    exit 1
#fi
#
## Test import
#podman import "$BACKUP_FILE" backup-test:latest
#if [ $? -eq 0 ]; then
#    echo "Import test: OK"
#    podman rmi backup-test:latest
#else
#    echo "Import test: FAILED"
#    exit 1
##fi
##