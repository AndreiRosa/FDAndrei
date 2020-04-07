
<h2 align="center"> 
	🚀 AnDreiF (ADF)
</h2>
<br>

### :rocket: Instructions
- To test the ALMs, Memory Bits and Fmax, use the program Quartus 18.1. 
Use the file ./fda/TOOP.vdh as your Top-Level entity and modify the constants MEM_WIDTH, MEM_HEIGHT and PROC_NUMBER in the file ./blocks_fixed/fda_package.vhd at your will.
- To test the number of cycles, use the program Model Sim. 
Use the file ./blocks_fixed/testbench/tb_toppest.vhd. In this file, you can see an example of a test using a 100x100 pixel image, with 20 ADFs. To modify it, you have to divide your image in as much ADFs as you want, and put each part of the image in a separeted .txt file, with each 16 bit pixel in a line of the .txt file. Then, you have to read each of them in a text variable in the tb_toppest. 


<h2 align="center">Have fun!</h2>


💬 Contact
------------------
[*LinkedIn*](https://www.linkedin.com/in/andreifrosa)
