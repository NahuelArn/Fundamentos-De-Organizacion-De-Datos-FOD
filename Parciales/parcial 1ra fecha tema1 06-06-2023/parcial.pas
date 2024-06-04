program parcial;
type
  producto = record
    codProducto: integer; //univoco
    nombreProducto: string;
    descripcion: string;
    precioDeCompra: real;
    precioDeVenta: real;
    ubicacionEnDePosito: string;
  end;

  pArchivo = file of producto;

procedure leerData(var p: producto);
begin
  readln(p.codProducto);
  readln(p.nombreProducto);
  readln(p.descripcion);
  readln(p.precioDeCompra);
  readln(p.precioDeVenta);
  readln(p.ubicacionEnDePosito);
end;

procedure agregarProducto(var arch: pArchivo);
var
  pActual: producto;
  cabecera: producto;
begin
  leerData(pActual);
  if(not existeArchivo(arch,pActual.codProducto))then //asumo que lo abre y cierra ahi
    begin
      reset(arch);
      read(arch,cabecera);  //leo cabecera
      if(not cabecera.codProducto > -1)then //puedo reutilizar
        begin
          seek(arch,cabecera.codProducto*-1);
          read(arch,cabecera);
          Seek(arch, FilePos(arch)-1);
          write(pActual);
          seek(arch, 0);
          write(cabecera);
        end
      else  //no hay un espacio para reutilizar
        begin
          seek(arch, filePos(arch));
          write(arch,pActual);
        end;
      Close(arch);
    end
  else
    Writeln('Ya se encontraba ese codigo en el archivo');
end;

procedure quitarProducto(var arch: pArchivo);
var
  pBuscado,pActual: producto;
  cabecera: producto;
  encontrado: boolean;
  falsoEnlace: integer;
begin
  leerData(pBuscado);
  reset(arch);
  encontrado: false;
  read(arch,cabecera);
  while(not eof (arch) and (not encontrado))do
    begin
      read(arch, pActual);
      if(pActual.codProducto = pBuscado.codProducto)then
        encontrado:= true;
    end;
  if(encontrado)then
    begin
      Seek(arch, FilePos(arch)-1);
      falsoEnlace:= FilePos(arch);
      write(arch,cabecera);
      cabecera.codProducto:= falsoEnlace*-1;
      Seek(arch,0);
      write(cabecera);
    end
  else 
    Writeln('No existe ese codigo en el archivo');
  close(arch);
end;

var
  arch: pArchivo;
begin
  assig(arch, 'yaSeCargo');
  agregarProducto(arch);
  quitarProducto(arch);
end.