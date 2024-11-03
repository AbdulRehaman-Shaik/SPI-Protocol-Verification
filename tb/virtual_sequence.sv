class virtual_sequence extends uvm_sequence#(uvm_sequence_item);
  `uvm_object_utils(virtual_sequence)

  master_sequencer m_seqrh[];
  slave_sequencer  s_seqrh[];

  virtual_sequencer v_seqrh;

  env_config e_cfg;

  extern function new(string name = "virtual_sequence");
  extern task body();

endclass

  function virtual_sequence :: new(string name = "virtual_sequence");
	super.new(name);
  endfunction

  task virtual_sequence :: body();
//	super.body();

	if(!uvm_config_db #(env_config) :: get(null,get_full_name(),"env_config",e_cfg))
		`uvm_fatal("FATAL","not getting in virtual_sequence")

	m_seqrh = new[e_cfg.no_of_master_agents];	
	s_seqrh = new[e_cfg.no_of_slave_agents];
	
	assert($cast(v_seqrh,m_sequencer))
	  else
	  begin
		`uvm_error("ERROR","error occured in virtual_sequence")
	  end

	foreach(m_seqrh[i])
		begin
			m_seqrh[i] = v_seqrh.m_seqrh[i];
		end

	  foreach(s_seqrh[i])
		begin
			s_seqrh[i] = v_seqrh.s_seqrh[i];
		end
  endtask
	 
class vseq1 extends virtual_sequence;

  `uvm_object_utils(vseq1)

  master_seq m_seqh;
  slave_seq  s_seqh;

  extern function new(string name = "vseq1");
  extern task body();

endclass

  function vseq1 :: new(string name = "vseq1");
	super.new(name);
  endfunction

  task vseq1 :: body();
	super.body();
	m_seqh = master_seq :: type_id :: create("m_seqh");
	s_seqh = slave_seq  :: type_id :: create("s_seqh");
	fork
		foreach(m_seqrh[i])
		m_seqh.start(m_seqrh[i]);
		
		foreach(s_seqrh[i])
		s_seqh.start(s_seqrh[i]);
	join

  endtask
