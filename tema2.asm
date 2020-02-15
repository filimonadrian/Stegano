%include "include/io.inc"

extern atoi
extern printf
extern exit

; Functions to read/free/print the image.
; The image is passed in argv[1].
extern read_image
extern free_image
; void print_image(int* image, int width, int height);
extern print_image

; Get image's width and height.
; Store them in img_[width, height] variables.
extern get_image_width
extern get_image_height

section .data
	use_str db "Use with ./tema2 <task_num> [opt_arg1] [opt_arg2]", 10, 0
    cuvant: dd 'r', 'e', 'v', 'i', 'e', 'n', 't'
section .bss
    task:       resd 1
    img:        resd 1
    img_width:  resd 1
    img_height: resd 1

section .text

;====================================Task1=====================================
find_word_in_message:
    
    push ebp
    mov ebp, esp    
    
    ;pun in ebx adresa primului element de pe linie
    mov ebx, eax  
  
    xor eax, eax
    xor ecx, ecx
   
    ;lungimea sirului meu e data de lungimea liniei
    ;o pun pe stiva
    ;ebp - 4 -->lungime sir
    mov dword eax, [img_width]
    mov ecx, 4
    mul ecx
    push eax
    
    xor eax, eax
    xor ecx, ecx
    
    ;cuvantul pe care il caut 
    ;ebp - 8 -->lungime subsir - 1
    mov ecx, 6
    push ecx
    
    ;scad lungimea subsirului din lungimea sirului
    mov eax, [ebp - 8]
    sub [ebp - 4], eax
 
    xor eax, eax
   
   ;eax se incrementeaza pentru a accesa fiecare caracter
   ;din mesajul dat ca parametru
   ;edx este folosit pentru a testa daca toate celelalte litere sunt identice
find_word:
   
    cmp eax, [ebp - 4]
    jg return    
     
    ;ecx are lungimea subsirului
    mov ecx, [ebp - 8]
    xor edx, edx
    
    lea esi, [ebx + eax]
    mov edi, cuvant
    
    ;daca se face match 
    ;trec la urmatorul caracter si din cuvant, si din mesaj
    ;adica incrementez edx
match_character:
    lea esi, [ebx + eax]
    mov edi, cuvant    
    add esi, edx
    add edi, edx
    mov esi, [esi]
    mov edi, [edi]

    cmp esi, edi   
    je increments
    jne no_match
    
increments:
    cmp ecx, 0
    je exist
    add edx, 4
    dec ecx
    jmp match_character    
    
    ;daca gasesc neptrivire trec la urmatoarea litera din mesaj
no_match:
    add eax, 4
    jmp find_word

exist:
    xor edx, edx
    mov edx, 1
        
return:
    leave
    ret    

print_task1:

mess:
        
    cmp dword [ebx], 0
    je print_key_and_row_number
    PRINT_CHAR [ebx]
    add ebx, 4
    jmp mess 
    
print_key_and_row_number:
    ;afisez cheia
    NEWLINE
    PRINT_DEC 4, eax
    NEWLINE
    ;afisez linia la care l-am gasit
    PRINT_DEC 4, ecx
    NEWLINE
    
    ret

xor_matrix:
    ;verific daca mai am elemente in vector
    cmp ecx, edi
    je stop_xor
    ;iau valoarea din vector
    mov edx, [ebx + 4 * ecx]    
    ;aplic xor
    xor edx, eax
    ;pun valoarea in vector
    mov [ebx + 4 * ecx], edx
    inc ecx
    jmp xor_matrix
    
stop_xor:
    ret

task_1_rez:
    push ebp
    mov ebp, esp
   
    ;edi va contine numarul de elemente din vector
    mov eax, [img_width]
    mul dword [img_height]
    push eax
    mov edi, eax
    
    mov ebx, [img]
    xor ecx, ecx
    xor eax, eax
    ;deoarece trebuie sa verific si pentru cheia 0
    ;inainte de primul xor incrementez esi
    mov esi, -1    

another_key:
    mov ebx, [img]
    xor ecx, ecx
    inc esi
    mov eax, esi
    
    call xor_matrix

search:
    xor ecx, ecx
    
