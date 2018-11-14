`timescale 1ns/1ns

module int_fixed_point_mult_int
	(
		input signed [20:0] int_in, 
		input signed [9:0] fixed_X, 
		input signed [17:0] fixed_Y, 
		output signed [20:0] int_out
	);

	// here fixed_Y must be the binary representation of the integer to the right of the decimal point
	// accuracy of fixed point value is assumed to be 5 d.p. so divide by 10^5
	assign int_out = int_in * fixed_X + $rtoi((int_in * fixed_Y) / 100000);

endmodule

module int_fixed_point_div_int
	(
		input signed [20:0] int_in, 
		input signed [9:0] fixed_X, 
		input signed [17:0] fixed_Y, 
		output signed [20:0] int_out
	);

	assign int_out = int_in / fixed_X + $rtoi((int_in / fixed_Y) * 100000);

endmodule

// this module only to count through slices for a single frame
// int_in can be a max of 160 (8 bits), and both the int and fixed_point are positive, so no signed values required
// fixed point value is 0.375 at 160x120 resolution
// fixed_X_out can take a max value of 60 (field of view)
module int_fixed_point_mult_fixed_point
	(
		input [7:0] int_in,
		input fixed_X,
		input [2:0] fixed_Y,
		output [5:0] fixed_X_out,
		output reg [2:0] fixed_Y_out
	);
	
	// coincidence that the integer after the decimal point can be perfectly represented by 3 bits for all input cases
	// and that we only need 3 d.p. accuracy to perfectly represent all input cases in decimal
	assign fixed_X_out = (int_in * fixed_X) + $floor((int_in * fixed_Y) / 1000);
	assign fixed_Y_out = ((int_in * fixed_Y) / 1000 - $floor((int_in * fixed_Y) / 1000)) * 1000;
	
endmodule
