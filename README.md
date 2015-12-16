# hubot-list-pulls

Lists open pull requests

See [`src/list-pulls.coffee`](src/list-pulls.coffee) for full documentation.

## Installation

In hubot project repo, run:

`npm install hubot-list-pulls --save`

Then add **hubot-list-pulls** to your `external-scripts.json`:

```json
[
  "hubot-list-pulls"
]
```

Set the following environment variables:

```
HUBOT_LIST_PULLS_GITHUB_ORGANIZATION
# Github organization for the repos (i.e. 'gratafy' for https://github.com/gratafy repos)

HUBOT_LIST_PULL_GITHUB_REPOS
# Comma separated list of repo names in the organization to look for pull requests (i.e. 'hubot-list-pulls,some-other-repo)

HUBOT_LIST_PULLS_GITHUB_TOKEN
# Github authorization token with access to read pull requests of repos, created at https://github.com/settings/tokens (i.e. '87a153bae3d8b9b13c07da682949df95b283176b')
```

## Sample Interaction

```
user1>> hubot list pulls
hubot>> /code <a href="http://github.com/kcrobinson/hubot-list-pulls/pulls/240">#240</a> - "This is a pull request" - created by kcrobinson a year ago
```
