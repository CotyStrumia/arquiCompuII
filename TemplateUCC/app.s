.globl app
app:
	//---------------- Inicialización GPIO --------------------

	mov w20, PERIPHERAL_BASE + GPIO_BASE     // Dirección de los GPIO.		
	
	// Configurar GPIO 17 como input:
	mov X21,#0
	str w21,[x20,GPIO_GPFSEL1] 		// Coloco 0 en Function Select 1 (base + 4)   	
	
	//---------------- Main code --------------------
	// X0 contiene la dirección base del framebuffer (NO MODIFICAR)
	
	mov w3, 0xF800    	// 0xF800 = ROJO	
	add x10, x0, 0		// X10 contiene la dirección base del framebuffer
loop2:
	mov x2,512         	// Tamaño en Y
loop1:
	mov x1,512         	// Tamaño en X
loop0:
	sturh w3,[x10]	   	// Setear el color del pixel N
	add x10,x10,2	   	// Siguiente pixel
	sub x1,x1,1	   		// Decrementar el contador X
	cbnz x1,loop0	   	// Si no terminó la fila, saltar
	sub x2,x2,1	   		// Decrementar el contador Y
	cbnz x2,loop1	  	// Si no es la última fila, saltar
	
	// --- Delay loop ---
	movz x11, 0x10, lsl #16
delay1: 
	sub x11,x11,#1
	cbnz x11, delay1
	// ------------------
		
	bl inputRead		// Leo el GPIO17 y lo guardo en x21
	mov w3, 0x001F    	// 0x001F = AZUL	
	add x10, x0, 0		// X10 contiene la dirección base del framebuffer
	cbz X22, loop2
	mov w3, 0x07E0    	// 0x07E0 = VERDE			
	b loop2
	

fondo:
	mov x15, 0 //inicializo el limite en x15
	mov w12, 0x20  //led verde
	mov w13, 0x800  //led rojo
	mov w14, 0x1    //led azul
	mov w27, 0x111B //defino el color superior

	pintar1:
		sturh w27, [x10] //pinto x10
		add x10, x10, x10 //multiplico el valor de x10 para trabajar en 16 bits
		add x10, x0, x10 //sumo al valor de la memoria la dirección base del framebuffer
		sturh w27,[x10] // cargo el nuevo color a el pixel
		add x15, x15, 2 // aumento el valor de x15 para medir el pixel
		movz x7, 2631
		cmp x15, x7 // valor del ultimo pixel segun formula del pdf
		beq pintar1


	mov w27, 0x0E32 //defino el color superior
	pintar2:
		sturh w27, [x10] //pinto x10
		add x10, x10, x10 //multiplico el valor de x10 para trabajar en 16 bits
		add x10, x0, x10 //sumo al valor de la memoria la dirección base del framebuffer
		sturh w27,[x10] // cargo el nuevo color a el pixel
		add x15, x15, 2 // aumento el valor de x15 para medir el pixel
		movz x7, 5258
		cmp x15, x7 //valor del ultimo pixel segun formula del pdf


		




cabeza:
	mov w27, 0x1B2B //defino el color a usar
   arriba:
	mov x3, 151 //inicio x
	mov x4, 411 // fin x

	mov x5, 101 //inicio y
	mov x6, 131 // fin y
	bl dibujar

    derecha:
	mov x3, 411 //inicio x
	mov x4, 382 // fin x

	mov x5, 131 //inicio y
	mov x6, 315 // fin y
	bl dibujar

    abajo:
	mov x3, 382 //inicio x
	mov x4, 168 // fin x

	mov x5, 315 //inicio y
	mov x6, 291 // fin y
	bl dibujar


    izquierda:
	mov x3, 151 //inicio x
	mov x4, 137 // fin x

	mov x5, 101 //inicio y
	mov x6, 266 // fin y
	bl dibujar


dibujar:	
	mov x1, x4 // cargo el limite de y en x1
punto0:	
	mul x26, x6, x2 //calculo el desplazamiento de fila en pixeles, x2 contiene el ancho
	add x10, x26, x1 //calculo el desplazamiento mas la posición en x1 para obtener la dirección en la memoria de cada pixel a modificar
	add x10, x10, x10 //multiplico el valor de x10 para trabajar en 16 bits
	add x10, x0, x10 //sumo al valor de la memoria la dirección base del framebuffer
	sturh w27,[x10] // cargo el nuevo color a 
	cmp x1, x3 // comparo el puntero del bucle con el inicio
	beq dibujary //si son iguales voy a moverme en y
	sub x1,x1,1 // sumo uno en el puntero del bucle
	b punto0
dibujary:	
	cmp x2, x5 //comparo el puntero del bucle con el inicio de y
	beq volver //si son iguales salgo de los bucles
	sub x2,x2,1 //si no son iguales aumento un valor en el puntero y vuelvo a dibujar
	b dibujar
volver:
	br x30


	// --- Infinite Loop ---	
InfLoop: 
	b InfLoop
	