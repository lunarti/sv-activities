module comparator #(parameter width = 4)
		   (input logic zero,carry,
		    output logic hs,ls,hi,lo);

  and gate_or1 (ls_or, zero, carry);
  not gate_not1 (lo_not, carry);
  not gate_not2 (hi_not, ls_or);

  assign hs = carry;
  assign ls = ls_or;
  assign hi = hi_not;
  assign lo = lo_not;

endmodule