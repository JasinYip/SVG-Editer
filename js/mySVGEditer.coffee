SVG_NS = 'http://www.w3.org/2000/svg';

createForm = document.getElementById "createForm"
attrsForm  = document.getElementById "attrsForm"

selected = null

shapeInfo = 
	rect : 'x:10,y:10,rx:0,ry:0,width:200,height:100'


defaultAttrs = 
	fill : '#ffffff',
	stroke : '#ff0000'

# Functions
createSVG = ->
	_svg = document.createElementNS(SVG_NS, 'svg')
	_svg.setAttribute "width", "100%"
	_svg.setAttribute "height", "100%"
	canvas.appendChild _svg
	return _svg

createShape = (shapeName) ->
	shape = document.createElementNS(SVG_NS, shapeName)
	svg.appendChild shape
	select shape

createControler = (shape, name, value) ->
	label = document.createElement "label"
	label.textContent = name

	controler = document.createElement "input"
	controler.setAttribute "name" , name
	controler.setAttribute "type" , "range"
	controler.setAttribute "value", value
	controler.setAttribute "min"  , 0
	controler.setAttribute "max"  , 800

	attrsForm.appendChild label
	attrsForm.appendChild controler

select = (shape) ->
	attrs = shapeInfo[shape.tagName].split ','
	attrsForm.innerHTML = ""

	while attrs.length
		attr = attrs.shift().split ':'
		name = attr[0]
		value = shape.getAttribute(name) || attr[1]
		createControler shape, name, value
		shape.setAttribute name, value

	for name, value of defaultAttrs
		value = shape.getAttribute(name) || value
		shape.setAttribute(name, value)

	selected = shape


# Events
createForm.addEventListener "click", (e) ->
	if e.target.tagName.toLowerCase() is "button"
		createShape e.target.getAttribute "create"

attrsForm.addEventListener "input", (e) ->
	if e.target.tagName.toLowerCase() is "input"
		controler = e.target
		selected.setAttribute controler.name, controler.value

canvas.addEventListener "click", (e) ->
	if e.target.tagName.toLowerCase() of shapeInfo
		select e.target



svg = createSVG()

