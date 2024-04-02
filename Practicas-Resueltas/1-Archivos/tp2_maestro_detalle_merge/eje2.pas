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
  str20 = string[20];
  alumno = record
    cod_alumno: integer;
    apellido: str20;
    nombre: str20;
    cant_materias_cursadas_aprobadas_sin_final: integer;
    cant_materias_cursadas_aprobadas_con_final: integer;
  end;

  materia = record
    cod_alumno: integer;
    cant_materias_cursadas_aprobadas_sin_final: str20;
    cant_materias_cursadas_aprobadas_con_final: str20;
  end;

  archivo_logico_estudiante = file of alumno;
  archivo_logico_materia = file of materia;

procedure traerme_la_data(var arch_maestro: text;var arch_detalle: text);
begin
  Assign(arch_maestro, 'D:\Codigo\Fundamentos-De-Organizacion-De-Datos-FOD\Practicas-Resueltas\1-Archivos\tp2_maestro_detalle_merge\archivos_txt\archivo_alumnoEje2.txt');
  Assign(arch_detalle, 'D:\Codigo\Fundamentos-De-Organizacion-De-Datos-FOD\Practicas-Resueltas\1-Archivos\tp2_maestro_detalle_merge\archivos_txt\archivo_detalleEje2.txt');
  reset(arch_maestro);
  reset(arch_detalle);
  // if(not eof(arch_maestro))then
  //   begin
  //       Writeln('casa');
  //       readln(arch_maestro, maestroRegistro.cod_alumno, maestroRegistro.cant_materias_cursadas_aprobadas_sin_final, maestroRegistro.cant_materias_cursadas_aprobadas_con_final, maestroRegistro.apellido, maestroRegistro.nombre);
  //       Writeln('nombre',maestroRegistro.apellido);
  //       readln();
  //   end;
  // if(not eof(arch_detalle))then
  //   Writeln('casa2');
end;

procedure convertir_a_binario(var arch_maestro: archivo_logico_estudiante;var arch_detalle: archivo_logico_materia);
var
  auxMaestro: text;
  auxDetalle: text;
  maestroRegistro: alumno;
  detalleRegistro: materia;
begin
  traerme_la_data(auxMaestro,auxDetalle);
  Assign(arch_maestro, 'D:\Codigo\Fundamentos-De-Organizacion-De-Datos-FOD\Practicas-Resueltas\1-Archivos\tp2_maestro_detalle_merge\archivos_txt\maestroEje2Binario');
  Assign(arch_detalle, 'D:\Codigo\Fundamentos-De-Organizacion-De-Datos-FOD\Practicas-Resueltas\1-Archivos\tp2_maestro_detalle_merge\archivos_txt\detalleEje2Binario');
  Rewrite(arch_maestro);
  Rewrite(arch_detalle);
  while (not eof(auxMaestro)) do
    begin
      readln(auxMaestro, maestroRegistro.cod_alumno);
      readln(auxMaestro, maestroRegistro.apellido);
      readln(auxMaestro, maestroRegistro.nombre);
      readln(auxMaestro, maestroRegistro.cant_materias_cursadas_aprobadas_sin_final, maestroRegistro.cant_materias_cursadas_aprobadas_con_final);
      write(arch_maestro, maestroRegistro);
    end;
  while(not eof(auxDetalle))do
    begin
      readLN(auxDetalle, detalleRegistro.cod_alumno);
      readln(auxDetalle, detalleRegistro.cant_materias_cursadas_aprobadas_sin_final);
      readln(auxDetalle, detalleRegistro.cant_materias_cursadas_aprobadas_con_final);
      write(arch_detalle, detalleRegistro);
    end;
  close(auxMaestro);
  close(auxDetalle);
  close(arch_maestro);
  close(arch_detalle);
end;

//modulo bertone
procedure leer_detalle(var arch_detalle:  archivo_logico_materia; var regd: materia);
begin
  if(not eof(arch_detalle))then
    read(arch_detalle, regd)
  else
    regd.cod_alumno := fin;
end;

procedure actualizar_maestro(var arch_maestro: archivo_logico_estudiante;var arch_detalle: archivo_logico_materia);
var 
  totalizador_sin,totalizador_con: integer;
  alumno_actual: integer;
  regm: alumno;
  regd: materia;
