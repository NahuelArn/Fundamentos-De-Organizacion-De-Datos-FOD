program parcial;
const
  valorAlto= 999;
type
  empresa = record
    codFarmaco: integer;
    nombre: string;
    fecha: string;
    cantVendida: integer;
    formaDePago: string; //tarjeta o contado
  end;
  
  detalle = file of empresa;
  
  vectDet = array[1..30]of detalle;
  vectDetR = array[1..30] of empresa;

procedure asignarDirecciones(var vD: vectDet);
var
  i: integer;
  direccionInmutable,casa: string;
begin
  direccionInmutable:= 'binarioYaCargado';
  for i:= 1 to 30 do
    begin
      str(i,casa);
      assign(vD[i], direccionInmutable+casa);
    end;
end; 

procedure leerPrimeraVez(var vD: vectDet;var vDR:vectDetR);
var
  i: integer;
begin
  for i:= 1 to 30 do
    begin
      reset(vD[i]);
      read(vD[i], vDR[i]);
    end;
end;

procedure leer(var d: detalle;var e: empresa);
begin
  if(not eof(d))then
    read(d, e)
  else
    begin
      e.fecha:= valorAlto;
      e.codFarmaco:= valorAlto;
    end;
end;

procedure minimo(var vD: vectDet;var vDR: vectDetR;var min: empresa);
var
  i,pos: integer;
begin
  min.codFarmaco:= valorAlto;
  min.fecha:= valorAlto;
  for i:= 1 to 30 do
    begin
      if (vDR[i].codFarmaco < min.codFarmaco or (vDR[i].codFarmaco = min.codFarmaco)and vDR[i].fecha < min.fecha) then
        begin
          min:= vDR[i];
          pos:= i;
        end; 
    end;
  if(min.codFarmaco <> valorAlto and min.fecha <> valorAlto) then
    begin
      min:= vDR[pos];
      leer(vD[pos],vDR[pos]);
    end;
end;

procedure generarArchivo(var txt: text; codFarmacoAct: integer; nombre, fechaActual: string; cantVentFecha: integer);
begin
  writeln(txt, codFarmacoAct, cantVentFecha, nombre);
  writeln(txt,  fechaActual);
end;

procedure cerrarArchivos(var vD: vectDet);
var
  i: integer;
begin
  for i:= 1 to 30 do
    begin
      close(vD[i]);
    end;
end;

procedure analizarInformacion(var vD: vectDet);
var
  vDR: vectDetR;
  min: empresa;
  txt: text;
  cantVentAct,codFarmacoAct,maxCant,codMax,cantVentFecha: integer;
  fechaActual, nombre: string;
begin
   leerPrimeraVez(vD,vDR);
   assign(txt,"resumenDeVentas.txt");
   rewrite(txt);
   minimo(vD,vDR,min);
   maxCant:= 999;
   while(min.codFarmaco <> valorAlto and min.fecha <> valorAlto)then
     begin
       codFarmacoAct:= min.codFarmaco;
       cantVentAct:= 0;
       while ( codFarmacoAct = min.codFarmaco)do
         begin
           fechaActual:= min.fecha;
           cantVentFecha:= 0;
           nombre:= min.nombre;
           while( codFarmacoAct = min.codFarmaco and fechaActual = min.fecha ) do
             begin
               cantVentAct:= cantVentAct + min.cantVendida;
               cantVentFecha:= cantVentFecha + min.cantVendida;
               minimo(vD,vDR);
             end;
           generarArchivo(txt,codFarmacoAct,nombre,fechaActual,cantVentFecha);   //genera por fecha             
         end;
       //generarArchivo(txt,codFarmacoAct,nombre,fechaActual,cantVentFecha);   //Solo me pide por fecha
       if cantVentAct > maxCant then
         begin
           maxCant:= cantVentAct;
           codMax:= codFarmacoAct;
         end;
     end;
   Writeln('El farmaco con mayor cantVendida es: ', codMax); 
   close(txt);
   cerrarArchivos(vD);
end;
 
var
  vD: vectDet;
begin
  asignarDirecciones(vD);
  analizarInformacion(vD);
end;
