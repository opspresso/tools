#!/bin/bash

# curl -sL opspresso.github.io/tools/install.sh | bash

REPO="opspresso.github.io/tools"

# update
curl -sL ${REPO}/base.sh | bash
# [ $? == 1 ] && exit 1

# awscli
curl -sL ${REPO}/awscli.sh | bash

# aws-vault
curl -sL ${REPO}/aws-vault.sh | bash

# tfenv
curl -sL ${REPO}/tfenv.sh | bash

# kubectl
curl -sL ${REPO}/kubectl.sh | bash

# helm
curl -sL ${REPO}/helm.sh | bash

# # istioctl
# curl -sL ${REPO}/istioctl.sh | bash

# # nodejs
# curl -sL ${REPO}/nodejs.sh | bash

# # java
# curl -sL ${REPO}/java.sh | bash

# # maven
# curl -sL ${REPO}/maven.sh | bash

# # semver
# curl -sL ${REPO}/semver.sh | bash

# clean
curl -sL ${REPO}/clean.sh | bash
