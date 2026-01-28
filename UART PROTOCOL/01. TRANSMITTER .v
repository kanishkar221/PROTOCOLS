module transmitter(
    input clk1,baud_tclk,rst,wr_data,
    input [7:0]data,
    output  reg tx,donet
);

    parameter idle_state=3'b000;
    parameter start_state=3'b001;
    parameter data_state=3'b010;
    parameter parity_state=3'b011;
    parameter stop_state=3'b100;

    reg [2:0]state;
    reg [3:0]count;
    reg st;

    always@(posedge baud_tclk or posedge rst)begin
        if(rst)begin
            state<=idle_state;
            count<=4'd0;
            tx<=1;
            donet<=0;
            st<=0;
        end
        else begin
            case(state)
                idle_state:begin
                    if(wr_data)begin
                        state<=start_state;
                        tx<=1;
                    end
                    else
                        state<=idle_state;
                    end
                
                start_state:begin
                    if(!st)begin
                        state<=data_state;
                        tx<=0;
                        st<=1;
                    end
                    else
                        state<=start_state;
                    end
                    
                data_state:begin
                    if(count<=4'd7)begin
                        tx<=data[count];
                        count<=count+1;
                    end
                    else begin
                        count<=0;
                        tx <= ^data;
                        state<=stop_state;
                    end
                end
                
                parity_state:begin
                    tx<=^data;
                    state<=stop_state;
                end
                
                stop_state:begin
                    tx<=1;
                    donet<=1;
                    state<=idle_state;
                end
            endcase
        end
   end
endmodule
