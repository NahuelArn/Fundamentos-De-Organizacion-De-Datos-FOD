{
   Realizar un programa que genere un archivo de novelas filmadas durante el presente
    año. De cada novela se registra: código, género, nombre, duración, director y precio.
    El programa debe presentar un menú con las siguientes opciones

    a. Crear el archivo y cargarlo a partir de datos ingresados por teclado. Se
 utiliza la técnica de lista invertida para recuperar espacio libre en el
 archivo. Para ello, durante la creación del archivo, en el primer registro del
 mismo se debe almacenar la cabecera de la lista. Es decir un registro
 ficticio, inicializando con el valor cero (0) el campo correspondiente al
 código de novela, el cual indica que no hay espacio libre dentro del
 archivo.
 b. Abrir el archivo existente y permitir su mantenimiento teniendo en cuenta el
 inciso a., se utiliza lista invertida para recuperación de espacio. En
 particular, para el campo de ´enlace´ de la lista, se debe especificar los
 números de registro referenciados con signo negativo, (utilice el código de
 novela como enlace).Una vez abierto el archivo, brindar operaciones para:
      i. Dar de alta una novela leyendo la información desde teclado. Para
        esta operación, en caso de ser posible, deberá recuperarse el
        espacio libre. Es decir, si en el campo correspondiente al código de
        novela del registro cabecera hay un valor negativo, por ejemplo-5,
        se debe leer el registro en la posición 5, copiarlo en la posición 0
        (actualizar la lista de espacio libre) y grabar el nuevo registro en la
        posición 5. Con el valor 0 (cero) en el registro cabecera se indica
        que no hayespacio libre.
     ii. Modificar los datos de una novela leyendo la información desde
        teclado. El código de novela no puede ser modificado.
     iii. Eliminar una novela cuyo código es ingresado por teclado. Por
        ejemplo, si se da de baja un registro en la posición 8, en el campo
        código de novela del registro cabecera deberá figurar-8, y en el
        registro en la posición 8 debe copiarse el antiguo registro cabecera.
        c. Listar en un archivo de texto todas las novelas, incluyendo las borradas, que
        representan la lista de espacio libre. El archivo debe llamarse “novelas.txt”. En
 NOTA: Tanto en la creación como en la apertura el nombre del archivo debe ser
 proporcionado por el usuario
}



program eje3;

const
  valor_alto = 9999;
type
  novelas = record
    codigo: integer;
    genero: string;
    nombre: string;
    duracion: integer;
    director: string;
    precio: real;
    enlace: integer;
  end;
  archivo = file of novelas;

procedure leer_novela(var n: novelas);
begin
  Writeln('Ingrese 0 para finalizar la carga de novelas');
  WriteLn('Ingrese el codigo de la novela');// (utilice el código de novela como enlace)
  ReadLn(n.codigo);
  if(n.codigo <> 0)then
    begin
      WriteLn('Ingrese el genero de la novela');
      ReadLn(n.genero);
      WriteLn('Ingrese el nombre de la novela');
      ReadLn(n.nombre);
      WriteLn('Ingrese la duracion de la novela');
      ReadLn(n.duracion);
      WriteLn('Ingrese el director de la novela');
      ReadLn(n.director);
      WriteLn('Ingrese el precio de la novela');
      ReadLn(n.precio);
    end;
end;

procedure modulo_a(var arch: archivo);
  procedure inicializar_vacio(var arch: archivo);
  var
    n: novelas;
  begin
    n.codigo:= 0; //se pdejar solo los campos necesarios y lo demas dejarlo con basura
    n.genero:= '';
    n.nombre:= '';
    n.duracion:= 0;
    n.director:= '';
    n.precio:= 0;
    n.enlace:= 0;
    write(arch, n);
  end;
var
  n: novelas;
  direccion_inmutable: string;
  direccion_mutable: string;
begin
  Writeln('Ingrese el nombre para el archivo ');
  readln(direccion_mutable);
  direccion_inmutable:= 'D:\Codigo\Fundamentos-De-Organizacion-De-Datos-FOD\Practicas-Resueltas\1-Archivos\tp3_bajas_archivos_secuenciales\eje3\archivo\';
  direccion_mutable:= direccion_inmutable+direccion_mutable;
  assign(arch, direccion_mutable);
  rewrite(arch);
  inicializar_vacio(arch);  //creo la cabecera 
  leer_novela(n);
  while(n.codigo <> 0)do
    begin
      write(arch, n);
      leer_novela(n);
    end;
  close(arch);
end;

procedure modulo_alta_i(var arch: archivo);
var
  n,novela_alta: novelas;
  n_aux: novelas;
begin
  leer_novela(novela_alta);
  read(arch, n);  //leo cabecera
  if(n.codigo = 0)then  //si no hay un espacio libre, lo inserto al final
    begin
      Seek(arch, FilePos(arch));
      write(arch, novela_alta);
    end
  else  //si hay un espacio libre, lo inserto en la posicion que me indica la cabecera
    begin
      Seek(arch, n.codigo *-1);
      read(arch, n_aux);  //me guardo el archivo que esta en la posicion que me indica la cabecera
      Seek(arch, FilePos(arch) -1); //vuelvo a la posicion donde apuntaba la cabecera
      write(arch, novela_alta);  //escribo el nuevo archivo
      Seek(arch, 0);
      write(arch, n_aux);  //actualizo la cabecera con lo que estaba en la posicion que me indicaba la cabecera
    end;
