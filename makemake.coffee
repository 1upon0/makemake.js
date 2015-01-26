deps = require('./depfinder') {
	'ball' : []
	'balltrail' : []
	'button' : []
	'color' : []
	'explosion' : []
	'log' : []
	'main' : []
	'matrix' : []
	'particle' : []
	'physics' : []
	'slider' : []
	'sprite' : []
	'texture' : []
	'ball_processor' : []
	'timer' : []
	'ui' : []
	'vektor' : []
	'wall' : []
}
console.log deps
libs = [
	'glut'
	'GL'
	'GLU'
	'pthread'
]

makes = []

dirs = {
	'src':'src/'
	'bin':'build/bin/'
	'build':'build/'
	'release':'build/release/'
	'debug':'build/debug/'
	'debug-file':'build/debug-file/'
	'doc':'doc/'
}

targets = {
	'release':''
	'debug':'-g -DDEBUG'
	'debug-file':'-g -DDEBUG -DDEBUG_FILE'
}

default_target = 'release'

fs = require 'fs'
mkdirp = require 'mkdirp'

(makes.push defmake for defmake in [
	"NUM_BALLS := 20"
	"NUM_THREADS := 4"
	"all: #{default_target}"
	"execute: execute-#{default_target}"
	"force:"
	"dirs:\n\tmkdir -p "+(dir for name,dir of dirs).join(' ')
	"makefile: makemake.coffee\n\tcoffee makemake.coffee"
	"doc: all\n\tcd doc/latex/ && make"
]) 

cleanmake="clean: force\n\trm -f #{dirs.bin}*"
for target of targets
	cleanmake+="\n\trm -f #{dirs[target]}*.o"
makes.push cleanmake

for target,opt of targets
	actualdeps = []
	for dep, extradeps of deps
		header = if fs.existsSync "#{dirs.src}#{dep}.h" then true else false
		if fs.existsSync "#{dirs.src}#{dep}.cpp"
			actualdeps.push dep
			make = "#{dirs[target]}#{dep}.o:  #{dirs.src}#{dep}.cpp " + ("#{dirs.src}#{extra}" for extra in extradeps).join(' ')
			make +="\n\tg++ #{opt} -c #{dirs.src}#{dep}.cpp -o #{dirs[target]}#{dep}.o 2>&1"
			makes.push make 
	mainmake = target+": "+("#{dirs[target]}#{dep}.o " for dep in actualdeps).join(' ') 
	mainmake+="\n\t g++ "+("#{dirs[target]}#{dep}.o " for dep in actualdeps).join(' ')+" "+("-l#{lib}" for lib in libs).join(' ')+ " -o #{dirs.bin}#{target} 2>&1"
	execmake = "execute-#{target}: #{target}\n\t#{dirs.bin}#{target} $(NUM_BALLS) $(NUM_THREADS)"
	makes.push mainmake
	makes.push execmake

fs.writeFile("makefile",(make for make in makes).join('\n'),(err)->console.log (if err? then err else "Made makefile successfully"))