----------------------------------------------------------------------------------
-- Company:             IIT, Madras
-- Engineer:            Urvish Markad
--      
-- Create Date:         
-- Design Name:         HSV2RGB Version 2
-- Module Name:         HSV2RGB - Behavioral
-- Project Name:        
-- Target Devices:      ZC702 Evaluation Kit 
-- Tool Versions:       Vivado 2018.1
-- Description:         
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision             0.01 - File Created
-- Additional Comments:
-- IPs instantiations have been named in following manner:
-- <Use Case>_L<Latency>_<IP Name>_<IP Number>
-- For all the Naming Conventions in the Code, Please See The Following Equation
-- <https://www.rapidtables.com/convert/color/hsv-to-rgb.html>
-- Note that the modulo operation is real. Adjusted using subtraction. 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

Entity HSV2RGB is
 Port ( 
     Clk 							: In  STD_LOGIC;
     Aresetn 						: In  STD_LOGIC;
     S_Axis_Video_Tvalid 			: In  STD_LOGIC;
     S_Axis_Video_Tdata 			: In  STD_LOGIC_VECTOR (23 downto 0);
     S_Axis_Video_Tuser_SOF         : In  STD_LOGIC;
     S_Axis_Video_Tlast 			: In  STD_LOGIC;
     S_Axis_Video_Tready            : Out Std_Logic;
     
     M_Axis_Video_Tvalid 			: Out STD_LOGIC;
     M_Axis_Video_Tdata 			: Out STD_LOGIC_VECTOR (23 downto 0);
     M_Axis_Video_Tuser_SOF 		: Out STD_LOGIC;
     M_Axis_Video_Tlast  			: Out STD_LOGIC;
     M_Axis_Video_Tready            : In  Std_Logic
 );
End HSV2RGB;

Architecture Behavioral of HSV2RGB is

COMPONENT Fix2Flo_L6_Floating_Point_0
PORT (
 Aclk                    : IN  STD_LOGIC;
 S_Axis_A_Tvalid         : IN  STD_LOGIC;
 S_Axis_A_Tdata          : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
 M_Axis_Result_Tvalid    : OUT STD_LOGIC;
 M_Axis_Result_Tdata     : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
);
END COMPONENT;

COMPONENT Multiply_L8_Floating_Point_1
 PORT (
  Aclk                    : IN  STD_LOGIC;
  S_Axis_A_Tvalid         : IN  STD_LOGIC;
  S_Axis_A_Tdata          : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
  S_Axis_B_Tvalid         : IN  STD_LOGIC;
  S_Axis_B_Tdata          : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
  M_Axis_Result_Tvalid    : OUT STD_LOGIC;
  M_Axis_Result_Tdata     : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
 );
END COMPONENT;

COMPONENT Delay_L8_C_Shift_Ram_0
  PORT (
    D                     : IN  STD_LOGIC_VECTOR(32 DOWNTO 0);
    CLK                   : IN  STD_LOGIC;
    Q                     : OUT STD_LOGIC_VECTOR(32 DOWNTO 0)
  );
END COMPONENT;

COMPONENT AddSub_L11_Floating_Point_2
 PORT (
  Aclk                    : IN  STD_LOGIC;
  S_Axis_A_Tvalid         : IN  STD_LOGIC;
  S_Axis_A_Tdata          : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
  S_Axis_B_Tvalid         : IN  STD_LOGIC;
  S_Axis_B_Tdata          : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
  S_Axis_Operation_Tvalid : IN  STD_LOGIC;
  S_Axis_Operation_Tdata  : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
  M_Axis_Result_Tvalid    : OUT STD_LOGIC;
  M_Axis_Result_Tdata     : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
 );
END COMPONENT;

COMPONENT Comparator_L2_Floating_Point_3
  PORT (
    Aclk                    : IN  STD_LOGIC;
    S_Axis_A_Tvalid         : IN  STD_LOGIC;
    S_Axis_A_Tdata          : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
    S_Axis_B_Tvalid         : IN  STD_LOGIC;
    S_Axis_B_Tdata          : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
    S_Axis_Operation_Tvalid : IN  STD_LOGIC;
    S_Axis_Operation_Tdata  : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
    M_Axis_Result_Tvalid    : OUT STD_LOGIC;
    M_Axis_Result_Tdata     : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
  );
END COMPONENT;

COMPONENT Delay_L3_C_Shift_Ram_1
  PORT (
   D                        : IN  STD_LOGIC_VECTOR(32 DOWNTO 0);
   CLK                      : IN  STD_LOGIC;
   Q                        : OUT STD_LOGIC_VECTOR(32 DOWNTO 0)
 );
END COMPONENT;

COMPONENT Delay_L17_C_Shift_Ram_2
  PORT (
   D                        : IN  STD_LOGIC_VECTOR(32 DOWNTO 0);
   CLK                      : IN  STD_LOGIC;
   Q                        : OUT STD_LOGIC_VECTOR(32 DOWNTO 0)
 );
