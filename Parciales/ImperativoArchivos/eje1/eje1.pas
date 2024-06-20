{
  Merge, con 5 archivos mas corte de control, control de unicidad por Dni
}

program eje1;
const
  valorAlto = 9999;
type
  carrera = record
    dni: integer;
    apellido: string;
    nombre: string;
    kms: real;
    estado: integer; //1 gano | 0 perdio
  end;

  carArchivo = file of carrera;

  vArchivos = array[1..5]of carArchivo;
  suportVector = array[1..5]of carrera;

  maestro = record
    // info_atleta: carrera;
    dni: integer;
    apellido: string;
    nombre: string;
    kmsTotales: real;
    cantCarrerasGanadas: integer;
  end;

  archMaestro = file of maestro;

procedure asignarDireccionesVector(var vA: vArchivos);
var
  direccion_inmutable,casa: string;
  i: integer;
begin
  direccion_inmutable:= 'abrilBinarioYaCargado';
  for i:= 1 to 5 do
    begin
      str(i,casa);
      assign(vA[i],direccion_inmutable+casa);
    end;  
end;

procedure leer(var arch: carArchivo; var c: carrera);
begin
  if not eof(arch) then
    read(arch, c)
  else
    c.dni:= 9999;
end;
//Se encarga de abrir y cargar el primer elemento al vector suport
procedure leerPrimeraVez(var vA: vArchivos; var vS: suportVector);
var
  i: integer;
begin
  for i:= 1 to 5 do
    begin
      reset(vA[i]);
      leer(vA[i],vS[i]);
    end;
end;

procedure minimo(var vA: vArchivos;var vS:suportVector;var min:carrera);
var
  i,pos: integer;
begin
  min.dni:= valorAlto;
  for i:= 1 to 5 do
    begin
      if (vS[i].dni < min.dni) then
        begin
          pos:= i;
          min:= vS[i];
        end;
    end;
  if(min.dni <> valorAlto)then
    begin
      min:= vS[pos];
      leer(vA[pos],vS[pos]);
    end;
end;

procedure cerrarVector(var vA: vArchivos);
var
  i: integer;
begin
  for i:= 1 to 5 do
    begin
      close(vA[i]);
    end;
end;

procedure crearMaestro(var vA: vArchivos; var mae: archMaestro);
var
  vS: suportVector;
  min: carrera;
  dniActual,carrerasGanadas: integer;
  kmsTotales: real;
  rm: maestro;
begin
  leerPrimeraVez(vA,vS);
  assign(mae, 'infoMergeada');
  rewrite(mae);  
  minimo(vA,vS,min);
  while(min.dni <> valorAlto)do
    begin
      dniActual:= min.dni;
      carrerasGanadas:= 0;
      kmsTotales:= 0;
      rm.dni:= dniActual; //agarro la data para el maestro aca
      rm.apellido:= min.apellido;
      rm.nombre:= min.nombre;
      while(min.dni = dniActual)do
        begin
          if min.estado = 1 then
            carrerasGanadas:= carrerasGanadas+1;
          kmsTotales:= kmsTotales+ min.kms;
          minimo(vA,vS,min);
        end;
      //data del maestro que fue acumulandose, pero si estoy aca cambio el dni
      rm.kmsTotales:= mae.kmsTotales+kmsTotales;
      rm.cantCarrerasGanadas:= cantCarrerasGanadas+carrerasGanadas;
      write(mae,rm);
    end;
  close(mae);
  cerrarVector(vA);
end;

var
  vA: vArchivos;
  mae: archMaestro;
begin
  asignarDireccionesVector(vA);
  crearMaestro(vA,mae);
end.