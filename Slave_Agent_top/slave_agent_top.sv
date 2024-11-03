class slave_agent_top extends uvm_env;
  `uvm_component_utils(slave_agent_top)

  slave_agent s_agenth[];
  env_config e_cfg;

  extern function new(string name = "slave_agent_top", uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  
endclass

  function slave_agent_top :: new(string name = "slave_agent_top", uvm_component parent);
	super.new(name,parent);
  endfunction

  function void slave_agent_top :: build_phase(uvm_phase phase);
	super.build_phase(phase);
	
	if(!uvm_config_db #(env_config) :: get(this,"","env_config",e_cfg))
		`uvm_fatal("FATAL","not getting in slave_agent_top")

	s_agenth = new[e_cfg.no_of_slave_agents];

	foreach(s_agenth[i])
		begin
			s_agenth[i] = slave_agent :: type_id :: create($sformatf("s_agenth[%0d]",i),this);
			uvm_config_db #(slave_agent_config) :: set(this,$sformatf("s_agenth[%0d]*",i),"slave_agent_config",e_cfg.s_cfg[i]);
		end
  endfunction
