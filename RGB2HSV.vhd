----------------------------------------------------------------------------------
-- Company:             IIT, Madras
-- Engineer:            Urvish Marakad
-- 
-- Create Date:        
-- Design Name:         RGB2HSV Version 6.0
-- Module Name:         RGB2HSV - Behavioral
-- Project Name:        --
-- Target Devices:      Zynq 7000 [ZC702 Evaluation Board]
-- Tool Versions:       Vivado 2018.1
-- Description:          
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments: Note that IPs have been named in the following format:
--                      <IP Use Case>_L<Latency>_<IP Name>_<IP Number> 						
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;


Entity RGB2HSV is
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
End RGB2HSV;

Architecture Behavioral of RGB2HSV is

COMPONENT Delay_L1_C_Shift_Ram_0
  PORT (
    D                       : IN  STD_LOGIC_VECTOR(24 DOWNTO 0);
    CLK                     : IN  STD_LOGIC;
    Q                       : OUT STD_LOGIC_VECTOR(24 DOWNTO 0)
  );
END COMPONENT;

COMPONENT Delay_L35_C_Shift_Ram_1
  PORT (
    D                       : IN  STD_LOGIC_VECTOR(32 DOWNTO 0);
    CLK                     : IN  STD_LOGIC;
    Q                       : OUT STD_LOGIC_VECTOR(32 DOWNTO 0)
  );
END COMPONENT;

