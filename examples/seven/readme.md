## GM-STUDY-E1 Example "seven"

This Verilog example program validates the function of the six 7-segment display modules. This program works without a clock. Turning a slide switch "on" enables the respective board LED0..9. For switches SW0..5, turning it on also lights up the respective 7-segment module with its number. Turning slide switch SW0..5 off will light up all LED segments of the corresponding 7-segment module.

### Usage

```
fm@nuc7vm2204:~/fpga/hardware/gm-study-e1/examples/seven$ make all
/home/fm/cc-toolchain-linux/bin/yosys/yosys -ql log/synth.log -p 'read -sv src/hexdigit.v src/seven.v; synth_gatemate -top seven -vlog net/seven_synth.v'
/home/fm/cc-toolchain-linux/bin/p_r/p_r -i net/seven_synth.v -o seven -ccf ../gm-study-e1.ccf > log/impl.log
/usr/local/bin/openFPGALoader  -b gatemate_evb_jtag seven_00.cfg
Jtag frequency : requested 6.00MHz   -> real 6.00MHz  
Load SRAM via JTAG: [==================================================] 100.00%
Done
Wait for CFG_DONE DONE
```
