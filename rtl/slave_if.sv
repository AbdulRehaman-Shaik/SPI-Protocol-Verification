interface slave_if(input bit clock);

  logic 	miso_pad_i;
  logic 	mosi_pad_o;
  logic 	sclk_pad_o;
  logic [8-1:0] ss_pad_o;

  clocking slave_drv_cb@(posedge clock);
    default input #1 output #1;	
	output miso_pad_i;
	input  mosi_pad_o;
	input  sclk_pad_o;
   	input  ss_pad_o;
  endclocking

  clocking slave_mon_cb@(posedge clock);
    default input #1 output #1;
	input  miso_pad_i;
	input  mosi_pad_o;
	input  sclk_pad_o;
   	input  ss_pad_o;
  endclocking

  modport SDRV_MP(clocking slave_drv_cb);
  modport SMON_MP(clocking slave_mon_cb);

endinterface