END COMPONENT;

COMPONENT Absolute_Value_L0_Floating_Point_4
PORT (
 S_Axis_A_Tvalid 			: IN  STD_LOGIC;
 S_Axis_A_Tdata 			: IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
 M_Axis_Result_Tvalid 		: OUT STD_LOGIC;
 M_Axis_Result_Tdata 		: OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
);
END COMPONENT;

COMPONENT Delay_L47_C_Shift_Ram_3
PORT (
 D                          : IN  STD_LOGIC_VECTOR(9 DOWNTO 0);
 CLK                        : IN  STD_LOGIC;
 Q                          : OUT STD_LOGIC_VECTOR(9 DOWNTO 0)
  );
END COMPONENT;

COMPONENT Delay_L15_C_Shift_Ram_4
PORT (
 D                          : IN  STD_LOGIC_VECTOR(32 DOWNTO 0);
 CLK                        : IN  STD_LOGIC;
 Q                          : OUT STD_LOGIC_VECTOR(32 DOWNTO 0)
);
END COMPONENT;

COMPONENT Flo2Fix_L6_Floating_Point_5
PORT (
 Aclk 					    : IN  STD_LOGIC;
 S_Axis_A_tvalid 		    : IN  STD_LOGIC;
 S_Axis_A_tdata 		    : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
 M_Axis_Result_Tvalid 	    : OUT STD_LOGIC;
 M_Axis_Result_Tdata 	    : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
  );
END COMPONENT;

COMPONENT Delay_L73_C_Shift_Ram_5
PORT (
 D                          : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
 CLK                        : IN  STD_LOGIC;
 Q                          : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
  );
END COMPONENT;


Signal      Hue                             :   Std_Logic_Vector(15 Downto 00);
Signal      Sat                             :   Std_Logic_Vector(15 Downto 00);
Signal      Val                             :   Std_Logic_Vector(15 Downto 00);

Signal      Val_Float                       :   Std_Logic_Vector(31 Downto 00);
Signal      Val_Float_Valid                 :   Std_Logic;

Signal      Sat_Float                       :   Std_Logic_Vector(31 Downto 00);
Signal      Sat_Float_Valid                 :   Std_Logic;
 
Constant    Single_Precision_INV255         :   Std_Logic_Vector(31 Downto 00) := X"3B80_8081"; --1/255 
Constant    Single_Precision_INV255_Valid   :   Std_Logic := '1';

Constant    Single_Precision_INV60          :   Std_Logic_Vector(31 Downto 00) := X"3C88_8889"; --1/60 
Constant    Single_Precision_INV60_Valid    :   Std_Logic := '1';

Constant    Single_Precision_255            :   Std_Logic_Vector(31 Downto 0) := X"437F0000";    --255
Constant    Single_Precision_255_Valid      :   Std_Logic := '1';

Signal      Sat_Norm                        :   Std_Logic_Vector(31 Downto 00);
Signal      Sat_Norm_Valid                  :   Std_Logic;

Signal      Val_Norm                        :   Std_Logic_Vector(31 Downto 00);
Signal      Val_Norm_Valid                  :   Std_Logic;

Signal      Val_Norm_D8                     :   Std_Logic_Vector(31 Downto 00);
Signal      Val_Norm_D8_Valid               :   Std_Logic;

Signal      C                               :   Std_Logic_Vector(31 Downto 00);
Signal      C_Valid                         :   Std_Logic;

Signal      C_D17                           :   Std_Logic_Vector(31 Downto 00);
Signal      C_D17_Valid                     :   Std_Logic;

Signal      C_D25                           :   Std_Logic_Vector(31 Downto 00);
Signal      C_D25_Valid                     :   Std_Logic;

Signal      M                               :   Std_Logic_Vector(31 Downto 00);
Signal      M_Valid                         :   Std_Logic;

Constant    OP_Add                          :   Std_Logic_Vector(07 Downto 00) := X"00";
Constant    OP_Add_Valid                    :   Std_Logic := '1';
    
Constant    OP_Sub                          :   Std_Logic_Vector(07 Downto 00) := X"01";
Constant    OP_Sub_Valid                    :   Std_Logic := '1';     

Signal      Hue_by_60                       :   Std_Logic_Vector(31 Downto 00);
Signal      Hue_by_60_Valid                 :   Std_Logic;

Signal      Hue_Float                       :   Std_Logic_Vector(31 Downto 00);
Signal      Hue_Float_Valid                 :   Std_Logic; 

Constant    OP_GEQ                          :   Std_Logic_Vector(7 Downto 0) := "00110100";    --Greater Than Or Equal to 
Constant    OP_GEQ_Valid                    :   Std_Logic := '1';

Constant    OP_LT                           :   Std_Logic_Vector(7 Downto 0) := "00001100";    --Less Than 
Constant    OP_LT_Valid                     :   Std_Logic := '1';

