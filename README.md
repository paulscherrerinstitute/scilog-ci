# scilog-ci
CI configuration to deploy SciLog server


## Deploy.sh

The [deploy.sh](deploy.sh) script should ease the deployment in the development and qa environment, by making use of CI triggers.

The deployment to development is triggered when a pull request to main is opened or when there is a workflow dispatch event. The script makes use of the github APIs to trigger a workflow dispatch event and start a deployment on development. On qa the trigger is a push to main and, so, the script does a push on main when needing to deploy on qa.

### How to use

1. clone the repo and its submodules: 
```
git clone git@github.com:paulscherrerinstitute/scilog-ci.git
git submodule update --recursive --init
```

2. Print out the script options: 
```
./deploy.sh -h
>Input options:
>   -e           deployment environment name. Default to development
>   -w           CI workflow file name. To be specified when environment=development
>   -s           submodule name. Default to scilog
>   -c           CI repo local path. Default to .
>   -b           CI Branch name. Default to the current branch name of the submodule
>   -o           CI origin alias. Default to origin
>   -m           CI Main branch name. Default to main
>   -t           Github token
```

#### Deploy on dev

To deploy on development the workflow to run and the github token must be set, respectively with the -w and -t flags or exporting the env variables. The other options are optional.

```
./deploy.sh -t <YOUR_GITHUB_TOKEN> -w be.yml
```

This will trigger the deployment of the scilog be using the commit from your submodule (NOTE that this commit must be in [scilog](https://github.com/paulscherrerinstitute/scilog)).

To obtain a suitable token, please follow the [github wiki](https://docs.github.com/en/rest/actions/workflows#create-a-workflow-dispatch-event).

#### Deploy on qa

To deploy on qa the environment option must be set, with the -e flag, or exporting the env variable.

```
./deploy.sh -e qa
```

As before, the version which is deployed on qa is the one of the commit from your submodule (NOTE that this commit must be in [scilog](https://github.com/paulscherrerinstitute/scilog)).

### :warning: IMPORTANT

The deploy.sh script belongs to the scilog-ci repo, so it needs to be run from this folder. This means that, when developing on scilog, one still needs to run the following steps: 

1. from scilog-ci `cd` into scilog:
```
cd scilog
```
2. commit and push the change to the scilog repo
3. cd back to scilog-ci:
```
cd ..
```
4. run deploy.sh
```
./deploy.sh
```

This can be eased by creating an alias that sets the -c flag, e.g.: 

```
alias deploy_scilog=". <YOUR_PATH_TO_SCILOGCI>/deploy.sh -c <YOUR_PATH_TO_SCILOGCI>"
```

or exporting the cipath env variable and expanding the PATH:

```
export cipath=<YOUR_PATH_TO_SCILOGCI>
PATH=$PATH:<YOUR_PATH_TO_SCILOGCI>
```

In this way, it is possible to run the deploy.sh script directly from the scilog folder, thus not needing (3).
