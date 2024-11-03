class env extends uvm_env;

  `uvm_component_utils(env)

  master_agent_top m_agt_toph;
  slave_agent_top  s_agt_toph;

  virtual_sequencer v_seqrh;
  scoreboard sb;

  env_config 	e_cfg;

  extern function new(string name = "env", uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);

endclass

  function env :: new(string name = "env", uvm_component parent);
	super.new(name,parent);
  endfunction

  function void env :: build_phase(uvm_phase phase);
	super.build_phase(phase);

	if(!uvm_config_db #(env_config) :: get(this,"","env_config",e_cfg))
		`uvm_fatal("FATAL","not getting in env")

	if(e_cfg.has_scoreboard)
		sb = scoreboard :: type_id :: create("sb",this);

	if(e_cfg.has_virtual_sequencer)
		v_seqrh = virtual_sequencer :: type_id :: create("v_seqrh",this);

	if(e_cfg.has_master_agent_top)
		m_agt_toph = master_agent_top :: type_id :: create("m_agt_toph",this);

	if(e_cfg.has_slave_agent_top)
		s_agt_toph = slave_agent_top :: type_id :: create("s_agt_toph",this);
  endfunction

  function void env :: connect_phase(uvm_phase phase);
      if(e_cfg.has_scoreboard)
	begin
	  for(int i=0; i<e_cfg.no_of_master_agents; i++)
	     begin
		m_agt_toph.m_agenth[i].monh.monitor_port.connect(sb.m_fifoh[i].analysis_export);
	     end

	  for(int i=0; i<e_cfg.no_of_slave_agents; i++)
	     begin
		s_agt_toph.s_agenth[i].monh.monitor_port.connect(sb.s_fifoh[i].analysis_export);
	     end
	end

	if(e_cfg.has_virtual_sequencer)
	  begin
	    if(e_cfg.has_master_agent_top)
	      begin
		for(int i=0; i<e_cfg.no_of_master_agents; i++)
		v_seqrh.m_seqrh[i] = m_agt_toph.m_agenth[i].seqrh; 
	      end

	   if(e_cfg.has_slave_agent_top)
	     begin
		for(int i=0; i<e_cfg.no_of_slave_agents; i++)
		v_seqrh.s_seqrh[i] = s_agt_toph.s_agenth[i].seqrh;
	     end
	  end

  endfunction
