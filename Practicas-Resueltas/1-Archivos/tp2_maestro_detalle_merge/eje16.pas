{
  16. La editorial X, autora de diversos semanarios, posee un archivo maestro con la
 información correspondiente a las diferentes emisiones de los mismos. De cada emisión se
 registra: fecha, código de semanario, nombre del semanario, descripción, precio, total de
 ejemplares y total de ejemplares vendido.


 Mensualmente se reciben 100 archivos detalles con las ventas de los semanarios en todo el
 país. La información que poseen los detalles es la siguiente: fecha, código de semanario y
 cantidad de ejemplares vendidos. Realice las declaraciones necesarias, la llamada al
 procedimiento y el procedimiento que recibe el archivo maestro y los 100 detalles y realice la
 actualización del archivo maestro en función de las ventas registradas. Además deberá
 informar fecha y semanario que tuvo más ventas y la misma información del semanario con
 menos ventas.

 Nota: Todos los archivos están ordenados por fecha y código de semanario. No se realizan
 ventas de semanarios si no hay ejemplares para hacerlo

}


program eje16;
const
  dimLdetalle = 3;
  valorAlto = 9999;
type
  emision = record
    fecha: integer; //anho
    codSeminario: integer;
    nombreSeminario: integer;
    descripcion: string;
    precio: real;
    totalEjemplares: integer;
    totalEjemplaresVendidos: integer;
  end;

  venta = record
    fecha: codSeminario;
    codSeminario: integer;
    cantDeEjemplaresVendidos: integer;
  end;

  detalle = file of venta;
  maestro = file of emision;

  maestro = file of emision;
  vectorDetalle = array[1..dimFdetalle]of detalle;
  vectorDetalleRegistro = array[1..dimFdetalle] of venta;

procedure actualizarMaestro(var aM: maestro;var vD: vectorDetalle);
  procedure leerPrimeraVez(var vD: vectorDetalle;var vDR:vectorDetalleRegistro);
  var i: integer;
  begin
    for i:= 1 to dimLdetalle do
      begin
        reset(vD[i]);
        read(vD[i], vDR[i])
      end;
  end;

  procedure minimo(var vD: vectorDetalle;var vDR: vectorDetalleRegistro;var min:venta);
    procedure leer(var archivo: detalle; var dato: venta);
    begin
      if(not eof(archivo))then
        read(archivo, dato)
      else
        begin
          dato.fecha:= valorAlto;
          dato.cantDeEjemplaresVendidos:= valorAlto;
        end;
    end;

  var i, pos: integer;
  begin
    min.fecha:= valorAlto;
    min.codSeminario:= valorAlto;
    for i:= 1 to dimLdetalle do
      begin
        if(vDR[i].fecha < min.fecha) and (vDR[i].fecha < min.cantDeEjemplaresVendidos)then
          begin
            min:= vDR[i];
            pos: i;
          end;
      end;
    if(valorAlto <> min.fecha) and (valorAlto <> min.cantDeEjemplaresVendidos)then
      begin
        min:= vDR[pos];
        leer(vD[pos], vDR[pos]);
      end;
  end;

  procedure sacarMaxMin(var fechaMax,fechaMin,max,min:integer; cantVendida,fechaActual:integer;var semMax,semMin: integer; actualSem: integer);
  begin
    if(cantVendida > max)then
      begin
        max:= cantVendida;
        fechaMax:= fechaActual;
        semMax:=actualSem;
      end;
    if(cantVendida < min)then
      begin
        min: cantVendida;
        fechaMin:= fechaActual;
        semMin:= actualSem;
      end;
  end;
var
  vDR: vectorDetalleRegistro;
  min: venta;
  seminarioActual,fechaActual: integer;
  cantVendida,i: integer;
  fechaMax,fechaMin,max,min,semMax,semMin: integer;
  rM: emision;
begin
  leerPrimeraVez(vD,vDR);
  reset(aM);
  read(aM,rM);
  minimo(vD,vDR,min);
  max:= -9999;
  min:= 9999;
  while (min.fecha <> valorAlto) do
    begin
      fechaActual:= min.fecha;
      while(min.fecha <> valorAlto) and (fechaActual = min.fecha)do
        begin
          seminarioActual:= min.fecha;
          cantVendida:= 0;
          while (min.fecha <> valorAlto) and (fechaActual = min.fecha) and (min.codSeminario = seminarioActual) do
            begin
              cantVendida:= cantVendida + min.cantDeEjemplaresVendidos;
              minimo(vD,vDR,min);
            end;
          sacarMaxMin(fechaMax,fechaMin,max,min,cantVendida, fechaActual,semMax,semMin,seminarioActual);
          while(fechaActual <> rM.fecha ) and (seminarioActual <> rM.codSeminario)do
            begin
              read(aM, rM);
            end;
          Seek(aM, filepos(aM)-1);
          rM.totalEjemplaresVendidos:= rM.totalEjemplaresVendidos + cantVendida;
          write(aM, rM);
          if(not eof(aM))then
            read(aM,rM);
        end;
    end;
    Writeln('Seminario con menos cantidad vendida: ',semMin, ' con mas: ',semMax);
    close(aM);
    for i:=  1 to dimLdetalle do
      begin
        close(vD[i]);
      end;
end;

//Todos los archivos están ordenados por fecha y código de semanario
var
  aM: maestro;
  vD: vectorDetalle;
begin
  cargarNdetalles(vD);  //se dipsone
  cargarMaestro(aM);  //se dispone
  actualizarMaestro(aM, vD);
end.