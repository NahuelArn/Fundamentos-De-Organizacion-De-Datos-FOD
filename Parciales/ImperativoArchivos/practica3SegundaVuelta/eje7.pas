program eje7;
const 
  valorAlto = 999;
type
  ave = record
    cod: integer;
    nombreEspecie: string;
    familiaAve: string;
    descripcion: string;
    zonaGeografica: integer;
  end;

  archivo = file of ave;

procedure marcarRegistros(var arch: archivo);
var
  codAliminar: integer;
  r: ave;
  encontrado: boolean;
begin
  writeln('Ingrese el código a eliminar (50000 para finalizar): ');
  readln(codAliminar);
  while codAliminar <> 50000 do
    begin
      encontrado:= false;
      while not eof(arch) and not encontrado do //el encontrado no va si existe repediso se tendria que recorrer completo el archivo
        begin
          read(arch, r);
          if(r.cod = codAliminar)then
            begin
              seek(arch, filePos(arch)-1);
              r.cod:= r.cod-1;
              write(arch, r);
              encontrado:= true; //si existen repetidos esto no va
            end;
        end;
        writeln('Ingrese el código a eliminar (50000 para finalizar): ');
        readln(codAliminar);
        Seek(arch, 0);
    end;
end;

procedure leer(var a: archivo; var r: ave);
begin
  if(not eof(a))then
    read(a, r)
  else
    r.cod:= valorAlto;
end;

procedure borrarCompactar(var arch: archivo);
var
  r,cambiazo: ave;
  pos: integer;
begin
  reset(arch);
  leer(arch,r);
  while r.cod <> valorAlto do
    begin
      if(r.cod < 0)then
        begin
          pos:= filePos(arch)-1;
          seek(arch, FileSize()-1);
          read(arch,cambiazo);
          seek(arch, pos);
          write(arch, cambiazo);
          seek(arch,FileSize(arch)-1);
          truncate(arch);
          Seek(arch, pos);
        end;
      leer(arch,r);
    end;
  close(arch);
end;

var
  arch: archivo;
begin 
  assign(arh, 'binarioYaCargado');
  marcarRegistros(arch);
  borrarCompactar(arch);
end.