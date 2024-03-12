program eje6;

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
  Writeln('Ingrese ¨F¨ para desplegar el nuevo menh del punto 7');
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

procedure mostrar_menu(var opcion: char);
begin
  Writeln('Ingrese ¨A¨ para anhadir uno o mas celulares al final del archivo, con sus datos ingresados por teclad');
  Writeln('Ingrese ¨B¨ para modificar el stock de un celular dado');
  Writeln('Ingrese ¨C¨ para expotar el contenido del archivo a un txt, conaquellos celulares que tegan stock 0 ');
  readln(opcion);
end;

{cod_celular: integer;
    nombre: string;
    descripcion: string;
    marca: string;
    precio: real;
    stock_minimo: integer;
    stock_disponible: integer;}


procedure leer_data(var cel: celular);
begin
  Writeln('Ingrese el nombre: ');
  readln(cel.nombre);
  Writeln('Ingrese la descripcion ');
  readln(cel.descripcion);
  Writeln('Ingrese la marca ');
  readln(cel.marca);
  Writeln('Ingrese el precio ');
  readln(cel.precio);
  Writeln('Ingrese el stock minimo');
  readln(cel.stock_minimo);
  Writeln('Ingrese el stock disponible ');
  readln(cel.stock_disponible);
end;

procedure opcion_nueva_a(var archivo_logico: archivo_celulares);
var
  prosiga: boolean;
  cel: celular;
  estado: char;
begin
  Seek(archivo_logico,SizeOf(archivo_logico));  //quedo posicionado en el final
  prosiga:= true;
  while(prosiga)do
    begin
      // if(prosiga)then //dice uno o mas, 1 minimo va tener
      //   begin
      //     leer_data(cel);
      //     write(archivo_logico,cel);
      //   end;
      leer_data(cel);
      write(archivo_logico,cel);
      Writeln('Ingrese Y o N para seguir agregando celulares.');
      readln(estado);
      prosiga:= (estado = 'Y');
    end;
end;

procedure buscarPos(var archivo_logico: archivo_celulares; var pos: integer; nombre: string);
var
  cel: celular;
begin
  while (((pos = -1)) and not eof (archivo_logico))do  
    begin
      read(archivo_logico, cel);
      if(cel.nombre = nombre)then
        pos:= FilePos(archivo_logico);  //encuentro pos, corta por circuito corto
    end;
end;

procedure opcion_nueva_b(var archivo_logico: archivo_celulares);
var
  nombre: string;
  pos, stock_nuevo: integer;
  cel: celular;
begin
  Writeln('Ingrese el nombre de un celular para modificar el stock de un celular dado');
  readln(nombre);
  pos:= -1;
  buscarPos(archivo_logico,pos,nombre);
  if(pos <> -1)then
    begin
      Writeln('Ingrese a que stock quiere modificar');
      readln(stock_nuevo);
      {podria darse el caso q no se resetee el indice del archivo y lo q  tengo en la vuelta, es el archivo en la pos q paro? me ahorraria la instruccion de buscar por Pos}
      Seek(archivo_logico,pos); //me pos en el lugar donde modificar
      read(archivo_logico,cel);  //me traigo el [celular]
      cel.stock_disponible:= stock_nuevo; //modifico el stock
      Seek(archivo_logico, FilePos(archivo_logico)-1);  //me pos en el lugar indicado por el read+1
      write(archivo_logico,cel);  //guardo el celular con el stock modificado
    end;
end;

procedure opcion_nueva_c(var archivo_logico: archivo_celulares);
var
  texto_logico: text;
  cel: celular;
begin
  Assign(texto_logico, 'SinStock.txt');
  Rewrite(texto_logico);
  while (not eof(archivo_logico))do
    begin
      read(archivo_logico, cel);
      if(cel.stock_disponible <= 0)then //no me acuerdo si resta en alguna parte el stock, en una de esas queda negativo el stock
        begin
          write(texto_logico, 'nombre: ',cel.nombre, 'descripcion: ',cel.descripcion, ' marca: ',cel.marca, ' precio: ',cel.precio,' stock minimo: ',cel.stock_minimo, ' stock disponible: ',cel.stock_disponible);          
        end;
    end;
end;

procedure nuevo_menu(var archivo_logico: archivo_celulares);
var
  opcion: char;
begin
  mostrar_menu(opcion);
  reset (archivo_logico); //abro solo una vez para no estar abriendo, cerrando el archivo en cada modulo
  case opcion of 
    'A': opcion_nueva_a(archivo_logico);
    'B': opcion_nueva_b(archivo_logico);
    'C': opcion_nueva_c(archivo_logico);
  end;
  close(archivo_logico);
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
      'F': nuevo_menu(archivo_logico);
      else
        begin
          WriteLn('Error');
        end;
    end;
end.