module nios_ii(loc,alu_output,clk);

	//IN-OUT DECLARATION
	output 		loc,alu_output;
	input 		clk;

	//IN-OUT TYPE DECLARATION
	reg[31:0] 	loc,alu_output;
	wire 			clk;

	//MEMORY DECLARATION (INSTRUCTION MEMORY,REGISTER BANK,DATA MEMORY)
	reg[31:0] 	insmem_48[0:14],
					regmem_48[0:31],
					datamem_48[0:31];
	reg[1:0]  	exit;

	//INTERMEDIATE REGISTERS
	reg[4:0] 	pc_48;
	reg[31:0] 	Inst_F_48,Inst_D_48;
	
	reg[5:0] 	opcode_D_48;
	reg[10:0]	opx_D_48;
	reg[15:0] 	imm_D_48;
	reg[31:0] 	Imm_SignExt_D_48;
	reg[4:0] 	Rd_D_48;
	reg[31:0] 	Des_addr_D_48;
	reg[4:0]		Rs_D_48;
	reg[31:0] 	Alu_ip1_D_48;
	reg[4:0] 	Rt_D_48;
	reg[31:0]	Alu_ip2_D_48;
	reg[2:0]		Alu_opx_D_48;
	reg[1:0]		Alu_src2_D_48;
	reg 			Reg_wr_D_48,Mem_wr_D_48;
	reg			fwd_req_D_48;
	reg[1:0] 	Br_D_48;
	
	reg[5:0] 	opcode_E_48;
	reg[10:0]	opx_E_48;
	reg[31:0] 	Des_addr_E_48;
	reg[1:0] 	Br_E_48;
	reg[2:0]		Alu_opx_E_48;
	reg[1:0]		Alu_src2_E_48,Br_En_E_48;
	reg 			Reg_wr_E_48,Mem_wr_E_48;
	reg[4:0] 	Rd_E_48,Rs_E_48,Rt_E_48;
	reg[31:0] 	Alu_ip1_E_48;
	reg[31:0]	Alu_ip2_E_48;
	reg[31:0] 	Alu_src1_48,
					Alu_src2_48;
	reg[15:0] 	imm_E_48;
	reg[31:0] 	Imm_SignExt_E_48,Alu_output_E_48;
	reg			fwd_req_E_48;
	
	reg[5:0] 	opcode_M_48;
	reg 			Reg_wr_M_48,Mem_wr_M_48;
	reg[31:0] 	Des_addr_M_48;
	reg[4:0] 	Rd_M_48,Rs_M_48,Rt_M_48;
	reg[1:0] 	Br_En_M_48;	
	reg[31:0] 	Alu_output_M_48,Alu_output_M1_48;
	reg			fwd_req_M_48;
	
	reg[31:0]	Alu_output_W_48;
	reg[5:0] 	opcode_W_48;
	reg[4:0] 	Rd_W_48,Rs_W_48;
	reg 			Reg_wr_W_48,Mem_wr_W_48,fwd_req_W_48;
	
