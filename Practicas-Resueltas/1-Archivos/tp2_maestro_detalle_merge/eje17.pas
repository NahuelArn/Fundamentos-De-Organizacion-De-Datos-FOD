{
  17. Una concesionaria de motos de la Ciudad de Chascomús, posee un archivo con
 información de las motos que posee a la venta. De cada moto se registra: código, nombre,
 descripción, modelo, marca y stock actual. Mensualmente se reciben 10 archivos detalles
 con información de las ventas de cada uno de los 10 empleados que trabajan. De cada
 archivo detalle se dispone de la siguiente información: código de moto, precio y fecha de la
 venta. Se debe realizar un proceso que actualice el stock del archivo maestro desde los
 archivos detalles. Además se debe informar cuál fue la moto más vendida.
 NOTA: Todos los archivos están ordenados por código de la moto y el archivo maestro debe
 ser recorrido sólo una vez y en forma simultánea con los detalles.
 
 }

program eje17;
const
  dimFdetalle = 3;
  valorAlto = 3;
type
  moto = record
    cod: integer;
    nombre: string;
    descripcion: string;
    modelo: string;
    marca: string;
    stockActual: integer;
  end;

  venta = record
    codMoto: integer;
    precio: real;
    fecha: integer;//anho
  end;

  detalle = file of venta;
  maestro = file of moto;

  vectorDetalle = array[1..dimFdetalle]of detalle;
  vectorDetalleRegistro = array[1..dimFdetalle]of venta; 

{Todos los archivos están ordenados por código de la moto y el archivo maestro debe
 ser recorrido sólo una vez y en forma simultánea con los detalles}
procedure actualizarMaestro(var aM: maestro;var vD: vectorDetalle);
  procedure minimo(var vD: vectorDetalle; var vDR: vectorDetalleRegistro;var min: venta);
  var
    pos: integer;
  begin
    min.codMoto:= valorAlto;
    for i:= 1 to dimFdetalle do
      begin
        if(vDR[i].codMoto < min.codMoto)then
          begin
            min:= vDR[i];
            pos: i;
          end;
      end;
    if(min.codMoto <> valorAlto)then
      begin
        min:= vDR[pos];
        leer(vD[pos], vDR[pos]);
      end;
  end;
var 
  vDR: vectorDetalleRegistro;
  rM: moto;
  min: venta;
  codMotoActual,contVentas: integer;
  codMotoMasVendida,max,i: integer;
begin
  minimo(vD,vDR,min);
  reset(aM);
  read(aM, rM);
  max:= -9099;
  while (min.codMoto <> valorAlto) do
    begin
      codMotoActual:= min.codMoto;
      contVentas:= 0;
      while(min.codMoto <> valorAlto) and (codMotoActual = min.codMoto)do
        begin
          contVentas:= contVentas+1;
          minimo(vD,VDR,min);
        end;
      if(contVentas > max)then
        begin
          codMotoMasVendida:= codMotoActual;
          max:= contVentas;
        end;
      while(codMotoActual <> rM.cod)do
        read(aM, rM);
      Seek(aM, filepos(aM)-1);
      write(aM, rM);
      if(not eof(aM))then
        read(aM, rM);
    end;
    writeln('Moto mas vendida: ',codMotoMasVendida);
    for i:= 1 to dimFdetalle do
      close(vD[i]);
    close(aM);
end;


var
  aM: maestro;
  vD: vectorDetalle;
begin
  cargarMaestro(aM);
  cargarVector(vD);
  actualizarMaestro(aM, vD);
end.