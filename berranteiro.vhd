-- Copyright (C) 1991-2012 Altera Corporation
-- Your use of Altera Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Altera Program License 
-- Subscription Agreement, Altera MegaCore Function License 
-- Agreement, or other applicable license agreement, including, 
-- without limitation, that your use is for the sole purpose of 
-- programming logic devices manufactured by Altera and sold by 
-- Altera or its authorized distributors.  Please refer to the 
-- applicable agreement for further details.

-- Generated by Quartus II Version 12.1 Build 243 01/31/2013 Service Pack 1 SJ Web Edition
-- Created on Thu Nov 07 14:21:30 2019

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY berranteiro IS
    PORT (
        clock : IN STD_LOGIC;
        reset : IN STD_LOGIC := '0';
        B1 : IN STD_LOGIC := '0';
        B2 : IN STD_LOGIC := '0';
        B3 : IN STD_LOGIC := '0';
        B4 : IN STD_LOGIC := '0';
        butOne : IN STD_LOGIC := '0';
        butHalf : IN STD_LOGIC := '0';
        r1 : OUT STD_LOGIC;
        r2 : OUT STD_LOGIC;
        r3 : OUT STD_LOGIC;
        r4 : OUT STD_LOGIC
    );
END berranteiro;

ARCHITECTURE BEHAVIOR OF berranteiro IS
    TYPE type_fstate IS (principio,maisOne1,maisHalf1,start1,start2,start3,start4,entregaComTroco,entregaSemTroco);
    SIGNAL fstate : type_fstate;
    SIGNAL reg_fstate : type_fstate;
	 
	 signal pr1: bit_vector(2 downto 0):= "001"; --50 centavos
	 signal pr2: bit_vector(2 downto 0):= "010"; --1 real
	 signal pr3: bit_vector(2 downto 0):= "100"; --2 reais
	 signal pr4: bit_vector(2 downto 0):= "101"; --2,50 reais
	 signal pnow: bit_vector(2 downto 0):="000";
	 
	 signal pMeta: bit_vector(2 downto 0); --Preço que deve ser atingido
	 signal pMetaMaior: bit_vector(2 downto 0);
	 
	 signal cent: bit_vector(2 downto 0):="001";
	 signal reais: bit_vector(2 downto 0):="010";
	 
	 signal seiya: bit_vector(2 downto 0);
	 signal carry: bit_vector(2 downto 0);

	 
	 
