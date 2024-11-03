class test extends uvm_test;
  `uvm_component_utils(test)

  env envh;
  env_config e_cfg;

  bit has_scoreboard = 1;
  bit has_virtual_sequencer = 1;
  int has_master_agent_top = 1;
  int has_slave_agent_top = 1;
  
  int no_of_master_agents = 1;
  int no_of_slave_agents = 1;
  int ctrl;		
  
  master_agent_config m_cfg[];
  slave_agent_config  s_cfg[];

  extern function new(string name = "test", uvm_component parent);
  extern function void config_spi();
  extern function void build_phase(uvm_phase phase);
  //extern function void connect_phase(uvm_phase phase);
  extern function void end_of_elaboration_phase(uvm_phase phase);

endclass

  function test :: new(string name = "test", uvm_component parent);
	super.new(name,parent);
  endfunction

  function void test :: config_spi();
	
	if(has_master_agent_top)
	  begin
		m_cfg = new[no_of_master_agents];

		foreach(m_cfg[i])
		  begin
			m_cfg[i] = master_agent_config :: type_id :: create($sformatf("m_cfg[%0d]",i));
			
			m_cfg[i].is_active = UVM_ACTIVE;

			if(!uvm_config_db #(virtual wishbone_if) :: get(this,"",$sformatf("wishbone_if_%0d",i),m_cfg[i].vif))
				`uvm_fatal("FATAL","not getting in test")

			e_cfg.m_cfg[i] = m_cfg[i];
		  end
	  end

	if(has_slave_agent_top)
	  begin
		s_cfg = new[no_of_slave_agents];

		foreach(s_cfg[i])
		  begin
			s_cfg[i] = slave_agent_config :: type_id :: create($sformatf("s_cfg[%0d]",i));
			
			s_cfg[i].is_active = UVM_ACTIVE;

			if(!uvm_config_db #(virtual slave_if) :: get(this,"",$sformatf("slave_if_%0d",i),s_cfg[i].vif))
				`uvm_fatal("FATAL","not getting in test")

			e_cfg.s_cfg[i] = s_cfg[i];
		  end
	  end

	e_cfg.no_of_master_agents  = no_of_master_agents;
	e_cfg.no_of_slave_agents   = no_of_slave_agents;
	e_cfg.has_master_agent_top = has_master_agent_top;
	e_cfg.has_slave_agent_top  = has_slave_agent_top;
	e_cfg.has_scoreboard 	   = has_scoreboard;
	e_cfg.has_virtual_sequencer = has_virtual_sequencer;
  endfunction


  function void test :: build_phase(uvm_phase phase);
	e_cfg = env_config :: type_id :: create("e_cfg");

	if(has_master_agent_top)
		e_cfg.m_cfg = new[no_of_master_agents];

	if(has_slave_agent_top)
		e_cfg.s_cfg = new[no_of_slave_agents];

	config_spi();

	uvm_config_db #(env_config) :: set(this,"*","env_config",e_cfg);

	super.build_phase(phase);

	envh = env :: type_id :: create("envh",this);

  endfunction

  function void test :: end_of_elaboration_phase(uvm_phase phase);
	uvm_top.print_topology();
  endfunction

//charlen 8-bits
class test1 extends test;

  `uvm_component_utils(test1)

  vseq1 seqh;

  extern function new(string name = "test1", uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);

endclass

  function test1 :: new(string name = "test1", uvm_component parent);
	super.new(name,parent);
  endfunction
 
  function void test1 :: build_phase(uvm_phase phase);
	super.build_phase(phase);

	ctrl[31:14] = 0; //RESERVED
	ctrl[13] = 1;	//ASS
	ctrl[12]=1;	//IE
	ctrl[11]=1;	//LSB
	ctrl[10]=0;	//TX_NEG
	ctrl[9]=1;	//RX_NEG
	ctrl[8]=1;	//GO_BUSY
	ctrl[7]=0;	//RESERVED
	ctrl[6:0]=10;	//CHAR_LEN

	uvm_config_db#(int)::set(this,"*","int",ctrl);

  endfunction

  task test1 :: run_phase(uvm_phase phase);

		phase.raise_objection(this);
		seqh = vseq1 :: type_id :: create("seqh");
	$display("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&");
		seqh.start(envh.v_seqrh);
		phase.drop_objection(this);
  endtask

//charlen 32-bits
class test2 extends test;

  `uvm_component_utils(test2)

  vseq1 seqh;

  extern function new(string name = "test2", uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);

endclass

  function test2 :: new(string name = "test2", uvm_component parent);
	super.new(name,parent);
  endfunction
 
  function void test2 :: build_phase(uvm_phase phase);
	super.build_phase(phase);

	ctrl[31:14] = 0; //RESERVED
	ctrl[13] = 1;	//ASS
	ctrl[12]=1;	//IE
	ctrl[11]=1;	//LSB
	ctrl[10]=0;	//TX_NEG
	ctrl[9]=1;	//RX_NEG
	ctrl[8]=1;	//GO_BUSY
	ctrl[7]=0;	//RESERVED
	ctrl[6:0]=32;	//CHAR_LEN

	uvm_config_db#(int)::set(this,"*","int",ctrl);

  endfunction

  task test2 :: run_phase(uvm_phase phase);

		phase.raise_objection(this);
		seqh = vseq1 :: type_id :: create("seqh");
	$display("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&");
		seqh.start(envh.v_seqrh);
		phase.drop_objection(this);
  endtask

//charlen 127-bits
class test3 extends test;

  `uvm_component_utils(test3)

  vseq1 seqh;

  extern function new(string name = "test3", uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);

endclass

  function test3 :: new(string name = "test3", uvm_component parent);
	super.new(name,parent);
  endfunction
 
  function void test3 :: build_phase(uvm_phase phase);
	super.build_phase(phase);

	ctrl[31:14] = 0; //RESERVED
	ctrl[13] = 1;	//ASS
	ctrl[12]=1;	//IE
	ctrl[11]=0;	//MSB
	ctrl[10]=1;	//TX_NEG
	ctrl[9]=0;	//RX_NEG
	ctrl[8]=1;	//GO_BUSY
	ctrl[7]=0;	//RESERVED
	ctrl[6:0]=127;	//CHAR_LEN

	uvm_config_db#(int)::set(this,"*","int",ctrl);

  endfunction

  task test3 :: run_phase(uvm_phase phase);

		phase.raise_objection(this);
		seqh = vseq1 :: type_id :: create("seqh");
	$display("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&");
		seqh.start(envh.v_seqrh);
		phase.drop_objection(this);
  endtask
