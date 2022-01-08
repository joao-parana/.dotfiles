--[[
---------------- USER CONFIGURATION ----------------
Change the parameters below to fit your needs.
]]--

-- Colors

HTML_color_battery = "#FFFFFF"
HTML_color_drive_1 = "#FFFFFF"
HTML_color_drive_2 = "#FFFFFF"
HTML_color_CPU = "#FFFFFF"
HTML_color_RAM = "#FFFFFF"
HTML_color_BORDER = "#FFFFFF"
transparency_battery = 0.6
transparency_drive_1 = 0.6
transparency_drive_2 = 0.6
transparency_CPU = 0.6
transparency_RAM = 0.6
transparency_border = 0.1

--[[
Show battery:
	true
	false
]]--
battery = false

--[[
Modes:
	1 = Show background area
	2 = No background area
]]--
mode = 2

-- Path of drives for free space status.
drive_paths = {"/"}

-- Names of drives for free space status.
drive_names = {"Root"}

-- Number of drives to show free space status. Adjust the conky "height"-parameter in config manually to adjust for the increase in Conky height when adding more drives.
drives = 1

-- Number of CPUs
number_of_cpus = 24

-- Special border width
special_border = 0

-- Normal border size
border_size = 4

-- Hide percent text in circular conky mode
hide = false

-- Draw a horizontal line over circle. Set a value for line size. A value of 0 disables drawing the line.
line_over_size = 0

-- Distance between each conky area.
gap_y = 10



























--[[
-- DON'T EDIT BELOW IF YOU DO NOT KNOW WHAT YOU ARE DOING!!!
]]--


require 'cairo'

operator = {CAIRO_OPERATOR_SOURCE,
			CAIRO_OPERATOR_CLEAR
		   }
		   
operator_transpose = {CAIRO_OPERATOR_CLEAR,
			CAIRO_OPERATOR_SOURCE
		   }

function hex2rgb(hex)
	hex = hex:gsub("#","")
	return (tonumber("0x"..hex:sub(1,2))/255), (tonumber("0x"..hex:sub(3,4))/255), tonumber(("0x"..hex:sub(5,6))/255)
end


r_battery, g_battery, b_battery = hex2rgb(HTML_color_battery)
r_CPU, g_CPU, b_CPU = hex2rgb(HTML_color_CPU)
r_RAM, g_RAM, b_RAM = hex2rgb(HTML_color_RAM)

r_border, g_border, b_border = hex2rgb(HTML_color_BORDER)

r_drive_1, g_drive_1, b_drive_1 = hex2rgb(HTML_color_drive_1)
r_drive_2, g_drive_2, b_drive_2 = hex2rgb(HTML_color_drive_2)

drive_colors = {{r_drive_1, g_drive_1, b_drive_1,transparency_drive_1},
				{r_drive_2, g_drive_2, b_drive_2,transparency_drive_2}}
				
function fix_text(text)
	if string.len(text) == 1 then
		new_text = "0" .. text .. "%"
		return new_text
	else
		new_text = text .. "%"
		return new_text
	end
end

function split_string(inputstr, sep)
	if sep == nil then
			sep = "%s"
	end
	local t={}
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
			table.insert(t, str)
	end
	return t
end


function draw_circle(cr,pos_x,pos_y,rectangle_x,rectangle_y,color1,color2,color3,trans,parameter)
	cairo_set_operator(cr, operator[mode])
	cairo_set_source_rgba(cr, color1,color2,color3,trans)
	cairo_set_line_width(cr, 2)
	
	-- Background

	cairo_arc(cr,pos_x+10+34,(88/2)+pos_y,54,0*math.pi/180,360*math.pi/180)
	cairo_fill(cr)

	-- End Background
	
	-- Border

	cairo_set_line_width(cr, border_size)
	cairo_set_source_rgba(cr, r_border,g_border,b_border,transparency_border)
	cairo_arc(cr,pos_x+10+34,(88/2)+pos_y,54,0*math.pi/180,360*math.pi/180)
	cairo_stroke(cr)

	-- End Border
	
	cairo_set_operator(cr, operator_transpose[mode])
	cairo_set_line_width(cr, special_border)

	-- Text Area

	cairo_set_source_rgba(cr, color1,color2,color3,trans)
	cairo_arc(cr,pos_x+10+34,(88/2)+pos_y,51,0*math.pi/180,360*math.pi/180)
	cairo_stroke(cr)
	cairo_close_path(cr)
	
	if not hide then
		ct = cairo_text_extents_t:create()
		cairo_set_font_size(cr,10)	
		cairo_text_extents(cr,fix_text(parameter),ct)
		cairo_move_to(cr,pos_x+10+34-ct.width/2,pos_y+start_rect_height/2-54+25/2+ct.height/2)
		cairo_show_text(cr,fix_text(parameter))
		cairo_close_path(cr)
	end

	-- Text End
	
	-- Reposition to draw next object 

	cairo_set_line_width(cr, line_over_size)
	cairo_move_to(cr,pos_x+10+34,pos_y+start_rect_height/2)
	cairo_rel_line_to(cr,54,0)
	cairo_rel_line_to(cr,-108,0)
	cairo_stroke(cr)