Constant    Single_Precision_2              :   Std_Logic_Vector(31 Downto 0) := X"40000000";  --Decimal 2
Constant    Single_Precision_2_Valid        :   Std_Logic := '1';

Constant    Single_Precision_4              :   Std_Logic_Vector(31 Downto 0) := X"40800000";  --Decimal 4
Constant    Single_Precision_4_Valid        :   Std_Logic := '1';

Constant    Single_Precision_6              :   Std_Logic_Vector(31 Downto 0) := X"40C00000";  --Decimal 6
Constant    Single_Precision_6_Valid        :   Std_Logic := '1';

Constant    Single_Precision_1              :   Std_Logic_Vector(31 Downto 0) := X"3F800000";  --Decimal 1
Constant    Single_Precision_1_Valid        :   Std_Logic := '1';

Signal      A_LT_2                          :   Std_Logic_Vector(7 Downto 0);                  -- Note: A= H/60
Signal      A_LT_2_Valid                    :   Std_Logic;

Signal      A_GEQ_2                         :   Std_Logic_Vector(7 Downto 0);
Signal      A_GEQ_2_Valid                   :   Std_Logic;

Signal      A_LT_4                          :   Std_Logic_Vector(7 Downto 0);
Signal      A_LT_4_Valid                    :   Std_Logic;

Signal      A_GEQ_4                         :   Std_Logic_Vector(7 Downto 0);
Signal      A_GEQ_4_Valid                   :   Std_Logic;

Signal      A_LT_6                          :   Std_Logic_Vector(7 Downto 0);
Signal      A_LT_6_Valid                    :   Std_Logic;  

Signal      Sub_Num                         :   Std_Logic_Vector(31 Downto 0);
Signal      Sub_Num_Valid                   :   Std_Logic;

Signal      Hue_By_60_D3                    :   Std_Logic_Vector(31 Downto 0);
Signal      Hue_By_60_D3_Valid              :   Std_Logic;      

Signal      H60_Mod2_M1                     :   Std_Logic_Vector(31 Downto 0);          --(Result of H/60 mod 2 - 1)
Signal      H60_Mod2_M1_Valid               :   Std_Logic;                              --Hby60Mod2Minus1

Signal      Absolute_Value                  :   Std_Logic_Vector(31 Downto 0);
Signal      Absolute_Value_Valid            :   Std_Logic;

Signal      One_Minus_Abs_Val               :   Std_Logic_Vector(31 Downto 0);          -- [1 - Absolute Value]
Signal      One_Minus_Abs_Val_Valid         :   Std_Logic;

Signal      X                               :   Std_Logic_Vector(31 Downto 0);
Signal      X_Valid                         :   Std_Logic;    

Signal      Hue_D47                         :   Std_Logic_Vector(8 Downto 0);
Signal      Hue_D47_Valid                   :   Std_Logic;

Signal      Red_Dash                        :   Std_Logic_Vector(31 Downto 0);
Signal      Red_Dash_Valid                  :   Std_Logic;

Signal      Green_Dash                      :   Std_Logic_Vector(31 Downto 0);
Signal      Green_Dash_Valid                :   Std_Logic;

Signal      Blue_Dash                       :   Std_Logic_Vector(31 Downto 0);
Signal      Blue_Dash_Valid                 :   Std_Logic;

Signal      M_D15                           :   Std_Logic_Vector(31 Downto 0);
Signal      M_D15_Valid                     :   Std_Logic;

Signal      Red_Float                       :   Std_Logic_Vector(31 Downto 0);
Signal      Red_Float_Valid                 :   Std_Logic;

Signal      Green_Float                     :   Std_Logic_Vector(31 Downto 0);
Signal      Green_Float_Valid               :   Std_Logic;

Signal      Blue_Float                      :   Std_Logic_Vector(31 Downto 0);
Signal      Blue_Float_Valid                :   Std_Logic;

Signal      Red_Scaled                      :   Std_Logic_Vector(31 Downto 0);
Signal      Red_Scaled_Valid                :   Std_Logic;

Signal      Green_Scaled                    :   Std_Logic_Vector(31 Downto 0);
Signal      Green_Scaled_Valid              :   Std_Logic;

Signal      Blue_Scaled                     :   Std_Logic_Vector(31 Downto 0);
Signal      Blue_Scaled_Valid               :   Std_Logic;

Signal      Red                             :   Std_Logic_Vector(15 Downto 0);
Signal      Red_Valid                       :   Std_Logic;

Signal      Green                           :   Std_Logic_Vector(15 Downto 0);
Signal      Green_Valid                     :   Std_Logic;

Signal      Blue                            :   Std_Logic_Vector(15 Downto 0);
Signal      Blue_Valid                      :   Std_Logic;


                         
Begin

Hue                                 <=  "0000000" & S_Axis_Video_Tdata(23 Downto 16) & '0';   --Hue/2 is received, We Left Shift it here so that we get the Hue Component
Sat                                 <=  X"00" & S_Axis_Video_Tdata(15 Downto 08);
Val                                 <=  X"00" & S_Axis_Video_Tdata(07 Downto 00);


