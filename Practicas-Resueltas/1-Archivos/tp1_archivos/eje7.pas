{
Realizar un programa que permita:
a. Crear un archivo binario a partir de la información almacenada en un archivo de texto.
El nombre del archivo de texto es: “novelas.txt”

b. Abrir el archivo binario y permitir la actualización del mismo. Se debe poder agregar
una novela y modificar una existente. Las búsquedas se realizan por código de novela.

NOTA: La información en el archivo de texto consiste en: código de novela, nombre,
género y precio de diferentes novelas argentinas. De cada novela se almacena la
información en dos líneas en el archivo de texto. La primera línea contendrá la siguiente
información: código novela, precio, y género, y la segunda línea almacenará el nombre
de la novela.
}
program eje7;
type
  novela = record
    cod: integer;
    nombre: string;
    genero: string;
    precio: real ;
  end;

  archivo_fisico = file of novela;

procedure inicializar(var archivo_logico: archivo_fisico);
begin
  Assign(archivo_logico, 'archivo_binario');
  rewrite(archivo_logico);
end;

procedure copiar_datos_de_txt(var archivo_logico: archivo_fisico);
var
  texto: text;
  novel: novela;
begin
  Assign(texto,'D:\Escritorio\Fod\Fundamentos-De-Organizacion-De-Datos-FOD\Practicas-Resueltas\1-Archivos\tp1_archivos\archivos_txt\novelas.txt');
  reset(texto);
  while(not eof(texto))do
    begin
      readln(texto, novel.cod, novel.precio, novel.genero);
      readln(texto, novel.nombre);
      write(archivo_logico, novel);
    end;
  close(archivo_logico); //en inicializar ya habia abierto el archivo
  close(texto);
end;

procedure leer_data_novela(var n: novela);
begin
  Writeln('Ingrese el codigo de la novela');
  readln(n.cod);
  Writeln('Ingrese el nombre de la novela');  
  readln(n.nombre);
  Writeln('Ingrese el genero de la novela');
  readln(n.genero);
  Writeln('Ingrese el precio ');
  readln(n.precio);
end;

procedure buscar_novela(var archivo_logico: archivo_fisico; cod: integer; var pos: integer);
var
  novel: novela;
begin
  while((pos = -1) and not eof(archivo_logico))do
    begin
      read(archivo_logico, novel);
      if(novel.cod = cod)then
        pos:= (filePos(archivo_logico)-1);// en el read avance 1+
    end;
end;

procedure punto_b(var archivo_logico: archivo_fisico);
var
  novel: novela;
  cod,pos: integer;
begin
  Reset(archivo_logico);
  Writeln('Agregando una novela nueva');

  leer_data_novela(novel);
  Seek(archivo_logico, FileSize(archivo_logico));
  write(archivo_logico,novel);
  Writeln('Ingrese el codigo de novela ha modificar sus datos');
  readln(cod);
  pos:= -1;
  Seek(archivo_logico, 0); // reseteo, estaba en el ultimo lugar.. IGUAL deberia cerrar el archivo cosa q impacte y aca volverlo a abrir otra vez
  buscar_novela(archivo_logico,cod,pos);
  if(pos <> -1)then
    begin
      Writeln('Se va ha modificar una novela existente');
      Seek(archivo_logico, pos); //IGUAL como no cerre el archivo tipo en el modulo de busqueda,deberia estar ya parado en el archivo buscado pos-1
      leer_data_novela(novel);
      write(archivo_logico, novel);
    end;
  Close(archivo_logico);
end;

var
  archivo_logico: archivo_fisico;
begin
  inicializar(archivo_logico);
  copiar_datos_de_txt(archivo_logico);
  punto_b(archivo_logico);
end.