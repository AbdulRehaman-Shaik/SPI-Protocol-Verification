class env_config extends uvm_object;
  `uvm_object_utils(env_config)

  bit has_scoreboard = 1;
  bit has_virtual_sequencer = 1;
  bit has_master_agent_top = 1;
  bit has_slave_agent_top = 1;
  
  int no_of_master_agents = 1;
  int no_of_slave_agents = 1;

  master_agent_config m_cfg[];
  slave_agent_config  s_cfg[];

  extern function new(string name = "env_config");

endclass

  function env_config :: new(string name = "env_config");
	super.new(name);
  endfunction
