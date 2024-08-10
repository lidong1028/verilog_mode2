//=========================================
//Created by    :xxx
//Filename      :afifo_wctrl.v
//Author        :xxx(RDC)
//Created On    :2024-07-02 20:11
//Last Modified :
//Update Count  :
//Description   :
//
//
//=========================================
//
module afifo_wctrl #(
    parameter  integer AW      = 4,
    parameter  integer ALFULL  = 12
)
(
    //=========================================
    //ports declared by Verilog-mode tool
    //=========================================
    /*autoinput("^clk\|^rst")*/
    input                 wclk,
    input                 wrst_n,
    input                 wsrst,

    /*autoinput("^din\([0-1]\)_\(a\|b\)")*/

    /*autooutput("^dout_*")*/

    //=========================================
    // ports declared by user
    //=========================================
    // input/output to/from internal logic block
    input                       winc,
    input         [AW:0]        r2w_gptr,

    // output from inter-connection of internal instance
    output                      ram_wen,
    output        [AW-1:0]      ram_waddr,  // Write address for memory
    output logic  [AW:0]        wgptr,  // Gray write address for sync to read clock domain
    output logic                wfull,  // Write address for memory
    output logic                awfull,  // Write almost full flag
    output                      werr
    
);
//===========================
//Local parameters
//===========================
//
//===========================
//Local wires and registers
//===========================
/*autologic*/

/*autodefine*/
//  Define flip-flop registers here
reg   [AW:0]       wbptr;    //
//  Define combination registers here
//  Define wires here
wire               awfull_tmp;    //
wire  [AW:0]       wbptr_next;    //
wire               wfull_tmp;    //
wire  [AW:0]       wgptr_next;    //
//  End of automatic define
//  User define
reg   [AW:0]       r2w_bptr;    
//  End of user define

//
//===========================
//Main code begins here
//===========================
// 写指针产生
assign   ram_wen           = (winc & (~wfull));     //非满且写的时候，产生memory写使能
assign   wbptr_next[AW:0]  = wbptr[AW:0] + ram_wen; //非满且写的时候，写指针加一
assign   wgptr_next[AW:0]  = {1'd0,wbptr_next[AW:1]}^wbptr_next[AW:0]; //写指针二进制转格雷码
assign   ram_waddr[AW-1:0] = wbptr[AW-1:0];
always@( posedge wclk or negedge wrst_n ) begin
	if( !wrst_n) begin
		wbptr[AW:0] <= {(AW+1){1'b0}};
		wgptr[AW:0] <= {(AW+1){1'b0}};
	end else if( wsrst) begin
		wbptr[AW:0] <= {(AW+1){1'b0}};
		wgptr[AW:0] <= {(AW+1){1'b0}};
	end else begin
		wbptr[AW:0] <= wbptr_next[AW:0];
		wgptr[AW:0] <= wgptr_next[AW:0];
	end
end

// 满/将满标志产生
assign  wfull_tmp  = (wgptr_next[AW:0] == {~r2w_gptr[AW:AW-1],r2w_gptr[AW-2:0]});
assign  awfull_tmp = ((wbptr_next[AW:0] - r2w_bptr[AW:0]) > ALFULL);
always@( posedge wclk or negedge wrst_n ) begin
	if( !wrst_n) begin
		wfull  <= 1'b0;
		awfull <= 1'b0;
	end else if( wsrst) begin
		wfull  <= 1'b0;
		awfull <= 1'b0;
	end else begin
		wfull  <= wfull_tmp;
		awfull <= awfull_tmp;
	end
end
//////////////////////////////// 格雷码转二进制  ///////////////////////////////////////////
generate for(genvar i=0;i<AW+1;i=i+1)  begin :GRAY2BIN_R2W
    always@(*)  begin
	    r2w_bptr[i] = ^r2w_gptr[AW:i];
	end
end
endgenerate
//////////////////////////////// 维测相关  ///////////////////////////////////////////
assign  werr = winc & wfull;  //强写
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
