extends Node

@export var PORT:int
@export var external_ip:String
var upnp:UPNP
# Called when the node enters the scene tree for the first time.
func _ready():
	upnp=UPNP.new()
	
	var discover_result = upnp.discover(2000,2,"InternetGatewayDevice")

	if discover_result == UPNP.UPNP_RESULT_SUCCESS:
#		print_debug("description_url ",upnp.get_device(0).description_url)
#		print_debug("igd_control_url ",upnp.get_device(0).igd_control_url)
#		print_debug("igd_our_addr ",upnp.get_device(0).igd_our_addr)
#		print_debug("igd_service_type ",upnp.get_device(0).igd_service_type)
#		print_debug("igd_status ",upnp.get_device(0).igd_status)
#		print_debug("service_type ",upnp.get_device(0).service_type)
		if upnp.get_gateway():
			if upnp.get_gateway().is_valid_gateway():
			
				external_ip=upnp.query_external_address()
#				print_debug("external_ip is ",external_ip)
				
				
				var map_result_udp=upnp.add_port_mapping(PORT,PORT,"godot_udp","UDP",0)
				var map_result_tcp=upnp.add_port_mapping(PORT,PORT,"godot_udp","TCP",0)
				
				if not map_result_udp == UPNP.UPNP_RESULT_SUCCESS:
					upnp.add_port_mapping(PORT,PORT,"","UDP")
					
				if not map_result_tcp == UPNP.UPNP_RESULT_SUCCESS:
					upnp.add_port_mapping(PORT,PORT,"","TCP")
		else:
#			print_debug("UPnP failed")
			pass

func _exit_tree():
	upnp.delete_port_mapping(PORT,"UDP")
	upnp.delete_port_mapping(PORT,"TCP")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