SubNumSel: Process(Clk, Aresetn)
Begin
If(Aresetn = '0') Then
    Sub_Num             <=  (Others=>'0');
    Sub_Num_Valid       <= '0';
Elsif(Rising_Edge(Clk)) Then
    If(A_LT_2_Valid = '1' And A_GEQ_2_Valid = '1' And A_LT_4_Valid = '1' And A_GEQ_4_Valid = '1' And A_LT_6_Valid = '1') Then             --All Other Valid Flags are HIGH/LOW Simultaniously
        If(A_LT_2(0) = '1') Then                                                                                                          --LSB is turned HIGH if the comparator output is TRUE
            Sub_Num         <=  X"3F800000";     --Single Precision 1  (0 + 1)
            Sub_Num_Valid   <=  '1';
        Elsif(A_GEQ_2(0) = '1' And A_LT_4(0) = '1') Then
            Sub_Num         <=  X"40400000";     --Single Precision 3  (2 + 1)
            Sub_Num_Valid   <=  '1';
        Elsif(A_GEQ_4(0) = '1' And A_LT_6(0) = '1') Then
            Sub_Num         <=  X"40A00000";     --Single Precision 5  (4 + 1)
            Sub_Num_Valid   <=  '1';
        Else
            Sub_Num         <=  X"40E00000";     --Single Precision 7  (6 + 1)
            Sub_Num_Valid   <=  '1';                 
        End If;
    Else
        Sub_Num         <= (Others=>'0');
        Sub_Num_Valid   <= '0';
    End If;         
Else
    Sub_Num         <=  Sub_Num;
    Sub_Num_Valid   <=  Sub_Num_Valid;
End If;                                              
End Process;

RGBDashSel: Process(Clk, Aresetn)                                                                                                       --Selection of R'G'B' Depending on Hue Value [Refer Equation Given in Top Comment]
Begin
If(Aresetn = '0') Then
    Red_Dash            <=  (Others=>'0');
    Red_Dash_Valid      <=  '0';
    
    Green_Dash          <= (Others=>'0');
    Green_Dash_Valid    <= '0';
    
    Blue_Dash           <= (Others=>'0');
    Blue_Dash_Valid     <= '0';

 Elsif(Rising_Edge(Clk)) Then
    If((Hue_D47 >= 0 And Hue_D47 < 60) Or Hue_D47 = 360) Then                                                                           --Hue has been delayed to time-match the R'G'B' Signals
        If(Hue_D47_Valid = '1') Then
            Red_Dash           <=  C_D25;
            Red_Dash_Valid     <=   '1';
        
            Green_Dash         <=  X;
            Green_Dash_Valid   <=  '1';
        
            Blue_Dash          <= (Others=>'0');
            Blue_DAsh_Valid    <= '1';
         Else     
            Red_Dash           <=  C_D25;
            Red_Dash_Valid     <=   '0';
     
            Green_Dash         <=  X;
            Green_Dash_Valid   <=  '0';
     
            Blue_Dash          <= (Others=>'0');
            Blue_Dash_Valid    <= '0';
         End If;
     Elsif(Hue_D47 >= 60 And Hue_D47 < 120) Then
        If(Hue_D47_Valid = '1') Then
            Red_Dash           <=    X;
            Red_Dash_Valid     <=   '1';
     
            Green_Dash         <=   C_D25;
            Green_Dash_Valid   <=   '1';
     
            Blue_Dash          <= (Others=>'0');
            Blue_Dash_Valid    <= '1';
        Else     
            Red_Dash           <=    X;
            Red_Dash_Valid     <=   '0';
  
            Green_Dash         <=   C_D25;
            Green_Dash_Valid   <=  '0';
  
            Blue_Dash          <= (Others=>'0');
            Blue_DAsh_Valid    <= '0';
        End If; 
    Elsif(Hue_D47 >= 120 And Hue_D47 < 180) Then
        If(Hue_D47_Valid = '1') Then
            Red_Dash           <= (Others=>'0');
            Red_Dash_Valid     <= '1';
            
            Green_Dash         <= C_D25;
            Green_Dash_Valid   <= '1';
            
            Blue_Dash          <= X;
            Blue_Dash_Valid    <= '1';
        Else
            Red_Dash           <= (Others=>'0');
            Red_Dash_Valid     <= '0';
        
            Green_Dash         <= C_D25;
            Green_Dash_Valid   <= '0';
        
            Blue_Dash          <=  X;
            Blue_Dash_Valid    <= '0';
        End If;
    Elsif(Hue_D47 >= 180 And Hue_D47 < 240) Then
        If(Hue_D47_Valid = '1') Then
            Red_Dash           <=  (Others=>'0');
            Red_Dash_Valid     <=  '1';
            
            Green_Dash         <=  X;
            Green_Dash_Valid   <= '1';
            
            Blue_Dash          <=  C_D25;
            Blue_Dash_Valid    <=  '1';
        Else
            Red_Dash           <=  (Others=>'0');
            Red_Dash_Valid     <=  '0';
        
            Green_Dash         <=  X;
            Green_Dash_Valid   <= '0';
        
            Blue_Dash          <=  C_D25;
            Blue_Dash_Valid    <=  '0';
        End If;
    Elsif(Hue_D47 >= 240 And Hue_D47 < 300) Then
        If(Hue_D47_Valid = '1') Then
            Red_Dash           <= X;
            Red_Dash_Valid     <= '1';
            
            Green_Dash         <= (Others=>'0');
            Green_Dash_Valid   <= '1';
            
            Blue_Dash          <= C_D25;
            Blue_Dash_Valid    <= '1';
        Else
            Red_Dash           <= X;
            Red_Dash_Valid     <= '0';
        
            Green_Dash         <= (Others=>'0');
            Green_Dash_Valid   <= '0';
        
            Blue_Dash          <= C_D25;
            Blue_Dash_Valid    <= '0'; 
        End If;
   Else
       If(Hue_D47_Valid = '1') Then
            Red_Dash            <= C_D25;
            Red_Dash_Valid      <= '1';
            
            Green_Dash          <= (Others=>'0');
            Green_Dash_Valid    <= '1';
            
            Blue_Dash           <= X;
            Blue_Dash_Valid     <= '1';
       Else
            Red_Dash            <= C_D25;
            Red_Dash_Valid      <= '0';
       
            Green_Dash          <= (Others=>'0');
            Green_Dash_Valid    <= '0';
       
            Blue_Dash           <= X;
            Blue_Dash_Valid     <= '0';
       End If; 
    End If;
