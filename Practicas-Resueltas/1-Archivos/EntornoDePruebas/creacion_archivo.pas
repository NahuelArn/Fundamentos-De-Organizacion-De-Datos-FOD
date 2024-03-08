program creacion_archivo;
Type
  alumno = record
    nombre: string;
    edad: integer;
    legajo: integer;
  end;

  siu = file of alumno; //defino el tipo de dato, quiero una archivo alumno
var
  arch_siu_logico: siu;
  nombre_del_archivo_fisico: string;
  alu: alumno;
begin
  Writeln('Ingres el nombre del archivo: '); //creo q es el nombre q va tener el txt (a eso llaman fisico)
  readln(nombre_del_archivo_fisico);
  Assign(arch_siu_logico, nombre_del_archivo_fisico); //Assign ( n_lógico, N_físico)  // aca hace tipo un enlaze supongo
  rewrite(arch_siu_logico); //se crea el archivo y lo abre
  Writeln('Ingrese la edad del alumno (corta con 0): ');//mientras no sea 0, voy cargando el archivo con las edades de alumnos?
  readln(alu.edad);
  while (alu.edad <> 0)do
    begin
      write(arch_siu_logico, alu);  //se escribe en el archivo
      Writeln('Ingrese la edad del alumno (corta con 0): ');
      readln(alu.edad);
    end;
  close(arch_siu_logico);
end.