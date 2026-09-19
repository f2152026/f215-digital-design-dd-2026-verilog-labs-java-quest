module FA_Gate(
  input  a,
  input  b,
  input  cin,
  output sum,
  output cout
);
  wire ps, pc1, pc2;

  xor #(1, 2) (ps,  a,   b);
  and #(1, 2) (pc1, a,   b);
  xor #(1, 2) (sum, cin, ps);
  and #(1, 2) (pc2, cin, ps);
  or  #(1, 2) (cout, pc1, pc2);

endmodule
