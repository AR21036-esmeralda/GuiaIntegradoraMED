

// **********************************************
// FUNCION: Traducción de dirección logica a fisica
// ***********************************************
Funcion dirFisica <- TraducirDireccion(paginaLogica, offset, Presente, PaginaMarco, TAM_MARCO)
	
    Definir marco Como Entero//posicion en memoria fisica donde esta la pagina
	
    Si Presente[paginaLogica] = 0 Entonces         //verifica si la pagina esta en RAM
        dirFisica <- -1                              // indica fallo de pagina
    Sino
        marco <- PaginaMarco[paginaLogica]
        dirFisica <- (marco * TAM_MARCO) + offset
    FinSi
	
FinFuncion



// **************************************
// FASE 1: ADMINISTRADOR DE MEMORIA
// **************************************
SubProceso InicializarRAM(MarcoOcupado Por Referencia, MarcoPagina Por Referencia)
	
    Definir i Como Entero
	
    Para i <- 1 Hasta 4 Hacer
        MarcoOcupado[i] <- 0    // 0 si esta libre
        MarcoPagina[i] <- -1    // marco sin pagina asignada
    FinPara
	Escribir "RAM inicializada correctamente."
	Esperar Tecla
	
FinSubProceso



SubProceso MostrarMapaBits(MarcoOcupado)
	
    Definir i Como Entero
	
    Para i <- 1 Hasta 4 Hacer
        Escribir MarcoOcupado[i], " " Sin Saltar
    FinPara
	Esperar Tecla
FinSubProceso



SubProceso EjecutarFase1(MarcoOcupado Por Referencia, MarcoPagina Por Referencia)
	
    Definir opcion Como Entero
	
    Repetir
		Limpiar Pantalla
        Escribir "===== FASE 1 ====="
        Escribir "1. Inicializar RAM"
        Escribir "2. Mostrar mapa de bits"
        Escribir "3. Volver"
        Leer opcion
		
        Segun opcion Hacer
            1:
                InicializarRAM(MarcoOcupado, MarcoPagina)
				
            2:
                MostrarMapaBits(MarcoOcupado)
								
        FinSegun
		
    Hasta Que opcion = 3
	
FinSubProceso



// **************************************
// FASE 2: La MMU y Traducción de Direcciones
// **************************************
SubProceso InicializarPaginas(Presente Por Referencia, PaginaMarco Por Referencia, MAXP)
	
    Definir i Como Entero
	
    Para i <- 1 Hasta MAXP Hacer
        Presente[i] <- 0
        PaginaMarco[i] <- -1
    FinPara
	
    // se cargan paginas en los 4 marcos 
    Presente[1] <- 1
    PaginaMarco[1] <- 1   // pagina 1 en marco1 
	
    Presente[2] <- 1
    PaginaMarco[2] <- 2   // pagina 2 en marco 2
		
    Presente[3] <- 1
    PaginaMarco[3] <- 3
	
    Presente[4] <- 1
    PaginaMarco[4] <- 4
	
FinSubProceso



SubProceso EjecutarFase2(Presente Por Referencia, PaginaMarco Por Referencia, TAM_MARCO, MAXP)
	
    Definir opcion, paginaLogica, offset, dirFisica Como Entero
	
    InicializarPaginas(Presente, PaginaMarco, MAXP)
	
    Repetir
		Limpiar Pantalla
        Escribir "***** FASE 2  *****  "
        Escribir "1. Traducir dirección"
        Escribir "2. Volver"
        Leer opcion
		
        Segun opcion Hacer
            1:   // Solicita la pagina logica
                Escribir "Ingrese pagina logica (1 a 8):"			 
                Leer paginaLogica
				
				// Valida que este dentro del rango permitido
                Si paginaLogica < 1 O paginaLogica > MAXP Entonces
                    Escribir "Fuera de rango"
					Esperar Tecla					
                Sino
					// Verifica si la pagina esta en memoria
                    Si Presente[paginaLogica] = 0 Entonces
                        Escribir "Fallo de pagina"
						Esperar Tecla
                    Sino
						// Solicita el desplazamiento
                        Escribir "Ingrese offset (0 a 4095):"
                        Leer offset
						
						// Valida el rango del offset
						Si offset < 0 o offset > 4095 Entonces
							
							Escribir" fuera de rango"
							Esperar Tecla
													
						SiNo
							dirFisica <- TraducirDireccion(paginaLogica, offset, Presente, PaginaMarco, TAM_MARCO)
							Escribir "Direccion fisica: ", dirFisica
							Esperar Tecla
							
						FinSi
														
						                        
                    FinSi
					
                FinSi
        FinSegun
		
    Hasta Que opcion = 2
	
