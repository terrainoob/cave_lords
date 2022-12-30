# this is where things start when ./dragonruby is executed

def tick(args)
  x = 640
  y = 540
  text = 'Hi there!'
  size = 5
  align = 1

  args.outputs.labels << [x, y, text, size, align]
end
