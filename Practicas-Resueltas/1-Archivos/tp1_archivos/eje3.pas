{Realizar un programa que presente un menú con opciones para:
a. Crear un archivo de registros no ordenados de empleados y completarlo con
datos ingresados desde teclado. De cada empleado se registra: número de
empleado, apellido, nombre, edad y DNI. Algunos empleados se ingresan con
DNI 00. La carga finaliza cuando se ingresa el String ‘fin’ como apellido.
b. Abrir el archivo anteriormente generado y
i. Listar en pantalla los datos de empleados que tengan un nombre o apellido
determinado.
ii. Listar en pantalla los empleados de a uno por línea.
iii. Listar en pantalla empleados mayores de 70 años, próximos a jubilarse.
NOTA: El nombre del archivo a crear o utilizar debe ser proporcionado por el usuario.}

program eje3;
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
  readln(opcion);
  Writeln('Ingrese 2, para listar en pantalla los empledos de a uno por linea');
  readln(opcion);
  Writeln('Ingrese 3, para listar en pantalla empleados mayores de 70 anhos, proximos a jubilarse');
  readln(opcion);
  case opcion of
    1: opcion_1(archivo_logico);
    2: opcion_2(archivo_logico);
    3: opcion_3(archivo_logico);
  end;
  Writeln('-------------------------------------------------------------');
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
    Writeln('Ingrese "C" para salir');
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
      'C': 
      begin
        salida := true; // Si el usuario elige 'C', salimos del bucle
      end;
    else
      begin
        Writeln('!!!!!!!!!!!!!!!!!!!');
        Writeln('Opcion invalida. Ingrese una opcion valida (A, B o C).');
        Writeln('!!!!!!!!!!!!!!!!!!!');
      end;
    end;
  end;
  Writeln('------------------------------------------------------');
end.


