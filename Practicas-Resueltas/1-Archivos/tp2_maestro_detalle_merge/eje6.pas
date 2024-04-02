{6- Se desea modelar la información necesaria para un sistema de recuentos de casos de
 covid para el ministerio de salud de la provincia de buenos aires.

 Diariamente se reciben archivos provenientes de los distintos municipios, la información
 contenida en los mismos es la siguiente: código de localidad, código cepa, cantidad casos
 activos, cantidad de casos nuevos, cantidad de casos recuperados, cantidad de casos
 fallecidos.
 El ministerio cuenta con un archivo maestro con la siguiente información: código localidad,
 nombre localidad, código cepa, nombre cepa, cantidad casos activos, cantidad casos
 nuevos, cantidad recuperados y cantidad de fallecidos.
 Se debe realizar el procedimiento que permita actualizar el maestro con los detalles
 recibidos, se reciben 10 detalles. Todos los archivos están ordenados por código de
 localidad y código de cepa. 
Para la actualización se debe proceder de la siguiente manera: 
    1. Al número de fallecidos se le suman el valor de fallecidos recibido del detalle.
    2. Idem anterior para los recuperados.
    3. Los casos activos se actualizan con el valor recibido en el detalle.
    4. Idem anterior para los casos nuevos hallados.
 Realice las declaraciones necesarias, el programa principal y los procedimientos que
 requiera para la actualización solicitada e informe cantidad de localidades con más de 50
 casos activos (las localidades pueden o no haber sido actualizadas).}
 
program eje6;
const
  dimFDetalles = 3;
  valorAlto = 999;
type
  r_casos_detalle = record
    codLocalidad: integer;
    codCepa: integer;
    cantCasosActivos: integer;
    cantCasosNuevos: integer;
    cantCasosRecuperados: integer;
    cantCasosFallecidos: integer;
  end;
  r_casos_maestro = record
    codLocalidad: integer;
    nombreLocalidad: string;
    codCepa: integer;
    nombreCepa: string;
    cantCasosActivos: integer;
    cantCasosNuevos: integer;
    cantRecuperados: integer;
    cantFallecidos: integer;
  end;

  archivo_detalle = file of r_casos_detalle;
  archivo_maestro = file of r_casos_maestro;

  vector_archivo_detalle = array[1..dimFDetalles] of archivo_detalle;
  vector_registro_detalle = array[1..dimFDetalles]of r_casos_detalle;

procedure cargarMaestro(var archM: archivo_maestro);
  procedure leerData(var r: r_casos_maestro);
  begin
    Writeln('Codigo de localidad: ');
    readln(r.codLocalidad);
    Writeln('Nombre de localidad ');
    r.nombreLocalidad:= 'casa';
    Writeln('Cod cepa: ');
    readln(r.codCepa);
    Writeln('Nombre cepa: ');
    r.nombreCepa:= 'ferlas';
    Writeln('Cantidad de casos activos ');
    r.cantCasosActivos:= 10;
    Writeln('Cantidad de casos nuevos ');
    r.cantCasosNuevos:= 10;
    Writeln('Cantidad de recuperados ');
    r.cantRecuperados:= 10;
    Writeln('Cantidad de fallecidos ');
    r.cantFallecidos:= 0;
  end;

var
  longitudMaestro,i: integer;
  r: r_casos_maestro;
begin
  Writeln('Ingrese cuantos registros quiere que contenga el maestro');
  readln(longitudMaestro);
  if(longitudMaestro = 0)then
    longitudMaestro:= 1;
  Assign(archM, 'D:\Codigo\Fundamentos-De-Organizacion-De-Datos-FOD\Practicas-Resueltas\1-Archivos\tp2_maestro_detalle_merge\archivos_txt\eje6Archivos\binarioMaestro');
  rewrite(archM);
  for i:= 1  to longitudMaestro do
    begin
      leerData(r);
      write(archM, r);
    end;
  close(archM);
end;

procedure cargarDetalles(var vAD: vector_archivo_detalle);
  const longitudCadaArchivo= 2;
  procedure leer(var r: r_casos_detalle);
  begin
    Writeln('Codigo de localidad ');
    ReadLn(r.codLocalidad);
    Writeln('Ingrese el codigo de cepa: ');
    readln(r.codCepa);
    Writeln('Ingrese la cantidad de casos activos ');
    r.cantCasosActivos:= 0;
    Writeln('Ingrese la cantidad de casos nuevos ');
    r.cantCasosNuevos:= 0;
    Writeln('Ingrese la cantidad recuperados ');
    r.cantCasosRecuperados:= 10;
    Writeln('Ingrese la cantidad de fallecidos');
    r.cantCasosFallecidos:= 0;
  end;
var
  i,o: integer;
  direccion_mutable, direccion_inmutable, casa: string;
  r: r_casos_detalle;
  //aD: archivo_detalle;
