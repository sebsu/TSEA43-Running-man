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
type gubb_array is array (0 to 63) of elements;
type manga_gubbar is array (0 to 3) of gubb_array;
subtype xrange is integer  range 0 to 800;
subtype yrange is integer  range 168 to 232;
type x_position is array (0 to 3) of xrange;
type y_position is array (0 to 3) of yrange;

signal sprite_brick : bit_array ;
signal sprite_gubbe:  manga_gubbar;
signal x_pos : x_position;
signal y_pos : y_position;
signal gubb_sprite : integer range 0 to 3;

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

sprite_gubbe(0)	( 0)	<=	"00000000000011111111000000000000";
sprite_gubbe(0)	( 1)	<=	"00000000000111111111100000000000";
sprite_gubbe(0)	( 2)	<=	"00000000000111111111110000000000";
sprite_gubbe(0)	( 3)	<=	"00000000001111111111110000000000";
sprite_gubbe(0)	( 4)	<=	"00000000001111111111111000000000";
sprite_gubbe(0)	( 5)	<=	"00000000001111111111111000000000";
sprite_gubbe(0)	( 6)	<=	"00000000001111111111111000000000";
sprite_gubbe(0)	( 7)	<=	"00000000001111111111111000000000";
sprite_gubbe(0)	( 8)	<=	"00000000001111111111111000000000";
sprite_gubbe(0)	( 9)	<=	"00000000001111111111110000000000";
sprite_gubbe(0)	(10)	<=	"00000000001111111111110000000000";
sprite_gubbe(0)	(11)	<=	"00000000000111111111100000000000";
sprite_gubbe(0)	(12)	<=	"00000000000011111111100000000000";
sprite_gubbe(0)	(13)	<=	"00000000000001111111000000000000";
sprite_gubbe(0)	(14)	<=	"00000000000000111110000000000000";
sprite_gubbe(0)	(15)	<=	"00000000000000001110000000000000";
sprite_gubbe(0)	(16)	<=	"00000000000000001110000000000000";
sprite_gubbe(0)	(17)	<=	"00000000000000001110000000000000";
sprite_gubbe(0)	(18)	<=	"00000000000000001110000000000000";
sprite_gubbe(0)	(19)	<=	"00000000000000001110000000000000";
sprite_gubbe(0)	(20)	<=	"00000000000000001110000000000000";
sprite_gubbe(0)	(21)	<=	"00000000000000001110000000000000";
sprite_gubbe(0)	(22)	<=	"00000000000000001111000000000000";
sprite_gubbe(0)	(23)	<=	"00000000000000011111000000000000";
sprite_gubbe(0)	(24)	<=	"00000000000000011111000000000000";
sprite_gubbe(0)	(25)	<=	"00000000000000111111000000000000";
sprite_gubbe(0)	(26)	<=	"00000000000000111111000000000000";
sprite_gubbe(0)	(27)	<=	"00000000000000111111000000000000";
sprite_gubbe(0)	(28)	<=	"00000000000001111111100000000000";
sprite_gubbe(0)	(29)	<=	"00000000000001111111100000000000";
sprite_gubbe(0)	(30)	<=	"00000000000001111111100000000000";
sprite_gubbe(0)	(31)	<=	"00000000000011111111100000000000";
sprite_gubbe(0)	(32)	<=	"00000000000000111111100000000000";
sprite_gubbe(0)	(33)	<=	"00000000000000001110000000000000";
sprite_gubbe(0)	(34)	<=	"00000000000000001110000000000000";
sprite_gubbe(0)	(35)	<=	"00000000000000001110000000000000";
sprite_gubbe(0)	(36)	<=	"00000000000000001110000000000000";
sprite_gubbe(0)	(37)	<=	"00000000000000001110000000000000";
sprite_gubbe(0)	(38)	<=	"00000000000000011111000000000000";
sprite_gubbe(0)	(39)	<=	"00000000000000111111000000000000";
sprite_gubbe(0)	(40)	<=	"00000000000000111111000000000000";
sprite_gubbe(0)	(41)	<=	"00000000000000111111000000000000";
sprite_gubbe(0)	(42)	<=	"00000000000001111111000000000000";
sprite_gubbe(0)	(43)	<=	"00000000000001111111000000000000";
sprite_gubbe(0)	(44)	<=	"00000000000001111111000000000000";
sprite_gubbe(0)	(45)	<=	"00000000000001111111000000000000";
sprite_gubbe(0)	(46)	<=	"00000000000011111111000000000000";
sprite_gubbe(0)	(47)	<=	"00000000000011111111000000000000";
sprite_gubbe(0)	(48)	<=	"00000000000011101111000000000000";
sprite_gubbe(0)	(49)	<=	"00000000000011101111000000000000";
sprite_gubbe(0)	(50)	<=	"00000000000011110111000000000000";
sprite_gubbe(0)	(51)	<=	"00000000000011110111000000000000";
sprite_gubbe(0)	(52)	<=	"00000000000011110111100000000000";
sprite_gubbe(0)	(53)	<=	"00000000000011110111100000000000";
sprite_gubbe(0)	(54)	<=	"00000000000001110111100000000000";
sprite_gubbe(0)	(55)	<=	"00000000000001111011110000000000";
sprite_gubbe(0)	(56)	<=	"00000000000001111011110000000000";
sprite_gubbe(0)	(57)	<=	"00000000000001111011110000000000";
sprite_gubbe(0)	(58)	<=	"00000000000001111011110000000000";
sprite_gubbe(0)	(59)	<=	"00000000000001111101111000000000";
sprite_gubbe(0)	(60)	<=	"00000000000000111101111000000000";
sprite_gubbe(0)	(61)	<=	"00000000000000111101111000000000";
sprite_gubbe(0)	(62)	<=	"00000000000000111101111000000000";
sprite_gubbe(0)	(63)	<=	"00000000000000000000000000000000";

