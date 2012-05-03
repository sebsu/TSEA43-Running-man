----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:03:27 04/23/2012 
-- Design Name: 
-- Module Name:    SpriteGpu - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
use IEEE.numeric_std;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SpriteGpu is
    Port ( 	clk : in  STD_LOGIC;
				x : in  integer;
				y : in  integer;
				spriteVgaRed: out  std_logic_vector(2 downto 0);					
				spriteVgaGreen: out  std_logic_vector(2 downto 0);		
				spriteVgaBlue: out  std_logic_vector(2 downto 1);
				collision: out std_logic;
				spriteDetected: out std_logic;
				rst : in  STD_LOGIC;
				jump: in std_logic;
				duck: in std_logic;
				move_box: in std_logic;
				put_box: in std_logic;
				next_box: in std_logic;
				split_legs: in std_logic);
end SpriteGpu;


architecture Behavioral of SpriteGpu is

subtype elements is std_logic_vector(31 downto 0);
type bit_array is array (0 to 31) of elements;
type gubb_array is array (0 to 64) of elements;
subtype test is integer  range 0 to 800;
type position is array (0 to 7) of test;
signal sprite_brick : bit_array ;
signal sprite_gubbe:  gubb_array;
signal sprite_gubbe_aktiv:  gubb_array;
signal sprite_gubbe_jump:  gubb_array;
signal sprite_gubbe_duck:  gubb_array;
signal sprite_gubbe_split:  gubb_array;
signal x_pos : position;
signal y_pos : position;

signal spriteSize : integer := 32;
signal gubbSize : integer := 64;
signal btnuPressed: std_logic;
begin


sprite_brick( 0) <= "11111111111111111111111111111111"; 
sprite_brick( 1) <= "10010010010010000100100100100101"; 
sprite_brick( 2) <= "11001001001001001001001001001001"; 
sprite_brick( 3) <= "10100100100100100100100100100101";
sprite_brick( 4) <= "10010010010010000100100100100101"; 
sprite_brick( 5) <= "11001001001001001001001001001001"; 
sprite_brick( 6) <= "10100100100100100100100100100101"; 
sprite_brick( 7) <= "10010010010010000100100100100101"; 
sprite_brick( 8) <= "11001001001001001001001001001001"; 
sprite_brick( 9) <= "10100100100100100100100100100101"; 
sprite_brick(10) <= "10010010010010000100100100100101"; 
sprite_brick(11) <= "11001001001001001001001001001001"; 
sprite_brick(12) <= "10100100100100100100100100100101"; 
sprite_brick(13) <= "10010010010010000100100100100101"; 
sprite_brick(14) <= "11001001001001001001001001001001"; 
sprite_brick(15) <= "10100100100100100100100100100101";
sprite_brick(16) <= "10010010010010000100100100100101"; 
sprite_brick(17) <= "11001001001001001001001001001001"; 
sprite_brick(18) <= "10100100100100100100100100100101"; 
sprite_brick(19) <= "10010010010010000100100100100101"; 
sprite_brick(20) <= "11001001001001001001001001001001"; 
sprite_brick(21) <= "10100100100100100100100100100101"; 
sprite_brick(22) <= "10010010010010000100100100100101"; 
sprite_brick(23) <= "11001001001001001001001001001001"; 
sprite_brick(24) <= "10100100100100100100100100100101"; 
sprite_brick(25) <= "10010010010010000100100100100101"; 
sprite_brick(26) <= "11001001001001001001001001001001"; 
sprite_brick(27) <= "10100100100100100100100100100101"; 
sprite_brick(28) <= "10010010010010000100100100100101"; 
sprite_brick(29) <= "11001001001001001001001001001001"; 
sprite_brick(30) <= "10100100100100100100100100100101"; 
sprite_brick(31) <= "11111111111111111111111111111111";  

