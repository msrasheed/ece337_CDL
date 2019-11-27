/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : K-2015.06-SP1
// Date      : Sun Nov 24 21:01:04 2019
/////////////////////////////////////////////////////////////


module protocol_controller ( clk, n_rst, rx_packet, tx_done, buffer_reserved, 
        tx_packet_data_size, buffer_occupancy, rx_data_ready, 
        rx_transfer_active, rx_error, tx_transfer_active, tx_error, clear, 
        tx_packet, d_mode );
  input [2:0] rx_packet;
  input [6:0] tx_packet_data_size;
  input [6:0] buffer_occupancy;
  output [1:0] tx_packet;
  input clk, n_rst, tx_done, buffer_reserved;
  output rx_data_ready, rx_transfer_active, rx_error, tx_transfer_active,
         tx_error, clear, d_mode;
  wire   N160, N161, N162, N163, N164, N165, N166, N167, N168, N169, N172,
         N173, N174, N175, N176, N186, N187, N188, N189, N190, N203, N204,
         N205, N206, N207, N208, N209, N210, N211, N212, N214, N215, N216,
         N219, N220, N221, N222, N223, N224, N225, N226, N227, N228,
         rx_data_ready_next, rx_transfer_active_next, rx_error_next,
         tx_transfer_active_next, tx_error_next, clear_next, n230, n231, n232,
         n233, n234, n235, n236, n237, n238, n239, n240, n241, n242, n243,
         n244, n245, n246, n247, n248, n249, n250, n251, n252, n253, n254,
         n255, n256, n257, n258, n259, n260, n261, n262, n263, n264, n265,
         n266, n267, n268, n269, n270, n271, n272, n273, n274, n275, n276,
         n277, n278, n279, n280, n281, n282, n283, n284, n285, n286, n287,
         n288, n289, n290, n291, n292, n293, n294, n295, n296, n297, n298,
         n299, n300, n301, n302, n303, n304, n305, n306, n307, n308, n309,
         n310, n311, n312, n313, n314, n315, n316, n317, n318, n319, n320,
         n321, n322, n323, n324, n325, n326, n327, n328, n329, n330, n331,
         n332, n333, n334, n335, n336, n337, n338, n339, n340, n341, n342,
         n343, n344, n345, n346, n347, n348, n349, n350, n351, n352, n353,
         n354, n355, n356, n357, n358, n359, n360, n361, n362, n363, n364,
         n365, n366, n367, n368, n369, n370, n371, n372, n373, n374, n375,
         n376, n377, n378, n379, n380, n381, n382, n383, n384, n385, n386,
         n387, n388, n389, n390, n391, n392, n393, n394, n395, n396, n397,
         n398, n399, n400, n401, n402, n403, n404, n405, n406, n407, n408,
         n409, n410, n411, n412, n413, n414, n415, n416, n417, n418, n419,
         n420;
  wire   [4:0] PS;
  wire   [4:0] NS;
  wire   [1:0] tx_packet_next;

  DFFSR \PS_reg[4]  ( .D(NS[4]), .CLK(clk), .R(n_rst), .S(1'b1), .Q(PS[4]) );
  DFFSR \PS_reg[3]  ( .D(NS[3]), .CLK(clk), .R(n_rst), .S(1'b1), .Q(PS[3]) );
  DFFSR \PS_reg[2]  ( .D(NS[2]), .CLK(clk), .R(n_rst), .S(1'b1), .Q(PS[2]) );
  DFFSR \PS_reg[1]  ( .D(NS[1]), .CLK(clk), .R(n_rst), .S(1'b1), .Q(PS[1]) );
  DFFSR \PS_reg[0]  ( .D(NS[0]), .CLK(clk), .R(n_rst), .S(1'b1), .Q(PS[0]) );
  DFFSR d_mode_reg ( .D(tx_transfer_active_next), .CLK(clk), .R(n_rst), .S(
        1'b1), .Q(d_mode) );
  DFFSR rx_data_ready_reg ( .D(rx_data_ready_next), .CLK(clk), .R(n_rst), .S(
        1'b1), .Q(rx_data_ready) );
  DFFSR rx_transfer_active_reg ( .D(rx_transfer_active_next), .CLK(clk), .R(
        n_rst), .S(1'b1), .Q(rx_transfer_active) );
  DFFSR rx_error_reg ( .D(rx_error_next), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        rx_error) );
  DFFSR tx_transfer_active_reg ( .D(tx_transfer_active_next), .CLK(clk), .R(
        n_rst), .S(1'b1), .Q(tx_transfer_active) );
  DFFSR tx_error_reg ( .D(tx_error_next), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        tx_error) );
  DFFSR clear_reg ( .D(clear_next), .CLK(clk), .R(n_rst), .S(1'b1), .Q(clear)
         );
  DFFSR \tx_packet_reg[1]  ( .D(tx_packet_next[1]), .CLK(clk), .R(n_rst), .S(
        1'b1), .Q(tx_packet[1]) );
  DFFSR \tx_packet_reg[0]  ( .D(tx_packet_next[0]), .CLK(clk), .R(n_rst), .S(
        1'b1), .Q(tx_packet[0]) );
  NAND2X1 U279 ( .A(PS[2]), .B(n371), .Y(n264) );
  NAND2X1 U280 ( .A(n316), .B(n371), .Y(n252) );
  AOI22X1 U281 ( .A(N224), .B(n320), .C(N165), .D(n319), .Y(n231) );
  NAND2X1 U282 ( .A(PS[3]), .B(n316), .Y(n234) );
  NAND2X1 U283 ( .A(PS[2]), .B(PS[3]), .Y(n259) );
  AOI22X1 U284 ( .A(N224), .B(n317), .C(N224), .D(n318), .Y(n230) );
  NAND2X1 U285 ( .A(PS[0]), .B(n372), .Y(n288) );
  NOR2X1 U286 ( .A(n288), .B(PS[4]), .Y(n277) );
  AOI21X1 U287 ( .A(n231), .B(n230), .C(n321), .Y(n242) );
  NOR2X1 U288 ( .A(n313), .B(n372), .Y(n285) );
  XOR2X1 U289 ( .A(PS[0]), .B(n319), .Y(n232) );
  AOI21X1 U290 ( .A(N224), .B(n285), .C(n232), .Y(n240) );
  NAND2X1 U291 ( .A(n313), .B(n370), .Y(n239) );
  OAI22X1 U292 ( .A(N160), .B(n252), .C(N208), .D(n259), .Y(n233) );
  OAI22X1 U293 ( .A(N219), .B(n259), .C(N203), .D(n234), .Y(n236) );
  OAI22X1 U294 ( .A(N172), .B(n252), .C(N186), .D(n264), .Y(n235) );
  OAI21X1 U295 ( .A(n236), .B(n235), .C(PS[1]), .Y(n237) );
  OAI21X1 U296 ( .A(PS[1]), .B(n324), .C(n237), .Y(n238) );
  OAI22X1 U297 ( .A(n370), .B(n240), .C(n239), .D(n238), .Y(n241) );
  OR2X1 U298 ( .A(n242), .B(n241), .Y(NS[0]) );
  AOI22X1 U299 ( .A(N204), .B(n317), .C(N220), .D(n318), .Y(n245) );
  NAND2X1 U300 ( .A(N187), .B(n320), .Y(n244) );
  AOI21X1 U301 ( .A(N173), .B(n319), .C(PS[4]), .Y(n243) );
  NAND3X1 U302 ( .A(n245), .B(n244), .C(n243), .Y(n249) );
  NAND2X1 U303 ( .A(PS[1]), .B(n313), .Y(n287) );
  AOI22X1 U304 ( .A(N214), .B(n320), .C(N166), .D(n319), .Y(n247) );
  AOI22X1 U305 ( .A(N214), .B(n317), .C(N214), .D(n318), .Y(n246) );
  AOI21X1 U306 ( .A(n247), .B(n246), .C(n321), .Y(n248) );
  AOI21X1 U307 ( .A(n249), .B(n314), .C(n248), .Y(n257) );
  NOR2X1 U308 ( .A(PS[0]), .B(PS[1]), .Y(n282) );
  AOI22X1 U309 ( .A(N161), .B(n316), .C(N209), .D(PS[2]), .Y(n250) );
  NOR2X1 U310 ( .A(n315), .B(n250), .Y(n255) );
  NOR2X1 U311 ( .A(n319), .B(n318), .Y(n302) );
  NOR2X1 U312 ( .A(PS[4]), .B(n302), .Y(n254) );
  OAI21X1 U313 ( .A(n252), .B(N225), .C(PS[1]), .Y(n251) );
  OAI21X1 U314 ( .A(n252), .B(n288), .C(n251), .Y(n253) );
  AOI22X1 U315 ( .A(n255), .B(n254), .C(n253), .D(PS[4]), .Y(n256) );
  NAND2X1 U316 ( .A(n257), .B(n256), .Y(NS[1]) );
  AND2X1 U317 ( .A(n371), .B(n285), .Y(n258) );
  AOI21X1 U318 ( .A(n258), .B(N226), .C(PS[2]), .Y(n276) );
  AOI22X1 U319 ( .A(N215), .B(n317), .C(N167), .D(n319), .Y(n263) );
  NOR2X1 U320 ( .A(n259), .B(n287), .Y(n261) );
  NOR2X1 U321 ( .A(PS[0]), .B(n264), .Y(n260) );
  AOI22X1 U322 ( .A(n261), .B(N221), .C(n260), .D(N188), .Y(n262) );
  OAI21X1 U323 ( .A(n313), .B(n263), .C(n262), .Y(n274) );
  AOI22X1 U324 ( .A(N162), .B(n371), .C(N210), .D(PS[2]), .Y(n265) );
  AND2X1 U325 ( .A(n265), .B(n264), .Y(n267) );
  NAND3X1 U326 ( .A(PS[0]), .B(n318), .C(N215), .Y(n266) );
  OAI21X1 U327 ( .A(PS[0]), .B(n267), .C(n266), .Y(n268) );
  AOI21X1 U328 ( .A(N215), .B(n320), .C(n268), .Y(n272) );
  AOI22X1 U329 ( .A(N205), .B(n317), .C(N174), .D(n319), .Y(n269) );
  OAI21X1 U330 ( .A(PS[2]), .B(n313), .C(n269), .Y(n270) );
  NAND2X1 U331 ( .A(n270), .B(PS[1]), .Y(n271) );
  OAI21X1 U332 ( .A(PS[1]), .B(n272), .C(n271), .Y(n273) );
  OAI21X1 U333 ( .A(n274), .B(n273), .C(n370), .Y(n275) );
  OAI21X1 U334 ( .A(n370), .B(n276), .C(n275), .Y(NS[2]) );
  NAND2X1 U335 ( .A(PS[4]), .B(n316), .Y(n280) );
  NAND2X1 U336 ( .A(N227), .B(n285), .Y(n279) );
  NAND3X1 U337 ( .A(n277), .B(n319), .C(N168), .Y(n278) );
  OAI21X1 U338 ( .A(n280), .B(n279), .C(n278), .Y(n297) );
  OAI21X1 U339 ( .A(PS[0]), .B(N189), .C(PS[1]), .Y(n281) );
  OAI21X1 U340 ( .A(n313), .B(n322), .C(n281), .Y(n284) );
  AOI22X1 U341 ( .A(N163), .B(n282), .C(N175), .D(n314), .Y(n283) );
  AOI22X1 U342 ( .A(n284), .B(n320), .C(n323), .D(n319), .Y(n295) );
  NOR2X1 U343 ( .A(n285), .B(n316), .Y(n286) );
  OAI21X1 U344 ( .A(N211), .B(n315), .C(n286), .Y(n292) );
  OAI22X1 U345 ( .A(N222), .B(n372), .C(N216), .D(n313), .Y(n291) );
  NOR2X1 U346 ( .A(N206), .B(n287), .Y(n290) );
  OAI21X1 U347 ( .A(N227), .B(n288), .C(n316), .Y(n289) );
  OAI22X1 U348 ( .A(n292), .B(n291), .C(n290), .D(n289), .Y(n293) );
  OAI21X1 U349 ( .A(PS[4]), .B(n293), .C(PS[3]), .Y(n294) );
  OAI21X1 U350 ( .A(PS[4]), .B(n295), .C(n294), .Y(n296) );
  OR2X1 U351 ( .A(n297), .B(n296), .Y(NS[3]) );
  AOI22X1 U352 ( .A(N190), .B(n320), .C(N176), .D(n319), .Y(n299) );
  AOI22X1 U353 ( .A(N207), .B(n317), .C(N223), .D(n318), .Y(n298) );
  NAND2X1 U354 ( .A(n299), .B(n298), .Y(n300) );
  NAND2X1 U355 ( .A(n314), .B(n300), .Y(n312) );
  NAND2X1 U356 ( .A(PS[0]), .B(n319), .Y(n301) );
  OAI21X1 U357 ( .A(N228), .B(n301), .C(PS[4]), .Y(n311) );
  AOI22X1 U358 ( .A(N164), .B(n316), .C(N212), .D(PS[2]), .Y(n308) );
  OR2X1 U359 ( .A(n302), .B(PS[0]), .Y(n307) );
  AOI22X1 U360 ( .A(N228), .B(n320), .C(N169), .D(n319), .Y(n304) );
  AOI22X1 U361 ( .A(N228), .B(n317), .C(N228), .D(n318), .Y(n303) );
  NAND2X1 U362 ( .A(n304), .B(n303), .Y(n305) );
  NAND2X1 U363 ( .A(PS[0]), .B(n305), .Y(n306) );
  OAI21X1 U364 ( .A(n308), .B(n307), .C(n306), .Y(n309) );
  OAI21X1 U365 ( .A(PS[4]), .B(n309), .C(n372), .Y(n310) );
  NAND3X1 U366 ( .A(n312), .B(n311), .C(n310), .Y(NS[4]) );
  INVX2 U367 ( .A(PS[0]), .Y(n313) );
  INVX2 U368 ( .A(n287), .Y(n314) );
  INVX2 U369 ( .A(n282), .Y(n315) );
  INVX2 U370 ( .A(PS[2]), .Y(n316) );
  INVX2 U371 ( .A(n234), .Y(n317) );
  INVX2 U372 ( .A(n259), .Y(n318) );
  INVX2 U373 ( .A(n252), .Y(n319) );
  INVX2 U374 ( .A(n264), .Y(n320) );
  INVX2 U375 ( .A(n277), .Y(n321) );
  INVX2 U376 ( .A(N227), .Y(n322) );
  INVX2 U377 ( .A(n283), .Y(n323) );
  INVX2 U378 ( .A(n233), .Y(n324) );
  NAND2X1 U379 ( .A(n357), .B(n353), .Y(n338) );
  OR2X1 U380 ( .A(n338), .B(NS[3]), .Y(n326) );
  NAND2X1 U381 ( .A(NS[0]), .B(NS[1]), .Y(n325) );
  OAI21X1 U382 ( .A(n326), .B(n325), .C(n345), .Y(rx_data_ready_next) );
  XOR2X1 U383 ( .A(NS[3]), .B(NS[1]), .Y(n327) );
  OAI21X1 U384 ( .A(n327), .B(n353), .C(n357), .Y(n328) );
  AOI22X1 U385 ( .A(n328), .B(NS[1]), .C(NS[2]), .D(n327), .Y(n334) );
  AOI21X1 U386 ( .A(NS[0]), .B(n357), .C(NS[3]), .Y(n332) );
  NAND2X1 U387 ( .A(n353), .B(n347), .Y(n331) );
  NOR2X1 U388 ( .A(NS[0]), .B(n347), .Y(n329) );
  OAI21X1 U389 ( .A(NS[3]), .B(NS[4]), .C(n329), .Y(n330) );
  OAI21X1 U390 ( .A(n332), .B(n331), .C(n330), .Y(n333) );
  NAND2X1 U391 ( .A(n334), .B(n333), .Y(n336) );
  NAND2X1 U392 ( .A(rx_error), .B(n336), .Y(n335) );
  OAI21X1 U393 ( .A(n346), .B(n336), .C(n335), .Y(rx_error_next) );
  OAI21X1 U394 ( .A(n338), .B(n362), .C(n347), .Y(n337) );
  NAND2X1 U395 ( .A(n346), .B(n337), .Y(n339) );
  AOI21X1 U396 ( .A(n338), .B(NS[1]), .C(n339), .Y(n343) );
  OR2X1 U397 ( .A(n339), .B(NS[4]), .Y(n340) );
  OAI21X1 U398 ( .A(n357), .B(n340), .C(n344), .Y(n341) );
  NAND3X1 U399 ( .A(NS[0]), .B(NS[1]), .C(n341), .Y(n342) );
  OAI21X1 U400 ( .A(n344), .B(n343), .C(n342), .Y(tx_error_next) );
  INVX2 U401 ( .A(tx_error), .Y(n344) );
  INVX2 U402 ( .A(rx_data_ready), .Y(n345) );
  INVX2 U403 ( .A(n327), .Y(n346) );
  INVX2 U404 ( .A(NS[1]), .Y(n347) );
  NAND3X1 U405 ( .A(n348), .B(n349), .C(n350), .Y(tx_transfer_active_next) );
  OAI21X1 U406 ( .A(n351), .B(n352), .C(n353), .Y(n350) );
  MUX2X1 U407 ( .B(NS[1]), .A(n354), .S(n355), .Y(n352) );
  NAND2X1 U408 ( .A(NS[0]), .B(NS[2]), .Y(n354) );
  INVX1 U409 ( .A(tx_packet_next[1]), .Y(n349) );
  NAND3X1 U410 ( .A(n356), .B(n357), .C(NS[0]), .Y(n348) );
  OAI22X1 U411 ( .A(n358), .B(n359), .C(n360), .D(n361), .Y(tx_packet_next[1])
         );
  NAND2X1 U412 ( .A(NS[2]), .B(n362), .Y(n361) );
  NAND3X1 U413 ( .A(n355), .B(n353), .C(n347), .Y(n360) );
  OAI21X1 U414 ( .A(n358), .B(n359), .C(n363), .Y(tx_packet_next[0]) );
  NAND3X1 U415 ( .A(NS[3]), .B(n353), .C(n351), .Y(n363) );
  INVX1 U416 ( .A(n364), .Y(n351) );
  NAND3X1 U417 ( .A(NS[1]), .B(n357), .C(NS[0]), .Y(n364) );
  MUX2X1 U418 ( .B(n356), .A(n365), .S(n347), .Y(n358) );
  NOR2X1 U419 ( .A(NS[4]), .B(n355), .Y(n365) );
  NOR2X1 U420 ( .A(n366), .B(n367), .Y(rx_transfer_active_next) );
  NAND2X1 U421 ( .A(n368), .B(n357), .Y(n367) );
  XNOR2X1 U422 ( .A(n347), .B(NS[0]), .Y(n368) );
  NAND2X1 U423 ( .A(n355), .B(n353), .Y(n366) );
  INVX1 U424 ( .A(NS[3]), .Y(n355) );
  NOR2X1 U425 ( .A(n359), .B(n369), .Y(clear_next) );
  NAND2X1 U426 ( .A(n356), .B(n347), .Y(n369) );
  NOR2X1 U427 ( .A(n353), .B(NS[3]), .Y(n356) );
  INVX1 U428 ( .A(NS[4]), .Y(n353) );
  NAND2X1 U429 ( .A(n362), .B(n357), .Y(n359) );
  INVX1 U430 ( .A(NS[2]), .Y(n357) );
  INVX1 U431 ( .A(NS[0]), .Y(n362) );
  NOR2X1 U432 ( .A(tx_done), .B(n370), .Y(N228) );
  NOR2X1 U433 ( .A(tx_done), .B(n371), .Y(N227) );
  NOR2X1 U434 ( .A(tx_done), .B(n316), .Y(N226) );
  NOR2X1 U435 ( .A(tx_done), .B(n372), .Y(N225) );
  NOR2X1 U436 ( .A(tx_done), .B(n313), .Y(N224) );
  NOR2X1 U437 ( .A(n373), .B(n370), .Y(N223) );
  OAI21X1 U438 ( .A(n373), .B(n371), .C(n374), .Y(N222) );
  OAI21X1 U439 ( .A(n373), .B(n316), .C(n374), .Y(N221) );
  OAI21X1 U440 ( .A(n373), .B(n372), .C(n374), .Y(N220) );
  OAI21X1 U441 ( .A(n373), .B(n313), .C(n374), .Y(N219) );
  NAND2X1 U442 ( .A(rx_packet[0]), .B(n373), .Y(n374) );
  NOR2X1 U443 ( .A(n375), .B(rx_packet[1]), .Y(n373) );
  NAND2X1 U444 ( .A(n376), .B(n371), .Y(N216) );
  NAND2X1 U445 ( .A(n376), .B(n316), .Y(N215) );
  NAND2X1 U446 ( .A(n376), .B(n372), .Y(N214) );
  INVX1 U447 ( .A(tx_done), .Y(n376) );
  NOR2X1 U448 ( .A(n377), .B(n370), .Y(N212) );
  NAND2X1 U449 ( .A(n371), .B(n378), .Y(N211) );
  NAND2X1 U450 ( .A(n316), .B(n378), .Y(N210) );
  NOR2X1 U451 ( .A(n377), .B(n372), .Y(N209) );
  NAND2X1 U452 ( .A(n313), .B(n378), .Y(N208) );
  OAI21X1 U453 ( .A(n370), .B(n379), .C(n380), .Y(N207) );
  OAI21X1 U454 ( .A(n371), .B(n379), .C(n381), .Y(N206) );
  NOR2X1 U455 ( .A(n316), .B(n379), .Y(N205) );
  OAI21X1 U456 ( .A(n372), .B(n379), .C(n381), .Y(N204) );
  OR2X1 U457 ( .A(n379), .B(PS[0]), .Y(N203) );
  NAND2X1 U458 ( .A(n380), .B(n381), .Y(n379) );
  NAND2X1 U459 ( .A(n382), .B(n383), .Y(n381) );
  INVX1 U460 ( .A(n384), .Y(n383) );
  INVX1 U461 ( .A(n385), .Y(n380) );
  OAI21X1 U462 ( .A(n382), .B(n384), .C(n386), .Y(n385) );
  NOR2X1 U463 ( .A(n387), .B(n388), .Y(n382) );
  NAND3X1 U464 ( .A(n389), .B(n390), .C(n391), .Y(n388) );
  XNOR2X1 U465 ( .A(buffer_occupancy[5]), .B(tx_packet_data_size[5]), .Y(n391)
         );
  XNOR2X1 U466 ( .A(buffer_occupancy[6]), .B(tx_packet_data_size[6]), .Y(n390)
         );
  XNOR2X1 U467 ( .A(buffer_occupancy[4]), .B(tx_packet_data_size[4]), .Y(n389)
         );
  NAND3X1 U468 ( .A(n392), .B(n393), .C(n394), .Y(n387) );
  NOR2X1 U469 ( .A(n395), .B(n396), .Y(n394) );
  XNOR2X1 U470 ( .A(tx_packet_data_size[1]), .B(n397), .Y(n396) );
  XNOR2X1 U471 ( .A(tx_packet_data_size[0]), .B(n398), .Y(n395) );
  XNOR2X1 U472 ( .A(buffer_occupancy[2]), .B(tx_packet_data_size[2]), .Y(n393)
         );
  XNOR2X1 U473 ( .A(buffer_occupancy[3]), .B(tx_packet_data_size[3]), .Y(n392)
         );
  NOR2X1 U474 ( .A(n370), .B(n399), .Y(N190) );
  NOR2X1 U475 ( .A(n371), .B(n399), .Y(N189) );
  OAI21X1 U476 ( .A(n316), .B(n399), .C(n400), .Y(N188) );
  OAI21X1 U477 ( .A(n372), .B(n399), .C(n400), .Y(N187) );
  OAI21X1 U478 ( .A(n313), .B(n399), .C(n400), .Y(N186) );
  NAND2X1 U479 ( .A(n378), .B(n401), .Y(n400) );
  NAND2X1 U480 ( .A(n402), .B(n378), .Y(n399) );
  INVX1 U481 ( .A(n377), .Y(n378) );
  NOR2X1 U482 ( .A(n403), .B(n404), .Y(n377) );
  NAND3X1 U483 ( .A(n397), .B(n405), .C(n398), .Y(n404) );
  INVX1 U484 ( .A(buffer_occupancy[0]), .Y(n398) );
  INVX1 U485 ( .A(buffer_occupancy[2]), .Y(n405) );
  INVX1 U486 ( .A(buffer_occupancy[1]), .Y(n397) );
  NAND3X1 U487 ( .A(n406), .B(n407), .C(n408), .Y(n403) );
  NOR2X1 U488 ( .A(buffer_occupancy[6]), .B(buffer_occupancy[5]), .Y(n408) );
  INVX1 U489 ( .A(buffer_occupancy[4]), .Y(n407) );
  INVX1 U490 ( .A(buffer_occupancy[3]), .Y(n406) );
  OAI21X1 U491 ( .A(n370), .B(n409), .C(n410), .Y(N176) );
  NOR2X1 U492 ( .A(n371), .B(n409), .Y(N175) );
  NOR2X1 U493 ( .A(n316), .B(n409), .Y(N174) );
  OAI21X1 U494 ( .A(n372), .B(n409), .C(n411), .Y(N173) );
  OAI21X1 U495 ( .A(n313), .B(n409), .C(n411), .Y(N172) );
  NAND2X1 U496 ( .A(n410), .B(n411), .Y(n409) );
  NAND3X1 U497 ( .A(n412), .B(n375), .C(n413), .Y(n411) );
  NOR2X1 U498 ( .A(n414), .B(n370), .Y(N169) );
  NOR2X1 U499 ( .A(n414), .B(n371), .Y(N168) );
  NOR2X1 U500 ( .A(n414), .B(n316), .Y(N167) );
  NAND2X1 U501 ( .A(n372), .B(n415), .Y(N166) );
  NOR2X1 U502 ( .A(n414), .B(n313), .Y(N165) );
  INVX1 U503 ( .A(n415), .Y(n414) );
  NAND3X1 U504 ( .A(n412), .B(n375), .C(rx_packet[0]), .Y(n415) );
  INVX1 U505 ( .A(rx_packet[1]), .Y(n412) );
  OAI21X1 U506 ( .A(n370), .B(n416), .C(n417), .Y(N164) );
  AND2X1 U507 ( .A(n384), .B(n410), .Y(n417) );
  INVX1 U508 ( .A(PS[4]), .Y(n370) );
  OAI21X1 U509 ( .A(n371), .B(n416), .C(n418), .Y(N163) );
  INVX1 U510 ( .A(PS[3]), .Y(n371) );
  NOR2X1 U511 ( .A(n316), .B(n416), .Y(N162) );
  OAI21X1 U512 ( .A(n372), .B(n416), .C(n418), .Y(N161) );
  NAND3X1 U513 ( .A(n402), .B(n410), .C(buffer_reserved), .Y(n418) );
  INVX1 U514 ( .A(PS[1]), .Y(n372) );
  OR2X1 U515 ( .A(n401), .B(n419), .Y(N160) );
  OAI21X1 U516 ( .A(n313), .B(n416), .C(n410), .Y(n419) );
  NAND3X1 U517 ( .A(n410), .B(n420), .C(n402), .Y(n416) );
  INVX1 U518 ( .A(n401), .Y(n402) );
  INVX1 U519 ( .A(buffer_reserved), .Y(n420) );
  NAND3X1 U520 ( .A(rx_packet[2]), .B(n413), .C(rx_packet[1]), .Y(n410) );
  NAND2X1 U521 ( .A(n386), .B(n384), .Y(n401) );
  NAND3X1 U522 ( .A(rx_packet[0]), .B(n375), .C(rx_packet[1]), .Y(n384) );
  NAND3X1 U523 ( .A(n413), .B(n375), .C(rx_packet[1]), .Y(n386) );
  INVX1 U524 ( .A(rx_packet[2]), .Y(n375) );
  INVX1 U525 ( .A(rx_packet[0]), .Y(n413) );
endmodule

