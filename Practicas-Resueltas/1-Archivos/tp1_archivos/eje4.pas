{Agregar al menú del programa del ejercicio 3, opciones para:
a. Añadir uno o más empleados al final del archivo con sus datos ingresados por
teclado. Tener en cuenta que no se debe agregar al archivo un empleado con
un número de empleado ya registrado (control de unicidad).
b. Modificar edad a uno o más empleados.
c. Exportar el contenido del archivo a un archivo de texto llamado
“todos_empleados.txt”.
d. Exportar a un archivo de texto llamado: “faltaDNIEmpleado.txt”, los empleados
que no tengan cargado el DNI (DNI en 00).
NOTA: Las búsquedas deben realizarse por número de empleado.}


program eje4;
type
  empleado = record
    apellido: string;
    nombre: string;
    num_empleado: integer;
    edad: integer;
    dni: integer;
  end;

  archivo = file of empleado;

procedure leer_data(var empl: empleado);
begin
  Writeln('Ingrese el apellido ');
  readln(empl.apellido);
  if(empl.apellido <> 'fin')then
    begin
       Writeln('Ingrese el nombre');
       readln(empl.nombre);
       Writeln('Ingrese el numero de empleado ');
       readln(empl.num_empleado);
       Writeln('Ingrese la edad ');
       readln(empl.edad);
       Writeln('Ingrese el dni ');
       readln(empl.dni);
    end;
end;

procedure opcion_a(var archivo_logico: archivo);
var
  empl: empleado;
  nombre_fisico: string;
begin
  Writeln('Ingrese el nombre que va llevar el archivo');
  readln(nombre_fisico);
  Assign(archivo_logico, nombre_fisico);
  rewrite(archivo_logico);  //crea el archivo y lo abre
  // reset(archivo_logico); //el reset solo me sirve para abrir cuando ya tengo el archivo creado, con el rewrite ya lo abre y lo crea
  leer_data(empl);
  while(empl.apellido <> 'fin')do
    begin
      write(archivo_logico,empl);
      leer_data(empl);
    end;
  close(archivo_logico);
end;

procedure imprimir_empleado(e: empleado);
begin
  Writeln('Apellido: ',e.apellido);
  Writeln('Nombre: ',e.nombre);
  Writeln('Numero de empleado: ',e.num_empleado);
  Writeln('Edad: ',e.edad);
  Writeln('Dni: ',e.dni);  
end;

procedure opcion_1(var archivo_logico:archivo);
var
  determinado: string;
  empl: empleado;
begin
  Writeln('Ingrese la palabra determinada que tiene q matchear con el apellido y nombre');
  readln(determinado);
  reset(archivo_logico);
  while not eof(archivo_logico)do
    begin
      read(archivo_logico,empl);
      if(empl.nombre = determinado) and (empl.apellido = determinado)then
        imprimir_empleado(empl);
    end;
  close(archivo_logico);
end;

procedure opcion_2(var archivo_logico:archivo);
var
  empl: empleado;
begin
  //Listar en pantalla los empleados de a uno por línea.
  reset(archivo_logico);
  while not eof(archivo_logico)do
    begin
      read(archivo_logico,empl);
      imprimir_empleado(empl);
    end;
  close(archivo_logico);
end;

procedure opcion_3(var archivo_logico: archivo);
var
  empl: empleado;
begin
//Listar en pantalla empleados mayores de 70 años, próximos a jubilarse.
  reset(archivo_logico);
  while not eof(archivo_logico)do
    begin
      read(archivo_logico,empl);
      if(empl.edad > 70)then
        imprimir_empleado(empl);
    end;
  close(archivo_logico);
end;

procedure opciones_b(var archivo_logico: archivo);
var
  opcion: integer;
begin
  Writeln('--------------------------------------------------------------');
  Writeln('Ingrese 1, para listar los datos de empleados que tengan un nombre preterminado');
  Writeln('Ingrese 2, para listar en pantalla los empledos de a uno por linea');
  Writeln('Ingrese 3, para listar en pantalla empleados mayores de 70 anhos, proximos a jubilarse');
  Writeln('Ingrese 4, para ');
  readln(opcion);
  
  case opcion of
    1: opcion_1(archivo_logico);
    2: opcion_2(archivo_logico);
    3: opcion_3(archivo_logico);
  end;
  Writeln('-------------------------------------------------------------');
end;

//--------------aa-----------------------------
procedure existe_el_empleado(var archivo_logico: archivo; var ok:Boolean; num_empleado: integer);
var
  empl: empleado;
  sigo: Boolean;
begin
  sigo:= true; //aca no abro el archivo por q vendria a ser un sub sub modulo, ya lo abri en el modulo anterior
  while not eof(archivo_logico) and (sigo)do
    begin
      read(archivo_logico, empl);
      if(empl.num_empleado = num_empleado)then
        sigo:= false;
    end;
  ok:= sigo;
end;

procedure opcion_aa(var archivo_logico: archivo);
var 
  emp: empleado;
  ok,sigo: boolean;
  aux: string;
