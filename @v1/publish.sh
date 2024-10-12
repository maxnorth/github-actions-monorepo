#! /bin/bash

shopt -s globstar

src_branch=$(git rev-parse --abbrev-ref HEAD)
current_commit_msg=$(git log -1 --pretty=%B)
dest_branches=$(ls -d ./**/@*/ | xargs basename | cut -c2- | sort | uniq)

echo "Preparing to publish to branches: $(echo $dest_branches | tr '\n' ',')"

for dest_branch in $dest_branches; do
    # switch to branch being deployed
    git checkout $dest_branch || git checkout -b $dest_branch

    # clear existing contents and create new content
    git rm -rf ./*
    git checkout $src_branch .
    git rm -rf ./**/@*/
    git checkout $src_branch "*/@$dest_branch/*"

    # hoist @folder contents up one level
    for dest_branch_path in ls ./**/@*/; do
        mv ./$dest_branch_path/* ./$dest_branch_path/../
    done

    # remove old @folders
    rm -rf \*\*/@$dest_branch/

    # commit and push
    git add -A
    git commit -m $current_commit_msg
    git push -u origin HEAD
done

git checkout $src_branch
