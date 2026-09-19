module and_beh_intra #(parameter DELAY = 1) (
  input a,
  input b,
  output reg y
);
  always @(*) begin
    y = #DELAY a & b;
  end
endmodule