FinSubProceso



// *********************************************
// FASE 3: Simulacion Algoritmos de Reemplazo
// *********************************************





//*************************************
//Simulacion FIFO

SubProceso InicializarMarcosUsuario(Marcos Por Referencia, Ocupado Por Referencia, CANT_MARCOS_USUARIO)
	
    Definir i Como Entero
	
    Para i <- 1 Hasta CANT_MARCOS_USUARIO Hacer
        Ocupado[i] <- 0
        Marcos[i] <- -1
    FinPara
	
FinSubProceso



Funcion idx <- BuscarPaginaEnMarcos(pag, Marcos, Ocupado, CANT_MARCOS_USUARIO) // busca si una pagina ya esta en marco
	
    Definir i Como Entero
    idx <- -1 // no se encontro
	
    Para i <- 1 Hasta CANT_MARCOS_USUARIO Hacer
        Si Ocupado[i] = 1 Y Marcos[i] = pag Entonces
            idx <- i        //retorna la posicion del marco donde esta la pagina
        FinSi
    FinPara
	
FinFuncion


// Simula el algoritmo FIFO para reemplazo de paginas
Funcion fallos <- SimularFIFO(Marcos Por Referencia, Ocupado Por Referencia, Referencias Por Referencia, CANT_MARCOS_USUARIO)
	
    Definir i, t, pag, libre, punteroFIFO Como Entero
	
    InicializarMarcosUsuario(Marcos, Ocupado, CANT_MARCOS_USUARIO)
	
    fallos <- 0
    punteroFIFO <- 1  //apunta al marco mas antiguo
	
    Para t <- 1 Hasta 12 Hacer
		
        pag <- Referencias[t]
		
		// Verifica si la pagina ya esta cargada
        Si BuscarPaginaEnMarcos(pag, Marcos, Ocupado, CANT_MARCOS_USUARIO) = -1 Entonces
			
            fallos <- fallos + 1  // ocurre fallo de pagina
            libre <- -1
			
			// Busca un marco libre
            Para i <- 1 Hasta CANT_MARCOS_USUARIO Hacer
                Si Ocupado[i] = 0 Entonces
                    libre <- i
                FinSi
            FinPara
			
            Si libre <> -1 Entonces       //Si hay espacio, carga la pagina
                Marcos[libre] <- pag
                Ocupado[libre] <- 1
            Sino
                Marcos[punteroFIFO] <- pag
                punteroFIFO <- punteroFIFO + 1
				
                Si punteroFIFO > CANT_MARCOS_USUARIO Entonces   // Reinicia el puntero si llega al limite
                    punteroFIFO <- 1
                FinSi
            FinSi
			
        FinSi
		
    FinPara
	
FinFuncion




//*************************************
//Simulacion Optimo

// Selecciona la pagina que se usara mas tarde (algoritmo Optimo)
Funcion victima <- ElegirVictimaOPT(tActual, Marcos, Referencias, CANT_MARCOS_USUARIO)
	
    Definir i, k, mejorMarco, mayorDist, pag, dist Como Entero
    Definir encontrado Como Logico
	
    mejorMarco <- 1
    mayorDist <- -1
	
    Para i <- 1 Hasta CANT_MARCOS_USUARIO Hacer
		
        pag <- Marcos[i]  //pagina actual en el marco
        dist <- 99999    //valor grande para simular "no se usa pronto" 
        encontrado <- Falso
		
		// Busca cuando se volvera a usar la pagina
        Para k <- tActual + 1 Hasta 12 Hacer
			
            Si Referencias[k] = pag Y encontrado = Falso Entonces
                dist <- k - tActual
                encontrado <- Verdadero
            FinSi
			
        FinPara
		
		// Se queda con la pagina que se usara mas tarde
        Si dist > mayorDist Entonces
            mayorDist <- dist
            mejorMarco <- i
        FinSi
		
    FinPara
	
    victima <- mejorMarco
	
FinFuncion