begin
  ok:= false; //no hago reset, porq va estar abierto el archivo hasta que den a la opcion C
  sigo:= true;  //pincho el comentario de arriba
  reset(archivo_logico);
  while (sigo) and not(ok)do
    begin
      leer_data(emp);
      existe_el_empleado(archivo_logico,ok,emp.num_empleado);  //reasigno condicion booleana
      if not(ok)then
        begin
          Writeln('Se va ha agregar al archivo el empleado leido.');
          Seek(archivo_logico, FileSize(archivo_logico));
          write(archivo_logico,emp);
        end;
      Writeln('Ingresar true o false, dependiendo si quiere seguir cargando data');
      readln(aux);
      sigo:= (aux = 'true');
    end;
  close(archivo_logico);
end;
{b. Modificar edad a uno o más empleados.}
procedure buscar_modificar(var archivo_logico:archivo; num_busqueda: integer);
var
  empl: empleado;
begin
  while not eof(archivo_logico)do
    begin
      read(archivo_logico,empl);
      if(empl.num_empleado = num_busqueda)then
        begin
          Writeln('Ingrese a que edad, desea modificar');
          readln(empl.edad);
          write(archivo_logico,empl);
        end;
    end;
end;

procedure opcion_bb(var archivo_logico: archivo);
var
  num_busqueda: integer;
  prosiga: boolean;
  aux: string;
begin
  prosiga:= true;
  reset(archivo_logico);
  while(prosiga)do
    begin
      Writeln('Ingresa un numero de empleado al cual modificar su edad');
      readln(num_busqueda);
      buscar_modificar(archivo_logico,num_busqueda);
      Writeln('Ingrese true, false para salir');
      readln(aux);
      prosiga:= aux = 'true';
    end;
  Close(archivo_logico);
end;

{c. Exportar el contenido del archivo a un archivo de texto llamado
“todos_empleados.txt”.}
procedure opcion_cc(var archivo_logico: archivo);
var 
  archivo_nuevo: text;
  empl: empleado;
begin
  reset(archivo_logico);
  Assign(archivo_nuevo, 'todos_empleados.txt');
  rewrite(archivo_logico);
  while not eof(archivo_logico)do
    begin
      read(archivo_logico,empl);  //obtengo
      // write(archivo_nuevo, empl);  //escribo[NO ANDO]    //puede no andar ya que es un txt, no sabe q es un registro, tendria sentido q no ande --------+++++++++++++++++++--------------------
      write(archivo_nuevo, {cargo campo x campo}'Apellido: ',empl.apellido, 'Nombre: ',empl.nombre, 'Numero de empleado: ',empl.num_empleado, ' Edad empleado: ',empl.edad, ' Ingrese dni: ',empl.dni, ' | ');
    end;
  close(archivo_logico);
  close(archivo_nuevo);
end;

{Exportar a un archivo de texto llamado: “faltaDNIEmpleado.txt”, los empleados
que no tengan cargado el DNI (DNI en 00).}

procedure opcion_dd(var archivo_logico: archivo);
var
  archivo_texto: text;
  empl: empleado;
begin
  reset(archivo_logico);
  Assign(archivo_texto, 'faltaDniEmpleado.txt');
  rewrite(archivo_texto);
  while not eof(archivo_logico)do
    begin
      read(archivo_logico, empl);
      if(empl.dni = 00)then
        // write(archivo_texto, empl); //mismo problema de antes
        write(archivo_texto, 'Apellido: ',empl.apellido, 'Nombre: ',empl.nombre, 'Numero de empleado: ',empl.num_empleado, ' Edad empleado: ',empl.edad, ' Ingrese dni: ',empl.dni, ' | ');
    end;
  close(archivo_logico);
  close(archivo_texto);
end;

var
  archivo_logico: archivo;
  salida: boolean;
  opcion: char;
begin
  salida:= false;
  Writeln('------------------------------------------------------');
  while not(salida) do
  begin
    Writeln('Ingrese una opcion');
    Writeln();
    Writeln('Ingrese "A" para crear un archivo, con datos de empleados leidos por teclado');
    Writeln('Ingrese "B" para abrir el archivo anteriormente generado');
    Writeln('Ingrese "C" para anhadir uno o mas empleados al final del archivo con sus datos ingresados por teclado'); //controlar unicidad
    Writeln('Ingrese "D" para modificar a uno o mas empleados');
    Writeln('Ingrese "E" para exportar el contenido del archivo a un archivo de texto llamado "todos_empleados.txt"');
    Writeln('Ingrese "F" para exportar un nuevo archivo de texto con los empleados sin el dni 00');
    Writeln('Ingrese "G" para salir');
    readln(opcion); // Debes leer la opción nuevamente después de mostrar las opciones al usuario
    case opcion of  //EL Case lleva un enddddddddddddddddddddd
      'A': 
      begin
        opcion_a(archivo_logico);
      end;
      'B':
      begin
        opciones_b(archivo_logico);
      end;
      'C': //agregado --------------------------------------
        begin
          opcion_aa(archivo_logico);
        end;
      'D':
        begin
          opcion_bb(archivo_logico);
        end;
      'E':
        begin
          opcion_cc(archivo_logico);
        end;
      'F':
        begin
          opcion_dd(archivo_logico);
        end;  //--------------------------------------
      'G': 
        begin
          salida := true; // Si el usuario elige 'G', salimos del bucle
        end;
    else
      begin
        Writeln('!!!!!!!!!!!!!!!!!!!');
        Writeln('Opcion invalida. Ingrese una opcion valida (A, B, C, D, E, F o G).');
        Writeln('!!!!!!!!!!!!!!!!!!!');
      end;
    end;
  end;
  Writeln('------------------------------------------------------');
end.

