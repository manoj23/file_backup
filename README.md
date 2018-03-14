file_backup
===========

`file_backup` script is used to copy a file into a git repository, commit and
push (if the remote exist).
The first argument to give to the script is the file to back up and the second
argument is the git (bare) repository.

This script depends on: sh, date, git, and inotifywait.

## Example

```
#!/bin/sh

. /root/file_backup/file_backup.sh

file_backup "/var/www/georges.savound.com/webdav/pwd-home.kdbx" "/opt/webdav-backup"
```
