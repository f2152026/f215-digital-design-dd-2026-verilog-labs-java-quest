module tb;
  reg [3:0] t_a, t_b;
  reg t_op;
  wire [3:0] t_result;
  reg [3:0] expected;
  integer a_value, b_value, errors, total;
  string vcd_file;

  alu DUT (.a(t_a), .b(t_b), .op(t_op), .result(t_result));

  initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, tb);
    end
    if ($test$plusargs("monitor"))
      $monitor("time=%0t a=%d b=%d op=%b | result=%d",
               $time, t_a, t_b, t_op, t_result);
  end

  task check;
    input [3:0] next_a, next_b;
    input next_op;
    begin
      t_a = next_a;
      t_b = next_b;
      t_op = next_op;
      // Assignment to four bits models arithmetic modulo 16.
      expected = next_op ? (next_a - next_b) : (next_a + next_b);
      #5;
      total = total + 1;
      if (t_result !== expected) begin
        $display("FAIL at time %0t: a=%0d b=%0d op=%b got=%b expected=%b",
                 $time, t_a, t_b, t_op, t_result, expected);
        errors = errors + 1;
      end
    end
  endtask

  initial begin
    errors = 0;
    total = 0;
    // Only op changes in the next two transitions.
    check(9, 3, 0);
    check(9, 3, 1);
    check(9, 3, 0);
    // Subtraction with changing operands exposes stale intermediate values.
    check(7, 2, 1);
    check(12, 5, 1);
    check(3, 6, 1);
    // Every operand pair, both operations, and both directions of op change.
    for (a_value = 0; a_value < 16; a_value = a_value + 1) begin
      for (b_value = 0; b_value < 16; b_value = b_value + 1) begin
        check(a_value, b_value, 0);
        check(a_value, b_value, 1);
        check(a_value, b_value, 0);
      end
    end
    // Also sweep operands while holding subtraction selected.
    for (a_value = 0; a_value < 16; a_value = a_value + 1)
      for (b_value = 0; b_value < 16; b_value = b_value + 1)
        check(a_value, b_value, 1);
    $write("Task 5: %0d/%0d passed", total - errors, total);
    $display("; errors=%0d", errors);
    if (errors != 0) $fatal(1, "ALU checks failed");
    $finish;
  end
endmodule
