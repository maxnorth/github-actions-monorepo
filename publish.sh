#! /bin/bash

src_branch=$(git rev-parse --abbrev-ref HEAD)
current_commit_msg=$(git log -1 --pretty=%B)
dest_branches=$(find . -type d -name "@*" | xargs basename | cut -c2- | sort | uniq)

echo "Preparing to publish to branches: $dest_branches"

for dest_branch in $dest_branches; do
    # switch to branch being deployed
    git checkout $dest_branch || git checkout -b $dest_branch 1> .log.verbose

    # clear existing contents and create new content
    git rm -rf ./* 1> .log.verbose
    git checkout $src_branch . 1> .log.verbose

    # remove @folders unrelated to this branch
    find . -type d -name "@*" | grep -vE "/@$dest_branch$" | xargs git rm -rf 1> .log.verbose

    # hoist @folder contents up one level
    for dest_branch_path in $(find . -type d -name "@*"); do
        mv ./$dest_branch_path/* ./$dest_branch_path/../ 1> .log.verbose
    done

    # remove old @folders
    find . -type d -name "@*" | xargs rm -rf 1> .log.verbose

    # commit and push
    git add -A 1> .log.verbose
    git commit -m $current_commit_msg 1> .log.verbose
    git push -uf origin HEAD
done

git checkout $src_branch
