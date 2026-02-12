open_hw_manager
connect_hw_server -allow_non_jtag
open_hw_target
set device [lindex [get_hw_devices xc7a35t_0] 0]
set scriptdir [file dirname [info script]]
current_hw_device $device
refresh_hw_device -update_hw_probes false
if {[file exists $scriptdir/design_1_wrapper.ltx]} {
    set_property PROBES.FILE $scriptdir/design_1_wrapper.ltx $device
} else {
    puts "Couldn't find design_1_wrapper.ltx, not using it for programming"
}
set_property FULL_PROBES.FILE {} $device
set_property PROGRAM.FILE $scriptdir/top_out.bit $device
program_hw_devices $device
refresh_hw_device $device
