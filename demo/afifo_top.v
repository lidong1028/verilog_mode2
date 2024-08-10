//=========================================
//Created by    :lidong
//Filename      :afifo_top.v
//Author        :lidong(RDC)
//Created On    :2024-07-03 22:08
//Last Modified :
//Update Count  :
//Description   :
//
//
//=========================================
//
module afifo_top #(
    parameter  integer DW      = 10,
    parameter  integer DEPTH   = 16 ,
    parameter  integer ALFULL  = 12,
    parameter  integer ALEMPTY = 4
)
(
    //=========================================
    //ports declared by Verilog-mode tool
    //=========================================
    /*autoinput("^clk\|^rst")*/
    input                 wclk,
    input                 rclk,
    input                 wrst_n,
    input                 rrst_n,
    input                 srst,
    /*autoinput("^din\([0-1]\)_\(a\|b\)")*/

    /*autooutput("^dout_*")*/

    //=========================================
    // ports declared by user
    //=========================================
    // input/output to/from internal logic block
	//FIFO 读写接口，用户使用侧                
	input                       winc,              //写使能，高有效
	input      [DW-1:0]         wdata,             //写数据
	input                       rinc,              //读使能，高有效             
	output                      rdata_valid,       //读数据有效指示，高有效
	output     [DW-1:0]         rdata,             //读数据
	output     [DW-1:0]         rdata_ahead,       //读数据
	output                      rempty,            //空信号，读时钟域，高有效
	output                      arempty,           //将空信号，读时钟域，高有效
	output                      wfull,             //满信号，写时钟域，高有效
	output                      awfull,            //将满信号，写时钟域，高有效
	
	//维测相关
	output                      werr,              //写错误脉冲(满写)
	output                      rerr               //读错误脉冲(空读)
    // output from inter-connection of internal instance
);
//===========================
//Local parameters
//===========================
localparam integer AW = $clog2(DEPTH);
//===========================
//Local wires and registers
//===========================
/*autologic*/

/*autodefine*/
//  Define flip-flop registers here
//  Define combination registers here
//  Define wires here
//  End of automatic define
//  User define
wire [AW:0]             r2w_gptr_sync;          
wire [AW-1:0]           ram_raddr;              
wire                    ram_ren;                
wire [AW-1:0]           ram_waddr;              
wire                    ram_wen;                
wire [AW:0]             rgptr;                  
wire                    rsrst;                  
wire [AW:0]             w2r_gptr_sync;          
wire [AW:0]             wgptr;                  
wire                    wsrst;                  
//  End of user define

//
//===========================
//Main code begins here
//===========================
//
//sync 
/*
afifo_sync auto_template (
    .clk           ( wclk   ),
    .rst_n         ( wrst_n ),
    .srst          ( 1'd0   ),
    .din           ( srst   ),
    .dout          ( wsrst  ),
);
*/
afifo_sync # (
  .DW       (1    ),
  .STAGE    (2    )
)  u_wsrst_sync (/*autoinst*/
                 // Outputs
                 .dout                  ( wsrst  ),              // Templated
                 // Inputs
                 .clk                   ( wclk   ),              // Templated
                 .rst_n                 ( wrst_n ),              // Templated
                 .srst                  ( 1'd0   ),              // Templated
                 .din                   ( srst   ));             // Templated

/*
afifo_sync auto_template (
    .clk           ( rclk   ),
    .rst_n         ( rrst_n ),
    .srst          ( 1'd0   ),
    .din           ( srst   ),
    .dout          ( rsrst  ),
);
*/
afifo_sync # (
  .DW       (1    ),
  .STAGE    (2    )
)  u_rsrst_sync (/*autoinst*/
                 // Outputs
                 .dout                  ( rsrst  ),              // Templated
                 // Inputs
                 .clk                   ( rclk   ),              // Templated
                 .rst_n                 ( rrst_n ),              // Templated
                 .srst                  ( 1'd0   ),              // Templated
                 .din                   ( srst   ));             // Templated

/*
afifo_sync auto_template (
    .clk           ( rclk              ),
    .rst_n         ( rrst_n            ),
    .srst          ( rsrst             ),
    .din           ( wgptr[]           ),
    .dout          ( w2r_gptr_sync[]   ),
);
*/
afifo_sync # (
  .DW       (AW+1    ),
  .STAGE    (2       )
)  u_w2r_sync (/*autoinst*/
               // Outputs
               .dout                    ( w2r_gptr_sync[(AW+1)-1:0]   ), // Templated
               // Inputs
               .clk                     ( rclk              ),   // Templated
               .rst_n                   ( rrst_n            ),   // Templated
               .srst                    ( rsrst             ),   // Templated
               .din                     ( wgptr[(AW+1)-1:0]           )); // Templated


