module comparator #(parameter width = 4)
		   (input logic zero,carry,
		    output logic hs,ls,hi,lo);

  or gate_or1 (z_or_c, zero, carry);
  not gate_not1 (not_c, carry);
  not gate_not2 (not_z_or_c, z_or_c);

  assign hs = carry;
  assign ls = z_or_c;
  assign hi = not_z_or_c;
  assign lo = not_c;

endmodule