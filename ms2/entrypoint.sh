#!/bin/bash
set -Eeuo pipefail

bundle exec ruby web.rb -s Puma -p $PORT -o 0.0.0.0
