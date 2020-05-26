module FloatingPointAdder (A, B, C, overflow);

input wire [7:0] A, B;
output wire [7:0] C;
output wire overflow;

wire sign_A, sign_B, sign_C;
wire [2:0] exp_A, exp_B, exp_C;
wire [3:0] frac_A, frac_B, frac_C;
wire [4:0] frac_A_with_one, frac_B_with_one;
wire [4:0] frac_A_shifted, frac_B_shifted;
wire [4:0] frac_A_2s_comp, frac_B_2s_comp;
wire [5:0] frac_C_pre_2s;
wire [4:0] frac_C_2s;
wire [5:0] frac_c_pre_shift;
wire [2:0] exp_C_pre_shift;
wire [7:0] pre_C;

wire [2:0] small_shift_num;
wire frac_shift_sel;
wire convert_2s_comp;
wire result_right_shift_num;
wire [2:0] result_left_shift_num;
wire zero_result;

//divide floating point number as three parts
assign sign_A = A[7];
assign sign_B = B[7];
assign pre_C[7] = sign_C;
assign exp_A = A[6:4];
assign exp_B = B[6:4];
assign pre_C[6:4] = exp_C;
assign frac_A = A[3:0];
assign frac_B = B[3:0];
assign pre_C[3:0] = frac_C;
assign frac_A_with_one = (exp_A != 0) ? {1'b1, frac_A} :  {1'b0, frac_A};
assign frac_B_with_one = (exp_B != 0) ? {1'b1, frac_B} :  {1'b0, frac_B};


//compare two exponents
assign small_shift_num = (exp_B > exp_A) ? (exp_B - exp_A) : (exp_A - exp_B);
assign frac_shift_sel = (exp_B > exp_A) ? 1 : 0;	// 1 for B 
assign exp_C_pre_shift = frac_shift_sel ? exp_B : exp_A;

//right shift the fraction part of the smaller number
assign frac_A_shifted = frac_shift_sel ? (frac_A_with_one >> small_shift_num) : frac_A_with_one;
assign frac_B_shifted = frac_shift_sel ? frac_B_with_one : (frac_B_with_one >> small_shift_num);

//compute the 2's complement of negative sign-magnitude number
assign convert_2s_comp = (sign_A ^ sign_B) && (frac_A_shifted != 0) && (frac_B_shifted != 0);
assign frac_A_2s_comp = (convert_2s_comp & sign_A) ? (~frac_A_shifted + 1) : frac_A_shifted;
assign frac_B_2s_comp = (convert_2s_comp & sign_B) ? (~frac_B_shifted + 1) : frac_B_shifted;

//add two fractions and convert back to sign-magnitude number
assign frac_C_pre_2s = frac_A_2s_comp + frac_B_2s_comp;
assign sign_C = convert_2s_comp ? (~frac_C_pre_2s[5]) : ((frac_A_shifted != 0) ? sign_A : ((frac_B_shifted != 0) ? sign_B : sign_B));
assign frac_C_2s = frac_C_pre_2s[5] ? frac_C_pre_2s[4:0] : (~frac_C_pre_2s[4:0] + 1);
assign frac_c_pre_shift = convert_2s_comp ? {1'b0, frac_C_2s}: frac_C_pre_2s;

//shift the number back to normalized numbers
assign result_right_shift_num = frac_c_pre_shift[5];
assign result_left_shift_num = (frac_c_pre_shift[5] != 0) ? 0 : ((frac_c_pre_shift[4] != 0) ? 0 : ((frac_c_pre_shift[3] != 0) ? 1 : ((frac_c_pre_shift[2] != 0) ? 2 : ((frac_c_pre_shift[1] != 0) ? 3 : 4) ) ) );
assign zero_result = ((result_left_shift_num == 4) && (frac_c_pre_shift[0] == 0));
assign exp_C = result_right_shift_num ? (exp_C_pre_shift + 1) : ((exp_C_pre_shift > result_left_shift_num) ? (exp_C_pre_shift - result_left_shift_num) : 0);
assign frac_C = result_right_shift_num ? frac_c_pre_shift[4:1] : ((exp_C_pre_shift > result_left_shift_num) ? (frac_c_pre_shift[3:0] << result_left_shift_num) : 0);

//handle the cases of zero and NaN
assign C = (exp_A == 7) ? A : ((exp_B == 7) ? B : (zero_result ? 0 : pre_C) );
assign overflow = (result_right_shift_num == 1) && (exp_C_pre_shift == 6);

endmodule
