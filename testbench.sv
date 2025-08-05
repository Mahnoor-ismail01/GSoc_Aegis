// Dummy Adder DUT
module adder (
  input  logic rstn,
  input  logic [7:0] a,
  input  logic [7:0] b,
  output logic [7:0] sum,
  output logic carry
);
  assign {carry, sum} = rstn ? (a + b) : 0;
endmodule

// Interface for DUT and testbench components
interface adder_if();
  logic rstn;
  logic [7:0] a, b, sum;
  logic carry;
endinterface

interface clk_if();
  logic tb_clk;
  initial begin
    tb_clk = 0;
    forever #10 tb_clk = ~tb_clk;
  end
endinterface

// Packet class
class Packet;
  rand bit rstn;
  rand bit[7:0] a;
  rand bit[7:0] b;
  bit [7:0] sum;
  bit carry;

  function void print(string tag="");
    $display ("T=%0t %s a=0x%0h b=0x%0h sum=0x%0h carry=0x%0h", $time, tag, a, b, sum, carry);
  endfunction

  function void copy(Packet tmp);
    this.a = tmp.a;
    this.b = tmp.b;
    this.rstn = tmp.rstn;
    this.sum = tmp.sum;
    this.carry = tmp.carry;
  endfunction
endclass

// Generator
class generator;
  int loop = 10;
  event drv_done;
  mailbox drv_mbx;

  function new(string name = "gen");
  endfunction

  task run();
    for (int i = 0; i < loop; i++) begin
      Packet item = new;
      assert(item.randomize());
      $display ("T=%0t [Generator] Loop:%0d/%0d", $time, i+1, loop);
      drv_mbx.put(item);
      @(drv_done);
    end
  endtask
endclass

// Driver
class driver;
  virtual adder_if m_adder_vif;
  virtual clk_if m_clk_vif;
  event drv_done;
  mailbox drv_mbx;

  function new(string name = "drv");
  endfunction

  task run();
    $display ("T=%0t [Driver] starting ...", $time);
    forever begin
      Packet item;
      drv_mbx.get(item);
      @(posedge m_clk_vif.tb_clk);
      item.print("Driver");
      m_adder_vif.rstn <= item.rstn;
      m_adder_vif.a    <= item.a;
      m_adder_vif.b    <= item.b;
      ->drv_done;
    end
  endtask
endclass

// Monitor
class monitor;
  virtual adder_if m_adder_vif;
  virtual clk_if m_clk_vif;
  mailbox scb_mbx;

  function new(string name = "mon");
  endfunction

  task run();
    $display ("T=%0t [Monitor] starting ...", $time);
    forever begin
      Packet m_pkt = new();
      @(posedge m_clk_vif.tb_clk);
      #1;
      m_pkt.a     = m_adder_vif.a;
      m_pkt.b     = m_adder_vif.b;
      m_pkt.rstn  = m_adder_vif.rstn;
      m_pkt.sum   = m_adder_vif.sum;
      m_pkt.carry = m_adder_vif.carry;
      m_pkt.print("Monitor");
      scb_mbx.put(m_pkt);
    end
  endtask
endclass

// Scoreboard
class scoreboard;
  mailbox scb_mbx;

  function new(string name = "sb");
  endfunction

  task run();
    forever begin
      Packet item, ref_item;
      scb_mbx.get(item);
      ref_item = new();
      ref_item.copy(item);
      if (ref_item.rstn)
        {ref_item.carry, ref_item.sum} = ref_item.a + ref_item.b;
      else
        {ref_item.carry, ref_item.sum} = 0;

      if (ref_item.carry != item.carry)
        $display("[%0t] Scoreboard Error! Carry mismatch ref=0x%0h item=0x%0h", $time, ref_item.carry, item.carry);
      else
        $display("[%0t] Scoreboard Pass! Carry match", $time);

      if (ref_item.sum != item.sum)
        $display("[%0t] Scoreboard Error! Sum mismatch ref=0x%0h item=0x%0h", $time, ref_item.sum, item.sum);
      else
        $display("[%0t] Scoreboard Pass! Sum match", $time);
    end
  endtask
endclass

// Environment
class env;
  generator g0;
  driver d0;
  monitor m0;
  scoreboard s0;

  mailbox scb_mbx;
  mailbox drv_mbx;
  event drv_done;

  virtual adder_if m_adder_vif;
  virtual clk_if m_clk_vif;

  function new(string name = "env");
    g0 = new();
    d0 = new();
    m0 = new();
    s0 = new();
    drv_mbx = new();
    scb_mbx = new();
  endfunction

  task run();
    d0.m_adder_vif = m_adder_vif;
    d0.m_clk_vif = m_clk_vif;
    m0.m_adder_vif = m_adder_vif;
    m0.m_clk_vif = m_clk_vif;

    d0.drv_mbx = drv_mbx;
    g0.drv_mbx = drv_mbx;

    m0.scb_mbx = scb_mbx;
    s0.scb_mbx = scb_mbx;

    d0.drv_done = drv_done;
    g0.drv_done = drv_done;

    fork
      s0.run();
      d0.run();
      m0.run();
      g0.run();
    join_any
    disable fork;
  endtask
endclass

// Test
class test;
  env e0;
  function new(string name = "test");
    e0 = new();
  endfunction

  task run();
    e0.run();
  endtask
endclass

// Testbench top
module tb;
  clk_if m_clk_if();
  adder_if m_adder_if();
  adder u0 (
    .rstn(m_adder_if.rstn),
    .a(m_adder_if.a),
    .b(m_adder_if.b),
    .sum(m_adder_if.sum),
    .carry(m_adder_if.carry)
  );

  initial begin
    test t0;
    t0 = new();
    t0.e0.m_adder_vif = m_adder_if;
    t0.e0.m_clk_vif = m_clk_if;
    t0.run();
    #100 $finish;
  end

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, tb);
  end
endmodule
