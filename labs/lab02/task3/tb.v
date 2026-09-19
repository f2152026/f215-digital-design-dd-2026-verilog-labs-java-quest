module tb;
  reg [1:0] t_a, t_b;
  wire t_gt, t_lt, t_eq;
  reg exp_gt, exp_lt, exp_eq;
  integer a_value, b_value, errors, total;
  string vcd_file;

  comp2 DUT (.A(t_a), .B(t_b), .GT(t_gt), .LT(t_lt), .EQ(t_eq));

  initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, tb);
    end
    if ($test$plusargs("monitor"))
      $monitor("time=%0t A=%b B=%b | GT=%b LT=%b EQ=%b",
               $time, t_a, t_b, t_gt, t_lt, t_eq);
  end

  initial begin
    errors = 0;
    total = 0;
    for (a_value = 0; a_value < 4; a_value = a_value + 1) begin
      for (b_value = 0; b_value < 4; b_value = b_value + 1) begin
        t_a = a_value;
        t_b = b_value;
        exp_gt = (a_value > b_value);
        exp_lt = (a_value < b_value);
        exp_eq = (a_value == b_value);
        #5;
        total = total + 1;
        if ({t_gt, t_lt, t_eq} !== {exp_gt, exp_lt, exp_eq}) begin
          $display("FAIL at time %0t: A=%b B=%b got GT=%b LT=%b EQ=%b expected GT=%b LT=%b EQ=%b",
                   $time, t_a, t_b, t_gt, t_lt, t_eq, exp_gt, exp_lt, exp_eq);
          errors = errors + 1;
        end
      end
    end
    $write("Task 3: %0d/%0d passed", total - errors, total);
    $display("; errors=%0d", errors);
    if (errors != 0) $fatal(1, "Comparator checks failed");
    $finish;
  end
endmodule
