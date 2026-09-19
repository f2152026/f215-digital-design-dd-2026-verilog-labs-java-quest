// Exhaustively check both mux implementations with the same stimulus.

module tb;

  reg t_i0, t_i1, t_s;
  wire t_y;
  reg expected;
  integer i, errors;
  DUT DUT (.I0(t_i0), .I1(t_i1), .S(t_s), .Y(t_y));

  // Waveform dump configuration
  // Packed text storage permits this bench to run in Verilog-2005 too.
  reg [8*256-1:0] vcd_file;
  initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, DUT);
    end
  end

  initial begin
    errors = 0;
    for (i = 0; i < 8; i = i + 1) begin
      {t_i0, t_i1, t_s} = i;
      expected = t_s ? t_i1 : t_i0;
      #5;
      if (t_y !== expected) begin
        $display("FAIL at time %0t: I0=%b I1=%b S=%b got=%b expected=%b",
                 $time, t_i0, t_i1, t_s, t_y, expected);
        errors = errors + 1;
      end
    end
    $display("Task 1: %0d/8 passed; errors=%0d", 8-errors, errors);
    if (errors != 0) $fatal(1, "Mux checks failed");
    $finish;
  end

  initial
    $monitor($time, " I0=%b I1=%b S=%b | Y=%b", t_i0, t_i1, t_s, t_y);

endmodule
