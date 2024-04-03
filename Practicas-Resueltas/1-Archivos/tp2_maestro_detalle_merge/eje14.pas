{

  14. Una compañía aérea dispone de un archivo maestro donde guarda información sobre
 sus próximos vuelos. En dicho archivo se tiene almacenado el destino, fecha, hora de salida
 y la cantidad de asientos disponibles. La empresa recibe todos los días dos archivos detalles
 para actualizar el archivo maestro. En dichos archivos se tiene destino, fecha, hora de salida
 y cantidad de asientos comprados. Se sabe que los archivos están ordenados por destino
 más fecha y hora de salida, y que en los detalles pueden venir 0, 1 ó más registros por cada
 uno del maestro. Se pide realizar los módulos necesarios para:
 c. Actualizar el archivo maestro sabiendo que no se registró ninguna venta de pasaje
 sin asiento disponible.
 d. Generar una lista con aquellos vuelos (destino y fecha y hora de salida) que
 tengan menos de una cantidad específica de asientos disponibles. La misma debe
 ser ingresada por teclado.
 NOTA: El archivo maestro y los archivos detalles sólo pueden recorrerse una vez.
}

program eje14;
const
  dimFdetalle = 3;
  dimFmaestro = 3;
  valorAlto = 'zzzz';
type
  proximoVuelo = record 
    destino: string;
    fecha: integer;
    horaDeSalida: real;
    cantAsientosDisponibles: integer;
  end;

  actualizacion = record
    data: proximoVuelo;
    cantAsientosComprados: integer;
  end;

  archMaestro = file of proximoVuelo;
  archDetalle = file of actualizacion;

  vectorDetalle = array[1..dimFdetalle]of archDetalle;
  vectorDetalleRegistro = array[1..dimFdetalle]of actualizacion;

  lista = ^nodo;

  nodo = record
    dato: actualizacion;
    sig: lista;
  end;

procedure cargarMaestro(var archM: archMaestro);
  procedure leerData(var p: proximoVuelo);
  begin
    Writeln('Ingrese el destino ');
    readln(p.destino);
    Writeln('Ingrese la fecha ');
    readln(p.fecha); //anho
    Writeln('Ingrese la hora ');
    readln(p.horaDeSalida);
    Writeln('Ingrese la cantidad de asientos disponibles ');
    p.cantAsientosDisponibles:= 0;
  end;

var
  p: proximoVuelo;
  i: integer;
begin
  Assign(archM, 'D:\Codigo\Fundamentos-De-Organizacion-De-Datos-FOD\Practicas-Resueltas\1-Archivos\tp2_maestro_detalle_merge\archivos_txt\eje14Archivos\binarioMaestro');
  Rewrite(archM);
  for i:= 1 to dimFmaestro do 
    begin
      leerData(p);
      write(archM, p);
    end;
  Close(archM);
end;

procedure cargarDetalles(var vD: vectorDetalle);
  procedure leerData(var a: actualizacion);
  begin
    Writeln('Ingrese el destino ');
    readln(a.data.destino);
    Writeln('Ingrese la fecha ');
    readln(a.data.fecha); //anho
    Writeln('Ingrese la hora ');
    readln(a.data.horaDeSalida);
    Writeln('Ingrese la cantidad de asientos comprados ');
    a.cantAsientosComprados:= 0;
  end;

var
  direccionMutable, direccionInmutable, casa: string;
  i,z: integer;
  a: actualizacion;
begin
  direccionInmutable:= 'D:\Codigo\Fundamentos-De-Organizacion-De-Datos-FOD\Practicas-Resueltas\1-Archivos\tp2_maestro_detalle_merge\archivos_txt\eje14Archivos\binarioDetalle';
  for i:= 1 to dimFdetalle do
    begin
      str(i, casa);
      direccionMutable:= direccionInmutable + casa;
      Assign(vD[i], direccionMutable);
      Rewrite(vD[i]);
      for z:= 1 to dimFdetalle-1 do //la dimF, de cada archivo individual
        begin
          leerData(a);
          write(vD[i], a);
        end;
      close(vD[i]);
    end;
    wRITELN('salgo');
