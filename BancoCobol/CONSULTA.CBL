*> *****************************************************************
*>  SUBPROGRAMA: CONSULTA.CBL
*>  CONSULTAR SALDO DE UNA CUENTA
*> *****************************************************************

IDENTIFICATION DIVISION.
PROGRAM-ID. CONSULTA.

ENVIRONMENT DIVISION.
INPUT-OUTPUT SECTION.
FILE-CONTROL.
    SELECT CUENTAS ASSIGN TO "cuentas.dat"
        ORGANIZATION IS LINE SEQUENTIAL
        ACCESS MODE IS SEQUENTIAL.

DATA DIVISION.      
FILE SECTION.
FD  CUENTAS.
COPY BANCO REPLACING REG-CUENTA BY REG-CUENTA-FD.

WORKING-STORAGE SECTION.
01 WS-NUM-BUSCAR   PIC 9(5).
01 WS-ENCONTRADO   PIC X VALUE 'N'.
    88 WS-SI        VALUE 'S'.
01 WS-EOF           PIC X VALUE 'N'.
    88 WS-FIN        VALUE 'S'.


PROCEDURE DIVISION.   
INICIO.
    DISPLAY "Consultar saldo."
    DISPLAY "Número de cuenta: " WITH NO ADVANCING.
    ACCEPT WS-NUM-BUSCAR.

    OPEN INPUT CUENTAS.
    MOVE 'N' TO WS-ENCONTRADO
    MOVE 'N' TO WS-EOF
    PERFORM UNTIL WS-FIN
        READ CUENTAS NEXT
            AT END
                MOVE 'S' TO WS-EOF
            NOT AT END
                IF CU-NUMERO = WS-NUM-BUSCAR
                    MOVE 'S' TO WS-ENCONTRADO
                    DISPLAY "Titular: " CU-NOMBRE
                    DISPLAY "Saldo: " CU-SALDO
                END-IF    
    END-PERFORM. 

    CLOSE CUENTAS.

    IF NOT WS-SI
        DISPLAY "Cuenta no encontrada."
    END-IF.

    EXIT PROGRAM.        