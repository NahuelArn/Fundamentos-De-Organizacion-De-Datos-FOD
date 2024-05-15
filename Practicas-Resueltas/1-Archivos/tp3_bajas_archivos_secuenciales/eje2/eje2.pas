{
  Definir un programa que genere un archivo con registros de longitud fija conteniendo
 información de asistentes a un congreso a partir de la información obtenida por
 teclado. Se deberá almacenar la siguiente información: nro de asistente, apellido y
 nombre, email, teléfono y D.N.I. Implementar un procedimiento que, a partir del
 archivo de datos generado, elimine de forma lógica todos los asistentes con nro de
 asistente inferior a 1000.
 Para ello se podrá utilizar algún carácter especial situándolo delante de algún campo
 String a su elección. Ejemplo: ‘@Saldaño’

}

program eje2;

type
  str50 = string[50];
  asistente = record  //longitud fija
    nro: integer;
    apellido: str50;
    nombre: str50;
    email: str50;
    telefono: str50;
    dni: str50;
  end;

  archivo = file of asistente;

procedure leer_datos(var a: asistente);
begin
  Writeln('Ingrese -1 para finalizar, en nro de asistente ');
  Write('Ingrese el nro de asistente: '); Readln(a.nro);
  if(a.nro <> -1)then
    begin
      Write('Ingrese el apellido: '); Readln(a.apellido);
      Write('Ingrese el nombre: '); Readln(a.nombre);
      Write('Ingrese el email: '); Readln(a.email);
      Write('Ingrese el telefono: '); Readln(a.telefono);
      Write('Ingrese el dni: '); Readln(a.dni);
    end;
end;

procedure crear_archivo(var archivo_logico: archivo);
var
  direccion_inmutable, direccion_mutable: string;
  a: asistente;
begin
  direccion_inmutable:= 'D:\Codigo\Fundamentos-De-Organizacion-De-Datos-FOD\Practicas-Resueltas\1-Archivos\tp3_bajas_archivos_secuenciales\eje2\archivo\';
  Write('Ingrese el nombre del archivo: '); 
  Readln(direccion_mutable);
  assign(archivo_logico, direccion_inmutable + direccion_mutable);
  rewrite(archivo_logico);
  leer_datos(a);
  while a.nro <> -1 do
    begin
      write(archivo_logico, a);
      leer_datos(a);
    end;
  Writeln('Archivo creado con exito!');
  Close(archivo_logico);
end;

procedure eliminar_asistentes_logico(var archivo_logico: archivo);
var
  a: asistente;
begin
  reset(archivo_logico);
  while (not eof (archivo_logico))do
    begin
      read(archivo_logico, a);
      if(a.nro < 1000)then
        begin
          a.apellido:= '@' + a.apellido;
          seek(archivo_logico, filepos(archivo_logico) - 1);
          write(archivo_logico, a);
        end;
    end;
  close(archivo_logico);
end;

procedure imprimirAsistente(a: asistente);
begin
  writeln('Numero: ', a.nro, ' Apellido: ', a.apellido, ' Nombre: ', a.nombre, ' DNI: ', a.dni);
end;
procedure imprimirArchivo(var arc: archivo; estado: boolean);
var
  a: asistente;
begin
  reset(arc);
  while(not eof(arc)) do
    begin
      read(arc, a);
      if estado then
        begin
          imprimirAsistente(a);
        end
      else
        begin
          if(a.apellido[1] <> '@')then
            imprimirAsistente(a);
        end;
    end;
   close(arc);
end;

var
  archivo_logico: archivo;
  // archivo_fisico: str20;
  estado: string;
begin
  crear_archivo(archivo_logico);
  eliminar_asistentes_logico(archivo_logico);
  writeln('ver archivo con asistentes eliminados? SI , NO');
  readln(estado);
  if(estado = 'SI')then
    begin
      Writeln('Se va ha mostrar el archivo con con los asistentes eliminados');
      imprimirArchivo(archivo_logico,true);
    end
  else
    begin
      Writeln('Se va ha mostrar el archivo sin los asistentes eliminados');
      imprimirArchivo(archivo_logico,false);      
    end;
end.