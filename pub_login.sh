# Create credentials.json file.
echo "Copy credentials"
mkdir -p ~/Library/Application\ Support/dart
cat <<EOF > ~/Library/Application\ Support/dart/pub-credentials.json
$INPUT_CREDENTIAL
EOF
mkdir -p ~/.pub-cache
ln -s ~/Library/Application\ Support/dart/pub-credentials.json credentials.json
echo "OK"