initial 
	begin
		
	//INITIALIZE ALL VARIABLES
		pc_48=0;Inst_F_48=0;exit=0;
		
		Inst_D_48=0;opcode_D_48=0;opx_D_48=0;imm_D_48=0;Imm_SignExt_D_48=0;Des_addr_D_48=0;
		Rd_D_48=0;Alu_ip1_D_48=0;Rs_D_48=0;Alu_ip2_D_48=0;Rt_D_48=0;Alu_opx_D_48=0;Alu_src2_D_48=0;
		Alu_src1_48=0;Alu_src2_48=0;Reg_wr_D_48=0;Mem_wr_D_48=0;Br_D_48=0;fwd_req_D_48=0;
		
		opcode_E_48=0;Des_addr_E_48=0;Br_E_48=0;Alu_opx_E_48=0;Alu_src2_E_48=0;Br_En_E_48=0;Reg_wr_E_48=0;
		Mem_wr_E_48=0;Rd_E_48=0;Rs_E_48=0;Rt_E_48=0;Alu_ip1_E_48=0;Alu_ip2_E_48=0;imm_E_48=0;
		Imm_SignExt_E_48=0;Alu_output_E_48=0;fwd_req_E_48=0;opx_E_48=0;
		
		opcode_M_48=0;Reg_wr_M_48=0;Mem_wr_M_48=0;Rd_M_48=0;Rs_M_48=0;Rt_M_48=0;Des_addr_M_48=0;Br_En_M_48=0;fwd_req_M_48=0;
		Alu_output_M_48=0;Alu_output_M1_48=0;
		
		Alu_output_W_48=0;opcode_W_48=0;Rd_W_48=0;Rs_W_48=0;Reg_wr_W_48=0;Mem_wr_W_48=0;fwd_req_W_48=0;
	
	//PROGRAM COUNTER (INITIALLY ZERO TO POINT AT FIRST LINE OF CODE)
		pc_48 = 5'h00;

	//INSTRUCTION MEMORY (WILL CONTAIN THE WHOLE PROGRAM IN ORDER OF EXECUTION)
		insmem_48[0] = 32'h10800005;  //MOVIA R2,AVECTOR
		insmem_48[1] = 32'h18C00245;  //MOVIA R3,BVECTOR
		insmem_48[2] = 32'h210004C5;  //MOVIA R4,N
		insmem_48[3] = 32'h21000011;  //LDW R4,0(R4)
		insmem_48[4] = 32'h280007FA;  //ADD R5,R0,R0
		insmem_48[5] = 32'h30800011;  //LDW R6,0(R2)
		insmem_48[6] = 32'h38C00011;  //LDW R7,0(R3)
		insmem_48[7] = 32'h418E06FA;  //MUL R8,R6,R7
		insmem_48[8] = 32'h295007FA;  //ADD R5,R5,R8
		insmem_48[9] = 32'h10800044;  //ADDI R2,R2,1
		insmem_48[10] = 32'h18C00044; //ADDI R3,R3,1
		insmem_48[11] = 32'h21000047; //SUBI R4,R4,1
		insmem_48[12] = 32'h20000150; //BGT R4,R0,LOOP
		insmem_48[13] = 32'h2800048F; //STW R5,DOT_PRODUCT(R0)
		insmem_48[14] = 32'h00000006; //BR STOP

	//REGISTER MEMORY (WILL CONTAIN THE INTERMEDIATE DATA'S THAT NEED TO BE TEMPORARILY STORED)
		regmem_48[0] = 32'h00000000;
		regmem_48[1] = 32'h00000000;
		regmem_48[2] = 32'h00000000;
		regmem_48[3] = 32'h00000000;
		regmem_48[4] = 32'h00000000;
		regmem_48[5] = 32'h00000000;
		regmem_48[6] = 32'h00000000;
		regmem_48[7] = 32'h00000000;
		regmem_48[8] = 32'h00000000;
		regmem_48[9] = 32'h00000000;
		regmem_48[10] = 32'h00000000;
		regmem_48[11] = 32'h00000000;
		regmem_48[12] = 32'h00000000;
		regmem_48[13] = 32'h00000000;
		regmem_48[14] = 32'h00000000;
		regmem_48[15] = 32'h00000000;

	//DATA MEMORY
		datamem_48[0] = 32'h00000000;	//0	A vector
		datamem_48[1] = 32'h00000001;	//1
		datamem_48[2] = 32'h00000001;	//1
		datamem_48[3] = 32'h00000004;	//4
		datamem_48[4] = 32'h00000007;	//7
		datamem_48[5] = 32'h00000008;	//8
		datamem_48[6] = 32'h00000009;	//9
		datamem_48[7] = 32'h00000004;	//4
		datamem_48[8] = 32'h00000008;	//8
	
		datamem_48[9] = 32'h00000000;	//0	B vector
		datamem_48[10] = 32'h00000002;//2
		datamem_48[11] = 32'h00000002;//2
		datamem_48[12] = 32'h00000009;//9
		datamem_48[13] = 32'h00000005;//5
		datamem_48[14] = 32'h00000007;//7
		datamem_48[15] = 32'h00000008;//8
		datamem_48[16] = 32'h00000009;//9
		datamem_48[17] = 32'h00000006;//6
	
	//answer storage
		datamem_48[18] = 32'h00000000;
		
	//location of N
		datamem_48[19] = 32'h00000009;
	end

