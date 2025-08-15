class uart16550_uvm_test extends uvm_sequence_item;
    `uvm_object_utils(uart16550_uvm_test)

    // --> Members
    
    
    rand logic CLK;
    
    
    
    rand logic [7:0] wb_dat_i;
    
    
    
    rand logic [2:0] wb_addr_i;
    
    
    
    rand logic wb_we_i;
    
    
    
    rand logic wb_stb_i;
    
    
    
    rand logic wb_cyc_i;
    
    
    
    logic wb_ack_o;
    
    

    // --> Internal Registers (Dynamically Generated)
    
    bit [7:0] IER;
    
    bit [7:0] IIR;
    
    bit [7:0] FCR;
    
    bit [7:0] LCR;
    
    bit [7:0] LSR;
    
    bit [7:0] MCR;
    
    bit [7:0] MSR;
    
    bit [7:0] DL;
    
    bit [7:0] DL1;
    
    bit [7:0] DL2;
    
    bit [7:0][$] THR;
    
    bit [7:0][$] RB;
    

    // --> Constraints
    
    
    
   
    
    
   
    
    
   
    
    
   
    
    
   
    
    
   
    
    
    function new(string name = "uart16550_uvm_test");
        super.new(name);
    endfunction

    virtual function void do_copy(uvm_object rhs);
        uart16550_uvm_test rhs_;
        if (!$cast(rhs_, rhs)) begin
            `uvm_fatal("do_copy", "Cast failed")
        end
        super.do_copy(rhs);
        
        CLK = rhs_.CLK;
        
        wb_dat_i = rhs_.wb_dat_i;
        
        wb_addr_i = rhs_.wb_addr_i;
        
        wb_we_i = rhs_.wb_we_i;
        
        wb_stb_i = rhs_.wb_stb_i;
        
        wb_cyc_i = rhs_.wb_cyc_i;
        
        wb_ack_o = rhs_.wb_ack_o;
        
        
        IER = rhs_.IER;
        
        IIR = rhs_.IIR;
        
        FCR = rhs_.FCR;
        
        LCR = rhs_.LCR;
        
        LSR = rhs_.LSR;
        
        MCR = rhs_.MCR;
        
        MSR = rhs_.MSR;
        
        DL = rhs_.DL;
        
        DL1 = rhs_.DL1;
        
        DL2 = rhs_.DL2;
        
        THR = rhs_.THR;
        
        RB = rhs_.RB;
        
    endfunction

    function void do_print(uvm_printer printer);
        super.do_print(printer);
        
        
        printer.print_field("CLK", this.CLK, logic, UVM_DEC);
        
        
        printer.print_field("wb_dat_i", this.wb_dat_i, 7-0, UVM_DEC);
        
        
        printer.print_field("wb_addr_i", this.wb_addr_i, 2-0, UVM_DEC);
        
        
        printer.print_field("wb_we_i", this.wb_we_i, logic, UVM_DEC);
        
        
        printer.print_field("wb_stb_i", this.wb_stb_i, logic, UVM_DEC);
        
        
        printer.print_field("wb_cyc_i", this.wb_cyc_i, logic, UVM_DEC);
        
        
        printer.print_field("wb_ack_o", this.wb_ack_o, logic, UVM_DEC);
        
        
        
        printer.print_field("IER", this.IER, 8, UVM_DEC);
        
        
        
        printer.print_field("IIR", this.IIR, 8, UVM_DEC);
        
        
        
        printer.print_field("FCR", this.FCR, 8, UVM_DEC);
        
        
        
        printer.print_field("LCR", this.LCR, 8, UVM_DEC);
        
        
        
        printer.print_field("LSR", this.LSR, 8, UVM_DEC);
        
        
        
        printer.print_field("MCR", this.MCR, 8, UVM_DEC);
        
        
        
        printer.print_field("MSR", this.MSR, 8, UVM_DEC);
        
        
        
        printer.print_field("DL", this.DL, 8, UVM_DEC);
        
        
        
        printer.print_field("DL1", this.DL1, 8, UVM_DEC);
        
        
        
        printer.print_field("DL2", this.DL2, 8, UVM_DEC);
        
        
        
        foreach(this.THR[i])
            printer.print_field($sformatf("THR[%0d]", i), this.THR[i], 8, UVM_DEC);
        
        
        
        foreach(this.RB[i])
            printer.print_field($sformatf("RB[%0d]", i), this.RB[i], 8, UVM_DEC);
        
        
    endfunction
endclass