;aici matricea contine valorile xorate cu cheia   
find_word_in_matrix:

    push ebx
    push ecx
    push edi
    push esi
    
    ;pun in eax adresa fiecarei linii din matrice
    mov eax, [img_width]
    mov edx, 4
    mul edx
    
    mul ecx
    mov edx, eax
    lea eax, [ebx + edx]
    xor edx, edx
    call find_word_in_message

    pop esi
    pop edi
    pop ecx
    pop ebx
    
    cmp edx, 1
    ;daca edx este 1 am gasit mesajul, deci si cheia
    je exit_task_1
    
    inc ecx
    cmp ecx, [img_height]
    jl find_word_in_matrix
    
    xor ecx, ecx
    
    ;xorez matricea pentru a o obtine pe cea originala
    ;verific daca mai am elemente in vector
    mov ebx, [img]
    xor ecx, ecx
    mov eax, esi

    call xor_matrix
    jmp another_key

exit_task_1:
    ;pun in eax cheia
    mov eax, esi
    leave
    ret

;====================================Task2=====================================

new_key:
    xor edx, edx
    mov ebx, 2
    mul ebx
    add eax, 3
    mov ebx, 5
    div ebx
    sub eax, 4

    ret

put_message_in_matrix:  
    mov dword [eax], 'C'
    ;acesta este apostroful
    mov dword [eax + 4], 39
    mov dword [eax + 8], 'e'
    mov dword [eax + 12], 's'
    mov dword [eax + 16], 't'  
    mov dword [eax + 20], ' '
    mov dword [eax + 24], 'u'
    mov dword [eax + 28], 'n'
    mov dword [eax + 32], ' '
    mov dword [eax + 36], 'p'
    mov dword [eax + 40], 'r'
    mov dword [eax + 44], 'o'
    mov dword [eax + 48], 'v'
    mov dword [eax + 52], 'e'
    mov dword [eax + 56], 'r'
    mov dword [eax + 60], 'b'
    mov dword [eax + 64], 'e'
    mov dword [eax + 68], ' '
    mov dword [eax + 72], 'f'
    mov dword [eax + 76], 'r'
    mov dword [eax + 80], 'a'
    mov dword [eax + 84], 'n'
    mov dword [eax + 88], 'c'
    mov dword [eax + 92], 'a'
    mov dword [eax + 96], 'i'
    mov dword [eax + 100], 's'
    mov dword [eax + 104], '.'
    mov dword [eax + 108], 0

    ret

;====================================Task3=====================================

morse_encrypt:
    
    ;eax contine adresa primului caracter din sir 
    ;esi continte byte-ul la care ar trebui sa merg in matrice
    ;ebx contine adresa primului element din imagine
    add ebx, esi
    xor ecx, ecx

encode:
    cmp byte [eax], 'A'
    je A_LETTER
    cmp byte [eax], 'B'
    je B_LETTER
    cmp byte [eax], 'C'
    je C_LETTER
    cmp byte [eax], 'D'
    je D_LETTER
    cmp byte [eax], 'E'
    je E_LETTER
    cmp byte [eax], 'F'
    je F_LETTER
    cmp byte [eax], 'G'
    je G_LETTER
    cmp byte [eax], 'H'
    je H_LETTER
    cmp byte [eax], 'I'
    je I_LETTER
    cmp byte [eax], 'J'
    je J_LETTER
    cmp byte [eax], 'K'
    je K_LETTER
    cmp byte [eax], 'L'
    je L_LETTER
    cmp byte [eax], 'M'
    je M_LETTER
    cmp byte [eax], 'N'
    je N_LETTER
    cmp byte [eax], 'O'
    je O_LETTER
    cmp byte [eax], 'P'
    je P_LETTER
    cmp byte [eax], 'Q'
    je Q_LETTER
    cmp byte [eax], 'R'
    je R_LETTER
    cmp byte [eax], 'S'
    je S_LETTER
    cmp byte [eax], 'T'
    je T_LETTER
    cmp byte [eax], 'U'
    je U_LETTER
    cmp byte [eax], 'V'
    je V_LETTER
    cmp byte [eax], 'W'
    je W_LETTER
    cmp byte [eax], 'X'
    je X_LETTER
    cmp byte [eax], 'Y'
    je Y_LETTER
    cmp byte [eax], 'Z'
    je Z_LETTER

    cmp byte [eax], '1'
    je NUMBER_1
    cmp byte [eax], '2'
    je NUMBER_2
    cmp byte [eax], '3'
    je NUMBER_3
    cmp byte [eax], '4'
    je NUMBER_4
    cmp byte [eax], '5'
    je NUMBER_5
    cmp byte [eax], '6'
    je NUMBER_6
    cmp byte [eax], '7'
    je NUMBER_7
    cmp byte [eax], '8'
    je NUMBER_8
    cmp byte [eax], '9'
    je NUMBER_9
    cmp byte [eax], '0'
    je NUMBER_0
    cmp byte [eax], ' '
    je SPACE

    cmp byte [eax], ','
    je COMMA


    cmp byte [eax], 0
    je exit_morse_encode



