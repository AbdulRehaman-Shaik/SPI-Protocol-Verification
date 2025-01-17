interface wishbone_if(input bit clock);

  logic		wb_clk_i;
  logic 	wb_rst_i;
  logic [4:0]	wb_adr_i;
  logic [32-1:0]wb_dat_i;
  logic [32-1:0]wb_dat_o;
  logic [3:0]	wb_sel_i;
  logic		wb_we_i;
  logic		wb_stb_i;
  logic 	wb_cyc_i;
  logic		wb_ack_o;
  logic 	wb_err_o;
  logic 	wb_int_o;
 
  clocking master_drv_cb@(posedge clock);
    default input #1 output #1;
	output wb_clk_i;
	output wb_rst_i;
 	output wb_adr_i;
	output wb_dat_i;
	output wb_sel_i;
	output wb_we_i;
	output wb_stb_i;
	output wb_cyc_i;
	
	input wb_dat_o;
	input wb_ack_o;
	input wb_err_o;
	input wb_int_o;

  endclocking

  clocking master_mon_cb@(posedge clock);
    default input #1 output #1;
	input wb_clk_i;
	input wb_rst_i;
 	input wb_adr_i;
	input wb_dat_i;
	input wb_sel_i;
	input wb_we_i;
	input wb_stb_i;
	input wb_cyc_i;
	
	input wb_dat_o;
	input wb_ack_o;
	input wb_err_o;
	input wb_int_o;

  endclocking

  modport MDRV_MP(clocking master_drv_cb);
  modport MMON_MP(clocking master_mon_cb);

endinterface
