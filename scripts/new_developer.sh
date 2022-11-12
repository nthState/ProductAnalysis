echo "Setting up workspace for a new developer"

# Update Xcode Command line Tools
xcode-select --install

#https://commitizen-tools.github.io/commitizen/
brew install commitizen

# Install swift lint
brew install swiftlint

#https://pre-commit.com/
brew install pre-commit

# This will add the .pre-commit-config.yaml as a hook
pre-commit install --hook-type commit-msg --hook-type pre-push
pre-commit autoupdate
