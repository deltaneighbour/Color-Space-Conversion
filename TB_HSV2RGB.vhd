----------------------------------------------------------------------------------
-- Company:             IIT, Madras
-- Engineer:            Urvish Markad   
-- 
-- Create Date:         
-- Design Name:         HSV2RGB
-- Module Name:         HSV2RGB_TB - Behavioral
-- Project Name:        HSV2RGB Test Bench
-- Target Devices:      Xilinx Zynq ZC7020 Evaluation Kit
-- Tool Versions:       Vivado 2018.1
-- Description:         
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- Not a self-testing testbench
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

Entity HSV2RGB_TB is
End HSV2RGB_TB;

Architecture Behavioral of HSV2RGB_TB is

Component HSV2RGB is
 Port ( 
     Clk 							: In  STD_LOGIC;
     Aresetn 						: In  STD_LOGIC;
     S_Axis_Video_Tvalid 			: In  STD_LOGIC;
     S_Axis_Video_Tdata 			: In  STD_LOGIC_VECTOR (23 downto 0);
     S_Axis_Video_Tuser_SOF         : In  STD_LOGIC;
     S_Axis_Video_Tlast 			: In  STD_LOGIC;
     M_Axis_Video_Tvalid 			: Out STD_LOGIC;
     M_Axis_Video_Tdata 			: Out STD_LOGIC_VECTOR (23 downto 0);
     M_Axis_Video_Tuser_SOF 		: Out STD_LOGIC;
     M_Axis_Video_Tlast  			: Out STD_LOGIC
 );
End Component;

Constant            CLK_PERIOD                          :   Time := 100 ns;

Signal              Clk                                 :   Std_Logic;
Signal              Aresetn                             :   Std_Logic;
Signal              S_Axis_Video_Tvalid                 :   Std_Logic;
Signal              S_Axis_Video_Tdata                  :   Std_Logic_Vector(23 Downto 0);
Signal              S_Axis_Video_Tuser_SOF              :   Std_Logic;
Signal              S_Axis_Video_Tlast                  :   Std_Logic;

Signal              M_Axis_Video_Tvalid                 :   Std_Logic;
Signal              M_Axis_Video_Tdata                  :   Std_Logic_Vector(23 Downto 0);
Signal              M_Axis_Video_Tuser_SOF              :   Std_Logic;
Signal              M_Axis_Video_Tlast                  :   Std_Logic;              

Begin

DUT: HSV2RGB
 Port Map( 
     Clk 					  => Clk,					
     Aresetn 				  => Aresetn, 				
     S_Axis_Video_Tvalid 	  => S_Axis_Video_Tvalid, 	
     S_Axis_Video_Tdata 	  => S_Axis_Video_Tdata, 	
     S_Axis_Video_Tuser_SOF   => S_Axis_Video_Tuser_SOF, 
     S_Axis_Video_Tlast 	  => S_Axis_Video_Tlast, 	
     M_Axis_Video_Tvalid 	  => M_Axis_Video_Tvalid, 	
     M_Axis_Video_Tdata 	  => M_Axis_Video_Tdata, 	
     M_Axis_Video_Tuser_SOF   => M_Axis_Video_Tuser_SOF, 
     M_Axis_Video_Tlast  	  => M_Axis_Video_Tlast  	
);

ClkGen:Process
Begin
Clk         <= '1';
Wait For CLK_PERIOD/2;
Clk         <= '0';
Wait For CLK_PERIOD/2;
End Process;


ArstGen: Process
Begin
Aresetn     <= '0';
Wait For 3*CLK_PERIOD;
Aresetn     <= '1';
Wait;
End Process;
 

ValidGen: Process
Begin
S_Axis_Video_Tvalid             <= '0';
Wait For 4*CLK_PERIOD;
S_Axis_Video_Tvalid             <= '1';
Wait;
End Process;

DataGen: Process
Begin
S_Axis_Video_Tdata          <= X"000000";
Wait For 4*CLK_PERIOD;

S_Axis_Video_Tdata          <= X"00FFFF";       --Red Will Result
Wait For CLK_PERIOD;

S_Axis_Video_Tdata          <= X"3CFFFF";        --Green Will Result    
Wait For CLK_PERIOD;

S_Axis_Video_Tdata          <= X"78FFFF";       --Blue Will Result
Wait For CLK_PERIOD;

S_Axis_Video_Tdata          <= X"1EFFFF";        --Yellow Will Result
Wait For CLK_PERIOD;

S_Axis_Video_Tdata          <= X"80FFFF";         --White Will Result   
Wait;
End Process;

SOF_Gen:Process
Begin
S_Axis_Video_Tuser_SOF  <= '0';
Wait For 4*CLK_PERIOD;
S_Axis_Video_Tuser_SOF  <= '1';
Wait For CLK_PERIOD;
S_Axis_Video_Tuser_SOF  <= '0';
Wait;
End Process;

Last_Gen:Process
Begin
S_Axis_Video_Tlast  <= '0';
Wait For 8*CLK_PERIOD;
S_Axis_Video_Tlast  <= '1';
Wait For CLK_PERIOD;
S_Axis_Video_Tlast  <= '0';
Wait;
End Process;

End Behavioral;
