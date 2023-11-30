shader_type spatial;
//render_mode blend_mix, world_vertex_coords;

group_uniforms Measurement_Colors;
	uniform vec4 primary_tick_color: source_color=vec4(1,1,1,1);
	uniform vec4 secondary_tick_color: source_color=vec4(.2,.2,.2,1);
	uniform vec4 ground_color: source_color=vec4(0,0.4,0,1);
group_uniforms Thresholds;
	uniform float primary_tick_thickness:hint_range(0,1)=0.01;
	uniform float secondary_tick_thickness:hint_range(0,1)=0.01;
	uniform float primary_tick_increment:hint_range(0,1e3)=1;
	uniform float secondary_tick_increment:hint_range(0,1e3)=1;

void fragment() {
	vec3 world_vertex = (INV_VIEW_MATRIX * vec4(VERTEX, 1.0)).xyz;
	vec3 color_out=vec3(0.5);
	if (
		// Main Ticks drawn
			fract(world_vertex.x/primary_tick_increment) < primary_tick_thickness/2.0 ||
		 (1.0-fract(world_vertex.x/primary_tick_increment)) < primary_tick_thickness/2.0 ||
		fract(world_vertex.y/primary_tick_increment) < primary_tick_thickness/2.0 ||
		 (1.0-fract(world_vertex.y/primary_tick_increment)) < primary_tick_thickness/2.0 ||
		fract(world_vertex.z/primary_tick_increment) < primary_tick_thickness/2.0 ||
		 (1.0-fract(world_vertex.z/primary_tick_increment)) < primary_tick_thickness/2.0
	){
		color_out=primary_tick_color.rgb;
	}else{
		if(		
			// Secondary Ticks Drawn
			fract(world_vertex.x/secondary_tick_increment) <= secondary_tick_thickness/2.0 ||
			 (1.0-fract(world_vertex.x/secondary_tick_increment)) <= secondary_tick_thickness/2.0 ||
			fract(world_vertex.y/secondary_tick_increment) <= secondary_tick_thickness/2.0 ||
			 (1.0-fract(world_vertex.y/secondary_tick_increment)) <= secondary_tick_thickness/2.0 ||
			fract(world_vertex.z/secondary_tick_increment) <= secondary_tick_thickness/2.0 ||
			 (1.0-fract(world_vertex.z/secondary_tick_increment)) <= secondary_tick_thickness/2.0
		){
			color_out=secondary_tick_color.rgb;
		}
		else{
		 // Ground Drawn
		color_out=ground_color.rgb;
		}
	}
	ALBEDO=color_out;
	ALPHA=1.0;
}