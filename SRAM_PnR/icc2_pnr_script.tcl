# Initialize the lib (it would be worthwhile to open tech.tf in gvim and check what it contains)
#create_lib -technology /package/eda/cells/OSU/v2.7/synopsys/flow/tsmc018/tech.tf \
    -ref_libs /home/ecegrid/a/ece559/tsmc018_stdcell.ndm my_sram_decoder.nlib
create_lib -technology /package/eda/cells/OSU/v2.7/synopsys/flow/tsmc018/tech.tf \
    -ref_libs {/home/ecegrid/a/ece559/tsmc018_stdcell.ndm /home/ecegrid/a/559mg16/SRAM_LEFtoNDM/sram_senseamp_ndm} my_sram_decoder.nlib
# Read in netlist (This automatically creates a new block in the lib)
read_verilog /home/ecegrid/a/559mg16/SRAM_synth/decoder.netlist.v

##SRAM NDM steps
create_cell sram_senseamp [get_lib_cells sram_senseamp_ndm/sram_array_layout_best_128x16_Instance_Senseamp/frame]

# Initial Save
save_block
save_lib

# Read in timing/electrical constraints
source ./decoder.sdc

# Create the frame for the decoder; Dimensions will automatically be snapped to a multiple of std_cell tile (0.8 1)
 #initialize_floorplan -shape R -side_length {120 500} -core_offset {0.8 1}
 initialize_floorplan -shape R -side_length {250 500} -core_offset {0.8 1}
# Added by Raghu
##initialize_floorplan -shape R -side_length {127.25 471.5} -core_offset {0.8 1}

# You can open the GUI to see the floorplan at this stage
start_gui

##SRAM NDM steps
set_cell_location sram_senseamp -coordinates {139 1}
for {set i 0} {$i < 128} {incr i} {
	#create_net sram_net_read_$i
	set net_name [get_object_name [get_nets -of_objects [get_ports read_wl[$i]]]]
	disconnect_net -net $net_name [get_ports read_wl[$i]]
	remove_ports read_wl[$i]
	connect_net -net $net_name [get_pins sram_senseamp/RWL[$i]]
	
	#create_net sram_net_write_$i
	set net_name [get_object_name [get_nets -of_objects [get_ports write_wl[$i]]]]
	disconnect_net -net $net_name [get_ports write_wl[$i]]
	remove_ports write_wl[$i]
	connect_net -net $net_name [get_pins sram_senseamp/WWL[$i]]
	
}

#SRAM NDM Steps
create_routing_blockage -net_types {clock power ground signal} -zero_spacing -name_prefix sram_rblkg -layers [get_layers metal*] -boundary {{139.0000 0.0000} {250.400 502.000}}
create_placement_blockage -boundary {{139.0000 0.0000} {250.400 502.000}} -type hard -name sram_pblkg
set_attribute [get_cells sram*] physical_status fixed
# Create PG mesh
source ./create_pg.tcl


# Configure ports
set_individual_pin_constraint -length 0.8 -width 0.48 -sides 1 \
    -ports [get_ports -f direction==in] -pin_spacing 4 -allowed_layers {metal3}
place_pins -ports [get_ports -filter direction==in]

