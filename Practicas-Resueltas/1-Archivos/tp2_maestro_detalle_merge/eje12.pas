{

   La empresa de software ‘X’ posee un servidor web donde se encuentra alojado el sitio de
    la organización. En dicho servidor, se almacenan en un archivo todos los accesos que se
    realizan al sitio.
    La información que se almacena en el archivo es la siguiente: año, mes, dia, idUsuario y
    tiempo de acceso al sitio de la organización. El archivo se encuentra ordenado por los
    siguientes criterios: año, mes, dia e idUsuario.
    Se debe realizar un procedimiento que genere un informe en pantalla, para ello se indicará
    el año calendario sobre el cual debe realizar el informe. El mismo debe respetar el formato
    mostrado a continuación:
    Año :--
    Mes:-- 1
    día:-- 1
    idUsuario 1 Tiempo Total de acceso en el dia 1 mes 1--------
    idusuario N Tiempo total de acceso en el dia 1 mes 1
    Tiempo total acceso dia 1 mes 1------------
    día N
    idUsuario 1 Tiempo Total de acceso en el dia N mes 1--------
    idusuario N Tiempo total de acceso en el dia N mes 1
    Tiempo total acceso dia N mes 1
    Total tiempo de acceso mes 1
  ----
 Mes 12
 día 1
  idUsuario 1 Tiempo Total de acceso en el dia 1 mes 12--------
  idusuario N Tiempo total de acceso en el dia 1 mes 12
  Tiempo total acceso dia 1 mes 12------------
día N
  idUsuario 1 Tiempo Total de acceso en el dia N mes 12--------
  idusuario N Tiempo total de acceso en el dia N mes 12
  Tiempo total acceso dia N mes 12
  Total tiempo de acceso mes 12
  Total tiempo de acceso año
  Se deberá tener en cuenta las siguientes aclaraciones:
    El año sobre el cual realizará el informe de accesos debe leerse desde teclado.--
    El año puede no existir en el archivo, en tal caso, debe informarse en pantalla “año
    no encontrado”.
    Debe definir las estructuras de datos necesarias.
    El recorrido del archivo debe realizarse una única vez procesando sólo la información
    necesaria
}

program eje12;
const
  valorAlto = 8999;
type
  acceso = record 
    anho: Integer;
    mes: integer;
    dia: integer;
    idUsuario: Integer;
    tiempoDeAccesoAlsitioDeLaOrganizacion: integer;
  end;

procedure generarInforme(anho: integer);
  procedure leer(var texto: text; var acc: acceso);
  begin
    if(not eof(texto))then
      readln(texto, acc.anho, acc.mes, acc.dia, acc.idUsuario, acc.tiempoDeAccesoAlsitioDeLaOrganizacion)
    else
      acc.anho:= valorAlto;
  end;

var
  texto: text;
  acc: acceso;
  encontrado: Boolean;
  anhoActual, mesActual, diaActual, idUsuarioActual: integer;
  tiempoTotalMess,tiempoTotalDia,totalAnho: real;
begin
  Assign(texto, 'D:\Codigo\Fundamentos-De-Organizacion-De-Datos-FOD\Practicas-Resueltas\1-Archivos\tp2_maestro_detalle_merge\archivos_txt\eje12Archivos\texto.txt');
  reset(texto);
  leer(texto, acc);
  encontrado:= false;
  while(acc.anho <> valorAlto)do
    begin
      while(acc.anho <> valorAlto) and (acc.anho <> anho)do
        begin
          leer(texto, acc);
        end;
      if(acc.anho = anho)then
        encontrado:= true;
      if(encontrado)then
        begin
          totalAnho:= 0;
          anhoActual:= acc.anho;
          Writeln('Anho: ',anhoActual);
          while(acc.anho <> valorAlto) and (anhoActual = acc.anho)do
            begin
              mesActual:= acc.mes;
              Writeln('Mes: ',mesActual);
              tiempoTotalMess:= 0;
              while((acc.anho <> valorAlto) and (anhoActual = acc.anho) and (mesActual = acc.mes))do
                begin
                  diaActual:= acc.dia;
                  Writeln('Dia: ',diaActual);               
                  while((acc.anho <> valorAlto) and (anhoActual = acc.anho) and (mesActual = acc.mes) and (diaActual = acc.dia))do
                    begin
                      idUsuarioActual:= acc.idUsuario;
                      tiempoTotalDia:= 0;
                      while ((acc.anho <> valorAlto) and (anhoActual = acc.anho) and (mesActual = acc.mes) and (diaActual = acc.dia) and (idUsuarioActual = acc.idUsuario))do 
                        begin
                          tiempoTotalDia:= acc.tiempoDeAccesoAlsitioDeLaOrganizacion+ tiempoTotalDia;
                          leer(texto, acc);                        
                        end;
                        Writeln('Usuario: ',idUsuarioActual, ' dia: ',diaActual,' tiempo: ',tiempoTotalDia);
                        tiempoTotalMess:= tiempoTotalMess + tiempoTotalDia;
                    end;
                end;
                Writeln('tiempo total mes: ',tiempoTotalMess);
                totalAnho:= totalAnho+ tiempoTotalMess;
            end;
            Writeln('Tiempo acceso anho: ',totalAnho:2:2);
        end
      else
        Writeln('No encontrado!');
    end;
    close(texto);
end;

var
  anho: integer;
begin
  //orden anho --> mes --> dia --> idUsuario
  Writeln('Ingrese el anho a informar ');
  readln(anho);
  generarInforme(anho);
end.