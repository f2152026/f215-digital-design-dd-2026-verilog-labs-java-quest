// tb.v
// Check every address in an overridden 8-word ROM.

module tb;

  localparam WIDTH = 8;
  localparam DEPTH = 8;
  reg [$clog2(DEPTH)-1:0] t_sel;
  wire [WIDTH-1:0] t_dout;
  reg [WIDTH-1:0] expected;
  integer i, errors;

  lut #(.WIDTH(WIDTH), .DEPTH(DEPTH)) DUT (.sel(t_sel), .dout(t_dout));

  // Waveform dump configuration (DO NOT CHANGE)
  string vcd_file;
  initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, DUT);
    end
  end

  initial begin
    errors = 0;
    for (i = 0; i < DEPTH; i = i + 1) begin
      t_sel = i;
      expected = i * i;
      #5;
      if (t_dout !== expected) begin
        $display("FAIL at time %0t: sel=%0d got=%0d expected=%0d",
                 $time, t_sel, t_dout, expected);
        errors = errors + 1;
      end
    end
    $display("Task 2: %0d/%0d passed; errors=%0d", DEPTH-errors, DEPTH, errors);
    if (errors != 0) $fatal(1, "ROM checks failed");
    $finish;
  end

  initial
    $monitor($time, " sel=%0d | dout=%0d", t_sel, t_dout);

endmodule
