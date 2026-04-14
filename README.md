[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-22041afd0340ce965d47ae6ef1cefeee28c7c493a6346c4f15d667ab976d596c.svg)](https://classroom.github.com/a/d5nOy1eX)



### q3 
#### a:
i just pushed all the strings in target into a text file, found the you have passed string
i saw that there was %63s just above it and aa sstring there so i just tried it and it worked.

#### b:
i used gdb then used the command ni and display/i $pc that showed all the riscv commands(in sequence one by one) and saw the command bnez a0,fail
ie if a0!=NULL then fail
ie i somehow have to set a0=NULL
i tried empty file but it failed
the buffer for password was 208 bytes which i filled up with a
s0 was 8 bytes which i also filled up with a
I then ooverwrite ra with the address to pass
so it fails executes fail but when trying to return it goes to pass 
there it prints the pass condition
then because our reference point to the stack s0 is now garbage we have a segmentation fault occur



### q5
note that it cant handle spaces at end(idk why u would do that since we are looking for palindrome which is just one word that is same in reverse as forward but disclaimer)