end

function draw_battery(cr,pos_x, pos_y,start_rect_height,color1,color2,color3,trans)

	cairo_set_operator(cr, operator_transpose[mode])
	cairo_set_source_rgba(cr, color1,color2,color3,trans)
	cairo_set_line_width(cr, 2)  
	set_battery_blocks_x = 0
	--battery_gap_y = (start_rect_height/2)-27/2+pos_y-10
	battery_gap_y = (88/2)-(27/2)+pos_y

	cairo_move_to(cr,pos_x,battery_gap_y)
	cairo_rel_line_to(cr,64,0)
	cairo_rel_line_to(cr,0,((27-10)/2))
	cairo_rel_line_to(cr,5,0)
	cairo_rel_line_to(cr,0,10)
	cairo_rel_line_to(cr,-5,0)
	cairo_rel_line_to(cr,0,((27-10)/2))
    cairo_rel_line_to(cr,-64,0)
	cairo_close_path(cr)
	cairo_fill(cr)
	
	number_of_charges = math.floor((12 / 100)*tonumber(conky_parse('${battery_percent}')))
	cairo_set_operator(cr, operator[mode])
	for i=1,number_of_charges do
		cairo_rectangle(cr,pos_x+3+set_battery_blocks_x,3+battery_gap_y,3,21)
		cairo_fill(cr)
		set_battery_blocks_x = set_battery_blocks_x + 5
	end
end

function draw_folder(cr,x_pos,y_pos,start_rect_height,hdd,folder_name,r_color_drive,g_color_drive,b_color_drive,transparency_drive)

-- Draw indicator
	cairo_set_source_rgba(cr,r_color_drive,g_color_drive,b_color_drive,transparency_drive)
	cairo_set_operator(cr, operator_transpose[mode])
	local distance_between_arcs = 0
	local number_of_arcs = 20
	local arcs_length = (360 - (number_of_arcs*distance_between_arcs)) / number_of_arcs
	local start_angel = 270
	local used_blocks = math.floor((number_of_arcs / 100) * tonumber(conky_parse('${fs_free_perc ' .. hdd .. '}')))
	local radius_outer = 34
	local radius_inner = 24
	local radius = 29
	cairo_set_line_width(cr, 2)


	cairo_set_line_width(cr, 6)
	-- main indicator
	cairo_arc(cr,x_pos+10+34,(start_rect_height/2)+y_pos,radius,start_angel*math.pi/180,(start_angel+360)*math.pi/180)
	cairo_stroke(cr)
	
	cairo_set_line_width(cr, 3)
	cairo_set_operator(cr, operator[mode])
	for i=1, used_blocks do
		-- usage indicator
		cairo_arc(cr, x_pos+10+34,(start_rect_height/2)+y_pos,radius,start_angel*math.pi/180,(start_angel+arcs_length)*math.pi/180)
		cairo_stroke(cr)
		start_angel = start_angel+arcs_length+distance_between_arcs
	end

	cairo_set_operator(cr, operator_transpose[mode])
	cairo_set_source_rgba(cr,r_color_drive,g_color_drive,b_color_drive,transparency_drive)
	cairo_set_line_width(cr, 2)
	
	-- roof
	cairo_move_to(cr,x_pos+10+34-15,(start_rect_height/2-5.5)+y_pos)
	cairo_rel_line_to(cr,15,-9)
	cairo_rel_line_to(cr,15,9)
	cairo_rel_line_to(cr,0,4)
	cairo_rel_line_to(cr,-15,-9)
	cairo_rel_line_to(cr,-15,9)
	cairo_close_path(cr)
	cairo_fill(cr)
	
	-- chimney
	cairo_move_to(cr,x_pos+10+34-15+24,(start_rect_height/2-5.5)-6+y_pos)
    cairo_rel_line_to(cr,4,2)
	cairo_rel_line_to(cr,0,-5)
	cairo_rel_line_to(cr,-4,0)
	cairo_close_path(cr)
	cairo_fill(cr)
	
	-- house block
	cairo_move_to(cr,x_pos+10+34-15+4,(start_rect_height/2-5.5)+5+y_pos)
	cairo_rel_line_to(cr,11,-7)
	cairo_rel_line_to(cr,11,7)
	cairo_rel_line_to(cr,0,15)
	cairo_rel_line_to(cr,-(11*2-math.abs(-8))/2,0)
	cairo_rel_line_to(cr,0,-6)
	cairo_rel_line_to(cr,-8,0)
	cairo_rel_line_to(cr,0,6)
	cairo_rel_line_to(cr,-(11*2-math.abs(-8))/2,0)
	cairo_close_path(cr)
	cairo_fill(cr)

	-- HD name
	cairo_set_operator(cr, operator_transpose[mode])
	ct_text = cairo_text_extents_t:create()
	cairo_set_font_size(cr,14)
	cairo_text_extents(cr,folder_name,ct_text)
	cairo_move_to(cr,x_pos+10+34-ct_text.width/2,(start_rect_height/2)+y_pos+54-25/2+ct_text.height/2) 		
	cairo_show_text(cr,folder_name)
	

	-- position reset
	cairo_set_line_width(cr, line_over_size)
	-- cairo_move_to(cr,x_pos+10+34,y_pos+start_rect_height/2)
	cairo_move_to(cr,x_pos+10+34,y_pos)
	cairo_rel_line_to(cr,54,0)
	cairo_rel_line_to(cr,-108,0)
	cairo_stroke(cr)