sprite_gubbe	( 0)	<=	"00000000000011111111000000000000";
sprite_gubbe	( 1)	<=	"00000000000111111111100000000000";
sprite_gubbe	( 2)	<=	"00000000000111111111110000000000";
sprite_gubbe	( 3)	<=	"00000000001111111111110000000000";
sprite_gubbe	( 4)	<=	"00000000001111111111111000000000";
sprite_gubbe	( 5)	<=	"00000000001111111111111000000000";
sprite_gubbe	( 6)	<=	"00000000001111111111111000000000";
sprite_gubbe	( 7)	<=	"00000000001111111111111000000000";
sprite_gubbe	( 8)	<=	"00000000001111111111111000000000";
sprite_gubbe	( 9)	<=	"00000000001111111111110000000000";
sprite_gubbe	(10)	<=	"00000000001111111111110000000000";
sprite_gubbe	(11)	<=	"00000000000111111111100000000000";
sprite_gubbe	(12)	<=	"00000000000011111111100000000000";
sprite_gubbe	(13)	<=	"00000000000001111111000000000000";
sprite_gubbe	(14)	<=	"00000000000000111110000000000000";
sprite_gubbe	(15)	<=	"00000000000000001110000000000000";
sprite_gubbe	(16)	<=	"00000000000000001110000000000000";
sprite_gubbe	(17)	<=	"00000000000000001110000000000000";
sprite_gubbe	(18)	<=	"00000000000000001110000000000000";
sprite_gubbe	(19)	<=	"00000000000000001110000000000000";
sprite_gubbe	(20)	<=	"00000000000000001110000000000000";
sprite_gubbe	(21)	<=	"00000000000000001110000000000000";
sprite_gubbe	(22)	<=	"00000000000000001111000000000000";
sprite_gubbe	(23)	<=	"00000000000000011111000000000000";
sprite_gubbe	(24)	<=	"00000000000000011111000000000000";
sprite_gubbe	(25)	<=	"00000000000000111111000000000000";
sprite_gubbe	(26)	<=	"00000000000000111111000000000000";
sprite_gubbe	(27)	<=	"00000000000000111111000000000000";
sprite_gubbe	(28)	<=	"00000000000001111111100000000000";
sprite_gubbe	(29)	<=	"00000000000001111111100000000000";
sprite_gubbe	(30)	<=	"00000000000001111111100000000000";
sprite_gubbe	(31)	<=	"00000000000011111111100000000000";
sprite_gubbe	(32)	<=	"00000000000000111111100000000000";
sprite_gubbe	(33)	<=	"00000000000000001110000000000000";
sprite_gubbe	(34)	<=	"00000000000000001110000000000000";
sprite_gubbe	(35)	<=	"00000000000000001110000000000000";
sprite_gubbe	(36)	<=	"00000000000000001110000000000000";
sprite_gubbe	(37)	<=	"00000000000000001110000000000000";
sprite_gubbe	(38)	<=	"00000000000000011111000000000000";
sprite_gubbe	(39)	<=	"00000000000000111111000000000000";
sprite_gubbe	(40)	<=	"00000000000000111111000000000000";
sprite_gubbe	(41)	<=	"00000000000000111111000000000000";
sprite_gubbe	(42)	<=	"00000000000001111111000000000000";
sprite_gubbe	(43)	<=	"00000000000001111111000000000000";
sprite_gubbe	(44)	<=	"00000000000001111111000000000000";
sprite_gubbe	(45)	<=	"00000000000001111111000000000000";
sprite_gubbe	(46)	<=	"00000000000011111111000000000000";
sprite_gubbe	(47)	<=	"00000000000011111111000000000000";
sprite_gubbe	(48)	<=	"00000000000011101111000000000000";
sprite_gubbe	(49)	<=	"00000000000011101111000000000000";
sprite_gubbe	(50)	<=	"00000000000011110111000000000000";
sprite_gubbe	(51)	<=	"00000000000011110111000000000000";
sprite_gubbe	(52)	<=	"00000000000011110111100000000000";
sprite_gubbe	(53)	<=	"00000000000011110111100000000000";
sprite_gubbe	(54)	<=	"00000000000001110111100000000000";
sprite_gubbe	(55)	<=	"00000000000001111011110000000000";
sprite_gubbe	(56)	<=	"00000000000001111011110000000000";
sprite_gubbe	(57)	<=	"00000000000001111011110000000000";
sprite_gubbe	(58)	<=	"00000000000001111011110000000000";
sprite_gubbe	(59)	<=	"00000000000001111101111000000000";
sprite_gubbe	(60)	<=	"00000000000000111101111000000000";
sprite_gubbe	(61)	<=	"00000000000000111101111000000000";
sprite_gubbe	(62)	<=	"00000000000000111101111000000000";
sprite_gubbe	(63)	<=	"00000000000000000000000000000000";

