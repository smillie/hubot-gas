# Description
#   Hubot client for the GeekSoc Account System API
#
#
# Configuration:
#   HUBOT_GAS_API_URL
#   HUBOT_GAS_API_USER
#   HUBOT_GAS_API_PASS
#
# Commands:
#   hubot userinfo - return details about a user
#   hubot groupinfo - return details about a group
#
#
# Author:
#   smillie


base_url= process.env.HUBOT_GAS_API_URL
unless base_url?
  console.log "Missing HUBOT_GAS_API_URL in environment: please set and try again"
  process.exit(1)
api_user= process.env.HUBOT_GAS_API_USER
unless api_user?
  console.log "Missing HUBOT_GAS_API_USER in environment: please set and try again"
  process.exit(1)
api_password= process.env.HUBOT_GAS_API_PASS
unless api_password?
  console.log "Missing HUBOT_GAS_API_PASS in environment: please set and try again"
  process.exit(1)

api_url = "http://#{api_user}:#{api_password}@#{base_url}"

module.exports = (robot) ->
  
  robot.hear /userinfo (.*)/i, (msg) ->
    user = msg.match[1]
    robot.http("#{api_url}/users/#{user}")
        .header('Accept', 'application/json')
        .get() (err, res, body) ->
          if res.statusCode is 404
            msg.send "No such user"
            return
          else if res.statusCode isnt 200
            msg.send "Request didn't come back HTTP 200 :("
            return
          else
            data = JSON.parse(body)
            msg.send "User: #{user}, Name: #{data.displayname}, Email: #{data.email}, Student Number: #{data.studentnumber}, Status: #{data.status}"
            msg.send "Groups: #{data.groups}"
            
            
  robot.hear /groupinfo (.*)/i, (msg) ->
    group = msg.match[1]
    robot.http("#{api_url}/groups/#{group}")
        .header('Accept', 'application/json')
        .get() (err, res, body) ->
          if res.statusCode is 404
            msg.send "No such user"
            return
          else if res.statusCode isnt 200
            msg.send "Request didn't come back HTTP 200 :("
            return
          else
            data = JSON.parse(body)
            msg.send "Group: #{group}, Members: #{data.members}"
            