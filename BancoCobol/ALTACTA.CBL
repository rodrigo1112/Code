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

*>******************************
WORKING-STORAGE SECTION.  
*>****************************** 
77  FILLER            PIC X(26)   VALUE '* INICIO WORKING-STORAGE *'.

01  WS-FS             PIC XX.

01 WS-EOF             PIC X       VALUE 'N'.
    88 WS-FIN                     VALUE 'S'.

01 WS-FIN-PROCESO     PIC X       VALUE 'N'.
   88 WS-HAY-ERROR                VALUE 'S'.

01 WS-ULTIMO-NUM      PIC 9(5)    VALUE 0.
01 WS-SALDO-INI       PIC 9(7)V99 VALUE 0.

77  FILLER            PIC X(26) VALUE '* FINAL  WORKING-STORAGE *'.

PROCEDURE DIVISION.

*>********************************
*> CUERPO PRINCIPAL DEL PROGRAMA *
*>********************************
MAIN-PROGRAM.
    PERFORM 1000-INICIO   THRU  F-1000-INICIO.

    PERFORM 2000-PROCESO  THRU  F-2000-PROCESO 
            UNTIL WS-HAY-ERROR.

    PERFORM 9999-FINAL    THRU  F-9999-FINAL.       

F-MAIN-PROGRAM. GOBACK.

*>***********************************
*> CUERPO INICIO - APERTURA ARCHIVO *
*>***********************************
1000-INICIO.

*> ABRE EN INPUT PARA LEER. SI NO EXISTE (FS=35) LO CREA CON
*> OUTPUT, LO CIERRA.
*> EL EXTEND SE HACE EN 2000-PROCESO 
*> DESPUES DE DETERMINAR EL ULTIMO NUMERO.
    
    OPEN INPUT CUENTAS
    
    IF WS-FS IS EQUAL TO '35'
        OPEN OUTPUT CUENTAS
        IF WS-FS IS NOT EQUAL TO '00'
            DISPLAY '"Error al crear cuentas.dat    = ' WS-FS
            MOVE 9999 TO RETURN-CODE
            SET WS-HAY-ERROR TO TRUE
        END-IF 
        CLOSE CUENTAS
    END-IF.       
        
    IF WS-FS IS NOT EQUAL TO '00'
        DISPLAY '*Error en open cuentas (input) = ' WS-FS
        MOVE 9999 TO RETURN-CODE
        SET WS-HAY-ERROR TO TRUE        
    END-IF.

F-1000-INICIO. EXIT. 

*>************************************
*> CUERPO PRINCIPAL - ALTA DE CUENTA *
*>************************************
2000-PROCESO.

*> RECORRE EL ARCHIVO PARA DETERMINAR EL ULTIMO NUMERO
    
    MOVE 0   TO WS-ULTIMO-NUM.
    MOVE 'N' TO WS-EOF.

    PERFORM UNTIL WS-FIN
        READ CUENTAS NEXT
            AT END
                MOVE 'S' TO WS-EOF
            NOT AT END
                IF CU-NUMERO OF REG-CUENTA-FD > WS-ULTIMO-NUM
                    MOVE CU-NUMERO OF REG-CUENTA-FD 
                        TO WS-ULTIMO-NUM
                END-IF
        END-READ
    END-PERFORM.

    CLOSE CUENTAS.

*> REABRE EN EXTEND PARA AGREGAR EL NUEVO REGISTRO AL FINAL
    OPEN EXTEND CUENTAS
    
    IF WS-FS IS NOT EQUAL TO '00'
        DISPLAY '* ERROR EN OPEN CUENTAS (EXTEND) = ' WS-FS
        MOVE 9999 TO RETURN-CODE
        SET WS-HAY-ERROR TO TRUE
    END-IF.



*> ASIGNA EL NUEVO NUMERO Y SOLICITA DATOS AL USUARIO

    IF NOT WS-HAY-ERROR
        ADD 1 TO WS-ULTIMO-NUM
        MOVE WS-ULTIMO-NUM TO CU-NUMERO OF REG-CUENTA-FD

        DISPLAY "Alta de nueva cuenta."
        DISPLAY "Número asignado: " WS-ULTIMO-NUM.
        DISPLAY "Nombre del titular: " WITH NO ADVANCING.
        ACCEPT CU-NOMBRE OF REG-CUENTA-FD.
        DISPLAY "Saldo inicial: " WITH NO ADVANCING.
        ACCEPT WS-SALDO-INI.
        MOVE WS-SALDO-INI TO CU-SALDO OF REG-CUENTA-FD.

*>**************************** 
*> GRABA EL NUEVO REGISTRO   *    
*>****************************  
    WRITE REG-CUENTA-FD
   
    IF WS-FS IS NOT EQUAL '00'
        DISPLAY '* ERROR EN WRITE CUENTAS         = ' WS-FS
        MOVE 9999 TO RETURN-CODE
    ELSE  
        DISPLAY '  Cuenta creada con exito.'
    END-IF.

    SET WS-HAY-ERROR TO TRUE.

F-2000-PROCESO. EXIT.       

*>*************************************
*> CUERPO FINAL - CIERRE DE ARCHIVO   *
*>*************************************
9999-FINAL.
   
    IF RETURN-CODE = 9999
        CONTINUE
    ELSE 
        CLOSE CUENTAS
        IF WS-FS IS NOT EQUAL '00'
            DISPLAY 'ERROR EN CLOSE CUENTAS       = ' WS-FS
            MOVE 9999 TO RETURN-CODE
        END-IF
    END-IF.

F-9999-FINAL. EXIT.
    


    
    

