# Chuong trinh: Nhan 2 so nguyen 32 bit
#-----------------------------------
# Data segment
	.data
# Cac dinh nghia bien
dulieu1:	.space	8
dulieu2:	.space	8
dulieu1_hi:	.word	0	#32 bit cao cua dulieu1
output_hi:	.word 	0	#32 bit cao cua ket qua
output_lo:	.word	0	#32 bit thap cua ket qua 
dau:			.word	0	# dau cua phep nhan

#Bien hien thi decimal
ans:			.space	30	# ket qua he 10
ans_tmp:		.space	30	# Bien ket qua tam thoi
base:		.space	30	# co gia tri 2^x, x>=0
base_tmp:		.space	30	# Bien base tam thoi

tenfile:	.asciiz	"INT2.BIN"
fdescr:	.word	0	
# Cac cau nhac nhap va xuat du lieu
str_dl1:	.asciiz	"Du lieu 1 = "
str_dl2:	.asciiz	"Du lieu 2 = "
str_loi:	.asciiz	"Mo file bi loi."
str_kq_bin:	.asciiz	"Ket qua sau khi nhan he 2 la: "
str_kq_dec:	.asciiz	"Ket qua sau khi nhan he 10 la: "
#-----------------------------------
# Code segment
	.text
	.globl	main
#-----------------------------------
# Chuong trinh chinh
#-----------------------------------
main:	
# Nhap (syscall)
# Xu ly
  # mo file doc
	la	$a0,tenfile
	addi	$a1,$zero,0	#flag=0:read only
	addi	$v0,$zero,13
	syscall
	bltz	$v0,baoloi	#Kiem tra tinh trang file
	sw	$v0,fdescr
  # ghi du lieu tu file vao bien
    # 4 byte so nguyen thu nhat
  	lw	$a0,fdescr
  	la	$a1,dulieu1
  	addi	$a2,$zero,4
  	addi	$v0,$zero,14
  	syscall
    # 4 byte so nguyen thu 2
  	la	$a1,dulieu2
  	addi	$a2,$zero,4
  	addi	$v0,$zero,14
  	syscall
  # dong file
	lw	$a0,fdescr
	addi	$v0,$zero,16
	syscall
  #Goi ham nhan
  	#Nhan tham so dau vao
  	lw $a1, dulieu1_hi
  	
Load_32bit_of_a:
	la $a0, dulieu1
  	lw $a2,4($a0)
  	sll $a2,$a2,16
  	lw $t0, dulieu1
  	or $a2,$a2,$t0
Load_32bit_of_b:
	la $a0, dulieu2
  	lw $a3,4($a0)
	sll $a3,$a3,16
	lw $t0, dulieu2
  	or $a3,$a3,$t0
  	
	#xu li am duong
	srl $t0,$a2,31 #bit dau cua so a
	srl $t1,$a3,31 #bit dau cua so b
	beq $t0,$t1,Check_a # if (a*b >= 0) check a;
	li $t0,1
	sw $t0, dau
	
Check_a:
	slt $t0,$a2,$zero
	beqz $t0,Check_b #if(a >= 0) check b;
	j Fix_a
Check_b:
	slt $t0,$a3,$zero
	beqz $t0,Function_call #if(b >= 0) Function_call;
	j Fix_b 
Fix_a: #else Fix a;
	nor $a2,$a2,$zero
	addiu $a2,$a2,1
	j Check_b
Fix_b: #else Fix b;
	nor $a3,$a3,$zero
	addiu $a3,$a3,1
	#Goi ham
Function_call:
  	jal Multi32
  	#Luu ket qua
  	sw $a1,output_hi
  	sw $a3,output_lo
  	
  	#Xuat ket qua
  	jal	Xuat_kq
  	jal	Xuat_kq_decimal
  #Ket thuc
  	j Kthuc
baoloi:	
	la	$a0,str_loi
	addi	$v0,$zero,4
	syscall
	j Kthuc
