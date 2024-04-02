{
  4. Suponga que trabaja en una oficina donde está montada una LAN (red local). La misma
fue construida sobre una topología de red que conecta 5 máquinas entre sí y todas las
máquinas se conectan con un servidor central. Semanalmente cada máquina genera un
archivo de logs informando las sesiones abiertas por cada usuario en cada terminal y por
cuánto tiempo estuvo abierta. Cada archivo detalle contiene los siguientes campos:
cod_usuario, fecha, tiempo_sesion. Debe realizar un procedimiento que reciba los archivos
detalle y genere un archivo maestro con los siguientes datos: cod_usuario, fecha,
tiempo_total_de_sesiones_abiertas.
Notas:
- Cada archivo detalle está ordenado por cod_usuario y fecha.
- Un usuario puede iniciar más de una sesión el mismo día en la misma o en diferentes
máquinas.
- El archivo maestro debe crearse en la siguiente ubicación física: /var/log

}
program eje4;
const
  dimF_detalles= 1;
  fin = 9999;
type
  maquina = record  
    cod_usuario: integer;
    fecha: integer;
    tiempo_sesion: real;
  end;

  servidor = record
    cod_usuario: integer;
    fecha: integer;
    tiempo_total_de_sesiones_abiertas: real;
  end;

  detalle = file of maquina;
  maestro = file of servidor;

  vector_detalles = array[1..dimF_detalles]of detalle;
  vector_registros_maquina = array[1..dimF_detalles]of maquina;

procedure leer_maquina(var maq: maquina; i: integer);
begin
  Writeln('Ingrese el cod de usuario: ');
  maq.cod_usuario:= i;
  Writeln('Ingrese la fecha ');
  maq.fecha:= 2000 +i;
  Writeln('Ingrese el tiempo de sesion: ');
  maq.tiempo_sesion:= random(24)+1;
end;

procedure leer_maquina2(var maq: maquina);
begin
  Writeln('Ingrese el cod de usuario: ');
  // readln(maq.cod_usuario);
  maq.cod_usuario:= 1;
  Writeln('Ingrese la fecha ');
  readln(maq.fecha);
  Writeln('Ingrese el tiempo de sesion: ');
  readln(maq.tiempo_sesion);
end;

procedure generar_detalles(var vD: vector_detalles);
var
  maq: maquina;
  i,o: integer;
  det: detalle;
  direccion_absoluta_inmutable,direccion_absoluta_mutable,casa: string;
  eleccion: integer;
begin
  direccion_absoluta_inmutable:= 'D:\Codigo\Fundamentos-De-Organizacion-De-Datos-FOD\Practicas-Resueltas\1-Archivos\tp2_maestro_detalle_merge\archivos_txt\eje4Archivos\maquina';
  Writeln('Ingrese como quiere cargar los detalles, 1 manual, 2 Automatico');
  readln(eleccion);
  if(eleccion = 2)then
    begin
      for i:= 1 to dimF_detalles do
        begin
          str(i, casa); //parsea a String
          direccion_absoluta_mutable:= direccion_absoluta_inmutable+casa;
          Assign(det, direccion_absoluta_mutable);
          rewrite(det);
          for o:= 1 to dimF_detalles-2 do
            begin
              leer_maquina(maq,o);
              write(det, maq); 
            end;
          close(det);
          vD[i]:= det;  //guarda los archivos cerrados
        end;
    end
  else
    if(eleccion = 1)then
      begin
        for i:= 1 to dimF_detalles do
          begin
            str(i, casa); //parsea a String
            direccion_absoluta_mutable:= direccion_absoluta_inmutable+casa;
            Assign(det, direccion_absoluta_mutable);
            rewrite(det);
            for o:= 1 to 4 do
              begin
                leer_maquina2(maq);
                write(det, maq); 
              end;
            close(det);
            vD[i]:= det;  //guarda los archivos cerrados
          end;
      end;
end;

procedure impresion(var vD: vector_detalles);
var
  i: integer;
  maq: maquina;