sprite_gubbe_jump	( 0)	<=	"00000000000011111111000000000000";
sprite_gubbe_jump	( 1)	<=	"00000000000111111111100000000000";
sprite_gubbe_jump	( 2)	<=	"00000000000111111111110000000000";
sprite_gubbe_jump	( 3)	<=	"00000000001111111111110000000000";
sprite_gubbe_jump	( 4)	<=	"00000000001111111111111000000000";
sprite_gubbe_jump	( 5)	<=	"00000000001111111111111000000000";
sprite_gubbe_jump	( 6)	<=	"00000000001111111111111000000000";
sprite_gubbe_jump	( 7)	<=	"00000000001111111111111000000000";
sprite_gubbe_jump	( 8)	<=	"00000000001111111111111000000000";
sprite_gubbe_jump	( 9)	<=	"00000000001111111111110000000000";
sprite_gubbe_jump	(10)	<=	"00000000000111111111110000000000";
sprite_gubbe_jump	(11)	<=	"00000000000111111111100000000000";
sprite_gubbe_jump	(12)	<=	"00000000000011111111100000000000";
sprite_gubbe_jump	(13)	<=	"00000000000001111111000000000000";
sprite_gubbe_jump	(14)	<=	"00000001100000111110000000000000";
sprite_gubbe_jump	(15)	<=	"00000011110000001111000000000000";
sprite_gubbe_jump	(16)	<=	"00000011111000001111000000000000";
sprite_gubbe_jump	(17)	<=	"00000001111110001111000000000000";
sprite_gubbe_jump	(18)	<=	"00001100111111001111000000000000";
sprite_gubbe_jump	(19)	<=	"00001111001111101111000000000000";
sprite_gubbe_jump	(20)	<=	"00001111110111111111000000000000";
sprite_gubbe_jump	(21)	<=	"00001111111111111111000000000000";
sprite_gubbe_jump	(22)	<=	"00000111111111111111000000000000";
sprite_gubbe_jump	(23)	<=	"00000001111111111111000000000000";
sprite_gubbe_jump	(24)	<=	"00000000001111111111000000000000";
sprite_gubbe_jump	(25)	<=	"00000000000001111111000000000000";
sprite_gubbe_jump	(26)	<=	"00000000000000011111000000000000";
sprite_gubbe_jump	(27)	<=	"00000000000000001111000000000000";
sprite_gubbe_jump	(28)	<=	"00000000000000001111000000000000";
sprite_gubbe_jump	(29)	<=	"00000000000000001111000000000000";
sprite_gubbe_jump	(30)	<=	"00000000000000001111000000000000";
sprite_gubbe_jump	(31)	<=	"00000000000000001111000000000000";
sprite_gubbe_jump	(32)	<=	"00000000000000001111000000000000";
sprite_gubbe_jump	(33)	<=	"00000000000000001111000000000000";
sprite_gubbe_jump	(34)	<=	"00011100000000001111000000000000";
sprite_gubbe_jump	(35)	<=	"00011111100000001111000000000000";
sprite_gubbe_jump	(36)	<=	"00011111111000001111000000000000";
sprite_gubbe_jump	(37)	<=	"00011111111111001110000000000000";
sprite_gubbe_jump	(38)	<=	"00111110111111111111000000000000";
sprite_gubbe_jump	(39)	<=	"00111110000111111111000000000000";
sprite_gubbe_jump	(40)	<=	"00111110000001111111000000000000";
sprite_gubbe_jump	(41)	<=	"00111100000001111110000000000000";
sprite_gubbe_jump	(42)	<=	"00111100000001111100000000000000";
sprite_gubbe_jump	(43)	<=	"00111100000011111000000000000000";
sprite_gubbe_jump	(44)	<=	"01111100000111110000000000000000";
sprite_gubbe_jump	(45)	<=	"01111000011111110000000000000000";
sprite_gubbe_jump	(46)	<=	"01111000111111100000000000000000";
sprite_gubbe_jump	(47)	<=	"01111001111111111100000000000000";
sprite_gubbe_jump	(48)	<=	"01111011111111111111110000000000";
sprite_gubbe_jump	(49)	<=	"00000000001111111111110000000000";
sprite_gubbe_jump	(50)	<=	"00000000000000001111110000000000";
sprite_gubbe_jump	(51)	<=	"00000000000000000000000000000000";
sprite_gubbe_jump	(52)	<=	"00000000000000000000000000000000";
sprite_gubbe_jump	(53)	<=	"00000000000000000000000000000000";
sprite_gubbe_jump	(54)	<=	"00000000000000000000000000000000";
sprite_gubbe_jump	(55)	<=	"00000000000000000000000000000000";
sprite_gubbe_jump	(56)	<=	"00000000000000000000000000000000";
sprite_gubbe_jump	(57)	<=	"00000000000000000000000000000000";
sprite_gubbe_jump	(58)	<=	"00000000000000000000000000000000";
sprite_gubbe_jump	(59)	<=	"00000000000000000000000000000000";
sprite_gubbe_jump	(60)	<=	"00000000000000000000000000000000";
sprite_gubbe_jump	(61)	<=	"00000000000000000000000000000000";
sprite_gubbe_jump	(62)	<=	"00000000000000000000000000000000";
sprite_gubbe_jump	(63)	<=	"00000000000000000000000000000000";