begin
  Reset(arch_maestro);
  Reset(arch_detalle);
  read(arch_maestro, regm);
  leer_detalle(arch_detalle, regd);
  while(regd.cod_alumno <> fin)do //me aseguro q no quedarme sin archivos detalle
    begin //corte de control
      totalizador_con:= 0;
      totalizador_sin:= 0;
      alumno_actual:= regd.cod_alumno;
      while (alumno_actual = regd.cod_alumno) do  //acumulo
        begin
          if(regd.cant_materias_cursadas_aprobadas_sin_final = 'si')then
            totalizador_sin:= totalizador_sin+ 1;
          if(regd.cant_materias_cursadas_aprobadas_con_final = 'si')then
            totalizador_con:= totalizador_con+1;
          leer_detalle(arch_detalle,regd);
        end;
      while(regm.cod_alumno <> alumno_actual)do //busca el detalle actual, en el maestro
        begin
          read(arch_maestro, regm);
        end;
      regm.cant_materias_cursadas_aprobadas_sin_final:= totalizador_con + regm.cant_materias_cursadas_aprobadas_sin_final;
      regm.cant_materias_cursadas_aprobadas_con_final:= totalizador_con + regm.cant_materias_cursadas_aprobadas_con_final;
      Seek(arch_maestro, FilePos(arch_maestro)-1);
      write(arch_maestro,regm);
      if(not eof(arch_maestro))then
        begin
          read(arch_maestro, regm);
        end;
    end;
    close(arch_maestro);
    close(arch_detalle);
end;

procedure imprimir(var arch_maestro: archivo_logico_estudiante);
var
  est: alumno;
begin
  Reset(arch_maestro);
  while (not eof (arch_maestro)) do
    begin
      read(arch_maestro, est);
      writeln('cod: ',est.cod_alumno);
      writeln('aprobadas cursadas ',est.cant_materias_cursadas_aprobadas_sin_final);
      writeln('aprobadas con final ',est.cant_materias_cursadas_aprobadas_con_final);
    end;
  close(arch_maestro);
end;

procedure listar_alumnos_cursada_aprobada(var nuevo_archivardotxt: text;var arch_maestro:archivo_logico_estudiante);
var
  est: alumno;
begin
  reset(arch_maestro);
  Assign(nuevo_archivardotxt, 'D:\Codigo\Fundamentos-De-Organizacion-De-Datos-FOD\Practicas-Resueltas\1-Archivos\tp2_maestro_detalle_merge\archivos_txt\nuevoTextoGeneradoEje2.txt');
  rewrite(nuevo_archivardotxt);
  while (not eof(arch_maestro)) do
    begin 
      read(arch_maestro, est);
      if(est.cant_materias_cursadas_aprobadas_sin_final > 4)then
        begin
          writeln(nuevo_archivardotxt, est.cod_alumno);
          writeln(nuevo_archivardotxt, est.apellido);
          writeln(nuevo_archivardotxt, est.nombre);
          writeln(nuevo_archivardotxt, est.cant_materias_cursadas_aprobadas_sin_final, ' ',est.cant_materias_cursadas_aprobadas_con_final);
          writeln(nuevo_archivardotxt, ' ');
          writeln('cod: ',est.cod_alumno, ' apellido: ',est.apellido, ' nombr: ',est.nombre, ' aprb sin finl: ',est.cant_materias_cursadas_aprobadas_sin_final, ' con finl ',est.cant_materias_cursadas_aprobadas_con_final);
        end;
    end;
  close(arch_maestro);
  close(nuevo_archivardotxt);
end;

var
  arch_maestro: archivo_logico_estudiante;
  arch_detalle: archivo_logico_materia;
  nuevo_archivardotxt: text;
begin
  // traerme_la_data(arch_maestro,arch_detalle);
  convertir_a_binario(arch_maestro,arch_detalle); //los retorna cargados 
  actualizar_maestro(arch_maestro,arch_detalle);  //
  writeln();
  imprimir(arch_maestro);

  listar_alumnos_cursada_aprobada(nuevo_archivardotxt,arch_maestro);
end.








