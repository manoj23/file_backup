#!/bin/sh

monitor_file()
{
	inotifywait -q -m -e attrib,delete_self,close_write --format %e "$file_path" |
	while read -r events; do
		echo "$events"
		cp -p "$file_path" "$git_repo_path"
		(cd "$git_repo_path" && \
			git add "$file_name" && \
			git commit -m "$file_name: $(date --iso-8601)" && \
			[ "x$is_remote_present" = "xyes" ] && git push)

		if [ "x$events" = "xDELETE_SELF" ]; then
			killall -15 inotifywait
			break
		fi
	done
}

file_backup()
{
	file_path=$1
	git_repo_path=$2
	file_name=$(basename "$file_path")
	is_remote_present="no" # by default: we consider there is no remote

	[ ! -f "$file_path" ] && echo "$file_path file does not exist" && exit 1
	[ ! -d "$git_repo_path" ] && echo "$git_repo_path directory does not exist" && exit 2
	[ ! -d "$git_repo_path/.git" ] && echo "$git_repo_path directory is not a git repository" && exit 3
	! (which inotifywait > /dev/null 2>&1) && echo "inotifywait is not installed" && exit 4

	if (cd "$git_repo_path" && git ls-remote --exit-code origin > /dev/null 2>&1); then
		is_remote_present="yes"
	fi

	while :; do
		while [ ! -f "$file_path" ]; do
			echo "$file_path does not exist, sleeping..."
			sleep 5;
		done

		monitor_file
	done
}
