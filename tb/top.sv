module top();

  import uvm_pkg :: *;
 
  import spi_pkg :: *;

    bit clock;
	always #10 clock = !clock;	

  wishbone_if 	w_if(clock);
  slave_if 	s_if(clock);

  spi_top DUV (

  // Wishbone signals
  .wb_clk_i(clock), .wb_rst_i(w_if.wb_rst_i), .wb_adr_i(w_if.wb_adr_i), .wb_dat_i(w_if.wb_dat_i), .wb_dat_o(w_if.wb_dat_o), .wb_sel_i(w_if.wb_sel_i),
  .wb_we_i(w_if.wb_we_i), .wb_stb_i(w_if.wb_stb_i), .wb_cyc_i(w_if.wb_cyc_i), .wb_ack_o(w_if.wb_ack_o), .wb_err_o(w_if.wb_err_o), .wb_int_o(w_if.wb_int_o),

  // SPI signals
  .ss_pad_o(s_if.ss_pad_o), .sclk_pad_o(s_if.sclk_pad_o), .mosi_pad_o(s_if.mosi_pad_o), .miso_pad_i(s_if.miso_pad_i)
);


  initial
	begin
		`ifdef VCS
		$fsdbDumpvars(0,top);
		`endif
	
		uvm_config_db #(virtual wishbone_if) :: set(null,"*","wishbone_if_0",w_if);
		uvm_config_db #(virtual slave_if)    :: set(null,"*","slave_if_0",s_if);

		run_test();
    	end
endmodule