end;

procedure modulo_modificar_ii(var arch: archivo);
var 
  n: novelas;
  encontrado: Boolean;
  codigo: integer;
begin
  encontrado:= false;
  Seek(arch, 1);
  Writeln('Ingrese el codigo de la novela a modificar');
  ReadLn(codigo);
  while (not eof(arch) and not encontrado)do
    begin
      read(arch, n);
      if(n.codigo = codigo)then
        begin
          encontrado:= true;
          leer_novela(n);
          Seek(arch, FilePos(arch) -1);
          write(arch, n);
        end;
    end;
  if(encontrado)then
    Writeln('Se ha encontrado la novela')
  else
    Writeln('No se ha encontrado la novela');
end;

procedure leerArch (var n: archivo; var novel: novelas);
  begin
    if not eof(n) then
      read(n, novel)
    else
      novel.codigo:= valor_alto;
end;

procedure modulo_eliminar_novela_iii(var arch: archivo);
var
  n,cabecera: novelas;
  cod_eliminar,pos,pos_eliminada_signo,puntero_cabecera: integer;
  sigo: Boolean;
begin
  Writeln('Ingrese el codigo de la novela a eliminar');
  readln(cod_eliminar);
  sigo:= false;
  Seek(arch, 1);
  leerArch(arch, n);
  while((n.codigo <> valor_alto) and (not sigo))do
    begin
      if(n.codigo = cod_eliminar)then
        begin
          sigo:= true;
          pos:= filePos(arch) - 1; //me paro en la pos, donde estaba la novela a eliminar
          pos_eliminada_signo:= pos * -1;  //le cambio el signo para indicar que esta eliminado
          seek(arch, 0);  //me posiciono en la cabecera
          read(arch, cabecera);//leo
          seek(arch, filePos(arch) - 1);  //VUELVO A LA CABECERA
          puntero_cabecera:= cabecera.codigo; //me guardo lo que estaba apuntando la cabecera

          cabecera.codigo:= pos_eliminada_signo;  //actualizo la cabecera
          write(arch, cabecera);
          seek(arch, pos); //vuelvo a la posicion donde estaba la novela a eliminar
          Read(arch, n);
          n.codigo:= puntero_cabecera;  //hago que apunte al registro que estaba apuntando la cabecera
          seek(arch, filePos(arch) - 1);
          write(arch, n);
        end
      else
        leerArch(arch, n);
    end;
end;


procedure modulo_b(var arch: archivo);
var
  opcion: char;
begin
  //este modulo gestiona la apertura y cerrado para cualquiera de las 3 operaciones
  WriteLn('Ingrese la opcion deseada');
  WriteLn('1. Dar de alta una novela leyendo la información desde teclado');
  WriteLn('2. Modificar los datos de una novela leyendo la información desde teclado');
  WriteLn('3. Eliminar una novela cuyo código es ingresado por teclado');
  ReadLn(opcion);
  Reset(arch);
  case opcion of 
    '1':
      begin
        modulo_alta_i(arch);//alta();
      end;
    '2':
      begin
        modulo_modificar_ii(arch);//modificar();
      end;
    '3':
      begin
        modulo_eliminar_novela_iii(arch);//eliminar();
      end;
  end;
  close(arch);
end;

procedure modulo_c(var arch: archivo);
var
  direccion_inmutable: string;
  novel: Text;
  novela: novelas;
begin
  direccion_inmutable:= 'D:\Codigo\Fundamentos-De-Organizacion-De-Datos-FOD\Practicas-Resueltas\1-Archivos\tp3_bajas_archivos_secuenciales\eje3\archivo\novelas.txt';
  assign(novel, direccion_inmutable);
  rewrite(novel);
  reset(arch);
  seek(arch, 1);
  leerArch(arch, novela);
  while(novela.codigo <> valor_alto)do
    begin
      writeln(novel, ' codigo: ',novela.codigo, ' genero: ',novela.genero, ' nombre: ',novela.nombre, ' duracion: ',novela.duracion, ' director: ',novela.director, ' precio: ',novela.precio);
      leerArch(arch, novela);
    end;
  Close(novel);
  Close(arch);
end;

var
  opcion: char;
  sigo: Boolean;
  arch: archivo;
begin
  //cada mudlo es el encargado de abrir y cerrrar 
  WriteLn('a. Crear el archivo y cargarlo a partir de datos ingresados por teclado');
  WriteLn('b. Abrir el archivo existente y permitir su mantenimiento');
  WriteLn('c. Listar en un archivo de texto todas las novelas');
  sigo:= true;
  WriteLn('Ingrese la opcion deseada, "F" para terminar el programa');
  ReadLn(opcion);
  while sigo do
    begin
      case opcion of 
      'A':
        begin
          modulo_a(arch);
        end;
      'B':
        begin
          modulo_b(arch);
        end;
      'C':
        begin
          modulo_c(arch);
        end;
      'F':
        begin
          WriteLn('Fin del programa');
          sigo:= False;
        end;
    end;
    if(sigo)then
      begin
        WriteLn('a. Crear el archivo y cargarlo a partir de datos ingresados por teclado');
        WriteLn('b. Abrir el archivo existente y permitir su mantenimiento');
        WriteLn('c. Listar en un archivo de texto todas las novelas');
        WriteLn('Ingrese la opcion deseada, "F" para terminar el programa');
        ReadLn(opcion);
      end;
  end;
end.