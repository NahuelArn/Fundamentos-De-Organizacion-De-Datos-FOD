{ 9. Se necesita contabilizar los votos de las diferentes mesas electorales registradas por
 provincia y localidad. Para ello, se posee un archivo con la siguiente información: código de
 provincia, código de localidad, número de mesa y cantidad de votos en dicha mesa.
 Presentar en pantalla un listado como se muestra a continuación:
 Código de Provincia
 Código de Localidad
 ................................
 ................................
 Total de Votos
 ......................   
 ......................
 Total de Votos Provincia: ___
 
 Código de Provincia
 Código de Localidad
 ................................
 Total de Votos Provincia: ___
 Total de Votos
 ......................
 …………………………………………………………..
 Total General de Votos: ___
 NOTA: La información se encuentra ordenada por código de provincia y código de
 localidad
 
 
 }

//cond pr
program eje9;
const
  valorAlto = 999;
type  
  mesa = record
    codProvincia: integer;
    codLocalidad: integer;
    numMesa: integer;
    cantVotosDichaMesa: integer;
  end;

  procedure leer(var texto: text;var m: mesa);
  begin
    if(not eof(texto))then
      readln(texto, m.codProvincia, m.codLocalidad, m.numMesa, m.cantVotosDichaMesa)
    else
      m.codProvincia:= valorAlto;
  end;
var
  texto: text;
  m: mesa;
  codProvinciaActual, codLocalidadActual: integer;
  totalLocalidad, totalProvincia: integer;
//codProvincia,  codLocalidad, numMesa, cantVotosDichaMesa
begin
  Assign(texto, 'D:\Codigo\Fundamentos-De-Organizacion-De-Datos-FOD\Practicas-Resueltas\1-Archivos\tp2_maestro_detalle_merge\archivos_txt\eje9Archivos\texto.txt');
  reset(texto);
  leer(texto, m);
  while(m.codProvincia <> valorAlto)do
    begin
      codProvinciaActual:= m.codProvincia;
      totalProvincia:= 0;
      while(m.codProvincia <> valorAlto) and (codProvinciaActual = m.codProvincia)do
        begin
          codLocalidadActual:= m.codLocalidad;
          totalLocalidad:= 0;
          while((m.codProvincia <> valorAlto) and (codProvinciaActual = m.codProvincia) and (codLocalidadActual = m.codLocalidad))do
            begin        
              totalLocalidad:= totalLocalidad+ m.cantVotosDichaMesa;     
              leer(texto, m);
            end;
          Writeln('Votos de la localidad: ',totalLocalidad);
          totalProvincia:= totalProvincia+totalLocalidad;
        end;   
      Writeln('Votos total de la provincia: ',totalProvincia);
    end;
end.