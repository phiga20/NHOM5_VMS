module tb_aes_128_ofb;

    // Inputs
    reg clk = 0;
    reg rst_n = 0;
    reg ld = 0;
    reg mode = 0;
    reg [127:0] key = 128'h00000000000000000000000000000000;
    reg [127:0] iv = 128'h00000000000000000000000000000000;
    reg [127:0] data_in = 128'h00112233445566778899aabbccddeeff;

    // Outputs
    wire ofb_done;
    wire [127:0] data_out;

    // Instantiate the Unit Under Test (UUT)
    aes_128_ofb uut (
        .clk(clk),
        .rst_n(rst_n),
        .ld(ld),
        .mode(mode),
        .ofb_done(ofb_done),
        .key(key),
        .iv(iv),
        .data_in(data_in),
        .data_out(data_out)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        // Monitor signals for debugging
        $monitor("Time = %0t: rst_n = %b, ld = %b, mode = %b, ofb_done = %b, data_out = %h", 
                 $time, rst_n, ld, mode, ofb_done, data_out);

        // Initialize Inputs
        clk = 0;
        rst_n = 0;
        ld = 0;
        mode = 0;
        key = 128'h00000000000000000000000000000000;
        iv = 128'h00000000000000000000000000000000;
        data_in = 128'h00112233445566778899aabbccddeeff;

        // Reset
        #10 rst_n = 1;

        // Load IV
        #10 ld = 1;
        #10 ld = 0;

        // Wait for some time
        #50;

        // Test encryption mode
        mode = 0;
        key = 128'h31313131313131313131313131313131;
        iv = 128'h41414141414141414141414141414141;
        data_in = 128'h00112233445566778899aabbccddeeff;

        // Load data
        #10 ld = 1;
        #10 ld = 0;

        // Wait for encryption to complete
        wait(ofb_done);
        #10; // Wait a bit for stability

        // Check encryption result
        $display("Encryption Output: %h", data_out);

        // Test decryption mode
        mode = 1;
        // Use the output from encryption as input for decryption
        data_in = data_out;

        // Load data
        #10 ld = 1;
        #10 ld = 0;

        // Wait for decryption to complete
        wait(ofb_done);
        #10; // Wait a bit for stability

        // Check decryption result
        $display("Decryption Output: %h", data_out);
     
        // Finish simulation
        $finish;
    end

endmodule


