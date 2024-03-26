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
  dimF_detalles= 5;
  fin = 9999;
type
  maquina = record  
    cod_usuario: integer;
    fecha: string;
    tiempo_sesion: real;
  end;

  servidor = record
    cod_usuario: integer;
    fecha: string;
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
  maq.fecha:= 2000+i;
  Writeln('Ingrese el tiempo de sesion: ');
  maq.tiempo_sesion:= random(24)+1;
end;

procedure generar_detalles(var vD: vector_detalles);
var
  maq: maquina;
  i,o: integer;
  det: detalle;
  direccion_absoluta_inmutable,direccion_absoluta_mutable,casa: string;
begin
  direccion_absoluta_inmutable:= 'D:\Codigo\Fundamentos-De-Organizacion-De-Datos-FOD\Practicas-Resueltas\1-Archivos\tp2_maestro_detalle_merge\archivos_txt\eje4Archivos\maquina';
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
      Writeln('Entraste en uno');
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
var
  i: integer;
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
          min= vR[i];
          pos:= i;
        end;
    end;
  if(min.cod_usuario <> fin)then
    begin
      min:= vR[pos];
      leer(vD[pos], vR[pos]);
    end;
end;

procedure merge(var mae: maestro; var vD: vector_detalles; var vR: vector_registros_maquina);
var
  rm: servidor;
  min: maquina;
  cod_actual,fecha_actual: integer;
  tiempo_total: real;
begin
  rewrite(mae);
  leer_primera_vez(vD,vR);
  read(mae, rm);
  minimo(vD,vR,min);
  while(min.cod_usuario <> fin)do
    begin
      tiempo_total:= 0;
      cod_actual:= min.cod_usuario;
      while (cod_actual = min.cod_usuario) do
        begin
          fecha_actual:= min.fecha;
          while (fecha_actual = min.fecha) do
            begin
              tiempo_total:= min.tiempo_sesion+tiempo_total;
              minimo(vD,vR,min);
            end;
        end;
        write(mae, );
    end;
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
  merge(mae,vD.vR);


  {
      Hacerlo de nuevo
      el tema de la logica del merge...




  }
end.