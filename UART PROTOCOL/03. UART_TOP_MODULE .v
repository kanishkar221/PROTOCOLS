module uart_top_module(
    input clk1,clk2,rst,wr_data,
    input [7:0]data,
    output baud_clk_t,baud_clk_r,tx,donet,error,doner,
    output [7:0]r_data
);

    baud_rate_t baudt(
        .clk1(clk1),
        .rst(rst),
        .baud_clk_t(baud_clk_t)
    );

    baud_rate_r baudr(
        .clk2(clk2),
        .rst(rst),
        .baud_clk_r(baud_clk_r)
    );
    
    transmitter master_tx(
        .clk1(clk1),
        .rst(rst),
        .wr_data(wr_data),
        .data(data),
        .baud_tclk(baud_clk_t),
        .tx(tx),.donet(donet)
    );

    receiver slave_rx(
        .clk2(clk2),
        .rst(rst),
        .baud_rclk(baud_clk_r),
        .r_data(r_data),
        .rx(tx),
        .error(error),
        .doner(doner)
    );

endmodule


module baud_rate_t(
    input clk1,rst,
    output reg baud_clk_t);
    
    parameter integer baud_rate=115200;
    parameter integer frq=50000000;
    parameter integer clk_div=frq/baud_rate;
    integer count;

    always@(posedge clk1)begin
        if(rst)begin
            count<=0;
            baud_clk_t<=0;
        end
        else begin
            if(count==clk_div)begin
                count<=0;
                baud_clk_t<=1;
            end
            else begin
                count<=count+1;
                baud_clk_t<=0;
            end
        end
    end
endmodule

module baud_rate_r(
    input clk2,rst,
    output reg baud_clk_r);
    
    parameter integer baud_rate=115200;
    parameter integer frq=40000000;
    parameter integer clk_div=frq/baud_rate;
    integer count;
    
    always@(posedge clk2)begin
        if(rst)begin
            count<=0;
            baud_clk_r<=0;
        end
        else begin
            if(count==clk_div)begin
                count<=0;
                baud_clk_r<=1;
            end
            else begin
                count<=count+1;
                baud_clk_r<=0;
            end
        end
    end
endmodule