A_LETTER:
    mov dword [ebx + 4 * ecx], '.'
    inc ecx
    mov dword [ebx + 4 * ecx], '-'
    inc ecx
    mov dword [ebx + 4 * ecx], ' '
    jmp cond
B_LETTER:
    mov dword [ebx + 4 * ecx], '-'
    inc ecx
    mov dword [ebx + 4 * ecx], '.'
    inc ecx
    mov dword [ebx + 4 * ecx], '.'
    inc ecx
    mov dword [ebx + 4 * ecx], '.'
    inc ecx
    mov dword [ebx + 4 * ecx], ' '
    jmp cond
C_LETTER:
    mov dword [ebx + 4 * ecx], '-'
    inc ecx
    mov dword [ebx + 4 * ecx], '.'
    inc ecx
    mov dword [ebx + 4 * ecx], '-'
    inc ecx
    mov dword [ebx + 4 * ecx], '.'
    inc ecx
    mov dword [ebx + 4 * ecx], ' '
    jmp cond
D_LETTER:
    mov dword [ebx + 4 * ecx], '-'
    inc ecx
    mov dword [ebx + 4 * ecx], '.'
    inc ecx
    mov dword [ebx + 4 * ecx], '.'
    inc ecx
    mov dword [ebx + 4 * ecx], ' '
    jmp cond
E_LETTER:
    mov dword [ebx + 4 * ecx], '.'
    inc ecx
    mov dword [ebx + 4 * ecx], ' '
    jmp cond
F_LETTER:
    mov dword [ebx + 4 * ecx], '.'
    inc ecx
    mov dword [ebx + 4 * ecx], '.'
    inc ecx
    mov dword [ebx + 4 * ecx], '-'
    inc ecx
    mov dword [ebx + 4 * ecx], '.'
    inc ecx
    mov dword [ebx + 4 * ecx], ' '
    jmp cond
G_LETTER:
    mov dword [ebx + 4 * ecx], '-'
    inc ecx
    mov dword [ebx + 4 * ecx], '-'
    inc ecx
    mov dword [ebx + 4 * ecx], '.'
    inc ecx
    mov dword [ebx + 4 * ecx], ' '
    jmp cond
H_LETTER:
    mov dword [ebx + 4 * ecx], '.'
    inc ecx
    mov dword [ebx + 4 * ecx], '.'
    inc ecx
    mov dword [ebx + 4 * ecx], '.'
    inc ecx
    mov dword [ebx + 4 * ecx], '.'
    inc ecx
    mov dword [ebx + 4 * ecx], ' '
    jmp cond
I_LETTER:
    mov dword [ebx + 4 * ecx], '.'
    inc ecx
    mov dword [ebx + 4 * ecx], '.'
    inc ecx
    mov dword [ebx + 4 * ecx], ' '
    jmp cond
J_LETTER:
    mov dword [ebx + 4 * ecx], '.'
    inc ecx
    mov dword [ebx + 4 * ecx], '-'
    inc ecx
    mov dword [ebx + 4 * ecx], '-'
    inc ecx
    mov dword [ebx + 4 * ecx], '-'
    inc ecx
    mov dword [ebx + 4 * ecx], ' '
    jmp cond
