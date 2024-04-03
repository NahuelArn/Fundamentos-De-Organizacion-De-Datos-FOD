{

  15. Se desea modelar la información de una ONG dedicada a la asistencia de personas con
  carencias habitacionales. La ONG cuenta con un archivo maestro conteniendo información
  como se indica a continuación: Código pcia, nombre provincia, código de localidad, nombre
  de localidad, #viviendas sin luz, #viviendas sin gas, #viviendas de chapa, #viviendas sin
  agua,# viviendas sin sanitarios. 

  Mensualmente reciben detalles de las diferentes provincias indicando avances en las obras
  de ayuda en la edificación y equipamientos de viviendas en cada provincia. La información
  de los detalles es la siguiente: Código pcia, código localidad, #viviendas con luz, #viviendas
  construidas, #viviendas con agua, #viviendas con gas, #entrega sanitarios.
  Se debe realizar el procedimiento que permita actualizar el maestro con los detalles
  recibidos, se reciben 10 detalles. Todos los archivos están ordenados por código de
  provincia y código de localidad. 

  Para la actualización se debe proceder de la siguiente manera: 
  1. Al valor de vivienda con luz se le resta el valor recibido en el detalle.
  2.  Idem para viviendas con agua, gas y entrega de sanitarios.
  3.    A las viviendas de chapa se le resta el valor recibido de viviendas construidas

  La misma combinación de provincia y localidad aparecen a lo sumo una única vez.
  Realice las declaraciones necesarias, el programa principal y los procedimientos que
  requiera para la actualización solicitada e informe cantidad de localidades sin viviendas de
  chapa (las localidades pueden o no haber sido actualizadas).
}
program eje15;
const
  dimFdetalle = 3;
  valorAlto = 999;
type
  sinVivienda = record
    sinLuz: integer;
    sinGas: integer;
    deChapa: Integer;
    sinAgua: integer;
    sinSanitarios: integer;
  end;
  maestro = record
    codProvincia: integer;
    nombreProvincia: string;
    codLocalidad: integer;
    nombreLocalidad: string;
    v: sinVivienda;
  end;
  //------------------------------------
  conVivienda = record
    conLuz: integer;
    conGas: integer;
    conAgua: integer;
    cantConstruidas: integer;
    viviendasConAgua: integer;
    cantEntregaSanitarios: integer;
  end;
  detalle = record
    codProvincia: integer;
    codLocalidad: integer;
    c: conVivienda;
  end;

  archMaestro = file of maestro;
  archDetalle = file of detalle;

  vectorDetalle = array[1..dimFdetalle]of archDetalle;
  vectorDetalleRegistros = array[1..dimFdetalle]of detalle;

procedure cargarMaestro(var aM:archMaestro);
begin
end;

procedure cargarDetalle(var vD: vectorDetalle);
begin
  
end;

procedure actualizarMaestro(var aM: archMaestro;var vD: vectorDetalle);
  
  procedure leerPrimeraVez(var vD: vectorDetalle;var vDR: vectorDetalleRegistros);
  var i: integer;
  begin
    for i:= 1 to dimFdetalle do
      begin
        reset(vD[i]);
        read(v[i], vDR[i]);
      end;
  end;

  procedure leer(var archivo: archDetalle; var dato:detalle );
  begin
    if(not eof(archivo))then
      read(archivo, dato)
    else
      begin
        dato.codProvincia:= valorAlto;
        dato.codLocalidad:= valorAlto;
      end;
  end;

  {Todos los archivos están ordenados por código de
  provincia y código de localidad. }
  procedure minimo(var vD: vectorDetalle; var vDR: vectorDetalleRegistros; var min: detalle);
  var 
    i,pos: integer;
  begin  
    min.codProvincia:= valorAlto;
    min.codLocalidad:= valorAlto;
    for i := 1 to dimFdetalle do
      begin
        if(vDR[i].codProvincia < min.codProvincia) and (min.codLocalidad < min.codLocalidad)then
          begin
            min:= vDR[i];
            pos: i;
          end;
      end;
      if(min.codProvincia <> valorAlto) and (min.codLocalidad <> valorAlto)then
        begin
          min:= vDR[pos];
          leer(vD[pos], vDR[pos]);
        end;
  end;

var
  vDR: vectorDetalleRegistros;
  rM: maestro;
  min: detalle;
  provinciaActual,localidadActual: integer;
  actual: conVivienda;
  sinChapaCont: integer;
begin
  leerPrimeraVez(vD,vDR);
  reset(aM);
  read(aM, rM);
  minimo(vD,vDR,min);
  sinChapaCont:= 0;
  while (min.codProvincia <> valorAlto) do
    begin 
      provinciaActual:= min.codProvincia;
      while (min.codProvincia <> valorAlto) and (min.provinciaActual = provinciaActual) do
        begin
          localidadActual:= min.codLocalidad;
          actual.conLuz:=0;
          actual.conGas:=0;
          actual.conAgua:=0;
          actual.cantEntregaSanitarios:=0;
          while((min.codProvincia <> valorAlto) and(min.provinciaActual = provinciaActual) and (localidadActual = min.codLocalidad))do
            begin
              actual.conLuz:= actual.conLuz+ min.c.conLuz;
              actual.conGas:= actual.conGas +min.c.conGas;
              actual.conAgua:= actual.conAgua+ min.c.conAgua;
              actual.cantEntregaSanitarios:= actual.cantEntregaSanitarios+ min.c.cantEntregaSanitarios;
              actual.cantConstruidas:=  actual.cantConstruidas+ min.c.cantConstruidas;
              minimo(vD,vDR,min);
            end;
            if(actual.cantConstruidas > 0)then
              sinChapaCont:= sinChapaCont+1;
          while(min.codProvincia <> rM.codProvincia) and (min.codLocalidad <> rM.codLocalidad)do
            begin
              read(aM, rM);
            end;
          Seek(aM, filepos(aM)-1);
          rM.v.sinLuz:= rM.v.sinLuz- actual.conLuz;
          rM.v.sinGas:= rM.v.sinGas- actual.conGas;
          rM.v.sinAgua:= rM.v.sinAgua- actual.conAgua;
          rM.v.deChapa:= rM.v.deChapa - actual.cantConstruidas;
          if(not eof(aM))then
            read(aM,rM);
        end;
    end;
    Writeln('La cantidad de localidades sin viviendas de chapa: ',sinChapaCont);
    for i:= 1 to dimFdetalle do
      begin
        close(vD[i]);
      end;
    close(aM);
end;
{ Para la actualización se debe proceder de la siguiente manera: 
  1. Al valor de vivienda con luz se le resta el valor recibido en el detalle.
  2.  Idem para viviendas con agua, gas y entrega de sanitarios.
  3.    A las viviendas de chapa se le resta el valor recibido de viviendas construidas}
var
  aM: archMaestro;
  vD: vectorDetalle;
begin
  cargarMaestro(aM);
  cargarDetalle(vD);
  actualizarMaestro(aM, vD);
end.