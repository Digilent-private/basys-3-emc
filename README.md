# Basys 3 EMC Test

This project consists of several components:

* hw: Hardware design follows the standard digilent-vivado-scripts repository structure and implements a microblaze processor and several peripherals.
* sw: Software application follows the standard digilent-vitis-scripts repository structure and handles coordination between a USBUART command line interface and software-accessable peripherals.
* host:
  * `py host/gui.py` presents a GUI for configuration, programs the board via TCL scripts, and logs test status to file. 
* scripts: Additional project management scripts:
  * `sh scripts/run_updatemem.sh` combines sw (elf) and hw (mmi, bitstream) into a single bit file. Note: error on missing .ltx file is expected when no ILA is present in hw.

In addition to normal checkout procedures, rebuild the project while working around some vitis bugs, use:

- Use normal Vivado checkout and rebuild process, export hw to handoff folder and sw/src/platform
- Launch Vitis
- Terminal -> New Terminal
- `vitis -s .../basys-3-emc/sw/scripts/checkout.py`
- Then Set Workspace to ws
- Rebuild if needed (in case of clang issues)
- Switch to VS code or bash and run `sh .../basys-3-emc/scripts/run_updatemem.sh`
- Check that top_out.bit has successfully been generated
- Run the project by running `py .../basys-3-emc/host/gui.py`.

This project exercises the various peripherals of the Basys 3:

* Flash: programmed at the start of the test with a known set of random data, then read back via AXI QSPI on a command sent from host to sw.
* VGA: port generates a test pattern on a connected monitor.
* USBUART: in addition to coordinating other test functions, once a second, host sends 100 random bytes to sw via UART which are then echoed back and verified
* Pmod ports:
  * In immunity mode, counting patterns are generated on a loopback and validated.
  * In emissions mode, counting patterns are pushed out across all pins on each port.
* XADC: used to monitor supply status and die temperature of the FPGA.
* Seven segment display: counts at 10 Hz.
* BRAM: hw writes, reads, and validates a known random set of data once per second.
* PS/2 mouse: polled for ID to ensure connection is maintained.
* LEDs: used to indicate test status:
  * LED0 indicates an error condition has previously been detected on any other line.
  * LED1 indicates a BRAM readback error.
  * LED2 indicates a Flash readback error.
  * LED3 indicates a mouse disconnect.
  * LED4 indicates an unrecognized command received by the processor over UART.
  * LED12 indicates a mismatch in DIO readback on port JA.
  * LED13 indicates a mismatch in DIO readback on port JB.
  * LED14 indicates a mismatch in DIO readback on port JC.
  * LED15 indicates a mismatch in DIO readback on port JXADC.

Note: in general, random data handled by the FPGA is generated and validated using LFSRs with seeds passed from the host.