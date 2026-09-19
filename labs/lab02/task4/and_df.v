// Set DELAY to 1, 2, or 3 at elaboration for the three experiments.
module and_df #(parameter DELAY = 1) (
  input a,
  input b,
  output wire y
);
  assign #DELAY y = a & b;
endmodule
