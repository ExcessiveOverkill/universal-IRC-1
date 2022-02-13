library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
--
-- Copyright (C) 2007, Peter C. Wallace, Mesa Electronics
-- http://www.mesanet.com
--
-- This program is is licensed under a disjunctive dual license giving you
-- the choice of one of the two following sets of free software/open source
-- licensing terms:
--
--    * GNU General Public License (GPL), version 2.0 or later
--    * 3-clause BSD License
-- 
--
-- The GNU GPL License:
-- 
--     This program is free software; you can redistribute it and/or modify
--     it under the terms of the GNU General Public License as published by
--     the Free Software Foundation; either version 2 of the License, or
--     (at your option) any later version.
-- 
--     This program is distributed in the hope that it will be useful,
--     but WITHOUT ANY WARRANTY; without even the implied warranty of
--     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--     GNU General Public License for more details.
-- 
--     You should have received a copy of the GNU General Public License
--     along with this program; if not, write to the Free Software
--     Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA
-- 
-- 
-- The 3-clause BSD License:
-- 
--     Redistribution and use in source and binary forms, with or without
--     modification, are permitted provided that the following conditions
--     are met:
-- 
--         * Redistributions of source code must retain the above copyright
--           notice, this list of conditions and the following disclaimer.
-- 
--         * Redistributions in binary form must reproduce the above
--           copyright notice, this list of conditions and the following
--           disclaimer in the documentation and/or other materials
--           provided with the distribution.
-- 
--         * Neither the name of Mesa Electronics nor the names of its
--           contributors may be used to endorse or promote products
--           derived from this software without specific prior written
--           permission.
-- 
-- 
-- Disclaimer:
-- 
--     THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
--     "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
--     LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
--     FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
--     COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
--     INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
--     BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
--     LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
--     CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
--     LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
--     ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
--     POSSIBILITY OF SUCH DAMAGE.
-- 
-------------------------------------------------------------------------------
-- 32 bit Harvard Arch accumulator oriented processor ~490 slices: 
-- 1 clk/inst, only exception is conditional jumps:
-- 1 clock if not taken, 3 clocks if taken
-- ~70 MHz operation in Spartan3 ~40 MHz in Spartan2
-- 32 bit data, 24 bit instruction width
-- 64 JMP instructions: 
-- All Ored true, false, dont-care combinations of sign, zero and carry
-- 10 basic memory reference instructions:
-- OR, XOR, AND, ADD, ADDC, SUB, SUBB, LDA, STA, MUL, MULS (ACC OP MEM --> ACC)
-- OR, XOR, AND, ADD, ADDC, SUB, SUBB, LDA have writeback option (ACC OP MEM --> ACC,MEM)
-- Multiply has pipelined mac option with aux 40 bit accumulator
-- 11 operate instructions, load immediate, rotate, mac clear and load bounded mac
-- LXWI, LLWI, LHWI, WSWP, SXW, RCL, RCR, ASHR, CLRMAC, LDMACB, LDMACT?
-- 14 index load/store/increment: 
-- LDY, LDX, LDZ, LDT, STY, STX, STZ, STT, ADDIX, ADDIY, ADDIZ, ADDIT, RTT, TTR  
-- 4K words instruction space
-- 4K words data space (exp to 32K words)
-- 4 index registers for indirect memory access
-- 12-15 bit offset for indirect addressing (ADD sinetable(6) etc)
-- 12-15 bit direct memory addressing range
-- 12-15 bit indirect addressing range with 12 bit offset range
-- 2 levels of subroutine call/return
-- Starts at address 0 from reset
-- THE BAD NEWS: pipelined processor with no locks so --->
-- Instruction hazards: 
--   PUSH/POP must precede JSR by at least 2 instructions
--  
--   PUSH/POP must precede RET by at least 2 instructions
--   (option) No unconditional jumps in 2 instructions after a conditional jump 
-- Data hazards:
--   Stored data requires 3 instructions before fetch
--   MAC data needs one extra instruction time after last MUL before transfer to ACC
-- Address hazards:
--   Fetches via index register require 2 instructions from ST(X,Y,Z,T),ADDI(X,Y) 
--   to actual fetch (STA via index takes no extra delay) 
-------------------------------------------------------------------------------

