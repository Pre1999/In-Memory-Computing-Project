create_net -power VDD
create_net -ground GND
connect_pg_net -automatic

create_pg_mesh_pattern mesh_pattern \
   -layers {{{vertical_layer:   metal6} {width: 3.6} {pitch: 36} {offset: 18}} \
            {{horizontal_layer: metal5} {width: 1.8} {pitch: 18} {offset: 9}} \
            {{vertical_layer:   metal4} {width: 1.8} {pitch: 18} {offset: 9}}}

set_pg_strategy M6M5M4_mesh -core -pattern {{name: mesh_pattern} {nets: VDD GND}}

create_pg_std_cell_conn_pattern rail_pattern -layers metal1

set_pg_strategy metal1_rails -core -pattern {{name: rail_pattern} {nets: VDD GND}}

set_pg_via_master_rule VIA_6x1 -via_array_dimension {6 1}

set_pg_strategy_via_rule via_rule  -via_rule {\
    {{{strategies: M6M5M4_mesh} {layers: metal4}} \
     {{strategies: metal1_rails} {layers: metal1}} \
     {via_master: VIA_6x1}} \
       {{intersection: undefined} {via_master: NIL}} \
}

compile_pg -strategies {M6M5M4_mesh metal1_rails} -via_rule {via_rule}

set m4_shapes [get_shapes -filter "layer_name == metal4 && (net_type == power || net_type == ground)"]
set m1_shapes [get_shapes -filter "layer_name == metal1 && (net_type == power || net_type == ground)"]

set_pg_via_master_rule via1_staple \
  -contact_code viagen21 \
  -via_array_dimension {2 1} \
  -allow_multiple {0.5 0} \
  -snap_reference_point {0 0}

set_pg_via_master_rule via2_staple \
  -contact_code viagen32 \
  -via_array_dimension {2 1} \
  -allow_multiple {0.5 0} \
  -snap_reference_point {0 0}

set_pg_via_master_rule via3_staple \
  -contact_code viagen43 \
  -via_array_dimension {4 1} \
  -allow_multiple {0.5 0} \
  -snap_reference_point {0 0}

create_pg_stapling_vias -nets {VDD GND} \
  -from_layer metal4 -to_layer metal1 \
  -from_shapes $m4_shapes -to_shapes $m1_shapes \
  -via_masters {via1_staple via2_staple via3_staple}


