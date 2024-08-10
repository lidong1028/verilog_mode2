//=========================================
//Created by    :lidong
//Filename      :afifo_sync.v
//Author        :lidong(RDC)
//Created On    :2024-07-01 21:44
//Last Modified :
//Update Count  :
//Description   :
//
//
//=========================================
//
module afifo_sync #(
    parameter  integer DW     = 4,
    parameter  integer STAGE  = 3
)
(
    //=========================================
    //ports declared by Verilog-mode tool
    //=========================================
    /*autoinput("^clk\|^rst")*/
    input                       clk,
    input                       rst_n,
    input                       srst,

    /*autoinput("^din\([0-1]\)_\(a\|b\)")*/

    /*autooutput("^dout_*")*/

    //=========================================
    // ports declared by user
    //=========================================
    // input/output to/from internal logic block
    input   [DW-1:0]            din,
    output  [DW-1:0]            dout

    // output from inter-connection of internal instance
);
//===========================
//Local parameters
//===========================
localparam  integer DW_TOTAL = DW*STAGE;
//===========================
//Local wires and registers
//===========================
/*autologic*/

/*autodefine*/
//  Define flip-flop registers here
reg   [DW_TOTAL-1:0]     data_dly;    //
//  Define combination registers here
//  Define wires here
//  End of automatic define
//  User define
//  End of user define

//
//===========================
//Main code begins here
//===========================
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        data_dly[DW_TOTAL-1:0] <=  'd0;
    end else if(srst) begin
        data_dly[DW_TOTAL-1:0] <=  'd0;
    end else begin
        data_dly[DW_TOTAL-1:0] <=  {data_dly[DW_TOTAL-1-DW:0],din[DW-1:0]};
    end
end


assign  dout[DW-1:0] = data_dly[DW_TOTAL-1-:DW];
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
