program parcial;
type
  empleado = record
    dni: integer;
    nombre: string;
    apellido: string;
    edad: integer;
    domicilio: string;
    fecha_nacimiento: integer;
  end;

  eArchivo = file of empleado;

procedure solicitarDatos(var e: empleado);
begin
  readln(e.dni);  
  readln(e.nombre);
  readln(e.apellido);
  readln(e.edad);
  readln(e.domicilio);
  readln(e.fecha_nacimiento);
end;

procedure agregarEmpleado(var arch: eArchivo);
var
  e,cabecera,swap: empleado;
begin
  reset(arch);
  solicitarDatos(e);
  read(arch,cabecera);  //leo cabecera
  if (not existeEmpleado(arch,e.dni))then
    begin
      if(cabecera.dni < 0)then
        begin
          seek(arch, filePos(cabecera.dni*-1)); //voy donde hay un espacio libre(marcado)
          read(arch,swap);  //(leo lo que esta ahi, podria ser el siguiente eliminado o 0)
          seek(arch,filePos(arch)-1);//vuelvo 1 para atras
          write(arch,e); //agrego al nuevo empleado
          seek(arch,0); //vuelvo a la cabecera
          write(arch,swap); //escribo la cabecera con lo que habia en la pos marcada
        end
      else
        begin
          seek(arch,FileSize);
          write(arch, e);
        end;
    end
  else
    writeln('El empleado ya existe en el archivo');
  close(arch);
end;

procedure quitarEmpleado(var arch: eArchivo);
var
  cabecera,eliminado,e,lectura: empleado;
  pos: integer;
  encontre: Boolean;
begin
  reset(arch);
  read(arch,cabecera);
  solicitarDatos(e);
  if(existeEmpleado(arch,e.dni))then
    begin
      seek(arch,1);
      encontre:= false;
      while(not eof (arch) and (not encontre))do  //el not eof, taria al pedo si estoy aca se que esta
        begin
          read(arch,lectura);
          if(e.dni = lectura.dni)then
            encontre := true;
        end;
        if(encontre)then //ta al pedo preguntar, si o si lo voy a encontrar saliendo del while
          begin
            seek(arch,FilePos(arch)-1); //me acomodo donde esta el empleado ha eliminar
            pos:= filePos(arch);  //me guardo su pos
            read(arch,eliminado);//
            eliminado.dni:= pos*-1;
            Seek(arch,filePos(arch)-1);
            write(arch,cabecera);
            Seek(arch, 0);
            write(arch,eliminado);
          end;
    end
  else
    Writeln('El empleado no existia');
  close(arch);
end;

var
  arch: eArchivo;
begin
  //suponga que tiene un archivo con informacion referente a los empleados..
  assig(arch, 'infoYacargada');
  agregarEmpleado(arch);
  quitarEmpleado(arch);
end.