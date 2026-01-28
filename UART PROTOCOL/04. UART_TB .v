module uart_tb;
    reg clk1,clk2,rst,wr_data;
    reg [7:0]data;
    wire baud_clk_t,baud_clk_r,tx,donet,error,doner;
    wire [7:0]r_data;

    initial begin
        clk1=1;
        clk2=1;
    end

    always #10 clk1=~clk1;
    always #12.5 clk2=~clk2;
    
    uart_top_module dut(clk1,clk2,rst,wr_data,data,baud_clk_t,baud_clk_r,tx,donet,error,doner,r_data);
    
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars();
        
        #10 rst=1;
        #20 rst=0;wr_data=1;
        #10 data=8'b10101010;
        #1000000;
        $finish;
    end
endmodule
