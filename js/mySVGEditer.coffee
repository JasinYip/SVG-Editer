SVG_NS = 'http://www.w3.org/2000/svg';

createForm = document.getElementById "createForm"
attrForm   = document.getElementById "attrsForm"

shapeInfo = 
	rect : 'x:10,y:10,width:200,height:100,rx:0,ry:0'


defaultAttrs = 
	fill : '#ffffff',
	stroke : '#ff0000'

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

select = (shape) ->
	attrs = shapeInfo[shape.tagName].split ','
	attrForm.innerHTML = ""

	while attrs.length
		attr = attrs.shift().split ':'
		name = attr[0]
		value = shape.getAttribute(name) || attr[1]
		createControler shape, name, value
		shape.setAttribute name, value

	for name, value of defaultAttrs
		value = shape.getAttribute(name) || value
		shape.setAttribute(name, value)

svg = createSVG()

createForm.addEventListener "click", (e) ->
	if e.target.tagName.toLowerCase() == "button"
		createShape e.target.getAttribute "create"
