class master_agent_top extends uvm_env;
  `uvm_component_utils(master_agent_top)

  master_agent m_agenth[];
  env_config e_cfg;

  extern function new(string name = "master_agent_top", uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  
endclass

  function master_agent_top :: new(string name = "master_agent_top", uvm_component parent);
	super.new(name,parent);
  endfunction

  function void master_agent_top :: build_phase(uvm_phase phase);
	super.build_phase(phase);
	
	if(!uvm_config_db #(env_config) :: get(this,"","env_config",e_cfg))
		`uvm_fatal("FATAL","not getting in master_agent_top")

	m_agenth = new[e_cfg.no_of_master_agents];

	foreach(m_agenth[i])
		begin
			m_agenth[i] = master_agent :: type_id :: create($sformatf("m_agenth[%0d]",i),this);
			uvm_config_db #(master_agent_config) :: set(this,$sformatf("m_agenth[%0d]*",i),"master_agent_config",e_cfg.m_cfg[i]);
		end
  endfunction