BEGIN
    PROCESS (clock,reg_fstate)
    BEGIN
        IF (clock='1' AND clock'event) THEN
            fstate <= reg_fstate;
        END IF;
    END PROCESS;

    PROCESS (fstate,reset,B1,B2,B3,B4,butOne,butHalf)
    BEGIN
        IF (reset='1') THEN
            reg_fstate <= principio;
            r1 <= '0';
            r2 <= '0';
            r3 <= '0';
            r4 <= '0';
        ELSE
            r1 <= '0';
            r2 <= '0';
            r3 <= '0';
            r4 <= '0';
            CASE fstate IS
                WHEN principio =>
                    IF (((((B1 = '1') AND (B2 = '0')) AND (B3 = '0')) AND (B4 = '0'))) THEN
                        reg_fstate <= start1;
                    ELSIF (((((B1 = '0') AND (B2 = '1')) AND (B3 = '0')) AND (B4 = '0'))) THEN
                        reg_fstate <= start2;
                    ELSIF (((((B1 = '0') AND (B2 = '0')) AND (B3 = '1')) AND (B4 = '0'))) THEN
                        reg_fstate <= start3;
                    ELSIF (((((B1 = '0') AND (B2 = '0')) AND (B3 = '0')) AND (B4 = '1'))) THEN
                        reg_fstate <= start4;
                    -- Inserting 'else' block to prevent latch inference
                    ELSE
                        reg_fstate <= principio;
                    END IF;
						  
                WHEN maisOne1 =>
                    IF (((butOne = '0') AND (butHalf = '1'))) THEN
                        reg_fstate <= maisHalf1;
                    ELSIF (((butOne = '1') AND (butHalf = '0'))) THEN
                        reg_fstate <= maisOne1;
                    -- Inserting 'else' block to prevent latch inference
						  ELSIF (pnow = pMeta) THEN
								reg_fstate <= entregaSemTroco;
						  ELSIF (pnow = pMetaMaior) THEN
								reg_fstate <= entregaComTroco;
                    ELSE
                        reg_fstate <= maisOne1;
                    END IF;
							 
							
						  pnow(2) <= pnow(2) xor reais(2) xor carry(1);
							carry(2) <= (pnow(2) and reais(2)) or (pnow(2) and carry(1)) or (carry(1) and reais(2)); 
							
						  pnow(1) <= pnow(1) xor reais(1) xor carry(0);
							carry(1) <= (pnow(1) and reais(1)) or (pnow(1) and carry(0)) or (carry(0) and reais(1)); 
							
						  pnow(0) <= pnow(0) xor reais(0);
							carry(0) <= pnow(0) and reais(0);
							
						  
                WHEN maisHalf1 =>
                    IF (((butOne = '1') AND (butHalf = '0'))) THEN
                        reg_fstate <= maisOne1;
                    ELSIF (((butOne = '0') AND (butHalf = '1'))) THEN
                        reg_fstate <= maisHalf1;
                    -- Inserting 'else' block to prevent latch inference
						  ELSIF (pnow = pMeta) THEN
								reg_fstate <= entregaSemTroco;
						  ELSIF (pnow = pMetaMaior) THEN
								reg_fstate <= entregaComTroco;
                    ELSE
                        reg_fstate <= maisHalf1;
                    END IF;
						  
						  pnow(2) <= pnow(2) xor cent(2) xor carry(1);
							carry(2) <= (pnow(2) and cent(2)) or (pnow(2) and carry(1)) or (carry(1) and cent(2)); 
							
						  pnow(1) <= pnow(1) xor cent(1) xor carry(0);
							carry(1) <= (pnow(1) and cent(1)) or (pnow(1) and carry(0)) or (carry(0) and cent(1)); 
							
						  pnow(0) <= pnow(0) xor cent(0);
							carry(0) <= pnow(0) and cent(0);
						  
						  
                WHEN start1 =>
                    IF (((butOne = '1') AND (butHalf = '0'))) THEN
                        reg_fstate <= maisOne1;
                    ELSIF (((butOne = '0') AND (butHalf = '1'))) THEN
                        reg_fstate <= maisHalf1;
                    -- Inserting 'else' block to prevent latch inference
                    ELSE
                        reg_fstate <= start1;
                    END IF;

                    r1 <= '1';
						  pMeta <= pr1; --Definir o preço do refrigerante
						  
                WHEN start2 =>
                    IF (((butOne = '1') AND (butHalf = '0'))) THEN
                        reg_fstate <= maisOne1;
                    ELSIF (((butOne = '0') AND (butHalf = '1'))) THEN
                        reg_fstate <= maisHalf1;
                    -- Inserting 'else' block to prevent latch inference
                    ELSE
                        reg_fstate <= start2;
                    END IF;

                    r2 <= '1';
						  pMeta <= pr2; --Definir o preço do refrigerante
						  
						  pMetaMaior(2)<= pr2(2) or (pr2(1) and pr2(0));
						  pMetaMaior(1)<= pr2(1) xor pr2(0);
						  pMetaMaior(0)<= not pr2(0);
						  
                WHEN start3 =>
                    IF (((butOne = '1') AND (butHalf = '0'))) THEN
                        reg_fstate <= maisOne1;
                    ELSIF (((butOne = '0') AND (butHalf = '1'))) THEN
                        reg_fstate <= maisHalf1;
                    -- Inserting 'else' block to prevent latch inference
                    ELSE
                        reg_fstate <= start3;
                    END IF;

                    r3 <= '1';
						  pMeta <= pr3; --Definir o preço do refrigerante
						  
                WHEN start4 =>
                    IF (((butOne = '1') AND (butHalf = '0'))) THEN
                        reg_fstate <= maisOne1;
                    ELSIF (((butOne = '0') AND (butHalf = '1'))) THEN
                        reg_fstate <= maisHalf1;
                    -- Inserting 'else' block to prevent latch inference
                    ELSE
                        reg_fstate <= start4;
                    END IF;

                    r4 <= '1';
						  pMeta <= pr4; --Definir o preço do refrigerante

					 WHEN entregaComTroco =>
							pnow <="000";
							
							--Código pra quando for troco
							
							
					 WHEN entregaSemTroco =>
							pnow <="000";
					 
							--Código pra quando não tiver troco
					 
					 
					 
					 
                WHEN OTHERS => 
                    r1 <= 'X';
                    r2 <= 'X';
                    r3 <= 'X';
                    r4 <= 'X';
                    report "Reach undefined state";
            END CASE;
        END IF;
    END PROCESS;
END BEHAVIOR;
