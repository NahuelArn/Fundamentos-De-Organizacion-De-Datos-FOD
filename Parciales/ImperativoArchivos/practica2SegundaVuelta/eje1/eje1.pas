program eje1;
const
  valorAlto = 9999;
type
  empresa = record
    cod: integer;
    nombre: string;
    montoComision: real;
  end;

  // cod empleado Orden
  archivo = file of empresa;
procedure leer(var arch: archivo; var e: empresa);
begin
  if(not eof(arch))then
    read(arch, e)
  else
    e.cod:= valorAlto;
end;

procedure compactarTipoMerge(var arch: archivo; archComp: archivo);
var
  e: empresa;
  codActual: integer;
  valorTotalComisiones: real;
  empleadoActual: empresa;
begin
  reset(arch);
  rewrite(archComp);
  leer(arch, e);
  while (e.cod <> valorAlto)do
    begin
      codActual:= e.cod;
      valorTotalComisiones:= 0;
      empleadoActual.nombre:= e.nombre;
      while (codActual = e.cod)do
        begin
          valorTotalComisiones:= valorTotalComisiones + e.montoComision;
          leer(arch, e);
        end;
      empleadoActual.cod:= codActual;
      empleadoActual.montoComision:= valorTotalComisiones;
      write(archComp, empleadoActual);
    end;
  close(arch);
  close(archComp);
end;

var
  arch, archComp: archivo;
begin
  assign(arch, 'yaCargado');
  cargar(arch); //  se dispone Ya se tiene la data 
  assign(archComp, 'dataAguardar');
  compactarTipoMerge(arch,archComp);
end.