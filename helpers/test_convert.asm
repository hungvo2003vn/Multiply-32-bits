.data
	num1:.asciiz "18446744073709551616"
	num2:.asciiz "9223372036854775808"
	str_phep:.asciiz " + "
	str_bang:.asciiz " = "
	ans: 	.space 30
	tmp:		.space 30
.text
	
	#Len of s1
	la $v1,num1
	jal strlen
	move $t0,$v0
	
	#Len of s2
	la $v1,num2
	jal strlen
	move $t1,$v0
	
	jal string_add
	jal Ket_qua
	j exit
strlen:
  li $v0,0
  loop_strlen:
	lb $t3,0($v1)
	beqz $t3,end_loop_strlen
	addi $v1,$v1,1
	addi $v0,$v0,1
	j loop_strlen
  end_loop_strlen:
  	jr $ra
  	
string_add:
	la $a0,num1 # s1
	la $a1,num2 # s2
	li $t2,0 # char = 0;
	
	subi $t0,$t0,1 # len1 = len(s1) - 1;
	subi $t1,$t1,1 # leb2 = len(s2) - 1;
	
	add $a0,$a0,$t0 # s1[n-1]
	add $a1,$a1,$t1 # s2[n-1]
	
  while_add:
  	addi $t3,$t2,0 # v = char;
  	condi1:
  	bltz $t0,condi2 # if(len1 < 0) check condi2;
  	lb $v0,0($a0)
  	add $t3,$t3,$v0
  	subi $t3,$t3,48 # v += s1[len1] - '0';
  	
  	condi2:
  	bltz $t1,condi3 # if(len2 < 0) check condi3;
  	lb $v0,0($a1)
  	add $t3,$t3,$v0
  	subi $t3,$t3,48 # v += s2[len2] - '0';
  	
  	j do_last # ans = (v%10 + 48) <-concat-> ans;
  	
  	condi3:
  	blez $t2,end_while_add # if(char < 0) break;
  	
  	do_last:
  		li $t4,10
  		div $t3,$t4 
  		mflo $t2 # char = v/10;
  		mfhi $t3
  		addi $t3,$t3,48
  		j concat
  next_while_add:
  	subi $t0,$t0,1	# len1--;
  	subi $t1,$t1,1	# len2--;
  	subi $a0,$a0,1 # step back string s1
  	subi $a1,$a1,1 # step back string s2
  	j while_add
  	
  end_while_add:
	jr $ra
#####################
concat:
	li $v0,0
	la $t4,ans
  while_last:
  	lb $t5,0($t4)
  	beqz $t5,while_concat
  	addi $t4,$t4,1
  	addi $v0,$v0,1
  	j while_last
  	
  while_concat:
  	beqz $v0,end_concat # if(count == 0) break;
  	lb $t5,-1($t4)
  	sb $t5,0($t4) # s[i] = s[i-1];
  	
  	subi $v0,$v0,1 # count--;
  	subi $t4,$t4,1
  	j while_concat
  	
  end_concat:
  	sb $t3,ans
	j next_while_add
	
Ket_qua:
	li $v0,4
	la $a0,num1
	syscall
	
	la $a0,str_phep
	syscall
	
	la $a0,num2
	syscall
	
	la $a0,str_bang
	syscall
	
	la $a0,ans
	syscall
	
	jr $ra
exit:
	li $v0,10
	syscall
