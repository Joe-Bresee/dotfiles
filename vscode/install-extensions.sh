#!/usr/bin/env bash
cat "$(dirname "$0")/extensions.txt" | xargs -L1 code --install-extension
