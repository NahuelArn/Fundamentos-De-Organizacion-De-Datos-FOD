//-------------------------------------------------------------------------------------------------------
//3 o mas criterios de orden
//Tres o más criterios: Se comparan codFarmaco, fechaAnho y fechaMes.
procedure leer(var det: detalle; var reg:registro);
begin
    if(not eof(det)) then
        read(det, reg)
    else 
      begin 
        reg.codFarmaco:=valorAlto;
        reg.fechaAnho:=valorAlto;
        reg.fechaMes:=valorAlto
      end;
end;

procedure minimo(var v: vector; var vr: vector_far; var min: farmaco);
var
  i, pos: integer;
begin
  min.cod_farmaco := valorAlto;
  min.fechaAnho := valorAlto;
  min.fechaMes := valorAlto;
  for i := 1 to df do
    if (vr[i].codFarmaco < min.codFarmaco) or ((vr[i].codFarmaco = min.codFarmaco) and (vr[i].fechaAnho < min.fechaAnho)) or 
      ((vr[i].codFarmaco = min.codFarmaco) and (vr[i].fechaAnho = min.fechaAnho) and (vr[i].fechaMes < min.fechaMes)) then
      begin
        min := vr[i];
        pos := i;
      end;
  if (min.cod_farmaco <> valorAlto) then
    leer(v[pos], vr[pos]);
end;

//-------------------------------------------------------------------------------------------------------
// 2 criterios de orden
//Dos criterios: Se comparan fecha y codigo.
procedure Leer(var det:detalle; var reg: datoDetalle);
begin
    if(not eof(det)) then
        read(det, reg)
    else 
      begin
        reg.fecha:=valorAlto;
        reg.codigo:=valorAlto;
      end;
end;
procedure Minimo (var vD:vDetalles; var vDR:vDetR; var min:registro);
var
  i, pos:integer;
begin
  min.fecha:=valorAlto; 
  min.codigo:=valorAlto;
  for i:= 1 to df do
    begin
      if(vDR[i].fecha < min.fecha) or ((vDR[i].fecha = min.fecha) and (vDR[i].codigo < min.codigo)) then 
        begin
          min:= vDR[i];
          pos:= i;
        end;
    end;
  if(min.fecha <> valorAlto) then
    Leer(vD[pos], vDR[pos]);
end;



//-------------------------------------------------------------------------------------------------------
//el mas simple, un solo criterio de orden
//Un criterio: Se compara cod.
procedure Leer(var det: archivo; var reg:registro);
begin
    if (not eof(det)) then 
      read(det, reg)
    else 
      reg.cod:=valorAlto;
end;

procedure Minimo(var vD: vDetalles;var vDR: vDetR; var min: registro);
var
  i, pos:integer; 
begin
  min.cod:=valorAlto;
  for i:= 1 to dimF do
    begin
      if (vDR[i].cod < min.cod) then 
        begin
          min:= vDR[i];
          pos:= i;
        end;
    end;
  if (min.cod <> valorAlto) then
    Leer(vD[pos], vDetR[pos]);
end;