######## Ham nhan 2 so nguyen 32 bit ########
#$a1: chua 32 bit cao cua tich
#$a2: chua so nguyen 1 (so a) (so bi nhan)
#$a3: chua so nguyen 2 (so b) (so nhan) (chua 32 bit thap cua tich)
#$t0: bien dem count = 0
Multi32:
  li $t0,32
  Loop:
  	beqz $t0,end_Loop #if(count == 0) break;
  	andi $t1,$a3,1 # $t1 = LSB cua tich
  	beqz $t1,continue # if($t1 == 0) continue;
  	addu $a1,$a1,$a2 # ans_hi += a;
  	
     continue:
   	andi $t1,$a1,1 # $t1 = LSB cua 32 bit cao cua tich
   	srl $a1,$a1,1 #dich phai 32 bit cao cua tich
   	srl $a3,$a3,1 #dich phai 32 bit thap cua tich
Gan_bit:
	beqz $t1,next_Loop #if ($t1 == 0) next_Loop;
	ori $a3,$a3,0x80000000 # else (MSB 32 bit thap cua tich) = 1;
next_Loop:
   	subi $t0,$t0,1 #count -=1;
   	j Loop 
  end_Loop:
  	jr $ra
################ Ket thuc ham ################

# Xuat ket qua (syscall)
Xuat_kq:
  # in du lieu 1
	la	$a0,str_dl1
	addi	$v0,$zero,4
	syscall
	
	lw	$a0,dulieu1
	addi	$v0,$zero,1
	syscall
  # xuong dong
	addi	$a0,$zero,'\n'
	addi	$v0,$zero,11
	syscall
  # in du lieu 2
	la	$a0,str_dl2
	addi	$v0,$zero,4
	syscall
	
	lw	$a0,dulieu2
	addi	$v0,$zero,1
	syscall
  # xuong dong
	addi	$a0,$zero,'\n'
	addi	$v0,$zero,11
	syscall
  #Xuat ket qua phep nhan
	la $a0,str_kq_bin
	li $v0,4
	syscall 
	#Doi dau neu am
	lw $a0,dau
	lw $t3,output_hi
   	lw $t4,output_lo
	beqz $a0,Duong
   Am:
   	Bu_1:
   	nor $t3,$t3,$zero
   	nor $t4,$t4,$zero # Bu 1
   	
   	Bu_2:
   	addiu $t4,$t4,1 # add 32 bit lo
   	sltiu $t5,$t4,1 #carry flag
   	addu $t3,$t3,$t5 #add 32 bit hi
   	
   Duong:
	#Xuat 32 bit cao (neu khac 0)
	move $a0,$t3
	beqz $a0,ans_low # if (ans_hi == 0) goto label ans_low
	li $v0,35
	syscall
	#Xuat 32 bit thap
  ans_low:
	li $v0,35
	move $a0,$t4
	syscall 
    # xuong dong
	addi	$a0,$zero,'\n'
	addi	$v0,$zero,11
	syscall
  #Return
  	jr $ra
############# In ra so decimal ################
Xuat_kq_decimal:
 
li $t0,'1'
la $a0,base
sb $t0,0($a0) #base = 2^0 - Initialize base = 1

li $t0,'0'
la $a0,ans
sb $t0,0($a0) # ans = 0

li $t9,64 # count = 64

#Init:
	lw $s0,output_hi # Load 32 bit cao
	lw $s1,output_lo # Load 32 bit thap

  while_shift:
  	beqz $t9,end_shift #if(count == 0) break;
  	andi $t0,$s1,1 #LSB cua 32 bit thap
  	bnez $t0,update_ans # ans += base;
  	
  next_while_shift:
  	
  	srl $s1,$s1,1 # dich phai 32 bit thap
  	andi $t0,$s0,1 # LSB cua 32 bit cao
  	srl $s0,$s0,1 # dich phai 32 bit cao
  	beqz $t0,condition_next_shift # LSB == 0 thi continue
  	ori $s1,$s1,0x80000000 # else MSB cua 32 bit thap bang 1
  	
  condition_next_shift:
  	j update_base # base *= 2;
  	
  after_update_base:
  	subi $t9,$t9,1 # count--;
  	j while_shift
  	
  end_shift:
  	j decimal_out