sprite_gubbe_duck	( 0)	<=	"00000000000000000001111111100000";
sprite_gubbe_duck	( 1)	<=	"00000000000000000011111111110000";
sprite_gubbe_duck	( 2)	<=	"00000000000000000111111111110000";
sprite_gubbe_duck	( 3)	<=	"00000000000000000111111111111000";
sprite_gubbe_duck	( 4)	<=	"00000000000000001111111111111000";
sprite_gubbe_duck	( 5)	<=	"00000000000000001111111111111100";
sprite_gubbe_duck	( 6)	<=	"00000000000000001111111111111100";
sprite_gubbe_duck	( 7)	<=	"00000000000000001111111111111100";
sprite_gubbe_duck	( 8)	<=	"00000000000000001111111111111100";
sprite_gubbe_duck	( 9)	<=	"00000000001110001111111111111000";
sprite_gubbe_duck	(10)	<=	"00000000001111100111111111110000";
sprite_gubbe_duck	(11)	<=	"00000000110111110011111111110000";
sprite_gubbe_duck	(12)	<=	"00000001111101111001111111100000";
sprite_gubbe_duck	(13)	<=	"00000001111111011100111111000000";
sprite_gubbe_duck	(14)	<=	"01000000011111111111111110000000";
sprite_gubbe_duck	(15)	<=	"01111111111001111111111100000000";
sprite_gubbe_duck	(16)	<=	"01111111111100011111111100000000";
sprite_gubbe_duck	(17)	<=	"01111111111100000111111000000000";
sprite_gubbe_duck	(18)	<=	"00001110011100001111110000000000";
sprite_gubbe_duck	(19)	<=	"00011111001110011111110000000000";
sprite_gubbe_duck	(20)	<=	"00011111001110011111100000000000";
sprite_gubbe_duck	(21)	<=	"00111111101111111111100000000000";
sprite_gubbe_duck	(22)	<=	"01111111110111111111000000000000";
sprite_gubbe_duck	(23)	<=	"11111011111111111111000000000000";
sprite_gubbe_duck	(24)	<=	"11100001111111111110000000000000";
sprite_gubbe_duck	(25)	<=	"00000000111111111100000000000000";
sprite_gubbe_duck	(26)	<=	"00000000011111111100000000000000";
sprite_gubbe_duck	(27)	<=	"00000000001111111000000000000000";
sprite_gubbe_duck	(28)	<=	"00000000001111111000000000000000";
sprite_gubbe_duck	(29)	<=	"00000000000111110000000000000000";
sprite_gubbe_duck	(30)	<=	"00000000000000000000000000000000";
sprite_gubbe_duck	(31)	<=	"00000000000000000000000000000000";
sprite_gubbe_duck	(32)	<=	"00000000000000000000000000000000";
sprite_gubbe_duck	(33)	<=	"00000000000000000000000000000000";
sprite_gubbe_duck	(34)	<=	"00000000000000000000000000000000";
sprite_gubbe_duck	(35)	<=	"00000000000000000000000000000000";
sprite_gubbe_duck	(36)	<=	"00000000000000000000000000000000";
sprite_gubbe_duck	(37)	<=	"00000000000000000000000000000000";
sprite_gubbe_duck	(38)	<=	"00000000000000000000000000000000";
sprite_gubbe_duck	(39)	<=	"00000000000000000000000000000000";
sprite_gubbe_duck	(40)	<=	"00000000000000000000000000000000";
sprite_gubbe_duck	(41)	<=	"00000000000000000000000000000000";
sprite_gubbe_duck	(42)	<=	"00000000000000000000000000000000";
sprite_gubbe_duck	(43)	<=	"00000000000000000000000000000000";
sprite_gubbe_duck	(44)	<=	"00000000000000000000000000000000";
sprite_gubbe_duck	(45)	<=	"00000000000000000000000000000000";
sprite_gubbe_duck	(46)	<=	"00000000000000000000000000000000";
sprite_gubbe_duck	(47)	<=	"00000000000000000000000000000000";
sprite_gubbe_duck	(48)	<=	"00000000000000000000000000000000";
sprite_gubbe_duck	(49)	<=	"00000000000000000000000000000000";
sprite_gubbe_duck	(50)	<=	"00000000000000000000000000000000";
sprite_gubbe_duck	(51)	<=	"00000000000000000000000000000000";
sprite_gubbe_duck	(52)	<=	"00000000000000000000000000000000";
sprite_gubbe_duck	(53)	<=	"00000000000000000000000000000000";
sprite_gubbe_duck	(54)	<=	"00000000000000000000000000000000";
sprite_gubbe_duck	(55)	<=	"00000000000000000000000000000000";
sprite_gubbe_duck	(56)	<=	"00000000000000000000000000000000";
sprite_gubbe_duck	(57)	<=	"00000000000000000000000000000000";
sprite_gubbe_duck	(58)	<=	"00000000000000000000000000000000";
sprite_gubbe_duck	(59)	<=	"00000000000000000000000000000000";
sprite_gubbe_duck	(60)	<=	"00000000000000000000000000000000";
sprite_gubbe_duck	(61)	<=	"00000000000000000000000000000000";
sprite_gubbe_duck	(62)	<=	"00000000000000000000000000000000";
sprite_gubbe_duck	(63)	<=	"00000000000000000000000000000000";