// Simula el algoritmo Optimo y calcula los fallos de pagina
Funcion fallos <- SimularOPT(Marcos Por Referencia, Ocupado Por Referencia, Referencias Por Referencia, CANT_MARCOS_USUARIO)
	
    Definir t, pag, i, libre, v Como Entero
	
    InicializarMarcosUsuario(Marcos, Ocupado, CANT_MARCOS_USUARIO)
	
    fallos <- 0 //contador de fallos
	
    Para t <- 1 Hasta 12 Hacer
		
        pag <- Referencias[t]
		
		// Verifica si la pagina ya esta en memoria
        Si BuscarPaginaEnMarcos(pag, Marcos, Ocupado, CANT_MARCOS_USUARIO) = -1 Entonces
			
            fallos <- fallos + 1
            libre <- -1
			
            Para i <- 1 Hasta CANT_MARCOS_USUARIO Hacer
                Si Ocupado[i] = 0 Entonces
                    libre <- i
                FinSi
            FinPara
			
            Si libre <> -1 Entonces
                Marcos[libre] <- pag
                Ocupado[libre] <- 1
            Sino
                v <- ElegirVictimaOPT(t, Marcos, Referencias, CANT_MARCOS_USUARIO)
                Marcos[v] <- pag
            FinSi
			
        FinSi
		
    FinPara
	
FinFuncion



SubProceso EjecutarFase3(Marcos Por Referencia, Ocupado Por Referencia, Referencias Por Referencia, CANT_MARCOS_USUARIO)
	
    Definir opcion, fallos Como Entero
	
    Repetir
		Limpiar Pantalla
        Escribir "**** FASE 3 ****"
        Escribir "1. FIFO"
        Escribir "2. OPT"
        Escribir "3. Volver"
        Leer opcion
		
        Segun opcion Hacer
            1:
                fallos <- SimularFIFO(Marcos, Ocupado, Referencias, CANT_MARCOS_USUARIO)
                Escribir "Fallos FIFO: ", fallos
				Esperar Tecla				
            2:
                fallos <- SimularOPT(Marcos, Ocupado, Referencias, CANT_MARCOS_USUARIO)
                Escribir "Fallos OPT: ", fallos
				Esperar Tecla
        FinSegun
		
    Hasta Que opcion = 3
	
FinSubProceso



// *************************************
// PROGRAMA PRINCIPAL
// ************************************
Proceso SimuladorMMU
	
    Definir opcion Como Entero
    Definir limite, MAXP, TAM_MARCO Como Entero
    Definir MarcoOcupado, MarcoPagina Como Entero
    Definir Presente, PaginaMarco Como Entero
    Definir CANT_MARCOS_USUARIO Como Entero
    Definir Marcos, Ocupado, Referencias Como Entero
	
    limite <- 4 // solo pueden haber 4 marcos, la ram es 16KB
    MAXP <- 8 // numero de paginas logicas
    TAM_MARCO <- 4096 // tamano de cada marco
    CANT_MARCOS_USUARIO <- 3 // marcos disponibles para reemplazo 
	
    Dimension MarcoOcupado[limite] //indica si el marco esta ocupado
    Dimension MarcoPagina[limite]// pagina almacenada en cada marco
    
	// tabla de paginas
	Dimension Presente[MAXP] // bit de presencia (0 o 1)
    Dimension PaginaMarco[MAXP]// relacion pagina marco
	
	// Estructuras para simulacion de reemplazo
    Dimension Marcos[CANT_MARCOS_USUARIO] //paginas en memoria
    Dimension Ocupado[CANT_MARCOS_USUARIO]//estado de cada marco
    Dimension Referencias[12]
	
	
	// Secuencia de paginas a simular
    Referencias[1] <- 1 
    Referencias[2] <- 2
    Referencias[3] <- 3
    Referencias[4] <- 4
    Referencias[5] <- 1
    Referencias[6] <- 2
    Referencias[7] <- 5
    Referencias[8] <- 1
    Referencias[9] <- 2
    Referencias[10] <- 3
    Referencias[11] <- 4
    Referencias[12] <- 5
	
    Repetir
		Limpiar Pantalla
        Escribir "===== MENU ====="
        Escribir "1. Fase 1:ADMINISTRADOR DE MEMORIA"
        Escribir "2. Fase 2:La MMU y Traducción de Direcciones"
        Escribir "3. Fase 3:Simulacion Algoritmos de Reemplazo"
        Escribir "4. Salir"
        Leer opcion
		
        Segun opcion Hacer
            1:
                EjecutarFase1(MarcoOcupado, MarcoPagina)
            2:
                EjecutarFase2(Presente, PaginaMarco, TAM_MARCO, MAXP)
            3:
                EjecutarFase3(Marcos, Ocupado, Referencias, CANT_MARCOS_USUARIO)
        FinSegun
		
    Hasta Que opcion = 4
	
FinProceso
