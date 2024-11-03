class master_monitor extends uvm_monitor;
  `uvm_component_utils(master_monitor)

  virtual wishbone_if.MMON_MP vif;
  master_agent_config m_cfg;
  uvm_analysis_port #(master_xtn) monitor_port;

  master_xtn m_xtn;

  extern function new(string name = "master_monitor", uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern task collect_data();

endclass

  function master_monitor :: new(string name = "master_monitor", uvm_component parent);
	super.new(name,parent);
	monitor_port = new("monitor_port",this);
  endfunction

  function void master_monitor :: build_phase(uvm_phase phase);
	if(!uvm_config_db #(master_agent_config) :: get(this,"","master_agent_config",m_cfg))
		`uvm_fatal("FATAL","not getting in master_monitor")
	super.build_phase(phase);
  endfunction

  function void master_monitor :: connect_phase(uvm_phase phase);
	vif = m_cfg.vif;
  endfunction

  task master_monitor :: run_phase(uvm_phase phase);
	m_xtn = master_xtn::type_id::create("m_xtn");

	forever
	  begin
		collect_data();
	  end
  endtask

  task master_monitor :: collect_data();

//	@(vif.master_mon_cb);

	while(vif.master_mon_cb.wb_ack_o !== 1)
	@(vif.master_mon_cb);

	m_xtn.wb_we_i  = vif.master_mon_cb.wb_we_i;
	m_xtn.wb_adr_i = vif.master_mon_cb.wb_adr_i;

	if(m_xtn.wb_we_i == 1 && m_xtn.wb_adr_i == 'h00)
		m_xtn.TX0 = vif.master_mon_cb.wb_dat_i;
	if(m_xtn.wb_we_i == 1 && m_xtn.wb_adr_i == 'h04)
		m_xtn.TX1 = vif.master_mon_cb.wb_dat_i;
	if(m_xtn.wb_we_i == 1 && m_xtn.wb_adr_i == 'h08)
		m_xtn.TX2 = vif.master_mon_cb.wb_dat_i;
	if(m_xtn.wb_we_i == 1 && m_xtn.wb_adr_i == 'h0c)
		m_xtn.TX3 = vif.master_mon_cb.wb_dat_i;

	if(m_xtn.wb_we_i == 0 && m_xtn.wb_adr_i == 'h00)
		m_xtn.RX0 = vif.master_mon_cb.wb_dat_o;
	if(m_xtn.wb_we_i == 0 && m_xtn.wb_adr_i == 'h04)
		m_xtn.RX1 = vif.master_mon_cb.wb_dat_o;
	if(m_xtn.wb_we_i == 0 && m_xtn.wb_adr_i == 'h08)
		m_xtn.RX2 = vif.master_mon_cb.wb_dat_o;
	if(m_xtn.wb_we_i == 0 && m_xtn.wb_adr_i == 'h0c)
		m_xtn.RX3 = vif.master_mon_cb.wb_dat_o;

	if(m_xtn.wb_we_i == 1 && m_xtn.wb_adr_i == 'h14)
		m_xtn.DIVIDER = vif.master_mon_cb.wb_dat_i;
	if(m_xtn.wb_we_i == 1 && m_xtn.wb_adr_i == 'h18)
		m_xtn.SS = vif.master_mon_cb.wb_dat_i;
	if(m_xtn.wb_we_i == 1 && m_xtn.wb_adr_i == 'h10)
		m_xtn.CTRL = vif.master_mon_cb.wb_dat_i;

	@(vif.master_mon_cb);
	monitor_port.write(m_xtn);
	
	`uvm_info("MASTER_MONITOR",$sformatf("printing from master_monitor \n %s",m_xtn.sprint()),UVM_LOW)
	
  endtask
