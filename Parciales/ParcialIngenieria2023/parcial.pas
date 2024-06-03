//0:03
//lista invertida
//
program parcial;
type
  profesional = record 
    dni: integer;
    nombre: string;
    apellido: string;
    sueldo: real;
  end;

  tArchivo = file of profesional;

procedure inicializoCabecera(var p: profesional);
begin
  p.dni:= 0;
  p.nombre:= '';
  p.apellido:= '';
  p.sueldo:= 0.0;
end;

//me pasan un txt con la data y la tengo que pasar al binario
procedure crear(var arch: tArchivo;var info: txt);
var
  p: profesional;
begin
  rewrite(arch);  //creo el arch, q no esta creado
  reset(info);  //abro el arch que me dice que ya tengo
  inicializoCabecera(p);
  write(arch, p);
  while not eof(info)do
    begin
      readln(txt, p.dni);
      readln(txt, p.nombre);
      readln(txt, p.apellido);
      readln(txt, p.sueldo);
      write(arch, p);
    end;
  close(arch);
  close(info);
end;
//me pasan el archivo cerrado
procedure agregar(var arch: tArchivo; var p: profesional);
var
  cabecera,swap: profesional;
begin
  reset(arch);
  read(arch,cabecera);
  if(cabecera.dni < 0)then
    begin
      seek(arch, filePos(cabecera.dni*-1));
      read(arch,swap);
      Seek(arch, FilePos(arch)-1);
      write(arch,p);
      Seek(arch, 0);
      write(swap);
    end
  else
    begin
      seek(arch,FileSize(arch));
      write(arch,p)
    end;
  Close(arch);
end;

procedure eliminar(var arch: tArchivo; dni: integer);
var 
  p,cabecera: profesional;
  encontre: boolean;
  pos: integer;
begin
  reset(arch);
  encontre:= false;
  read(arch,cabecera);
  while (not eof(arch)) and (not encontre) do
    begin
      read(arch,p);
      if(p.dni > 0 and p.dni = dni)then
        encontre:= true;
    end; 
  if(encontre)then
    begin
      pos:= filePos(arch)-1;
      Seek(arch, pos);
      write(arch,cabecera);
      Seek(arch, 0);
      cabecera.dni:= pos*-1;
      write(arch,cabecera);
    end
  else
    begin
      Writeln('El dni ha eliminar no se encontraba en el archivo');
    end;
  Close(arch);
end;

var
  arch: tArchivo;
  info: txt;
begin
  assing(arch,'archivoBinario');
  assing(info,'textoConInfo.txt');
  crear(arch,info);
end.