K_LETTER:
    mov dword [ebx + 4 * ecx], '-'
    inc ecx
    mov dword [ebx + 4 * ecx], '.'
    inc ecx
    mov dword [ebx + 4 * ecx], '-'
    inc ecx
    mov dword [ebx + 4 * ecx], ' '
    jmp cond
L_LETTER:
    mov dword [ebx + 4 * ecx], '.'
    inc ecx
    mov dword [ebx + 4 * ecx], '-'
    inc ecx
    mov dword [ebx + 4 * ecx], '.'
    inc ecx
    mov dword [ebx + 4 * ecx], '.'
    inc ecx
    mov dword [ebx + 4 * ecx], ' '
    jmp cond
M_LETTER:
    mov dword [ebx + 4 * ecx], '-'
    inc ecx
    mov dword [ebx + 4 * ecx], '-'
    inc ecx
    mov dword [ebx + 4 * ecx], ' '
    jmp cond
N_LETTER:
    mov dword [ebx + 4 * ecx], '-'
    inc ecx
    mov dword [ebx + 4 * ecx], '.'
    inc ecx
    mov dword [ebx + 4 * ecx], ' '
    jmp cond
O_LETTER:
    mov dword [ebx + 4 * ecx], '-'
    inc ecx
    mov dword [ebx + 4 * ecx], '-'
    inc ecx
    mov dword [ebx + 4 * ecx], '-'
    inc ecx
    mov dword [ebx + 4 * ecx], ' '
    jmp cond
P_LETTER:
    mov dword [ebx + 4 * ecx], '.'
    inc ecx
    mov dword [ebx + 4 * ecx], '-'
    inc ecx
    mov dword [ebx + 4 * ecx], '-'
    inc ecx
    mov dword [ebx + 4 * ecx], '.'
    inc ecx
    mov dword [ebx + 4 * ecx], ' '
    jmp cond
Q_LETTER:
    mov dword [ebx + 4 * ecx], '-'
    inc ecx
    mov dword [ebx + 4 * ecx], '-'
    inc ecx
    mov dword [ebx + 4 * ecx], '.'
    inc ecx
    mov dword [ebx + 4 * ecx], '-'
    inc ecx
    mov dword [ebx + 4 * ecx], ' '
    jmp cond
R_LETTER:
    mov dword [ebx + 4 * ecx], '.'
    inc ecx
    mov dword [ebx + 4 * ecx], '-'
    inc ecx
    mov dword [ebx + 4 * ecx], '.'
    inc ecx
    mov dword [ebx + 4 * ecx], ' '
    jmp cond
S_LETTER:
    mov dword [ebx + 4 * ecx], '.'
    inc ecx
    mov dword [ebx + 4 * ecx], '.'
    inc ecx
    mov dword [ebx + 4 * ecx], '.'
    inc ecx
    mov dword [ebx + 4 * ecx], ' '
    jmp cond
T_LETTER:
    mov dword [ebx + 4 * ecx], '-'
    inc ecx
    mov dword [ebx + 4 * ecx], ' '
    jmp cond
U_LETTER:
    mov dword [ebx + 4 * ecx], '.'
    inc ecx
    mov dword [ebx + 4 * ecx], '.'
    inc ecx
    mov dword [ebx + 4 * ecx], '-'
    inc ecx
    mov dword [ebx + 4 * ecx], ' '
    jmp cond
V_LETTER:
    mov dword [ebx + 4 * ecx], '.'
    inc ecx
    mov dword [ebx + 4 * ecx], '.'
    inc ecx
    mov dword [ebx + 4 * ecx], '.'
    inc ecx
    mov dword [ebx + 4 * ecx], '-'
    inc ecx
    mov dword [ebx + 4 * ecx], ' '
    jmp cond
W_LETTER:
    mov dword [ebx + 4 * ecx], '.'
    inc ecx
    mov dword [ebx + 4 * ecx], '-'
    inc ecx
    mov dword [ebx + 4 * ecx], '-'
    inc ecx
    mov dword [ebx + 4 * ecx], ' '
    jmp cond
