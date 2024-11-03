class slave_agent_config extends uvm_object;
  `uvm_object_utils(slave_agent_config)
  
  uvm_active_passive_enum is_active = UVM_ACTIVE;
  virtual slave_if vif;
  extern function new(string name = "slave_agent_config");


endclass

  function slave_agent_config :: new(string name = "slave_agent_config");
	super.new(name);
  endfunction
