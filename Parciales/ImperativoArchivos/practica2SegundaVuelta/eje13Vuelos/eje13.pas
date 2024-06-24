program eje13;
const
  valorAlto = 9999;
  valorAltoString= 'zzzzz';
type
  infoVuelos = record
    destino: string;
    fecha: string;
    horaDeSalida: real;
    cantAsientosDisponibles: integer;
  end;

  maestro = file of infoVuelos;

  infoDet = record
    destino: string;
    fecha: string;
    horaDeSalida: real;
    cantAsientosComp: integer;
  end;

  detalle = file of infoDet;

  vecDet = array[1..2]of detalle;
  vecDetR = array[1..2]of infoDet;

  registroLista = record
    destino: string;
    fecha: string;
    horaDeSalida: real;
  end;

  lista = ^nodo;

  nodo = record
    dato: registroLista;
    sig: lista;
  end;

procedure cargarDirecciones(var vD: vecDet);
var
  i: integer; direccionInmutable,casa: string;
begin
  direccionInmutable:= 'yaCargadoDetalle';
  for i:= 1 to 2 do
    begin
      str(i,casa);
      assign(vD[i], direccionInmutable+casa);
    end;
end;

procedure leerPrimeraVez(var vD: vecDet;var vDR: vecDetR);
var
  i: integer;
begin
  for i:= 1 to 2 do
    begin
      reset(vD[i]);
      read(vD[i], vDR[i]);
    end;
end;

procedure leer(var a: detalle; var r: infoDet);
begin
  if(not eof(a))then
    read(a,r)
  else
    begin
      r.destino:= valorAltoString;
      r.fecha:= valorAltoString;
      r.horaDeSalida:= valorAlto;
    end;
end;

//orden Destino > fecha > hora de salida
procedure minimo(var vD: vecDet;var vDR: vecDetR;var min: infoDet);
var
  pos,i: integer;
begin
  min.destino:= valorAltoString;
  min.fecha:= valorAltoString;
  min.horaDeSalida:= valorAlto;
  for i:= 1 to 2 do
    begin
      if(vDR[i].destino < min.destino) or (vDR[i].destino = min.destino) and (vDR[i].horaDeSalida < min.horaDeSalida) or (
        vDR[i].destino = min.destino and vDR[i].horaDeSalida = min.horaDeSalida and vDR[i].horaDeSalida < min.horaDeSalida) then
        begin
          min:= vDR[i];
          pos:= i;
        end;
    end;
  if(min.destino <> valorAltoString)then
    begin
      min:= vDR[pos];
      leer(vD[pos],vDR[pos]);
    end;
end;

procedure agregarAdelante(var l: lista;var r: infoVuelos);
var
  aux: registroLista;
  nue: lista;
begin
  aux.destino:= r.destino;
  aux.fecha:= r.fecha;
  aux.horaDeSalida:= r.horaDeSalida;
  new(nue);
  nue^.dato:= aux;
  nue^.sig:= l;
  l:= nue;
end;

procedure cerrarDetalles(var vD: vecDet);
var
  i: integer;
begin
  for i:= 1 to 2 do
    close(vD[i]);
end;

procedure actualizarMaestro(var arch: maestro; var vD: vecDet; var l: lista);
var 
  vDR: vecDetR;
  min: infoDet;
  rM: infoVuelos;
  destinoActual, fechaActual: string;
  horaDeSalidaActual,cantTotAsien,cantidad: integer;
begin
  reset(arch);
  leerPrimeraVez(vD,vDR);
  minimo(vD,vDR,min);
  read(arch,rM);
  Writeln('Ingrese un cantidad ');
  readln(cantidad);
  while(min.destino <> valorAlto)do
    begin
      destinoActual:= min.destino;
      while (destinoActual = min.destino) do
        begin
          fechaActual:= min.fecha;
          while(destinoActual = min.destino and fechaActual = min.fecha)do
            begin
              horaDeSalidaActual:= min.horaDeSalida;
              cantTotAsien:= 0;
              while(destinoActual = min.destino and fechaActual = min.fecha and horaDeSalidaActual = min.horaDeSalida)do
                begin
                  cantTotAsien:= cantTotAsien+min.cantAsientosComp;
                  minimo(vD,vDR,min);
                end;
              while(rM.destino <> destinoActual or rM.fecha <> fechaActual or rM.horaDeSalida<> min.horaDeSalida)do
                begin
                  if(rM.cantAsientosDisponibles < cantidad)then
                    agregarAdelante(l,rM);
                  read(arch,rM);
                end;
              rM.cantAsientosDisponibles:= rM.cantAsientosDisponibles - cantTotAsien;
              seek(arch, filePos(arch)-1);
              write(arch,rM);
              if(rM.cantAsientosDisponibles < cantidad)then
                agregarAdelante(l,rM);
              if(not eof(arch))then
                read(arch,rM);
            end;
        end;
    end;
    while not eof(arch)do //por si me quedan data que leer todavia en el maestro
      begin
        if(rM.cantAsientosDisponibles < cantidad)then
          agregarAdelante(l,rM);
        read(arch,rM);
      end;
    close(arch);
    cerrarDetalles(vD);
end;

var
  arch: maestro;
  vD: vecDet;
  l: lista;
begin
  assign(arch, 'yaCargado');
  cargarDirecciones(vD);
  l:= nil;
  actualizarMaestro(arch,vD,l);
end.