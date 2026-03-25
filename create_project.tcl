# create_project.tcl
#
# Recreate the FPGA Mario VGA project from scratch.
# Run from the repo root:
#   vivado -mode batch -source create_project.tcl

set script_dir [file dirname [file normalize [info script]]]

set proj_name "fpga_mario_vga"
set proj_dir  "${script_dir}/vivado_build"
set part      "xc7a100tcsg324-1"

create_project ${proj_name} ${proj_dir} -part ${part} -force

add_files -norecurse [glob ${script_dir}/src/*.v]
set_property file_type {Verilog} [get_files [glob ${script_dir}/src/*.v]]

add_files -fileset constrs_1 -norecurse ${script_dir}/constraints/nexys_a7_100t.xdc

set_property top top_mario_game [current_fileset]

update_compile_order -fileset sources_1

puts ""
puts "========================================================"
puts " Project created: ${proj_dir}/${proj_name}.xpr"
puts " Top module: top_mario_game"
puts " Board target: Nexys A7-100T / Nexys4 DDR"
puts "========================================================"
puts ""
puts "Next steps:"
puts "  1. Open the project:"
puts "       vivado ${proj_dir}/${proj_name}.xpr"
puts ""
puts "  2. Run synthesis, implementation, and bitstream generation."
puts "  3. Program the board over USB in Vivado Hardware Manager."
puts ""

