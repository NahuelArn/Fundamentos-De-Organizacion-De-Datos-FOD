program parcial;
const
  valorAlto = 999;
type
  rango4 = 0..3;
  equipo  = record
    codEquipo: integer;
    nombreEquipo: string;
    anho: integer;
    codigoDeTorneo: integer;
    codigoDeEquipoRival: integer;
    golesAhFavor: integer;
    golesEnContra: integer;
    puntosObtenidos: rango4; //ENUM ver si sirve de algo |perdio,gano, empato|
  end;

  eArchivo = file of equipo;
  //anho, cod de torneo, cod de equipo  //CRITERIO DE ORDEN

procedure leer(var arch: eArchivo;var e: equipo);
begin
  if(not eof (arch))then
    read(arch, e)
  else
    e.anho:= valorAlto;
end;

procedure generarInforme(var arch: eArchivo);
var
  e: equipo;
  anhoActual,codTorneoActual,codDeEquipoActual: integer;
  cont,contPerdido,contEmpate,campeonTorneo,maxCampeon: integer;
  nombreCampeon: string;
  nombreActual: string;
begin
  reset(arch);
  leer(arch,e);
  while e.anho <> valorAlto do
    begin
      anhoActual:= e.anho;
      Writeln('anho: 'anhoActual);
      while e.anho <> valorAlto and e.anho = e.anho do 
        begin
          codTorneoActual:= e.codigoDeTorneo;
          Writeln('cod torneo: 'codTorneoActual);
          maxCampeon:= -1;
          while e.anho <> valorAlto and e.anho = e.anho and codTorneoActual = e.codigoDeTorneo do
            begin
              codDeEquipo:= e.codEquipo;
              cont:= 0;
              contPerdido:= cont;
              contEmpate:= contPerdido;
              nombreActual:= e.nombreEquipo;
              writeln('cod equipo: ',codDeEquipoActual, ' nombre actual: ',nombreActual);
              while e.anho <> valorAlto and e.anho = e.anho and codTorneoActual = e.codigoDeTorneo and e.codEquipo = codDeEquipoActual do
                begin
                  Writeln('Cantidad de goles a favor: ',e.golesAhFavor, ' equipo: ',codDeEquipoActual);
                  Writeln('Cantidad total de goles en contra :',e.golesEnContra, ' equipo: ',codDeEquipoActual);
                  Writeln('Resta de gol ( ',e.golesAhFavor - e.golesEnContra,' ) equipo: ',codDeEquipoActual);
                  if e.puntosObtenidos =1 then  
                    begin
                      totalPuntos:= totalPuntos+1;
                      cont:= cont+1;
                    end;
                  if(e.puntosObtenidos = 0)then
                    begin
                      totalPuntos:= totalPuntos+1;
                      conPerdido:= contPerdido+1;
                    end;
                  if(e.puntosObtenidos = 3)then
                    begin
                      totalPuntos:= totalPuntos+1;
                      contEmpate:= contEmpate+1;
                    end;
                    leer(arch, e);
                end;
                Writeln('Cantidad de partidos ganados: ',cont ,' ' ,'equipo:',codDeEquipoActual);
                Writeln('Cantidad de partidos perdidos: ',conPerdido ,' ' ,'equipo:',codDeEquipoActual);
                Writeln('Cantidad de partidos empatados: ',contEmpate ,' ' ,'equipo:',codDeEquipoActual);
                Writeln('Cantidad total de puntos en el torneo: ',totalPuntos, ' equipo: 'codDeEquipoActual);
                if(totalPuntos > max)then
                  begin
                    max:= totalPuntos;
                    nombreCampeon:= nombreActual;
                  end;
            end;
              Writeln('equipo campeon: ',nombreCampeon);
        end;
    end;
end;

var
  arch: eArchivo;
begin
  assign(arch, 'yaEstaCargado');
  generarInforme(arch);
end.