/*
afifo_sync auto_template (
    .clk           ( wclk              ),
    .rst_n         ( wrst_n            ),
    .srst          ( wsrst             ),
    .din           ( rgptr[]           ),
    .dout          ( r2w_gptr_sync[]   ),
);
*/
afifo_sync # (
  .DW       (AW+1    ),
  .STAGE    (2       )
)    u_r2w_sync (/*autoinst*/
                 // Outputs
                 .dout                  ( r2w_gptr_sync[(AW+1)-1:0]   ), // Templated
                 // Inputs
                 .clk                   ( wclk              ),   // Templated
                 .rst_n                 ( wrst_n            ),   // Templated
                 .srst                  ( wsrst             ),   // Templated
                 .din                   ( rgptr[(AW+1)-1:0]           )); // Templated

/*
afifo_wctrl auto_template (
    .r2w_gptr           ( r2w_gptr_sync[] ),
);
*/
afifo_wctrl # (
  .AW       (AW    ),
  .ALFULL   (ALFULL)
)    u_afifo_wctrl (/*autoinst*/
                    // Outputs
                    .ram_wen            (ram_wen),
                    .ram_waddr          (ram_waddr[AW-1:0]),
                    .wgptr              (wgptr[AW:0]),
                    .wfull              (wfull),
                    .awfull             (awfull),
                    .werr               (werr),
                    // Inputs
                    .wclk               (wclk),
                    .wrst_n             (wrst_n),
                    .wsrst              (wsrst),
                    .winc               (winc),
                    .r2w_gptr           ( r2w_gptr_sync[AW:0] )); // Templated

/*
afifo_rctrl auto_template (
    .w2r_gptr           ( w2r_gptr_sync[] ),
);
*/
afifo_rctrl # (
  .AW       (AW     ),
  .ALEMPTY  (ALEMPTY)
)    u_afifo_rctrl (/*autoinst*/
                    // Outputs
                    .ram_ren            (ram_ren),
                    .ram_raddr          (ram_raddr[AW-1:0]),
                    .rgptr              (rgptr[AW:0]),
                    .arempty            (arempty),
                    .rempty             (rempty),
                    .rerr               (rerr),
                    // Inputs
                    .rclk               (rclk),
                    .rrst_n             (rrst_n),
                    .rsrst              (rsrst),
                    .rinc               (rinc),
                    .w2r_gptr           ( w2r_gptr_sync[AW:0] )); // Templated

/*
afifo_mem auto_template (
    .ram_wdata            (wdata[]),
    .ram_rdata_valid      (rdata_valid),
    .ram_rdata            (rdata[]),
    .ram_rdata_ahead      (rdata_ahead[]),
);
*/
afifo_mem # (
  .DW       (DW     ),
  .DEPTH    (DEPTH  )
)    u_afifo_mem (/*autoinst*/
                  // Outputs
                  .ram_rdata_valid      (rdata_valid),           // Templated
                  .ram_rdata            (rdata[DW-1:0]),         // Templated
                  .ram_rdata_ahead      (rdata_ahead[DW-1:0]),   // Templated
                  // Inputs
                  .wclk                 (wclk),
                  .rclk                 (rclk),
                  .wrst_n               (wrst_n),
                  .rrst_n               (rrst_n),
                  .wsrst                (wsrst),
                  .rsrst                (rsrst),
                  .ram_wen              (ram_wen),
                  .ram_ren              (ram_ren),
                  .ram_waddr            (ram_waddr[AW-1:0]),
                  .ram_raddr            (ram_raddr[AW-1:0]),
                  .ram_wdata            (wdata[DW-1:0]));        // Templated

//=========================================
//Verilog-mode Setting:
//Local Variables:
//verilog-library-files: (
//"./test.v"
//)
//verilog-library-directories: (
//"."
//".."
//)
//verilog-auto-inst-param-value: t
//End:
//=========================================
endmodule
