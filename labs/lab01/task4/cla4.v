// cla4.v
// (Carried forward from Task 3 -- paste in your completed, delay-annotated
// version.)
// Gate-level 4-bit carry-lookahead adder, matching the lecture circuit.
// Every gate needs an explicit delay (constant is fine here, e.g. #(2)) --
// this is the default from Task 2 onward, not a special step.
//
// TODO -- Step 1: generate/propagate signals (one xor + one and per bit)
//   p[i] = a[i] ^ b[i]
//   g[i] = a[i] & b[i]
//
// TODO -- Step 2: direct (non-recursive) carry equations. Verilog's and/or
// primitives accept more than 2 inputs directly, e.g.:
//   and #(2) (t2, p1, p0, g0);
// so you do not need to manually chain 2-input gates.
//   c1 = g0 + p0.cin
//   c2 = g1 + p1.g0 + p1.p0.cin
//   c3 = g2 + p2.g1 + p2.p1.g0 + p2.p1.p0.cin
//   c4 = g3 + p3.g2 + p3.p2.g1 + p3.p2.p1.g0 + p3.p2.p1.p0.cin
//
// TODO -- Step 3: sum bits
//   sum[i] = p[i] ^ c[i]     (c0 = cin)

module cla4(
  input  [3:0] a,
  input  [3:0] b,
  input        cin,
  output [3:0] sum,
  output       cout
);

  wire p0, p1, p2, p3;
  wire g0, g1, g2, g3;
  wire c1, c2, c3;

  // TODO: your gate-level P/G, carry, and sum logic goes here.
  // (cout should be connected to c4.) Remember the delay on every gate.

  wire t_c1;
  wire t_c2_1, t_c2_2;
  wire t_c3_1, t_c3_2, t_c3_3;
  wire t_c4_1, t_c4_2, t_c4_3, t_c4_4;

  xor #(2) x0 (p0, a[0], b[0]);
  xor #(2) x1 (p1, a[1], b[1]);
  xor #(2) x2 (p2, a[2], b[2]);
  xor #(2) x3 (p3, a[3], b[3]);

  and #(2) a0 (g0, a[0], b[0]);
  and #(2) a1 (g1, a[1], b[1]);
  and #(2) a2 (g2, a[2], b[2]);
  and #(2) a3 (g3, a[3], b[3]);

  // c1 = g0 + p0c0 here c0 = cin
  and #(2) and_c1 (t_c1, p0, cin);
  or #(2) or_c1 (c1, t_c1, g0);


  // c2 = g1 + p1g0 + p1p0c0
  and #(2) and_c2_1 (t_c2_1, p1, p0, cin);
  and #(2) and_c2_2 (t_c2_2, p1, g0);
  or #(2) or_c2 (c2, t_c2_1, t_c2_2, g1);

  // c3 = g2 + p2g1 + p2p1g0 + p2p1p0c0
  and #(2) and_c3_1 (t_c3_1, p2, p1, p0, cin);
  and #(2) and_c3_2 (t_c3_2, p2, p1, g0);
  and #(2) and_c3_3 (t_c3_3, p2, g1);
  or #(2) or_c3 (c3, t_c3_1, t_c3_2, t_c3_3, g2);

  // c4 = g3 + p3g2 + p3p2g1 + p3p2p1g0 + p3p2p1p0c0
  and #(2) and_c4_1 (t_c4_1, p3, p2, p1, p0, cin);
  and #(2) and_c4_2 (t_c4_2, p3, p2, p1, g0);
  and #(2) and_c4_3 (t_c4_3, p3, p2, g1);
  and #(2) and_c4_4 (t_c4_4, p3, g2);
  or #(2) or_c4 (cout, t_c4_1, t_c4_2, t_c4_3, t_c4_4, g3);

  xor #(2) sum0 (sum[0], p0, cin);
  xor #(2) sum1 (sum[1], p1, c1);
  xor #(2) sum2 (sum[2], p2, c2);
  xor #(2) sum3 (sum[3], p3, c3);

endmodule
