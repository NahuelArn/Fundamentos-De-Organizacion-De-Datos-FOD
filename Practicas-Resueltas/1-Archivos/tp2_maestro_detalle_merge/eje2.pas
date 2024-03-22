{
Se dispone de un archivo con información de los alumnos de la Facultad de Informática. Por
cada alumno se dispone de su código de alumno, apellido, nombre, cantidad de materias
(cursadas) aprobadas sin final y cantidad de materias con final aprobado. Además, se tiene
un archivo detalle con el código de alumno e información correspondiente a una materia
(esta información indica si aprobó la cursada o aprobó el final).
Todos los archivos están ordenados por código de alumno y en el archivo detalle puede
haber 0, 1 ó más registros por cada alumno del archivo maestro. Se pide realizar un
programa con opciones para:

a. Actualizar el archivo maestro de la siguiente manera:
i.Si aprobó el final se incrementa en uno la cantidad de materias con final aprobado.
ii.Si aprobó la cursada se incrementa en uno la cantidad de materias aprobadas sin
final.
b. Listar en un archivo de texto los alumnos que tengan más de cuatro materias
con cursada aprobada pero no aprobaron el final. Deben listarse todos los campos.
NOTA: Para la actualización del inciso a) los archivos deben ser recorridos sólo una vez.
}
program eje2;
const 
  fin = 9999;
type
  alumno = record
    cod_alumno: integer;
    apellido: string;
    nombre: string;
    cant_materias_cursadas_aprobadas_sin_final: integer;
    cant_materias_cursadas_aprobadas_con_final: integer;
  end;

  materia = record
    cod_alumno: integer;
    cant_materias_cursadas_aprobadas_sin_final: string;
    cant_materias_cursadas_aprobadas_con_final: string;
  end;
  archivo_disponible = file of alumno;

procedure traerme_la_data(var arch_maestro: text;var arch_detalle: text);
begin
  Assign(arch_maestro, 'D:\Codigo\Fundamentos-De-Organizacion-De-Datos-FOD\Practicas-Resueltas\1-Archivos\tp2_maestro_detalle_merge\archivos_txt\archivo_alumnoEje2.txt');
  Assign(arch_detalle, 'D:\Codigo\Fundamentos-De-Organizacion-De-Datos-FOD\Practicas-Resueltas\1-Archivos\tp2_maestro_detalle_merge\archivos_txt\archivo_detalleEje2.txt');
end;


//modulo bertone
procedure leer_detalle(var arch_detalle:  text; var regd: materia);
begin
  if(not eof(arch_detalle))then
    read(arch_detalle, regd)
  else
    regd.cod_alumno := fin;
end;

procedure actualizar_maestro(var arch_maestro: text;var arch_detalle: text);
var 
  aux: integer;
  totalizador_sin,totalizador_con: integer;
  alumno_actual: integer;
  regm: alumno;
  regd: materia;
begin
  reset(arch_maestro);
  Reset(arch_detalle);
  read(arch_maestro, regm);
  leer_detalle(arch_detalle, regd);
  while(regd.cod_alumno <> fin)do
    begin //corte de control
      totalizador_con:= 0;
      totalizador_sin:= 0;
      alumno_actual:= regd.cod_alumno;
      while (alumno_actual = regd.cod_alumno) do
        begin
          
        end;
    end;
end;

var
  // arch_detalle: archivo_disponible;
  arch_maestro: text;
  arch_detalle: text;
begin
  traerme_la_data(arch_maestro,arch_detalle);
  actualizar_maestro(arch_maestro,arch_detalle);
end.