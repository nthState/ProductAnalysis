echo "Setting up workspace for a new user"

# Update Xcode Command line Tools
xcode-select --install

#https://commitizen-tools.github.io/commitizen/
brew install commitizen

#https://pre-commit.com/
brew install pre-commit

# This will add the .pre-commit-config.yaml as a hook
pre-commit install --hook-type commit-msg --hook-type pre-push
pre-commit autoupdate
