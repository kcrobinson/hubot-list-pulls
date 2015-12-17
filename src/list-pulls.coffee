# Description
#   Lists open pull requests
#
# Configuration:
#   HUBOT_LIST_PULLS_GITHUB_TOKEN
#    - Github authorization token with access to read pull requests of repos,
#    - Created at https://github.com/settings/tokens
#    - (i.e. '87a153bae3d8b9b13c07da682949df95b283176b')
#
# Commands:
#   hubot list pulls - Lists open pull requests in the configured repos
#
# Notes:
#   Dependency on 'moment'
#
# Author:
#   Kyle Parker-Robinson <kcrobinson@gmail.com>

moment = require('moment')

githubToken = process.env.HUBOT_LIST_PULLS_GITHUB_TOKEN
if !githubToken
  console.log 'MISSING ENV variable HUBOT_LIST_PULLS_GITHUB_TOKEN'
  process.exit(1)

module.exports = (robot) ->
  repoList = []
  
  robot.respond /list pulls/, (msg) ->
    if repoList.length == 0
      msg.send 'No repos. Use "add repo" command to add repos.'
    else
      processPull(repo, robot, msg) for repo in repoList
    
  robot.respond /add repo ([\w-_]*\/[\w-_]*)/i, (msg) ->
    repo = msg.match[1]
    path = 'repos/' + repo
    
    if repoList.indexOf(repo) > -1
      msg.send 'Repo already exists: ' + repo
      return
    
    callGithub path, robot, (err, res, body) ->
      isValid = res.statusCode == 200
      if isValid
        repoList.push repo
        msg.send 'Repo added: ' + repo
      else
        msg.send 'Failed to validate repo: ' + repo
        
  robot.respond /(remove|delete) repo ([\w-_]*\/[\w-_]*)/i, (msg) ->
    repo = msg.match[2]
    index = repoList.indexOf(repo)
    if index < 0
      msg.send 'Repo does not exist: ' + repo
      return
    repoList.splice(index, 1)
    msg.send 'Repo removed: ' + repo
    
  robot.respond /list repos/, (msg) ->
    if repoList.length == 0
      msg.send 'No repos. Use "add repo" command to add repos.'
    else
      msg.send 'Repos: ' + repoList.join(', ')
      
processPull = (repo, robot, msg) ->
  path = 'repos/' + repo + '/pulls?state=open'
  callGithub path, robot, (err, res, body) ->
    if err or !body
      err = err or 'No body in response'
      msg.send 'Error receiving pull information from ' + repo  + ' - ' + err
    else
      pulls = JSON.parse(body)
      if pulls.length == 0
        msg.send 'No pull requests for ' + repo
        return
      for pull in pulls
        formatted = formatPull(pull)
        msg.send formatted
  
formatPull = (pull) ->
  txt = '/code <a href="' + pull.url + '">#' + pull.number + '</a> - '
  txt += '"' + pull.title + '" - created by ' + pull.user.login
  
  timeAgo = moment(pull.created_at, moment.ISO_8601).fromNow()
  txt += ' ' + timeAgo
  
  return txt
      
callGithub = (pathAndQuery, robot, responseHandler) ->
  url = 'https://api.github.com/' + pathAndQuery
  robot.http(url)
    .header('Authorization', 'token ' + githubToken)
    .get() responseHandler
  