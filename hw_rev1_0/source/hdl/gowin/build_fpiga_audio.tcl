set script_dir [file dirname [file normalize [info script]]]
set hdl_dir [file normalize [file join $script_dir ..]]
set project_name "fpiga_audio"

if {[info exists ::env(FPIGA_GOWIN_BUILD_DIR)]} {
    set build_dir [file normalize $::env(FPIGA_GOWIN_BUILD_DIR)]
} else {
    set build_dir [file normalize [file join $hdl_dir build gowin]]
}

if {[info exists ::env(FPIGA_GOWIN_PART)]} {
    set part_number $::env(FPIGA_GOWIN_PART)
} else {
    set part_number "GW5A-LV25MG121NC1/I0"
}

if {[info exists ::env(FPIGA_GOWIN_DEVICE_VERSION)]} {
    set device_version $::env(FPIGA_GOWIN_DEVICE_VERSION)
} else {
    set device_version "A"
}

file mkdir $build_dir
create_project -name $project_name -dir $build_dir -pn $part_number -device_version $device_version -force

set source_files [list \
    [file join $hdl_dir hdl-lib DSP FPiGA_AudioDSP fpiga_audio_package.vhd] \
    [file join $hdl_dir hdl-lib Comms FPiGA_I2CSlv i2cslv.vhd] \
    [file join $hdl_dir hdl-lib Comms FPiGA_I2CSlv fpigaI2cReg.vhd] \
    [file join $hdl_dir hdl-lib Comms FPiGA_I2CSlv FPiGA-I2C-Core.vhd] \
    [file join $hdl_dir hdl-lib Audio FPiGA_I2SCore fpiga_i2s.vhd] \
    [file join $hdl_dir gowin fpiga_clks.vhd] \
    [file join $hdl_dir gowin wavetable_bram_gw5a.vhd] \
    [file join $hdl_dir gowin aud_dsp_mult_gw5a.vhd] \
    [file join $hdl_dir hdl-lib DSP FPiGA_Wavetable fpiga_wavetable.vhd] \
    [file join $hdl_dir hdl-lib DSP FPiGA_AudioDSP fpiga_audiodsp.vhd] \
    [file join $hdl_dir audio_dsp_top.vhd] \
]

foreach source_file $source_files {
    add_file -type vhdl $source_file
}

add_file -type cst [file join $hdl_dir i2c_25k.cst]
add_file -type sdc [file join $hdl_dir clks.sdc]

set_option -top_module FPiGA_Audio
set_option -cst_warn_to_error 1
set_option -use_sspi_as_gpio 1
set_option -use_cpu_as_gpio 1
run all
run close