X_LETTER:
    mov dword [ebx + 4 * ecx], '-'
    inc ecx
    mov dword [ebx + 4 * ecx], '.'
    inc ecx
    mov dword [ebx + 4 * ecx], '.'
    inc ecx
    mov dword [ebx + 4 * ecx], '-'
    inc ecx
    mov dword [ebx + 4 * ecx], ' '
    jmp cond
Y_LETTER:
    mov dword [ebx + 4 * ecx], '-'
    inc ecx
    mov dword [ebx + 4 * ecx], '.'
    inc ecx
    mov dword [ebx + 4 * ecx], '-'
    inc ecx
    mov dword [ebx + 4 * ecx], '-'
    inc ecx
    mov dword [ebx + 4 * ecx], ' '
    jmp cond
Z_LETTER:
    mov dword [ebx + 4 * ecx], '-'
    inc ecx
    mov dword [ebx + 4 * ecx], '-'
    inc ecx
    mov dword [ebx + 4 * ecx], '.'
    inc ecx
    mov dword [ebx + 4 * ecx], '.'
    inc ecx
    mov dword [ebx + 4 * ecx], ' '
    jmp cond

NUMBER_1:
    mov dword [ebx + 4 * ecx], '.'
    inc ecx
    mov dword [ebx + 4 * ecx], '-'
    inc ecx
    mov dword [ebx + 4 * ecx], '-'
    inc ecx
    mov dword [ebx + 4 * ecx], '-'
    inc ecx
    mov dword [ebx + 4 * ecx], '-'
    inc ecx
    mov dword [ebx + 4 * ecx], ' '
    jmp cond
NUMBER_2:
    mov dword [ebx + 4 * ecx], '.'
    inc ecx
    mov dword [ebx + 4 * ecx], '.'
    inc ecx
    mov dword [ebx + 4 * ecx], '-'
    inc ecx
    mov dword [ebx + 4 * ecx], '-'
    inc ecx
    mov dword [ebx + 4 * ecx], '-'
    inc ecx
    mov dword [ebx + 4 * ecx], ' '
    jmp cond
NUMBER_3:
    mov dword [ebx + 4 * ecx], '.'
    inc ecx
    mov dword [ebx + 4 * ecx], '.'
    inc ecx
    mov dword [ebx + 4 * ecx], '.'
    inc ecx
    mov dword [ebx + 4 * ecx], '-'
    inc ecx
    mov dword [ebx + 4 * ecx], '-'
    inc ecx
    mov dword [ebx + 4 * ecx], ' '
    jmp cond
NUMBER_4:
    mov dword [ebx + 4 * ecx], '.'
    inc ecx
    mov dword [ebx + 4 * ecx], '.'
    inc ecx
    mov dword [ebx + 4 * ecx], '.'
    inc ecx
    mov dword [ebx + 4 * ecx], '.'
    inc ecx
    mov dword [ebx + 4 * ecx], '-'
    inc ecx
    mov dword [ebx + 4 * ecx], ' '
    jmp cond
NUMBER_5:
    mov dword [ebx + 4 * ecx], '.'
    inc ecx
    mov dword [ebx + 4 * ecx], '.'
    inc ecx
    mov dword [ebx + 4 * ecx], '.'
    inc ecx
    mov dword [ebx + 4 * ecx], '.'
    inc ecx
    mov dword [ebx + 4 * ecx], '.'
    inc ecx
    mov dword [ebx + 4 * ecx], ' '
    jmp cond
NUMBER_6:
    mov dword [ebx + 4 * ecx], '-'
    inc ecx
    mov dword [ebx + 4 * ecx], '.'
    inc ecx
    mov dword [ebx + 4 * ecx], '.'
    inc ecx
    mov dword [ebx + 4 * ecx], '.'
    inc ecx
    mov dword [ebx + 4 * ecx], '.'
    inc ecx
    mov dword [ebx + 4 * ecx], ' '
    jmp cond
NUMBER_7:
    mov dword [ebx + 4 * ecx], '-'
    inc ecx
    mov dword [ebx + 4 * ecx], '-'
    inc ecx
    mov dword [ebx + 4 * ecx], '.'
    inc ecx
    mov dword [ebx + 4 * ecx], '.'
    inc ecx
    mov dword [ebx + 4 * ecx], '.'
    inc ecx
    mov dword [ebx + 4 * ecx], ' '
    jmp cond
