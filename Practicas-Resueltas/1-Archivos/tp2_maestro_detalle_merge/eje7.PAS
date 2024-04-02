{
  El encargado de ventas de un negocio de productos de limpieza desea administrar el
 stock de los productos que vende. Para ello, genera un archivo maestro donde figuran todos
 los productos que comercializa. De cada producto se maneja la siguiente información:
 código de producto, nombre comercial, precio de venta, stock actual y stock mínimo.
 Diariamente se genera un archivo detalle donde se registran todas las ventas de productos

  realizadas. De cada venta se registran: código de producto y cantidad de unidades vendidas.
 Se pide realizar un programa con opciones para:
 a. Actualizar el archivo maestro con el archivo detalle, sabiendo que:
    ● Ambos archivos están ordenados por código de producto.
    ● Cada registro del maestro puede ser actualizado por 0, 1 ó más registros del
    archivo detalle.
    ● El archivo detalle sólo contiene registros que están en el archivo maestro.
 b.
    Listar en un archivo de texto llamado “stock_minimo.txt” aquellos productos cuyo
    stock actual esté por debajo del stock mínimo permitido.
}
program eje7;
const
  dimF = 3;
  valorAlto = 999;
type
  producto = record //maestro
    codProducto: integer;
    nombreComerciar: string;
    precioDeVenta: integer;
    stockActual: integer;
    stockMinimo: integer;
  end;

  venta = record  //detalle
    codProducto: integer;
    cantUnidadesVendidas: integer;
  end;

  d_producto = file of producto;
  m_venta = file of venta;
  vector_archivos_detalle = array[1..dimF]of d_producto;
  vector_archivos_registro = array[1..dimF] of producto;

procedure actualizarMaestro(var vecAD: vector_archivos_detalle; var archM: d_producto);

  procedure leer_primera_vez(var vecAD: vector_archivo_detalle;var vectAR: vector_archivos_registro);
  var
    direccion_inmutable, direccion_mutable, casa: string;
  begin
    for i:= 1 to dimF do
      begin
        reset(vecAD[i]);
        read(vecAD[i], vectAR[i]);
      end;
  end;

  procedure leer(var archivo: d_producto;var dato: producto);
  begin
    if(not eof(archivo))then
      begin
        read(archivo, dato);
      end
    else
      dato.codProducto:= valorAlto;
  end;

  procedure minimo(var vecAD: vector_archivo_detalle;var vectAR: vector_archivos_registro;var min:venta);
  var
    i,pos: integer;
  begin
    min.codProducto:= valorAlto;
    for i:= 1 to dimF do
      begin
        if (vectAR[i].codProducto < min.codProducto )then
          begin
            min:= vectAR[i];
            pos:= i;
          end;
      end;
    if(min.codProducto <> valorAlto)then
      begin
        min:= vectAR[pos];
        leer(vecAD[pos], vectAR[pos]);
      end;
  end;

var
  vectAR: vector_archivos_registro;
  rM: producto;
  min: producto;
  acumulador: venta;
  i: integer;
begin
  leer_primera_vez(vecAD, vectAR);
  reset(archM);
  read(archM, rM);
  minimo(vecAD, vectAR, min);
  while (min.codProducto <> valorAlto) do
    begin
      acumulador.codProducto:= min.codProducto;
      acumulador.cantUnidadesVendidas:= 0;
      while (min.codProducto <> valorAlto) and (acumulador.codProducto = min.codProducto) do
        begin
          acumulador.cantUnidadesVendidas:= acumulador.cantUnidadesVendidas+1;
          minimo(vecAD, vectAR,min);
        end;
      while (archM.codProducto <> min.codProducto) do
        read(archM, rM);
      Seek(archM, filepos(archM)-1);
      rM.stockActual:= rM.stockActual - acumulador.cantUnidadesVendidas;
      write(archM, rM);
      if(not eof(archM))then
        read(archM, rM);
    end;
    close(archM);
    for i:= 1 to dimF do
      close(vecAD[i]);
end;

procedure listar(var arcM: d_producto);
var
  p: producto;
  texto: text;
begin
  reset(arcM);
  Assign(texto, 'D:\Codigo\Fundamentos-De-Organizacion-De-Datos-FOD\Practicas-Resueltas\1-Archivos\tp2_maestro_detalle_merge\archivos_txt\eje7Archivos\listado.txt');
  rewrite(texto);
  while (not eof(archM)) do
    begin
      read(arcM, p);
      if(p.stockActual < p.stockMinimo)then
        begin
          writeln(texto, p.codProducto);
          writeln(texto, p.nombreComerciar);
          writeln(texto, p.precioDeVenta);
          writeln(texto, p.stockActual);
          writeln(texto, p.stockMinimo);
        end;
    end;
   close(arcM);
end;

var
  archM: m_venta;
  vecAD: vector_archivos_detalle;
begin
  cargarDetalle(vecAD); //se dispone
  cargarMaestro(archM); //se dispone
  actualizarMaestro(vecAD,archM);
  listar(arcM);
end.