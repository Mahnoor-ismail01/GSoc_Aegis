

import uvm_pkg::*;

class fifo_xtn extends uvm_sequence_item;
  `uvm_object_utils(fifo_xtn)

  // WISHBONE interface signals (8-bit mode)


  // Dynamic FIFOs



  // Internal Registers
  bit [7:0] IER;   // Interrupt Enable Register
  bit [7:0] IIR;   // Interrupt Identification Register
  bit [7:0] FCR;   // FIFO Control Register
  bit [7:0] LCR;   // Line Control Register
  bit [7:0] LSR;   // Line Status Register
  bit [7:0] MCR;   // Modem Control Register
  bit [7:0] MSR;   // Modem Status Register
  bit [7:0] DL1;   // Divisor Latch Byte 1 (MSB)
  bit [7:0] DL2;   // Divisor Latch Byte 2 (LSB)

  function new(string name = "fifo_xtn");
    super.new(name);
  endfunction

  virtual function void do_copy(uvm_object rhs);
    fifo_xtn tmp;
    super.do_copy(rhs);
    if (!$cast(tmp, rhs)) `uvm_fatal("COPY", "Cast failed in do_copy")

    this.IER = tmp.IER;
    this.IIR = tmp.IIR;
    this.FCR = tmp.FCR;
    this.LCR = tmp.LCR;
    this.LSR = tmp.LSR;
    this.MCR = tmp.MCR;
    this.MSR = tmp.MSR;
    this.DL1 = tmp.DL1;
    this.DL2 = tmp.DL2;
  endfunction

  virtual function string convert2string();
    string s = $sformatf("wb_dat_i=%0h wb_addr_i=%0h wb_we_i=%0b wb_stb_i=%0b wb_cyc_i=%0b", 
                         wb_dat_i, wb_addr_i, wb_we_i, wb_stb_i, wb_cyc_i);

    s = {s, $sformatf(" IER=%0h IIR=%0h FCR=%0h LCR=%0h LSR=%0h MCR=%0h MSR=%0h DL1=%0h DL2=%0h", 
                      IER, IIR, FCR, LCR, LSR, MCR, MSR, DL1, DL2)};
    return s;
  endfunction
endclass