NUMBER_8:
    mov dword [ebx + 4 * ecx], '-'
    inc ecx
    mov dword [ebx + 4 * ecx], '-'
    inc ecx
    mov dword [ebx + 4 * ecx], '-'
    inc ecx
    mov dword [ebx + 4 * ecx], '.'
    inc ecx
    mov dword [ebx + 4 * ecx], '.'
    inc ecx
    mov dword [ebx + 4 * ecx], ' '
    jmp cond
NUMBER_9:
    mov dword [ebx + 4 * ecx], '-'
    inc ecx
    mov dword [ebx + 4 * ecx], '-'
    inc ecx
    mov dword [ebx + 4 * ecx], '-'
    inc ecx
    mov dword [ebx + 4 * ecx], '-'
    inc ecx
    mov dword [ebx + 4 * ecx], '.'
    inc ecx
    mov dword [ebx + 4 * ecx], ' '
    jmp cond
NUMBER_0:
    mov dword [ebx + 4 * ecx], '-'
    inc ecx
    mov dword [ebx + 4 * ecx], '-'
    inc ecx
    mov dword [ebx + 4 * ecx], '-'
    inc ecx
    mov dword [ebx + 4 * ecx], '-'
    inc ecx
    mov dword [ebx + 4 * ecx], '-'
    inc ecx
    mov dword [ebx + 4 * ecx], ' '
    jmp cond 

COMMA:
    mov dword [ebx + 4 * ecx], '-'
    inc ecx
    mov dword [ebx + 4 * ecx], '-'
    inc ecx
    mov dword [ebx + 4 * ecx], '.'
    inc ecx
    mov dword [ebx + 4 * ecx], '.'
    inc ecx
    mov dword [ebx + 4 * ecx], '-'
    inc ecx
    mov dword [ebx + 4 * ecx], '-'
    inc ecx
    mov dword [ebx + 4 * ecx], ' '
    jmp cond
SPACE:
    mov dword [ebx + 4 * ecx], '|'
    inc ecx
    mov dword [ebx + 4 * ecx], ' '

cond:
    inc ecx
    inc eax
    jmp encode

exit_morse_encode:
    dec ecx
    mov dword [ebx + 4 * ecx], 0
    ret

;====================================Task4=====================================

lsb_encrypt:
    ;eax contine adresa primului caracter din sir 
    ;esi continte octetul la care ar trebui sa merg in matrice
    ;ebx contine adresa primului element din imagine
    ;edi o sa fie, pe rand, fiecare bit de la 0 la 7
    add ebx, esi
    mov edx, eax
    xor edx, edx
    xor ecx, ecx
    inc ecx
    ;setez pentru edi bitul cel mai semnificativ pe 1
    ;pentru primul octet
    mov edi, 128
    
encode_lsb:
    ;ma asigur ca fac ultimul bit 0
    shr dword [ebx], 1
    shl dword [ebx], 1
    ;daca bitul respectiv din litera respectiva este 1
    ;adaug 1 si sar la incrementari, altfel sar direct
    test [eax], edi
    jz lsb_encode_cond
    
    inc dword [ebx]

lsb_encode_cond:
    ;merg la urmatorul pixel din matrice
    add ebx, 4
    ;shit pentru a testa urmatorul bit
    shr edi, 1
    ;daca edi este 0 insemna ca trebuie sa trec la urmatoarea litera
    cmp edi, 0
    je next_byte
stop_cond:
    ;daca am ajuns la \0 inseamna ca trebuie sa fac lsb 0
    ;pentru inca 8 pixeli si apoi sa ma opresc
    cmp byte [eax], 0
    jne encode_lsb
    je backslash0_case

next_byte:
    mov edi, 128
    inc eax
    jmp stop_cond

    ;pentru acesti 8 ultimi pixeli verificarea se face separat
backslash0_case:
    mov ecx, 8
shift_for_backslash0:
    shr dword [ebx], 1
    shl dword [ebx], 1
    add ebx, 4
    dec ecx
    cmp ecx, 0
    jnz shift_for_backslash0

    ret

