.text
.global n_grt

n_grt:
    addi sp, sp, -32   #allocate 32 bytes on stack
    sd ra, 24(sp) #save ra
    sd a0, 16(sp) #save input arrat pointer
    sd a1, 8(sp)  #save array length
    sd a2, 0(sp)    #save output array ppointer

    slli t0, a1, 2   #t0=4xa1
    addi t0, t0, 15 #t0=4xa1+15
    andi t0, t0, -16 #bitwise and to round  to nearext 16
    sub sp, sp, t0  # Subtract size from sp to dynamically allocate the temporary array!
    addi t1, sp, 0  #t1=sp points to bottom of temp stack array

    addi t2, zero, 0 #t2=0,tracks no of elems in temp array
    addi t3, a1, -1  #t3=a1-1(length -1) no of loops to run(stops when less than 0)

ng_loop:
    blt t3, zero, ng_over #if t3<0 branch

ng_while:
    beq t2, zero, ng_w_end    #end while loop if nothing in array

    addi t4, t2, -1
    slli t5, t4, 2      #to get byte offset
    add t5, t1, t5      #add offset to stack ptr
    lw t6, 0(t5)        #load val from top of stack

    slli t4, t6, 2    #Multiply current array index by 4(no of byts in int)
    add t4, a0, t4      #add to input array
    lw t4, 0(t4)        #t4=value from input array

    slli t5, t3, 2   #byte offset=t5
    add t5, a0, t5#add offset to a0
    lw t5, 0(t5)    #val of current element

    ble t4, t5, ng_pop   #t4<t5 then pop
    jal zero, ng_w_end  #jump

ng_pop:
    addi t2, t2, -1  #decrease stack sixe by 1(pop)
    jal zero, ng_while  #go back to loop to use new top

ng_w_end:
    beq t2, zero, ng_no#if stack empty jump(no greater element)

    addi t4, t2, -1#index of top of stack
    slli t5, t4, 2#x4 to get offset
    add t5, t1, t5    #address of top of stack
    lw t6, 0(t5)    #load elem index from t5 into t6
    
    slli t4, t3, 2   #get byte offset
    add t4, a2, t4  #get output arr adress
    sw t6, 0(t4)    #store next greatest elem index in t6 to t4
    jal zero, ng_push   #jump to push next elem

ng_no:
    slli t4, t3, 2   #byte offset
    add t4, a2, t4
    addi t6, zero, -1  #next greatest elem =-1 ie nonn existent
    sw t6, 0(t4)    #store -1 in output arrray

ng_push:
    slli t4, t2, 2      #stack size x 4 to get offset
    add t5, t1, t4      #next empty stack element
    sw t3, 0(t5)        #store current array index in stack
    
    addi t2, t2, 1   #stack size +1
    addi t3, t3, -1 #decrement array index
    jal zero, ng_loop

ng_over:
    slli t0, a1, 2  #length x4
    addi t0, t0, 15 #add 15vto align w end
    andi t0, t0, -16  #round to nearest 16
    add sp, sp, t0     #deallocate stack space
    
    ld ra, 24(sp)       #load return address into ra(restore ra)
    addi sp, sp, 32     #deallocate standard stack space
    jalr zero, 0(ra)