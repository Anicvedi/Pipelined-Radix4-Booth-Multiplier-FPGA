`timescale 1ns / 1ps

module booth_radix4_csa_multiplier (
    input  wire        clk,
    input  wire        rst,
    input  wire signed [7:0] multiplicand,
    input  wire signed [7:0] multiplier,
    output reg  signed [15:0] product
);

    reg signed [7:0] A_reg, B_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            A_reg <= 8'sd0;
            B_reg <= 8'sd0;
        end else begin
            A_reg <= multiplicand;
            B_reg <= multiplier;
        end
    end

    // Extend multiplier
    wire [8:0] B_ext = {B_reg, 1'b0};

    // Partial Products
    wire signed [15:0] pp0, pp1, pp2, pp3;

    booth_encoder_radix4 be0 (.A(A_reg), .code(B_ext[2:0]), .pp(pp0));
    booth_encoder_radix4 be1 (.A(A_reg), .code(B_ext[4:2]), .pp(pp1));
    booth_encoder_radix4 be2 (.A(A_reg), .code(B_ext[6:4]), .pp(pp2));
    booth_encoder_radix4 be3 (.A(A_reg), .code(B_ext[8:6]), .pp(pp3));

    // Shifting
    wire signed [17:0] pp0e = {{2{pp0[15]}}, pp0} <<< 0;
    wire signed [17:0] pp1e = {{2{pp1[15]}}, pp1} <<< 2;
    wire signed [17:0] pp2e = {{2{pp2[15]}}, pp2} <<< 4;
    wire signed [17:0] pp3e = {{2{pp3[15]}}, pp3} <<< 6;

    // CSA Stage 1
    wire [17:0] sum1, carry1;
    csa3 csa_stage1 (
        .a(pp0e),
        .b(pp1e),
        .c(pp2e),
        .sum(sum1),
        .carry(carry1)
    );

    // CSA Stage 2
    wire [17:0] sum2, carry2;
    csa3 csa_stage2 (
        .a(sum1),
        .b(carry1 << 1),
        .c(pp3e),
        .sum(sum2),
        .carry(carry2)
    );

    // Final Ripple Add
    wire [17:0] final_sum = sum2 + (carry2 << 1);

    always @(posedge clk or posedge rst) begin
        if (rst)
            product <= 16'sd0;
        else
            product <= final_sum[15:0];
    end

endmodule