end

function draw_cpu(cr,x_pos,y_pos,r,g,b,transparency, number_of_cpus)

	cairo_select_font_face (cr, "GE Inspira", CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_BOLD);

	cairo_set_operator(cr, operator_transpose[mode])
	cairo_set_source_rgba(cr,r,g,b,transparency)

	local cpu_name = "Ryzen 5900X" 

	local cm_text = cairo_text_extents_t:create()
	cairo_set_font_size(cr,20)
	cairo_text_extents(cr,cpu_name,cm_text)
	cairo_move_to(cr, x_pos + outter_rect_width/2 - cm_text.width/2 , y_pos + cm_text.height)
	cairo_show_text(cr,cpu_name)

	local cpu_usage = conky_parse("${cpu cpu0}") .. " %"

	local am_text = cairo_text_extents_t:create()
	cairo_set_font_size(cr,20)
	cairo_text_extents(cr, cpu_usage, am_text)
	cairo_move_to(cr, x_pos + outter_rect_width/2 - am_text.width/2 , y_pos + outter_rect_height/2 + am_text.height/2 + 10)
	cairo_show_text(cr, cpu_usage)

	local arc_x = outter_rect_width / 2
	local arc_y = outter_rect_height / 2 + 10

	local outter_radius = (outter_rect_height - 40) / 2

	local meter_radius = outter_radius - 5

	local inner_radius = outter_radius - 10

	cairo_new_path(cr)
	cairo_set_line_width (cr, 2.0);
	cairo_arc(cr, arc_x, arc_y, outter_radius, 0, 2*math.pi)
	cairo_stroke(cr);
	cairo_arc(cr, arc_x, arc_y, inner_radius, 0, 2*math.pi)
	cairo_stroke(cr);

	local cpu_usage_radius = (tonumber(conky_parse("${cpu cpu0}")) / 100) * 2*math.pi
	cairo_set_line_width (cr, 4.0);
	cairo_arc(cr, arc_x, arc_y, meter_radius, math.pi, cpu_usage_radius + math.pi)
	cairo_stroke(cr);

end

