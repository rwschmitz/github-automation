# Define branch names for develop and main
DEVELOP_BRANCH_NAME="develop"
MAIN_BRANCH_NAME="main"

# Checkout develop, fetch from remote, and pull latest changes
git checkout $DEVELOP_BRANCH_NAME && git fetch && git pull

# Get version number from user
read -p "Please enter the release version number (MAJOR.MINOR.PATCH): " VERSION_NUMBER

# Define branch name for release using the user's input
RELEASE_BRANCH_NAME="release/automation-v$VERSION_NUMBER"

# Create a new release branch
git checkout -b $RELEASE_BRANCH_NAME

# Push the release branch to the remote repo
git push --set-upstream origin $RELEASE_BRANCH_NAME

# Create a new tag based using the user's input
git tag v$VERSION_NUMBER

# Push the tag to the remote repo
git push origin tag v$VERSION_NUMBER

# Define release title
RELEASE_TITLE="Release v$VERSION_NUMBER"

# Create a new release, automatically generate the notes, set the target to the release branch, and set a title
gh release create v$VERSION_NUMBER --generate-notes --target $RELEASE_BRANCH_NAME --title $RELEASE_TITLE

# Create a new PR FROM the release branch TO the main branch and populate the body with the release notes
gh pr create --base $MAIN_BRANCH_NAME --head $RELEASE_BRANCH_NAME --body "$(gh release view v$VERSION_NUMBER --json body --jq '.body')" --label release --title $RELEASE_TITLE