begin
  for i:= 1 to dimF_detalles do
    begin
      reset(vD[i]);
      writeln();
      while(not eof (vD[i]))do
        begin
          read(vD[i],maq);
          Writeln('cod user: ',maq.cod_usuario, ' tiempo de sesion: ',maq.tiempo_sesion:2:2);
        end;
      close(vD[i]);
      writeln();
      Writeln('----------------------');
    end;
end;

procedure leer(var d: detalle; var r: maquina);
begin
  if(not eof (d))then
    read(d,r)
  else
    begin
      r.cod_usuario:= fin;
      r.fecha:= fin;
    end;
end;

procedure leer_primera_vez(var vD: vector_detalles; var vR: vector_registros_maquina);
var
  i: integer;
begin
  for i:=  1 to dimF_detalles do
    begin
      reset(vD[i]);
      leer(vD[i],vR[i]);
    end;
end;

procedure minimo(var vD: vector_detalles; var vR: vector_registros_maquina;var min:maquina);
var
  i,pos: integer;
begin
  min.cod_usuario:= fin;
  for i:= 1 to dimF_detalles do
    begin
      if(vR[i].cod_usuario < min.cod_usuario)then
        begin
          min:= vR[i];
          pos:= i;
        end;
    end;
  if(min.cod_usuario <> fin)then
    begin
      min:= vR[pos];
      leer(vD[pos], vR[pos]);
    end;
end;

procedure cerrar_detalles(var vD: vector_detalles);
var
  i: integer;
begin
  for i:=  1 to dimF_detalles do
    begin
      close(vD[i]);
    end;
end;

procedure merge(var mae: maestro; var vD: vector_detalles; var vR: vector_registros_maquina);
var
  rm,aux: servidor;
  min: maquina;
  cod_actual,fecha_actual: integer;
  tiempo_total_fecha, tiempo_total_codigo: real;
begin
  rewrite(mae); //CREO EL MAESTRO
  leer_primera_vez(vD,vR);  //LEO X5
  minimo(vD,vR,min);  //
  
  while(min.cod_usuario <> fin)do
    begin
      tiempo_total_codigo:= 0;
      cod_actual:= min.cod_usuario;
      while (min.cod_usuario <> fin) and (cod_actual = min.cod_usuario) do
        begin
          fecha_actual:= min.fecha;
          tiempo_total_fecha:= 0;
          while (min.cod_usuario <> fin) and (cod_actual = min.cod_usuario) and (fecha_actual = min.fecha) do
            begin
              tiempo_total_fecha:= min.tiempo_sesion+tiempo_total_fecha;
              minimo(vD,vR,min);
            end;
            //sali de la fecha actual
            aux.cod_usuario:= cod_actual;
            aux.fecha:= fecha_actual;
            aux.tiempo_total_de_sesiones_abiertas := tiempo_total_fecha;
            tiempo_total_codigo:= aux.tiempo_total_de_sesiones_abiertas+tiempo_total_codigo;
            write(mae, aux);
        end;
        //sali del codigo actual del usuario
        // aux.cod_usuario:= cod_actual;
        // aux.fecha:= min.fecha;
        // aux.tiempo_total_de_sesiones_abiertas:= tiempo_total_codigo;
        // write(mae, aux);
    end;
    //sali 
    cerrar_detalles(vD);
    close(mae);
end;


procedure imprimir_maestro(var mae: maestro);
var
  serv: servidor;
begin
  reset(mae);
  while (not eof (mae))do
    begin
      read(mae, serv);
      Writeln('Codigo: ',serv.cod_usuario, ' fecha: ',serv.fecha, ' tiempo total de sesion: ',serv.tiempo_total_de_sesiones_abiertas:2:2);
    end;
  close(mae);
end;

var
  vD: vector_detalles;
  vR: vector_registros_maquina;
  mae: maestro;
begin
  randomize;
  generar_detalles(vD);
  // impresion(vD);
  Assign(mae, 'D:\Codigo\Fundamentos-De-Organizacion-De-Datos-FOD\Practicas-Resueltas\1-Archivos\tp2_maestro_detalle_merge\archivos_txt\eje4Archivos\maestro');
  merge(mae,vD,vR);
  imprimir_maestro(mae);
end.