function draw_ram(cr,x_pos,y_pos,corner_radius,r_RAM,g_RAM,b_RAM,transparency_RAM,used_ram,total_ram)

	cairo_select_font_face (cr, "GE Inspira", CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_BOLD);

	cairo_set_operator(cr, operator_transpose[mode])

	local mem_per = (used_ram/total_ram) * 100;

	cairo_set_source_rgba(cr,r_RAM,g_RAM,b_RAM,transparency_RAM)

	local consumed_ram = used_ram .. " GB"

	local cm_text = cairo_text_extents_t:create()
	cairo_set_font_size(cr,20)
	cairo_text_extents(cr,consumed_ram,cm_text)
	cairo_move_to(cr, x_pos + outter_rect_width/2 - cm_text.width/2 , y_pos + cm_text.height)
	cairo_show_text(cr,consumed_ram)

	local available_ram = total_ram .. " GB"

	local am_text = cairo_text_extents_t:create()
	cairo_set_font_size(cr,20)
	cairo_text_extents(cr,available_ram,am_text)
	cairo_move_to(cr, x_pos + outter_rect_width/2 - am_text.width/2 , y_pos + outter_rect_height)
	cairo_show_text(cr,available_ram)

	local padding_horizontal = 10
	local padding_vertical = math.max(am_text.height, cm_text.height) + 4

	local inner_rect_height = outter_rect_height - 2 * padding_vertical
    local inner_rect_width = outter_rect_width - 2 * padding_horizontal

	-- Memory chip drawing (body)

	local chip_height = 50
	local chip_width = outter_rect_width - 4 * padding_horizontal

	local inner_x = x_pos + (outter_rect_width - chip_width) / 2
	local inner_y = y_pos + (outter_rect_height - chip_height) / 2

	cairo_set_source_rgba(cr,r_RAM,g_RAM,b_RAM,transparency_RAM)
	cairo_new_path(cr)
	-- top right corner	
	cairo_arc(cr, inner_x + chip_width - corner_radius, inner_y + corner_radius, corner_radius, 3 * math.pi/2, 0)
	-- bottom right corner
	cairo_arc(cr, inner_x + chip_width - corner_radius, inner_y + chip_height - corner_radius, corner_radius, 0, math.pi/2)
	-- bottom left corner
	cairo_arc(cr, inner_x + corner_radius, inner_y + chip_height - corner_radius, corner_radius, math.pi/2, math.pi)
	-- top left corner
	cairo_arc(cr, inner_x + corner_radius, inner_y + corner_radius, corner_radius, math.pi, 3*math.pi/2)

	cairo_close_path(cr)
	cairo_set_line_width (cr, 5.0);
	cairo_stroke(cr);


	local indicator_name = "DDR"

	-- Memory Chip (Text)	
	ct_text = cairo_text_extents_t:create()
	cairo_set_font_size(cr, 20)
	cairo_text_extents(cr, indicator_name,ct_text)
	cairo_move_to(cr, x_pos + (outter_rect_width / 2) - ct_text.width/2, y_pos + ct_text.height/2 + outter_rect_height/2) 		
	cairo_show_text(cr, indicator_name)

	-- Memory chip drawing (Connector)

	local max_pin_count = 6

	local pin_ratio = 6 * mem_per/100

	local full_pin_count = math.floor(pin_ratio)

	local decimal = pin_ratio - full_pin_count

	if decimal >= 0.5 then
		full_pin_count = full_pin_count + 1
	end

	local pin_padding = 4

	local pin_slot_width = (chip_width - 2 * corner_radius) / max_pin_count;

	local pin_width = pin_slot_width - pin_padding

	local pin_spacer = 10

	cairo_set_line_width(cr, 2.0)
	cairo_new_path(cr)

	for i=0, max_pin_count - 1 do 

		-- top array
		local x_arc = inner_x + corner_radius + pin_padding/2 + pin_width/2 + i * (pin_padding + pin_width)
	
		local y_arc = inner_y - pin_spacer

		cairo_arc(cr, x_arc, y_arc, pin_width/2, math.pi, 0)

		cairo_line_to(cr, x_arc + pin_width/2, y_arc + pin_spacer/2)
		cairo_line_to(cr, x_arc - pin_width/2, y_arc + pin_spacer/2)
		cairo_line_to(cr, x_arc - pin_width/2, y_arc)

		if (i + 1) <= full_pin_count then
			cairo_stroke_preserve(cr)
			cairo_fill(cr)
		else
			cairo_stroke(cr)
		end

		-- Bottom array

		local x_arc = inner_x + corner_radius + pin_padding/2 + pin_width/2 + i * (pin_padding + pin_width)
	
		local y_arc = inner_y + chip_height + pin_spacer

		cairo_arc(cr, x_arc, y_arc, pin_width/2, 0, math.pi)

		cairo_line_to(cr, x_arc - pin_width/2, y_arc - pin_spacer/2)
		cairo_line_to(cr, x_arc + pin_width/2, y_arc - pin_spacer/2)
		cairo_line_to(cr, x_arc + pin_width/2, y_arc)

		if (i + 1) <= full_pin_count then
			cairo_stroke_preserve(cr)
			cairo_fill(cr)
		else
			cairo_stroke(cr)
		end

	end
end