Else
    Red_Dash                <= Red_Dash;
    Red_Dash_Valid          <= Red_Dash_Valid;
    
    Green_Dash              <= Green_Dash;
    Green_Dash_Valid        <= Green_Dash_Valid;
    
    Blue_Dash               <= Blue_Dash;
    Blue_Dash_Valid         <= Green_Dash_Valid;
End If;       
End Process;      

ReadyMap: Process(Clk, Aresetn)
Begin
If(Aresetn = '0') Then
    S_Axis_Video_Tready <= '1';
Elsif(Rising_Edge(Clk)) Then
    S_Axis_Video_Tready <= M_Axis_Video_Tready;
End If;         
End Process;                                                                                                  
      

HueFix2Flo : Fix2Flo_L6_Floating_Point_0
 PORT MAP (
  Aclk                         => Clk,
  S_Axis_A_Tvalid              => S_Axis_Video_Tvalid,
  S_Axis_A_Tdata               => Hue,
  M_Axis_Result_Tvalid         => Hue_Float_Valid,
  M_Axis_Result_Tdata          => Hue_Float
 );
 
 SatFix2Flo : Fix2Flo_L6_Floating_Point_0
 PORT MAP (
  Aclk                         => Clk,
  S_Axis_A_Tvalid              => S_Axis_Video_Tvalid,
  S_Axis_A_Tdata               => Sat,
  M_Axis_Result_Tvalid         => Sat_Float_Valid,
  M_Axis_Result_Tdata          => Sat_Float
 );

ValFix2Flo : Fix2Flo_L6_Floating_Point_0
 PORT MAP (
  Aclk                         => Clk,
  S_Axis_A_Tvalid              => S_Axis_Video_Tvalid,
  S_Axis_A_Tdata               => Val,
  M_Axis_Result_Tvalid         => Val_Float_Valid,
  M_Axis_Result_Tdata          => Val_Float
 );

SatNormComp : Multiply_L8_Floating_Point_1
PORT MAP (
 Aclk                         => Clk,
 S_Axis_A_Tvalid              => Sat_Float_Valid,
 S_Axis_A_Tdata               => Sat_Float,
 S_Axis_B_Tvalid              => Single_Precision_INV255_Valid,
 S_Axis_B_Tdata               => Single_Precision_INV255,
 M_Axis_Result_Tvalid         => Sat_Norm_Valid,
 M_Axis_Result_Tdata          => Sat_Norm
);

ValNormComp : Multiply_L8_Floating_Point_1
PORT MAP (
 Aclk                         => Clk,
 S_Axis_A_Tvalid              => Val_Float_Valid,
 S_Axis_A_Tdata               => Val_Float,
 S_Axis_B_Tvalid              => Single_Precision_INV255_Valid,
 S_Axis_B_Tdata               => Single_Precision_INV255,
 M_Axis_Result_Tvalid         => Val_Norm_Valid,
 M_Axis_Result_Tdata          => Val_Norm
);

HueBy60Comp : Multiply_L8_Floating_Point_1
PORT MAP (
 Aclk                         => Clk,
 S_Axis_A_Tvalid              => Hue_Float_Valid,
 S_Axis_A_Tdata               => Hue_Float,
 S_Axis_B_Tvalid              => Single_Precision_INV60_Valid,
 S_Axis_B_Tdata               => Single_Precision_INV60,
 M_Axis_Result_Tvalid         => Hue_By_60_Valid,
 M_Axis_Result_Tdata          => Hue_By_60
);

