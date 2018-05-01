#!/bin/sh

file_backup()
{
	file_path=$1
	git_repo_path=$2
	file_name=$(basename $file_path)
	file_commit_message="$file_name: $(date --iso-8601)"
	is_remote_present="no" # by default: we consider there is no remote

	[ ! -f "$file_path" ] && echo "$file_path file does not exist" && exit 1
	[ ! -d "$git_repo_path" ] && echo "$git_repo_path directory does not exist" && exit 2
	[ ! -d "$git_repo_path/.git" ] && echo "$git_repo_path directory is not a git repository" && exit 3
	[ ! which inotifywait > /dev/null 2>&1 ] && echo "inotifywait is not installed" && exit 4

	if (cd $git_repo_path && git ls-remote --exit-code origin > /dev/null 2>&1); then
		is_remote_present="yes"
	fi

	inotifywait -q -m -e close_write --format %e $file_path |
	while read events; do
		cp -p $file_path $git_repo_path
		(cd $git_repo_path && \
			git add $file_name && \
			git commit -m "$file_commit_message" && \
			[ "x$is_remote_present" == "xyes" ] && git push)
	done
}