;====================================Task5=====================================

lsb_decrypt:
    add ebx, esi
    mov edi, 1
    xor ecx, ecx
    xor edx, edx
    ;in eax voi retine octetul
    xor eax, eax

decode_lsb:
    shl eax, 1
    test [ebx], edi
    jz lsb_decode_cond

    inc eax  

lsb_decode_cond:
    ;incrementez numarul de pixeli testati
    inc ecx
    ;merg la urmatorul pixel din matrice
    add ebx, 4
    ;daca am testat 8 pixeli inseamna ca eax contine deja o litera
    cmp ecx, 8
    je print_decrypted_message
    jmp decode_lsb

    ;scrie litera descoperita
print_decrypted_message:
    cmp eax, 0
    je exit_decrypt
    PRINT_CHAR eax
    xor eax, eax
    xor ecx, ecx
    jmp decode_lsb

exit_decrypt:
    ret

;===================================General====================================

read_arg3_arg4:

    mov ebx, [ebp + 12]
    mov ebx, [ebx + 16]
    mov eax, 0
    push ebx
    call atoi
    add esp, 4
    ;esi contine offsetul
    mov ecx, 4
    mul ecx
    mov esi, eax

    ;eax contine adresa mesajului
    mov ebx, [ebp + 12]
    mov ebx, [ebx + 12]
    mov eax, ebx
    mov ebx, [img]

    ret

print_matrix:

    push dword [img_height]
    push dword [img_width]
    push dword [img]
    call print_image 
    add esp, 12
    
    ret 

global main
main:
    mov ebp, esp; for correct debugging
    ; Prologue
    ; Do not modify!
    push ebp
    mov ebp, esp

    mov eax, [ebp + 8]
    cmp eax, 1
    jne not_zero_param

    push use_str
    call printf
    add esp, 4

    push -1
    call exit

not_zero_param:
    ; We read the image. You can thank us later! :)
    ; You have it stored at img variable's address.
    mov eax, [ebp + 12]
    push DWORD[eax + 4]
    call read_image
    add esp, 4
    mov [img], eax

    ; We saved the image's dimensions in the variables below.
    call get_image_width
    mov [img_width], eax

    call get_image_height
    mov [img_height], eax

    ; Let's get the task number. It will be stored at task variable's address.
    mov eax, [ebp + 12]
    push DWORD[eax + 8]
    call atoi
    add esp, 4
    mov [task], eax

    ; There you go! Have fun! :
    mov eax, [task]
    cmp eax, 1
    je solve_task1
    cmp eax, 2
    je solve_task2
    cmp eax, 3
    je solve_task3
    cmp eax, 4
    je solve_task4
    cmp eax, 5
    je solve_task5
    cmp eax, 6
    je solve_task6
    jmp done

solve_task1:

    call task_1_rez
    mov edi, eax

print_message:
    mov eax, ecx
    mul dword [img_width]
    mov edx, 4
    mul edx
    mov ebx, [img]
    add ebx, eax          
    mov eax, edi
 
    call print_task1
    
    jmp done
    
solve_task2:
    
    ;matricea este deja xorata cu cheia gasita
    ;cheia este in eax
    ;linia este in ecx
    call task_1_rez

    ;modific eax pentru a creea noua cheie
    call new_key
    ;esi are noua cheie
    mov esi, eax
    
    ;merg la "linia pe care am gasit-o" + 1 si suprascriu mesajul
    mov ebx, [img]
    mov eax, [img_width]
    mov edx, 4
    mul edx
    inc ecx
    mul ecx
    mov edi, eax
    lea eax, [ebx + edi]

    call put_message_in_matrix
    
    ;xorex din nou totul cu noua cheie
    xor ecx, ecx
    mov ebx, [img]
    mov eax, [img_width]
    mul dword [img_height]
    ;edi contine numarul de elemente
    mov edi, eax
    mov eax, esi
    
    call xor_matrix  
    call print_matrix  
    
    jmp done

solve_task3:

    call read_arg3_arg4
    call morse_encrypt
    call print_matrix

    jmp done

