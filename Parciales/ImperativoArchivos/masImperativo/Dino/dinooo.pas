program dinooo;
type
  tipo = record
    cod: integer;
    tipoDeDino: integer;
    altura: real;
    pesoPromedio: real;
    descripcion: integer;
    zonaGeografica: string;
  end;
  
  archivo = file of tipo;

procedure bajaLogica(var arch: archivo; codAliminar:integer ;var encontrado: boolean);
var
  posEliminada: integer;
  cabecera,t: tipo;
begin
  reset(arch);
  encontrado:= false;
  read(arch, cabecera);
  while (not eof(arch) and (not encontrado))do
    begin
      read(arch, t);
      encontrado:= codAliminar = t.cod;
    end;
  if(encontrado)then
    begin
      seek(arch, filePos(arch)-1);
      posEliminada:= filePos(arch) * -1;
      write(arch, cabecera);
      cabecera.cod:= posEliminada;
      seek(arch,0);
      write(arch,cabecera);
    end;
  Close(arch);
end;

procedure altaLogica(var arch: archivo; dino: tipo);
var
  cabecera: tipo;
  
begin
  reset(arch);
  read(arch, cabecera);
  if(cabecera.cod < 0)then
    begin
      seek(arch, cabecera.cod*-1);
      read(arch,cabecera);
      seek(arch, filePos(arch)-1);
      write(arch, dino);
      seek(arch, 0);
      write(arch,cabecera);
    end
  else
    begin
      seek(arch, fileSize(arch));
      write(arch, dino);
    end;
  close(arch);
end;

procedure obtenerListado(var arch: archivo; var txt: text);
var
  t: tipo;
  cabecera: tipo;
begin
  reset(arch);
  read(arch,cabecera);
  if(cabecera.cod < 0)then
    begin
      while(not eof(arch))do
        begin
          read(arch,t);
          if(t.cod > 0)then
            begin
              writeln(txt, t.cod, t.tipoDeDino, t.altura, t.pesoPromedio, t.descripcion, t.zonaGeografica);
            end;
        end;  
    end;
  close(arch);
  close(txt);
end;

var
  arch: archivo;
  codAEliminar: integer;
  encontrado: boolean
  dino: tipo;
  txt: text;
begin
  assign(arch, 'yaCargado');
  assign(txt, 'archivoTexto.txt');
  writeln('Ingrese los codigos de los dinos a eliminar');
  writeln('0 para cortar');
  readln(codAEliminar);
  while(codAliminar <> 0) do
    begin
      bajaLogica(arch,codAliminar,encontrado);
      if (not encontrado) then
        Writeln('ese codigo de dino no estaba en el archivo')
      else
        Writeln('Se elimino correctamente');
      readln(codAEliminar);
    end;
  cargaDino(dino); //me retorna un dino cargado
  altaLogica(arch,dino);
  rewrite(txt);
  obtenerListado(arch,txt);
end.
