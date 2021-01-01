# Container image that runs your code
FROM mcr.microsoft.com/dotnet/core/sdk:3.1

LABEL "com.github.actions.name"="Auto Release Miletsone"
LABEL "com.github.actios.description"="Drafts a github release"

LABEL version="0.1.0"
LABEL repository="https://github.com/ShaunMendes/docker-action.git"
LABEL maintainer="Shaun Mendes"

#Install jquery
RUN apt-get update -y && apt-get install -y jq

RUN dotnet tool install -g GitReleaseManager.Tool
# Adding to path
RUN EXPORT PATH="$PATH:/roots/.dotnet/tools"

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]