sprite_gubbe_split	( 0)	<=	"00000000000011111111000000000000";
sprite_gubbe_split	( 1)	<=	"00000000000111111111100000000000";
sprite_gubbe_split	( 2)	<=	"00000000000111111111110000000000";
sprite_gubbe_split	( 3)	<=	"00000000001111111111110000000000";
sprite_gubbe_split	( 4)	<=	"00000000001111111111111000000000";
sprite_gubbe_split	( 5)	<=	"00000000001111111111111000000000";
sprite_gubbe_split	( 6)	<=	"00000000001111111111111000000000";
sprite_gubbe_split	( 7)	<=	"00000000001111111111111000000000";
sprite_gubbe_split	( 8)	<=	"00000000001111111111111000000000";
sprite_gubbe_split	( 9)	<=	"00000000001111111111110000000000";
sprite_gubbe_split	(10)	<=	"00000000001111111111110000000000";
sprite_gubbe_split	(11)	<=	"00000000000111111111100000000000";
sprite_gubbe_split	(12)	<=	"00000000000011111111100000000000";
sprite_gubbe_split	(13)	<=	"00000000000001111111000000000000";
sprite_gubbe_split	(14)	<=	"00000000000000111110000000000000";
sprite_gubbe_split	(15)	<=	"00000000000000001110000000000000";
sprite_gubbe_split	(16)	<=	"00000000000000001110000000000000";
sprite_gubbe_split	(17)	<=	"00000000000000001110000000000000";
sprite_gubbe_split	(18)	<=	"00000000000000001110000000000000";
sprite_gubbe_split	(19)	<=	"00000000000000001110000000000000";
sprite_gubbe_split	(20)	<=	"00000000000000001110000000000000";
sprite_gubbe_split	(21)	<=	"00000000000000011111000000000000";
sprite_gubbe_split	(22)	<=	"00000000000011111111000000000000";
sprite_gubbe_split	(23)	<=	"00000000001111111111100000000000";
sprite_gubbe_split	(24)	<=	"00000001111111111111110000000000";
sprite_gubbe_split	(25)	<=	"00000111111111111111111000000000";
sprite_gubbe_split	(26)	<=	"00000111111111001111111000000000";
sprite_gubbe_split	(27)	<=	"00000111111100001111111100000000";
sprite_gubbe_split	(28)	<=	"00000011110000001111111110000000";
sprite_gubbe_split	(29)	<=	"00000011100000001110011111000000";
sprite_gubbe_split	(30)	<=	"00000000000000001110001111000000";
sprite_gubbe_split	(31)	<=	"00000000000000001110001111100000";
sprite_gubbe_split	(32)	<=	"00000000000000001110000111000000";
sprite_gubbe_split	(33)	<=	"00000000000000001110000010000000";
sprite_gubbe_split	(34)	<=	"00000000000000001110000000000000";
sprite_gubbe_split	(35)	<=	"00000000000000001110000000000000";
sprite_gubbe_split	(36)	<=	"00000000000000001110000000000000";
sprite_gubbe_split	(37)	<=	"00000000000000001110000000000000";
sprite_gubbe_split	(38)	<=	"00000000000000011111000000000000";
sprite_gubbe_split	(39)	<=	"00000000000000111111000000000000";
sprite_gubbe_split	(40)	<=	"00000000000001111111000000000000";
sprite_gubbe_split	(41)	<=	"00000000000011111111000000000000";
sprite_gubbe_split	(42)	<=	"00000000000111111111000000000000";
sprite_gubbe_split	(43)	<=	"00000000011111101111000000000000";
sprite_gubbe_split	(44)	<=	"00000000111111000111000000000000";
sprite_gubbe_split	(45)	<=	"00000001111110000111100000000000";
sprite_gubbe_split	(46)	<=	"00000001111100000111100000000000";
sprite_gubbe_split	(47)	<=	"00000011111000000111100000000000";
sprite_gubbe_split	(48)	<=	"00000111110000000011100000000000";
sprite_gubbe_split	(49)	<=	"00001111100000000011100000000000";
sprite_gubbe_split	(50)	<=	"00001111000000000011110000000000";
sprite_gubbe_split	(51)	<=	"00001111000000000011110000000000";
sprite_gubbe_split	(52)	<=	"00001111000000000011111000000000";
sprite_gubbe_split	(53)	<=	"00001111000000000001111110000000";
sprite_gubbe_split	(54)	<=	"00001111000000000000111111000000";
sprite_gubbe_split	(55)	<=	"00001111100000000000011111100000";
sprite_gubbe_split	(56)	<=	"00001111100000000000001111110000";
sprite_gubbe_split	(57)	<=	"00001111100000000000000111111000";
sprite_gubbe_split	(58)	<=	"00000111100000000000000011111000";

