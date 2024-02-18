	AREA MyCode, CODE, Readonly
	EXPORT __main
	ALIGN
	ENTRY
__main	PROC

	BL  project  ;execute project procedure 
	
Stop B Stop

	ENDP
		
		
cscore DCD 670, 695, 620, 850, 420, 353, 710, 545, 302, 780	;array for credit score
debt DCD 0, 0, 20, 0, 3, 0, 30, 15, 0, 0 ;array for debt 
married	DCD 0, 1, 0, 1, 1, 0, 0, 0, 1, 1 ;array for marriage status
	
project PROC
	
		;set the starting memory address of each array to registers
		LDR r0,=cscore 
		LDR r1,=debt
		LDR r2,=married
		
		;where the result will be stored
		LDR r7,=0x20000000
		
		MOV r3, #0 ;index for the arrays
	
		MOV r8, #0 ;Credit card NO
		MOV r9, #1 ;Credit card Yes
		
		B loop

loop 	CMP r3, #10 ;while index < 10
		BGE endloop

		;set each array[index] values to registers
		LDR r4, [r2, r3, LSL #2] ;married
		LDR r5, [r0, r3, LSL #2] ;cscore
		LDR r6, [r1, r3, LSL #2] ;debt

		;first split
		CMP r4, #1 ;compare marriage status with 1 then split
		BEQ loopTyler
		BNE loopJason
		
		;split on N2 
loopTyler CMP r5, #420 ;compare credit score with 420 then split
		BLE loop1
		BGT loop2
		
loop1	STRB r8, [r7],#1 ;node(N4) is no
		ADD r3, r3, #1 ;index++
		B loop ;back to loop

loop2	STRB r9, [r7],#1 ;node(N5) is yes
		ADD r3, r3, #1 ;index++
		B loop ;back to the loop

		;split on N3
loopJason CMP r5, #620 ;compare credit score with 620 then split

		BLE loopArmis 
		
		;if it is greater than 620 (split on N7)
		CBZ r6, loop3 ;compare and branch if zero
		CBNZ r6, loop4 ;compare and branch if not zero

loop3	STRB r9, [r7],#1 ;node(N10) is yes
		ADD r3, r3, #1 ;index++
		B loop ;back to the loop
		
loop4 	STRB r8, [r7],#1 ;node(N11) is no
		ADD r3, r3, #1 ;index++
		B loop ;back to the loop

		;split on N6
loopArmis 
		CBZ r6, loop5 ;compare and branch if zero
		CBNZ r6, loop6 ;compare and branch if not zero

loop5	STRB r9, [r7],#1 ;node(N8) is yes
		ADD r3, r3, #1 ;index++
		B loop ;back to the loop
		
loop6 	STRB r8, [r7],#1 ;node(N9) is no
		ADD r3, r3, #1 ;index++
		B loop ;back to the loop

endloop
		BX LR ;return 
	ENDP    
	END 