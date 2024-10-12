this repo is for managing a monorepo of reusable actions and workflows for Github Actions. it is not for working with traditional monorepos in github actions.

get all @ prefixed folders
for each

- git checkout $DEST_BRANCH || git checkout -b $DEST_BRANCH
- git rm -rf \*
- git checkout $SRC_BRANCH .
- git rm -rf \*_/@_/
- git checkout $SRC_BRANCH "*/@$DEST_BRANCH/\*"
- for $(ls \*_/@_/)
  - mv ./$FILE_PATH/* ./$FILE_PATH/../
- rm -rf \*\*/@$DEST_BRANCH/
- git add -A
- git commit -m "publish bla"
