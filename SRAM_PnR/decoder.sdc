set outputs [get_ports -filter direction==out]
set inputs [get_ports -filter direction==in]

set_load 10.0 [get_ports ${outputs}]
set_load  1.0 [get_ports ${inputs}]
set_max_delay -to ${outputs} 5

