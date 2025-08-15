class adder_uvm_test_transaction extends uvm_sequence_item;
    `uvm_object_utils(adder_uvm_test_transaction)

    
    
    rand logic rstn;
    
    
    
    rand logic [7:0] a;
    
    
    
    rand logic [7:0] b;
    
    
    
    logic [7:0] sum;
    
    
    
    logic carry;
    
    

    function new(string name = "adder_uvm_test_transaction");
        super.new(name);
    endfunction

    virtual function void do_copy(uvm_object rhs);
        adder_uvm_test_transaction rhs_;
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
endclass