entity Big32v2 is
	generic(
		width : integer := 32;			-- data width
		iwidth	: integer := 24;		-- instruction width
		maddwidth : integer := 12;	-- memory address width
		macwidth : integer := 40;	-- macwidth
		paddwidth : integer := 12	-- program counter width
       );
	port (
		clk      : in  std_logic;
		reset    : in  std_logic;
		iabus    : out std_logic_vector(paddwidth-1 downto 0);  	-- program address bus
		idbus    : in  std_logic_vector(iwidth-1 downto 0);  		-- program data bus       
		mradd    : out std_logic_vector(maddwidth-1  downto 0);  -- memory read address
		mwadd    : out std_logic_vector(maddwidth-1  downto 0);  -- memory write address
		mibus    : in  std_logic_vector(width-1 downto 0);  		-- memory data in bus     
		mobus    : out std_logic_vector(width-1 downto 0);  		-- memory data out bus
		mwrite   : out std_logic;           							-- memory write signal        
		mread		: out std_logic; 											-- memory read signal
		carryflg : out std_logic            							-- carry flag
		);
end Big32v2;


architecture Behavioral of Big32v2 is


-- basic op codes												-- IIII0MRRXXXXAAAAAAAAAAAA or IIII1MXXXXXXOOOOOOOOOOOO
-- Beware, certain bits are used to simpilfy decoding - dont change without knowing what you are doing...
  constant opr   : std_logic_vector (3 downto 0) := x"0";	-- operate
  constant jsr   : std_logic_vector (3 downto 0) := x"1";	-- jump to sub 
  constant jmp   : std_logic_vector (3 downto 0) := x"2";	-- unconditional jump
  constant jmpc  : std_logic_vector (3 downto 0) := x"3";	-- conditional jump
  constant lda   : std_logic_vector (3 downto 0) := x"4";	-- load accumulator from memory
  constant lor   : std_logic_vector (3 downto 0) := x"5";	-- OR accumulator with memory	
  constant lxor  : std_logic_vector (3 downto 0) := x"6";	-- XOR accumulator with memory	
  constant land  : std_logic_vector (3 downto 0) := x"7";	-- AND accumulator with memory	
  constant idxo  : std_logic_vector (3 downto 0) := x"8";	-- IDX operate  
  constant mul   : std_logic_vector (3 downto 0) := x"9";	-- signed unsigned Multiply  
  constant muls  : std_logic_vector (3 downto 0) := x"A";	-- signed signed Multiply  
  constant sta   : std_logic_vector (3 downto 0) := x"B";	-- store accumulator to memory
  constant add   : std_logic_vector (3 downto 0) := x"C";	-- add memory to accumulator
  constant addc  : std_logic_vector (3 downto 0) := x"D";	-- add memory and carry to accumulator
  constant sub   : std_logic_vector (3 downto 0) := x"E";	-- subtract memory from accumulator
  constant subc  : std_logic_vector (3 downto 0) := x"F";	-- subtract memory and carry from accumulator

-- operate instructions
  constant nop : std_logic_vector (3 downto 0) := x"0";

-- immediate load type									-- 0INNNNh
 
  constant lxwi : std_logic_vector (3 downto 0) := x"1";  
  constant llwi : std_logic_vector (3 downto 0) := x"2";  
  constant lhwi : std_logic_vector (3 downto 0) := x"3";  
  
-- accumulator operate type							-- 0IXXXXh	

  constant rotcl : std_logic_vector (3 downto 0) := x"4";
  constant rotcr : std_logic_vector (3 downto 0) := x"5";
  constant wswp  : std_logic_vector (3 downto 0) := x"6";
  constant sxw   : std_logic_vector (3 downto 0) := x"7";
  
  constant clrmac : std_logic_vector (3 downto 0) := x"8";
  constant ldmacb : std_logic_vector (3 downto 0) := x"9";
  constant ldmact : std_logic_vector (3 downto 0) := x"A";
  constant ashr   : std_logic_vector (3 downto 0) := x"B";
-- constant bitset?
-- constant bitclr?  
-- constant setbit
-- constant	clrbit
  
