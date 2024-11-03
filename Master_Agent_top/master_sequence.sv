class master_base_sequence extends uvm_sequence#(master_xtn);
  `uvm_object_utils(master_base_sequence)

  int ctrl;
  extern function new(string name = "master_base_sequence");
 
endclass

  function master_base_sequence :: new(string name = "master_base_sequence");
	super.new(name);
  endfunction

class master_seq extends master_base_sequence;
  `uvm_object_utils(master_seq)

  extern function new(string name = "master_seq");
  extern task body();

endclass

  function master_seq :: new(string name = "master_seq");
	super.new(name);
  endfunction

  task master_seq :: body();
	int ctrl;
//	super.body();
	if(!uvm_config_db #(int) :: get(null,get_full_name(),"int",ctrl))
		`uvm_fatal("FATAL","not getting in master_sequence")

	begin 
//TX0 Register Sequence
		req = master_xtn :: type_id :: create("req");
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 'h00; wb_we_i == 1; wb_dat_i == 1000;})
		finish_item(req);

//TX1 Register Sequence
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 'h04; wb_we_i == 1; wb_dat_i == 2000;})
		finish_item(req);

//TX2 Register Sequence
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 'h08; wb_we_i == 1; wb_dat_i == 3000;})
		finish_item(req);

//TX3 Register Sequence
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 'h0c; wb_we_i == 1; wb_dat_i == 4000;})
		finish_item(req);

//RX0 Register Sequence
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 'h00; wb_we_i == 0;})
		finish_item(req);

//RX1 Register Sequence
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 'h04; wb_we_i == 0;})
		finish_item(req);

//RX2 Register Sequence
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 'h08; wb_we_i == 0;})
		finish_item(req);

//RX3 Register Sequence
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 'h0c; wb_we_i == 0;})
		finish_item(req);

//DIVIDER Register Sequence
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 'h14; wb_we_i == 1; wb_dat_i[31:16] == 16'b0; wb_dat_i[15:0] == 16'b10;})
		finish_item(req);

//SS Register Sequence
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 'h18; wb_we_i == 1; wb_dat_i[31:8] == 24'b0; wb_dat_i[7:0] == 8'b0;})
		finish_item(req);

//CTRL Register Sequence
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 'h10; wb_we_i == 1; wb_dat_i == ctrl;})
		finish_item(req);

	end
  endtask