always@(pc_48)//-----------------------------------------------------------------------------------------------------------FETCH STAGE
	begin 
		Inst_F_48 = insmem_48[pc_48];
	end	

always@(posedge clk)
	begin 
		Inst_D_48 <= Inst_F_48;
		
			
		if(Br_En_E_48 == 2'b00 && pc_48 == 5'h0c)			//CONDITIONAL BRANCH "BGT R4,R0,LOOP"			
		begin
			pc_48 <= pc_48;
			exit = 0;
		end
		else if(Br_En_E_48 == 2'b11 && pc_48 == 5'h0c)	//CONDITIONAL BRANCH "BGT R4,R0,LOOP"
		begin
			pc_48 <= 5;
			exit = 0;
		end
		else if(Br_En_E_48 == 2'b10 && pc_48 == 5'h0e) 	//UNCONDITIONAL BRANCH "BR STOP"
		begin
			pc_48 <= pc_48 - 1;
			exit = 0;
		end
		else if(opcode_D_48 == 6'h011 && pc_48 == 5'h06 && exit < 2)
		begin
			pc_48 <= pc_48;
			exit <= exit + 1;
		end
		else
		begin
			pc_48 <= pc_48 + 1; 									//NO BRANCHING
			exit = 0;
		end		
	end	
		
