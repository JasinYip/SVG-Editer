SVG_NS = "http://www.w3.org/2000/svg"

createForm        = document.getElementById "createForm"
attrsForm         = document.getElementById "attrsForm"
lookForm          = document.getElementById "lookForm"
canvasSettingForm = document.getElementById "canvasSettingForm"
strokeWidth       = document.getElementById "stroke-width"

selected = {}

drag =
	target : null

	setDrag : (target, mouseCurrentX, mouseCurrentY) ->
		this.target        = target
		this.mouseCurrentX = mouseCurrentX
		this.mouseCurrentY = mouseCurrentY
		this.shapeCurrentX = +selected.getAttribute "x"
		this.shapeCurrentY = +selected.getAttribute "y"
		this.target.addEventListener "mousemove", drag.draggable

		return this

	rmDrag : ->
		this.target.removeEventListener "mousemove", drag.draggable
		this.target        = null
		this.mouseCurrentX = 0
		this.mouseCurrentY = 0
		this.shapeCurrentX = 0
		this.shapeCurrentY = 0

		return this

	draggable : (e) ->
		if e.target is drag.target
			mouseMoveX  = e.x - drag.mouseCurrentX
			mouseMoveY  = e.y - drag.mouseCurrentY
			drag.target.setAttribute "x", drag.shapeCurrentX + mouseMoveX
			drag.target.setAttribute "y", drag.shapeCurrentY + mouseMoveY
			

shapeInfo = 
	rect : "x:10,y:10,rx:0,ry:0,width:200,height:100"

defaultAttrs = 
	fill : "#ffffff",
	stroke : "#ff0000",
	"stroke-width" : 1
	transform : "translate(0,0) rotate(0) scale(1)"

# Functions
createSVG = ->
	_svg = document.createElementNS(SVG_NS, "svg")
	_svg.setAttribute "width", "100%"
	_svg.setAttribute "height", "100%"
	canvas.appendChild _svg
	_svg.setAttribute "viewBox", "0 0 " + _svg.offsetWidth + " " + _svg.offsetHeight
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
	controler.setAttribute "id"   , "ctrl" + name

	attrsForm.appendChild label
	attrsForm.appendChild controler

updateLookControler = () ->
	fill.value = selected.getAttribute "fill"
	stroke.value = selected.getAttribute "stroke"
	strokeWidth.value = selected.getAttribute "stroke-width"
	t = decodeTransform(selected.getAttribute('transform'))
	if t
		translateX.value = t.tx
		translateY.value = t.ty
		rotate.value = t.rotate
		scale.value = t.scale
	else
		translateX.value = 0
		translateY.value = 0
		rotate.value = 0
		scale.value = 1

select = (shape) ->
	attrs = shapeInfo[shape.tagName].split ","
	attrsForm.innerHTML = ""

	while attrs.length
		attr = attrs.shift().split ":"
		name = attr[0]
		value = shape.getAttribute(name) || attr[1]
		createControler shape, name, value
		shape.setAttribute name, value

	for name, value of defaultAttrs
		value = shape.getAttribute(name) || value
		shape.setAttribute(name, value)

	selected = shape

	updateLookControler()

encodeTranform = (transObj) ->
	[
		"translate(", transObj.tx, ",", transObj.ty, ") ",
		"rotate(", transObj.rotate, ") ",
		"scale(", transObj.scale , ")"
	].join ""

decodeTransform = (transString) ->
	match = /translate\((-?\d+),(-?\d+)\)\srotate\((-?\d+)\)\sscale\((\d+|\d+?\.\d+)\)/.exec(transString)
	if match
		{
			tx: +match[1],
			ty: +match[2],
			rotate: +match[3],
			scale: +match[4]
		}
	else
		null

# Events
createForm.addEventListener "click", (e) ->
	if e.target.tagName.toLowerCase() is "button"
		createShape e.target.getAttribute "create"

attrsForm.addEventListener "input", (e) ->
	if e.target.tagName.toLowerCase() is "input"
		controler = e.target
		selected.setAttribute controler.name, controler.value

lookForm.addEventListener "input", (e) ->
	return if e.target.tagName.toLowerCase() isnt "input"
	return if !selected
	if e.target.parentNode is document.getElementById "row-transforms"
		selected.setAttribute "transform", encodeTranform 
			tx: translateX.value,
			ty: translateY.value,
			scale: scale.value,
			rotate: rotate.value
	else
		selected.setAttribute e.target.id, e.target.value

canvas.addEventListener "mousedown", (e) ->
	if e.target.tagName.toLowerCase() of shapeInfo
		select e.target
		drag.setDrag e.target, e.x, e.y

canvas.addEventListener "mouseup", (e) ->
	drag.rmDrag() if drag.target

svgViewBox.addEventListener "input", (e) ->
	svgWid = svg.offsetWidth * e.target.value
	svgHgt = svg.offsetHeight * e.target.value

	svg.setAttribute "viewBox", "0 0 " + svgWid + " " + svgHgt

recoverDefault.addEventListener "click", (e) ->
	# 缩放恢复为 1.0x
	svgViewBox.value = 1
	wid = svg.offsetWidth
	hgt = svg.offsetHeight
	svg.setAttribute "viewBox", "0 0 " + wid + " " + hgt

svg = createSVG()

window.onresize = ->
	svg.setAttribute("viewBox", svg.getAttribute("viewBox"))