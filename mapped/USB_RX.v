/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : K-2015.06-SP1
// Date      : Wed Nov 20 17:00:39 2019
/////////////////////////////////////////////////////////////


module RX_ControlFSM ( clk, n_rst, eop, decoded_bit, pass_5_bit, pass_16_bit, 
        byte_done, sr_val, shift_en, en_buffer, RX_PID, clear_crc, 
        clear_byte_count );
  input [15:0] sr_val;
  output [2:0] RX_PID;
  input clk, n_rst, eop, decoded_bit, pass_5_bit, pass_16_bit, byte_done,
         shift_en;
  output en_buffer, clear_crc, clear_byte_count;
  wire   N136, N137, N138, N139, N140, N147, N149, N150, N158, N161, n114,
         n115, n116, n117, n118, n119, n120, n121, n122, n123, n12, n13, n14,
         n15, n16, n17, n18, n19, n20, n21, n22, n23, n24, n25, n26, n27, n28,
         n29, n30, n31, n32, n33, n34, n35, n36, n37, n38, n39, n40, n41, n42,
         n43, n44, n45, n46, n47, n48, n49, n50, n51, n52, n53, n54, n55, n56,
         n57, n58, n59, n60, n61, n62, n63, n64, n65, n66, n67, n68, n69, n70,
         n71, n72, n73, n74, n75, n76, n77, n78, n79, n80, n81, n82, n83, n84,
         n85, n86, n87, n88, n89, n90, n91, n92, n93, n94, n95, n96, n97, n98,
         n99, n100, n101, n102, n103, n104, n105, n106, n107, n108, n109, n110,
         n111, n112, n113, n124, n125, n126, n127, n128, n129, n130, n131,
         n132, n133, n134, n135, n136, n137, n138, n139, n140, n141, n142,
         n143, n144, n145, n146, n147, n148, n149, n150, n151, n152, n153,
         n154, n155, n156, n157, n158, n159, n160, n161, n162, n163, n164,
         n165, n166, n167, n168, n169, n170, n171, n172, n173, n174, n175,
         n176, n177, n178, n179, n180, n181, n182, n183, n184, n185, n186,
         n187, n188, n189, n190, n191, n192, n193;
  wire   [4:0] next_state;
  wire   [4:0] state;
  wire   [2:0] PID;

  DFFSR \state_reg[0]  ( .D(n123), .CLK(clk), .R(n_rst), .S(1'b1), .Q(state[0]) );
  DFFSR \state_reg[4]  ( .D(n122), .CLK(clk), .R(n_rst), .S(1'b1), .Q(state[4]) );
  DFFSR \state_reg[3]  ( .D(n121), .CLK(clk), .R(n_rst), .S(1'b1), .Q(state[3]) );
  DFFSR \state_reg[2]  ( .D(n120), .CLK(clk), .R(n_rst), .S(1'b1), .Q(state[2]) );
  DFFSR \state_reg[1]  ( .D(n119), .CLK(clk), .R(n_rst), .S(1'b1), .Q(state[1]) );
  DFFSR \PID_reg[2]  ( .D(n116), .CLK(clk), .R(n_rst), .S(1'b1), .Q(PID[2]) );
  DFFSR \PID_reg[0]  ( .D(n117), .CLK(clk), .R(n_rst), .S(1'b1), .Q(PID[0]) );
  DFFSR \PID_reg[1]  ( .D(n118), .CLK(clk), .R(n_rst), .S(1'b1), .Q(PID[1]) );
  DFFSR \RX_PID_reg[2]  ( .D(n114), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        RX_PID[2]) );
  DFFSR \RX_PID_reg[1]  ( .D(n191), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        RX_PID[1]) );
  DFFSR \RX_PID_reg[0]  ( .D(n115), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        RX_PID[0]) );
  AND2X2 U4 ( .A(n83), .B(n24), .Y(n12) );
  NOR2X1 U15 ( .A(n74), .B(n73), .Y(n13) );
  INVX2 U16 ( .A(state[2]), .Y(n193) );
  INVX2 U17 ( .A(state[3]), .Y(n192) );
  NOR2X1 U18 ( .A(n105), .B(state[0]), .Y(n67) );
  NAND2X1 U19 ( .A(N158), .B(n67), .Y(n69) );
  NOR2X1 U20 ( .A(n94), .B(n86), .Y(n52) );
  OAI22X1 U21 ( .A(n69), .B(state[4]), .C(n77), .D(n75), .Y(n14) );
  XNOR2X1 U22 ( .A(state[0]), .B(n76), .Y(n60) );
  NAND3X1 U23 ( .A(n52), .B(n76), .C(N147), .Y(n15) );
  OAI21X1 U24 ( .A(n192), .B(n60), .C(n15), .Y(n23) );
  NOR2X1 U25 ( .A(n105), .B(n100), .Y(n58) );
  NAND2X1 U26 ( .A(n58), .B(n91), .Y(n50) );
  OAI21X1 U27 ( .A(state[4]), .B(n190), .C(n81), .Y(n21) );
  OAI21X1 U28 ( .A(n85), .B(n190), .C(state[4]), .Y(n18) );
  NAND3X1 U29 ( .A(n76), .B(n192), .C(N136), .Y(n17) );
  OAI21X1 U30 ( .A(n192), .B(N161), .C(n93), .Y(n16) );
  NAND3X1 U31 ( .A(n18), .B(n17), .C(n16), .Y(n19) );
  NAND3X1 U32 ( .A(n78), .B(n105), .C(n19), .Y(n20) );
  NAND2X1 U33 ( .A(n21), .B(n20), .Y(n22) );
  AOI21X1 U34 ( .A(n23), .B(state[1]), .C(n22), .Y(n24) );
  NOR2X1 U35 ( .A(n100), .B(state[1]), .Y(n39) );
  XNOR2X1 U36 ( .A(n92), .B(n89), .Y(n31) );
  NOR2X1 U37 ( .A(n75), .B(n105), .Y(n26) );
  OAI21X1 U38 ( .A(N137), .B(state[0]), .C(n193), .Y(n30) );
  NOR2X1 U39 ( .A(state[1]), .B(n30), .Y(n25) );
  AOI22X1 U40 ( .A(n26), .B(n189), .C(n25), .D(n31), .Y(n27) );
  OAI21X1 U41 ( .A(n79), .B(n31), .C(n27), .Y(n29) );
  OAI22X1 U42 ( .A(n93), .B(n77), .C(n88), .D(n69), .Y(n28) );
  NOR2X1 U43 ( .A(n29), .B(n28), .Y(n37) );
  NOR2X1 U44 ( .A(n76), .B(n105), .Y(n35) );
  NAND2X1 U45 ( .A(n31), .B(n84), .Y(n33) );
  OAI21X1 U46 ( .A(state[4]), .B(n88), .C(n67), .Y(n32) );
  OAI21X1 U47 ( .A(n79), .B(n33), .C(n32), .Y(n34) );
  AOI22X1 U48 ( .A(n35), .B(n75), .C(n34), .D(eop), .Y(n36) );
  OAI21X1 U49 ( .A(state[4]), .B(n37), .C(n36), .Y(next_state[1]) );
  NOR2X1 U50 ( .A(n94), .B(n76), .Y(n38) );
  OAI21X1 U51 ( .A(n39), .B(n67), .C(n38), .Y(n49) );
  NOR2X1 U52 ( .A(n87), .B(state[4]), .Y(n47) );
  NOR2X1 U53 ( .A(state[0]), .B(state[1]), .Y(n66) );
  AND2X1 U54 ( .A(n193), .B(n66), .Y(n40) );
  AOI22X1 U55 ( .A(n40), .B(N139), .C(N150), .D(n58), .Y(n41) );
  NAND2X1 U56 ( .A(n41), .B(n50), .Y(n46) );
  NAND3X1 U57 ( .A(n91), .B(n100), .C(N161), .Y(n42) );
  OAI21X1 U58 ( .A(n90), .B(n100), .C(n42), .Y(n43) );
  AOI21X1 U59 ( .A(state[1]), .B(n190), .C(n43), .Y(n44) );
  NAND3X1 U60 ( .A(n77), .B(n76), .C(n44), .Y(n45) );
  AOI22X1 U61 ( .A(n47), .B(n46), .C(n45), .D(n87), .Y(n48) );
  OAI21X1 U62 ( .A(eop), .B(n49), .C(n48), .Y(next_state[3]) );
  OAI21X1 U63 ( .A(n50), .B(n192), .C(n49), .Y(n51) );
  OAI21X1 U64 ( .A(n90), .B(n192), .C(n193), .Y(n56) );
  AOI22X1 U65 ( .A(N140), .B(n66), .C(n188), .D(n58), .Y(n54) );
  NAND2X1 U66 ( .A(n52), .B(n76), .Y(n53) );
  NOR2X1 U67 ( .A(n54), .B(n53), .Y(n55) );
  AOI21X1 U68 ( .A(n56), .B(state[4]), .C(n55), .Y(n57) );
  OAI21X1 U69 ( .A(n80), .B(n190), .C(n57), .Y(next_state[4]) );
  NAND2X1 U70 ( .A(n76), .B(n193), .Y(n64) );
  OAI21X1 U71 ( .A(n86), .B(N149), .C(n58), .Y(n63) );
  AOI22X1 U72 ( .A(N138), .B(n100), .C(state[0]), .D(n190), .Y(n59) );
  OAI21X1 U73 ( .A(n60), .B(n59), .C(n193), .Y(n61) );
  NAND3X1 U74 ( .A(n192), .B(n105), .C(n61), .Y(n62) );
  OAI21X1 U75 ( .A(n64), .B(n63), .C(n62), .Y(n74) );
  NOR2X1 U76 ( .A(n87), .B(n76), .Y(n65) );
  AOI21X1 U77 ( .A(n65), .B(n67), .C(n81), .Y(n72) );
  AOI22X1 U78 ( .A(n85), .B(n67), .C(n66), .D(N161), .Y(n68) );
  NAND2X1 U79 ( .A(n69), .B(n76), .Y(n70) );
  OAI21X1 U80 ( .A(n82), .B(n70), .C(n93), .Y(n71) );
  OAI21X1 U81 ( .A(eop), .B(n72), .C(n71), .Y(n73) );
  INVX2 U82 ( .A(n52), .Y(n75) );
  INVX2 U83 ( .A(state[4]), .Y(n76) );
  INVX2 U84 ( .A(n67), .Y(n77) );
  INVX2 U85 ( .A(n60), .Y(n78) );
  INVX2 U86 ( .A(n39), .Y(n79) );
  INVX2 U87 ( .A(n51), .Y(n80) );
  INVX2 U88 ( .A(n50), .Y(n81) );
  INVX2 U89 ( .A(n68), .Y(n82) );
  INVX2 U90 ( .A(n14), .Y(n83) );
  INVX2 U91 ( .A(n30), .Y(n84) );
  INVX2 U92 ( .A(n192), .Y(n85) );
  INVX2 U93 ( .A(n192), .Y(n86) );
  INVX2 U94 ( .A(n192), .Y(n87) );
  INVX2 U95 ( .A(n192), .Y(n88) );
  INVX2 U96 ( .A(n192), .Y(n89) );
  INVX2 U97 ( .A(n193), .Y(n90) );
  INVX2 U98 ( .A(n193), .Y(n91) );
  INVX2 U99 ( .A(n193), .Y(n92) );
  INVX2 U100 ( .A(n193), .Y(n93) );
  INVX2 U101 ( .A(n193), .Y(n94) );
  OAI21X1 U102 ( .A(n95), .B(n96), .C(n97), .Y(n191) );
  AOI21X1 U103 ( .A(RX_PID[1]), .B(n98), .C(n99), .Y(n97) );
  MUX2X1 U104 ( .B(n12), .A(n100), .S(n101), .Y(n123) );
  MUX2X1 U105 ( .B(n102), .A(n76), .S(n101), .Y(n122) );
  INVX1 U106 ( .A(next_state[4]), .Y(n102) );
  MUX2X1 U107 ( .B(n103), .A(n192), .S(n101), .Y(n121) );
  INVX1 U108 ( .A(next_state[3]), .Y(n103) );
  MUX2X1 U109 ( .B(n13), .A(n193), .S(n101), .Y(n120) );
  MUX2X1 U110 ( .B(n104), .A(n105), .S(n101), .Y(n119) );
  NAND3X1 U111 ( .A(n106), .B(n107), .C(n108), .Y(n101) );
  AOI22X1 U112 ( .A(n109), .B(n110), .C(en_buffer), .D(n190), .Y(n108) );
  OAI21X1 U113 ( .A(state[0]), .B(n111), .C(n112), .Y(n109) );
  NAND3X1 U114 ( .A(n113), .B(n124), .C(n125), .Y(n107) );
  INVX1 U115 ( .A(shift_en), .Y(n124) );
  NAND3X1 U116 ( .A(state[2]), .B(n76), .C(n126), .Y(n106) );
  OAI21X1 U117 ( .A(shift_en), .B(n127), .C(n128), .Y(n126) );
  NAND3X1 U118 ( .A(n105), .B(n192), .C(n110), .Y(n128) );
  INVX1 U119 ( .A(byte_done), .Y(n110) );
  AOI21X1 U120 ( .A(state[3]), .B(n100), .C(state[1]), .Y(n127) );
  INVX1 U121 ( .A(next_state[1]), .Y(n104) );
  MUX2X1 U122 ( .B(n129), .A(n96), .S(n130), .Y(n118) );
  INVX1 U123 ( .A(PID[1]), .Y(n96) );
  MUX2X1 U124 ( .B(n131), .A(n132), .S(n130), .Y(n117) );
  INVX1 U125 ( .A(PID[0]), .Y(n132) );
  NOR2X1 U126 ( .A(N147), .B(n133), .Y(n131) );
  MUX2X1 U127 ( .B(n134), .A(n135), .S(n130), .Y(n116) );
  INVX1 U128 ( .A(PID[2]), .Y(n135) );
  NOR2X1 U129 ( .A(n189), .B(n188), .Y(n134) );
  INVX1 U130 ( .A(n136), .Y(n188) );
  INVX1 U131 ( .A(n137), .Y(n189) );
  NAND3X1 U132 ( .A(n138), .B(n112), .C(n139), .Y(n115) );
  AOI22X1 U133 ( .A(RX_PID[0]), .B(n98), .C(PID[0]), .D(n140), .Y(n139) );
  INVX1 U134 ( .A(n141), .Y(n112) );
  NAND3X1 U135 ( .A(state[1]), .B(state[0]), .C(n125), .Y(n138) );
  INVX1 U136 ( .A(n142), .Y(n125) );
  NAND3X1 U137 ( .A(n143), .B(n144), .C(n145), .Y(n114) );
  AOI22X1 U138 ( .A(RX_PID[2]), .B(n98), .C(PID[2]), .D(n140), .Y(n145) );
  INVX1 U139 ( .A(n95), .Y(n140) );
  NAND3X1 U140 ( .A(state[3]), .B(n100), .C(n146), .Y(n95) );
  INVX1 U141 ( .A(n147), .Y(n98) );
  NAND3X1 U142 ( .A(n143), .B(n144), .C(n148), .Y(n147) );
  AOI21X1 U143 ( .A(n146), .B(n100), .C(n141), .Y(n148) );
  NOR2X1 U144 ( .A(n149), .B(state[2]), .Y(n141) );
  INVX1 U145 ( .A(n150), .Y(n146) );
  OR2X1 U146 ( .A(n142), .B(n113), .Y(n144) );
  XOR2X1 U147 ( .A(n105), .B(n100), .Y(n113) );
  NAND3X1 U148 ( .A(n193), .B(n192), .C(state[4]), .Y(n142) );
  INVX1 U149 ( .A(n99), .Y(n143) );
  NOR2X1 U150 ( .A(n149), .B(n193), .Y(n99) );
  NAND3X1 U151 ( .A(state[0]), .B(state[3]), .C(n151), .Y(n149) );
  NOR2X1 U152 ( .A(state[4]), .B(state[1]), .Y(n151) );
  INVX1 U153 ( .A(n152), .Y(en_buffer) );
  NAND3X1 U154 ( .A(state[0]), .B(state[3]), .C(n153), .Y(n152) );
  AOI21X1 U155 ( .A(n129), .B(n154), .C(n130), .Y(clear_crc) );
  NAND3X1 U156 ( .A(state[0]), .B(n192), .C(n153), .Y(n130) );
  INVX1 U157 ( .A(n111), .Y(n153) );
  NAND3X1 U158 ( .A(n193), .B(n76), .C(state[1]), .Y(n111) );
  NOR2X1 U159 ( .A(n150), .B(n155), .Y(clear_byte_count) );
  NAND2X1 U160 ( .A(state[0]), .B(n192), .Y(n155) );
  NAND3X1 U161 ( .A(n193), .B(n76), .C(n105), .Y(n150) );
  NAND2X1 U162 ( .A(pass_16_bit), .B(eop), .Y(N161) );
  NOR2X1 U163 ( .A(n156), .B(n157), .Y(N158) );
  NAND3X1 U164 ( .A(n158), .B(pass_5_bit), .C(n159), .Y(n157) );
  AND2X1 U165 ( .A(n160), .B(n161), .Y(n159) );
  NOR2X1 U166 ( .A(sr_val[14]), .B(sr_val[13]), .Y(n161) );
  NOR2X1 U167 ( .A(sr_val[12]), .B(sr_val[11]), .Y(n160) );
  NOR2X1 U168 ( .A(sr_val[10]), .B(n190), .Y(n158) );
  INVX1 U169 ( .A(eop), .Y(n190) );
  NAND3X1 U170 ( .A(n162), .B(n163), .C(n164), .Y(n156) );
  NOR2X1 U171 ( .A(sr_val[15]), .B(n165), .Y(n164) );
  OR2X1 U172 ( .A(sr_val[4]), .B(sr_val[5]), .Y(n165) );
  NOR2X1 U173 ( .A(sr_val[9]), .B(sr_val[8]), .Y(n163) );
  NOR2X1 U174 ( .A(sr_val[7]), .B(sr_val[6]), .Y(n162) );
  NAND2X1 U175 ( .A(n154), .B(n137), .Y(N150) );
  NAND2X1 U176 ( .A(n129), .B(n137), .Y(N149) );
  NAND3X1 U177 ( .A(n166), .B(n167), .C(n168), .Y(n137) );
  AOI21X1 U178 ( .A(n168), .B(n169), .C(n133), .Y(n129) );
  INVX1 U179 ( .A(n170), .Y(n133) );
  NAND3X1 U180 ( .A(sr_val[7]), .B(n171), .C(n169), .Y(n170) );
  NOR2X1 U181 ( .A(n172), .B(n173), .Y(n169) );
  NAND3X1 U182 ( .A(sr_val[1]), .B(sr_val[2]), .C(sr_val[4]), .Y(n173) );
  NAND3X1 U183 ( .A(n174), .B(n175), .C(n176), .Y(n172) );
  INVX1 U184 ( .A(sr_val[5]), .Y(n174) );
  NOR2X1 U185 ( .A(n171), .B(sr_val[7]), .Y(n168) );
  NAND2X1 U186 ( .A(n154), .B(n136), .Y(N147) );
  NAND3X1 U187 ( .A(n167), .B(n171), .C(n177), .Y(n136) );
  AND2X1 U188 ( .A(n166), .B(sr_val[7]), .Y(n177) );
  INVX1 U189 ( .A(n178), .Y(n166) );
  OR2X1 U190 ( .A(n179), .B(n180), .Y(n154) );
  NAND3X1 U191 ( .A(n167), .B(n181), .C(sr_val[4]), .Y(n180) );
  XOR2X1 U192 ( .A(sr_val[7]), .B(sr_val[3]), .Y(n181) );
  AND2X1 U193 ( .A(sr_val[5]), .B(sr_val[2]), .Y(n167) );
  NAND3X1 U194 ( .A(n182), .B(n175), .C(n176), .Y(n179) );
  INVX1 U195 ( .A(sr_val[0]), .Y(n176) );
  INVX1 U196 ( .A(sr_val[6]), .Y(n175) );
  NOR2X1 U197 ( .A(n183), .B(n76), .Y(N140) );
  NOR2X1 U198 ( .A(n192), .B(n183), .Y(N139) );
  NOR2X1 U199 ( .A(n193), .B(n183), .Y(N138) );
  NOR2X1 U200 ( .A(n183), .B(n105), .Y(N137) );
  INVX1 U201 ( .A(state[1]), .Y(n105) );
  INVX1 U202 ( .A(n184), .Y(n183) );
  NAND2X1 U203 ( .A(n100), .B(n184), .Y(N136) );
  NAND3X1 U204 ( .A(n185), .B(n171), .C(n186), .Y(n184) );
  NOR2X1 U205 ( .A(sr_val[2]), .B(n178), .Y(n186) );
  NAND3X1 U206 ( .A(sr_val[0]), .B(n182), .C(n187), .Y(n178) );
  NOR2X1 U207 ( .A(sr_val[6]), .B(sr_val[4]), .Y(n187) );
  INVX1 U208 ( .A(sr_val[1]), .Y(n182) );
  INVX1 U209 ( .A(sr_val[3]), .Y(n171) );
  NOR2X1 U210 ( .A(sr_val[7]), .B(sr_val[5]), .Y(n185) );
  INVX1 U211 ( .A(state[0]), .Y(n100) );
endmodule


module flex_stp_sr_NUM_BITS16_SHIFT_MSB1 ( clk, n_rst, shift_enable, serial_in, 
        parallel_out );
  output [15:0] parallel_out;
  input clk, n_rst, shift_enable, serial_in;
  wire   n20, n22, n24, n26, n28, n30, n32, n34, n36, n38, n40, n42, n44, n46,
         n48, n50, n1, n2, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12, n13, n14,
         n15, n16;

  DFFSR \parallel_out_reg[0]  ( .D(n50), .CLK(clk), .R(1'b1), .S(n_rst), .Q(
        parallel_out[0]) );
  DFFSR \parallel_out_reg[1]  ( .D(n48), .CLK(clk), .R(1'b1), .S(n_rst), .Q(
        parallel_out[1]) );
  DFFSR \parallel_out_reg[2]  ( .D(n46), .CLK(clk), .R(1'b1), .S(n_rst), .Q(
        parallel_out[2]) );
  DFFSR \parallel_out_reg[3]  ( .D(n44), .CLK(clk), .R(1'b1), .S(n_rst), .Q(
        parallel_out[3]) );
  DFFSR \parallel_out_reg[4]  ( .D(n42), .CLK(clk), .R(1'b1), .S(n_rst), .Q(
        parallel_out[4]) );
  DFFSR \parallel_out_reg[5]  ( .D(n40), .CLK(clk), .R(1'b1), .S(n_rst), .Q(
        parallel_out[5]) );
  DFFSR \parallel_out_reg[6]  ( .D(n38), .CLK(clk), .R(1'b1), .S(n_rst), .Q(
        parallel_out[6]) );
  DFFSR \parallel_out_reg[7]  ( .D(n36), .CLK(clk), .R(1'b1), .S(n_rst), .Q(
        parallel_out[7]) );
  DFFSR \parallel_out_reg[8]  ( .D(n34), .CLK(clk), .R(1'b1), .S(n_rst), .Q(
        parallel_out[8]) );
  DFFSR \parallel_out_reg[9]  ( .D(n32), .CLK(clk), .R(1'b1), .S(n_rst), .Q(
        parallel_out[9]) );
  DFFSR \parallel_out_reg[10]  ( .D(n30), .CLK(clk), .R(1'b1), .S(n_rst), .Q(
        parallel_out[10]) );
  DFFSR \parallel_out_reg[11]  ( .D(n28), .CLK(clk), .R(1'b1), .S(n_rst), .Q(
        parallel_out[11]) );
  DFFSR \parallel_out_reg[12]  ( .D(n26), .CLK(clk), .R(1'b1), .S(n_rst), .Q(
        parallel_out[12]) );
  DFFSR \parallel_out_reg[13]  ( .D(n24), .CLK(clk), .R(1'b1), .S(n_rst), .Q(
        parallel_out[13]) );
  DFFSR \parallel_out_reg[14]  ( .D(n22), .CLK(clk), .R(1'b1), .S(n_rst), .Q(
        parallel_out[14]) );
  DFFSR \parallel_out_reg[15]  ( .D(n20), .CLK(clk), .R(1'b1), .S(n_rst), .Q(
        parallel_out[15]) );
  INVX1 U2 ( .A(n1), .Y(n50) );
  MUX2X1 U3 ( .B(parallel_out[0]), .A(serial_in), .S(shift_enable), .Y(n1) );
  INVX1 U4 ( .A(n2), .Y(n48) );
  MUX2X1 U5 ( .B(parallel_out[1]), .A(parallel_out[0]), .S(shift_enable), .Y(
        n2) );
  INVX1 U6 ( .A(n3), .Y(n46) );
  MUX2X1 U7 ( .B(parallel_out[2]), .A(parallel_out[1]), .S(shift_enable), .Y(
        n3) );
  INVX1 U8 ( .A(n4), .Y(n44) );
  MUX2X1 U9 ( .B(parallel_out[3]), .A(parallel_out[2]), .S(shift_enable), .Y(
        n4) );
  INVX1 U10 ( .A(n5), .Y(n42) );
  MUX2X1 U11 ( .B(parallel_out[4]), .A(parallel_out[3]), .S(shift_enable), .Y(
        n5) );
  INVX1 U12 ( .A(n6), .Y(n40) );
  MUX2X1 U13 ( .B(parallel_out[5]), .A(parallel_out[4]), .S(shift_enable), .Y(
        n6) );
  INVX1 U14 ( .A(n7), .Y(n38) );
  MUX2X1 U15 ( .B(parallel_out[6]), .A(parallel_out[5]), .S(shift_enable), .Y(
        n7) );
  INVX1 U16 ( .A(n8), .Y(n36) );
  MUX2X1 U17 ( .B(parallel_out[7]), .A(parallel_out[6]), .S(shift_enable), .Y(
        n8) );
  INVX1 U18 ( .A(n9), .Y(n34) );
  MUX2X1 U19 ( .B(parallel_out[8]), .A(parallel_out[7]), .S(shift_enable), .Y(
        n9) );
  INVX1 U20 ( .A(n10), .Y(n32) );
  MUX2X1 U21 ( .B(parallel_out[9]), .A(parallel_out[8]), .S(shift_enable), .Y(
        n10) );
  INVX1 U22 ( .A(n11), .Y(n30) );
  MUX2X1 U23 ( .B(parallel_out[10]), .A(parallel_out[9]), .S(shift_enable), 
        .Y(n11) );
  INVX1 U24 ( .A(n12), .Y(n28) );
  MUX2X1 U25 ( .B(parallel_out[11]), .A(parallel_out[10]), .S(shift_enable), 
        .Y(n12) );
  INVX1 U26 ( .A(n13), .Y(n26) );
  MUX2X1 U27 ( .B(parallel_out[12]), .A(parallel_out[11]), .S(shift_enable), 
        .Y(n13) );
  INVX1 U28 ( .A(n14), .Y(n24) );
  MUX2X1 U29 ( .B(parallel_out[13]), .A(parallel_out[12]), .S(shift_enable), 
        .Y(n14) );
  INVX1 U30 ( .A(n15), .Y(n22) );
  MUX2X1 U31 ( .B(parallel_out[14]), .A(parallel_out[13]), .S(shift_enable), 
        .Y(n15) );
  INVX1 U32 ( .A(n16), .Y(n20) );
  MUX2X1 U33 ( .B(parallel_out[15]), .A(parallel_out[14]), .S(shift_enable), 
        .Y(n16) );
endmodule


module RX_SR ( clk, n_rst, shift_strobe, serial_in, ignore_bit, RX_packet_data
 );
  output [15:0] RX_packet_data;
  input clk, n_rst, shift_strobe, serial_in, ignore_bit;


  flex_stp_sr_NUM_BITS16_SHIFT_MSB1 shift_register ( .clk(clk), .n_rst(n_rst), 
        .shift_enable(shift_strobe), .serial_in(serial_in), .parallel_out(
        RX_packet_data) );
endmodule


module flex_counter_NUM_CNT_BITS4_1 ( clk, n_rst, clear, count_enable, 
        rollover_val, count_out, rollover_flag );
  input [3:0] rollover_val;
  output [3:0] count_out;
  input clk, n_rst, clear, count_enable;
  output rollover_flag;
  wire   N11, n1, n2, n3, n4, n5, n6, n12, n13, n14, n15, n16, n17, n18, n19,
         n20, n21, n22, n23, n24, n25, n26, n27, n28, n29, n30, n31, n32, n33,
         n34, n35, n36, n37;
  wire   [3:0] next_count;

  DFFSR \count_out_reg[0]  ( .D(next_count[0]), .CLK(clk), .R(n_rst), .S(1'b1), 
        .Q(count_out[0]) );
  DFFSR \count_out_reg[1]  ( .D(next_count[1]), .CLK(clk), .R(n_rst), .S(1'b1), 
        .Q(count_out[1]) );
  DFFSR \count_out_reg[2]  ( .D(next_count[2]), .CLK(clk), .R(n_rst), .S(1'b1), 
        .Q(count_out[2]) );
  DFFSR \count_out_reg[3]  ( .D(next_count[3]), .CLK(clk), .R(n_rst), .S(1'b1), 
        .Q(count_out[3]) );
  DFFSR rollover_flag_reg ( .D(N11), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        rollover_flag) );
  NOR2X1 U8 ( .A(n1), .B(n2), .Y(N11) );
  NAND2X1 U9 ( .A(n3), .B(n4), .Y(n2) );
  XNOR2X1 U10 ( .A(rollover_val[1]), .B(next_count[1]), .Y(n4) );
  OAI21X1 U11 ( .A(n5), .B(n6), .C(n12), .Y(next_count[1]) );
  NAND3X1 U12 ( .A(n13), .B(n5), .C(n14), .Y(n12) );
  NAND2X1 U13 ( .A(n15), .B(n16), .Y(n6) );
  OAI21X1 U14 ( .A(n13), .B(n17), .C(count_enable), .Y(n15) );
  INVX1 U15 ( .A(count_out[1]), .Y(n5) );
  XNOR2X1 U16 ( .A(rollover_val[2]), .B(next_count[2]), .Y(n3) );
  OAI21X1 U17 ( .A(n18), .B(n19), .C(n20), .Y(next_count[2]) );
  NAND3X1 U18 ( .A(n21), .B(n18), .C(n14), .Y(n20) );
  INVX1 U19 ( .A(n22), .Y(n14) );
  NAND2X1 U20 ( .A(n23), .B(n16), .Y(n19) );
  OAI21X1 U21 ( .A(n21), .B(n17), .C(count_enable), .Y(n23) );
  INVX1 U22 ( .A(n24), .Y(n17) );
  NAND2X1 U23 ( .A(n25), .B(n26), .Y(n1) );
  XNOR2X1 U24 ( .A(rollover_val[0]), .B(next_count[0]), .Y(n26) );
  OAI21X1 U25 ( .A(n13), .B(n22), .C(n27), .Y(next_count[0]) );
  NAND3X1 U26 ( .A(n16), .B(n28), .C(count_out[0]), .Y(n27) );
  XNOR2X1 U27 ( .A(rollover_val[3]), .B(next_count[3]), .Y(n25) );
  OAI21X1 U28 ( .A(n29), .B(n22), .C(n30), .Y(next_count[3]) );
  NAND3X1 U29 ( .A(n16), .B(n28), .C(count_out[3]), .Y(n30) );
  INVX1 U30 ( .A(count_enable), .Y(n28) );
  NAND2X1 U31 ( .A(count_enable), .B(n16), .Y(n22) );
  INVX1 U32 ( .A(clear), .Y(n16) );
  XOR2X1 U33 ( .A(n31), .B(n32), .Y(n29) );
  AND2X1 U34 ( .A(n24), .B(count_out[3]), .Y(n32) );
  NAND2X1 U35 ( .A(n21), .B(count_out[2]), .Y(n31) );
  AND2X1 U36 ( .A(n13), .B(count_out[1]), .Y(n21) );
  AND2X1 U37 ( .A(count_out[0]), .B(n24), .Y(n13) );
  NAND3X1 U38 ( .A(n33), .B(n34), .C(n35), .Y(n24) );
  NOR2X1 U39 ( .A(n36), .B(n37), .Y(n35) );
  XOR2X1 U40 ( .A(rollover_val[1]), .B(count_out[1]), .Y(n37) );
  XOR2X1 U41 ( .A(rollover_val[0]), .B(count_out[0]), .Y(n36) );
  XOR2X1 U42 ( .A(rollover_val[2]), .B(n18), .Y(n34) );
  INVX1 U43 ( .A(count_out[2]), .Y(n18) );
  XNOR2X1 U44 ( .A(count_out[3]), .B(rollover_val[3]), .Y(n33) );
endmodule


module RX_byte_counter ( clk, n_rst, count_enable, clear, byte_done );
  input clk, n_rst, count_enable, clear;
  output byte_done;
  wire   clear_counter;

  flex_counter_NUM_CNT_BITS4_1 counter_25 ( .clk(clk), .n_rst(n_rst), .clear(
        clear_counter), .count_enable(count_enable), .rollover_val({1'b1, 1'b0, 
        1'b0, 1'b0}), .rollover_flag(byte_done) );
  OR2X1 U3 ( .A(byte_done), .B(clear), .Y(clear_counter) );
endmodule


module flex_counter_NUM_CNT_BITS6 ( clk, n_rst, clear, count_enable, 
        rollover_val, count_out, rollover_flag );
  input [5:0] rollover_val;
  output [5:0] count_out;
  input clk, n_rst, clear, count_enable;
  output rollover_flag;
  wire   N13, \eq_42/A[0] , \eq_42/A[1] , \eq_42/A[2] , \eq_42/A[3] ,
         \eq_42/A[4] , \eq_42/A[5] , n1, n2, n3, n4, n5, n6, n14, n15, n16,
         n17, n18, n19, n20, n21, n22, n23, n24, n25, n26, n27, n28, n29, n30,
         n31, n32, n33, n34, n35, n36, n37, n38, n39, n40, n41, n42, n43, n44,
         n45, n46, n47, n48, n49;

  DFFSR \count_out_reg[0]  ( .D(\eq_42/A[0] ), .CLK(clk), .R(n_rst), .S(1'b1), 
        .Q(count_out[0]) );
  DFFSR \count_out_reg[1]  ( .D(\eq_42/A[1] ), .CLK(clk), .R(n_rst), .S(1'b1), 
        .Q(count_out[1]) );
  DFFSR \count_out_reg[2]  ( .D(\eq_42/A[2] ), .CLK(clk), .R(n_rst), .S(1'b1), 
        .Q(count_out[2]) );
  DFFSR \count_out_reg[3]  ( .D(\eq_42/A[3] ), .CLK(clk), .R(n_rst), .S(1'b1), 
        .Q(count_out[3]) );
  DFFSR \count_out_reg[4]  ( .D(\eq_42/A[4] ), .CLK(clk), .R(n_rst), .S(1'b1), 
        .Q(count_out[4]) );
  DFFSR \count_out_reg[5]  ( .D(\eq_42/A[5] ), .CLK(clk), .R(n_rst), .S(1'b1), 
        .Q(count_out[5]) );
  DFFSR rollover_flag_reg ( .D(N13), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        rollover_flag) );
  NOR2X1 U5 ( .A(n1), .B(n2), .Y(N13) );
  NAND3X1 U6 ( .A(n3), .B(n4), .C(n5), .Y(n2) );
  XNOR2X1 U12 ( .A(rollover_val[3]), .B(\eq_42/A[3] ), .Y(n5) );
  OAI22X1 U13 ( .A(n6), .B(n14), .C(n15), .D(n16), .Y(\eq_42/A[3] ) );
  XNOR2X1 U14 ( .A(n17), .B(n18), .Y(n15) );
  XNOR2X1 U15 ( .A(rollover_val[4]), .B(\eq_42/A[4] ), .Y(n4) );
  OAI22X1 U16 ( .A(n19), .B(n14), .C(n20), .D(n16), .Y(\eq_42/A[4] ) );
  XNOR2X1 U17 ( .A(n21), .B(n22), .Y(n20) );
  XNOR2X1 U18 ( .A(rollover_val[2]), .B(\eq_42/A[2] ), .Y(n3) );
  OAI22X1 U19 ( .A(n23), .B(n14), .C(n24), .D(n16), .Y(\eq_42/A[2] ) );
  XNOR2X1 U20 ( .A(n25), .B(n26), .Y(n24) );
  NAND3X1 U21 ( .A(n27), .B(n28), .C(n29), .Y(n1) );
  XNOR2X1 U22 ( .A(rollover_val[1]), .B(\eq_42/A[1] ), .Y(n29) );
  OAI22X1 U23 ( .A(n30), .B(n14), .C(n31), .D(n16), .Y(\eq_42/A[1] ) );
  XOR2X1 U24 ( .A(n32), .B(n33), .Y(n31) );
  XNOR2X1 U25 ( .A(rollover_val[5]), .B(\eq_42/A[5] ), .Y(n28) );
  OAI22X1 U26 ( .A(n34), .B(n14), .C(n35), .D(n16), .Y(\eq_42/A[5] ) );
  XOR2X1 U27 ( .A(n36), .B(n37), .Y(n35) );
  NOR2X1 U28 ( .A(n22), .B(n21), .Y(n37) );
  NAND2X1 U29 ( .A(n18), .B(n17), .Y(n21) );
  AND2X1 U30 ( .A(count_out[3]), .B(n38), .Y(n17) );
  AND2X1 U31 ( .A(n25), .B(n26), .Y(n18) );
  AND2X1 U32 ( .A(count_out[2]), .B(n38), .Y(n26) );
  NOR2X1 U33 ( .A(n39), .B(n32), .Y(n25) );
  NAND2X1 U34 ( .A(count_out[1]), .B(n38), .Y(n32) );
  NAND2X1 U35 ( .A(count_out[4]), .B(n38), .Y(n22) );
  NAND2X1 U36 ( .A(count_out[5]), .B(n38), .Y(n36) );
  XNOR2X1 U37 ( .A(rollover_val[0]), .B(\eq_42/A[0] ), .Y(n27) );
  OAI22X1 U38 ( .A(n40), .B(n14), .C(n33), .D(n16), .Y(\eq_42/A[0] ) );
  NAND2X1 U39 ( .A(count_enable), .B(n41), .Y(n16) );
  INVX1 U40 ( .A(clear), .Y(n41) );
  INVX1 U41 ( .A(n39), .Y(n33) );
  NAND2X1 U42 ( .A(count_out[0]), .B(n38), .Y(n39) );
  OR2X1 U43 ( .A(n42), .B(n43), .Y(n38) );
  NAND3X1 U44 ( .A(n44), .B(n45), .C(n46), .Y(n43) );
  XOR2X1 U45 ( .A(n19), .B(rollover_val[4]), .Y(n46) );
  INVX1 U46 ( .A(count_out[4]), .Y(n19) );
  XOR2X1 U47 ( .A(n34), .B(rollover_val[5]), .Y(n45) );
  INVX1 U48 ( .A(count_out[5]), .Y(n34) );
  XOR2X1 U49 ( .A(n6), .B(rollover_val[3]), .Y(n44) );
  INVX1 U50 ( .A(count_out[3]), .Y(n6) );
  NAND3X1 U51 ( .A(n47), .B(n48), .C(n49), .Y(n42) );
  XOR2X1 U52 ( .A(n30), .B(rollover_val[1]), .Y(n49) );
  INVX1 U53 ( .A(count_out[1]), .Y(n30) );
  XOR2X1 U54 ( .A(n23), .B(rollover_val[2]), .Y(n48) );
  INVX1 U55 ( .A(count_out[2]), .Y(n23) );
  XOR2X1 U56 ( .A(n40), .B(rollover_val[0]), .Y(n47) );
  OR2X1 U57 ( .A(count_enable), .B(clear), .Y(n14) );
  INVX1 U58 ( .A(count_out[0]), .Y(n40) );
endmodule


module flex_counter_NUM_CNT_BITS4_0 ( clk, n_rst, clear, count_enable, 
        rollover_val, count_out, rollover_flag );
  input [3:0] rollover_val;
  output [3:0] count_out;
  input clk, n_rst, clear, count_enable;
  output rollover_flag;
  wire   N11, n1, n2, n3, n4, n5, n6, n12, n13, n14, n15, n16, n17, n18, n19,
         n20, n21, n22, n23, n24, n25, n26, n27, n28, n29, n30, n31, n32, n33,
         n34, n35, n36, n37;
  wire   [3:0] next_count;

  DFFSR \count_out_reg[0]  ( .D(next_count[0]), .CLK(clk), .R(n_rst), .S(1'b1), 
        .Q(count_out[0]) );
  DFFSR \count_out_reg[1]  ( .D(next_count[1]), .CLK(clk), .R(n_rst), .S(1'b1), 
        .Q(count_out[1]) );
  DFFSR \count_out_reg[2]  ( .D(next_count[2]), .CLK(clk), .R(n_rst), .S(1'b1), 
        .Q(count_out[2]) );
  DFFSR \count_out_reg[3]  ( .D(next_count[3]), .CLK(clk), .R(n_rst), .S(1'b1), 
        .Q(count_out[3]) );
  DFFSR rollover_flag_reg ( .D(N11), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        rollover_flag) );
  NOR2X1 U8 ( .A(n1), .B(n2), .Y(N11) );
  NAND2X1 U9 ( .A(n3), .B(n4), .Y(n2) );
  XNOR2X1 U10 ( .A(rollover_val[1]), .B(next_count[1]), .Y(n4) );
  OAI21X1 U11 ( .A(n5), .B(n6), .C(n12), .Y(next_count[1]) );
  NAND3X1 U12 ( .A(n13), .B(n5), .C(n14), .Y(n12) );
  NAND2X1 U13 ( .A(n15), .B(n16), .Y(n6) );
  OAI21X1 U14 ( .A(n13), .B(n17), .C(count_enable), .Y(n15) );
  INVX1 U15 ( .A(count_out[1]), .Y(n5) );
  XNOR2X1 U16 ( .A(rollover_val[2]), .B(next_count[2]), .Y(n3) );
  OAI21X1 U17 ( .A(n18), .B(n19), .C(n20), .Y(next_count[2]) );
  NAND3X1 U18 ( .A(n21), .B(n18), .C(n14), .Y(n20) );
  INVX1 U19 ( .A(n22), .Y(n14) );
  NAND2X1 U20 ( .A(n23), .B(n16), .Y(n19) );
  OAI21X1 U21 ( .A(n21), .B(n17), .C(count_enable), .Y(n23) );
  INVX1 U22 ( .A(n24), .Y(n17) );
  NAND2X1 U23 ( .A(n25), .B(n26), .Y(n1) );
  XNOR2X1 U24 ( .A(rollover_val[0]), .B(next_count[0]), .Y(n26) );
  OAI21X1 U25 ( .A(n13), .B(n22), .C(n27), .Y(next_count[0]) );
  NAND3X1 U26 ( .A(n16), .B(n28), .C(count_out[0]), .Y(n27) );
  XNOR2X1 U27 ( .A(rollover_val[3]), .B(next_count[3]), .Y(n25) );
  OAI21X1 U28 ( .A(n29), .B(n22), .C(n30), .Y(next_count[3]) );
  NAND3X1 U29 ( .A(n16), .B(n28), .C(count_out[3]), .Y(n30) );
  INVX1 U30 ( .A(count_enable), .Y(n28) );
  NAND2X1 U31 ( .A(count_enable), .B(n16), .Y(n22) );
  INVX1 U32 ( .A(clear), .Y(n16) );
  XOR2X1 U33 ( .A(n31), .B(n32), .Y(n29) );
  AND2X1 U34 ( .A(n24), .B(count_out[3]), .Y(n32) );
  NAND2X1 U35 ( .A(n21), .B(count_out[2]), .Y(n31) );
  AND2X1 U36 ( .A(n13), .B(count_out[1]), .Y(n21) );
  AND2X1 U37 ( .A(count_out[0]), .B(n24), .Y(n13) );
  NAND3X1 U38 ( .A(n33), .B(n34), .C(n35), .Y(n24) );
  NOR2X1 U39 ( .A(n36), .B(n37), .Y(n35) );
  XOR2X1 U40 ( .A(rollover_val[1]), .B(count_out[1]), .Y(n37) );
  XOR2X1 U41 ( .A(rollover_val[0]), .B(count_out[0]), .Y(n36) );
  XOR2X1 U42 ( .A(rollover_val[2]), .B(n18), .Y(n34) );
  INVX1 U43 ( .A(count_out[2]), .Y(n18) );
  XNOR2X1 U44 ( .A(count_out[3]), .B(rollover_val[3]), .Y(n33) );
endmodule


module RX_timer ( clk, n_rst, d_plus, d_minus, en_sample );
  input clk, n_rst, d_plus, d_minus;
  output en_sample;
  wire   skip_bit, n1;

  flex_counter_NUM_CNT_BITS6 counter_25 ( .clk(clk), .n_rst(n_rst), .clear(
        1'b0), .count_enable(1'b1), .rollover_val({1'b0, 1'b1, 1'b1, 1'b0, 
        1'b0, 1'b1}), .rollover_flag(skip_bit) );
  flex_counter_NUM_CNT_BITS4_0 counter_8 ( .clk(clk), .n_rst(n_rst), .clear(
        1'b0), .count_enable(n1), .rollover_val({1'b1, 1'b0, 1'b0, 1'b0}), 
        .rollover_flag(en_sample) );
  INVX1 U3 ( .A(skip_bit), .Y(n1) );
endmodule


module RX_bit_stuff_detector ( clk, n_rst, decoded_bit, next_enable, 
        ignore_bit );
  input clk, n_rst, decoded_bit, next_enable;
  output ignore_bit;
  wire   n16, n18, n20, n1, n2, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12, n13,
         n14, n21;
  wire   [3:0] state;

  DFFSR \state_reg[0]  ( .D(n20), .CLK(clk), .R(n_rst), .S(1'b1), .Q(state[0])
         );
  DFFSR \state_reg[1]  ( .D(n18), .CLK(clk), .R(n_rst), .S(1'b1), .Q(state[1])
         );
  DFFSR \state_reg[2]  ( .D(n16), .CLK(clk), .R(n_rst), .S(1'b1), .Q(state[2])
         );
  MUX2X1 U3 ( .B(n1), .A(n2), .S(n3), .Y(n20) );
  AOI22X1 U4 ( .A(state[2]), .B(n4), .C(decoded_bit), .D(n2), .Y(n1) );
  INVX1 U5 ( .A(state[0]), .Y(n2) );
  OAI21X1 U6 ( .A(next_enable), .B(n5), .C(n6), .Y(n18) );
  AOI22X1 U7 ( .A(decoded_bit), .B(n7), .C(n8), .D(state[2]), .Y(n6) );
  OAI21X1 U8 ( .A(n3), .B(n9), .C(n10), .Y(n7) );
  OAI21X1 U9 ( .A(state[0]), .B(state[2]), .C(n5), .Y(n9) );
  MUX2X1 U10 ( .B(n11), .A(n12), .S(n13), .Y(n16) );
  OR2X1 U11 ( .A(n14), .B(n21), .Y(n12) );
  NOR2X1 U12 ( .A(n3), .B(n4), .Y(n11) );
  OAI21X1 U13 ( .A(state[1]), .B(n21), .C(n10), .Y(n4) );
  INVX1 U14 ( .A(n8), .Y(n10) );
  NOR2X1 U15 ( .A(n5), .B(state[0]), .Y(n8) );
  INVX1 U16 ( .A(state[1]), .Y(n5) );
  INVX1 U17 ( .A(decoded_bit), .Y(n21) );
  INVX1 U18 ( .A(next_enable), .Y(n3) );
  NOR2X1 U19 ( .A(n13), .B(n14), .Y(ignore_bit) );
  NAND3X1 U20 ( .A(next_enable), .B(state[1]), .C(state[0]), .Y(n14) );
  INVX1 U24 ( .A(state[2]), .Y(n13) );
endmodule


module RX_decoder ( clk, n_rst, d_plus, d_minus, en_sample, decoded, eop );
  input clk, n_rst, d_plus, d_minus, en_sample;
  output decoded, eop;
  wire   next_value, value, next_eop, n10, n1, n2, n3, n4, n5, n6, n7;

  DFFSR eop_reg ( .D(next_eop), .CLK(clk), .R(n_rst), .S(1'b1), .Q(eop) );
  DFFSR value_reg ( .D(next_value), .CLK(clk), .R(n_rst), .S(1'b1), .Q(value)
         );
  DFFSR decoded_reg ( .D(n10), .CLK(clk), .R(n_rst), .S(1'b1), .Q(decoded) );
  OAI21X1 U3 ( .A(n1), .B(n2), .C(n3), .Y(next_value) );
  OAI21X1 U4 ( .A(d_plus), .B(n1), .C(value), .Y(n3) );
  NOR2X1 U5 ( .A(n1), .B(n4), .Y(next_eop) );
  OR2X1 U6 ( .A(d_minus), .B(d_plus), .Y(n4) );
  MUX2X1 U7 ( .B(n5), .A(n6), .S(n1), .Y(n10) );
  INVX1 U8 ( .A(en_sample), .Y(n1) );
  INVX1 U9 ( .A(decoded), .Y(n6) );
  MUX2X1 U10 ( .B(n2), .A(d_plus), .S(value), .Y(n5) );
  NAND2X1 U11 ( .A(d_plus), .B(n7), .Y(n2) );
  INVX1 U12 ( .A(d_minus), .Y(n7) );
endmodule


module crc_16bit_chk ( clk, n_rst, clear, serial_in, shift_en, pass );
  input clk, n_rst, clear, serial_in, shift_en;
  output pass;
  wire   n63, n64, n65, n66, n67, n68, n69, n70, n71, n72, n73, n74, n75, n76,
         n77, n78, n17, n18, n19, n20, n21, n22, n23, n24, n25, n26, n27, n28,
         n29, n30, n31, n32, n33, n34, n35, n36, n37, n38, n39, n40, n41, n42,
         n43, n44, n45, n46, n47, n48, n49, n50, n51, n52, n53, n54, n55, n56,
         n57, n58, n59;
  wire   [15:0] Q;

  DFFSR \Q_reg[0]  ( .D(n78), .CLK(clk), .R(1'b1), .S(n_rst), .Q(Q[0]) );
  DFFSR \Q_reg[1]  ( .D(n77), .CLK(clk), .R(1'b1), .S(n_rst), .Q(Q[1]) );
  DFFSR \Q_reg[2]  ( .D(n76), .CLK(clk), .R(1'b1), .S(n_rst), .Q(Q[2]) );
  DFFSR \Q_reg[3]  ( .D(n75), .CLK(clk), .R(1'b1), .S(n_rst), .Q(Q[3]) );
  DFFSR \Q_reg[4]  ( .D(n74), .CLK(clk), .R(1'b1), .S(n_rst), .Q(Q[4]) );
  DFFSR \Q_reg[5]  ( .D(n73), .CLK(clk), .R(1'b1), .S(n_rst), .Q(Q[5]) );
  DFFSR \Q_reg[6]  ( .D(n72), .CLK(clk), .R(1'b1), .S(n_rst), .Q(Q[6]) );
  DFFSR \Q_reg[7]  ( .D(n71), .CLK(clk), .R(1'b1), .S(n_rst), .Q(Q[7]) );
  DFFSR \Q_reg[8]  ( .D(n70), .CLK(clk), .R(1'b1), .S(n_rst), .Q(Q[8]) );
  DFFSR \Q_reg[9]  ( .D(n69), .CLK(clk), .R(1'b1), .S(n_rst), .Q(Q[9]) );
  DFFSR \Q_reg[10]  ( .D(n68), .CLK(clk), .R(1'b1), .S(n_rst), .Q(Q[10]) );
  DFFSR \Q_reg[11]  ( .D(n67), .CLK(clk), .R(1'b1), .S(n_rst), .Q(Q[11]) );
  DFFSR \Q_reg[12]  ( .D(n66), .CLK(clk), .R(1'b1), .S(n_rst), .Q(Q[12]) );
  DFFSR \Q_reg[13]  ( .D(n65), .CLK(clk), .R(1'b1), .S(n_rst), .Q(Q[13]) );
  DFFSR \Q_reg[14]  ( .D(n64), .CLK(clk), .R(1'b1), .S(n_rst), .Q(Q[14]) );
  DFFSR \Q_reg[15]  ( .D(n63), .CLK(clk), .R(1'b1), .S(n_rst), .Q(Q[15]) );
  AND2X1 U19 ( .A(n17), .B(n18), .Y(pass) );
  NOR2X1 U20 ( .A(n19), .B(n20), .Y(n18) );
  NAND3X1 U21 ( .A(n21), .B(n22), .C(n23), .Y(n20) );
  NOR2X1 U22 ( .A(Q[1]), .B(Q[14]), .Y(n23) );
  INVX1 U23 ( .A(Q[5]), .Y(n22) );
  INVX1 U24 ( .A(Q[4]), .Y(n21) );
  NAND3X1 U25 ( .A(n24), .B(n25), .C(n26), .Y(n19) );
  NOR2X1 U26 ( .A(Q[9]), .B(Q[8]), .Y(n26) );
  INVX1 U27 ( .A(Q[7]), .Y(n25) );
  INVX1 U28 ( .A(Q[6]), .Y(n24) );
  NOR2X1 U29 ( .A(n27), .B(n28), .Y(n17) );
  NAND3X1 U30 ( .A(Q[3]), .B(Q[2]), .C(n29), .Y(n28) );
  NOR2X1 U31 ( .A(n30), .B(n31), .Y(n29) );
  NAND3X1 U32 ( .A(n32), .B(n33), .C(n34), .Y(n27) );
  NOR2X1 U33 ( .A(Q[13]), .B(Q[12]), .Y(n34) );
  INVX1 U34 ( .A(Q[11]), .Y(n33) );
  INVX1 U35 ( .A(Q[10]), .Y(n32) );
  OAI21X1 U36 ( .A(shift_en), .B(n30), .C(n35), .Y(n78) );
  AND2X1 U37 ( .A(n36), .B(n37), .Y(n35) );
  INVX1 U38 ( .A(Q[0]), .Y(n30) );
  NAND2X1 U39 ( .A(n38), .B(n36), .Y(n77) );
  MUX2X1 U40 ( .B(Q[1]), .A(Q[0]), .S(shift_en), .Y(n38) );
  OR2X1 U41 ( .A(n39), .B(n40), .Y(n76) );
  OAI21X1 U42 ( .A(Q[1]), .B(n37), .C(n36), .Y(n40) );
  MUX2X1 U43 ( .B(n41), .A(n42), .S(shift_en), .Y(n39) );
  NAND2X1 U44 ( .A(Q[1]), .B(n43), .Y(n42) );
  INVX1 U45 ( .A(Q[2]), .Y(n41) );
  NAND2X1 U46 ( .A(n44), .B(n36), .Y(n75) );
  MUX2X1 U47 ( .B(Q[3]), .A(Q[2]), .S(shift_en), .Y(n44) );
  NAND2X1 U48 ( .A(n45), .B(n36), .Y(n74) );
  MUX2X1 U49 ( .B(Q[4]), .A(Q[3]), .S(shift_en), .Y(n45) );
  NAND2X1 U50 ( .A(n46), .B(n36), .Y(n73) );
  MUX2X1 U51 ( .B(Q[5]), .A(Q[4]), .S(shift_en), .Y(n46) );
  NAND2X1 U52 ( .A(n47), .B(n36), .Y(n72) );
  MUX2X1 U53 ( .B(Q[6]), .A(Q[5]), .S(shift_en), .Y(n47) );
  NAND2X1 U54 ( .A(n48), .B(n36), .Y(n71) );
  MUX2X1 U55 ( .B(Q[7]), .A(Q[6]), .S(shift_en), .Y(n48) );
  NAND2X1 U56 ( .A(n49), .B(n36), .Y(n70) );
  MUX2X1 U57 ( .B(Q[8]), .A(Q[7]), .S(shift_en), .Y(n49) );
  NAND2X1 U58 ( .A(n50), .B(n36), .Y(n69) );
  MUX2X1 U59 ( .B(Q[9]), .A(Q[8]), .S(shift_en), .Y(n50) );
  NAND2X1 U60 ( .A(n51), .B(n36), .Y(n68) );
  MUX2X1 U61 ( .B(Q[10]), .A(Q[9]), .S(shift_en), .Y(n51) );
  NAND2X1 U62 ( .A(n52), .B(n36), .Y(n67) );
  MUX2X1 U63 ( .B(Q[11]), .A(Q[10]), .S(shift_en), .Y(n52) );
  NAND2X1 U64 ( .A(n53), .B(n36), .Y(n66) );
  MUX2X1 U65 ( .B(Q[12]), .A(Q[11]), .S(shift_en), .Y(n53) );
  NAND2X1 U66 ( .A(n54), .B(n36), .Y(n65) );
  MUX2X1 U67 ( .B(Q[13]), .A(Q[12]), .S(shift_en), .Y(n54) );
  NAND2X1 U68 ( .A(n55), .B(n36), .Y(n64) );
  MUX2X1 U69 ( .B(Q[14]), .A(Q[13]), .S(shift_en), .Y(n55) );
  OR2X1 U70 ( .A(n56), .B(n57), .Y(n63) );
  OAI21X1 U71 ( .A(Q[14]), .B(n37), .C(n36), .Y(n57) );
  INVX1 U72 ( .A(clear), .Y(n36) );
  NAND2X1 U73 ( .A(shift_en), .B(n58), .Y(n37) );
  MUX2X1 U74 ( .B(n31), .A(n59), .S(shift_en), .Y(n56) );
  NAND2X1 U75 ( .A(Q[14]), .B(n43), .Y(n59) );
  INVX1 U76 ( .A(n58), .Y(n43) );
  XOR2X1 U77 ( .A(Q[15]), .B(serial_in), .Y(n58) );
  INVX1 U78 ( .A(Q[15]), .Y(n31) );
endmodule


module crc_5bit_chk ( clk, n_rst, clear, serial_in, shift_en, pass );
  input clk, n_rst, clear, serial_in, shift_en;
  output pass;
  wire   n21, n22, n23, n24, n25, n6, n7, n8, n9, n10, n11, n12, n13, n14, n15,
         n16;
  wire   [4:0] Q;

  DFFSR \Q_reg[0]  ( .D(n25), .CLK(clk), .R(1'b1), .S(n_rst), .Q(Q[0]) );
  DFFSR \Q_reg[1]  ( .D(n24), .CLK(clk), .R(1'b1), .S(n_rst), .Q(Q[1]) );
  DFFSR \Q_reg[2]  ( .D(n23), .CLK(clk), .R(1'b1), .S(n_rst), .Q(Q[2]) );
  DFFSR \Q_reg[3]  ( .D(n22), .CLK(clk), .R(1'b1), .S(n_rst), .Q(Q[3]) );
  DFFSR \Q_reg[4]  ( .D(n21), .CLK(clk), .R(1'b1), .S(n_rst), .Q(Q[4]) );
  NOR2X1 U8 ( .A(n6), .B(n7), .Y(pass) );
  NAND2X1 U9 ( .A(Q[3]), .B(Q[2]), .Y(n7) );
  INVX1 U10 ( .A(n8), .Y(n6) );
  NOR3X1 U11 ( .A(Q[1]), .B(Q[4]), .C(Q[0]), .Y(n8) );
  NAND2X1 U12 ( .A(n9), .B(n10), .Y(n25) );
  MUX2X1 U13 ( .B(Q[0]), .A(n11), .S(shift_en), .Y(n9) );
  NAND2X1 U14 ( .A(n12), .B(n10), .Y(n24) );
  MUX2X1 U15 ( .B(Q[1]), .A(Q[0]), .S(shift_en), .Y(n12) );
  NAND2X1 U16 ( .A(n13), .B(n10), .Y(n23) );
  MUX2X1 U17 ( .B(Q[2]), .A(n14), .S(shift_en), .Y(n13) );
  XOR2X1 U18 ( .A(Q[1]), .B(n11), .Y(n14) );
  XOR2X1 U19 ( .A(Q[4]), .B(serial_in), .Y(n11) );
  NAND2X1 U20 ( .A(n15), .B(n10), .Y(n22) );
  MUX2X1 U21 ( .B(Q[3]), .A(Q[2]), .S(shift_en), .Y(n15) );
  NAND2X1 U22 ( .A(n16), .B(n10), .Y(n21) );
  INVX1 U23 ( .A(clear), .Y(n10) );
  MUX2X1 U24 ( .B(Q[4]), .A(Q[3]), .S(shift_en), .Y(n16) );
endmodule


module USB_RX ( clk, n_rst, d_plus, d_minus, RX_packet, store_RX_packet_data, 
        RX_packet_data );
  output [2:0] RX_packet;
  output [7:0] RX_packet_data;
  input clk, n_rst, d_plus, d_minus;
  output store_RX_packet_data;
  wire   delayed_en_sample, en_sample, ignore_bit, N0, eop, decoded_bit,
         pass_5_bit, pass_16_bit, byte_done, en_buffer, clear_crc,
         clear_byte_count, _1_net_, n4, n5, n6, n7;
  wire   [15:0] SR_data;

  DFFSR delayed_en_sample_reg ( .D(N0), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        delayed_en_sample) );
  RX_ControlFSM controller ( .clk(clk), .n_rst(n_rst), .eop(eop), 
        .decoded_bit(decoded_bit), .pass_5_bit(pass_5_bit), .pass_16_bit(
        pass_16_bit), .byte_done(byte_done), .sr_val(SR_data), .shift_en(n4), 
        .en_buffer(en_buffer), .RX_PID(RX_packet), .clear_crc(clear_crc), 
        .clear_byte_count(clear_byte_count) );
  RX_SR shift_register ( .clk(clk), .n_rst(n_rst), .shift_strobe(n4), 
        .serial_in(decoded_bit), .ignore_bit(ignore_bit), .RX_packet_data(
        SR_data) );
  RX_byte_counter byte_counter ( .clk(clk), .n_rst(n_rst), .count_enable(
        delayed_en_sample), .clear(clear_byte_count), .byte_done(byte_done) );
  RX_timer timer ( .clk(clk), .n_rst(n_rst), .d_plus(d_plus), .d_minus(d_minus), .en_sample(en_sample) );
  RX_bit_stuff_detector bsd ( .clk(clk), .n_rst(n_rst), .decoded_bit(
        decoded_bit), .next_enable(en_sample), .ignore_bit(ignore_bit) );
  RX_decoder decoder ( .clk(clk), .n_rst(n_rst), .d_plus(d_plus), .d_minus(
        d_minus), .en_sample(en_sample), .decoded(decoded_bit), .eop(eop) );
  crc_16bit_chk crc16 ( .clk(clk), .n_rst(n_rst), .clear(clear_crc), 
        .serial_in(decoded_bit), .shift_en(n5), .pass(pass_16_bit) );
  crc_5bit_chk crc5 ( .clk(clk), .n_rst(n_rst), .clear(clear_crc), .serial_in(
        decoded_bit), .shift_en(n5), .pass(pass_5_bit) );
  INVX2 U9 ( .A(n6), .Y(n4) );
  BUFX2 U10 ( .A(_1_net_), .Y(n5) );
  AND2X1 U11 ( .A(en_buffer), .B(byte_done), .Y(store_RX_packet_data) );
  NOR2X1 U12 ( .A(eop), .B(n6), .Y(_1_net_) );
  INVX1 U13 ( .A(delayed_en_sample), .Y(n6) );
  NOR2X1 U14 ( .A(ignore_bit), .B(n7), .Y(N0) );
  INVX1 U15 ( .A(en_sample), .Y(n7) );
endmodule

