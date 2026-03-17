*> *****************************************************************
*> PROGRAMA PRINCIPAL: BANCO.CBL
*> SISTEMA BANCARIO SIMPLE - MENU PRINCIPAL
*> *****************************************************************

IDENTIFICATION DIVISION.
PROGRAM-ID. BANCO.
AUTHOR. RODRIGO GIRARDI
*> PRESENTA EL MENU DE OPCIONES AL USUARIO   *
*> INVOCA LOS SUBPROGRAMAS CORRESPONDIENTES  *


DATA DIVISION.
*>*************************************
WORKING-STORAGE SECTION.
*>*************************************
77  FILLER         PIC X(26) VALUE '* INICIO WORKING-STORAGE *'.


01 WS-OPCION         PIC 9.     VALUE 9.
    88 OPC-SALIR                VALUE 0.
    88 OPC-ALTAS                VALUE 1.
    88 OPC-CONSULTA             VALUE 2.
    88 OPC-DEPOSITO             VALUE 3.
    88 OPC-RETIRO               VALUE 4.
    88 OPC-LISTAR               VALUE 5.
    88 OPC-MOVIM                VALUE 6.

01  WS-FLAG-FIN        PIC X    VALUE 'N'.
    88 WS-FIN-PROCESO  VALUE 'S'.

77  FILLER         PIC X(26) VALUE '* FINAL  WORKING-STORAGE *'.


PROCEDURE DIVISION.
*>*************************************
*>  CUERPO PRINCIPAL DEL PROGRAMA     *
*>*************************************
MAIN-PROGRAM.
    PERFORM 1000-INICIO   THRU  F-1000-INICIO.
    
    PERFORM 2000-PROCESO  THRU  F-2000-PROCESO
            UNTIL WS-FIN-PROCESO.
    
    PERFORM 9999-FINAL    THRU  F-9999-FINAL.
    
F-MAIN-PROGRAM.  GOBACK.

*>*************************************
*>  CUERPO INICIO - INICIALIZACION    *
*>*************************************
1000-INICIO.

    MOVE 9 TO WS-OPCION.

F-1000-INICIO. EXIT.

*>*************************************
*>  CUERPO PROCESO - MENU PRINCIPAL   *
*>*************************************
2000-PROCESO.

        DISPLAY " "  
        DISPLAY "=== SISTEMA BANCARIO RG ==="
        DISPLAY "1. Alta de cuenta"
        DISPLAY "2. Consultar saldo"
        DISPLAY "3. Realizar depósito"
        DISPLAY "4. Realizar retiro"
        DISPLAY "5. Listar todas las cuentas"
        DISPLAY "6. Ver moviemientos de una cuenta"
        DISPLAY "0. Salir"
        DISPLAY "Seleccione una opción:" WITH NO ADVANCING
        ACCEPT WS-OPCION
        
        EVALUATE TRUE
            WHEN OPC-ALTAS    
                CALL 'ALTACTA'
            MOVE RETURN-CODE TO WS-RC
            IF WS-RC IS NOT EQUAL 0   
                DISPLAY '* ERROR EN ALTACTA = ' WS-RC
            END-IF    
            WHEN OPC-DEPOSITO
                CALL 'DEPOSITO'
                MOVE RETURN-CODE TO WS-RC      
                IF WS-RC IS NOT EQUAL 0   
                    DISPLAY '* ERROR EN DEPOSITO = ' WS-RC
                END-IF
            WHEN OPC-CONSULTA
                CALL 'CONSULTA'
                MOVE RETURN-CODE TO WS-RC
                IF WS-RC IS NOT EQUAL 0   
                    DISPLAY '* ERROR EN CONSULTA = ' WS-RC
                END-IF
            WHEN OPC-RETIRO
                CALL 'RETIRO'
                MOVE RETURN-CODE TO WS-RC
                IF WS-RC IS NOT EQUAL 0
                    DISPLAY '* ERROR EN RETIRO = ' WS-RC
                END-IF
            WHEN OPC-LISTAR
                CALL 'LISTAR'
                MOVE RETURN-CODE TO WS-RC
                IF WS-RC IS NOT EQUAL 0
                    DISPLAY '* ERROR EN LISTAR = ' WS-RC
                END-IF
            WHEN OPC-MOVIM
                CALL 'MOVIM'
                MOVE RETURN-CODE TO WS-RC
                IF WS-RC IS NOT EQUAL 0
                    DISPLAY '* ERROR EN MOVIM = ' WS-RC
                END-IF
            WHEN OPC-SALIR      
                SET WS-FIN-PROCESO TO TRUE   
            WHEN OTHER
                DISPLAY "Opción no válida. Intente de nuevo."
        END-EVALUATE   

F-2000-PROCESO. EXIT.

*>*************************************
*>   CUERPO FINAL - CIERRE            *
*>*************************************
9999-FINAL.

    DISPLAY ' '.
    DISPLAY "Gracias por usar el sistema bancario."

F-9999-FINAL. EXIT   
    
