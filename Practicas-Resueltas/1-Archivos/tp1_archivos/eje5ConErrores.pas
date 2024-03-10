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
“celulares.txt”.

ERROR EN LA LECTURA DEL TXT
}

program eje5ConErrores;
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

{Crear un archivo de registros no ordenados de celulares y cargarlo con datos
ingresados desde un archivo de texto denominado “celulares.txt”. Los registros
correspondientes a los celulares, deben contener: código de celular, el nombre,
descripción, marca, precio, stock mínimo y el stock disponible.}

procedure crear_archivo(var archivo_logico:archivo_celulares);
var
  name: string;
  texto_logico: text;
  cel: celular;
begin
  Writeln('Ingrese un nombre para el archivo binario');
  readln(name);
  Assign(archivo_logico, name);
  Rewrite(archivo_logico);  //lo crea y lo abre arch, binario
  
  Assign(texto_logico, 'celulares.txt');
  reset(texto_logico); //abro el txt

  //en este punto tengo en texto_logico, tengo listo el txt, de la pre condicion... en archivo_logico tengo mi archivo donde se va almacenar la dta del txt
  while not (eof(texto_logico))do
    begin
      // readln(archivo_logico, cel);
      {-en la primera se especifica: código de celular, el precio y
      marca, 
      -en la segunda el stock disponible, stock mínimo y la descripción y en 
      -la tercera
      nombre en ese orden.}
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
  Writeln('test 0');
  while not eof(archivo_logico)do
    begin
      read(archivo_logico, cel);
      Writeln('1? : ',cel.cod_celular);
      Writeln('100?: ',cel.precio);
      Writeln('Motorola?: ',cel.marca);
      Writeln('Hotel?: ',cel.descripcion);
    end;
  Writeln('test 2');
  close(archivo_logico);
end;

var
  archivo_logico: archivo_celulares;
begin
  crear_archivo(archivo_logico);
  mostrar_archivo(archivo_logico);
end.