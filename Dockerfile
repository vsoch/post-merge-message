FROM alpine:latest

LABEL Maintainer="@vsoch"
LABEL "com.github.actions.name"="Post Merge Message"
LABEL "com.github.actions.description"="Post a Message after Merge of a Branch"
LABEL "com.github.actions.icon"="activity"
LABEL "com.github.actions.color"="purple"

RUN apk add --no-cache \
    bash \
    python3 \
    ca-certificates \
    curl \
    jq

ADD post-message.sh /usr/bin/post-message.sh
ADD post_message.py /post_message.py

ENTRYPOINT ["post-message.sh"]
