#!/bin/bash
HUGO_VERSION="0.136.2"

curl -sL https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_linux-amd64.deb -o /tmp/hugo.deb && dpkg -i /tmp/hugo.deb