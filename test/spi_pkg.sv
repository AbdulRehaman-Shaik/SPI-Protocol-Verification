package spi_pkg;

  import uvm_pkg :: *;

  `include "uvm_macros.svh"

  `include "master_agent_config.sv"
  `include "slave_agent_config.sv"
  `include "env_config.sv"

  `include "master_xtn.sv"
  `include "master_driver.sv"
  `include "master_monitor.sv"
  `include "master_sequencer.sv"
  `include "master_agent.sv"
  `include "master_agent_top.sv"
  `include "master_sequence.sv"

  `include "slave_xtn.sv"
  `include "slave_driver.sv"
  `include "slave_monitor.sv"
  `include "slave_sequencer.sv"
  `include "slave_agent.sv"
  `include "slave_agent_top.sv"
  `include "slave_sequence.sv"

  `include "virtual_sequencer.sv"
  `include "scoreboard.sv"
  `include "virtual_sequence.sv"

  `include "env.sv"
  `include "test.sv"

endpackage
