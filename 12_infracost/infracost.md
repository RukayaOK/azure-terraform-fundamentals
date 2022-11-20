

brew install infracost

infracost auth login
- will be promted to set up an account

infracost breakdown --path . 

or 
infracost breakdown --config-file infracost.yml

or 
infracost breakdown --config-file infracost.yml
              --format json --out-file infracost-base.json


https://github.com/infracost/actions

pull-requests:
    '**':
      - step:
          name: Run Infracost
          image: infracost/infracost:ci-latest
          script:
            - git checkout $BITBUCKET_PR_DESTINATION_BRANCH
            - >-
              infracost breakdown --config-file infracost.yml
              --format json --out-file infracost-base.json
            - git checkout $BITBUCKET_BRANCH
            - >-
              infracost diff --config-file infracost.yml
              --compare-to infracost-base.json
              --format json --out-file infracost.json
            - infracost output --path infracost.json --format diff
            - >-
              infracost comment bitbucket --path infracost.json
              --repo $BITBUCKET_WORKSPACE/$BITBUCKET_REPO_SLUG
              --pull-request $BITBUCKET_PR_ID
              --bitbucket-token $INFRACOST_BITBUCKET_USER:$INFRACOST_BITBUCKET_TOKEN
              --behavior update