########################## update ans ##########################
update_ans:
	
	#Get ans len
	strlen_ans:
		li $t0,0
		la $v1,ans
  	loop_strlen_ans:
		lb $t3,0($v1)
		beqz $t3,end_loop_strlen_ans
		addi $v1,$v1,1
		addi $t0,$t0,1
		j loop_strlen_ans
  	end_loop_strlen_ans:
  	
  	#get base len:
  	strlen_base:
		li $t1,0
		la $v1,base
  	loop_strlen_base:
		lb $t3,0($v1)
		beqz $t3,end_loop_strlen_base
		addi $v1,$v1,1
		addi $t1,$t1,1
		j loop_strlen_base
  	end_loop_strlen_base:
  	
string_add1:
	la $a0,ans # s1
	la $a1,base # s2
	li $t2,0 # char = 0;
	
	subi $t0,$t0,1 # len1 = len(s1) - 1;
	subi $t1,$t1,1 # leb2 = len(s2) - 1;
	
	add $a0,$a0,$t0 # s1[n-1]
	add $a1,$a1,$t1 # s2[n-1]
	
  while_add1:
  	addi $t3,$t2,0 # v = char;
  	condi11:
  	bltz $t0,condi21 # if(len1 < 0) check condi21;
  	lb $v0,0($a0)
  	add $t3,$t3,$v0
  	subi $t3,$t3,48 # v += s1[len1] - '0';
  	
  	condi21:
  	bltz $t1,condi31 # if(len2 < 0) check condi31;
  	lb $v0,0($a1)
  	add $t3,$t3,$v0
  	subi $t3,$t3,48 # v += s2[len2] - '0';
  	
  	j do_last1 # ans = (v%10 + 48) <-concat-> ans;
  	
  	condi31:
  	blez $t2,end_while_add1 # if(char < 0) break;
  	
  	do_last1:
  		li $t4,10
  		div $t3,$t4 
  		mflo $t2 # char = v/10;
  		mfhi $t3
  		addi $t3,$t3,48
  		j concat1
  next_while_add1:
  	subi $t0,$t0,1	# len1--;
  	subi $t1,$t1,1	# len2--;
  	subi $a0,$a0,1 # step back string s1
  	subi $a1,$a1,1 # step back string s2
  	j while_add1
  	
  end_while_add1:
  	#clear ans:
  	la $v0,ans_tmp
  	la $v1,ans
  	while_not_null_1:
  		lb $t0,0($v0)
  		beqz $t0,end_while_not_null_1
  		sb $t0,0($v1) # ans[i] = ans_tmp[i];
  		
  		li $t0,0
  		sb $t0,0($v0) # clear ans[i];
  		
  		addi $v0,$v0,1
  		addi $v1,$v1,1
  		j while_not_null_1
  		
  	end_while_not_null_1:
	j next_while_shift 
########concat1###########
concat1:
	li $v0,0
	la $t4,ans_tmp
  while_last1:
  	lb $t5,0($t4)
  	beqz $t5,while_concat1
  	addi $t4,$t4,1
  	addi $v0,$v0,1
  	j while_last1
  	
  while_concat1:
  	beqz $v0,end_concat1 # if(count == 0) break;
  	lb $t5,-1($t4)
  	sb $t5,0($t4) # s[i] = s[i-1];
  	
  	subi $v0,$v0,1 # count--;
  	subi $t4,$t4,1
  	j while_concat1
  	
  end_concat1:
  	sb $t3,ans_tmp
	j next_while_add1
#################################################################

