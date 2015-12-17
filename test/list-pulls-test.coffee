Helper = require('hubot-test-helper')
expect = require('chai').expect
nock = require('nock')

helper = new Helper('../src/list-pulls.coffee')

describe 'list-pulls', ->
  room = null

  beforeEach (done) ->
    process.env.HUBOT_LIST_PULLS_GITHUB_TOKEN = 'mockToken'
    
    room = helper.createRoom()
    do nock.disableNetConnect
    nock('https://api.github.com')
      .get('/repos/kcrobinson/hubot-list-pulls')
      .reply(200, { })
    room.user.say 'alice', 'hubot add repo kcrobinson/hubot-list-pulls'
    setTimeout done, 100
      
  afterEach ->
    room.destroy()
    nock.cleanAll()

  context 'user says "list pulls"', ->
    beforeEach (done) ->
      nock('https://api.github.com')
        .get('/repos/kcrobinson/hubot-list-pulls/pulls?state=open')
        .reply(200, [
            {
              'url': 'http://github.com/kcrobinson/hubot-list-pulls/pulls/240',
              'number': 240,
              'title': 'This is a pull request',
              'user': {
                'login': 'kcrobinson'
              },
              'created_at': '2014-12-12T00:00:00Z'
            }
          ])
      room.user.say 'alice', 'hubot list pulls'
      setTimeout done, 100

    it 'should list pull requests', ->
      expect(room.messages).to.eql [
        ['alice', 'hubot add repo kcrobinson/hubot-list-pulls'],
        ['hubot', 'Repo added: kcrobinson/hubot-list-pulls'],
        ['alice', 'hubot list pulls'],
        ['hubot', '/code <a href="http://github.com/kcrobinson/hubot-list-pulls/pulls/240">#240</a> - "This is a pull request" - created by kcrobinson a year ago']
      ]
      
  context 'user says "remove repo" on existing repo', ->
    beforeEach (done) ->
      room.user.say 'alice', 'hubot remove repo kcrobinson/hubot-list-pulls'
      setTimeout done, 100
      
    it 'should remove repo', ->
      expect(room.messages).to.eql [
        ['alice', 'hubot add repo kcrobinson/hubot-list-pulls'],
        ['hubot', 'Repo added: kcrobinson/hubot-list-pulls'],
        ['alice', 'hubot remove repo kcrobinson/hubot-list-pulls'],
        ['hubot', 'Repo removed: kcrobinson/hubot-list-pulls']
      ]
  
  context 'user says "remove repo" on non-existant repo', ->
    beforeEach (done) ->
      room.user.say 'alice', 'hubot remove repo kcrobinson/what-repo-is-this'
      setTimeout done, 100
      
    it 'should display failed message', ->
      expect(room.messages).to.eql [
        ['alice', 'hubot add repo kcrobinson/hubot-list-pulls'],
        ['hubot', 'Repo added: kcrobinson/hubot-list-pulls'],
        ['alice', 'hubot remove repo kcrobinson/what-repo-is-this'],
        ['hubot', 'Repo does not exist: kcrobinson/what-repo-is-this']
      ]
      
  context 'user says "list repos"', ->
    beforeEach (done) ->
      room.user.say 'alice', 'hubot list repos'
      setTimeout done, 100
    
    it 'should list repos', ->
      expect(room.messages).to.eql [
        ['alice', 'hubot add repo kcrobinson/hubot-list-pulls'],
        ['hubot', 'Repo added: kcrobinson/hubot-list-pulls'],
        ['alice', 'hubot list repos'],
        ['hubot', 'Repos: kcrobinson/hubot-list-pulls']
      ]