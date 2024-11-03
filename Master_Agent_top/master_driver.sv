class master_driver extends uvm_driver#(master_xtn);
  `uvm_component_utils(master_driver)

  virtual wishbone_if.MDRV_MP vif;
  master_agent_config m_cfg;

  extern function new(string name = "master_driver", uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern task send_to_dut(master_xtn m_xtn);

endclass

  function master_driver :: new(string name = "master_driver", uvm_component parent);
	super.new(name,parent);
  endfunction

  function void master_driver :: build_phase(uvm_phase phase);
	if(!uvm_config_db #(master_agent_config) :: get(this,"","master_agent_config",m_cfg))
		`uvm_fatal("FATAL","not getting in master_driver")

	super.build_phase(phase);
  endfunction

  function void master_driver :: connect_phase(uvm_phase phase);
	vif = m_cfg.vif;
  endfunction

  task master_driver :: run_phase(uvm_phase phase);
	//Reset logic
	@(vif.master_drv_cb);
	vif.master_drv_cb.wb_rst_i <= 1'b1;
	@(vif.master_drv_cb);	
	//@(vif.master_drv_cb);	
	vif.master_drv_cb.wb_rst_i <= 1'b0;
	
	forever
	  begin
		seq_item_port.get_next_item(req);
		send_to_dut(req);
		seq_item_port.item_done();
	  end
  endtask

  task master_driver :: send_to_dut(master_xtn m_xtn);

	`uvm_info("MASTER_DRIVER",$sformatf("printing from master_driver \n %s",m_xtn.sprint()),UVM_LOW) 	
	
//	@(vif.master_drv_cb);
	vif.master_drv_cb.wb_we_i  <= m_xtn.wb_we_i;
	vif.master_drv_cb.wb_adr_i <= m_xtn.wb_adr_i;
	vif.master_drv_cb.wb_dat_i <= m_xtn.wb_dat_i;

	vif.master_drv_cb.wb_stb_i <= 1;
	vif.master_drv_cb.wb_cyc_i <= 1;
	vif.master_drv_cb.wb_sel_i <= 4'b1111;

	while(vif.master_drv_cb.wb_ack_o !==1)
	@(vif.master_drv_cb);
	vif.master_drv_cb.wb_stb_i <= 0;
	vif.master_drv_cb.wb_cyc_i <= 0;	
	@(vif.master_drv_cb);
//	`uvm_info("MASTER_DRIVER",$sformatf("printing from master_driver \n %s",m_xtn.sprint()),UVM_LOW)
		
  endtask
