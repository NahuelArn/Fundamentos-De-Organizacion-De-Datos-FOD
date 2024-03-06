
program mostrar_archivo;
Type
  alumno = record
    nombre: string;
    edad: integer;
    legajo: integer;
  end;

  siu = file of alumno; //defino el tipo de dato, quiero una archivo alumno

procedure imprimir_archivo(var arch_siu_logico: siu); //es necesario pasarlo por referencia?? //no compila si no es por var
var
  alu: alumno;
  i: integer;
begin
  i:= 0;
  reset(arch_siu_logico); //abrimos el archivo ya creado, para operar deber abrise de lectura/escritura
  while not eof(arch_siu_logico)do //mientras no llegue al final del archivo
    begin
      i:= i+1;
      read(arch_siu_logico, alu);
      writeln('edad en la pos: ', i, ': [ ',alu.edad,' ]' );
    end;
    close(arch_siu_logico);
end;

var
  arch_siu_logico: siu;
  nombre_del_archivo_fisico: string;
  alu: alumno;
begin
  Writeln('Ingres el nombre del archivo: '); //creo q es el nombre q va tener el txt (a eso llaman fisico)
  readln(nombre_del_archivo_fisico);
  Assign(arch_siu_logico, nombre_del_archivo_fisico); //Assign ( n_lógico, N_físico)  // aca hace tipo un enlaze supongo, entre lo logico y el nombre fisico 
  rewrite(arch_siu_logico); //se crea el archivo
  Writeln('Ingrese la edad del alumno (corta con 0): ');//mientras no sea 0, voy cargando el archivo con las edades de alumnos?
  readln(alu.edad);
  while (alu.edad <> 0)do
    begin
      write(arch_siu_logico, alu);  //se escribe en el archivo
      Writeln('Ingrese la edad del alumno (corta con 0): ');
      readln(alu.edad);
    end;
  close(arch_siu_logico); //cerrar archivo

  //------------------------------------Imprimir_Archivo-----------------------------------
  imprimir_archivo(arch_siu_logico);  //se podria decir que funciona como un vector, "el archivo" guarda todo en binario, No en texto plano como un txt
end.