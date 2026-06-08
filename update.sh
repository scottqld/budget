#!/bin/sh
# Run on NAS to pull latest budget app from GitHub
# Usage: sh /Volume2/appdata/budget/update.sh

DEST="/Volume2/appdata/budget/index.html"
REPO="scottqld/budget"

echo "Fetching latest commit..."
SHA=$(python3 -c "
import urllib.request, json
r = urllib.request.urlopen('https://api.github.com/repos/$REPO/commits/main')
print(json.loads(r.read())['sha'])
")

echo "Downloading commit $SHA..."
python3 -c "
import urllib.request
url = 'https://raw.githubusercontent.com/$REPO/$SHA/index.html'
urllib.request.urlretrieve(url, '$DEST')
"

VERSION=$(grep -o 'v[0-9]*\.[0-9]*' "$DEST" | head -1)
echo "Done — $VERSION installed"
