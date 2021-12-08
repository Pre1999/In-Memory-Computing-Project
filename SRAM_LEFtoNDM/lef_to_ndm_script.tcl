create_workspace sram_senseamp_ndm -flow normal -technology /package/eda/cells/OSU/v2.7/synopsys/flow/tsmc018/tech.tf
read_lef /home/ecegrid/a/559mg16/In-Memory-Computing-Project_1204/In-Memory-Computing-Project/sram_sensamp.lef
set lib.workspace.remove_frame_bus_properties true
check_workspace
commit_workspace -output sram_senseamp_ndm -force
