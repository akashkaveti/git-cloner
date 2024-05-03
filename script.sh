#!/bin/sh
if [ -z "$REPO_SSH_LINK" ]; then 
	echo -e "\033[1;91mERROR:\033[0m REPO_SSH_LINK env variable is required"
	exit 1
fi

if [ -z "$REPO_BRANCH" ]; then 
	export REPO_BRANCH=master
fi

# if [ -z "$REPO_KEY" ]; then 
# 	export REPO_KEY=id_rsa
# fi

echo "repository : $REPO_SSH_LINK"
echo "branch     : $REPO_BRANCH"
echo "repo : REPO_SSH_LINK"
echo "sparce_checkout_directory : $SPARSE_CHECKOUT_DIR"

# check if credentials files exist
if [[ -f "/key/$REPO_KEY" ]] ; then 
	echo "key file   : $REPO_KEY"
	cp /key/$REPO_KEY /home/git/.ssh/id_rsa
	chmod 600 /home/git/.ssh/id_rsa
	ssh-keyscan -H bitbucket.org >> /home/git/.ssh/known_hosts
fi

clone_repository() {
    if [ ! -z "$REPO_HTTPS_LINK" ] && [ ! -z "$REPO_PASS" ]; then 
        # clone with repository username & password
        echo "credentials: username and password"
        git clone -n --depth=1 -b "$REPO_BRANCH" "https://$REPO_USER:$REPO_PASS@$REPO_SSH_LINK" /repository
    else
        if [ ! -f "/home/git/.ssh/id_rsa" ]; then
            echo -e "\033[1;93mWARNING:\033[0m REPO_USER, REPO_PASS env variables or SSH deployment key missing"
        else
            # clone public repository or using ssh deployment key
            echo "credentials: RSA key"
            git clone --filter=blob:none --no-checkout --depth=1 -b "$REPO_BRANCH" "$REPO_SSH_LINK" /repository
        fi
    fi
	cd /repository
	if [ ! -z "$SPARSE_CHECKOUT_DIR" ]; then
        git sparse-checkout init
        git sparse-checkout set "$SPARSE_CHECKOUT_DIR"
		git checkout
	else
	  git checkout "$REPO_BRANCH"
	fi
}

clone_repository