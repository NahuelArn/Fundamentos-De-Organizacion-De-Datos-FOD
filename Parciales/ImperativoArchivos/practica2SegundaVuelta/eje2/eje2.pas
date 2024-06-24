program eje2;
const
  valorAlto = 999;
type
  alumno = record
    cod: integer;
    apellido: string;
    nombre: string;
    cantMatAproSoloCursada: integer;
    cantMatAproConFinal: integer;
  end;

  maestro = file of alumno;

  info = record
    cod: integer;
    AproSoloCursada: boolean;
    AproConFinal: Boolean;
  end;

  detalle = file of info;
//Orden codigo de alumno
procedure leer(var det: detalle; var iR: info);
begin
  if(not eof(det))then
    read(det, iR)
  else
    iR.cod:= valorAlto;
end;

procedure actualizarAprobasFinal(var mae: maestro;var det: detalle);
var
  aR: alumno; iR: info;
  codActual: integer;
  cantFinalApr: integer;
begin
  reset(mae);
  reset(det);
  read(mae, aR,);
  leer(det, iR);
  while(iR.cod <> valorAlto)do
    begin
      codActual:= iR.cod;
      cantFinalApr:= 0;
      while(codActual = ir.cod)do
        begin
          if(ir.AproConFinal)then
            cantFinalApr:= cantFinalApr+1;
          leer(det,iR);
        end;
      while(codActual <> aR.cod)do
        begin
          read(mae, aR);
        end;
      Seek(mae, filePos(mae)-1);
      aR.cantMatAproConFinal:= aR.cantMatAproConFinal + cantFinalApr;
      aR.cantMatAproSoloCursada:=  aR.cantMatAproSoloCursada - cantFinalApr;
      write(arch, aR);
      if(not eof(arch))then
        read(arch, aR);
    end;
    close(mae);
    close(det);
end;

procedure actualizarAprobadasSoloCursada(var mae: maestro;var det: detalle);
var 
  aR: alumno; iR: info;
  codActual: integer;
  cantCursadaApr: integer;
begin
  reset(mae);
  reset(det);
  read(mae, aR,);
  leer(det, iR);
  while(iR.cod <> valorAlto)do
    begin
      codActual:= iR.cod;
      cantCursadaApr:= 0;
      while(codActual = ir.cod)do
        begin
          if(ir.AproSoloCursada)then
            cantCursadaApr:= cantCursadaApr+1;
          leer(det,iR);
        end;
      while(codActual <> aR.cod)do
        begin
          read(mae, aR);
        end;
      Seek(mae, filePos(mae)-1);
      aR.cantMatAproSoloCursada:= aR.cantMatAproSoloCursada+cantCursadaApr;
      write(arch, aR);
      if(not eof(arch))then
        read(arch, aR);
    end;
    close(mae);
    close(det);
end;

procedure listarEnTxt(var mae: maestro;var txt: txt);
var
  rM: alumno;
begin
  rewrite(txt);
  reset(mae); 
  while not eof(mae)do
    begin
      read(mae, rM);
      if(rM.cantMatAproConFinal > rM.cantMatAproSoloCursada)then
        begin
          writeln(txt, rM.cod, rM.cantMatAproSoloCursada, rM.cantMatAproConFinal, rM.apellido);
          writeln(txt, rM.nombre); //problema de 256 string caracters
        end;
    end;
  close(mae);
  close(txt);
end;

var
  mae: maestro; det: detalle;
  opcion: char;
begin
  writeln('Ingrese la opcion A o B (para saber  q hace leer el enucniadodo');
  read(opcion);
  //cargarMaestro(mae) //se dispone
  //cargarDetalle(det) //se dispone
  assign(mae,'yaCargado');
  assign(det, 'yaCargado');
  assign(txt, 'informe.txt');
  case opcion of  //A,B Podria/deberia hacerlo en un solo recorrido, baiteo de i y ii, es un solo proceso
    'a': actualizarAprobasFinal(mae,det);
    'b': actualizarAprobadasSoloCursada(mae,det);
    'c': listarEnTxt(mae,txt);
  end;

end.