SatValNormProdComp : Multiply_L8_Floating_Point_1
PORT MAP (
 Aclk                         => Clk,
 S_Axis_A_Tvalid              => Val_Norm_Valid,
 S_Axis_A_Tdata               => Val_Norm,
 S_Axis_B_Tvalid              => Sat_Norm_Valid,
 S_Axis_B_Tdata               => Sat_Norm,
 M_Axis_Result_Tvalid         => C_Valid,
 M_Axis_Result_Tdata          => C
);

ValNormDelay : Delay_L8_C_Shift_Ram_0           --To Compute M
PORT MAP (
 D(32)                       => Val_Norm_Valid,
 D(31 Downto 0)              => Val_Norm,
 CLK                         => Clk,
 Q(32)                       => Val_Norm_D8_Valid,
 Q(31 Downto 0)              => Val_Norm_D8
);

MComp: AddSub_L11_Floating_Point_2
 PORT MAP(
  Aclk                       => Clk,
  S_Axis_A_Tvalid            => Val_Norm_D8_Valid,
  S_Axis_A_Tdata             => Val_Norm_D8,
  S_Axis_B_Tvalid            => C_Valid,
  S_Axis_B_Tdata             => C,
  S_Axis_Operation_Tvalid    => OP_Sub_Valid,
  S_Axis_Operation_Tdata     => OP_Sub,
  M_Axis_Result_Tvalid       => M_Valid,
  M_Axis_Result_Tdata        => M
 );

ALT2Comp : Comparator_L2_Floating_Point_3       -- Compare : A<2
PORT MAP (
  Aclk 						 => Clk,
  S_Axis_A_Tvalid 			 => Hue_By_60_Valid,
  S_Axis_A_Tdata 			 => Hue_By_60,
  S_Axis_B_Tvalid 			 => Single_Precision_2_Valid,
  S_Axis_B_Tdata 			 => Single_Precision_2,
  S_Axis_Operation_Tvalid 	 => OP_LT_Valid,
  S_Axis_Operation_Tdata 	 => OP_LT,
  M_Axis_Result_Tvalid 		 => A_LT_2_Valid,
  M_Axis_Result_Tdata        => A_LT_2
);

AGEQ2Comp : Comparator_L2_Floating_Point_3      -- Compare : A>=2
PORT MAP (
  Aclk 						 => Clk,
  S_Axis_A_Tvalid 			 => Hue_By_60_Valid,
  S_Axis_A_Tdata 			 => Hue_By_60,
  S_Axis_B_Tvalid 			 => Single_Precision_2_Valid,
  S_Axis_B_Tdata 			 => Single_Precision_2,
  S_Axis_Operation_Tvalid 	 => OP_GEQ_Valid,
  S_Axis_Operation_Tdata 	 => OP_GEQ,
  M_Axis_Result_Tvalid 		 => A_GEQ_2_Valid,
  M_Axis_Result_Tdata        => A_GEQ_2
);

ALT4Comp : Comparator_L2_Floating_Point_3       -- Compare : A <4
PORT MAP (
  Aclk 						 => Clk,
  S_Axis_A_Tvalid 			 => Hue_By_60_Valid,
  S_Axis_A_Tdata 			 => Hue_By_60,
  S_Axis_B_Tvalid 			 => Single_Precision_4_Valid,
  S_Axis_B_Tdata 			 => Single_Precision_4,
  S_Axis_Operation_Tvalid 	 => OP_LT_Valid,
  S_Axis_Operation_Tdata 	 => OP_LT,
  M_Axis_Result_Tvalid 		 => A_LT_4_Valid,
  M_Axis_Result_Tdata        => A_LT_4
);

AGEQ4Comp : Comparator_L2_Floating_Point_3      -- Compare : A >= 4
PORT MAP (
  Aclk 						 => Clk,
  S_Axis_A_Tvalid 			 => Hue_By_60_Valid,
  S_Axis_A_Tdata 			 => Hue_By_60,
  S_Axis_B_Tvalid 			 => Single_Precision_4_Valid,
  S_Axis_B_Tdata 			 => Single_Precision_4,
  S_Axis_Operation_Tvalid 	 => OP_GEQ_Valid,
  S_Axis_Operation_Tdata 	 => OP_GEQ,
  M_Axis_Result_Tvalid 		 => A_GEQ_4_Valid,
  M_Axis_Result_Tdata        => A_GEQ_4
);

ALT6Comp : Comparator_L2_Floating_Point_3       -- Compare : A < 6
PORT MAP (
  Aclk 						 => Clk,
  S_Axis_A_Tvalid 			 => Hue_By_60_Valid,
  S_Axis_A_Tdata 			 => Hue_By_60,
  S_Axis_B_Tvalid 			 => Single_Precision_6_Valid,
  S_Axis_B_Tdata 			 => Single_Precision_6,
  S_Axis_Operation_Tvalid 	 => OP_LT_Valid,
  S_Axis_Operation_Tdata 	 => OP_LT,
  M_Axis_Result_Tvalid 		 => A_LT_6_Valid,
  M_Axis_Result_Tdata        => A_LT_6
);