-- index register load/store in address order 	-- 8IXXXXh
  constant ldx   : std_logic_vector (3 downto 0) := x"0";
  constant ldy   : std_logic_vector (3 downto 0) := x"1";
  constant ldz   : std_logic_vector (3 downto 0) := x"2";
  constant ldt   : std_logic_vector (3 downto 0) := x"3";
  constant stx   : std_logic_vector (3 downto 0) := x"4";
  constant sty   : std_logic_vector (3 downto 0) := x"5";
  constant stz   : std_logic_vector (3 downto 0) := x"6";
  constant stt   : std_logic_vector (3 downto 0) := x"7";
  constant addix : std_logic_vector (3 downto 0) := x"8";
  constant addiy : std_logic_vector (3 downto 0) := x"9";
  constant addiz : std_logic_vector (3 downto 0) := x"A";
  constant addit : std_logic_vector (3 downto 0) := x"B";
  
-- return register save/restore						-- 8IXXXXh
  constant pop   : std_logic_vector (3 downto 0) := x"C";	
  constant push  : std_logic_vector (3 downto 0) := x"D";
  constant ldsp  : std_logic_vector (3 downto 0) := x"E";
  constant stsp  : std_logic_vector (3 downto 0) := x"F";

-- basic signals
  signal accumcar  : std_logic_vector (width downto 0);  -- accumulator+carry
  alias accum      : std_logic_vector (width-1 downto 0) is accumcar(width-1 downto 0);
  alias carrybit   : std_logic is accumcar(width);
  alias signbit    : std_logic is accumcar(width-1);
  signal maskedcarry : std_logic;
  signal macc : std_logic_vector (macwidth-1 downto 0);  -- macccumulator
  alias mmsb : std_logic is macc(macwidth-1);
  alias mnmsbs : std_logic_vector(6 downto 0) is macc(macwidth-2 downto macwidth-8);
  signal macnext : std_logic;

  signal pc        : std_logic_vector (paddwidth -1 downto 0); -- program counter - 12 bits = 4k
  signal mra       : std_logic_vector (maddwidth -1 downto 0);  -- memory read address - 12 bits = 4k
  signal id1       : std_logic_vector (iwidth -1 downto 0);  -- instruction pipeline 1       
  signal id2       : std_logic_vector (iwidth -1 downto 0);  -- instruction pipeline 2 
  alias wbena2     : std_logic is id2(iwidth-2);
  alias writeback2 : std_logic is id2(iwidth-9); 
  signal wbena3    : std_logic; 
  signal writeback3: std_logic; 
  alias opcode0    : std_logic_vector (3 downto 0) is idbus (iwidth-1 downto iwidth-4);   -- main opcode at pipe0
  alias opcode2    : std_logic_vector (3 downto 0) is id2 (iwidth-1 downto iwidth-4);     -- main opcode at pipe2
  signal opcode3   : std_logic_vector (3 downto 0);
  alias CarryMask2 : std_logic is id2 (iwidth-5);
  alias CarryXor2  : std_logic is id2 (iwidth-6); 
  alias ZeroMask2  : std_logic is id2 (iwidth-7);  
  alias ZeroXor2   : std_logic is id2 (iwidth-8); 
  alias SignMask2  : std_logic is id2 (iwidth-9);  
  alias SignXor2   : std_logic is id2 (iwidth-10);  
  alias OvflMask2  : std_logic is id2 (iwidth-11);  
  alias OvflXor2   : std_logic is id2 (iwidth-12);  
  signal jumpq     : std_logic;
  alias Arith		 : std_logic_vector (1 downto 0) is id2 (iwidth-1 downto iwidth-2);
  alias WithCarry  : std_logic is id2(iwidth-4);		-- indicates add with carry or subtract with borrow
  alias Minus      : std_logic is id2(iwidth-3);		-- indicates subtract
  alias opradd0    : std_logic_vector (maddwidth -1 downto 0) is idbus (maddwidth -1 downto 0);               -- operand address at pipe0
  alias opradd2    : std_logic_vector (maddwidth -1 downto 0) is id2 (maddwidth -1 downto 0);                 -- operand address at pipe2
  alias ind0       : std_logic is idbus(iwidth -5); 
  alias ind2       : std_logic is id2(iwidth -5); 
  alias domac      : std_logic is id2(iwidth -6); 
  alias ireg0      : std_logic_vector(1 downto 0) is idbus(iwidth -7 downto iwidth -8); 
  alias offset0    : std_logic_vector (maddwidth-1  downto 0) is idbus(maddwidth-1 downto 0);
  alias opropcode2 : std_logic_vector (3 downto 0) is id2 (iwidth-5 downto iwidth-8);    -- operate opcode at pipe2  alias iopr2      : std_logic_vector (7 downto 0) is id2 (7 downto 0);                 -- immediate operand at pipe2
  alias iopr2      : std_logic_vector (15 downto 0) is id2 (15 downto 0);                 -- immediate operand at pipe2
  signal oprr      : std_logic_vector (width -1 downto 0);                              -- operand register
  signal idx       : std_logic_vector (maddwidth -1 downto 0);
  signal idy       : std_logic_vector (maddwidth -1 downto 0);
  signal idz       : std_logic_vector (maddwidth -1 downto 0);
  signal idt       : std_logic_vector (maddwidth -1 downto 0);

  signal idn0		 : std_logic_vector (maddwidth -1 downto 0);
  signal nextpc    : std_logic_vector (paddwidth -1 downto 0);
  signal pcplus1   : std_logic_vector (paddwidth -1 downto 0);
  signal acczero   : std_logic;
  signal maddpipe1 : std_logic_vector (maddwidth -1 downto 0);
  signal maddpipe2 : std_logic_vector (maddwidth -1 downto 0);
  signal maddpipe3 : std_logic_vector (maddwidth -1 downto 0);
  signal product : std_logic_vector (width -1 downto 0);
  signal apatch : std_logic_vector (width/2 -1 downto 0);
  signal opatch : std_logic_vector (width/2 -1 downto 0);
  signal spw: std_logic_vector (3 downto 0);
  signal spr: std_logic_vector (3 downto 0);	
  signal stackdin: std_logic_vector (width-1 downto 0);
  signal stackdout: std_logic_vector (width-1 downto 0);
  signal stackwe: std_logic;
  signal dopush: std_logic;
  signal dopop: std_logic;
 
  function rotcleft(v : std_logic_vector ) return std_logic_vector is
    variable result   : std_logic_vector(width downto 0);
  begin
    result(width downto 1) := v(width-1 downto 0);
    result(0)              := v(width);
    return result;
  end rotcleft;

  function rotcright(v : std_logic_vector ) return std_logic_vector is
    variable result    : std_logic_vector(width downto 0);
  begin
    result(width -1 downto 0) := v(width downto 1);
    result(width)             := v(0);
    return result;
  end rotcright;

  function signextendword(v : std_logic_vector ) return std_logic_vector is
    variable result         : std_logic_vector(width -1 downto 0);
  begin
    if v(15) = '1' then
      result(width-1 downto 16) := x"FFFF";
    else
      result(width-1 downto 16) := x"0000";
    end if;
    result(15 downto 0)         := v(15 downto 0);
    return result;
  end signextendword;
  
  function wordswap(v : std_logic_vector ) return std_logic_vector is
    variable result   : std_logic_vector(width -1 downto 0);
  begin
    result(width -1 downto 16) := v(15 downto 0);
    result(15 downto 0)        := v(width-1 downto 16);
    return result;
  end wordswap;   

