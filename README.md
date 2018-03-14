file_backup
===========

`file_backup` script copies the given file when it changes in a git repository,
commits and pushes (if the remote is on).
The script expects as arguments the file to back up and the git (bare)
repository.

This script depends on: sh, date, git, and inotifywait.

## Example

```
#!/bin/sh

. /root/file_backup/file_backup.sh

file_backup "/var/www/georges.savound.com/webdav/pwd-home.kdbx" "/opt/webdav-backup"
```