########################## update base ##########################
update_base:
	
  	#get base len:
  	strlen_base2:
		li $t1,0
		la $v1,base
  	loop_strlen_base2:
		lb $t3,0($v1)
		beqz $t3,end_loop_strlen_base2
		addi $v1,$v1,1
		addi $t1,$t1,1
		j loop_strlen_base2
  	end_loop_strlen_base2:
  	
  		addi $t0,$t1,0 # same length
  	
string_add2:
	la $a0,base # s1
	la $a1,base # s2
	li $t2,0 # char = 0;
	
	subi $t0,$t0,1 # len1 = len(s1) - 1;
	subi $t1,$t1,1 # leb2 = len(s2) - 1;
	
	add $a0,$a0,$t0 # s1[n-1]
	add $a1,$a1,$t1 # s2[n-1]
	
  while_add2:
  	addi $t3,$t2,0 # v = char;
  	condi12:
  	bltz $t0,condi22 # if(len1 < 0) check condi22;
  	lb $v0,0($a0)
  	add $t3,$t3,$v0
  	subi $t3,$t3,48 # v += s1[len1] - '0';
  	
  	condi22:
  	bltz $t1,condi32 # if(len2 < 0) check condi32;
  	lb $v0,0($a1)
  	add $t3,$t3,$v0
  	subi $t3,$t3,48 # v += s2[len2] - '0';
  	
  	j do_last2 # ans = (v%10 + 48) <-concat-> ans;
  	
  	condi32:
  	blez $t2,end_while_add2 # if(char < 0) break;
  	
  	do_last2:
  		li $t4,10
  		div $t3,$t4 
  		mflo $t2 # char = v/10;
  		mfhi $t3
  		addi $t3,$t3,48
  		j concat2
  next_while_add2:
  	subi $t0,$t0,1	# len1--;
  	subi $t1,$t1,1	# len2--;
  	subi $a0,$a0,1 # step back string s1
  	subi $a1,$a1,1 # step back string s2
  	j while_add2
  	
  end_while_add2:
  #clear base_tmp:
  	la $v0,base_tmp
  	la $v1,base
  	while_not_null_2:
  		lb $t0,0($v0)
  		beqz $t0,end_while_not_null_2
  		sb $t0,0($v1) # base[i] = base_tmp[i];
  		
  		li $t0,0
  		sb $t0,0($v0) # clear base_tmp[i];
  		
  		addi $v0,$v0,1
  		addi $v1,$v1,1
  		j while_not_null_2
  		
  	end_while_not_null_2:
	j after_update_base 
########concat2###########
concat2:
	li $v0,0
	la $t4,base_tmp
  while_last2:
  	lb $t5,0($t4)
  	beqz $t5,while_concat2
  	addi $t4,$t4,1
  	addi $v0,$v0,1
  	j while_last2
  	
  while_concat2:
  	beqz $v0,end_concat2 # if(count == 0) break;
  	lb $t5,-1($t4)
  	sb $t5,0($t4) # s[i] = s[i-1];
  	
  	subi $v0,$v0,1 # count++;
  	subi $t4,$t4,1
  	j while_concat2
  	
  end_concat2:
  	sb $t3,base_tmp
	j next_while_add2
#######################################################
### in decimal ###
decimal_out:
  #Xuat ket qua phep nhan
	la $a0,str_kq_dec
	li $v0,4
	syscall 
	#Xuat dau neu am
	lw $a0,dau
	beqz $a0,Xuat_tp
	li $v0,11
	addi $a0,$zero,'-'
	syscall 
  Xuat_tp:
	#Xuat decimal
   	la $a0,ans
	li $v0,4
	syscall
	# xuong dong
	addi	$a0,$zero,'\n'
	addi	$v0,$zero,11
	syscall
  #Return
  	jr $ra
# Ket thuc chuong trinh (syscall)
Kthuc:	
	addiu	$v0,$zero,10
	syscall
#-----------------------------------
