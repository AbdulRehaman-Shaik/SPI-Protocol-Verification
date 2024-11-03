class master_agent_config extends uvm_object;
  `uvm_object_utils(master_agent_config)
  
  uvm_active_passive_enum is_active = UVM_ACTIVE;
  virtual wishbone_if vif;
  extern function new(string name = "master_agent_config");


endclass

  function master_agent_config :: new(string name = "master_agent_config");
	super.new(name);
  endfunction
