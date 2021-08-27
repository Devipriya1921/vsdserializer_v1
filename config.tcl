# User config
set ::env(DESIGN_NAME) vsdserializer_v1

# Change if needed
set ::env(VERILOG_FILES) [glob $::env(DESIGN_DIR)/src/*.v]

# Fill this
set ::env(CLOCK_PERIOD) 10
set ::env(CLOCK_PORT) "clk"

set ::env(FP_CORE_UTIL) 25
set ::env(PL_TARGET_DENSITY) 1

set filename $::env(DESIGN_DIR)/$::env(PDK)_$::env(STD_CELL_LIBRARY)_config.tcl
if { [file exists $filename] == 1} {
	source $filename
}

