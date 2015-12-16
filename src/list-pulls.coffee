# Description
#   Lists open pull requests
#
# Configuration:
#   HUBOT_LIST_PULLS_GITHUB_ORGANIZATION - Github organization for the repos (i.e. 'kcrobinson' for https://github.com/kcrobinson/hubot-list-pulls)
#   HUBOT_LIST_PULL_GITHUB_REPOS - Comma separated list of repo names in the organization to look for pull requests (i.e. 'hubot-list-pulls,some-other-repo)
#   HUBOT_LIST_PULLS_GITHUB_TOKEN - Github authorization token with access to read pull requests of repos, created at https://github.com/settings/tokens (i.e. '87a153bae3d8b9b13c07da682949df95b283176b')
#
# Commands:
#   hubot list pulls - Lists open pull requests in the configured repos
#
# Notes:
#   <optional notes required for the script>
#
# Author:
#   Kyle Parker-Robinson <kcrobinson@gmail.com>

moment = require('moment')

organization = process.env.HUBOT_LIST_PULLS_GITHUB_ORGANIZATION
if !organization
  console.log 'Missing ENV variable HUBOT_LIST_PULLS_GITHUB_ORGANIZATION'
  process.exit(1)
  
repos = process.env.HUBOT_LIST_PULL_GITHUB_REPOS
if !repos
  console.log 'MISSING ENV variable HUBOT_LIST_PULL_GITHUB_REPOS'
  process.exit(1)
repoList = repos.split ','

githubToken = process.env.HUBOT_LIST_PULLS_GITHUB_TOKEN 
if !githubToken
  console.log 'MISSING ENV variable HUBOT_LIST_PULLS_GITHUB_TOKEN'
  process.exit(1)

module.exports = (robot) ->
  robot.respond /list pulls/, (response) ->
    processPull(repo, robot, response) for repo in repoList

processPull = (repo, robot, response) ->
  url = 'https://api.github.com/repos/' + organization + '/' + repo + '/pulls?state=open'
  robot.http(url)
    .header('Authorization', 'token ' + githubToken)
    .get() (err, res, body) ->
      if err or !body
        err = err or 'No body in response'
        response.send 'Error receiving pull information from ' + url  + ' - ' + err
      else
        pulls = JSON.parse(body)
        for pull in pulls
          formatted = formatPull(pull)
          response.send formatted
  
formatPull = (pull) ->
  txt = '/code <a href="' + pull.url + '">#' + pull.number + '</a> - '
  txt += '"' + pull.title + '" - created by ' + pull.user.login
  
  timeAgo = moment(pull.created_at, moment.ISO_8601).fromNow()
  txt += ' ' + timeAgo
  
  return txt