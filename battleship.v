// DO NOT MODIFY THE MODULE NAMES, SIGNAL NAMES, SIGNAL PROPERTIES

module battleship (
  input            clk  ,
  input            rst  ,
  input            start,
  input      [1:0] X    ,
  input      [1:0] Y    ,
  input            pAb  ,
  input            pBb  ,
  output reg [7:0] disp0,
  output reg [7:0] disp1,
  output reg [7:0] disp2,
  output reg [7:0] disp3,
  output reg [7:0] led
);

/* Your design goes here. */

reg [15:0] mapA;
reg [15:0] mapB;
reg [3:0] scoreA;
reg [3:0] scoreB;
reg [3:0] state;
reg [2:0] input_count;
reg [5:0] timer;
reg Z;
reg blink;

parameter idle = 4'b0000;
parameter show_a = 4'b0001;
parameter a_in = 4'b0010;
parameter error_a = 4'b0011;
parameter b_in = 4'b0100;
parameter error_b = 4'b0101;
parameter show_b = 4'b0110;
parameter show_score = 4'b0111;
parameter a_shoot = 4'b1000;
parameter a_sink = 4'b1001;
parameter a_win = 4'b1010;
parameter b_shoot = 4'b1011;
parameter b_sink = 4'b1100;
parameter b_win = 4'b1101;

parameter SSD_0 = 8'b00111111;
parameter SSD_1 = 8'b00000110;
parameter SSD_2 = 8'b01011011;
parameter SSD_3 = 8'b01001111;
parameter SSD_4 = 8'b01100110;
parameter SSD_A = 8'b01110111;
parameter SSD_b = 8'b01111100;
parameter SSD_E = 8'b01111001;
parameter SSD_r = 8'b01010000;
parameter SSD_o = 8'b01011100;
parameter SSD_I = 8'b00110000;
parameter SSD_l = 8'b00000110;
parameter SSD_d = 8'b01011110;
parameter SSD_e = 8'b01111011;
parameter SSD_Dash = 8'b01000000;
parameter SSD_Off = 8'b00000000;

