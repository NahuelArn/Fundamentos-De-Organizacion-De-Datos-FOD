{
  A partir de información sobre la alfabetización en la Argentina, se necesita actualizar un
archivo que contiene los siguientes datos: nombre de provincia, cantidad de personas
alfabetizadas y total de encuestados. Se reciben dos archivos detalle provenientes de dos
agencias de censo diferentes, dichos archivos contienen: nombre de la provincia, código de
localidad, cantidad de alfabetizados y cantidad de encuestados. Se pide realizar los módulos
necesarios para actualizar el archivo maestro a partir de los dos archivos detalle.
NOTA: Los archivos están ordenados por nombre de provincia y en los archivos detalle
pueden venir 0, 1 ó más registros por cada provincia.

eje4Nueva practica
}

program eje4Nuevo;
const
  dimF_detalle = 2;
  valorAlto = 'zzz';
type
  rMaestro = record
    nombre_de_provincia: string;
    cant_personas_alfabetizadas: integer;
    total_encuestados: integer;
  end;

  rDetalle = record
    nombre_de_provincia: string;
    cod_localidad: string;
    cant_alfabetizados: integer;
    cant_encuentados: integer;
  end;

  archMaestro = file of rMaestro;
  archDetalle = file of rDetalle;

  vDetalle = array[1..dimF_detalle]of archDetalle;
  vDregistros = array[1..dimF_detalle] of rDetalle;
  
procedure leer_data(var rD: rDetalle);
begin
  Writeln('Ingrese el nombre de la provincia');
  readln(rD.nombre_de_provincia);
  Writeln('Ingrese la localidad ');
  rD.cod_localidad:= 'casa';
  Writeln('Ingrese la cantidad de alfabetizados: ');
  rD.cant_alfabetizados:= 5;
  Writeln('Ingrese la cantidad de encuestados: ');
  rD.cant_encuentados:= 5;
end;

procedure generar_detalles(var vD: vDetalle);
var
  direccion_absoluta_inmutable, direccion_absoluta_mutable, casa: string;
  rD: rDetalle;
  i,o: integer;
  archD: archDetalle;
  cuantoDa: integer;
begin
  cuantoDa:= 0;
  direccion_absoluta_inmutable:= 'D:\Codigo\Fundamentos-De-Organizacion-De-Datos-FOD\Practicas-Resueltas\1-Archivos\tp2_maestro_detalle_merge\archivos_txt\eje4ArchivosNuevo\binarioDetalle';
  for i:= 1 to 2 do
    begin
      Str(i,casa);
      direccion_absoluta_mutable:= direccion_absoluta_inmutable+ casa;
      Assign(archD, direccion_absoluta_mutable);
      rewrite(archD);
      for o:= 1 to random(5)+3 do
        begin
          leer_data(rD);
          // cuantoDa:= cuantoDa+ rD.cant_encuentados;
          write(archD,rD);
        end;
      close(archD);
      vD[i]:= archD;
    end;
    // Writeln('ingre',cuantoDa);
end;

procedure generar_un_maestro(var mae:archMaestro);
var
  m: rMaestro;
begin
  Assign(mae, 'D:\Codigo\Fundamentos-De-Organizacion-De-Datos-FOD\Practicas-Resueltas\1-Archivos\tp2_maestro_detalle_merge\archivos_txt\eje4ArchivosNuevo\binarioMaestro');
  rewrite(mae); writeln(); writeln();
  Writeln('Maestro');writeln(); writeln();
  Writeln('Ingrese el nombre de la provincia ');
  readln(m.nombre_de_provincia);
  Writeln('Ingrese la cantidad de personas alfabetizadas ');
  readln(m.cant_personas_alfabetizadas);
  Writeln('Ingrese la cantidad de personas encuestadas: ');
  readln(m.total_encuestados);
  write(mae,m);
  close(mae);
end;

procedure leer_primera_vez(var vD: vDetalle;var vDr: vDregistros);
var
  i: integer;
begin
  for i:= 1 to dimF_detalle do
    begin
      reset(vD[i]);
      read(vD[i], vDr[i]);
    end;
end;

procedure leer(var d: archDetalle; var r: rDetalle);
begin
  if(not eof(d))then
    begin
      read(d, r);
    end
  else
    begin
      r.nombre_de_provincia:= valorAlto;
    end;
end;

procedure minimo(var vD: vDetalle;var vDr: vDregistros; var min: rDetalle);
var
  i,pos: integer;
begin
  min.nombre_de_provincia := valorAlto;
  for i:= 1 to dimF_detalle do
    begin
      if(vDr[i].nombre_de_provincia < min.nombre_de_provincia)then
        begin
          min:= vDr[i];
          pos:= i;
        end;
    end;
  if(min.nombre_de_provincia <> valorAlto)then
    begin
      min:= vDr[pos];
      leer(vD[pos],vDr[pos]);
    end;
end;

procedure seTieneUnMaestroYnArchivos(var vD: vDetalle;var vDr: vDregistros; var mae: archMaestro);
var
  rM: rMaestro;
  min: rDetalle;
  rD: rMaestro;
begin
  leer_primera_vez(vD,vDr);
  reset(mae);
  read(mae, rM);
  minimo(vD,vDr,min);
  while( min.nombre_de_provincia <> valorAlto) do
    begin
      rD.nombre_de_provincia:= min.nombre_de_provincia;
      rD.cant_personas_alfabetizadas:= 0;
      rD.total_encuestados:= 0;
      while(( min.nombre_de_provincia <> valorAlto) and (min.nombre_de_provincia = rD.nombre_de_provincia))do
        begin
          rD.cant_personas_alfabetizadas := rD.cant_personas_alfabetizadas + min.cant_alfabetizados;
          rD.total_encuestados := rd.total_encuestados + min.cant_encuentados;
          minimo(vD,vDr,min);
        end;
      while rM.nombre_de_provincia <> rD.nombre_de_provincia do
        read(mae, rM);
      Seek(mae, filePos(mae)-1);
      rM.cant_personas_alfabetizadas:= rM.cant_personas_alfabetizadas+ rD.cant_personas_alfabetizadas;
      rM.total_encuestados:= rD.total_encuestados + rM.total_encuestados;
      write(mae, rM);
      if(not eof (mae))then
        begin
          read(mae,rM);
        end;
    end;
    close(mae);
end;

procedure imprimir_maestro(var mae: archMaestro);
var
  rM: rMaestro;
begin
  reset(mae);
  while(not eof (mae))do
    begin
      read(mae, rM);
      Writeln('nombre de provincia ',rM.nombre_de_provincia, ' cant personas alfabetizadas ',rM.cant_personas_alfabetizadas, ' Total encuenstados ', rM.total_encuestados)
    end;
  close(mae);
end;

var
  vD: vDetalle;
  mae: archMaestro;
  vDr: vDregistros;
begin
  randomize;
  generar_detalles(vD);
  generar_un_maestro(mae);
  seTieneUnMaestroYnArchivos(vD,vDr,mae);
  imprimir_maestro(mae);
end.