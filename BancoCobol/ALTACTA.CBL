*> *****************************************************************
*>  SUBPROGRAMA: ALTACTA.CBL
*>  ALTA DE NUEVAS CUENTAS
*> *****************************************************************

IDENTIFICATION DIVISION.
PROGRAM-ID. ALTACTA.

ENVIRONMENT DIVISION.
INPUT-OUTPUT SECTION.
FILE-CONTROL.
    SELECT CUENTAS ASSIGN TO "cuentas.dat"
        ORGANIZATION IS LINE SEQUENTIAL
        FILE STATUS IS WS-FS.
DATA DIVISION.
FILE SECTION.
FD CUENTAS.
COPY BANCO REPLACING REG-CUENTA BY REG-CUENTA-FD.

WORKING-STORAGE SECTION.
01 WS-FS            PIC XX.
    88 FS-OK        VALUE "00".
    88 FS-NO-EXISTE VALUE "35".
01 WS-EOF           PIC X VALUE 'N'.
    88 WS-FIN        VALUE 'S'.
01 WS-ULTIMO-NUM    PIC 9(5) VALUE 0.
01 WS-SALDO-INI     PIC 9(7)V99 VALUE 0.

PROCEDURE DIVISION.
INICIO.
    OPEN INPUT CUENTAS
    IF FS-NO-EXISTE
        OPEN OUTPUT CUENTAS
        IF NOT FS-OK
            DISPLAY "Error creando cuentas.dat, status=" WS-FS
            STOP RUN
        END-IF
        CLOSE CUENTAS
    ELSE
        IF NOT FS-OK
            DISPLAY "Error abriendo cuentas.dat en INPUT, status=" WS-FS
            STOP RUN
        END-IF

        MOVE 0 TO WS-ULTIMO-NUM
        MOVE 'N' TO WS-EOF
        PERFORM UNTIL WS-FIN
            READ CUENTAS NEXT
                AT END
                    MOVE 'S' TO WS-EOF
                NOT AT END
                    IF CU-NUMERO OF REG-CUENTA-FD > WS-ULTIMO-NUM
                        MOVE CU-NUMERO OF REG-CUENTA-FD TO WS-ULTIMO-NUM
                    END-IF
            END-READ
        END-PERFORM

        CLOSE CUENTAS
    END-IF

    OPEN EXTEND CUENTAS
    IF NOT FS-OK
        DISPLAY "No se pudo abrir CUENTAS en EXTEND, status=" WS-FS
        STOP RUN
    END-IF     

    ADD 1 TO WS-ULTIMO-NUM.          
    MOVE WS-ULTIMO-NUM TO CU-NUMERO OF REG-CUENTA-FD.
    
    DISPLAY "Alta de nueva cuenta."
    DISPLAY "Número asignado: " WS-ULTIMO-NUM.
    DISPLAY "Nombre del titular: " WITH NO ADVANCING.
    ACCEPT CU-NOMBRE OF REG-CUENTA-FD.
    DISPLAY "Saldo inicial: " WITH NO ADVANCING.
    ACCEPT WS-SALDO-INI.
    MOVE WS-SALDO-INI TO CU-SALDO OF REG-CUENTA-FD.

    WRITE REG-CUENTA-FD
    DISPLAY "Cuenta creada con éxito."

    CLOSE CUENTAS
    EXIT PROGRAM.

    


    
    

