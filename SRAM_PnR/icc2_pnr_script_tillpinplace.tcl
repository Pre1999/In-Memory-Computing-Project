# Initialize the lib (it would be worthwhile to open tech.tf in gvim and check what it contains)
create_lib -technology /package/eda/cells/OSU/v2.7/synopsys/flow/tsmc018/tech.tf \
    -ref_libs /home/ecegrid/a/ece559/tsmc018_stdcell.ndm my_sram_decoder.nlib

# Read in netlist (This automatically creates a new block in the lib)
read_verilog /home/ecegrid/a/559mg16/SRAM_synth/decoder.netlist.v

# Initial Save
save_block
save_lib

# Read in timing/electrical constraints
source ./decoder.sdc

# Create the frame for the decoder; Dimensions will automatically be snapped to a multiple of std_cell tile (0.8 1)
 initialize_floorplan -shape R -side_length {120 500} -core_offset {0.8 1}
# Added by Raghu
##initialize_floorplan -shape R -side_length {127.25 471.5} -core_offset {0.8 1}

# You can open the GUI to see the floorplan at this stage
start_gui

# Create PG mesh
source ./create_pg.tcl


# Configure ports
set_individual_pin_constraint -length 0.8 -width 0.48 -sides 1 \
    -ports [get_ports -f direction==in] -pin_spacing 4 -allowed_layers {metal3}
place_pins -ports [get_ports -filter direction==in]

