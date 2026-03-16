*> *****************************************************************
*> COPYBOOK: BANCO.CPY                                 
*> *****************************************************************



01 REG-CUENTA.   
   05 CU-NUMERO    PIC 9(5).
   05 CU-NOMBRE    PIC X(30).
   05 CU-SALDO     PIC 9(7)V99.


01 REG-MOVIMIENTO.
   05 MV-NUMERO      PIC 9(5).
   05 MV-FECHA       PIC 9(8).
   05 MV-TIPO        PIC X(1).
   05 MV-IMPORTE     PIC 9(7)V99.
   05 MV-SALDO       PIC 9(7)V99. 
   