begin  -- the CPU

	StackRam : entity work.adpram 
	generic map (
		width => width,
		depth => 16
				)
	port map(
		addra => spw,
		addrb => spr,
		clk  => clk,
		dina  => stackdin,
--		douta => 
		doutb => stackdout,
		wea	=> stackwe
		);

  nextpcproc : process (clk, reset, pc, acczero, nextpc, 
                        id2, ind0, ind2, idbus, opcode0,
                        opcode2, carrybit, accumcar)  -- next pc calculation - jump decode
  begin
    jumpq <= (((SignBit xor SignXor2) and SignMask2) or
				 ((CarryBit xor CarryXor2) and CarryMask2) or
				 ((acczero xor ZeroXor2) and ZeroMask2)); 

	 pcplus1 <= pc + '1';    
	 iabus <= nextpc;  							-- program memory address from combinatorial    	 
	 if reset = '1' then                   -- nextpc since blockram has built in addr register
      nextpc <= (others => '0');
    else
      if (opcode0 = jmp) or (opcode0= jsr) then
        if ind0 = '1' then              	-- indirect (computed jump or return)
          nextpc <= stackdout(paddwidth -1 downto 0);
        else                            	-- direct (jump or jsr)
          nextpc <= idbus(paddwidth -1 downto 0);
        end if;
      elsif (opcode2 = jmpc) and (jumpq = '1') then	-- direct only
        nextpc <= id2(paddwidth -1 downto 0);
      else
        nextpc <= pcplus1;
      end if;  -- opcode = jmp
    end if;  -- no reset

   if clk'event and clk = '1' then
		pc <= nextpc;
		id1  <= idbus;   									--	instruction pipeline
      id2  <= id1;     
		writeback3 <= writeback2;						-- the writeback bit
		wbena3 <= wbena2;									-- determines writeback suitable instructions
		opcode3 <= opcode2;								-- for late decode of STA
		if reset = '1' or ((opcode2 = jmpc) and (jumpq = '1')) then
