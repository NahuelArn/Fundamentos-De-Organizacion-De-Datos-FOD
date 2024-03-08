{Realizar un algoritmo que cree un archivo de números enteros no ordenados y permita
incorporar datos al archivo. Los números son ingresados desde teclado. El nombre del
archivo debe ser proporcionado por el usuario desde teclado. La carga finaliza cuando
se ingrese el número 30000, que no debe incorporarse al archivo.}

program eje1;
type
  numeros = file of integer;
  str20 = string[20];
var
  num: integer;
  archivo_logico: numeros;
  nombre_del_archivo: str20;
begin
  Writeln('Ingrese el nombre que va llevar el archivo');
  readln(nombre_del_archivo);
  Assign(archivo_logico, nombre_del_archivo); //logico, (se puede hardcodear un string) nombre del archivo al guardarse ENLACE
  rewrite(archivo_logico);  //se crea el archivo
  Writeln('Ingrese un numero: ');
  readln(num); 
  while(num <> 30000 )do  
    begin
      write(archivo_logico,num);
      Writeln('Ingrese un numero: ');
      readln(num);   
    end;
    close(archivo_logico);
end.