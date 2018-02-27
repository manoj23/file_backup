#!/bin/sh

file_backup()
{
        local file_path=$1
        local git_repo_path=$2
        local file_name=$(basename $file_path)
	local file_commit_message="$file_name: $(date --iso-8601)"

        [ ! -f "$file_path" ] && echo "$file_path file does not exist" && exit 1
        [ ! -d "$git_repo_path" ] && echo "$git_repo_path directory does not exist" && exit 2
        [ ! -d "$git_repo_path/.git" ] && echo "$git_repo_path directory is not a git repository" && exit 3

        cp -p $file_path $git_repo_path
	cd $git_repo_path
	git add $file_name && git commit -m "$file_commit_message"
	cd -
}
