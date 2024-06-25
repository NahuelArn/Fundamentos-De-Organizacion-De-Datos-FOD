program parcial;
const
  valorAlto = 999;
type
  venta = record
    numTicked: integer;
    codProducto: integer;
    cantidadUniVen: integer 
  end;
  detalle = file of venta;

  vectDet = array[1..25]of detalle;
  vectDetR = array[1..25]of venta;
  //ORDEN CODIGO DE PRODUCTO
  producto = record
    cod: integer;
    descripcion: string;
    cantExistente: integer;
    stockMinimo: integer;
    precioVenta: real;
  end;

  maestro = file of producto;

procedure asignarDirecciones(var vD: vectDet);
var i: integer; direccionInmutable,casa: string;
begin
  direccionInmutable:= 'yacargado';
  for i:= 1 to 25 do
    begin
      str(i,casa);
      assign(vD[i], direccionInmutable+casa);
    end;
end;

procedure leerPrimeraVez(var vD: vectDet; var vDR: vecDetR);
var i: integer;
begin
  for i:= 1 to 25 do
    begin
      reset(vD[i]);
      read(vD[i], vDR[i]);
    end;
end;

procedure leer(var d: detalle;var r: venta);
begin
  if (not eof(d))then
    read(d)
  else
    r.codProducto:= valorAlto;
end;

procedure minimo(var vD: vectDet; var vDR: vecDetR; var min: venta);
var
  i,pos: integer;
begin
  min.codProducto:= valorAlto;
  for i:= 1 to 25 do
    begin
      if(vDR[i].codProducto < min.codProducto)then  //procesa registros
        begin
          min:= vDR[i];
          pos:= i;
        end;
    end;
  if(min.codProducto <> valorAlto)then
    begin
      min:= vDR[pos];
      leer(vD[pos],vDR[pos]);
    end;
end;

procedure cerrarDetalles(var vD:vectDet);
var i: integer;
begin
  for i:= 1 to 25 do
    close(vD[i]);
end;

procedure procesar(var mae: maestro;var vD:vectDet);
var 
  min: venta; codProdActual, cantTotal: integer;
  rM:producto;
  montoTotalFacturado: real;
begin
  reset(mae);
  leerPrimeraVez(vD);
  minimo(vD, vDR,min);
  read(mae,rM);
  montoTotalFacturado:= 0;
  while min.codProducto <> valorAlto do
    begin
      codProdActual:= min.codProducto;
      while (codProdActual = min.codProducto)do
        begin
          cantTotal:= min.cantidadUniVen + cantTotal;
          minimo(vD,vDR,min);
        end;
      while(rM.cod <> codProdActual)do
        begin
          writeln('cod: ',rM.cod, ' nombre:??quien escribio el enunciado?? ',' monto: ',0); //si esta aca es porque no es una venta y se esta buscando en el maestro la venta
          if(rM.cantExistente > 0)then
            writeln('b ',rM.cod);
          read(mae, rM)
        end;
      writeln('cod: ',rM.cod, ' nombre:??quien escribio el enunciado?? ',' monto: ',cantTotal* rM.precioVenta); 
      montoTotalFacturado:= montoTotalFacturado+cantTotal* rM.precioVenta;
      if((rM.cantExistente - cantTotal) > 0)then
        begin
          rM.cantExistente:= rM.cantExistente- cantTotal;
          seek(mae, filePos(mae)-1);
          write(mae, rM);
          if(rM.cantExistente < rM.stockMinimo)then
            writeln('c: ',rM.cod);
        end;  
      if(not eof(mae))then
        read(mae, rM);
    end;
    writeln('Monto total: ',montoTotalFacturado);
    close(mae);
    cerrarDetalles(vD);
end;

var
  mae: maestro;
begin
  assign(mae, ' yaCargado');
  asignarDirecciones(vD);
  procesar(mae,vD);
end.