sprite_gubbe(2)	( 0)	<=	"00000000000011111111000000000000";
sprite_gubbe(2)	( 1)	<=	"00000000000111111111100000000000";
sprite_gubbe(2)	( 2)	<=	"00000000000111111111110000000000";
sprite_gubbe(2)	( 3)	<=	"00000000001111111111110000000000";
sprite_gubbe(2)	( 4)	<=	"00000000001111111111111000000000";
sprite_gubbe(2)	( 5)	<=	"00000000001111111111111000000000";
sprite_gubbe(2)	( 6)	<=	"00000000001111111111111000000000";
sprite_gubbe(2)	( 7)	<=	"00000000001111111111111000000000";
sprite_gubbe(2)	( 8)	<=	"00000000001111111111111000000000";
sprite_gubbe(2)	( 9)	<=	"00000000001111111111110000000000";
sprite_gubbe(2)	(10)	<=	"00000000000111111111110000000000";
sprite_gubbe(2)	(11)	<=	"00000000000111111111100000000000";
sprite_gubbe(2)	(12)	<=	"00000000000011111111100000000000";
sprite_gubbe(2)	(13)	<=	"00000000000001111111000000000000";
sprite_gubbe(2)	(14)	<=	"00000001100000111110000000000000";
sprite_gubbe(2)	(15)	<=	"00000011110000001111000000000000";
sprite_gubbe(2)	(16)	<=	"00000011111000001111000000000000";
sprite_gubbe(2)	(17)	<=	"00000001111110001111000000000000";
sprite_gubbe(2)	(18)	<=	"00001100111111001111000000000000";
sprite_gubbe(2)	(19)	<=	"00001111001111101111000000000000";
sprite_gubbe(2)	(20)	<=	"00001111110111111111000000000000";
sprite_gubbe(2)	(21)	<=	"00001111111111111111000000000000";
sprite_gubbe(2)	(22)	<=	"00000111111111111111000000000000";
sprite_gubbe(2)	(23)	<=	"00000001111111111111000000000000";
sprite_gubbe(2)	(24)	<=	"00000000001111111111000000000000";
sprite_gubbe(2)	(25)	<=	"00000000000001111111000000000000";
sprite_gubbe(2)	(26)	<=	"00000000000000011111000000000000";
sprite_gubbe(2)	(27)	<=	"00000000000000001111000000000000";
sprite_gubbe(2)	(28)	<=	"00000000000000001111000000000000";
sprite_gubbe(2)	(29)	<=	"00000000000000001111000000000000";
sprite_gubbe(2)	(30)	<=	"00000000000000001111000000000000";
sprite_gubbe(2)	(31)	<=	"00000000000000001111000000000000";
sprite_gubbe(2)	(32)	<=	"00000000000000001111000000000000";
sprite_gubbe(2)	(33)	<=	"00000000000000001111000000000000";
sprite_gubbe(2)	(34)	<=	"00011100000000001111000000000000";
sprite_gubbe(2)	(35)	<=	"00011111100000001111000000000000";
sprite_gubbe(2)	(36)	<=	"00011111111000001111000000000000";
sprite_gubbe(2)	(37)	<=	"00011111111111001110000000000000";
sprite_gubbe(2)	(38)	<=	"00111110111111111111000000000000";
sprite_gubbe(2)	(39)	<=	"00111110000111111111000000000000";
sprite_gubbe(2)	(40)	<=	"00111110000001111111000000000000";
sprite_gubbe(2)	(41)	<=	"00111100000001111110000000000000";
sprite_gubbe(2)	(42)	<=	"00111100000001111100000000000000";
sprite_gubbe(2)	(43)	<=	"00111100000011111000000000000000";
sprite_gubbe(2)	(44)	<=	"01111100000111110000000000000000";
sprite_gubbe(2)	(45)	<=	"01111000011111110000000000000000";
sprite_gubbe(2)	(46)	<=	"01111000111111100000000000000000";
sprite_gubbe(2)	(47)	<=	"01111001111111111100000000000000";
sprite_gubbe(2)	(48)	<=	"01111011111111111111110000000000";
sprite_gubbe(2)	(49)	<=	"00000000001111111111110000000000";
sprite_gubbe(2)	(50)	<=	"00000000000000001111110000000000";
sprite_gubbe(2)	(51)	<=	"00000000000000000000000000000000";
sprite_gubbe(2)	(52)	<=	"00000000000000000000000000000000";
sprite_gubbe(2)	(53)	<=	"00000000000000000000000000000000";
sprite_gubbe(2)	(54)	<=	"00000000000000000000000000000000";
sprite_gubbe(2)	(55)	<=	"00000000000000000000000000000000";
sprite_gubbe(2)	(56)	<=	"00000000000000000000000000000000";
sprite_gubbe(2)	(57)	<=	"00000000000000000000000000000000";
sprite_gubbe(2)	(58)	<=	"00000000000000000000000000000000";
sprite_gubbe(2)	(59)	<=	"00000000000000000000000000000000";
sprite_gubbe(2)	(60)	<=	"00000000000000000000000000000000";
sprite_gubbe(2)	(61)	<=	"00000000000000000000000000000000";
sprite_gubbe(2)	(62)	<=	"00000000000000000000000000000000";
sprite_gubbe(2)	(63)	<=	"00000000000000000000000000000000";