{No me sirve resolver sobre los archivos text, ya que algunas instrucciones no estan disponibles para los text}
{mejor paso los text a binario y listo}
// program eje2;
// const 
//   fin = 9999;
// type
//   alumno = record
//     cod_alumno: integer;
//     apellido: string;
//     nombre: string;
//     cant_materias_cursadas_aprobadas_sin_final: integer;
//     cant_materias_cursadas_aprobadas_con_final: integer;
//   end;

//   materia = record
//     cod_alumno: integer;
//     cant_materias_cursadas_aprobadas_sin_final: string;
//     cant_materias_cursadas_aprobadas_con_final: string;
//   end;
//   archivo_disponible = file of alumno;

// procedure traerme_la_data(var arch_maestro: text;var arch_detalle: text);
// begin
//   Assign(arch_maestro, 'D:\Codigo\Fundamentos-De-Organizacion-De-Datos-FOD\Practicas-Resueltas\1-Archivos\tp2_maestro_detalle_merge\archivos_txt\archivo_alumnoEje2.txt');
//   Assign(arch_detalle, 'D:\Codigo\Fundamentos-De-Organizacion-De-Datos-FOD\Practicas-Resueltas\1-Archivos\tp2_maestro_detalle_merge\archivos_txt\archivo_detalleEje2.txt');
// end;


// //modulo bertone
// procedure leer_detalle(var arch_detalle:  text; var regd: materia);
// begin
//   if(not eof(arch_detalle))then
//     read(arch_detalle, regd.cod_alumno, regd.cant_materias_cursadas_aprobadas_sin_final, regd.cant_materias_cursadas_aprobadas_con_final)
//   else
//     regd.cod_alumno := fin;
// end;

// procedure actualizar_maestro(var arch_maestro: text;var arch_detalle: text);
// var 
//   aux: integer;
//   totalizador_sin,totalizador_con: integer;
//   alumno_actual: integer;
//   regm: alumno;
//   regd: materia;
// begin
//   reset(arch_maestro);
//   Reset(arch_detalle);
//   read(arch_maestro, regm.cod_alumno, regm.apellido,regm.nombre, regm.cant_materias_cursadas_aprobadas_sin_final, regm.cant_materias_cursadas_aprobadas_con_final);
//   leer_detalle(arch_detalle, regd);
//   while(regd.cod_alumno <> fin)do //me aseguro q no quedarme sin archivos detalle
//     begin //corte de control
//       totalizador_con:= 0;
//       totalizador_sin:= 0;
//       alumno_actual:= regd.cod_alumno;
//       while (alumno_actual = regd.cod_alumno) do  //acumulo
//         begin
//           if(regd.cant_materias_cursadas_aprobadas_sin_final = 'si')then
//             totalizador_sin:= totalizador_sin+ 1;
//           if(regd.cant_materias_cursadas_aprobadas_con_final = 'si')then
//             totalizador_con:= totalizador_con+1;
//           leer_detalle(arch_detalle,regd);
//         end;
//       while(regd.cod_alumno <> regm.cod_alumno)do //busca el detalle actual, en el maestro
//         begin
//           read(arch_maestro, regm.cod_alumno, regm.apellido,regm.nombre, regm.cant_materias_cursadas_aprobadas_sin_final, regm.cant_materias_cursadas_aprobadas_con_final);
//         end;
//       regm.cant_materias_cursadas_aprobadas_sin_final:= totalizador_con;
//       regm.cant_materias_cursadas_aprobadas_con_final:= totalizador_con;
//       Seek(arch_maestro, FilePos(arch_maestro)-1);
//       // write(arch_maestro,regm);
//       write(arch_maestro,regm.cod_alumno, regm.apellido, regm.nombre, regm.nombre, regm.cant_materias_cursadas_aprobadas_sin_final, regm.cant_materias_cursadas_aprobadas_con_final);
//       if(not eof(arch_maestro))then
//         begin
//           read(arch_maestro, regm.cod_alumno, regm.apellido,regm.nombre, regm.cant_materias_cursadas_aprobadas_sin_final, regm.cant_materias_cursadas_aprobadas_con_final);
//         end;
//     end;
//     close(arch_maestro);
//     close(arch_detalle);
// end;

// var
//   // arch_detalle: archivo_disponible;
//   arch_maestro: text;
//   arch_detalle: text;
// begin
//   traerme_la_data(arch_maestro,arch_detalle);
//   actualizar_maestro(arch_maestro,arch_detalle);  //A
// end.
