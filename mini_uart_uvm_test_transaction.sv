class mini_uart_uvm_test_transaction extends uvm_sequence_item;
    `uvm_object_utils(mini_uart_uvm_test_transaction)

    
    
    rand logic WB_CLK_I;
    
    
    
    rand logic WB_RST_I;
    
    
    
    rand logic [1:0] WB_ADDR_I;
    
    
    
    rand logic [7:0] WB_DAT_I;
    
    
    
    logic [7:0] WB_DAT_O;
    
    
    
    rand logic WB_WE_I;
    
    
    
    rand logic WB_STB_I;
    
    
    
    logic WB_ACK_O;
    
    
    
    logic IntTx_O;
    
    
    
    logic IntRx_O;
    
    
    
    rand logic BR_CLK_I;
    
    
    
    logic TxD_PAD_O;
    
    
    
    rand logic RxD_PAD_I;
    
    

    function new(string name = "mini_uart_uvm_test_transaction");
        super.new(name);
    endfunction

    virtual function void do_copy(uvm_object rhs);
        mini_uart_uvm_test_transaction rhs_;
        if (!$cast(rhs_, rhs)) begin
            `uvm_fatal("do_copy", "Cast failed")
        end
        super.do_copy(rhs);
        
        WB_CLK_I = rhs_.WB_CLK_I;
        
        WB_RST_I = rhs_.WB_RST_I;
        
        WB_ADDR_I = rhs_.WB_ADDR_I;
        
        WB_DAT_I = rhs_.WB_DAT_I;
        
        WB_DAT_O = rhs_.WB_DAT_O;
        
        WB_WE_I = rhs_.WB_WE_I;
        
        WB_STB_I = rhs_.WB_STB_I;
        
        WB_ACK_O = rhs_.WB_ACK_O;
        
        IntTx_O = rhs_.IntTx_O;
        
        IntRx_O = rhs_.IntRx_O;
        
        BR_CLK_I = rhs_.BR_CLK_I;
        
        TxD_PAD_O = rhs_.TxD_PAD_O;
        
        RxD_PAD_I = rhs_.RxD_PAD_I;
        
    endfunction
endclass