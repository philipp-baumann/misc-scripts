#!/bin/bash
REPO_TAG="quarto-dev/quarto-cli"

gh_get_quarto_prerelease () {
    # from https://stackoverflow.com/questions/67688662/how-can-i-get-the-latest-pre-release-release-for-my-github-repo-bash
    jq -r 'map(select(.prerelease)) | first | .tag_name' \
      <<< $(curl --silent https://api.github.com/repos/${REPO_TAG}/releases)
}

QUARTO_VERSION=$(gh_get_quarto_prerelease)
QUARTO_VERSION_num="${QUARTO_VERSION//v}"

echo $QUARTO_VERSION_num

# echo $QUARTO_VERSION

# according to the docs:
# https://docs.rstudio.com/resources/install-quarto/

sudo mkdir -p /opt/quarto/${QUARTO_VERSION_num}
sudo curl -o quarto.tar.gz -L \
    "https://github.com/quarto-dev/quarto-cli/releases/download/v${QUARTO_VERSION_num}/quarto-${QUARTO_VERSION_num}-linux-rhel7-amd64.tar.gz"
sudo tar -zxvf quarto.tar.gz \
    -C "/opt/quarto/${QUARTO_VERSION_num}" \
    --strip-components=1
# force link, so any currently possibly symliked versions are removed
sudo ln -sf /opt/quarto/${QUARTO_VERSION_num}/bin/quarto /usr/local/bin/quarto
sudo rm quarto.tar.gz
if [ $? -eq 0 ]
then
    echo "Successfully installed quarto pre-release CLI ${QUARTO_VERSION}"
    echo "Linked into '/usr/local/bin/quarto'"
    /opt/quarto/"${QUARTO_VERSION_num}"/bin/quarto check
fi