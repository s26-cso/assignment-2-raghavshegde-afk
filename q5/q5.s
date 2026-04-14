.section .data
filename: .asciz "input.txt"#Nulll terminated strings
mode:     .asciz "r"
yes_msg:  .asciz "Yes\n"
no_msg:   .asciz "No\n"

.section .text
.global main

.extern fopen  #externally defined functions
.extern fseek
.extern ftell
.extern fgetc
.extern fclose
.extern printf

main:
    addi sp, sp, -48   #allocae 48 bytes on stack
    sd ra, 40(sp)       #save ra
    sd s0, 32(sp)       #save s0(start index)
    sd s1, 24(sp)       #end index
    sd s2, 16(sp)       #file ptr
    sd s3, 8(sp)        #char at start to compre to one at end

    lui a0, %hi(filename)       # Load upper 20 bits of the 'filename' string address into a0
    addi a0, a0, %lo(filename)  #load lower 12 bits into a0(a0 points to input.txt)
    lui a1, %hi(mode)
    addi a1, a1, %lo(mode)  #a1 pointd to r
    call fopen              #fopen the file pointer in a0
    addi s2, a0, 0          #save a0 in s2

    addi a0, s2, 0          #arg1:file pointer (from s2)
    addi a1, x0, 0          #arg2:offset=0
    addi a2, x0, 2          #arg3: seek_end
    call fseek

    addi a0, s2, 0          #arg1:file ptr
    call ftell

    addi s1, a0, 0          #save a0 into s1(file size)
    addi s1, s1, -1         #subtract 1 from size to get the index of the last character
    
    blt s1, x0, is_pal      #if last char index<0,is palindrome

    addi a0, s2, 0         #just to ensure that last char is not newline we seek then get char
    addi a1, s1, 0
    addi a2, x0, 0
    call fseek

    addi a0, s2, 0
    call fgetc
    
    addi t0, x0, 10         # 10=ASCII val for \n,t0=10
    bne a0, t0, setup       # If the character read (a0) is NOT a newline (10), skip to setup
    addi s1, s1, -1         # If it is a newline, decrement our end index (s1) to ignore it

setup:
    addi s0, x0, 0          # Initialize s0 (start index) to 0

loop:
    bge s0, s1, is_pal   #start index>=end index

    addi a0, s2, 0
    addi a1, s0, 0      #start index
    addi a2, x0, 0      #seek_set
    call fseek

    addi a0, s2, 0
    call fgetc

    addi s3, a0, 0

    addi a0, s2, 0
    addi a1, s1, 0      #eend index
    addi a2, x0, 0
    call fseek

    addi a0, s2, 0
    call fgetc

    bne s3, a0, not_pal   #s3!=a0

    addi s0, s0, 1      #start index +1
    addi s1, s1, -1     #end index -1
    jal x0, loop        #next loop

is_pal:
    lui a0, %hi(yes_msg)                #upper 20  bits
    addi a0, a0, %lo(yes_msg)           #lower 12 bits
    call printf                         #prints yes
    jal x0, exit                        #jump

not_pal:
    lui a0, %hi(no_msg)
    addi a0, a0, %lo(no_msg)
    call printf             #printd no

exit:
    addi a0, s2, 0
    call fclose   #close file

    addi a0, x0, 0      #set return val to 0 for main
    ld ra, 40(sp)       # resstore ra
    ld s0, 32(sp)       #s0
    ld s1, 24(sp)       #s1
    ld s2, 16(sp)       #s2
    ld s3, 8(sp)        #s3
    addi sp, sp, 48     #deallocate space on stack
    jalr x0, 0(ra)      #return