HueBy60Delay: Delay_L3_C_Shift_Ram_1
PORT MAP (
  D(32)                      => Hue_By_60_Valid,
  D(31 Downto 0)             => Hue_By_60,
  CLK                        => Clk,
  Q(32)                      => Hue_By_60_D3_Valid,
  Q(31 Downto 0)             => Hue_By_60_D3
);

Hby60Mod2Minus1Comp: AddSub_L11_Floating_Point_2                --[((H/60) mod 2) - 1] Computation
PORT MAP(
  Aclk                       => Clk,
  S_Axis_A_Tvalid            => Hue_By_60_D3_Valid,
  S_Axis_A_Tdata             => Hue_By_60_D3,
  S_Axis_B_Tvalid            => Sub_Num_Valid,
  S_Axis_B_Tdata             => Sub_Num,
  S_Axis_Operation_Tvalid    => OP_Sub_Valid,
  S_Axis_Operation_Tdata     => OP_Sub,
  M_Axis_Result_Tvalid       => H60_Mod2_M1_Valid,
  M_Axis_Result_Tdata        => H60_Mod2_M1
 );
 
AbsoluteValueComp : Absolute_Value_L0_Floating_Point_4
PORT MAP (
  S_Axis_A_Tvalid            => H60_Mod2_M1_Valid,
  S_Axis_A_Tdata             => H60_Mod2_M1,
  M_Axis_Result_Tvalid       => Absolute_Value_Valid,
  M_Axis_Result_Tdata        => Absolute_Value
); 

OneMinusAbsVal: AddSub_L11_Floating_Point_2               --1 Minus Absolute Value
PORT MAP(
  Aclk                       => Clk,
  S_Axis_A_Tvalid            => Single_Precision_1_Valid,
  S_Axis_A_Tdata             => Single_Precision_1,
  S_Axis_B_Tvalid            => Absolute_Value_Valid,
  S_Axis_B_Tdata             => Absolute_Value,
  S_Axis_Operation_Tvalid    => OP_Sub_Valid,
  S_Axis_Operation_Tdata     => OP_Sub,
  M_Axis_Result_Tvalid       => One_Minus_Abs_Val_Valid,
  M_Axis_Result_Tdata        => One_Minus_Abs_Val
 );

CDelay: Delay_L17_C_Shift_Ram_2                         --For multiplication with OneMinusAbsVal
PORT MAP (
  D(32)                      => C_Valid,
  D(31 Downto 0)             => C,
  CLK                        => Clk,
  Q(32)                      => C_D17_Valid,
  Q(31 Downto 0)             => C_D17
);

CtimesOneMinusAbsValComp : Multiply_L8_Floating_Point_1
PORT MAP (
 Aclk                         => Clk,
 S_Axis_A_Tvalid              => One_Minus_Abs_Val_Valid,
 S_Axis_A_Tdata               => One_Minus_Abs_Val,
 S_Axis_B_Tvalid              => C_D17_Valid,
 S_Axis_B_Tdata               => C_D17,
 M_Axis_Result_Tvalid         => X_Valid,
 M_Axis_Result_Tdata          => X
);

CD17Delay : Delay_L8_C_Shift_Ram_0           --To Time Match X
PORT MAP (
 D(32)                       => C_D17_Valid,
 D(31 Downto 0)              => C_D17,
 CLK                         => Clk,
 Q(32)                       => C_D25_Valid,
 Q(31 Downto 0)              => C_D25
);

HueDelay: Delay_L47_C_Shift_Ram_3
PORT MAP (
D(9)                         => S_Axis_Video_Tvalid,
D(8 Downto 0)                => Hue(8 Downto 0),
CLK                          => Clk,
Q(9)                         => Hue_D47_Valid,
Q(8 Downto 0)                => Hue_D47  
);

MDelay : Delay_L15_C_Shift_Ram_4
PORT MAP (
 D(32)                       => M_Valid,
 D(31 Downto 0)              => M,
 CLK                         => Clk,
 Q(32)                       => M_D15_Valid,
 Q(31 Downto 0)              => M_D15
 );

