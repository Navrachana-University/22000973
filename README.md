Project Title: Garhwali Compiler (Creating a compiler in your own language)
The project created by me and my project partner is made on the Garhwali language. The final output given by the code is a three address code. 
The files for the project have been uploaded. They are: garhwali.l (The Lex File), garhwali.y (The Yacc File), and program.grw (a test program file).

Steps to run the project code:
1. Download the following files and save in one folder (garhwali.l, garhwali.y, program.grw)
2. Open command prompt and type cd path\to\your\folder
3. Then run the steps 4-7 and your three address code will be generated.
4. flex garhwali.l
5. bison -d garhwali.y
6. gcc lex.yy.c garhwali.tab.c -o garhwali_compiler
7. Get-Content program.grw | ./garhwali_compiler


The File "Compiler_Design_Lab_Manual.docx" is the lab manual containing all the codes and outputs of all codes, all of which were done in Lab throughout the semester. 

Shristi Mishra - 22000793
