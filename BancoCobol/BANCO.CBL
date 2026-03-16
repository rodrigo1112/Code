*> *****************************************************************
*> PROGRAMA PRINCIPAL: BANCO.CBL
*> SISTEMA BANCARIO SIMPLE - MENU PRINCIPAL
*> *****************************************************************

IDENTIFICATION DIVISION.
PROGRAM-ID. BANCO.
AUTHOR. RODRIGO GIRARDI.

DATA DIVISION.
WORKING-STORAGE SECTION.
01 WS-OPCION        PIC 9.
    88 OPC-SALIR     VALUE 0.
    88 OPC-ALTAS     VALUE 1.
    88 OPC-CONSULTA  VALUE 2.
    88 OPC-DEPOSITO  VALUE 3.
    88 OPC-RETIRO    VALUE 4.
    88 OPC-LISTAR    VALUE 5.
    88 OPC-MOVIM     VALUE 6.

PROCEDURE DIVISION.
MAIN-PROGRAM.
    MOVE 1 TO WS-OPCION
    PERFORM UNTIL OPC-SALIR
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
            WHEN OPC-DEPOSITO
                CALL 'DEPOSITO'
            WHEN OPC-CONSULTA
                CALL 'CONSULTA'
            WHEN OPC-RETIRO
                CALL 'RETIRO'
            WHEN OPC-LISTAR
                CALL 'LISTAR'
            WHEN OPC-MOVIM
                CALL 'MOVIM'
            WHEN OTHER        
                IF NOT OPC-SALIR    
                    DISPLAY "Opción no válida. Intente de nuevo."
        END-EVALUATE            
    END-PERFORM
    DISPLAY "Gracias por usar el sistema bancario."
    STOP RUN.
    