always@(Inst_D_48)//-------------------------------------------------------------------------------------------------------DECODE STAGE
	begin
			opcode_D_48 = Inst_D_48[5:0];
			Rd_D_48 = Inst_D_48[31:27];
			Rs_D_48 = Inst_D_48[26:22];
			Alu_ip1_D_48 = regmem_48[Rs_D_48];  	 	//value of source register
			Des_addr_D_48 = regmem_48[Rd_D_48]; 	//value of destination register
		
			if(pc_48 > 1)
				begin
					if(Rs_D_48 == Rd_E_48 || Rt_D_48 == Rd_E_48)
						fwd_req_D_48 = 1;
					else
						fwd_req_D_48 = 0;
				end
				
			case(opcode_D_48)

		//I - TYPE INSTRUCTION FILTERING
		6'h04:							//ADDI
			begin
				imm_D_48 = Inst_D_48[21:6];
				Alu_opx_D_48 = 3'b000;	//ADD
				Reg_wr_D_48 = 1'b1;		//ANSWER IS NEEDED TO BE STORED IN A REGISTER "Rd_48"
				Mem_wr_D_48 = 1'b0;
				Br_D_48 = 2'b00;			//NOT A BRANCHING INSTRUCTION
				Alu_src2_D_48 = 2'b01;	//ALU SOURCE 2 IS AN IMMEDIATE VALUE
				
				//SIGN EXTENSION OPERATION
				if(imm_D_48[15] == 1'b1)
					Imm_SignExt_D_48 = {16'hffff,imm_D_48};
				else
					Imm_SignExt_D_48 = {16'h0000,imm_D_48};
			end

		6'h05:								//MOVIA
			begin
				imm_D_48 = Inst_D_48[21:6];
				Alu_opx_D_48 = 3'b100;		//MOV
				Reg_wr_D_48 = 1'b1;			//ANSWER NEEDS TO BE WRITTEN IN A REGISTER "Rd_48"
				Mem_wr_D_48 = 1'b0;
				Br_D_48 = 2'b00;				//NOT A BRANCHING INSTRUCTION
				Alu_src2_D_48 = 2'b01;		//ALU SOURCE 2 IS AN IMMEDIATE VALUE
				
				//SIGN EXTENSION OPERATION
				if(imm_D_48[15] == 1'b1)
					Imm_SignExt_D_48 = {16'hffff,imm_D_48};
				else
					Imm_SignExt_D_48 = {16'h0000,imm_D_48};
			end

		6'h07:								//SUBI
			begin
				imm_D_48 = Inst_D_48[21:6];
				Alu_opx_D_48 = 3'b010;		//SUBTRACT
				Reg_wr_D_48 = 1'b1;			//ANSWER NEEDS TO BE WRITTEN IN A REGISTER "Rd_48"
				Mem_wr_D_48 = 1'b0;
				Br_D_48 = 2'b00;				//NOT A BRANCHING INSTRUCTION
				Alu_src2_D_48 = 2'b01;		//ALU SOURCE 2 IS AN IMMEDIATE DATA
				
				//SIGN EXTENSION OPERATION
				if(imm_D_48[15] == 1'b1)
					Imm_SignExt_D_48 = {16'hffff,imm_D_48};
				else
					Imm_SignExt_D_48 = {16'h0000,imm_D_48};
			end

		6'h0F:								//STW
			begin
				imm_D_48 = Inst_D_48[21:6];
				Alu_opx_D_48 = 3'b000;		//ADD
				Reg_wr_D_48 = 1'b0;
				Mem_wr_D_48 = 1'b1;			//ANSWER NEEDS TO BE WRITTEN IN A MEMORY LOCATION
				Br_D_48 = 2'b00;				//NOT A BRANCHING INSTRUCTION
				Alu_src2_D_48 = 2'b01;		//ALU SOURCE 2 IS AN IMMEDIATE DATA
				
													//SIGN EXTENSION OPERATION
				if(imm_D_48[15] == 1'b1)
					Imm_SignExt_D_48 = {16'hffff,imm_D_48};
				else
					Imm_SignExt_D_48 = {16'h0000,imm_D_48};
			end

		6'h11:									//LDW
			begin
				imm_D_48 = Inst_D_48[21:6];
				Alu_opx_D_48 = 3'b000;		//ADD
				Reg_wr_D_48 = 1'b1;
				Mem_wr_D_48 = 1'b0;
				Br_D_48 = 2'b00;				//NOT A BRANCHING INSTRUCTION
				Alu_src2_D_48 = 2'b01;		//ALU SOURCE 2 IS AN IMMEDIATE DATA
				
													//SIGN EXTENSION OPERATION
				if(imm_D_48[15] == 1'b1)
					Imm_SignExt_D_48 = {16'hffff,imm_D_48};
				else
					Imm_SignExt_D_48 = {16'h0000,imm_D_48};
			end
	
														//R - TYPE INSTRUCTION FILTERING
		6'h3A:										//ALL R-TYPE INSTRUCTIONS
			begin
				opx_D_48 = Inst_D_48[16:6];
				Rt_D_48 = Inst_D_48[21:17];
				Alu_ip2_D_48 = regmem_48[Rt_D_48];
				Br_D_48 = 2'b00;					//NOT A BRANCHING INSTRUCTION
				Alu_src2_D_48 = 2'b00;			//ALU SOURCE IS A REGISTER "Rt_48"
				Reg_wr_D_48 = 1'b1;				//ANSWER NEEDS TO BE WRITTEN IN A REGISTER
				Mem_wr_D_48 = 1'b0;
				if(opx_D_48 == 11'h01b) 		//MUL
					begin
						Alu_opx_D_48 = 3'b011; 	//MULTIPLY
						//fwd_req_D_48 = 1'b1;
					end
				else if(opx_D_48 == 11'h01f && pc_48 == 6'h09)					//ADD
					begin
						Alu_opx_D_48 = 3'b000;	//ADDITION
						fwd_req_D_48 = 1'b1;
					end
				else									//ADD
					begin
						Alu_opx_D_48 = 3'b000;	//ADDITION
					end
			end

														//J - TYPE INSTRUCTION FILTERING
		6'h10:										//BGT
			begin
				imm_D_48 = Inst_D_48[31:6];
				Imm_SignExt_D_48 = {16'h0000,imm_D_48};
				Alu_opx_D_48 = 3'b001;			//COMPARE
				Reg_wr_D_48 = 1'b0;
				Mem_wr_D_48 = 1'b0;
				Br_D_48 = 2'b11;	 				//ENABLE BRANCH SELECT BIT
				Alu_src2_D_48 = 2'b00;			//ALU SOURCE 2 IS A REGISTER
			end
		6'h06:	 									//BR
			begin
				Alu_opx_D_48 = 3'b001;			//COMPARE
				Imm_SignExt_D_48 = 32'h00000000;
				Reg_wr_D_48 = 1'b0;
				Mem_wr_D_48 = 1'b0;
				Br_D_48 = 2'b10; 					//ENABLE BRANCH SELECT BIT
				Alu_src2_D_48 = 2'b01;			//ALU SOURCE 2 IS A IMMEDIATE DATA
			end
		endcase
	end

always@(posedge clk)
	begin	
														//DECODE STAGE
		fwd_req_E_48 <= fwd_req_D_48;
		Des_addr_E_48 <= Des_addr_D_48;
		opcode_E_48 <= opcode_D_48;
		opx_E_48 <= opx_D_48;
		Rd_E_48 <= Rd_D_48;
		Rs_E_48 <= Rs_D_48;
		Rt_E_48 <= Rt_D_48;
		Alu_ip1_E_48 <= Alu_ip1_D_48;			//SOURCE REGISTER VALUE
		Alu_ip2_E_48 <= Alu_ip2_D_48;			//TARGET REGISTER VALUE
		Imm_SignExt_E_48 <= Imm_SignExt_D_48;
		Alu_opx_E_48 <= Alu_opx_D_48;
		Reg_wr_E_48 <= Reg_wr_D_48;
		Mem_wr_E_48 <= Mem_wr_D_48;
		Br_E_48 <= Br_D_48; 						//BRANCH SELECT BIT
		Alu_src2_E_48 <= Alu_src2_D_48;		//ALU source 2 selection bits	(Rt value or Immediate data)
	end	
	
always@(Rs_E_48,Rd_E_48,Rt_E_48,Alu_ip1_E_48,Alu_ip2_E_48,Imm_SignExt_E_48,Reg_wr_E_48,
					Mem_wr_E_48,Br_E_48,Alu_src2_E_48,Alu_opx_E_48,fwd_req_E_48,Des_addr_E_48,opcode_E_48,opx_E_48)
	begin //----------------------------------------------------------------------------------------------------------------EXECUTE STAGE
			if(fwd_req_E_48 == 0)
			begin
				Alu_src1_48 = Alu_ip1_E_48; 		//ALU SOURCE 1 IS ALWAYS THE SOURCE REGISTER GIVEN IN THE OPERAND
				
				if(Alu_src2_E_48 == 2'b00) 		//ALU SOURCE 2 IS Rt_48 FOR R-TYPE INSTRUCTION
					Alu_src2_48 = Alu_ip2_E_48;
				else if (Alu_src2_E_48 == 2'b01)	//ALU SOURCE 2 IS THE IMMEDIATE DATA FOR I-TYPE INSTRUCTION
					Alu_src2_48 = Imm_SignExt_E_48;
			end
			
			else											//FORWARDING
			begin
				if(opx_E_48 == 11'h01b)				//MULTIPLY
				begin
					Alu_src1_48 = Alu_ip1_E_48;
					Alu_src2_48 = Alu_ip2_E_48;
				end
				else if(opx_E_48 == 11'h01f)		//ADD
				begin
					Alu_src2_48 = Alu_output_M1_48;
					Alu_src1_48 = Alu_ip1_E_48;	//ALU SOURCE 2 IS Rt_48 FOR R-TYPE INSTRUCTION
				end
				else
				begin
					Alu_src1_48 = Alu_output_M1_48;
					if(Alu_src2_E_48 == 2'b00) 							//ALU SOURCE 2 IS Rt_48 FOR R-TYPE INSTRUCTION
						Alu_src2_48 = Alu_ip2_E_48;
					else if (Alu_src2_E_48 == 2'b01) 					//ALU SOURCE 2 IS THE IMMEDIATE DATA FOR I-TYPE INSTRUCTION
						Alu_src2_48 = Imm_SignExt_E_48;
				end
			end
					
				case(Alu_opx_E_48)
					3'b000: 																//ADD
						begin
							Alu_output_E_48 = Alu_src1_48 + Alu_src2_48;  	//CALCULATE THE SUM OR CALCULATE THE MEMORY ADDRESS
							Br_En_E_48=2'b00;											//DISABLE BRANCH
						end
					
					3'b001:																//COMPARE
						begin
							Alu_src1_48 = Des_addr_E_48;
							Alu_src2_48 = Alu_ip1_E_48;
							Alu_output_E_48 = Alu_ip1_E_48;
							if(Alu_src1_48 > Alu_src2_48)			
								Br_En_E_48 = 2'b11;									//BRANCH ENABLE IF R4 GREATER THAN R0
							else
								Br_En_E_48 = 2'b00;									//DISABLE BRANCH
						end
						
					3'b010:																//SUBTRACT
						begin
								Alu_output_E_48 = Alu_src1_48-Alu_src2_48;
								Br_En_E_48 = 2'b00;									//DISABLE BRANCH
						end
					3'b011: 																//MULTIPLY
						begin
								Alu_output_E_48 = Alu_src1_48*Alu_src2_48; 	
								Br_En_E_48 = 2'b00;									//DISABLE BRANCH
						end
					3'b100: 																//MOVE
						begin
								Alu_output_E_48 = Alu_src2_48;					
								Br_En_E_48 = 2'b00;									//DISABLE BRANCH
						end
				endcase
		end

always@(posedge clk)
	begin	
		Des_addr_M_48<=Des_addr_E_48;
		Rd_M_48<=Rd_E_48;
		//Rs_M_48<=Rs_E_48;
		opcode_M_48<=opcode_E_48;
		Alu_output_M_48<=Alu_output_E_48;
		Reg_wr_M_48<=Reg_wr_E_48;
		Mem_wr_M_48<=Mem_wr_E_48;
		fwd_req_M_48 <= fwd_req_E_48;
	end	
	
always@(Alu_output_M_48,Reg_wr_M_48,Mem_wr_M_48,Rs_M_48,Rd_M_48,opcode_M_48)//---------------------------------------------MEMORY READ STAGE
	begin
		if(Mem_wr_M_48==1'b1)
		begin
			if(Reg_wr_M_48==1'b0&&opcode_M_48==6'h0F) //STORE DATA IN MEMORY
				datamem_48[Alu_output_M_48] = Des_addr_M_48;
		end
		else if(Mem_wr_M_48==1'b0 && opcode_M_48==6'h11) //LOAD DATA IN REGISTER
				Alu_output_M1_48 = datamem_48[Alu_output_M_48];
		else
				Alu_output_M1_48 = Alu_output_M_48;
	end
		
always@(posedge clk)
	begin		
	//MEMORY READ STAGE
		Rd_W_48 <= Rd_M_48;
		//Rs_W_48 <= Rs_M_48;
		Alu_output_W_48 <= Alu_output_M1_48;
		Reg_wr_W_48 <= Reg_wr_M_48;
		Mem_wr_W_48 <= Mem_wr_M_48;
		opcode_W_48 <= opcode_M_48;	
		fwd_req_W_48 <= fwd_req_M_48;	
	end	
	
always@(Alu_output_W_48,Rd_W_48,Mem_wr_W_48,Reg_wr_W_48)//-----------------------------------------------------------------WRITE BACK STAGE
	begin
			if(Reg_wr_W_48 == 1'b1)
				regmem_48[Rd_W_48] = Alu_output_W_48;
			end
endmodule
	