sprite_gubbe(3)	( 0)	<=	"00000000000000000001111111100000";
sprite_gubbe(3)	( 1)	<=	"00000000000000000011111111110000";
sprite_gubbe(3)	( 2)	<=	"00000000000000000111111111110000";
sprite_gubbe(3)	( 3)	<=	"00000000000000000111111111111000";
sprite_gubbe(3)	( 4)	<=	"00000000000000001111111111111000";
sprite_gubbe(3)	( 5)	<=	"00000000000000001111111111111100";
sprite_gubbe(3)	( 6)	<=	"00000000000000001111111111111100";
sprite_gubbe(3)	( 7)	<=	"00000000000000001111111111111100";
sprite_gubbe(3)	( 8)	<=	"00000000000000001111111111111100";
sprite_gubbe(3)	( 9)	<=	"00000000001110001111111111111000";
sprite_gubbe(3)	(10)	<=	"00000000001111100111111111110000";
sprite_gubbe(3)	(11)	<=	"00000000110111110011111111110000";
sprite_gubbe(3)	(12)	<=	"00000001111101111001111111100000";
sprite_gubbe(3)	(13)	<=	"00000001111111011100111111000000";
sprite_gubbe(3)	(14)	<=	"01000000011111111111111110000000";
sprite_gubbe(3)	(15)	<=	"01111111111001111111111100000000";
sprite_gubbe(3)	(16)	<=	"01111111111100011111111100000000";
sprite_gubbe(3)	(17)	<=	"01111111111100000111111000000000";
sprite_gubbe(3)	(18)	<=	"00001110011100001111110000000000";
sprite_gubbe(3)	(19)	<=	"00011111001110011111110000000000";
sprite_gubbe(3)	(20)	<=	"00011111001110011111100000000000";
sprite_gubbe(3)	(21)	<=	"00111111101111111111100000000000";
sprite_gubbe(3)	(22)	<=	"01111111110111111111000000000000";
sprite_gubbe(3)	(23)	<=	"11111011111111111111000000000000";
sprite_gubbe(3)	(24)	<=	"11100001111111111110000000000000";
sprite_gubbe(3)	(25)	<=	"00000000111111111100000000000000";
sprite_gubbe(3)	(26)	<=	"00000000011111111100000000000000";
sprite_gubbe(3)	(27)	<=	"00000000001111111000000000000000";
sprite_gubbe(3)	(28)	<=	"00000000001111111000000000000000";
sprite_gubbe(3)	(29)	<=	"00000000000111110000000000000000";
sprite_gubbe(3)	(30)	<=	"00000000000000000000000000000000";
sprite_gubbe(3)	(31)	<=	"00000000000000000000000000000000";
sprite_gubbe(3)	(32)	<=	"00000000000000000000000000000000";
sprite_gubbe(3)	(33)	<=	"00000000000000000000000000000000";
sprite_gubbe(3)	(34)	<=	"00000000000000000000000000000000";
sprite_gubbe(3)	(35)	<=	"00000000000000000000000000000000";
sprite_gubbe(3)	(36)	<=	"00000000000000000000000000000000";
sprite_gubbe(3)	(37)	<=	"00000000000000000000000000000000";
sprite_gubbe(3)	(38)	<=	"00000000000000000000000000000000";
sprite_gubbe(3)	(39)	<=	"00000000000000000000000000000000";
sprite_gubbe(3)	(40)	<=	"00000000000000000000000000000000";
sprite_gubbe(3)	(41)	<=	"00000000000000000000000000000000";
sprite_gubbe(3)	(42)	<=	"00000000000000000000000000000000";
sprite_gubbe(3)	(43)	<=	"00000000000000000000000000000000";
sprite_gubbe(3)	(44)	<=	"00000000000000000000000000000000";
sprite_gubbe(3)	(45)	<=	"00000000000000000000000000000000";
sprite_gubbe(3)	(46)	<=	"00000000000000000000000000000000";
sprite_gubbe(3)	(47)	<=	"00000000000000000000000000000000";
sprite_gubbe(3)	(48)	<=	"00000000000000000000000000000000";
sprite_gubbe(3)	(49)	<=	"00000000000000000000000000000000";
sprite_gubbe(3)	(50)	<=	"00000000000000000000000000000000";
sprite_gubbe(3)	(51)	<=	"00000000000000000000000000000000";
sprite_gubbe(3)	(52)	<=	"00000000000000000000000000000000";
sprite_gubbe(3)	(53)	<=	"00000000000000000000000000000000";
sprite_gubbe(3)	(54)	<=	"00000000000000000000000000000000";
sprite_gubbe(3)	(55)	<=	"00000000000000000000000000000000";
sprite_gubbe(3)	(56)	<=	"00000000000000000000000000000000";
sprite_gubbe(3)	(57)	<=	"00000000000000000000000000000000";
sprite_gubbe(3)	(58)	<=	"00000000000000000000000000000000";
sprite_gubbe(3)	(59)	<=	"00000000000000000000000000000000";
sprite_gubbe(3)	(60)	<=	"00000000000000000000000000000000";
sprite_gubbe(3)	(61)	<=	"00000000000000000000000000000000";
sprite_gubbe(3)	(62)	<=	"00000000000000000000000000000000";
sprite_gubbe(3)	(63)	<=	"00000000000000000000000000000000";

