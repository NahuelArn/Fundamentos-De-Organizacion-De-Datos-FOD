program parcial;
const
  valorAlto = 9999;
  N = 1000;
type
  alumnoInscripto = record  
    dni: integer;
    codCarrera: integer;
    montoTotalPagado: real;
  end;

  maestro = file of alumnoInscripto;

  rapiPago = record
    dni: integer;
    codCarrera: integer;
    montoCuota: real;
  end;
  
  detalle = file of rapiPago;

  vectDet = array[1..N]of detalle;
  vectDetR = array[1..N]of rapiPago;
  //dniAlumno > codCarrera ORDEN

procedure asignarDirecciones(var vD: vectDet);
var
  i: integer;
  casa,direccionInmutable: string;
begin
  direccionInmutable:= 'yaExiste';
  for i:= 1 to N do
    begin
      str(i, casa);
      assign(vD[i], direccionInmutable+casa);
    end;
end;

procedure leerPrimeraVez(var vD: vectDet;var vDR: vectDetR);
var i: integer;
begin
  for i:=  1 to N do
    begin
      reset(vD[i]);
      read(vD[i], vDR[i]);
    end;
end;

procedure leer(var det: detalle; r: rapiPago);
begin
  if( not eof(det))then
    read(det,r)
  else
    begin
      r.dni:= valorAlto;
      r.codCarrera:= valorAlto;
    end;
end;

procedure minimo(var vD: vectDet; var vDR: vectDetR; var min: rapiPago);
var
  pos, i: integer;
begin
  min.dni:= valorAlto;
  min.codCarrera:= valorAlto;
  for i:= 1 to N do
    begin
      if(vDR[i].dni < min.dni or vDR[i].dni = min.dni and (vDR[i].codCarrera < min.codCarrera))then
        begin
          min:= vDR[i];
          pos:= i;
        end;
    end;
  if(min.dni <> valorAlto)then
    begin
      min:= vDR[pos];
      leer(vD[pos],vDR[pos]);
    end;
end;

procedure cerrarDetalles(var vD: vecDet);
var i: integer;
begin
  for i:= 1 to N do
    begin
      close(vD[i]);
    end;
end;

procedure actualizarPagos(var arch: maestro; var vD: vectDet);
var
  rM: alumnoInscripto;
  vDR: vectDetR;
  min: rapiPago;
  totalPagado: real; dniActual, codCarrActual: integer;
begin
  reset(arch);
  leerPrimeraVez(vD,vDR);
  read(arch, rM);
  minimo(vD,vDR,min);
  while(min.dni <> valorAlto)do
    begin
      dniActual:= min.dni;
      while(dniActual = min.dni)do
        begin
          codCarrActual:= min.codCarrera;
          totalPagado:= 0;
          while(dniActual = min.dni and codCarrActual = min.codCarrera)do
            begin
              totalPagado:= totalPagado + min.montoCuota;
              minimo(vD,vDR,min);
            end;
          while(dniActual <> rM.dni or codCarrActual <> rM.codCarrera)do
            begin
              read(arch, rM);
            end;
          seek(arch, filePos(arch)-1);
          rM.montoTotalPagado:= rM.montoTotalPagado + totalPagado;
          write(arch, rM);
          if(not eof(arch))then
            read(arch, rM);
        end;
    end;
  close(arch);
  cerrarDetalles(vD);
end;

procedure generarInforme(var arch: maestro; var txt: text);
var 
  r: alumnoInscripto;
begin
  reset(arch);
  rewrite(txt);
  while not eof(arch)do // si es un solo archivo sin repetidos, solo recorrer no hace falta el leerArchivo
    begin
      read(arch, r);
      if(r.montoTotalPagado <= 0)then
        writeln(txt, r.dni, r.codCarrera, ' alumno amoroso');
    end;
  close(arch);
  close(txt);
end;

var
  arch: maestro;
  vD: vectDet;
  txt: text;
begin
  assign(arch, 'yaExiste');
  asignarDirecciones(vD);
  actualizarPagos(arch);
  assign(txt, 'aCargarse.txt');
  generarInforme(arch,txt);
end.