always @(*) begin
    case (state)
        idle: begin
            led = 8'b10011001;  
            disp3 = SSD_I;
            disp2 = SSD_d;
            disp1 = SSD_l;
            disp0 = SSD_e;
        end
        show_a: begin
            disp3 = SSD_A;
            disp2 = SSD_Off;
            disp1 = SSD_Off;
            disp0 = SSD_Off;
            led = 8'b10000000;
        end
        a_in: begin
            disp3 = SSD_Off;
            disp2 = SSD_Off;
                
            if (X == 2'b00) begin
                disp1 = SSD_0;
            end
            else if (X == 2'b01) begin
                disp1 = SSD_1;
            end
            else if (X == 2'b10) begin
                disp1 = SSD_2;
            end
            else begin
                disp1 = SSD_3;
            end

            if (Y == 2'b00) begin
                disp0 = SSD_0;
            end
            else if (Y == 2'b01) begin
                disp0 = SSD_1;
            end
            else if (Y == 2'b10) begin
                disp0 = SSD_2;
            end
            else begin
                disp0 = SSD_3;
            end
            
            led = {1'b1, 1'b0, input_count[1:0], 4'b0}; 
        end
        error_a: begin
            disp3 = SSD_E;
            disp2 = SSD_r;
            disp1 = SSD_r;
            disp0 = SSD_o;
            led = 8'b10011001;
        end
        show_b: begin
            disp3 = SSD_b;
            disp2 = SSD_Off;
            disp1 = SSD_Off;
            disp0 = SSD_Off;
            led = 8'b10011001;
        end
        b_in: begin
            disp3 = SSD_Off;
            disp2 = SSD_Off;

            if (X == 2'b00) begin
                disp1 = SSD_0;
            end
            else if (X == 2'b01) begin
                disp1 = SSD_1;
            end
            else if (X == 2'b10) begin
                disp1 = SSD_2;
            end
            else begin
                disp1 = SSD_3;
            end

            if (Y == 2'b00) begin
                disp0 = SSD_0;
            end
            else if (Y == 2'b01) begin
                disp0 = SSD_1;
            end
            else if (Y == 2'b10) begin
                disp0 = SSD_2;
            end
            else begin
                disp0 = SSD_3;
            end

            led = {4'b0, input_count[1:0], 1'b0, 1'b1};
        end
        error_b: begin
            disp3 = SSD_E;
            disp2 = SSD_r;
            disp1 = SSD_r;
            disp0 = SSD_o;
            led = 8'b10011001;
        end
        show_score: begin
            disp3 = SSD_Off;
            disp2 = SSD_0;
            disp1 = SSD_Dash;
            disp0 = SSD_0;
            led = 8'b10011001;
        end
        a_shoot: begin
        // Assign SSD_Off to disp3 and disp2
            disp3 = SSD_Off;
            disp2 = SSD_Off;
            
            if (X == 2'b00) begin
                disp1 = SSD_0;
            end
            else if (X == 2'b01) begin
                disp1 = SSD_1;
            end
            else if (X == 2'b10) begin
                disp1 = SSD_2;
            end
            else begin
                disp1 = SSD_3;
            end
            
            if (Y == 2'b00) begin
                disp0 = SSD_0;
            end
            else if (Y == 2'b01) begin
                disp0 = SSD_1;
            end
            else if (Y == 2'b10) begin
                disp0 = SSD_2;
            end
            else begin
                disp0 = SSD_3;
            end
            
            // Assign values to LED display
            led = {1'b1, 1'b0, scoreA[1:0], scoreB[1:0], 2'b0};
        end
        a_sink: begin
            // Assign disp3
            disp3 = SSD_Off;

            // Assign disp2 based on scoreA using if-else
            if (scoreA == 4'b0000) begin
                disp2 = SSD_0;
            end
            else if (scoreA == 4'b0001) begin
                disp2 = SSD_1;
            end
            else if (scoreA == 4'b0010) begin
                disp2 = SSD_2;
            end
            else if (scoreA == 4'b0011) begin
                disp2 = SSD_3;
            end
            else begin
                disp2 = SSD_4;
            end

            // Assign disp1
            disp1 = SSD_Dash;

            // Assign disp0 based on scoreB using if-else
            if (scoreB == 4'b0000) begin
                disp0 = SSD_0;
            end
            else if (scoreB == 4'b0001) begin
                disp0 = SSD_1;
            end
            else if (scoreB == 4'b0010) begin
                disp0 = SSD_2;
            end
            else if (scoreB == 4'b0011) begin
                disp0 = SSD_3;
            end
            else begin
                disp0 = SSD_4;
            end

            // Assign led based on Z using if-else
            if (Z) begin
                led = 8'b11111111;
            end
            else begin
                led = 8'b00000000;
            end
        end
        a_win: begin
            // Assign disp3
            disp3 = SSD_A;

            // Assign disp2 based on scoreA using if-else
            if (scoreA == 4'b0000) begin
                disp2 = SSD_0;
            end
            else if (scoreA == 4'b0001) begin
                disp2 = SSD_1;
            end
            else if (scoreA == 4'b0010) begin
                disp2 = SSD_2;
            end
            else if (scoreA == 4'b0011) begin
                disp2 = SSD_3;
            end
            else begin
                disp2 = SSD_4;
            end

            // Assign disp1
            disp1 = SSD_Dash;

            // Assign disp0 based on scoreB using if-else
            if (scoreB == 4'b0000) begin
                disp0 = SSD_0;
            end
            else if (scoreB == 4'b0001) begin
                disp0 = SSD_1;
            end
            else if (scoreB == 4'b0010) begin
                disp0 = SSD_2;
            end
            else if (scoreB == 4'b0011) begin
                disp0 = SSD_3;
            end
            else begin
                disp0 = SSD_4;
            end

            if (blink) led = 8'b11111111;
            else led = 0;

        end
        b_shoot: begin
            // Set display segments 3 and 2 to off
            disp3 = SSD_Off;
            disp2 = SSD_Off;

            // Determine disp1 based on the value of X using if-else statements
            if (X == 2'b00) begin
                disp1 = SSD_0;
            end
            else if (X == 2'b01) begin
                disp1 = SSD_1;
            end
            else if (X == 2'b10) begin
                disp1 = SSD_2;
            end
            else begin
                disp1 = SSD_3;
            end

            // Determine disp0 based on the value of Y using if-else statements
            if (Y == 2'b00) begin
                disp0 = SSD_0;
            end
            else if (Y == 2'b01) begin
                disp0 = SSD_1;
            end
            else if (Y == 2'b10) begin
                disp0 = SSD_2;
            end
            else begin
                disp0 = SSD_3;
            end

            // Set the LED
            led = {2'b0, scoreA[1:0], scoreB[1:0], 1'b0, 1'b1};
        end
        b_sink: begin
            disp3 = SSD_Off;

            // Replace ternary operator for disp2 with if-else statements
            if (scoreA == 4'b0000) begin
                disp2 = SSD_0;
            end
            else if (scoreA == 4'b0001) begin
                disp2 = SSD_1;
            end
            else if (scoreA == 4'b0010) begin
                disp2 = SSD_2;
            end
            else if (scoreA == 4'b0011) begin
                disp2 = SSD_3;
            end
            else begin
                disp2 = SSD_4;
            end

            disp1 = SSD_Dash;

            // Replace ternary operator for disp0 with if-else statements
            if (scoreB == 4'b0000) begin
                disp0 = SSD_0;
            end
            else if (scoreB == 4'b0001) begin
                disp0 = SSD_1;
            end
            else if (scoreB == 4'b0010) begin
                disp0 = SSD_2;
            end
            else if (scoreB == 4'b0011) begin
                disp0 = SSD_3;
            end
            else begin
                disp0 = SSD_4;
            end

            // Replace ternary operator for led with if-else statement
            if (Z) begin
                led = 8'b11111111;
            end
            else begin
                led = 8'b00000000;
            end
        end
        b_win: begin
            // Assign disp3 to SSD_B
            disp3 = SSD_b;
    
            // Determine disp2 based on scoreA
            if (scoreA == 4'b0000) begin
                disp2 = SSD_0;
            end else if (scoreA == 4'b0001) begin
                disp2 = SSD_1;
            end else if (scoreA == 4'b0010) begin
                disp2 = SSD_2;
            end else if (scoreA == 4'b0011) begin
                disp2 = SSD_3;
            end else begin
                disp2 = SSD_4;
            end
    
            // Assign disp1 to SSD_Dash
            disp1 = SSD_Dash;
    
            // Determine disp0 based on scoreB
            if (scoreB == 4'b0000) begin
                disp0 = SSD_0;
            end else if (scoreB == 4'b0001) begin
                disp0 = SSD_1;
            end else if (scoreB == 4'b0010) begin
                disp0 = SSD_2;
            end else if (scoreB == 4'b0011) begin
                disp0 = SSD_3;
            end else begin
                disp0 = SSD_4;
            end
            if (blink) led = 8'b11111111;
            else led = 0;
        end
    
    
        default begin
            led = 8'b10011001;  
            disp3 = SSD_I;
            disp2 = SSD_d;
            disp1 = SSD_l;
            disp0 = SSD_e;
        end
    endcase

end
always @(posedge clk) begin
  if (rst) begin
    mapA <= 16'b0;
    mapB <= 16'b0;
    scoreA <= 4'b0;
    scoreB <= 4'b0;
    input_count <= 3'b0;
    timer <= 0;
    Z <= 1'b0;
    state <= idle;
    blink <= 0;
  end
  else begin
    case (state)
        idle: begin
            if (start) begin
                state <= show_a;
                timer <= 0;
            end
            else begin
                state <= idle;
            end
        end

        show_a: begin  
            if (timer == 49) begin
                state <= a_in;
                timer <= 0;
            end
            else begin
                timer <= timer + 1;
                state <= show_a;
            end
        end

        a_in: begin             
            if (pAb) begin
                if (mapA[X*4 + Y]) begin
                    state <= error_a;
                        timer <= 0;
                    end
                else begin
                    mapA[X*4 + Y] <= 1'b1;
                    if (input_count > 3'b010) begin
                        state <= show_b;
                        input_count <= 3'b0;
                        timer <= 0;
                    end
                    else begin
                        input_count <= input_count + 1'b1;
                    end
                end
            end
            else begin
                state <= a_in;
            end
        end
        error_a: begin  
            if (timer == 49) 
            begin
                state <= a_in;
                timer <= 0;
            end
            else timer <= timer + 1;
        end

        show_b: begin 
            if (timer == 49) 
            begin
                state <= b_in;
                timer <= 0;
            end
            else timer <= timer + 1;
        end

        b_in: begin   
            if (pBb) begin
                if (mapB[X*4 + Y]) begin
                    state <= error_b;
                    timer <= 0;
                end
                else begin
                    mapB[X*4 + Y] <= 1'b1;
                    if (input_count > 3'b010) begin
                        state <= show_score;
                        input_count <= 3'b0;
                        timer <= 0;
                    end
                    else begin
                        input_count <= input_count + 1'b1;
                    end
                end
            end
            else begin
                state <= b_in;
            end
        end


        error_b: begin
            if (timer == 49) 
            begin
                state <= b_in;
                timer <= 0;
            end
            else timer <= timer + 1;
        end

        show_score: begin  
            if (timer == 49) begin
                state <= a_shoot;
                timer <= 0;
            end
            else timer <= timer + 1;
        end

        a_shoot: begin     
            // Handle shooting logic based on pAb
            if (pAb) begin
                if (mapB[X*4 + Y]) begin
                mapB[X*4 + Y] <= 1'b0;
                scoreA <= scoreA + 1'b1;
                Z <= 1'b1;
                state <= a_sink;
                end
                else begin
                Z <= 1'b0;
                state <= a_sink;
                timer <= 0;
                end
            end
            else begin
                state <= a_shoot;
            end
        end


        a_sink: begin
        // Timer and state management
            if (timer == 49) begin
                timer <= 0;
                if (scoreA == 4) begin
                    state <= a_win;
                end
                else begin
                    state <= b_shoot;
                end
            end
            else begin
                timer <= timer + 1;
            end
        end

        b_shoot: begin
            // Handle the pBb condition
            if (pBb) begin
                if (mapA[X*4 + Y]) begin
                    mapA[X*4 + Y] <= 1'b0;
                    scoreB <= scoreB + 1'b1;
                    Z <= 1'b1;
                    state <= b_sink;
                end
                else begin 
                    Z <= 1'b0;
                    state <= b_sink;
                    timer <= 0;
                end 
            end
            else begin
                state <= b_shoot;
            end
        end


        b_sink: begin
            // Existing if-else logic for timer and state transitions
            if (timer == 49) begin
                timer <= 0;
                if (scoreB == 4) begin
                    state <= b_win;
                end
                else begin
                    state <= a_shoot;
                end
            end
            else begin
                timer <= timer + 1;
            end
        end

        a_win: begin
            timer <= timer + 1;
            if (timer == 49) begin
                blink <= blink + 1;
                timer <= 0;
            end
        end
        b_win: begin
            timer <= timer + 1;
            if (timer == 49) begin
                blink <= blink + 1;
                timer <= 0;
            end
        end


        default: state <= idle;
    endcase
  end
end
endmodule