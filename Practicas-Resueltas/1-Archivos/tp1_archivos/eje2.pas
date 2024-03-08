{Realizar un algoritmo, que utilizando el archivo de números enteros no ordenados
creados en el ejercicio 1, informe por pantalla cantidad de números menores a 1500 y el
promedio de los números ingresados. El nombre del archivo a procesar debe ser
proporcionado por el usuario una única vez. Además, el algoritmo deberá listar el
contenido del archivo en pantalla.}
program eje2;
type
  archivo = file of integer;

function es_menor(num: integer): boolean;
begin
  es_menor:= (num < 1500);  
end;

procedure mostrar_archivo(var archivo_logico: archivo);
var
  num: integer;
begin
  reset(archivo_logico);
  while not eof(archivo_logico)do
    begin
      read(archivo_logico,num); //se obtiene el elemento actual, desde el archivo y se pone en NUM
      write(' | ',num);
    end;
  close(archivo_logico);
end;

var
  archivo_logico: archivo;
  suma: integer;
  cant_menores: integer;
  nro_actual: integer;
begin
  assign(archivo_logico, 'D:\Codigo\Fundamentos-De-Organizacion-De-Datos-FOD\Practicas-Resueltas\1-Archivos\tp1_archivos\archivo_fisico');  //ruta relativa, del archivo creado el eje1
  // assign(archivo_logico, 'archivo_fisico');  //el .dat no sirve... me traigo el archivo ya creado al archivo logico
  Reset (archivo_logico); //abro el archivo logico
  suma:= 0;
  cant_menores:= 0;
  while not eof(archivo_logico)do
    begin
      read(archivo_logico, nro_actual);
      suma:= suma+nro_actual;
      if(es_menor(nro_actual))then
        cant_menores:= cant_menores+1;
    end;
  
  Writeln('La cantidad de numeros menores a 1500 es: ',cant_menores);
  // writeln('SARASA',FileSize(archivo_logico));
  Writeln('El promedio de los numeros ingresados menores a 1500 es: ', suma/FileSize(archivo_logico):2:2);
  close(archivo_logico);

  reset(archivo_logico);
  mostrar_archivo(archivo_logico);
end.