sprite_gubbe(1)	( 0)	<=	"00000000000011111111000000000000";
sprite_gubbe(1)	( 1)	<=	"00000000000111111111100000000000";
sprite_gubbe(1)	( 2)	<=	"00000000000111111111110000000000";
sprite_gubbe(1)	( 3)	<=	"00000000001111111111110000000000";
sprite_gubbe(1)	( 4)	<=	"00000000001111111111111000000000";
sprite_gubbe(1)	( 5)	<=	"00000000001111111111111000000000";
sprite_gubbe(1)	( 6)	<=	"00000000001111111111111000000000";
sprite_gubbe(1)	( 7)	<=	"00000000001111111111111000000000";
sprite_gubbe(1)	( 8)	<=	"00000000001111111111111000000000";
sprite_gubbe(1)	( 9)	<=	"00000000001111111111110000000000";
sprite_gubbe(1)	(10)	<=	"00000000001111111111110000000000";
sprite_gubbe(1)	(11)	<=	"00000000000111111111100000000000";
sprite_gubbe(1)	(12)	<=	"00000000000011111111100000000000";
sprite_gubbe(1)	(13)	<=	"00000000000001111111000000000000";
sprite_gubbe(1)	(14)	<=	"00000000000000111110000000000000";
sprite_gubbe(1)	(15)	<=	"00000000000000001110000000000000";
sprite_gubbe(1)	(16)	<=	"00000000000000001110000000000000";
sprite_gubbe(1)	(17)	<=	"00000000000000001110000000000000";
sprite_gubbe(1)	(18)	<=	"00000000000000001110000000000000";
sprite_gubbe(1)	(19)	<=	"00000000000000001110000000000000";
sprite_gubbe(1)	(20)	<=	"00000000000000001110000000000000";
sprite_gubbe(1)	(21)	<=	"00000000000000011111000000000000";
sprite_gubbe(1)	(22)	<=	"00000000000011111111000000000000";
sprite_gubbe(1)	(23)	<=	"00000000001111111111100000000000";
sprite_gubbe(1)	(24)	<=	"00000001111111111111110000000000";
sprite_gubbe(1)	(25)	<=	"00000111111111111111111000000000";
sprite_gubbe(1)	(26)	<=	"00000111111111001111111000000000";
sprite_gubbe(1)	(27)	<=	"00000111111100001111111100000000";
sprite_gubbe(1)	(28)	<=	"00000011110000001111111110000000";
sprite_gubbe(1)	(29)	<=	"00000011100000001110011111000000";
sprite_gubbe(1)	(30)	<=	"00000000000000001110001111000000";
sprite_gubbe(1)	(31)	<=	"00000000000000001110001111100000";
sprite_gubbe(1)	(32)	<=	"00000000000000001110000111000000";
sprite_gubbe(1)	(33)	<=	"00000000000000001110000010000000";
sprite_gubbe(1)	(34)	<=	"00000000000000001110000000000000";
sprite_gubbe(1)	(35)	<=	"00000000000000001110000000000000";
sprite_gubbe(1)	(36)	<=	"00000000000000001110000000000000";
sprite_gubbe(1)	(37)	<=	"00000000000000001110000000000000";
sprite_gubbe(1)	(38)	<=	"00000000000000011111000000000000";
sprite_gubbe(1)	(39)	<=	"00000000000000111111000000000000";
sprite_gubbe(1)	(40)	<=	"00000000000001111111000000000000";
sprite_gubbe(1)	(41)	<=	"00000000000011111111000000000000";
sprite_gubbe(1)	(42)	<=	"00000000000111111111000000000000";
sprite_gubbe(1)	(43)	<=	"00000000011111101111000000000000";
sprite_gubbe(1)	(44)	<=	"00000000111111000111000000000000";
sprite_gubbe(1)	(45)	<=	"00000001111110000111100000000000";
sprite_gubbe(1)	(46)	<=	"00000001111100000111100000000000";
sprite_gubbe(1)	(47)	<=	"00000011111000000111100000000000";
sprite_gubbe(1)	(48)	<=	"00000111110000000011100000000000";
sprite_gubbe(1)	(49)	<=	"00001111100000000011100000000000";
sprite_gubbe(1)	(50)	<=	"00001111000000000011110000000000";
sprite_gubbe(1)	(51)	<=	"00001111000000000011110000000000";
sprite_gubbe(1)	(52)	<=	"00001111000000000011111000000000";
sprite_gubbe(1)	(53)	<=	"00001111000000000001111110000000";
sprite_gubbe(1)	(54)	<=	"00001111000000000000111111000000";
sprite_gubbe(1)	(55)	<=	"00001111100000000000011111100000";
sprite_gubbe(1)	(56)	<=	"00001111100000000000001111110000";
sprite_gubbe(1)	(57)	<=	"00001111100000000000000111111000";
sprite_gubbe(1)	(58)	<=	"00000111100000000000000011111000";

sprite_gubbe(1)	(59)	<=	"00000001000000000000000001111000";
sprite_gubbe(1)	(60)	<=	"00000000000000000000000000100000";
sprite_gubbe(1)	(61)	<=	"00000000000000000000000000000000";
sprite_gubbe(1)	(62)	<=	"00000000000000000000000000000000";
sprite_gubbe(1)	(63)	<=	"00000000000000000000000000000000";

process(clk)
constant gubbe: integer :=3;
variable detected: boolean := false;
variable collisionDetected: boolean := false;
constant spriteSize : integer := 32;
constant gubbSize : integer := 64;
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
			gubb_sprite <= 0;
		else		
			if(jump='1') then
				y_pos(gubbe) <= 168;
				gubb_sprite <= 2;
			elsif(duck='1') then
				y_pos(gubbe) <= 232;
				gubb_sprite <= 3;
			else
				y_pos(gubbe) <= 200;
				if split_legs = '1' then
						gubb_sprite <= 0;
				else
						gubb_sprite <=1;
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
					if sprite_gubbe(gubb_sprite)( y - y_pos(gubbe) )( x - x_pos(gubbe) ) = '1' then
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