RedDashPlusM: AddSub_L11_Floating_Point_2
 PORT MAP(
  Aclk                       => Clk,
  S_Axis_A_Tvalid            => Red_Dash_Valid,
  S_Axis_A_Tdata             => Red_Dash,
  S_Axis_B_Tvalid            => M_D15_Valid,
  S_Axis_B_Tdata             => M_D15,
  S_Axis_Operation_Tvalid    => OP_Add_Valid,
  S_Axis_Operation_Tdata     => OP_Add,
  M_Axis_Result_Tvalid       => Red_Float_Valid,
  M_Axis_Result_Tdata        => Red_Float
 );
 
 GreenDashPlusM: AddSub_L11_Floating_Point_2
 PORT MAP(
  Aclk                       => Clk,
  S_Axis_A_Tvalid            => Green_Dash_Valid,
  S_Axis_A_Tdata             => Green_Dash,
  S_Axis_B_Tvalid            => M_D15_Valid,
  S_Axis_B_Tdata             => M_D15,
  S_Axis_Operation_Tvalid    => OP_Add_Valid,
  S_Axis_Operation_Tdata     => OP_Add,
  M_Axis_Result_Tvalid       => Green_Float_Valid,
  M_Axis_Result_Tdata        => Green_Float
 ); 
 
BlueDashPlusM: AddSub_L11_Floating_Point_2
 PORT MAP(
  Aclk                       => Clk,
  S_Axis_A_Tvalid            => Blue_Dash_Valid,
  S_Axis_A_Tdata             => Blue_Dash,
  S_Axis_B_Tvalid            => M_D15_Valid,
  S_Axis_B_Tdata             => M_D15,
  S_Axis_Operation_Tvalid    => OP_Add_Valid,
  S_Axis_Operation_Tdata     => OP_Add,
  M_Axis_Result_Tvalid       => Blue_Float_Valid,
  M_Axis_Result_Tdata        => Blue_Float
 );

RedScaledComp : Multiply_L8_Floating_Point_1
PORT MAP (
 Aclk                        => Clk,
 S_Axis_A_Tvalid             => Red_Float_Valid,
 S_Axis_A_Tdata              => Red_Float,
 S_Axis_B_Tvalid             => Single_Precision_255_Valid,
 S_Axis_B_Tdata              => Single_Precision_255,
 M_Axis_Result_Tvalid        => Red_Scaled_Valid,
 M_Axis_Result_Tdata         => Red_Scaled
);

GreenScaledComp : Multiply_L8_Floating_Point_1
PORT MAP (
 Aclk                        => Clk,
 S_Axis_A_Tvalid             => Green_Float_Valid,
 S_Axis_A_Tdata              => Green_Float,
 S_Axis_B_Tvalid             => Single_Precision_255_Valid,
 S_Axis_B_Tdata              => Single_Precision_255,
 M_Axis_Result_Tvalid        => Green_Scaled_Valid,
 M_Axis_Result_Tdata         => Green_Scaled
);

BlueScaledComp : Multiply_L8_Floating_Point_1
PORT MAP (
 Aclk                        => Clk,
 S_Axis_A_Tvalid             => Blue_Float_Valid,
 S_Axis_A_Tdata              => Blue_Float,
 S_Axis_B_Tvalid             => Single_Precision_255_Valid,
 S_Axis_B_Tdata              => Single_Precision_255,
 M_Axis_Result_Tvalid        => Blue_Scaled_Valid,
 M_Axis_Result_Tdata         => Blue_Scaled
);

RedFlo2Fix : Flo2Fix_L6_Floating_Point_5
PORT MAP (
 Aclk 					    => Clk,
 S_Axis_A_tvalid 		    => Red_Scaled_Valid,
 S_Axis_A_tdata 	        => Red_Scaled,
 M_Axis_Result_Tvalid 		=> Red_Valid,
 M_Axis_Result_Tdata 		=> Red
);

GreenFlo2Fix : Flo2Fix_L6_Floating_Point_5
PORT MAP (
 Aclk 					    => Clk,
 S_Axis_A_tvalid 		    => Green_Scaled_Valid,
 S_Axis_A_tdata 	        => Green_Scaled,
 M_Axis_Result_Tvalid 		=> Green_Valid,
 M_Axis_Result_Tdata 		=> Green
);

BlueFlo2Fix : Flo2Fix_L6_Floating_Point_5
PORT MAP (
 Aclk 					    => Clk,
 S_Axis_A_tvalid 		    => Blue_Scaled_Valid,
 S_Axis_A_tdata 	        => Blue_Scaled,
 M_Axis_Result_Tvalid 		=> Blue_Valid,
 M_Axis_Result_Tdata 		=> Blue
);

SOFlastMap : Delay_L73_C_Shift_Ram_5
PORT MAP (
 D(0)                       => S_Axis_Video_Tuser_SOF,
 D(1)                       => S_Axis_Video_Tlast,
 CLK                        => Clk,
 Q(0)                       => M_Axis_Video_Tuser_SOF,
 Q(1)                       => M_Axis_Video_Tlast 
);


M_Axis_Video_Tdata(23 Downto 16)        <=  Red(7 Downto 0);
M_Axis_Video_Tdata(15 Downto 08)        <=  Blue(7 Downto 0);
M_Axis_Video_Tdata(07 Downto 00)        <=  Green(7 Downto 0);

M_Axis_Video_Tvalid                     <=  Red_Valid And Green_Valid And Blue_Valid;
  
End Behavioral;