function draw_function(cr)
	local w,h=conky_window.width,conky_window.height	
	cairo_select_font_face (cr, "Dejavu Sans Book", CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_NORMAL);

   	local start_rect_x = 0
   	local start_rect_y = 0

	outter_rect_height = 150
    outter_rect_width = 150
    
	--gap_y_text = (start_rect_height/2)-7
    
	gap_x = 10
	gap_x_fix = 15
	gap_y_fix = 15
	radius = 10
	start_rect_height_no_battery = 66.5

	if battery then
		draw_circle(cr,start_rect_x+gap_x_fix,gap_y_fix, start_rect_width, start_rect_height,r_battery, g_battery, b_battery, transparency_battery,conky_parse('${battery_percent}'))
		draw_battery(cr,gap_x+gap_x_fix, gap_y_fix,start_rect_height,r_battery, g_battery, b_battery, transparency_battery)

		for i=1,drives do
			draw_circle(cr,start_rect_x+gap_x_fix,(start_rect_height+20+gap_y)*i+gap_y_fix, start_rect_width, start_rect_height,drive_colors[i][1], drive_colors[i][2], drive_colors[i][3], drive_colors[i][4],conky_parse('${fs_free_perc ' .. drive_paths[i] .. '}'))
			draw_folder(cr,start_rect_x+gap_x_fix,(start_rect_height+20+gap_y)*i+gap_y_fix,start_rect_height,drive_paths[i],drive_names[i],drive_colors[i][1], drive_colors[i][2], drive_colors[i][3], drive_colors[i][4])
		end
		draw_circle(cr,start_rect_x+gap_x_fix,(start_rect_height+20+gap_y)*(drives+1)+gap_y_fix, start_rect_width, start_rect_height,r_CPU, g_CPU, b_CPU, transparency_CPU,conky_parse('${cpu cpu0}'))
		draw_cpu(cr,number_of_cpus,gap_x+gap_x_fix,(start_rect_height+20+gap_y)*(drives+1)+gap_y_fix,r_CPU, g_CPU, b_CPU, transparency_CPU)
		draw_circle(cr,start_rect_x+gap_x_fix,(start_rect_height+gap_y+20)*(drives+2)+gap_y_fix, start_rect_width, start_rect_height,r_RAM, g_RAM, b_RAM, transparency_RAM,tostring(100-tonumber(conky_parse('${memperc}'))))
		draw_ram(cr,gap_x+gap_x_fix,(start_rect_height+gap_y+20)*(drives+2)+10+gap_y_fix, radius, r_RAM, g_RAM, b_RAM, transparency_RAM)
	else
		-- for i=1,drives do
		-- 	draw_circle(cr,start_rect_x+gap_x_fix,start_rect_height_no_battery+gap_y_fix, start_rect_width, start_rect_height,drive_colors[i][1], drive_colors[i][2], drive_colors[i][3], drive_colors[i][4],conky_parse('${fs_free_perc ' .. drive_paths[i] .. '}'))
		-- 	draw_folder(cr,start_rect_x+gap_x_fix,(start_rect_height_no_battery)+gap_y_fix,start_rect_height,drive_paths[i],drive_names[i],drive_colors[i][1], drive_colors[i][2], drive_colors[i][3], drive_colors[i][4])
		-- 	start_rect_height_no_battery = start_rect_height_no_battery+108+gap_y
		-- end
		
		draw_cpu(cr, 0, 0, r_CPU, g_CPU, b_CPU, transparency_CPU, number_of_cpus)

		local mem_total = tonumber(split_string(conky_parse('${memmax}'), '%s')[1])

		local mem_used = tonumber(split_string(conky_parse('${mem}'), '%s')[1])
		
		local mem_percent = tostring(100-tonumber(conky_parse('${memperc}')));

		draw_ram(cr, 0, 160, 10, r_RAM, g_RAM, b_RAM, transparency_RAM, mem_used, mem_total)
	end
end



function conky_start_widgets()
	local function draw_conky_function(cr)
		local str=''
		local value=0	
		draw_function(cr)
	end
	
	-- Check that Conky has been running for at least 5s

	if conky_window==nil then return end
	local cs=cairo_xlib_surface_create(conky_window.display,conky_window.drawable,conky_window.visual, conky_window.width,conky_window.height)
	
	local cr=cairo_create(cs)	
	
	local updates=conky_parse('${updates}')
	update_num=tonumber(updates)
	
	if update_num>5 then
		draw_conky_function(cr)
	end
	cairo_surface_destroy(cs)
	cairo_destroy(cr)
end
