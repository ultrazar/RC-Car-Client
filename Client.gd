extends Control

onready var conectar = $"Panel/Button"
onready var status = $"Panel/Label"
onready var target = $"Panel/LineEdit"


var websocket = WebSocketClient.new()
var conectat = false

func _ready():
	pass#update_status()

func _on_Button_pressed():
	#Conectar...
	var url = "ws://" + target.text + ":80"
	
	var err = websocket.connect_to_url(url)
	if err != OK:
		print("Unable to connect")
		set_process(false)
	
	websocket.connect("connection_closed",self,"closed")
	websocket.connect("connection_established",self,"connected")

func _process(delta):
	websocket.poll()


func update_status():
	if conectat:
		conectar.disabled = true
		status.text = "Estat: Conectat"
		status.modulate = Color("#41ff3f") #Verde
	else:
		conectar.disabled = false
		status.modulate =  Color("#ff3f3f") # Rojo
		status.text = "Estat: Desconectat"

func connected(b):
	conectat = true
	set_process(true)
	update_status()

func send(text:String):
	websocket.get_peer(1).put_packet(text.to_utf8())

func closed(b):
	conectat = false
	update_status()

onready var coche = $Viewport/Map
func _on_Updater_timeout():
	if conectat:
		var json = JSON.print({"command":"UPDATE_WHEELS","v":float(coche.vel), "d":float(coche.dir) })
		print("> " + json)
		send( json)
