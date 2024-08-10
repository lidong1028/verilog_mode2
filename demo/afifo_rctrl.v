//=========================================
//Created by    :xxx
//Filename      :afifo_rctrl.v
//Author        :xxx (RDC)
//Created On    :2024-07-02 20:31
//Last Modified :
//Update Count  :
//Description   :
//
//
//=========================================
//
module afifo_rctrl #(
    parameter  integer AW       = 4,
    parameter  integer ALEMPTY  = 12

)
(
    //=========================================
    //ports declared by Verilog-mode tool
    //=========================================
    /*autoinput("^clk\|^rst")*/
    input                 rclk,
    input                 rrst_n,
    input                 rsrst,

    /*autoinput("^din\([0-1]\)_\(a\|b\)")*/

    /*autooutput("^dout_*")*/

    //=========================================
    // ports declared by user
    //=========================================
    // input/output to/from internal logic block
    input                 rinc,
    input  [AW:0]         w2r_gptr,

    // output from inter-connection of internal instance
    output                      ram_ren,
    output        [AW-1:0]      ram_raddr,  // Read address for memory
    output logic  [AW:0]        rgptr,      // Gray read address for sync to write clock domain
    output logic                arempty,    // Read almost empty flag
    output logic                rempty,      // Read empty flag
    output                      rerr

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
reg   [AW:0]       rbptr;    //
//  Define combination registers here
//  Define wires here
wire               arempty_tmp;    //
wire  [AW:0]       rbptr_next;    //
wire               rempty_tmp;    //
wire  [AW:0]       rgptr_next;    //
//  End of automatic define
//  User define
reg   [AW:0]       w2r_bptr;    
//  End of user define

//
//===========================
//Main code begins here
//===========================
//
//读指针产生
assign   ram_ren              = (rinc & (~rempty));      //非空且读的时候，产生读使能
assign   rbptr_next[AW:0]     = rbptr[AW:0] + ram_ren; //非空且读的时候，读指针加一
assign   rgptr_next[AW:0]     = {1'd0,rbptr_next[AW:1]}^rbptr_next[AW:0]; //读指针二进制转格雷码
assign   ram_raddr[AW-1:0]    = rbptr[AW-1:0];
always@( posedge rclk or negedge rrst_n ) begin
	if( !rrst_n) begin
		rbptr[AW:0] <= {(AW+1){1'b0}};
		rgptr[AW:0] <= {(AW+1){1'b0}};
	end else if( rsrst) begin
		rbptr[AW:0] <= {(AW+1){1'b0}};
		rgptr[AW:0] <= {(AW+1){1'b0}};
	end else begin
		rbptr[AW:0] <= rbptr_next[AW:0];
		rgptr[AW:0] <= rgptr_next[AW:0];
	end
end

//空/将空标志产生
assign  rempty_tmp  = (w2r_gptr[AW:0] == rgptr_next[AW:0]);
assign  arempty_tmp = ((w2r_bptr[AW:0] - rbptr[AW:0]) < ALEMPTY);
always@( posedge rclk or negedge rrst_n ) begin
	if( !rrst_n) begin
		rempty  <= 1'b1;
		arempty <= 1'b1;
	end else if( rsrst) begin
		rempty  <= 1'b1;
		arempty <= 1'b1;
	end else begin
		rempty  <= rempty_tmp;
		arempty <= arempty_tmp;
	end
end
//////////////////////////////// 格雷码转二进制  ///////////////////////////////////////////
generate for(genvar i=0;i<AW+1;i=i+1)  begin :GRAY2BIN_W2R
    always@(*)  begin
	    w2r_bptr[i] = ^w2r_gptr[AW:i];
	end
end
endgenerate
//////////////////////////////// 维测相关  ///////////////////////////////////////////
assign  rerr = rinc & rempty; //强读
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