begin
  direccion_inmutable:= 'D:\Codigo\Fundamentos-De-Organizacion-De-Datos-FOD\Practicas-Resueltas\1-Archivos\tp2_maestro_detalle_merge\archivos_txt\eje6Archivos\binarioDetalle';
  for i:=  1 to dimFDetalles do
    begin
      str(i, casa);
      direccion_mutable:= direccion_inmutable + casa;
      Assign(vAD[i], direccion_mutable);
      rewrite(vAD[i]);
      for o :=  1 to longitudCadaArchivo do
        begin
          leer(r);
          write(vAD[i], r);
        end;
      close(vAD[i]);
      writeln('saliste de un archivo');
    end;
end;

procedure leer_primera_vez(var vAD: vector_archivo_detalle; var vRD: vector_registro_detalle);
var
  u: integer;
begin
  for u:= 1 to dimFDetalles do
    begin
      reset(vAD[u]);
      read(vAD[u], vRD[u]);
    end;
end;

procedure leer(var arch: archivo_detalle;var dato: r_casos_detalle);
begin
  if(not eof (arch))then
    read(arch, dato)
  else
    begin
      dato.codLocalidad:= valorAlto;
      dato.codCepa:= valorAlto;
    end;
end;

procedure minimo(var vAD: vector_archivo_detalle; var vRD: vector_registro_detalle;var min: r_casos_detalle);
var
  i,pos: integer;
begin
  min.codLocalidad:= valorAlto;
  min.codCepa:= valorAlto;
  for i:= 1 to dimFDetalles do
    begin
      if(vRD[i].codLocalidad < min.codLocalidad) and (vRD[i].codCepa < min.codCepa)then
        begin
          min:= vRD[i];
          pos:= i;
        end;
    end;
  if(min.codLocalidad <> valorAlto) and (vRD[pos].codCepa <> valorAlto)then
    begin
      min:= vRD[pos];
      leer(vAD[pos], vRD[pos]);
    end;
end;

procedure actualizar_maestro(var archM: archivo_maestro; var vAD: vector_archivo_detalle; var vRD: vector_registro_detalle);
var
  min: r_casos_detalle;
  rM: r_casos_maestro;
  aux: r_casos_maestro;
  cantLocalidades50,i: integer;
begin
  reset(archM);
  read(archM, rM);
  leer_primera_vez(vAD,vRD);
  minimo(vAD, vRD, min);
  cantLocalidades50:= 0;
  while (min.codLocalidad <> valorAlto) do
    begin
      aux.codLocalidad:= min.codLocalidad;
      while (min.codLocalidad <> valorAlto) and (aux.codLocalidad = min.codLocalidad) do
        begin
          aux.codCepa:= min.codCepa;
          aux.cantFallecidos:= 0;
          aux.cantRecuperados:= 0;
          aux.cantCasosActivos:= 0;
          aux.cantCasosNuevos:= 0;
          while (min.codLocalidad <> valorAlto) and (aux.codLocalidad = min.codLocalidad) and (aux.codCepa = min.codCepa) do
            begin
              aux.cantFallecidos:= aux.cantFallecidos + min.cantCasosFallecidos;
              aux.cantRecuperados:= aux.cantRecuperados + min.cantCasosRecuperados;
              aux.cantCasosActivos:= aux.cantCasosActivos + min.cantCasosActivos;
              aux.cantCasosNuevos:= aux.cantCasosNuevos + min.cantCasosNuevos;
              minimo(vAD,vRD,min);
            end;
          while (aux.codLocalidad <> rM.codLocalidad) and (aux.codCepa <> rM.codCepa)do
            begin
              read(archM, rM);
            end;
          Seek(archM, filePos(archM)-1);
          rM.cantFallecidos:= rM.cantFallecidos + aux.cantFallecidos;
          rM.cantRecuperados:= rM.cantRecuperados + aux.cantRecuperados;
          rM.cantCasosActivos:= rM.cantCasosActivos + aux.cantCasosActivos;
          rM.cantCasosNuevos:= rM.cantCasosNuevos + aux.cantCasosNuevos;
          write(archM, rM);
          if(not eof (archM))then
            read(archM,rM);
          if(rM.cantCasosActivos > 50)then
            cantLocalidades50:= cantLocalidades50+1;
        end;
    end;
    close(archM);
    for i :=  1 to dimFDetalles do
      begin
        close(vAD[i]);
      end;
    Writeln(' 50 : ', cantLocalidades50);
end;

var
  archM: archivo_maestro;
  vAD: vector_archivo_detalle;
  vRD: vector_registro_detalle;
begin
  cargarMaestro(archM);
  Writeln('Detalles');
  
  cargarDetalles(vAD);
  Writeln('Rompo aca');
  //criterio de orden, codigo de localidad y codigo de cepa
  actualizar_maestro(archM,vAD,vRD);
  Writeln('Rompo aca2');
  {M
  1,2 | 2,1| 3,1


  D
  1, 2 | 2,1 | 3,2
  1,2 | 2,1 | 3,1
  
  
  }
end.