sprite_gubbe_split	(59)	<=	"00000001000000000000000001111000";
sprite_gubbe_split	(60)	<=	"00000000000000000000000000100000";
sprite_gubbe_split	(61)	<=	"00000000000000000000000000000000";
sprite_gubbe_split	(62)	<=	"00000000000000000000000000100000";
sprite_gubbe_split	(63)	<=	"00000000000000000000000000000000";

process(clk)
variable gubbe: integer :=3;
variable detected: boolean := false;
variable collisionDetected: boolean := false;
begin
	if rising_edge(clk) then
		if rst ='1' then
			x_pos(0) <= 0;
			y_pos(0) <= 200;
			x_pos(1) <= 0;
			y_pos(1) <= 200;
			x_pos(2) <= 0;
			y_pos(2) <= 200;
			x_pos(3) <= 100;
			y_pos(3) <= 200;			
		else		
			if(jump='1') then
				y_pos(gubbe) <= 168;
				sprite_gubbe_aktiv<=sprite_gubbe_jump;
			elsif(duck='1') then
				y_pos(gubbe) <= 232;
				sprite_gubbe_aktiv<=sprite_gubbe_duck;
			else
				y_pos(gubbe) <= 200;
				if split_legs = '1' then
						sprite_gubbe_aktiv<=sprite_gubbe;
				else
						sprite_gubbe_aktiv<=sprite_gubbe_split;
				end if;
			end if;
			
			detected :=false;		
			collisionDetected := false;
			
			if put_box = '1' then
				 if x_pos(0) = 0 then
					x_pos(0) <= 800;
					if next_box ='1' then
						y_pos(0) <= 200;
					else
						y_pos(0) <= 232;
					end if;
				 elsif x_pos(1) = 0 then
					x_pos(1) <= 800;
					if next_box ='1' then
						y_pos(1) <= 200;
					else
						y_pos(1) <= 232;
					end if;
				 elsif x_pos(2) = 0 then
					x_pos(2) <= 800;
					if next_box ='1' then
						y_pos(2) <= 200;
					else
						y_pos(2) <= 232;
					end if;
				 else
				 end if;
			elsif move_box ='1' then
				for i in 2 downto 0 loop
					if x_pos(i)>0 then
						x_pos(i) <= x_pos(i) -1;
					end if;
				end loop;
			end if;

			for i in 2 downto 0 loop
			
				if y>=y_pos(i) and y < (y_pos(i)+spriteSize) then
					if x>= x_pos(i) and x < (x_pos(i)+spriteSize) then
						if sprite_brick( y - y_pos(i) )( x - x_pos(i) ) = '1' then
							spriteVgaRed<="111";				
							spriteVgaGreen<="101";
							spriteVgaBlue<="11";
							detected:= true;
						end if;					
					end if;					
				end if;
						
			end loop;
			
			if y>=y_pos(gubbe) and y < (y_pos(gubbe)+gubbSize) then
				if x>= x_pos(gubbe) and x < (x_pos(gubbe)+spriteSize) then
					if sprite_gubbe_aktiv( y - y_pos(gubbe) )( x - x_pos(gubbe) ) = '1' then
						spriteVgaRed<="111";				
						spriteVgaGreen<="101";
						spriteVgaBlue<="00";
						if detected = true then
							collisionDetected := true;
						end if;
						detected:= true;
					end if;					
				end if;					
			end if;
					
			if detected = true then
				spriteDetected <= '1';
			else
				spriteDetected <= '0';
			end if;
			
			if collisionDetected = true then
				collision <='1';
				else
				collision <='0';
			end if;
		end if;
	end if;
end process;

end Behavioral;