end;

procedure actualizarMaestro2Detalle(var archM: archMaestro;var vD: vectorDetalle);

  procedure leerPrimeraVez(var vD: vectorDetalle;var vDR: vectorDetalleRegistro);
  var i: integer;
  begin
    for i:= 1 to dimFdetalle do
      begin
        reset(vD[i]);
        read(vD[i], vDR[i]);
      end;
  end;
  
  procedure minimo(var vD: vectorDetalle;var vDR:vectorDetalleRegistro;var min:actualizacion);

    procedure leer(var archivo: archDetalle;var dato: actualizacion);
    begin
      if(not eof(archivo))then
        read(archivo, dato)
      else
        dato.data.destino:= valorAlto;
    end;
  var
    i,pos: integer;
  begin
    min.data.destino:= valorAlto;
    for i:= 1 to dimFdetalle do
      begin
        if(vDR[i].data.destino < min.data.destino) and ((vDR[i].data.fecha < min.data.fecha) and (vDR[i].data.horaDeSalida < min.data.horaDeSalida)) then
          begin
            min:= vDR[i];
            pos:= i;
          end;
      end;
    if(min.data.destino <> valorAlto)then
      begin
        min:= vDR[pos];
        leer(vD[pos],vDR[pos]);
      end;
  end;
  procedure agregarAtras(var l,ult: lista; min: actualizacion);
  var
    nue: lista;
  begin
    new(nue);
    nue^.dato:= min;
    nue^.sig:= nil;
    if(l = nil)then
      l:= nue
    else
      ult^.sig:= nue;
    ult:= nue;
  end;

var
  vDR: vectorDetalleRegistro;
  rM: proximoVuelo;
  min: actualizacion;
  destinoActual: string; fechaActual: integer; horaDeSalidaActual: real;
  puntoD: integer;
  cantAsientosComprado: integer;
  l,ult: lista;
begin
  reset(archM);
  read(archM, rM);
  leerPrimeraVez(vD, vDR);
  minimo(vD,vDR,min);
  Writeln('Ingrese la cantidad de asientos disponibles minima, para el punto b');
  readln(puntoD);
  while (min.data.destino <> valorAlto) do
    begin
      destinoActual:= min.data.destino;
      while (min.data.destino <> valorAlto) and (destinoActual = min.data.destino) do
        begin
          fechaActual:= min.data.fecha;
          while (min.data.destino <> valorAlto) and (destinoActual = min.data.destino) and (fechaActual = min.data.fecha) do
            begin
              horaDeSalidaActual:= min.data.horaDeSalida;
              cantAsientosComprado:= 0;
              while (min.data.destino <> valorAlto) and (destinoActual = min.data.destino) and (fechaActual = min.data.fecha) and (horaDeSalidaActual= min.data.horaDeSalida) do
                begin
                  cantAsientosComprado:= cantAsientosComprado + min.cantAsientosComprados;
                  if(rM.cantAsientosDisponibles < puntoD)then
                    agregarAtras(l,ult,min);
                  minimo(vD,vDR,min);
                end;
              while (destinoActual <> rM.destino) and (fechaActual <> rM.fecha) and (horaDeSalidaActual <> rM.horaDeSalida) do
                begin
                  read(archM, rM);
                end;
              Seek(archM, filepos(archM)-1);
              rM.cantAsientosDisponibles:= rM.cantAsientosDisponibles- cantAsientosComprado;
              write(archM, rM);
              if(not eof (archM))then
                read(archM, rM);
            end;
        end;
    end;
end;

//Se sabe que los archivos están ordenados por destino más fecha y hora de salida
var
  archM: archMaestro;
  vD: vectorDetalle;
begin
  cargarMaestro(archM);
  cargarDetalles(vD);
  actualizarMaestro2Detalle(archM,vD);
end.