#set_individual_pin_constraint -length 0.8 -width 0.48 -sides 3 \
#    -ports [get_ports -f direction==out] -pin_spacing 1 -allowed_layers {metal3}
#place_pins -ports [get_ports -filter direction==out]
#
# # Need to add port nets to bundle in the order which we want them placed 
# # In this case, interleaved write_wl and read_wl in alternating flipped manner
# create_bundle -name wordline_ports_w_even
# create_bundle -name wordline_ports_r_even
# create_bundle -name wordline_ports_w_odd
# create_bundle -name wordline_ports_r_odd
# for {set i 0} {$i < 128} {incr i} {
#     if {$i%2} {
#         add_to_bundle -bundle wordline_ports_w_odd [get_nets -of [get_port write_wl[$i]]]
#         add_to_bundle -bundle wordline_ports_r_odd [get_nets -of [get_port read_wl[$i]]]
#     } else {
#         add_to_bundle -bundle wordline_ports_r_even [get_nets -of [get_port read_wl[$i]]]
#         add_to_bundle -bundle wordline_ports_w_even [get_nets -of [get_port write_wl[$i]]]
#     }
# }
#
# set_bundle_pin_constraints -bundle_order decreasing -bundles wordline_ports_r_even -keep_pins_together true -pin_spacing_distance 6 -range {0 800} -sides 3 -allowed_layers {metal3}
# place_pins -ports {read_wl[0] read_wl[2] read_wl[4] read_wl[6] read_wl[8] read_wl[10] read_wl[12] read_wl[14] read_wl[16] read_wl[18] read_wl[20] read_wl[22] read_wl[24] read_wl[26] read_wl[28] read_wl[30] read_wl[32] read_wl[34] read_wl[36] read_wl[38] read_wl[40] read_wl[42] read_wl[44] read_wl[46] read_wl[48] read_wl[50] read_wl[52] read_wl[54] read_wl[56] read_wl[58] read_wl[60] read_wl[62] read_wl[64] read_wl[66] read_wl[68] read_wl[70] read_wl[72] read_wl[74] read_wl[76] read_wl[78] read_wl[80] read_wl[82] read_wl[84] read_wl[86] read_wl[88] read_wl[90] read_wl[92] read_wl[94] read_wl[96] read_wl[98] read_wl[100] read_wl[102] read_wl[104] read_wl[106] read_wl[108] read_wl[110] read_wl[112] read_wl[114] read_wl[116] read_wl[118] read_wl[120] read_wl[122] read_wl[124] read_wl[126]}
# set_bundle_pin_constraints -bundle_order decreasing -bundles wordline_ports_w_even -keep_pins_together true -pin_spacing_distance 6 -range {4 800} -sides 3 -allowed_layers {metal3} 
# place_pins -ports {write_wl[0] write_wl[2] write_wl[4] write_wl[6] write_wl[8] write_wl[10] write_wl[12] write_wl[14] write_wl[16] write_wl[18] write_wl[20] write_wl[22] write_wl[24] write_wl[26] write_wl[28] write_wl[30] write_wl[32] write_wl[34] write_wl[36] write_wl[38] write_wl[40] write_wl[42] write_wl[44] write_wl[46] write_wl[48] write_wl[50] write_wl[52] write_wl[54] write_wl[56] write_wl[58] write_wl[60] write_wl[62] write_wl[64] write_wl[66] write_wl[68] write_wl[70] write_wl[72] write_wl[74] write_wl[76] write_wl[78] write_wl[80] write_wl[82] write_wl[84] write_wl[86] write_wl[88] write_wl[90] write_wl[92] write_wl[94] write_wl[96] write_wl[98] write_wl[100] write_wl[102] write_wl[104] write_wl[106] write_wl[108] write_wl[110] write_wl[112] write_wl[114] write_wl[116] write_wl[118] write_wl[120] write_wl[122] write_wl[124] write_wl[126]}
# 
# set_bundle_pin_constraints -bundle_order decreasing -bundles wordline_ports_w_odd -keep_pins_together true -pin_spacing_distance 6 -range {0 800} -sides 3  -allowed_layers {metal3}
# place_pins -ports {write_wl[1] write_wl[3] write_wl[5] write_wl[7] write_wl[9] write_wl[11] write_wl[13] write_wl[15] write_wl[17] write_wl[19] write_wl[21] write_wl[23] write_wl[25] write_wl[27] write_wl[29] write_wl[31] write_wl[33] write_wl[35] write_wl[37] write_wl[39] write_wl[41] write_wl[43] write_wl[45] write_wl[47] write_wl[49] write_wl[51] write_wl[53] write_wl[55] write_wl[57] write_wl[59] write_wl[61] write_wl[63] write_wl[65] write_wl[67] write_wl[69] write_wl[71] write_wl[73] write_wl[75] write_wl[77] write_wl[79] write_wl[81] write_wl[83] write_wl[85] write_wl[87] write_wl[89] write_wl[91] write_wl[93] write_wl[95] write_wl[97] write_wl[99] write_wl[101] write_wl[103] write_wl[105] write_wl[107] write_wl[109] write_wl[111] write_wl[113] write_wl[115] write_wl[117] write_wl[119] write_wl[121] write_wl[123] write_wl[125] write_wl[127]}
# set_bundle_pin_constraints -bundle_order decreasing -bundles wordline_ports_r_odd -keep_pins_together true -pin_spacing_distance 6 -range {0 800} -sides 3  -allowed_layers {metal3}
# place_pins -ports {read_wl[1] read_wl[3] read_wl[5] read_wl[7] read_wl[9] read_wl[11] read_wl[13] read_wl[15] read_wl[17] read_wl[19] read_wl[21] read_wl[23] read_wl[25] read_wl[27] read_wl[29] read_wl[31] read_wl[33] read_wl[35] read_wl[37] read_wl[39] read_wl[41] read_wl[43] read_wl[45] read_wl[47] read_wl[49] read_wl[51] read_wl[53] read_wl[55] read_wl[57] read_wl[59] read_wl[61] read_wl[63] read_wl[65] read_wl[67] read_wl[69] read_wl[71] read_wl[73] read_wl[75] read_wl[77] read_wl[79] read_wl[81] read_wl[83] read_wl[85] read_wl[87] read_wl[89] read_wl[91] read_wl[93] read_wl[95] read_wl[97] read_wl[99] read_wl[101] read_wl[103] read_wl[105] read_wl[107] read_wl[109] read_wl[111] read_wl[113] read_wl[115] read_wl[117] read_wl[119] read_wl[121] read_wl[123] read_wl[125] read_wl[127]}
# 
 ##set_individual_pin_constraint -length 0.8 -width 0.48 -sides 3 \
 #    -ports [get_ports {write_wl* read_wl*}] -pin_spacing 1 -allowed_layers {metal3}
 ##place_pins -ports [get_ports {write_wl* read_wl*}]

# to undo incorrect port placement and start over:  
# remove_terminals [get_terminals -of [get_ports]] 
# remove_pin_constraints *
# remove_bundles *

###############################
## Place
###############################
set_app_options -name place.coarse.continue_on_missing_scandef -value true
set_app_options -name place.coarse.max_density -value 0.5
# Timing driven placement fails due to missing parasitics data
create_placement
legalize_placement

###############################
## Route
###############################
route_auto
# to undo route: remove_routes -global -detail -user

# Check for shorts/opens
check_lvs -max 999
remove_cell [get_cells sram_senseamp]
## Export GDS (geometric shapes only) and DEF (ports with connectivity info)
write_gds -merge_files /package/eda/cells/OSU/v2.7/cadence/lib/source/gds2/osu018_stdcells.gds2 \
    -flat_vias -layer_map /home/ecegrid/a/ece559/icc2_layer_map "[get_attr [current_design] name].merge.gds"
write_def -objects [get_ports] "[get_attr [current_design] name].ports.def"


# Save and exit when done
save_block
save_lib
exit
