module market_data_parser(
    input wire clk,
    input wire reset,
    input wire [31:0] data_in,
    input wire data_valid,
    output reg [15:0] symbol,
    output reg [15:0] price,
    output reg output_valid );

/* typedef enum logic [1:0] {
        IDLE = 2'b00,
        PARSE = 2'b01,
	OUTPUT = 2'b10 } state_t;   */

   reg [1:0] state_t;
   localparam IDLE = 2'b00, PARSE_HDR = 2'b01, OUTPUT = 2'b10;
	
    reg [1:0] state, next_state;
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            symbol <= 16'b0;
            price <= 16'b0;
            output_valid <= 1'b0;
        end else begin
            state <= next_state;
	    if (state == OUTPUT) output_valid <= 1'b1;
            else output_valid <= 1'b0;	
        end
    end

    // Next state and output logic
    always @(*) begin
        next_state = state;
        output_valid = 1'b0;
        
        case (state)
            IDLE: begin
                if (data_valid) begin
                    next_state = PARSE_HDR;
                end
            end
            PARSE_HDR: begin
                symbol = data_in[31:16]; // Extract symbol (bits 31-16)
                price = data_in[15:0];   // Extract price (bits 15-0)
                next_state = OUTPUT;
            end
            OUTPUT: begin
                output_valid = 1'b1;     // Signal valid output
                next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end
endmodule

