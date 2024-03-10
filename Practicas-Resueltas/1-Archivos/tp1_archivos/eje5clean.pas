{Realizar un programa para una tienda de celulares, que presente un menú con
opciones para:
a. Crear un archivo de registros no ordenados de celulares y cargarlo con datos
ingresados desde un archivo de texto denominado “celulares.txt”. Los registros
correspondientes a los celulares, deben contener: código de celular, el nombre,
descripción, marca, precio, stock mínimo y el stock disponible.
b. Listar en pantalla los datos de aquellos celulares que tengan un stock menor al
stock mínimo.
c. Listar en pantalla los celulares del archivo cuya descripción contenga una
cadena de caracteres proporcionada por el usuario.
d. Exportar el archivo creado en el inciso a) a un archivo de texto denominado
“celulares.txt”con todos los celulares del mismo. El archivo de texto generado
podría ser utilizado en un futuro como archivo de carga (ver inciso a), por lo que
debería respetar el formato dado para este tipo de archivos en la NOTA 2.

NOTA 1: El nombre del archivo binario de celulares debe ser proporcionado por el usuario.
NOTA 2: El archivo de carga debe editarse de manera que cada celular se especifique en
tres líneas consecutivas: en la primera se especifica: código de celular, el precio y
marca, en la segunda el stock disponible, stock mínimo y la descripción y en la tercera
nombre en ese orden. Cada celular se carga leyendo tres líneas del archivo
“celulares.txt”.}

program eje5clean;
type
  celular = record
    cod_celular: integer;
    nombre: string;
    descripcion: string;
    marca: string;
    precio: real;
    stock_minimo: integer;
    stock_disponible: integer;
  end;

  archivo_celulares = file of celular;
 
procedure crear_archivo(var archivo_logico:archivo_celulares);
var
  name: string;
  texto_logico: text;
  cel: celular;
begin
  Writeln('Ingrese un nombre para el archivo binario');
  readln(name);
  Assign(archivo_logico, name);
  Rewrite(archivo_logico); 
  Assign(texto_logico, 'celulares.txt');
  reset(texto_logico); 
  while not (eof(texto_logico))do
    begin
      readln(texto_logico, cel.cod_celular, cel.precio, cel.marca);
      readln(texto_logico, cel.stock_disponible, cel.stock_minimo, cel.descripcion);
      readln(texto_logico, cel.nombre);
      write(archivo_logico, cel);
    end;
  close(texto_logico);
  close(archivo_logico);
end;

procedure mostrar_archivo(var archivo_logico: archivo_celulares);
var 
  cel: celular;
begin
  reset(archivo_logico);
  while (not eof(archivo_logico))do
    begin
      read(archivo_logico, cel);
      Writeln('1? : ',cel.cod_celular);
      Writeln('100?: ',cel.precio);
      Writeln('Motorola?: ',cel.marca);
      Writeln('Hotel?: ',cel.descripcion);
    end;
  close(archivo_logico);
end;

procedure mostrarMenu(var opcion: char);
begin
  Writeln('---------------------------------------------');
  Writeln('Ingrese "A" para cargar un archivo, con los datos del txt');
  Writeln('Ingrese "B" listar en pantalla aquellos celulares q tienen stock menor al minimo');
  Writeln('Ingrese "C" listar los celulares q matcheen con la descripcion "descripcion en archivo usuario" = "descripcion entrada"');
  Writeln('Ingrese "D" para exportar el archivo creado en el inciso "A" en formato txt');
  Writeln('E para saliar');
  readln(opcion);
  Writeln('---------------------------------------------');
end;

procedure opcion_a(var archivo_logico:archivo_celulares);
begin
  crear_archivo(archivo_logico);
  mostrar_archivo(archivo_logico);
end;

procedure opcion_b(var archivo_logico: archivo_celulares);
var
  cel: celular;
begin
  reset(archivo_logico);
  while (not eof(archivo_logico))do
    begin
      read(archivo_logico, cel);
      if(cel.stock_disponible < cel.stock_minimo)then
        begin
          close(archivo_logico); //como tengo el modulo q lo abre y reutilizan varias partes del programa (hago esto)
          mostrar_archivo(archivo_logico);
          Reset(archivo_logico);    //MAGAIBA
        end;
    end;
  close(archivo_logico);
end;

procedure opcion_c(var archivo_logico: archivo_celulares);
var
  cadena: string;
  cel: celular;
begin
  Writeln('Ingrese una cadena para ver si matchea con la descripcion de algun celular');
  readln(cadena);
  reset(archivo_logico);
  while(not eof(archivo_logico))do
    begin
      read(archivo_logico, cel);
      if(cel.descripcion = cadena)then
        begin
          close(archivo_logico); //como tengo el modulo q lo abre y reutilizan varias partes del programa (hago esto)
          mostrar_archivo(archivo_logico);  //los modulos de impresion de registros, solo tienen q imprimir (sacar el abrir y cerrar)
          Reset(archivo_logico);    //MAGAIBA
        end;
    end;
  close(archivo_logico);
end;

{Exportar el archivo creado en el inciso a) a un archivo de texto denominado
“celulares.txt”con todos los celulares del mismo. El archivo de texto generado
podría ser utilizado en un futuro como archivo de carga (ver inciso a), por lo que
debería respetar el formato dado para este tipo de archivos en la NOTA 2.}

procedure opcion_d(var archivo_logico: archivo_celulares);
var
  nuevoTexto: text;
  cel: celular;
  // aux: string;
begin
  Assign(nuevoTexto, 'celularesv2.txt');
  Rewrite(nuevoTexto);
  While(not eof(archivo_logico))do
    begin
      read(archivo_logico, cel);
      // aux:= ('cod celular: ',cel.cod_celular, ' nombre: ',cel.nombre, ' descripcion: ',cel.descripcion,' marca: ',cel.marca, ' precio: ',cel.precio, ' stock minimo: ',cel.stock_minimo, ' stock disponible: ', cel.stock_disponible);
      write(nuevoTexto, 'cod celular: ',cel.cod_celular, ' nombre: ',cel.nombre, ' descripcion: ',cel.descripcion,' marca: ',cel.marca, ' precio: ',cel.precio, ' stock minimo: ',cel.stock_minimo, ' stock disponible: ', cel.stock_disponible);
    end;
  Close(nuevoTexto);
  Close(archivo_logico);
end;

var
  archivo_logico: archivo_celulares;
  opcion: char;
begin
  mostrarMenu(opcion);
  while (opcion <> 'E')do 
    case opcion of
      'A': 
        begin
          opcion_a(archivo_logico);
        end;
      'B':
        begin
          opcion_b(archivo_logico);
        end;
      'C':
        begin
          opcion_c(archivo_logico);
        end;
      'D': 
        begin
          opcion_d(archivo_logico);
        end;
      'E':  Writeln('Termino el programa.');
      else
        begin
          WriteLn('Error');
        end;
    end;
end.