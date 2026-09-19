module and_beh_before #(parameter DELAY = 1) (
  input a,
  input b,
  output reg y
);
  always @(*) begin
    #DELAY y = a & b;
  end
endmodule
