program eje2;
const
  valorAlto = 9999;
type  
  producto = record
    codDeProducto: integer;
    nombre: string;
    descripcion: string;
    codigoDeBarras: integer;
    categoriaProducto: integer; //1 limpieza, 2 alimiento 3 etc etc
    stockActual: integer;
    stockMinimo: integer;
  end;

  maestro = file of producto;

  pedido = record
    codDeProducto: integer;
    cantidadPedida: integer;
    descripcion: string;
  end;

  archPedido = file of pedido;

  vArchivos = array[1..3]of archPedido;
  vRegistros = array[1..3]of pedido;

  lista = ^nodo;

  nodo = record
    dato: producto;
    sig: lista;
  end;

procedure cargarDireccionesVector(var vArch: vArchivos);
var
  i: integer;
  casa,direccionInmutable: String;
begin
  direccionInmutable:= 'pedidosYaCargados';
  for i:= 1 to 3 do
    begin
      str(i,casa);
      assign(vArch[i], direccionInmutable+casa);
    end;
end;

procedure leerPrimeraVez(var vArch: vArchivos;var vSup: vRegistros);
var i: integer;
begin
  for i:= 1 to 3 do
    begin
      reset(vArch[i]);
      read(vArch[i],vSup[i]);
    end;
end;

procedure leer(var arch: archPedido; var min: pedido);
begin
  if(not eof (arch))then
    read(arch,min)
  else
    min.codDeProducto:= valorAlto;
end;

procedure minimo(var vArch:vArchivos;var vSup: vRegistros;var min: pedido);
var
  pos,i: integer;
begin
  min.codDeProducto:= valorAlto;
  for i:= 1 to 3 do
    begin
      if vSup[i].codDeProducto < min.codDeProducto then
        begin
          pos:= i;
          min:= vSup[i];
        end;
    end;
  if(min.codDeProducto <> valorAlto)then
    begin
      min:= vSup[pos];
      leer(vArch[pos],vSup[pos]);
    end;
end;

procedure agregarAdelante(var l: lista; p: producto);
var nue: lista;
begin
  new (nue);
  nue.dato:= p;
  nue.sig:= l;
  l:= nue;
end;

procedure cerrarDetalles(var vArch: vArchivos);
var i: integer;
begin
  for i:= 1 to 3 do
    begin
      close(vArch[i]);
    end;
end;

procedure actualizarMaestro(var vArch: vArchivos;var l:lista);
var
  vSup: vRegistros;
  mae: maestro;
  min: pedido;
  codActual,cantidadPedida: integer;
  rm: producto;
begin
  leerPrimeraVez(vArch,vSup);
  Assign(mae, 'yaCargadoProducto');
  reset(mae);
  read(mae,rm);
  minimo(vArch,vSup,min);
  while min.codDeProducto <> valorAlto do
    begin
      codActual:= min.codDeProducto;
      cantidadPedida:=0;
      while codActual = min.codDeProducto do
        begin
          cantidadPedida:= cantidadPedida+min.cantidadPedida;
          minimo(vArch,vSup,min);
        end;
      while codActual <> rm.codDeProducto do
        begin
          read(mae,rm);
        end;
      if((rm.stockActual-cantidadPedida) < rm.stockMinimo)then
        begin
          agregarAdelante(l,rm);
          writeln('Pertenece a la categoria: ',rm.categoriaProducto);
          WriteLn('el pedido ',codActual, ' no pudo por ',cantidadPedida-rm.stockActual);
        end;
      rm.stockActual:= rm.stockActual - cantidadPedida;
      seek(mae, filePos(mae)-1);
      write(mae,rm);
      if not eof(mae) then
        read(mae, rm);
    end;
  close(mae);
  cerrarDetalles(vArch);
end;

var
  vArch: vArchivos;
  l: lista;
begin
  l:= nil;
  cargarDireccionesVector(vArch);
  actualizarMaestro(vArchivos,l);
end.