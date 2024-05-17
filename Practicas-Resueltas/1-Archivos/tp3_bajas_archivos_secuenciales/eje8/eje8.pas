{
  Se cuenta con un archivo con información de las diferentes distribuciones de linux
existentes. De cada distribución se conoce: nombre, año de lanzamiento, número de
versión del kernel, cantidad de desarrolladores y descripción. El nombre de las
distribuciones no puede repetirse. Este archivo debe ser mantenido realizando bajas
lógicas y utilizando la técnica de reutilización de espacio libre llamada lista invertida.

Escriba la definición de las estructuras de datos necesarias y los siguientes
procedimientos:
a. ExisteDistribucion: módulo que recibe por parámetro un nombre y devuelve
verdadero si la distribución existe en el archivo o falso en caso contrario.
b. AltaDistribución: módulo que lee por teclado los datos de una nueva
distribución y la agrega al archivo reutilizando espacio disponible en caso
de que exista. (El control de unicidad lo debe realizar utilizando el módulo
anterior). En caso de que la distribución que se quiere agregar ya exista se
debe informar “ya existe la distribución”.
c. BajaDistribución: módulo que da de baja lógicamente una distribución 
cuyo nombre se lee por teclado. Para marcar una distribución como
borrada se debe utilizar el campo cantidad de desarrolladores para
mantener actualizada la lista invertida. Para verificar que la distribución a
borrar exista debe utilizar el módulo ExisteDistribucion. En caso de no existir
se debe informar “Distribución no existente”.


}
program eje8;
type
  distribucion = record
    nombre: string; //no puede repetirse unicidad
    anho: integer;
    version: double;
    desarrolladores: integer;
    descripcion: string;
  end;

  archivo = file of distribucion;

procedure crearArchivo(var arch: archivo);
var
  t: text;
  d: distribucion;
begin
  Assign(arch, 'D:\Escritorio\FOD\Fundamentos-De-Organizacion-De-Datos-FOD\Practicas-Resueltas\1-Archivos\tp3_bajas_archivos_secuenciales\eje8\archivo');
  Rewrite(arch);
  Assign(t, 'D:\Escritorio\FOD\Fundamentos-De-Organizacion-De-Datos-FOD\Practicas-Resueltas\1-Archivos\tp3_bajas_archivos_secuenciales\eje8\archivo\texto.txt');
  reset(t);
  d.desarrolladores:= 0;  //lista invertida cabeza
  write(arch, d);
  while (not eof(t))do
    begin
      readln(t, d.nombre);
      readln(t, d.anho, d.version, d.desarrolladores);
      readln(t, d.descripcion);
      write(arch, d);
    end;
  Close(arch);
  Close(t);
end;

{a. ExisteDistribucion: módulo que recibe por parámetro un nombre y devuelve
verdadero si la distribución existe en el archivo o falso en caso contrario.}
procedure ExisteDistribucion(var arch: archivo; nombre: string; var existe: boolean);
begin
  existe:= false;
  reset(arch);
  while (not eof(arch)) and (not existe) do
    begin
      read(arch, d);
      if (d.nombre = nombre) and (d.desarrolladores > -1 ) then //puedo encontrar el desarrollador en la lista invertida pero puede tener una baja logica
        existe:= true;
    end;
  Close(arch);
end;

{b. AltaDistribución: módulo que lee por teclado los datos de una nueva
distribución y la agrega al archivo reutilizando espacio disponible en caso
de que exista. (El control de unicidad lo debe realizar utilizando el módulo
anterior). En caso de que la distribución que se quiere agregar ya exista se
debe informar “ya existe la distribución”.}

procedure AltaDistribucion(var arch: archivo);
  procedure leerDatos(var d: distribucion);
  begin
    writeln ('Ingrese el nombre de la distribucion');
    readln(d.nombre);
    WriteLn ('Ingrese el anho de lanzamiento');
    readln(d.anho);
    WriteLn ('Ingrese la version del kernel');
    readln(d.version);
    WriteLn ('Ingrese la cantidad de desarrolladores');
    readln(d.desarrolladores);
    WriteLn ('Ingrese la descripcion');
    readln(d.descripcion);
  end;
var
  d: distribucion;
  cabeza: distribucion;
  log: distribucion;
begin
  leerDatos(d);  
  ExisteDistribucion(arch, d.nombre, existe);
  if (existe) then
    writeln('Ya existe la distribucion')
  else
    begin
      reset(arch);
      Read(arch, cabeza);
      if cabeza.desarrolladores < 0 then
        begin
          seek(arch, cabeza.desarrolladores*-1);  //busco el espacio libre
          read(arch, log); //leo el espacio libre
          Seek(arch, FilePos(arch)-1);// vuelvo a la posicion anterior 
          write(arch, d); //escribo la distribucion
          seek(arch, 0);  //vuelvo al principio
          write(arch, log); //actualizo la lista invertida
        end
      else
        begin
          seek(arch, filesize(arch));
          write(arch, d);
        end;
    end;
  Close(arch);
end;

{c. BajaDistribución: módulo que da de baja lógicamente una distribución 
cuyo nombre se lee por teclado. Para marcar una distribución como
borrada se debe utilizar el campo cantidad de desarrolladores para
mantener actualizada la lista invertida. Para verificar que la distribución a
borrar exista debe utilizar el módulo ExisteDistribucion. En caso de no existir
se debe informar “Distribución no existente”.}

procedure BajaDistribucion(var arch: archivo);
var
  nombre: string;
  existe: boolean;
  d,cabeza: distribucion;
  pos: integer;
begin
  writeln('Ingrese el nombre de la distribucion a dar de baja');
  readln(nombre);
  // ExisteDistribucion(arch, nombre, existe); //es al pedo usarlo si me retorna solo un true o false y se cierra el archivo
  existe:= false;
  reset(arch);
  Read(arch, cabeza);
  while (not eof(arch)) and (not existe) do
    begin
      read(arch, d);
      if (d.nombre = nombre) and (d.desarrolladores > -1 ) then //puedo encontrar el desarrollador en la lista invertida pero puede tener una baja logica
        begin
          d.desarrolladores:= cabeza.desarrolladores; //hago q apunte a lo q apuntaba la cabeza
          seek(arch, FilePos(arch)-1);  //vuelvo a la posicion anterior
          pos:= FilePos(arch);  //guardo la posicion de la baja actual
          write(arch, d); //actualizo la baja logica reciente, con lo que apuntaba la cabeza
          Seek(arch, 0);  //vuelvo al principio
          cabeza.desarrolladores:= pos*-1; //actualizo la cabeza con la nueva baja logica
          write(arch, cabeza.desarrolladores); //actualizo la lista invertida
          existe:= true;
        end;
    end;
  Close(arch);
end;

var
  arch: archivo;
  existe: boolean;
begin
  crearArchivo(arch);
  writeln('El archivo se ha creado con exito');
  existe:= ExisteDistribucion(arch, 'Ubuntu');
  AltaDistribucion(arch);
  BajaDistribucion(arch);
end.