class master_xtn extends uvm_sequence_item;
  `uvm_object_utils(master_xtn)

  rand bit wb_we_i;
  rand bit [4:0]wb_adr_i;
  rand bit [31:0]wb_dat_i;
  bit [31:0]wb_dat_o;

  bit wb_err_o;
  bit wb_int_o;

  //Registers
  int TX0,TX1,TX2,TX3;
  int RX0,RX1,RX2,RX3;
  int DIVIDER,SS,CTRL;

  extern function new(string name = "master_xtn");
  extern function void do_print(uvm_printer printer);

endclass

  function master_xtn :: new(string name = "master_xtn");
	super.new(name);
  endfunction 

  function void master_xtn :: do_print(uvm_printer printer);
	super.do_print(printer);
	
	printer.print_field("wb_we_i",this.wb_we_i,1,UVM_DEC);
	printer.print_field("wb_adr_i",this.wb_adr_i,5,UVM_HEX);
	printer.print_field("wb_dat_i",this.wb_dat_i,32,UVM_DEC);
	printer.print_field("wb_dat_o",this.wb_dat_o,32,UVM_DEC);
	
	//Registers
	printer.print_field("TX0",this.TX0,32,UVM_DEC);
	printer.print_field("TX1",this.TX1,32,UVM_DEC);
	printer.print_field("TX2",this.TX2,32,UVM_DEC);
	printer.print_field("TX3",this.TX3,32,UVM_DEC);

	printer.print_field("RX0",this.RX0,32,UVM_DEC);
	printer.print_field("RX1",this.RX1,32,UVM_DEC);
	printer.print_field("RX2",this.RX2,32,UVM_DEC);
	printer.print_field("RX3",this.RX3,32,UVM_DEC);

	printer.print_field("DIVIDER",this.DIVIDER,32,UVM_DEC);
	printer.print_field("SS",this.SS,32,UVM_DEC);
	printer.print_field("CTRL",this.CTRL,32,UVM_DEC);

  endfunction	
