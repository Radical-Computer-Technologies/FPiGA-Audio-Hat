# FPiGA Gowin HDL Layer

This directory contains source-controlled Gowin wrappers required by the
FPiGA Audio HAT top level.

The original HDL referenced IDE-generated blocks named `fpiga_clks`,
`WaveTableBram`, and `AUD_DSP_MULT`, but those generated source files were
not present in the repository. These wrappers preserve the expected entity
names while instantiating Gowin GW5A primitives explicitly:

- `fpiga_clks.vhd`: GW5A PLLA wrapper for 12.288786 MHz MCLK and 100 MHz system clock from the 50 MHz board oscillator.
- `wavetable_bram_gw5a.vhd`: GW5A `SP` BSRAM wrapper for the 4096 x 24 wavetable.
- `aud_dsp_mult_gw5a.vhd`: GW5A DSP multiplier wrapper for signed 24 x 24 products.

Build from `hw_rev1_0/source/hdl`:

```sh
./build_gowin.sh
```

Useful overrides:

```sh
FPIGA_GOWIN_PART=GW5A-LV25MG121NC1/I0 ./build_gowin.sh
FPIGA_GOWIN_DEVICE_VERSION=A ./build_gowin.sh
FPIGA_GOWIN_BUILD_DIR=/tmp/fpiga_gowin ./build_gowin.sh
GOWIN_HOME=/home/jvincent/gowin ./build_gowin.sh
```

The script runs `gw_sh` headlessly with `QT_QPA_PLATFORM=offscreen`, requires a
non-empty `.fs` bitstream, and scans synthesis/PnR logs for error or failure
text. It intentionally does not force `QT_QPA_PLATFORM_PLUGIN_PATH` because the
headless shell works more reliably with Gowin's bundled Qt search paths. Gowin
can report success too optimistically, so artifact and log checks are part of
the build contract.

The board constraint file remains `i2c_25k.cst` from the repository. The
`CLK_50M` pin is constrained to `E2`, which is a dual-purpose `CPU/SSPI` pin on
the GW5A MBGA121N package. The generated project therefore sets
`-use_sspi_as_gpio 1` and `-use_cpu_as_gpio 1` before place-and-route.
