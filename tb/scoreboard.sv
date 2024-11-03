class scoreboard extends uvm_scoreboard;
  `uvm_component_utils(scoreboard)

  uvm_tlm_analysis_fifo #(master_xtn) m_fifoh[];
  uvm_tlm_analysis_fifo #(slave_xtn)  s_fifoh[];

  master_xtn mst_cov_data;

  master_xtn m_xtn;
  slave_xtn  s_xtn;

 // int ctrl;
  bit [127:0]char_len;

  bit [127:0]tx;
  bit [127:0]rx;


  env_config e_cfg;

  covergroup cg;

	CHAR_LEN : coverpoint mst_cov_data.CTRL[6:0]{bins cl[] = {10,32,127};}
	GO_BUSY  : coverpoint mst_cov_data.CTRL[8]{bins gb[] = {1};}
	TX_RX    : coverpoint mst_cov_data.CTRL[10:9]{bins tr[] = {1,2};}	//{01,10};
	LSB	 : coverpoint mst_cov_data.CTRL[11]{bins lsb[] = {0,1};}	
	IE 	 : coverpoint mst_cov_data.CTRL[12]{bins ie[] = {1};}
	ASS	 : coverpoint mst_cov_data.CTRL[13]{bins ass[] = {1};}

  endgroup

  extern function new(string name = "scoreboard", uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern task check_data(master_xtn m_xtn, slave_xtn s_xtn);
endclass

  function scoreboard :: new(string name = "scoreboard", uvm_component parent);
	super.new(name,parent);
	cg = new();
	
  endfunction

  function void scoreboard :: build_phase(uvm_phase phase);
	super.build_phase(phase);
	
	if(!uvm_config_db #(env_config) :: get(this,"","env_config",e_cfg))
		`uvm_fatal("FATAL","not getting in scoreboard")

	m_fifoh = new[e_cfg.no_of_master_agents];

	foreach(m_fifoh[i])
		m_fifoh[i] = new($sformatf("m_fifoh[%0d]",i),this);

	s_fifoh = new[e_cfg.no_of_slave_agents];

	foreach(s_fifoh[i])
		s_fifoh[i] = new($sformatf("s_fifoh[%0d]",i),this);

//	if(!uvm_config_db #(int) :: get(this,"","int",ctrl))
//		`uvm_fatal("FATAL","not getting in scoreboard")


  endfunction

  task scoreboard :: run_phase(uvm_phase phase);
	forever
	  begin
		fork 
			m_fifoh[0].get(m_xtn);

			s_fifoh[0].get(s_xtn);
		join
		
		m_xtn.print();
		s_xtn.print();
		
		$display("I am in scoreboard ");
		check_data(m_xtn,s_xtn);
	  end
  endtask	

  task scoreboard :: check_data(master_xtn m_xtn, slave_xtn s_xtn);

	if(m_xtn.CTRL[6:0] == 0)
		char_len = 128;
	else
		char_len = m_xtn.CTRL[6:0];

	tx = {m_xtn.TX3,m_xtn.TX2,m_xtn.TX1,m_xtn.TX0};
	rx = {m_xtn.RX3,m_xtn.RX2,m_xtn.RX1,m_xtn.RX0};

	$display("-----------------------------");
	$display("COMPARING TX WITH MOSI_PAD_O");
	$display("-----------------------------");

	for(int i=0;i<char_len;i++)
	begin
	if(tx[i] == s_xtn.mosi_pad_o[i])
	$display("COMPARED SUCCESSFUL tx=%0b mosi=%0b",tx[i],s_xtn.mosi_pad_o[i]);
	else
	$display("COMPARED UNSUCCESSFUL tx=%0b mosi=%0b",tx[i],s_xtn.mosi_pad_o[i]);
	end

	$display("-----------------------------");
	$display("COMPARING RX WITH MISO_PAD_I");
	$display("-----------------------------");

	for(int i=0;i<char_len;i++)
	begin
	if(rx[i] == s_xtn.miso_pad_i[i])
	$display("COMPARED SUCCESSFUL rx=%0b miso=%0b",rx[i],s_xtn.miso_pad_i[i]);
	else
	$display("COMPARED UNSUCCESSFUL rx=%0b miso=%0b",rx[i],s_xtn.miso_pad_i[i]);
	end
	
	mst_cov_data = m_xtn;
	cg.sample();

  endtask