solve_task4:

    call read_arg3_arg4
    ;scad 4 din offset pentru ca trebuie sa modific
    ;al "esi-lea" element, nu elementul cu indexul esi
    sub esi, 4

    call lsb_encrypt
    call print_matrix


    jmp done
solve_task5:

    mov ebx, [ebp + 12]
    mov ebx, [ebx + 12]
    mov eax, 0
    push ebx
    call atoi
    add esp, 4
    ;esi contine offsetul
    dec eax
    mov ecx, 4
    mul ecx
    mov esi, eax
    mov ebx, [img]

    call lsb_decrypt

    jmp done


solve_task6:
    ; TODO Task6
    mov ebx, [img]

    ;parcurg matricea invers
    ;plec de la penultimul element al penultimei coloane 
    ;ajung la al doilea element de pe a doua coloana
    mov eax, [img_width]
    mov ecx, [img_height]
    mul ecx
    ;scad ultima linie din dimensiunea totala
    sub eax, [img_width]
    mov esi, eax
    ;salvez dimensiunea pe stiva
    push esi
    
    ;acum [ebx + esi] este primul element de pe ultima linie
    ;scad 2 ca sa ajung la penultima linie, penultimul element
    sub esi, 2
    
    mov ecx, esi
    mov edx, [img_width]
    sub edx, 2
    mov edi, 0
        

    ;edi va fi "la al catelea element pe linie sunt?"
    ;esi contine dimensiunea matricei
    ;parcurg de la coada la cap
calculate_blur_elements:
    
    ;verific daca am ajuns pe prima linie
    cmp ecx, [img_width]
    jle continue
   
    cmp edi, edx
    je next_line_inverse_scroll

    mov eax, [ebx + 4 * ecx]
    add eax, [ebx + 4 * ecx - 4]
    add eax, [ebx + 4 * ecx + 4]
    ;merg la elementul de deasupra
    sub ecx, [img_width]
    add eax, [ebx + 4 * ecx]
    ;revin la actualul
    add ecx, [img_width]
    ;merg la cel de sub el
    add ecx, [img_width]
    add eax, [ebx + 4 * ecx]
    ;revin
    sub ecx, [img_width]

    push edx
    push ecx

    ;calculez elementul
    xor edx, edx
    mov ecx, 5
    div ecx

    pop ecx
    pop edx
    ;pun elementul calculat pe stiva
    push eax
    
    dec ecx
    inc edi
    
    jmp calculate_blur_elements

next_line_inverse_scroll:
    mov edi, 0
    ;scad din ecx 2
    ;pentru ca trebuie sa sar prima coloana
    ;apoi o sar pe ultima si ajung la penultima 
    sub ecx, 2
    cmp ecx, [img_width]
    jle continue
    jmp calculate_blur_elements

continue:
    mov esi, [ebp - 4]
    sub esi, 1

    ;incep iterarea de la al doilea element de pe a doua linie
    ;img + img_width ma duce pe primul element de pe a doua linie
    ;de aceea incrementez
    mov ecx, [img_width]
    inc ecx
    ;iterez fara sa consider primul si ultimul element
    ;de pe linie
    mov edx, [img_width]
    sub edx, 2
    mov edi, 0


put_blurred_element_in_matrix:
    ;verific daca mai am elemente in matrice
    cmp ecx, esi
    je print_blurred_matrix
   
    cmp edi, edx
    je next_line

    ;scot de pe stiva elementul calculat
    ;il pun in matrice
    pop eax
    mov [ebx + 4 * ecx], eax
    
    inc ecx
    inc edi
    
    jmp put_blurred_element_in_matrix

next_line:
    mov edi, 0
    ;pentru ca trebuie sa sar prima coloana
    ;apoi o sar pe ultima si ajung la penultima 
    add ecx, 2
    jmp put_blurred_element_in_matrix

    ;scot din matrice valoarea pusa mai sus in esi
    ;pentru a retine dimensiunea 
    pop eax

print_blurred_matrix:
    call print_matrix

    ; Free the memory allocated for the image.
done:
 
    push DWORD[img]
    call free_image
    add esp, 4

    ; Epilogue
    ; Do not modify!
    xor eax, eax

    leave
    ret