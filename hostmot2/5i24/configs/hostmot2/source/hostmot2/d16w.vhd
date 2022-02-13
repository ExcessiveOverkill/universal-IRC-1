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
-- 16 bit Harvard Arch accumulator oriented processor ~135 S6 slices: 
-- 1 clk/inst, only exception is conditional jumps:
-- 1 clock if not taken, 3 clocks if taken
-- ~100 MHz operation in Spartan6
-- 16 bit data, 24 bit instruction width
-- 64 JMP instructions: 
-- All Ored true, false, dont-care combinations of sign, zero and carry
-- 10 basic memory reference instructions:
-- OR, XOR, AND, ADD, ADDC, SUB, SUBB, LDA, STA, MUL, MULS (ACC OP MEM --> ACC)
-- OR, XOR, AND, ADD, ADDC, SUB, SUBB, LDA have writeback option (ACC OP MEM --> ACC,MEM)
-- 8 operate instructions, load immediate, rotate
-- NOP, LWI, WSWP, SXW, RCL, RCR, ASHR, LDPH
-- 14 index load/store/increment: 
-- LDY, LDX, LDZ, LDT, STY, STX, STZ, STT, ADDIX, ADDIY, ADDIZ, ADDIT 
-- PUSH, POP, LDSP, STSP
-- 4K words instruction space
-- 4K words data space (exp to 32K words)
-- 4 index registers for indirect memory access
-- 12-15 bit offset for indirect addressing (ADD sinetable(6) etc)
-- 12-15 bit direct memory addressing range
-- 12-15 bit indirect addressing range with 12 bit offset range
-- 16 levels of subroutine call/return
-- Starts at address 0 from reset
-- THE BAD NEWS: pipelined processor with no locks so --->
-- Instruction hazards: 
--   PUSH/POP must precede JSR by at least 2 instructions
--  
--   PUSH/POP must precede RET by at least 2 instructions
--   (option) No unconditional jumps in 2 instructions after a conditional jump 
-- Data hazards:
--   Stored data requires 3 instructions before fetch
-- Address hazards:
--   Fetches via index register require 2 instructions from ST(X,Y,Z,T),ADDI(X,Y) 
--   to actual fetch (STA via index takes no extra delay) 
-------------------------------------------------------------------------------

