//=========================================
//Created by    :lidong
//Filename      :afifo_mem.v
//Author        :lidong(RDC)
//Created On    :2024-07-04 21:01
//Last Modified :
//Update Count  :
//Description   :
//
//
//=========================================
//
module afifo_mem #(
    parameter  integer DW     = 12,
    parameter  integer DEPTH  = 16,
    parameter  integer AW     = $clog2(DEPTH)
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
    input                 wsrst,
    input                 rsrst,
    /*autoinput("^din\([0-1]\)_\(a\|b\)")*/

    /*autooutput("^dout_*")*/

    //=========================================
    // ports declared by user
    //=========================================
    // input/output to/from internal logic block
    input                 ram_wen,
    input                 ram_ren,
    input    [AW-1:0]     ram_waddr,
    input    [AW-1:0]     ram_raddr,
    input    [DW-1:0]     ram_wdata,

    // output from inter-connection of internal instance
    output logic                ram_rdata_valid,
    output logic  [DW-1:0]      ram_rdata,
    output        [DW-1:0]      ram_rdata_ahead
);
//===========================
//Local parameters
//===========================
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
reg     [DEPTH-1:0][DW-1:0] mem;
//  End of user define

//
//===========================
//Main code begins here
//===========================
//
// 写memory
always@( posedge wclk ) begin
    if( ram_wen) begin
        mem[ram_waddr] <= ram_wdata[DW-1:0];
	end
end
// 读memory
always@( posedge rclk or negedge rrst_n ) begin
	if( !rrst_n) begin
		ram_rdata[DW-1:0]  <= {DW{1'b0}};
		ram_rdata_valid    <= 1'b0;
	end else if( rsrst) begin
		ram_rdata[DW-1:0]  <= {DW{1'b0}};
		ram_rdata_valid    <= 1'b0;
	end else if(ram_ren) begin
		ram_rdata[DW-1:0]  <= mem[ram_raddr];
		ram_rdata_valid    <= 1'b1;
	end else begin //数据不要清零，用于CG
		ram_rdata_valid    <= 1'b0;	
	end
end
assign ram_rdata_ahead[DW-1:0] = mem[ram_raddr]; //不用等待读使能有效，直接读数据
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
