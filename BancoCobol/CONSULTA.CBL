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
        FILE STATUS IS WS-FS.

DATA DIVISION.      
FILE SECTION.
FD  CUENTAS.
COPY BANCO REPLACING REG-CUENTA BY REG-CUENTA-FD.

*> *************************************
WORKING-STORAGE SECTION.
*> ************************************
77  FILLER         PIC X(26) VALUE '* INICIO WORKING-STORAGE *'.

01  WS-FS              PIC XX.

01  WS-EOF             PIC X       VALUE 'N'.
    88 WS-FIN          VALUE 'S'.

01  WS-FIN-PROCESO     PIC X       VALUE 'N'.    
    88 WS-HAY-ERROR    VALUE 'S'.

01  WS-NUM-BUSCAR      PIC 9(5)    VALUE 0.

01  WS-ENCONTRADO      PIC X       VALUE 'N'.
    88 WS-SI           VALUE 'S'.

77  FILLER         PIC X(26) VALUE '* FINAL  WORKING-STORAGE *'.



PROCEDURE DIVISION. 
*> *************************************
*>  CUERPO PRINCIPAL DEL PROGRAMA      *
*> *************************************
MAIN-PROGRAM.
    PERFORM 1000-INICIO   THRU  F-1000-INICIO.

    PERFORM 2000-PROCESO  THRU  F-2000-PROCESO 
            UNTIL WS-HAY-ERROR.

    PERFORM 9999-FINAL    THRU  F-9999-FINAL.

F-MAIN-PROGRAM. GOBACK.

*> *************************************
*>  CUERPO INICIO - APERTURA ARCHIVO   *
*> *************************************
1000-INICIO.
    
    OPEN INPUT CUENTAS.

    IF WS-FS IS NOT EQUAL TO '00'
        DISPLAY '*Error en open cuentas (input) = ' WS-FS
        MOVE 9999 TO RETURN-CODE
        SET WS-HAY-ERROR TO TRUE        
    END-IF.

F-1000-INICIO. EXIT.

*> *************************************
*>    CUERPO PROCESO - CONSULTA        *
*> *************************************   
2000-PROCESO.

*> SOLICITA EL NUMERO DE CUENTA A CONSULTAR
    
    DISPLAY "Consultar saldo."
    DISPLAY "Número de cuenta: " WITH NO ADVANCING.
    ACCEPT WS-NUM-BUSCAR.

*> RECORRE EL ARCHIVO PARA ENCONTRAR LA CUENTA    

    MOVE 'N' TO WS-ENCONTRADO
    MOVE 'N' TO WS-EOF
    
    PERFORM UNTIL WS-FIN
        READ CUENTAS NEXT
            AT END
                MOVE 'S' TO WS-EOF
            NOT AT END
                IF CU-NUMERO OF REG-CUENTA-FD
                         IS EQUAL TO WS-NUM-BUSCAR
                    MOVE 'S' TO WS-ENCONTRADO
                    MOVE 'S' TO WS-EOF
                END-IF
        END-READ       
    END-PERFORM.           
               
*> MUESTRA EL RESULTADO   

    IF WS-SI  
        DISPLAY '  Titular: ' CU-NOMBRE OF REG-CUENTA-FD
        DISPLAY '  Saldo:   ' CU-SALDO OF  REG-CUENTA-FD
    ELSE    
        DISPLAY '* Cuenta no encontrada.'
    END-IF.

    SET WS-HAY-ERROR TO TRUE.  

F-2000-PROCESO. EXIT.    

*> *************************************
*>  CUERPO FINAL - CIERRE DE ARCHIVO   *
*> *************************************      
9999-FINAL.

    IF RETURN-CODE = 9999
        CONTINUE
    ELSE
        CLOSE CUENTAS
        IF WS-FS IS NOT EQUAL TO '00'
            DISPLAY '*Error en close cuentas = ' WS-FS
            MOVE 9999 TO RETURN-CODE
        END-IF
    END-IF.    

F-9999-FINAL. EXIT.    

    