entity D16w is
	generic(
		width : integer := 16;			-- data width
		iwidth	: integer := 24;		-- instruction width
		maddwidth : integer := 12;	-- memory address width
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
end D16w;


architecture Behavioral of D16w is


-- basic op codes												-- IIIINMRRXXXXAAAAAAAAAAAA or IIII1MXXXXXXOOOOOOOOOOOO
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
 
  constant lwi : std_logic_vector (3 downto 0) := x"1";  
  
-- accumulator operate type							-- 0IXXXXh	

  constant rotcl : std_logic_vector (3 downto 0) := x"4"; 	-- rotate through carry left
  constant rotcr : std_logic_vector (3 downto 0) := x"5"; 	-- rotate through carry right
  constant bswp  : std_logic_vector (3 downto 0) := x"6";	-- byte swap
  constant sxb   : std_logic_vector (3 downto 0) := x"7";	-- sign extend byte
  constant ldph  : std_logic_vector (3 downto 0) := x"8";	-- load product high part
  
  constant ashr   : std_logic_vector (3 downto 0) := x"B";	-- arithmatic shift right
  
-- index register load/store in address order 	-- 8IXXXXh
  constant ldx   : std_logic_vector (3 downto 0) := x"0";	-- load acc from X
  constant ldy   : std_logic_vector (3 downto 0) := x"1";	-- load acc from Y	
  constant ldz   : std_logic_vector (3 downto 0) := x"2";	-- load acc from Z
  constant ldt   : std_logic_vector (3 downto 0) := x"3";	-- load acc from T
  constant stx   : std_logic_vector (3 downto 0) := x"4";	-- store acc to X
  constant sty   : std_logic_vector (3 downto 0) := x"5";	-- store acc to Y
  constant stz   : std_logic_vector (3 downto 0) := x"6";	-- store acc to Z
  constant stt   : std_logic_vector (3 downto 0) := x"7";	-- store acc to T
  constant addix : std_logic_vector (3 downto 0) := x"8";	-- add immediate to X
  constant addiy : std_logic_vector (3 downto 0) := x"9";	-- add immediate to Y
  constant addiz : std_logic_vector (3 downto 0) := x"A";	-- add immediate to Z
  constant addit : std_logic_vector (3 downto 0) := x"B";	-- add immediate to T
  
-- return register save/restore						-- 8IXXXXh
  constant pop   : std_logic_vector (3 downto 0) := x"C";	-- pop top of stack to accum
  constant push  : std_logic_vector (3 downto 0) := x"D";	--	push accum on stack
  constant ldsp  : std_logic_vector (3 downto 0) := x"E";	--	load acc from stack pointer
  constant stsp  : std_logic_vector (3 downto 0) := x"F";	-- store acc to stack pointer
  
-- basic signals

  signal accumcar  : std_logic_vector (width downto 0);  -- accumulator+carry
  alias accum      : std_logic_vector (width-1 downto 0) is accumcar(width-1 downto 0);
  alias carrybit   : std_logic is accumcar(width);
  alias signbit    : std_logic is accumcar(width-1);
  signal maskedcarry : std_logic;

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
  alias swap2      : std_logic is id2(iwidth -6);
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
  signal idr       : std_logic_vector (paddwidth -1 downto 0);
  signal idrt		 : std_logic_vector (paddwidth -1 downto 0);
  signal nextpc    : std_logic_vector (paddwidth -1 downto 0);
  signal pcplus1   : std_logic_vector (paddwidth -1 downto 0);
  signal acczero   : std_logic;
  signal maddpipe1 : std_logic_vector (maddwidth -1 downto 0);
  signal maddpipe2 : std_logic_vector (maddwidth -1 downto 0);
  signal maddpipe3 : std_logic_vector (maddwidth -1 downto 0);
  signal product : std_logic_vector (width*2 -1 downto 0);
  signal apatch : std_logic_vector (width -1 downto 0);
  signal opatch : std_logic_vector (width -1 downto 0);
  signal prodhigh: std_logic_vector (width -1 downto 0);
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

  function signextendbyte(v : std_logic_vector ) return std_logic_vector is
    variable result         : std_logic_vector(width -1 downto 0);
  begin
    if v(7) = '1' then
      result(width-1 downto 8) := x"FF";
    else
      result(width-1 downto 8) := x"00";
    end if;
    result(7 downto 0)         := v(7 downto 0);
    return result;
  end signextendbyte;
  
  function byteswap(v : std_logic_vector ) return std_logic_vector is
    variable result   : std_logic_vector(width -1 downto 0);
  begin
    result(width -1 downto 8) := v(7 downto 0);
    result(7 downto 0)        := v(width-1 downto 8);
    return result;
  end byteswap;   

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
		
  nextpcproc : process (clk, reset, pc, acczero, nextpc, id2, pcplus1,
                        ind0, ind2,idr, idbus, opcode0, jumpq,
                        opcode2, carrybit, accumcar,stackdout)  -- next pc calculation - jump decode
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
			id1  <= (others => '0');                -- on reset or taken conditional jump
			id2  <= (others => '0');					 -- fill inst pipeline with two 0s (nop)
      end if;
   end if;
	
  end process nextpcproc;

  mraproc : process (idbus, idx, idy, idz, idt,
                     ireg0, idn0, ind0, mra, 
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

	accumproc : process (clk, accumcar, accum, id2, -- accumulator instruction decode - operate
								oprr, idbus, pcplus1, spw)  
	begin
		carryflg <= carrybit;
		if accum = x"0000" then
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
				when mul					=> accum <= product(15 downto 0);
												prodhigh <= product(31 downto 16) -apatch;											
				when muls				=> accum <= product(15 downto 0);
												prodhigh <= product(31 downto 16) -apatch -opatch;											
				when opr					=>  												-- then operate
					case opropcode2 is
						when lwi	      => accum <= (iopr2);							-- load word immediate
						when rotcl     => accumcar <= rotcleft(accumcar);		-- rotate left through carry
						when rotcr     => accumcar <= rotcright(accumcar); 	-- rotate right through carry
						when ashr      => accumcar(width-2 downto 0) <= accumcar(width-1 downto 1);    
											   accumcar(width-1) <= accumcar(width-1);	-- shift right arithmetic 
						when bswp      => accum <= byteswap(accum); 				-- byte swap
						when sxb			=> accum <= signextendbyte(accum);		-- sign extend 8 bit value in low half
						when ldph		=> accum <= prodhigh;						-- load product high

						when others    => null;
					end case;
				when idxo				=> 												-- then index register	operate
					case opropcode2 is
						when ldx       => accum(maddwidth-1 downto 0) <= idx;
												accum(width-1 downto maddwidth) <= (others => '0');
						when ldy       => accum(maddwidth-1 downto 0) <= idy;
												accum(width-1 downto maddwidth) <= (others => '0');
						when ldz       => accum(maddwidth-1 downto 0) <= idz;
												accum(width-1 downto maddwidth) <= (others => '0');
						when ldt       => accum(maddwidth-1 downto 0) <= idt;
												accum(width-1 downto maddwidth) <= (others => '0');
		
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
					accumcar <= ('0'&accum) + ('0'&oprr) + (x"0000"&maskedcarry); -- add/addc
				else
					accumcar <= ('0'&accum) - ('0'&oprr) - (x"0000"&maskedcarry); -- sub/subc
				end if;
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
		
		product <= accum * oprr;
		if accum(15) = '1' then
			apatch <= oprr;
		else
			apatch <= (others =>'0');
		end if;
		if oprr(15) = '1' then
			opatch <= accum;
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
