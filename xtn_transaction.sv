class xtn extends uvm_sequence_item;
    `uvm_object_utils(xtn)

    // --> Members
    

    // --> Internal Registers (Dynamically Generated)
    

    // --> Constraints
    
    
    
    function new(string name = "xtn");
        super.new(name);
    endfunction

    virtual function void do_copy(uvm_object rhs);
        xtn rhs_;
        if (!$cast(rhs_, rhs)) begin
            `uvm_fatal("do_copy", "Cast failed")
        end
        super.do_copy(rhs);
        
        
    endfunction

    function void do_print(uvm_printer printer);
        super.do_print(printer);
        
        
    endfunction
endclass