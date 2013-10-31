'use strict'

# This regex is for parse gitconfig
#======================================================================================================
regex = 
  section: /^\s*\[\s*([^\]]*)\s*\]\s*$/,
  param: /^\s*([\w\.\-\_]+)\s*=\s*(.*?)\s*$/,
  comment: /^\s*;.*$/


parse = (data) ->
  value = {}
  lines = data.split(/\r\n|\r|\n/)
  section = null
  for line in lines then do (line) ->
    if regex.comment.test line
      return
    else if regex.param.test line
      match = line.match regex.param
      if section
        value[section][match[1]] = match[2]
      else
        value[match[1]] = match[2]
    else if regex.section.test line
      match = line.match regex.section
      value[match[1]] = {}
      section = match[1]
    else if line.length == 0 && section
      section = null
  value


#======================================================================================================

exports.description = 'Create a basic Rabi Project!'
exports.warnOn = ['Gruntfile.js','Gruntfile.coffee']

exports.template = (grunt, init, done) ->
  gitconfig = parse(grunt.file.read("#{process.env.HOME}/.gitconfig"))
  init.process 
    type: 'rabi',
    [
      init.prompt('name'),
      init.prompt('description', 'N/A'),
      init.prompt('version', '0.0.0'),
      init.prompt('licenses', 'MIT'),
      init.prompt('author_name', gitconfig.user.name),
      init.prompt('author_email', gitconfig.user.email)
    ],
    (err, props) ->
      console.log(props)
      files = init.filesToCopy(props)
      init.addLicenseFiles(files, props.licenses)
      init.copyAndProcess(files, props)
      done

     
