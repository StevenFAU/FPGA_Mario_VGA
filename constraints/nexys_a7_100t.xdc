## Nexys A7-100T / Nexys4 DDR constraints
## Adapted from the source repo and Digilent master XDC naming.

## 100 MHz board clock
set_property -dict {PACKAGE_PIN E3 IOSTANDARD LVCMOS33} [get_ports clk_100mhz]
create_clock -period 10.000 -name sys_clk_pin -waveform {0.000 5.000} [get_ports clk_100mhz]

## Buttons
set_property -dict {PACKAGE_PIN N17 IOSTANDARD LVCMOS33} [get_ports btn_center]
set_property -dict {PACKAGE_PIN P17 IOSTANDARD LVCMOS33} [get_ports btn_left]
set_property -dict {PACKAGE_PIN M17 IOSTANDARD LVCMOS33} [get_ports btn_right]
set_property -dict {PACKAGE_PIN M18 IOSTANDARD LVCMOS33} [get_ports btn_up]

## VGA red
set_property -dict {PACKAGE_PIN A3 IOSTANDARD LVCMOS33} [get_ports {vga_r[0]}]
set_property -dict {PACKAGE_PIN B4 IOSTANDARD LVCMOS33} [get_ports {vga_r[1]}]
set_property -dict {PACKAGE_PIN C5 IOSTANDARD LVCMOS33} [get_ports {vga_r[2]}]
set_property -dict {PACKAGE_PIN A4 IOSTANDARD LVCMOS33} [get_ports {vga_r[3]}]

## VGA green
set_property -dict {PACKAGE_PIN C6 IOSTANDARD LVCMOS33} [get_ports {vga_g[0]}]
set_property -dict {PACKAGE_PIN A5 IOSTANDARD LVCMOS33} [get_ports {vga_g[1]}]
set_property -dict {PACKAGE_PIN B6 IOSTANDARD LVCMOS33} [get_ports {vga_g[2]}]
set_property -dict {PACKAGE_PIN A6 IOSTANDARD LVCMOS33} [get_ports {vga_g[3]}]

## VGA blue
set_property -dict {PACKAGE_PIN B7 IOSTANDARD LVCMOS33} [get_ports {vga_b[0]}]
set_property -dict {PACKAGE_PIN C7 IOSTANDARD LVCMOS33} [get_ports {vga_b[1]}]
set_property -dict {PACKAGE_PIN D7 IOSTANDARD LVCMOS33} [get_ports {vga_b[2]}]
set_property -dict {PACKAGE_PIN D8 IOSTANDARD LVCMOS33} [get_ports {vga_b[3]}]

## VGA sync
set_property -dict {PACKAGE_PIN B11 IOSTANDARD LVCMOS33} [get_ports vga_hsync]
set_property -dict {PACKAGE_PIN B12 IOSTANDARD LVCMOS33} [get_ports vga_vsync]

