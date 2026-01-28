module receiver(
    input clk2,baud_rclk,rst,rx,
    output reg [7:0]r_data,
    output reg error,doner
);
    
    parameter start_state=2'b00;
    parameter data_state=2'b01;
    parameter parity_state=2'b10;
    parameter stop_state=2'b11;
    
    reg [1:0]state;
    reg [3:0]count;
    reg [7:0]data;

    always@(posedge baud_rclk or posedge rst)begin
        if(rst)begin
            state<=start_state;
            error<=0;
            count<=4'd0;
            data<=8'd0;
            doner<=0;
            r_data <=0;
        end
        else begin
            case(state)
                start_state:begin
                    if(!rx)begin
                        state<=data_state;
                    end
                    else
                        state<=start_state;
                end
                
                data_state:begin
                    if(count<=4'd7)begin
                        data[count]<=rx;
                        count<=count+1;
                    end
                    else begin
                        state=parity_state;
                    end
                end
                
                parity_state:begin
                    if(((^data)^rx)==0)begin
                        error<=1;
                        doner<=1;
                        r_data <= data;
                        state<=stop_state;
                     end
                     else begin
                        error<=0;
                        doner<=1;
                        data<=rx;
                        r_data <= data;
                        state<=stop_state;
                     end
                end
                
                stop_state:begin
                    doner<=1;
                    state<=stop_state;
                end
            default:state<=start_state;
            endcase
        end
    end
endmodule
