module market_data_parser_tb;
    // Inputs
    reg clk;
    reg reset;
    reg [31:0] data_in;
    reg data_valid;
    
    // Outputs
    wire [15:0] symbol;
    wire [15:0] price;
    wire output_valid;
    
    // Instantiate the module
    market_data_parser uut (
        .clk(clk),
        .reset(reset),
        .data_in(data_in),
        .data_valid(data_valid),
        .symbol(symbol),
        .price(price),
        .output_valid(output_valid)
    );
    
    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100 MHz clock (10ns period)
    end
    
    // Test stimulus
    initial begin
        // Initialize signals
        reset = 1;
        data_in = 32'b0;
        data_valid = 0;
        
        // Reset
        #20 reset = 0;
        
        // Test case 1: Valid packet
        #10 data_in = 32'h41424344; // Symbol "AB" (0x4142), Price 17220 (0x4344)
        data_valid = 1;
        #20 data_valid = 0;
        
        // Test case 2: Another packet
        #20 data_in = 32'h58475955; // Symbol "XY" (0x5847), Price 18773 (0x5955)
        data_valid = 1;
        #20 data_valid = 0;

        #20 data_in = 32'h58548940; // Symbol "XY" (0x5847), Price 18773 (0x5955)
        data_valid = 1;
        #20 data_valid = 0;
        

        #20 data_in = 32'h58475540; // Symbol "XY" (0x5847), Price 18773 (0x5955)
        data_valid = 1;
        #20 data_valid = 0;

        #20 data_in = 32'h58475860; // Symbol "XY" (0x5847), Price 18773 (0x5955)
        data_valid = 1;
        #20 data_valid = 0;
        
        // End simulation
        #100 $finish;
    end
    
    // Monitor outputs
    initial begin
        $monitor("Time=%0t, State=%b, Symbol=%h, Price=%h, Output_Valid=%b",
                 $time, uut.state, symbol, price, output_valid);
    end
endmodule
