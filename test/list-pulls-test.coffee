Helper = require('hubot-test-helper')
expect = require('chai').expect
nock = require('nock')

helper = new Helper('../src/list-pulls.coffee')

describe 'list-pulls', ->
  room = null

  beforeEach ->
    process.env.HUBOT_LIST_PULLS_GITHUB_ORGANIZATION = 'kcrobinson'
    process.env.HUBOT_LIST_PULL_GITHUB_REPOS = 'hubot-list-pulls'
    process.env.HUBOT_LIST_PULLS_GITHUB_TOKEN = 'mockToken'
    
    room = helper.createRoom()
    do nock.disableNetConnect
    nock('https://api.github.com')
      .get('/repos/kcrobinson/hubot-list-pulls/pulls?state=open')
      .reply 200, [
          {
            'url': 'http://github.com/kcrobinson/hubot-list-pulls/pulls/240',
            'number': 240,
            'title': 'This is a pull request',
            'user': {
              'login': 'kcrobinson'
            },
            'created_at': '2014-12-12T00:00:00Z'
          }
        ]

  afterEach ->
    room.destroy()
    nock.cleanAll()

  context 'user says "list pulls"', ->
    beforeEach (done) ->
      room.user.say 'alice', 'hubot list pulls'
      setTimeout done, 100

    it 'should list pull requests', ->
      expect(room.messages).to.eql [
        ['alice', 'hubot list pulls'],
        ['hubot', '/code <a href="http://github.com/kcrobinson/hubot-list-pulls/pulls/240">#240</a> - "This is a pull request" - created by kcrobinson a year ago']
      ]