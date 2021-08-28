#!/bin/bash

git clone https://github.com/$DEST_REPO_OWNER/$DEST_REPO_NAME.git
cd $DEST_REPO_NAME
git remote set-url origin https://.:$GITHUB_TOKEN@github.com/$DEST_REPO_OWNER/$DEST_REPO_NAME
git checkout -b update-dependencies

new_version=$(echo "github.com/$SRC_REPO_OWNER/$SRC_REPO_NAME" $(curl -H "Accept: application/vnd.github.v3+json" \
            https://api.github.com/repos/$SRC_REPO_OWNER/$SRC_REPO_NAME/releases/latest | jq '.tag_name' | xargs))
old_version=$(cat go.mod | grep github.com/$SRC_REPO_OWNER/$SRC_REPO_NAME | xargs)
sed -i -- 's#'"$old_version"'#'"$new_version"'#g' go.mod
go mod vendor
go mod tidy

git add *
git commit -m "Automated vendoring of $new_version release of $SRC_REPO_NAME"
git push  --force --quiet https://$GITHUB_USER:$GITHUB_TOKEN@github.com/$DEST_REPO_OWNER/$DEST_REPO_NAME update-dependencies:update-dependencies
hub pull-request --base main --head update-dependencies -F- <<< "Automated Vendoring of latest release of $SRC_REPO_NAME

This is an automated PR by Teddy Winters to update the vendoring of `$SRC_REPO_NAME` in this project with the latest release.

_Release notes_
`$SRC_REPO_NAME version $new_version has been vendored.`
"