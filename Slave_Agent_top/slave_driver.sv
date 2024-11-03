class slave_driver extends uvm_driver#(slave_xtn);
  `uvm_component_utils(slave_driver)

  virtual slave_if.SDRV_MP vif;
  slave_agent_config s_cfg;

  int ctrl;
  bit [6:0]char_len;

  extern function new(string name = "slave_driver", uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern task send_to_dut(slave_xtn s_xtn);

endclass

  function slave_driver :: new(string name = "slave_driver", uvm_component parent);
	super.new(name,parent);
  endfunction

  function void slave_driver :: build_phase(uvm_phase phase);
	if(!uvm_config_db #(slave_agent_config) :: get(this,"","slave_agent_config",s_cfg))
		`uvm_fatal("FATAL","not getting in slave_driver")

	if(!uvm_config_db #(int) :: get(this,"","int",ctrl))
		`uvm_fatal("FATAL","not getting in slave_driver")	

		super.build_phase(phase);
  endfunction

  function void slave_driver :: connect_phase(uvm_phase phase);
	vif = s_cfg.vif;
  endfunction

  task slave_driver :: run_phase(uvm_phase phase);
	forever
	  begin
		seq_item_port.get_next_item(req);
		send_to_dut(req);
		seq_item_port.item_done();
	  end
  endtask

  task slave_driver :: send_to_dut(slave_xtn s_xtn);
	
	if(ctrl[6:0] == 0)
	  char_len = 128;
	else
	  char_len = ctrl[6:0];

	if(ctrl[11] == 1)
	  begin
	    for(int i=0;i<char_len;i=i+1)
	      begin
		if(ctrl[9] == 1)
		  begin
			@(posedge vif.slave_drv_cb.sclk_pad_o);
			vif.slave_drv_cb.miso_pad_i <= s_xtn.miso_pad_i[i];
		  end
		else
		 begin 
			@(negedge vif.slave_drv_cb.sclk_pad_o);
			vif.slave_drv_cb.miso_pad_i <= s_xtn.miso_pad_i[i];
		 end
	     end
			@(negedge vif.slave_drv_cb.sclk_pad_o);			
	  end

	else
	  begin
	    for(int i=char_len-1;i>=0;i=i-1)
	      begin
		if(ctrl[9] == 1)
		  begin
			@(posedge vif.slave_drv_cb.sclk_pad_o);
			vif.slave_drv_cb.miso_pad_i <= s_xtn.miso_pad_i[i];
		  end
		else
		 begin 
			@(negedge vif.slave_drv_cb.sclk_pad_o);
			vif.slave_drv_cb.miso_pad_i <= s_xtn.miso_pad_i[i];
		 end
	     end
			@(negedge vif.slave_drv_cb.sclk_pad_o);			
	  end

	@(vif.slave_drv_cb);
	`uvm_info("SLAVE_DRIVER",$sformatf("printing from slave_driver \n %s",s_xtn.sprint()),UVM_LOW) 

  endtask
