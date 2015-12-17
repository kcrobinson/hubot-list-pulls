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
HUBOT_LIST_PULLS_GITHUB_TOKEN
 - Github authorization token with access to read pull requests of repos,
 - Created at https://github.com/settings/tokens
 - (i.e. '87a153bae3d8b9b13c07da682949df95b283176b')
```

## Sample Interaction

```
user1>> hubot add repo kcrobinson/hubot-list-pulls
hubot>> Repo added: kcrobinson/hubot-list-pulls
user1>> hubot list pulls
hubot>> /code <a href="http://github.com/kcrobinson/hubot-list-pulls/pulls/240">#240</a> - "This is a pull request" - created by kcrobinson a year ago
```
