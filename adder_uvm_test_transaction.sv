class adder_uvm_test extends uvm_sequence_item;
    `uvm_object_utils(adder_uvm_test)

    // --> Members
    
    
    rand logic rstn;
    
    
    
    rand logic [7:0] a;
    
    
    
    rand logic [7:0] b;
    
    
    
    logic [7:0] sum;
    
    
    
    logic carry;
    
    

    // --> Internal Registers (Dynamically Generated)
    

    // --> Constraints
    
    
    
   
    
    
   
    
    
   
    
    
    function new(string name = "adder_uvm_test");
        super.new(name);
    endfunction

    virtual function void do_copy(uvm_object rhs);
        adder_uvm_test rhs_;
        if (!$cast(rhs_, rhs)) begin
            `uvm_fatal("do_copy", "Cast failed")
        end
        super.do_copy(rhs);
        
        rstn = rhs_.rstn;
        
        a = rhs_.a;
        
        b = rhs_.b;
        
        sum = rhs_.sum;
        
        carry = rhs_.carry;
        
        
    endfunction

    function void do_print(uvm_printer printer);
        super.do_print(printer);
        
        
        printer.print_field("rstn", this.rstn, logic, UVM_DEC);
        
        
        printer.print_field("a", this.a, 7-0, UVM_DEC);
        
        
        printer.print_field("b", this.b, 7-0, UVM_DEC);
        
        
        printer.print_field("sum", this.sum, 7-0, UVM_DEC);
        
        
        printer.print_field("carry", this.carry, logic, UVM_DEC);
        
        
    endfunction
endclass