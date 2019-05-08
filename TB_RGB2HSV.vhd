----------------------------------------------------------------------------------
-- Company:                     IIT, Madras
-- Engineer:                    Urvish Markad
--          
-- Create Date:                 --
-- Design Name:                 RGB2HSV
-- Module Name:                 RGB2HSV_TB - Behavioral
-- Project Name:                RGB2HSV Test Bench
-- Target Devices:              Xilinx ZC7020 Evaluation Kit    
-- Tool Versions:               Vivado 2018.1
-- Description:     
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;


Entity RGB2HSV_TB is
End RGB2HSV_TB;

Architecture Behavioral of RGB2HSV_TB is

Component RGB2HSV is
 Port ( 
   Clk                      :   In  Std_Logic;
   Aresetn                  :   In  Std_Logic;
   S_Axis_Video_Tvalid      :   In  Std_Logic;
   S_Axis_Video_Tdata       :   In  Std_Logic_Vector(23 Downto 0);
   S_Axis_Video_Tuser_SOF   :   In  Std_Logic;
   S_Axis_Video_Tlast       :   In  Std_Logic;
   M_Axis_Video_Tvalid      :   Out Std_Logic;
   M_Axis_Video_Tdata       :   Out Std_Logic_Vector(23 Downto 0);
   M_Axis_Video_Tuser_SOF   :   Out Std_Logic;
   M_Axis_Video_Tlast       :   Out Std_Logic
);
End Component;

Constant            CLK_PERIOD                   :          Time    := 100 ns;

Signal				Clk 					     :			Std_Logic;
Signal				Aresetn 				     :			Std_Logic;
Signal				S_Axis_Video_Tvalid 	     :			Std_Logic;
Signal				S_Axis_Video_Tdata 	         :			Std_Logic_Vector(23 Downto 0);
Signal				S_Axis_Video_Tuser_SOF       :			Std_Logic;
Signal				S_Axis_Video_Tlast 	         :			Std_Logic;
Signal				M_Axis_Video_Tvalid 	     :			Std_Logic;
Signal				M_Axis_Video_Tdata 	         :			Std_Logic_Vector(23 Downto 0);
Signal				M_Axis_Video_Tuser_SOF       :			Std_Logic;
Signal				M_Axis_Video_Tlast  	     :			Std_Logic;




Begin

DUT: RGB2HSV
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


ClkGen: Process
Begin
Clk         <= '1';
Wait For    CLK_PERIOD/2;
Clk         <=  '0';
Wait For    CLK_PERIOD/2;
End Process;


ArstGen:Process
Begin
Aresetn     <= '0';
Wait For 3*CLK_PERIOD;
Aresetn     <= '1';
Wait;
End Process;


ValidGen: Process
Begin
S_Axis_Video_Tvalid         <= '0';
Wait For  4*CLK_PERIOD;
S_Axis_Video_Tvalid         <= '1';
Wait;
End Process;

DataGen: Process
Begin
S_Axis_Video_Tdata          <= X"000000";
Wait For    4*CLK_PERIOD;
S_Axis_Video_Tdata          <= X"FF0000";
Wait For CLK_PERIOD;
S_Axis_Video_Tdata          <= X"0000FF";
Wait For CLK_PERIOD;
S_Axis_Video_Tdata          <= X"00FF00";
Wait For CLK_PERIOD;
S_Axis_Video_Tdata          <= X"FFFFFF";
Wait For CLK_PERIOD;
S_Axis_Video_Tdata          <= X"FFFF00";
Wait For CLK_PERIOD;
S_Axis_Video_Tdata          <= X"000000";
Wait;
End Process;

SOF_Gen: Process
Begin
S_Axis_Video_Tuser_SOF      <= '0';
Wait For 4*CLK_PERIOD;
S_Axis_Video_Tuser_SOF      <= '1';
Wait For CLK_PERIOD;
S_Axis_Video_Tuser_SOF      <= '0';
Wait;
End Process;

LastGen: Process
Begin
S_Axis_Video_Tlast      <= '0';
Wait For 8*CLK_PERIOD;
S_Axis_Video_Tlast      <= '1';
Wait For CLK_PERIOD;
S_Axis_Video_Tlast      <= '0';
Wait;
End Process;

End Behavioral;