--		if reset = '1'  then
			id1  <= (others => '0');                -- on reset or taken conditional jump
			id2  <= (others => '0');					 -- fill inst pipeline with two 0s (nop)
      end if;
   end if;
	
  end process nextpcproc;

  mraproc : process (idbus, idx, idy, idz, idt, mra, ind0,
                     ireg0,
                     offset0, opcode0, opradd0, clk)  -- memory read address generation
  begin
    mradd <= mra;
    -- idx reg mux
	 case ireg0 is
		when "00" => idn0 <= idx;
      when "01" => idn0 <= idy;
		when "10" => idn0 <= idz;
      when "11" => idn0 <= idt;
		when others => null;
     end case;
	 -- direct/ind mux 
	 if ((opcode0 /= opr) and (opcode0 /= idxo) and (ind0 = '0')) then
		mra <= opradd0;
	 else
		mra <= idn0 + offset0;
	 end if;

	if clk'event and clk = '1' then

		if (opcode0 = lda) or (opcode0 = lor) or (opcode0 = lxor) or (opcode0 = land) or (opcode0 = mul)
		or (opcode0 = add) or (opcode0 = addc) or (opcode0 = sub) or (opcode0 = subc) then
			mread <= '1';					-- assert mread for side effects (FIFOs etc)
		else
			mread <= '0';
		end if;		
		maddpipe3 <= maddpipe2;
		maddpipe2 <= maddpipe1;
		maddpipe1 <= mra;
	end if;
	 	 
  end process mraproc;


	oprrproc : process (clk)  			-- memory operand register  -- could remove to
	begin  									-- reduce pipelining depth but would impact I/O read
		if clk'event and clk = '1' then	-- access time  --> not good for larger systems
			oprr <= mibus;
		end if;
	end process oprrproc;

	accumproc : process (clk, accumcar, accum, id2, oprr)  -- accumulator instruction decode - operate
	begin
		carryflg <= carrybit;
		if accum = x"00000000" then
			acczero <= '1';
		else
			acczero <= '0';
		end if;
		maskedcarry <= carrybit and WithCarry;
	
		if clk'event and clk = '1' then
			case opcode2 is 																-- memory reference first
				when land         	=> accum    <= accum and oprr;
				when lor         	 	=> accum    <= accum or oprr;
				when lxor         	=> accum    <= accum xor oprr;
				when lda          	=> accum    <= oprr;		
											if domac = '1' then 
												macnext <= '1';
											else
												macnext <= '0';
											end if;	
				when mul					=> accum(15 downto 0) <= product(15 downto 0);
											accum(31 downto 16)<= product(31 downto 16) -apatch;											
											if domac = '1' then 
												macnext <= '1';
											else
												macnext <= '0';
											end if;								
				when muls				=> accum(15 downto 0) <= product(15 downto 0);
											accum(31 downto 16)<= product(31 downto 16) -apatch -opatch;											
											if domac = '1' then 
												macnext <= '1';
											else
												macnext <= '0';
											end if;	

				when opr					=>  												-- then operate
					case opropcode2 is
						when lxwi      => accum <= signextendword(iopr2);		-- load sign extended word immediate
						when llwi      => accum(15 downto 0)  <= iopr2;			-- load low word immediate
						when lhwi      => accum(31 downto 16) <= iopr2;			-- load high word immediate
						when rotcl     => accumcar <= rotcleft(accumcar);		-- rotate left through carry
						when rotcr     => accumcar <= rotcright(accumcar); 	-- rotate right through carry
						when ashr      => accumcar(width-2 downto 0) <= accumcar(width-1 downto 1);    
											   accumcar(width-1) <= accumcar(width-1);		-- shift right arithmetic (fixed 7/24/12)
						when wswp      => accum <= wordswap(accum); 				-- word swap
						when sxw			=> accum <= signextendword(accum);		-- sign extend 16 bit value in low half
						when clrmac		=> macc <= (others => '0');				-- clear the macc
						when ldmacb		=>
										if mmsb = '0' then							-- positive case
											if mnmsbs = 0 then
												accum <= macc(31 downto 0);		-- no overflow
											else
												accum <= x"7FFFFFFF";				-- if overflow bound to max positive
											end if;
										else												-- negative case
											if mnmsbs = "1111111" then
												accum <= macc(31 downto 0);		-- no overflow
											else
												accum <= x"80000000";				-- if overflow bound to max negative
											end if;
										end if;	
						when others    => null;
					end case;
				when idxo				=> 												-- then index register	operate
					case opropcode2 is
						when ldx       => accum(maddwidth-1 downto 0) <= idx;
						when ldy       => accum(maddwidth-1 downto 0) <= idy;
						when ldz       => accum(maddwidth-1 downto 0) <= idz;
						when ldt       => accum(maddwidth-1 downto 0) <= idt;
		
						when stx       => idx <= accum(maddwidth-1 downto 0);
						when sty       => idy <= accum(maddwidth-1 downto 0);
						when stz       => idz <= accum(maddwidth-1 downto 0);
						when stt       => idt <= accum(maddwidth-1 downto 0);

						when addix		=> idx <= maddpipe2;							-- re-use the offset adder
						when addiy     => idy <= maddpipe2;							-- for add immediate to index
						when addiz		=> idz <= maddpipe2;
						when addit     => idt <= maddpipe2;

						when pop			=> accum <= stackdout;
						when stsp      => spw <= accum(3 downto 0);
						when ldsp		=> accum(3 downto 0) <= spw;
												accum(width-1 downto 4) <= (others => '0');
					
						when others    => null;
					end case;
				when others       => null;
			end case;
		
			if Arith = "11" then
				if Minus = '0' then
					accumcar <= '0'&accum + oprr + maskedcarry; -- add/addc
				else
					accumcar <= '0'&accum - oprr - maskedcarry; -- sub/subc
				end if;
				if domac = '1' then 
					macnext <= '1';
				else
					macnext <= '0';
				end if;	
			end if;	

			if macnext = '1' then
				macc <= macc + accum;
			end if;	
		
			if dopush = '1' then
				spw <= spw +1; 
			end if;

			if dopop = '1' then
				spw <= spw -1; 
			end if;
					
		end if;  -- clk
		
		if opcode0 = jsr then
			stackdin(paddwidth-1 downto 0) <= pcplus1;		--  a jsr (note jsr has priority)
			stackdin(width -1 downto paddwidth) <=(others => '0');
		else
			stackdin <= accum;
		end if;
		
		if (opcode0 = jsr) or ((opcode2 = idxo) and (opropcode2 = push))  then 	   
			stackwe <= '1';
			dopush <= '1';	
		else	
			stackwe <= '0';
			dopush <= '0';	
		end if;   

      if ((opcode0= jmp) and (ind0 = '1'))			-- jmp indirect is a return 
      or ((opcode2 = idxo) and (opropcode2 = pop))  then  
			dopop <= '1';	
		else
			dopop <= '0';	
		end if;  

		spr <= spw -1;		
		
		product <= accum(15 downto 0) * oprr(15 downto 0);
		if accum(15) = '1' then
			apatch <= oprr(15 downto 0);
		else
			apatch <= (others =>'0');
		end if;
		if oprr(15) = '1' then
			opatch <= accum(15 downto 0);
		else
			opatch <= (others =>'0');
		end if;
	
	end process accumproc;


	mwproc : process (accumcar,opcode3,writeback3,wbena3,maddpipe3)  		-- sta/writeback decode  -- not much to do but enable mwrite
	begin
		mwadd <= maddpipe3;						-- address at pipe 3 to match latched accumulator timimg
		mobus <= accum;							-- all we can write is whats in the accum
		if (opcode3 = sta) or ((writeback3 = '1') and (wbena3 = '1')) then
			mwrite <= '1';							-- asserted at pipe 3 to match 
		else											-- latched accumulator/maddpipe3
			mwrite <= '0';
		end if;
  end process mwproc;

end Behavioral;
