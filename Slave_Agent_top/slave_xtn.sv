class slave_xtn extends uvm_sequence_item;
  `uvm_object_utils(slave_xtn)

  rand bit [127:0]miso_pad_i;
  bit [127:0]mosi_pad_o;

  extern function new(string name = "slave_xtn");
  extern function void do_print(uvm_printer printer);

endclass

  function slave_xtn :: new(string name = "slave_xtn");
	super.new(name);
  endfunction 

  function void slave_xtn :: do_print(uvm_printer printer);
	super.do_print(printer);
	printer.print_field("mosi_pad_o",this.mosi_pad_o,128,UVM_DEC);
	printer.print_field("miso_pad_i",this.miso_pad_i,128,UVM_BIN);	
  endfunction
