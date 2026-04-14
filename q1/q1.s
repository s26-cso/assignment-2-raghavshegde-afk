.text
.global make_node
.global insert
.global get
.global getAtMost

make_node:
    addi sp, sp, -32      # Allocate 32 bytes on the stack for local variables and saved registers
    sd ra, 24(sp)         # save return address
    sd a0, 16(sp)         #saving input arg onyo stack

    addi a0, zero, 24     # Set a0 to 24 (the number of bytes to allocate for the struct) 
    jal ra, malloc          #call malloc

    addi t1, a0, 0        #t1=a0 value(move pointter to t1)
    
    ld t0, 16(sp)         #puut value into  t0  from stack
    sw t0, 0(t1)          #store node value at offset 0

    addi t2, zero, 0        #t2=0(NULL)
    sd t2, 8(t1)          #store memory  address with offset 8 16
    sd t2, 16(t1)         

    addi a0, t1, 0        #move pointer to a0

    ld ra, 24(sp)         #restore ra from stack
    addi sp, sp, 32     #deallocate space from stack
    jalr zero, 0(ra)    #return


insert:
    addi sp, sp, -32    #allocate 32 bytes on stack obv
    sd ra, 24(sp)       #save return address and args
    sd a0, 16(sp)         
    sd a1, 8(sp)          
    
    beq a0, zero, in_new    #branch to in_new if a0=0(root==NULL)
    lw t0, 0(a0)          #load root val into t0
    blt a1, t0, in_left     #insert to left if a1<t0

in_right:                   #insert to right subtree
    ld t1, 16(a0)         #load root-right to t1
    addi a0, t1, 0          #move t1 to a0
    ld a1, 8(sp)          #restore val into a1
    jal ra, insert      #recursively call insert for root-> right
    ld t2, 16(sp)         #restore original root into t2
    sd a0, 16(t2)         #update root->right
    addi a0, t2, 0      #SET a0=t2
    jal zero, insert_end    #jump to end

in_left:
    ld t1, 8(a0)          
    addi a0, t1, 0
    ld a1, 8(sp)          
    jal ra, insert
    ld t2, 16(sp)         
    sd a0, 8(t2)          
    addi a0, t2, 0
    jal zero, insert_end

in_new:
    ld a0, 8(sp)          #load val from stack into a0
    jal ra, make_node   #call makenode and  come back here after( recursion)

insert_end:
    ld ra, 24(sp)  #restore ra
    addi sp, sp, 32 #deallocare stack space
    jalr zero, 0(ra) #return


get:
    addi sp, sp, -32
    sd ra, 24(sp)       #save ra for recursion
    beq a0, zero, get_null 
    lw t0, 0(a0)            #load root->value into t0
    beq t0, a1, get_found #if nide has val = get arg, then jump
    blt a1, t0, get_left    #if a1 <t0 then go leftd
    
    ld a0, 16(a0)    #a0=root->right     
    jal ra, get     #recursively call get
    jal zero, get_end #jump to end

get_left:
    ld a0, 8(a0)     #a0=root->left     
    jal ra, get
    jal zero, get_end

get_found:
    jal zero, get_end 

get_null:
    addi a0, zero, 0  #return null pointer

get_end:
    ld ra, 24(sp) #restore ra
    addi sp, sp, 32 #deallocate space and return
    jalr zero, 0(ra)


getAtMost:
    addi t0, zero, -1     #t0=-1

loop:
    beq a0, zero, end    
    lw t1, 0(a0)          # Load current node->value into t1
    blt a1, t1, go_left   #a1<t1 then go left
    addi t0, t1, 0        #t0=t1
    ld a0, 16(a0)         #move to right child
    jal zero, loop          #repeat loop

go_left:
    ld a0, 8(a0)         #move to  left child
    jal zero, loop      #repeat loop

end:
    addi a0, t0, 0  #a0=t0(best output)
    jalr zero, 0(ra) #return