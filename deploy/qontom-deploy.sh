#!/bin/bash

# Qonto deployment script
# Author: Karim EL MANSOURI <karim.elmansouri@gmail.com>

set -eu
set -o pipefail

GIT_DEFAULT_BRANCH='master'

print_usage() {
        cat <<EOF
Usage: $(basename $0) [OPTIONS] <branch>

Options:
    -h  display this help and exit
EOF
}

mesg_start() {
    echo "$(tty -s && tput setaf 4)*$(tty -s && tput sgr0)" $@
}

# Parse command-line arguments
while getopts 'h' flag; do
    case "$flag" in
    h)
        print_usage
        exit 0
        ;;
    *)
        print_usage >&2
        exit 1
        ;;
    esac
done

shift $(($OPTIND-1))

if [ $# -ne 1 ]; then
    print_usage >&2
    exit 1
fi

git_branch=$1

# Cloning the project
mesg_start 'Cloning the project...'

git clone https://github.com/andronux/qontoms.git

branch_name="$(git symbolic-ref HEAD 2>/dev/null)" || branch_name="(unnamed branch)"     # detached HEAD
branch_name=${branch_name##refs/heads/}

get_branch() {
      branch_exist=`git branch -r --no-color | grep -E $git_branch | sed 's/origin\///g' | awk '{print $1}'` \
    ||  branch_exist=$GIT_DEFAULT_BRANCH
      echo $branch_exist
}

mesg_start 'Building ms1...'
cd qontoms/ms1
branch_to_depoy=$(get_branch $git_branch)
git checkout $branch_to_depoy
docker build -t registry.ganditest.us:5000/ms1:$branch_to_depoy .
docker push registry.ganditest.us:5000/ms1:$branch_to_depoy
mesg_start 'Configuring ms1 vhost...'
/usr/bin/python $HOME/deployment/nginx.py ms1 $branch_to_depoy
service nginx reload
mesg_start 'Deploying update ms1...'
docker service update --image registry.ganditest.us:5000/ms1:$branch_to_depoy --env-add MS_URL=http://ms2-${branch_to_depoy}.ganditest.us ms1
cd ../ms2/
mesg_start 'Building ms2...'
branch_to_depoy=$(get_branch $git_branch)
git checkout $branch_to_depoy
docker build -t registry.ganditest.us:5000/ms2:$branch_to_depoy .
docker push registry.ganditest.us:5000/ms2:$branch_to_depoy
mesg_start 'Configuring ms2 vhost...'
/usr/bin/python $HOME/deployment/nginx.py ms2 $branch_to_depoy
service nginx reload
mesg_start 'Deploying update ms2...'
docker service update --image registry.ganditest.us:5000/ms2:$branch_to_depoy --env-add MS_URL=http://ms1-${branch_to_depoy}.ganditest.us ms2
cd $HOME/deployment
rm -rf ~/qontoms

# vim: ts=4 sw=4 et ft=bash
