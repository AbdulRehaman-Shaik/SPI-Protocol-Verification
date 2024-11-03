class slave_monitor extends uvm_monitor;
  `uvm_component_utils(slave_monitor)

  virtual slave_if.SMON_MP vif;
  slave_agent_config s_cfg;
  uvm_analysis_port #(slave_xtn) monitor_port;

  slave_xtn s_xtn;
  int ctrl;
  bit [6:0]char_len;

  extern function new(string name = "slave_monitor", uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern task collect_data();

endclass

  function slave_monitor :: new(string name = "slave_monitor", uvm_component parent);
	super.new(name,parent);
	monitor_port = new("monitor_port",this);
  endfunction

  function void slave_monitor :: build_phase(uvm_phase phase);
	if(!uvm_config_db #(slave_agent_config) :: get(this,"","slave_agent_config",s_cfg))
		`uvm_fatal("FATAL","not getting in master_monitor")

	if(!uvm_config_db #(int) :: get(this,"","int",ctrl))
		`uvm_fatal("FATAL","not getting in slave_monitor")


	super.build_phase(phase);
  endfunction

  function void slave_monitor :: connect_phase(uvm_phase phase);
	vif = s_cfg.vif;
  endfunction

  task slave_monitor :: run_phase(uvm_phase phase);
	s_xtn = slave_xtn :: type_id :: create("s_xtn");
	forever
		collect_data();
  endtask

  task slave_monitor :: collect_data();

	@(vif.slave_mon_cb);
	@(vif.slave_mon_cb);

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
			@(negedge vif.slave_mon_cb.sclk_pad_o);
			s_xtn.miso_pad_i[i] = vif.slave_mon_cb.miso_pad_i;
			s_xtn.mosi_pad_o[i] = vif.slave_mon_cb.mosi_pad_o; 			
		  end
		else
		 begin 
			@(posedge vif.slave_mon_cb.sclk_pad_o);
			s_xtn.miso_pad_i[i] = vif.slave_mon_cb.miso_pad_i;
			s_xtn.mosi_pad_o[i] = vif.slave_mon_cb.mosi_pad_o; 			
		 end
	     end
	  end

	else
	  begin
	    for(int i=char_len-1;i>=0;i=i-1)
	      begin
		if(ctrl[9] == 1)
		  begin
			@(negedge vif.slave_mon_cb.sclk_pad_o);
			s_xtn.miso_pad_i[i] = vif.slave_mon_cb.miso_pad_i;
			s_xtn.mosi_pad_o[i] = vif.slave_mon_cb.mosi_pad_o; 		 
		   end
		else
		 begin 
			@(posedge vif.slave_mon_cb.sclk_pad_o);
			s_xtn.miso_pad_i[i] = vif.slave_mon_cb.miso_pad_i;
			s_xtn.mosi_pad_o[i] = vif.slave_mon_cb.mosi_pad_o; 
		 end
	     end
	  end

	monitor_port.write(s_xtn);	

	`uvm_info("SLAVE_MONITOR",$sformatf("printing from slave_monitor \n %s",s_xtn.sprint()),UVM_LOW) 	

  endtask