COMPONENT Fix2Flo_L6_Floating_Point_0
  PORT (
    
    Aclk                    : IN STD_LOGIC;
    S_Axis_A_Tvalid         : IN STD_LOGIC;
    S_Axis_A_Tdata          : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    M_Axis_Result_Tvalid    : OUT STD_LOGIC;
    M_Axis_Result_Tdata     : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
END COMPONENT;

COMPONENT Division_L28_Floating_Point_1
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

COMPONENT Adder_L11_Floating_Point_2
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

COMPONENT Multiply_L8_Floating_Point_3
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

COMPONENT Flo2Fix_L6_Floating_Point_4
  PORT (
    Aclk                    : IN  STD_LOGIC;
    S_Axis_A_Tvalid         : IN  STD_LOGIC;
    S_Axis_A_Tdata          : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
    M_Axis_Result_Tvalid    : OUT STD_LOGIC;
    M_Axis_Result_Tdata     : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
  );  
END COMPONENT;

COMPONENT Delay_L23_C_Shift_Ram_2
  PORT (
    D                       : IN  STD_LOGIC_VECTOR(8 DOWNTO 0);
    CLK                     : IN  STD_LOGIC;
    Q                       : OUT STD_LOGIC_VECTOR(8 DOWNTO 0)
  );
END COMPONENT;

COMPONENT Delay_L72_C_Shift_Ram_3
  PORT (
    D                       : IN  STD_LOGIC_VECTOR(8 DOWNTO 0);
    CLK                     : IN  STD_LOGIC;
    Q                       : OUT STD_LOGIC_VECTOR(8 DOWNTO 0)
  );
END COMPONENT;

COMPONENT Delay_L75_C_Shift_Ram_4
  PORT (
    D                       : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
    CLK                     : IN  STD_LOGIC;
    Q                       : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
  );
END COMPONENT;

Signal          Red_16bit                               :   Std_Logic_Vector(15 Downto 0);
Signal          Green_16bit                             :   Std_Logic_Vector(15 Downto 0);
Signal          Blue_16bit                              :   Std_Logic_Vector(15 Downto 0);     

Signal          C_max                                   :   Std_Logic_Vector(15 Downto 0);
Signal          C_max_Valid                             :   Std_Logic;

Signal          C_min                                   :   Std_Logic_Vector(15 Downto 0);
Signal          C_min_Valid                             :   Std_Logic;

Signal          Delta                                   :   Std_Logic_Vector(15 Downto 0);
Signal          Delta_Valid                             :   Std_Logic;

Signal          Delta_D0                                :   Std_Logic_Vector(15 Downto 0);
Signal          Delta_D0_Valid                          :   Std_Logic; 

Signal          Delta_D0_Float                          :   Std_Logic_Vector(31 Downto 0);
Signal          Delta_D0_Float_Valid                    :   Std_Logic;

Signal          Color_Dif                               :   Std_Logic_Vector(15 Downto 0);
Signal          Color_Dif_Valid                         :   Std_Logic;

Signal          Red_D0                                  :   Std_Logic_Vector(7 Downto 0);
Signal          Green_D0                                :   Std_Logic_Vector(7 Downto 0);
Signal          Blue_D0                                 :   Std_Logic_Vector(7 Downto 0);
Signal          Col_D0_Valid                            :   Std_Logic;
           
Signal          Col_Dif                                 :   Std_Logic_Vector(15 Downto 0);
Signal          Col_Dif_Valid                           :   Std_Logic;

Signal          Col_Dif_Float                           :   Std_Logic_Vector(31 Downto 0);
Signal          Col_Dif_Float_Valid                     :   Std_Logic;

Signal          Zero_Reg                                :   Std_Logic_Vector(7 Downto 0);

Signal          Hue_Ratio                               :   Std_Logic_Vector(31 Downto 0);
Signal          Hue_Ratio_Valid                         :   Std_Logic;

Signal          Addnum                                  :   Std_Logic_Vector(31 Downto 0);
Signal          Addnum_Valid                            :   Std_Logic;

Signal          Addnum_D35                              :   Std_Logic_Vector(31 Downto 0);
Signal          Addnum_D35_Valid                        :   Std_Logic;

Signal          Ratio_Add                               :   Std_Logic_Vector(31 Downto 0);
Signal          Ratio_Add_Valid                         :   Std_Logic;

Constant        Single_Precision_255                    :   Std_Logic_Vector(31 Downto 0) := X"437F_0000";   --Decimal 255
Constant        Single_Precision_255_Valid              :   Std_Logic := '1';

Constant        Single_Precision_30                     :   Std_Logic_Vector(31 Downto 0) := X"41F0_0000";	 --Decimal 30
Constant        Single_Precision_30_Valid               :   Std_Logic := '1';

Signal          Hue_Select                              :   Std_Logic_Vector(31 Downto 0);
Signal          Hue_Select_Valid                        :   Std_Logic;  

Signal          Hue_Scaled                              :   Std_Logic_Vector(31 Downto 0);
Signal          Hue_Scaled_Valid                        :   Std_Logic; 

Signal          Hue_Fixed                               :   Std_Logic_Vector(15 Downto 0);
Signal          Hue_Fixed_Valid                         :   Std_Logic; 

Signal          C_max_D0                                :   Std_Logic_Vector(15 Downto 0);
Signal          C_max_D0_Valid                          :   Std_Logic;

Signal          C_max_D1                                :   Std_Logic_Vector(15 Downto 0);
Signal          C_max_D1_Valid                          :   Std_Logic; 

Signal          C_max_D1_Float                          :   Std_Logic_Vector(31 Downto 0);
Signal          C_max_D1_Float_Valid                    :   Std_Logic;  

Signal          Sat_Ratio                               :   Std_Logic_Vector(31 Downto 0);
Signal          Sat_Ratio_Valid                         :   Std_Logic; 

Signal          Sat_Sel                                 :   Std_Logic_Vector(31 Downto 0);
Signal          Sat_Sel_Valid                           :   Std_Logic;

Signal          Sat_Scaled                              :   Std_Logic_Vector(31 Downto 0);
Signal          Sat_Scaled_Valid                        :   Std_Logic;  

Signal          Sat_Fix                                 :   Std_Logic_Vector(15 Downto 0);
Signal          Sat_Fix_Valid                           :   Std_Logic;  

Signal          Hue_Addnum                              :   Std_Logic_Vector(31 Downto 0);
Signal          Hue_Addnum_Valid                        :   Std_Logic;

Signal          Hue_Scaled_D0                           :   Std_Logic_Vector(31 Downto 0);
Signal          Hue_Scaled_D0_Valid                     :   Std_Logic; 

Signal          Hue_Final                               :   Std_Logic_Vector(31 Downto 0);
Signal          Hue_Final_Valid                         :   Std_Logic;

Signal          Sat_8bit                                :   Std_Logic_Vector(7 Downto 0);
Signal          Sat_8bit_Valid                          :   Std_Logic;

Signal          Val_8bit                                :   Std_Logic_Vector(7 Downto 0);
Signal          Val_8bit_Valid                          :   Std_Logic;

Signal          Color_Dif_Float                         :   Std_Logic_Vector(31 Downto 0);
Signal          Color_Dif_Float_Valid                   :   Std_Logic;

Begin

Red_16bit                            <=  X"00" & S_Axis_Video_Tdata(23 Downto 16);
Blue_16bit                           <=  X"00" & S_Axis_Video_Tdata(15 Downto 08);
Green_16bit                          <=  X"00" & S_Axis_Video_Tdata(07 Downto 00);


CmaxComp: Process(Clk, Aresetn)
Begin
If(Aresetn = '0') Then 
    C_max           <=  (Others=>'0');
    C_max_Valid     <=  '0';
Elsif(Rising_Edge(Clk)) Then
    If(Red_16bit >= Green_16bit And Red_16bit >= Blue_16bit) Then
       If(S_Axis_Video_Tvalid = '1') Then
           C_max           <=  Red_16bit;
           C_max_Valid     <=  '1';
       Else
           C_max           <=  Red_16bit;
           C_max_Valid     <=  '0';
       End If;
       
    Elsif(Green_16bit >= Red_16bit And Green_16bit >= Blue_16bit) Then
        If(S_Axis_Video_Tvalid = '1') Then
            C_max        <=  Green_16bit;
            C_max_Valid  <= '1';
        Else
            C_max        <=  Green_16bit;
            C_max_Valid  <=  '0';
        End If; 
    
    Else
        If(S_Axis_Video_Tvalid = '1') Then
            C_max        <= Blue_16bit;
            C_max_Valid  <= '1';
        Else
            C_max        <= Blue_16bit;
            C_max_Valid  <= '0';
        End If;                                
    End If;
Else
    C_max           <=  C_max;
    C_max_Valid     <=  C_max_Valid;
End If;            
End Process;


CminComp: Process(Clk, Aresetn)
Begin
If(Aresetn = '0') Then 
    C_min           <=  (Others=>'0');
    C_min_Valid     <=  '0';
Elsif(Rising_Edge(Clk)) Then
    If(Red_16bit <= Green_16bit And Red_16bit <= Blue_16bit) Then
       If(S_Axis_Video_Tvalid = '1') Then
           C_min           <=  Red_16bit;
           C_min_Valid     <=  '1';
       Else
           C_min           <=  Red_16bit;
           C_min_Valid     <=  '0';
       End If;
       
    Elsif(Green_16bit <= Red_16bit And Green_16bit <= Blue_16bit) Then
        If(S_Axis_Video_Tvalid = '1') Then
            C_min        <=  Green_16bit;
            C_min_Valid  <= '1';
        Else
            C_min        <=  Green_16bit;
            C_min_Valid  <=  '0';
        End If; 
    
    Else
        If(S_Axis_Video_Tvalid = '1') Then
            C_min        <= Blue_16bit;
            C_min_Valid  <= '1';
        Else
            C_min        <= Blue_16bit;
            C_min_Valid  <= '0';
        End If;                                
    End If;
Else
    C_min           <=  C_min;
    C_min_Valid     <=  C_min_Valid;s step if you’re importing an existing repository. 
End If;            
End Process;


DeltaComp: Process(Clk, Aresetn)
Begin
If(Aresetn = '0') Then
    Delta               <=  (Others=>'0');
    Delta_Valid         <=  '0';
Elsif(Rising_Edge(Clk)) Then
    If((C_max_Valid And C_min_Valid) = '1') Then
        Delta           <=  C_max - C_min;
        Delta_Valid     <=  '1';
    Else
        Delta           <= C_max - C_min;
        Delta_Valid     <=  '0';
    End If;             
Else
Delta        <=  Delta;
Delta_Valid  <=  Delta_Valid;
End If;   
End Process;

ColorDifComp: Process(Clk, Aresetn)
Begin
If(Aresetn = '0') Then
    Color_Dif           <=  (Others=>'0');
    Color_Dif_Valid     <=  '0';
Elsif(Rising_Edge(Clk)) Then
    If(C_max = Red_D0) Then
        If(Col_D0_Valid = '1') Then
            Color_Dif         <=( (X"00" & Green_D0) - (X"00" & Blue_D0) );
            Color_Dif_Valid   <= '1';
        Else 
            Color_Dif         <=( (X"00" & Green_D0) - (X"00" & Blue_D0) );
            Color_Dif_Valid   <= '0';
        End If;
    Elsif(C_max = Green_D0) Then
        If(Col_D0_Valid = '1') Then
            Color_Dif         <=( (X"00" & Blue_D0) - (X"00" & Red_D0) );
            Color_Dif_Valid   <= '1';
        Else 
            Color_Dif         <=( (X"00" & Blue_D0) - (X"00" & Red_D0) );
            Color_Dif_Valid   <= '0';
        End If;                        
    Else
        If(Col_D0_Valid = '1') Then
            Color_Dif         <=( (X"00" & Red_D0) - (X"00" & Green_D0) );
            Color_Dif_Valid   <= '1';
        Else 
            Color_Dif         <=( (X"00" & Red_D0) - (X"00" & Green_D0) );
            Color_Dif_Valid   <= '0';
        End If;
   End If;     
Else
    Color_Dif           <=  Color_Dif;
    Color_Dif_Valid     <=  Color_Dif_Valid;
End If;                
End Process;

ColorDifDelay: Process(Clk, Aresetn)
Begin
If(Aresetn  = '0') Then
    Col_Dif                 <= (Others=>'0');
    Col_Dif_Valid           <= '0';
Elsif(Rising_Edge(Clk)) Then
    Col_Dif                 <= Color_Dif;
    Col_Dif_Valid           <= Color_Dif_Valid;
Else
    Col_Dif                 <= Col_Dif;
    Col_Dif_Valid           <= Col_Dif_Valid; 
End If;                           
End Process;

AddnumSel: Process(Clk, Aresetn)
Begin
If(Aresetn = '0') Then
    Addnum          <=  (Others=> '0');
    Addnum_Valid    <=  '0';
Elsif(Rising_Edge(Clk)) Then
    If(C_max = Red_D0) Then
        If(Col_D0_Valid = '1') Then
            Addnum       <= (Others=>'0');  --Decimal 0
            Addnum_Valid <= '1';
        Else
            Addnum       <= (Others=>'0');
            Addnum_Valid <= '0';
        End If;
    Elsif(C_max = Green_D0) Then
        If(Col_D0_Valid = '1') Then
            Addnum       <= X"4000_0000";  --Decimal 2
            Addnum_Valid <= '1';
        Else
            Addnum       <= X"4000_0000";
            Addnum_Valid <= '0';
        End If;
    Else
        If(Col_D0_Valid = '1') Then
            Addnum_Valid <= '1';
            Addnum       <= X"4080_0000";  --Decimal 4
        Else
            Addnum       <= X"4080_0000";
            Addnum_Valid <= '0';
       End If;
    End If;
Else
Addnum       <= Addnum;
Addnum_Valid <= Addnum_Valid;
End If;
End Process;

HueSel: Process(Clk, Aresetn)
Begin
If(Aresetn = '0') Then
    Hue_Select              <=  (Others=>'0');
    Hue_Select_Valid        <=  '0';
Elsif(Rising_Edge(Clk)) Then
    If(Ratio_Add = X"7FC0_0000" And Ratio_Add_Valid = '1') Then
        Hue_Select          <=  (Others=>'0');
        Hue_Select_Valid    <=  '1';
    Elsif(Ratio_Add /= X"7FC0_0000" And Ratio_Add_Valid = '1') Then
        Hue_Select          <= Ratio_Add;
        Hue_Select_Valid    <= '1';
    Else
        Hue_Select          <= Ratio_Add;
        Hue_Select_Valid    <= '0';
    End If;
Else
    Hue_Select       <= Hue_Select;
    Hue_Select_Valid <= Hue_Select_Valid;
End If;                    
End Process;

HueAddnumSel: Process(Clk, Aresetn)
Begin
If(Aresetn = '0') Then
    Hue_Addnum          <= (Others=>'0');
    Hue_Addnum_Valid    <=  '0';
Elsif(Rising_Edge(Clk)) Then
    If(Hue_Scaled(31) = '1' And Hue_Scaled_Valid = '1') Then
        Hue_Addnum          <=  X"4334_0000";    				-- Decimal 180 
        Hue_Addnum_Valid    <=  '1';
    Elsif(Hue_Scaled(31) = '0' And Hue_Scaled_Valid = '1') Then
        Hue_Addnum          <= (Others=>'0');
        Hue_Addnum_Valid    <= '1';
    Else
        Hue_Addnum          <= (Others=>'0');
        Hue_Addnum_Valid    <= '0';
    End If;
Else
Hue_Addnum          <= Hue_Addnum;
Hue_Addnum_Valid    <= Hue_Addnum_Valid;
End If;                 
End Process;

CmaxDelay: Process(Clk, Aresetn)
Begin
If(Aresetn = '0') Then
    C_max_D0                <=  (Others=>'0');
    C_max_D0_Valid          <=  '0';
Elsif(Rising_Edge(Clk)) Then
    C_max_D0                <=  C_max;
    C_max_D0_Valid          <=  C_max_Valid;
    
    C_max_D1                <=  C_max_D0;
    C_max_D1_Valid          <=  C_max_D0_Valid;
Else
    C_max_D0                <=  C_max_D0;
    C_max_D0_Valid          <=  C_max_D0_Valid;
    
    C_max_D1                <=  C_max_D1;
    C_max_D1_Valid          <=  C_max_D1_Valid;    
End If;            
End Process;

SatRatioSel: Process(Clk, Aresetn)
Begin
If(Aresetn = '0') Then
    Sat_Sel                 <=  (Others=>'0');
    Sat_Sel_Valid           <=  '0';
Elsif(Rising_Edge(Clk)) Then
    If(Sat_Ratio = X"7FC0_0000" And Sat_Ratio_Valid = '1') Then
        Sat_Sel             <=  (Others=>'0');
        Sat_Sel_Valid       <=  '1';
    Elsif(Sat_Ratio /= X"7FC0_0000" And Sat_Ratio_Valid = '1') Then
        Sat_Sel             <= Sat_Ratio;
        Sat_Sel_Valid       <= '1';
    Else
        Sat_Sel             <= Sat_Ratio;
        Sat_Sel_Valid       <= '0';
    End If;               
Else
    Sat_Sel         <=  Sat_Sel;
    Sat_Sel_Valid   <=  Sat_Sel_Valid;
End If;    
End Process;

HueScaledDelay: Process(Clk, Aresetn)
Begin
If(Aresetn = '0') Then
    Hue_Scaled_D0           <= (Others=>'0');
    Hue_Scaled_D0_Valid     <= '0';
Elsif(Rising_Edge(Clk)) Then
    Hue_Scaled_D0           <= Hue_Scaled;
    Hue_Scaled_D0_Valid     <= Hue_Scaled_Valid;
Else
    Hue_Scaled_D0           <= Hue_Scaled_D0;
    Hue_Scaled_D0_Valid     <= Hue_Scaled_D0_Valid;
End If;                    
End Process;


ColDelay : Delay_L1_C_Shift_Ram_0       --Delayed Color Signals for Comparison
  PORT MAP (
    D(24)                       => S_Axis_Video_Tvalid,
    D(23 Downto 0)              => S_Axis_Video_Tdata,
    CLK                         => Clk,
    Q(24)                       => Col_D0_Valid,
    Q(23 Downto 16)             => Red_D0,
    Q(15 Downto 08)             => Blue_D0,
    Q(07 Downto 00)             => Green_D0
  );
DeltaDelay: Delay_L1_C_Shift_Ram_0
  PORT MAP (
  D(24)                         => Delta_Valid,
  D(23 Downto 08)               => Delta,
  D(07 Downto 00)               => X"00",
  Clk                           => Clk,
  Q(24)                         => Delta_D0_Valid,
  Q(23 Downto 08)               => Delta_D0,
  Q(07 Downto 00)               => Zero_Reg     
 );
 
ColDifFix2Flo : Fix2Flo_L6_Floating_Point_0
  PORT MAP (
   Aclk                         => Clk,
   S_Axis_A_Tvalid              => Col_Dif_Valid,
   S_Axis_A_Tdata               => Col_Dif,
   M_Axis_Result_Tvalid         => Col_Dif_Float_Valid,
   M_Axis_Result_Tdata          => Col_Dif_Float
   );
   
DeltaFix2Flo : Fix2Flo_L6_Floating_Point_0
  PORT MAP (
   Aclk                         => Clk,
   S_Axis_A_Tvalid              => Delta_D0_Valid,
   S_Axis_A_Tdata               => Delta_D0,
   M_Axis_Result_Tvalid         => Delta_D0_Float_Valid,
   M_Axis_Result_Tdata          => Delta_D0_Float
  );    

HueRatioComp : Division_L28_Floating_Point_1
 PORT MAP (
   Aclk                         => Clk,
   S_Axis_A_Tvalid              => Col_Dif_Float_Valid,
   S_Axis_A_Tdata               => Col_Dif_Float,
   S_Axis_B_Tvalid              => Delta_D0_Float_Valid,
   S_Axis_B_Tdata               => Delta_D0_Float,
   M_Axis_Result_Tvalid         => Hue_Ratio_Valid,
   M_Axis_Result_Tdata          => Hue_Ratio
   );
   
AddnumDelay: Delay_L35_C_Shift_Ram_1
 PORT MAP (
  D(32)                         => Addnum_Valid,
  D(31 Downto 0)                => Addnum,
  Clk                           => Clk,
  Q(32)                         => Addnum_D35_Valid,
  Q(31 Downto 0)                => Addnum_D35
 );

RatioAddnum : Adder_L11_Floating_Point_2
  PORT MAP (
  Aclk                          => Clk,
  S_Axis_A_Tvalid               => Hue_Ratio_Valid,
  S_Axis_A_Tdata 		        => Hue_Ratio,
  S_Axis_B_Tvalid		        => Addnum_D35_Valid,
  S_Axis_B_Tdata 		        => Addnum_D35,
  M_Axis_Result_Tvalid          => Ratio_Add_Valid,
  M_Axis_Result_Tdata           => Ratio_Add
  );    

HueScaledComp : Multiply_L8_Floating_Point_3
 PORT MAP (
   Aclk                         => Clk,
   S_Axis_A_Tvalid              => Hue_Select_Valid,
   S_Axis_A_Tdata               => Hue_Select,
   S_Axis_B_Tvalid              => Single_Precision_30_Valid,
   S_Axis_B_Tdata               => Single_Precision_30,
   M_Axis_Result_Tvalid         => Hue_Scaled_Valid,
   M_Axis_Result_Tdata          => Hue_Scaled
 );

CmaxD1Fix2Flo : Fix2Flo_L6_Floating_Point_0
  PORT MAP (
   Aclk                         => Clk,
   S_Axis_A_Tvalid              => C_max_D1_Valid,
   S_Axis_A_Tdata               => C_max_D1,
   M_Axis_Result_Tvalid         => C_max_D1_Float_Valid,
   M_Axis_Result_Tdata          => C_max_D1_Float
  ); 

SatRatioComp : Division_L28_Floating_Point_1
 PORT MAP (
   Aclk                         => Clk,
   S_Axis_A_Tvalid              => Delta_D0_Float_Valid,
   S_Axis_A_Tdata               => Delta_D0_Float,
   S_Axis_B_Tvalid              => C_max_D1_Float_Valid,
   S_Axis_B_Tdata               => C_max_D1_Float,
   M_Axis_Result_Tvalid         => Sat_Ratio_Valid,
   M_Axis_Result_Tdata          => Sat_Ratio
 );

SatScaledComp : Multiply_L8_Floating_Point_3
 PORT MAP (
   Aclk                         => Clk,
   S_Axis_A_Tvalid              => Sat_Sel_Valid,
   S_Axis_A_Tdata               => Sat_Sel,
   S_Axis_B_Tvalid              => Single_Precision_255_Valid,
   S_Axis_B_Tdata               => Single_Precision_255,
   M_Axis_Result_Tvalid         => Sat_Scaled_Valid,
   M_Axis_Result_Tdata          => Sat_Scaled
 );
 
SatFix : Flo2Fix_L6_Floating_Point_4
  PORT MAP (
   Aclk                         => Clk,
   S_Axis_A_Tvalid              => Sat_Scaled_Valid,
   S_Axis_A_Tdata               => Sat_Scaled,
   M_Axis_Result_Tvalid         => Sat_Fix_Valid,
   M_Axis_Result_Tdata          => Sat_Fix
 ); 


HueAddnum : Adder_L11_Floating_Point_2
  PORT MAP (
  Aclk                          => Clk,
  S_Axis_A_Tvalid               => Hue_Scaled_D0_Valid,
  S_Axis_A_Tdata 		        => Hue_Scaled_D0,
  S_Axis_B_Tvalid		        => Hue_Addnum_Valid,
  S_Axis_B_Tdata 		        => Hue_Addnum,
  M_Axis_Result_Tvalid          => Hue_Final_Valid,
  M_Axis_Result_Tdata           => Hue_Final
  );

HueFix : Flo2Fix_L6_Floating_Point_4
  PORT MAP (
   Aclk                         => Clk,
   S_Axis_A_Tvalid              => Hue_Final_Valid,
   S_Axis_A_Tdata               => Hue_Final,
   M_Axis_Result_Tvalid         => Hue_Fixed_Valid,
   M_Axis_Result_Tdata          => Hue_Fixed
  );
  
SatDelay : Delay_L23_C_Shift_Ram_2
  PORT MAP (
   D(8)                         => Sat_Fix_Valid,
   D(7 Downto 0)                => Sat_Fix(7 Downto 0),
   CLK                          => Clk,
   Q(8)                         => Sat_8bit_Valid,
   Q(7 Downto 0)                => Sat_8bit 
 );
 
ValDelay : Delay_L72_C_Shift_Ram_3
  PORT MAP (
   D(8)                         => C_max_D1_Valid,
   D(7 Downto 0)                => C_max_D1(7 Downto 0),
   CLK                          => Clk,
   Q(8)                         => Val_8bit_Valid,
   Q(7 Downto 0)                => Val_8bit 
  );    
  
ValidLastMap : Delay_L75_C_Shift_Ram_4
  PORT MAP (
   D(1)                         => S_Axis_Video_Tuser_SOF,
   D(0)                         => S_Axis_Video_Tlast,
   CLK                          => Clk,
   Q(1)                         => M_Axis_Video_Tuser_SOF,
   Q(0)                         => M_Axis_Video_Tlast
);  

M_Axis_Video_Tvalid              <= Val_8bit_Valid And Sat_8bit_Valid And Hue_Fixed_Valid;
M_Axis_Video_Tdata(23 Downto 16) <= Hue_Fixed(7 Downto 0);
M_Axis_Video_Tdata(15 Downto 08) <= Sat_8bit;
M_Axis_Video_Tdata(07 Downto 00) <= Val_8bit;

End Behavioral;
