fs=require 'fs'
_=require 'underscore'
dir='src/'
gendeps = (buf) ->
	regex=/(?:\n|$)(?: +?)?#include(?: +?)?"([^"]+?)"/g
	while (res=regex.exec(buf))?
		res[1]
module.exports= (deps) ->
	deps=_.clone deps
	for dep of deps
		depz = []
		resolvedep = (file) ->
			if fs.existsSync(dir+file)
				extradep = gendeps fs.readFileSync(dir+file,'utf8')
				newdeps = _.difference extradep,depz
				depz = _.union depz, newdeps
				for dep in newdeps
					depz = _.union depz, resolvedep dep
			return depz
		deps[dep]=resolvedep dep+'.cpp'
	deps