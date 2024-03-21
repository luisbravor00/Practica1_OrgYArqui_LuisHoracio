# Practica #1 (Torres de Hanoi)
# Luis Adrian Bravo Ramirez / Horacio Hernandez Garcia

#int main() {
#    int numDiscos;
#    printf("Ingrese el numero de discos: ");
#    scanf("%d", &numDiscos);
#    moverTorre(numDiscos, 'O', 'A', 'D');
#    return 0;
#}
.text
	# Definir variable para almacenar n. de discos
	addi s0, zero, 3	# numero de discos
	lui s1, 0x10010 	# declarar apuntador al arr Origen
	
	# Guardar datos en torre Origen
	addi t0, zero, 1	# variable i = t0
for:	blt s0, t0, endfor	# s0 < i (t0)
	sw t0, 0(s1)  		# Almacenar en s1 cada valor 1, 2, 3, ...
	addi s1, s1, 4		# accedemos a la siguiente posicion
	addi t0, t0, 1		# i++
	jal for
endfor: addi s1, s1, -4
	# Guardar apuntador a arr Auxiliar
	slli t0, s0, 2
	add s2, s1, t0 
	# Guardar apuntador a arr Destino
	add s3, s2, t0
	
	# Llamar a funcion de moverTorre(numDiscos, 'O', 'D', 'A');
	add a2, zero, s0	# guardamos en a2 el no. de discos
	add a3, zero, s1	# guardamos en a3 el puntero al ORIGEN
	add a4, zero, s2	# guardamos en a4 el puntero al AUX
	add a5, zero, s3	# guardamos en a5 el puntero al DESTINO
	add t4, zero, s0	# cantidad de discos en ORIGEN
	addi t5, zero, 0	# cantidad de discos en AUX
	addi t6, zero, 0	# cantidad de discos en DESTINO
 	jal moverTorre
	jal endcode
	
#int moverTorre(int altura, char origen, char intermedio, char destino) {
#    if (altura >= 1) {
#        moverTorre(altura-1,origen,destino,intermedio);
#        printf("mover disco %d de %c a %c\n", altura, origen, destino);
#        moverTorre(altura-1,intermedio, origen, destino);
#    }
#}
moverTorre: 	addi t0, zero, 1
		blt a2, t0, endmoverTorre 	# altura < 1 (a2 < t0)
		
		# PRIMERA LLAMADA RECURSIVA
		# push stack -> ra, altura-1, origen, aux, destino
		addi sp, sp, -4		# Cargamos ra
		sw ra, 0(sp)
		addi sp, sp, -4		# Cargamos altura - 1
		sw a2, 0(sp)
		addi sp, sp, -4		# Cargamos origen
		sw a3, 0(sp)		
		addi sp, sp, -4		# Cargamos destino
		sw a5, 0(sp)	
		addi sp, sp, -4		# Carganos auxiliar
		sw a4, 0(sp)
		# modificacion de argumentos
		addi a2, a2, -1
		# Cambiar valores de a3, a4 y a5
		add t1, zero, a4	# t1 = aux
		add a4, zero, a5	# aux = destino
		add a5, zero, t1	# destino = aux
		# llamada recursiva
		jal moverTorre
		# pop stack -> destino, aux, origen, altura-1, ra
		lw a4, 0(sp)		# Sacamos auxiliar
		addi sp, sp, 4
		lw a5, 0(sp)		# Sacamos destino
		addi sp, sp, 4	
		lw a3, 0(sp)		# Sacamos origen
		addi sp, sp, 4
		lw a2, 0(sp)		# Sacamos altura
		addi sp, sp, 4
		lw ra, 0(sp)		# Sacamos ra
		addi sp, sp, 4
						
		# IMPRESION
		# printf("mover disco %d de %c a %c\n", n, desde, hacia);
		add a0, zero, a2
		addi a7, zero, 1
		ecall
		addi a7, zero, 11
		addi a0, zero, 0x2D
		ecall
		add a0, zero, a3
		addi a7, zero, 34
		ecall
		addi a7, zero, 11
		addi a0, zero, 0x2D
		ecall
		add a0, zero, a5
		addi a7, zero, 34
		ecall
		addi a7, zero, 11
		addi a0, zero, 0xA
		ecall
		
		# MOVIMIENTO DE VALORES
		#calcular el offset origen
if_a3:		bne a3, s1, elseif_a3	# origen != 0x10010008
		addi t4, t4, -1		# t4 = t4 -1
		slli t1, t4, 2		# t1 = t4 * 4
		sub t1, a3, t1		# t1 = t1 - a3
		jal zero, load
elseif_a3:	bne a3, s2, else_a3	# origen != 0x10010014
		addi t5, t5, -1
		slli t1, t5, 2
		sub t1, a3, t1
		jal zero, load
else_a3:	bne a3, s3, load	# origen != 0x10010020
		addi t6, t6, -1
		slli t1, t6, 2
		sub t1, a3, t1
		jal zero, load	
		# obtener el valor del origen e igualar su posicion a cero	
load:		lw t0, 0(t1)
		sw zero, 0(t1)
		# calcular el offset destino
if_a5:		bne a5 s1, elseif_a5	# destino != 0x10010008
		slli t1, t4, 2
		sub t1, a5, t1
		addi t4, t4, 1
		jal zero, store
elseif_a5:	bne a5, s2, else_a5	# destino != 0x10010014
		slli t1, t5, 2
		sub t1, a5, t1
		addi t5, t5, 1
		jal zero, store
else_a5:	bne a5, s3, store	# destino != 0x10010020
		slli t1, t6, 2
		sub t1, a5, t1
		addi t6, t6, 1
		jal zero, store
		# almacenar el valor en el destino	
store:		sw t0, 0(t1)		
		
		# SEGUNDA LLAMADA RECURSIVA
		# push stack -> ra, altura-1, aux, origen, destino
		addi sp, sp, -4		# Cargamos ra
		sw ra, 0(sp)
		addi sp, sp, -4		# Cargamos altura - 1
		sw a2, 0(sp)
		addi sp, sp, -4		# Cargamos auxiliar
		sw a4, 0(sp)		
		addi sp, sp, -4		# Cargamos origen
		sw a3, 0(sp)
		addi sp, sp, -4		# Carganos destino
		sw a5, 0(sp)
		# modificacion de argumentos
		addi a2, a2, -1
		# Cambiar valores de a3, a4 y a5
		add t1, zero, a3	# t1 = origen
		add a3, zero, a4	# origen = aux
		add a4, zero, t1	# aux = origen
		# llamada recursiva
		jal moverTorre
		# pop stack -> destino, origen, aux, altura-1, ra
		lw a5, 0(sp)		# Sacamos destino
		addi sp, sp, 4
		lw a3, 0(sp)		# Sacamos origen
		addi sp, sp, 4
		lw a4, 0(sp)		# Sacamos aux
		addi sp, sp, 4
		lw a2, 0(sp)		# Sacamos altura
		addi sp, sp, 4
		lw ra, 0(sp)		# Sacamos ra
		addi sp, sp, 4

		jalr ra
endmoverTorre: 	jalr ra

endcode: nop
