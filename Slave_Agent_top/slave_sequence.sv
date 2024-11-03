class slave_sequence extends uvm_sequence#(slave_xtn);
  `uvm_object_utils(slave_sequence)

  extern function new(string name = "slave_sequence");

endclass

  function slave_sequence :: new(string name = "slave_sequence");
	super.new(name);
  endfunction

class slave_seq extends slave_sequence;
  `uvm_object_utils(slave_seq)

  extern function new(string name = "slave_seq");
  extern task body();

endclass

  function slave_seq :: new(string name = "slave_seq");
	super.new(name);
  endfunction

  task slave_seq :: body();
//	super.body();
	req = slave_xtn :: type_id :: create("req");
	start_item(req);
//	assert(req.randomize());
	assert(req.randomize() with {miso_pad_i == 1000;})
	finish_item(req);
  endtask
