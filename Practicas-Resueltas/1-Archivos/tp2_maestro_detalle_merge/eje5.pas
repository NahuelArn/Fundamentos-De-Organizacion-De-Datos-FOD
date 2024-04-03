{
  5.              (Voldemort?)
   A partir de un siniestro ocurrido se perdieron las actas de nacimiento y fallecimientos de
  toda la provincia de buenos aires de los últimos diez años. En pos de recuperar dicha
  información, se deberá procesar 2 archivos por cada una de las 50 delegaciones distribuidas
  en la provincia, un archivo de nacimientos y otro de fallecimientos y crear el archivo maestro
  reuniendo dicha información.

  Los archivos detalles con nacimientos, contendrán la siguiente información: nro partida
  nacimiento, nombre, apellido, dirección detallada (calle,nro, piso, depto, ciudad), matrícula
  del médico, nombre y apellido de la madre, DNI madre, nombre y apellido del padre, DNI del
  padre.

  En cambio, los 50 archivos de fallecimientos tendrán: nro partida nacimiento, DNI, nombre y
  apellido del fallecido, matrícula del médico que firma el deceso, fecha y hora del deceso y
  lugar.


  Realizar un programa que cree el archivo maestro a partir de toda la información de los
  archivos detalles. Se debe almacenar en el maestro: nro partida nacimiento, nombre,
  apellido, dirección detallada (calle,nro, piso, depto, ciudad), matrícula del médico, nombre y
  apellido de la madre, DNI madre, nombre y apellido del padre, DNI del padre y si falleció,
  además matrícula del médico que firma el deceso, fecha y hora del deceso y lugar. Se
  deberá, además, listar en un archivo de texto la información recolectada de cada persona

  Nota: Todos los archivos están ordenados por nro partida de nacimiento que es única.
  Tenga en cuenta que no necesariamente va a fallecer en el distrito donde nació la persona y
  además puede no haber fallecido.

}

program eje5;
const
  dimF_detalle = 3;
  valorAlto = 999;
type
  data_adulto = record
    nombre_y_apellido__del_adulto: string;
    dni: integer;
  end;
//mira aca
  acta_nacimiento = record
    nro_partida_nacimiento: integer;
    dni: integer;
  end;
 //------------------------------------------------
 
//mira aca
  acta_fallecimiento = record
    nro_partida_nacimiento: integer;
    dni: integer;
    matricula_medico_firma_deceso: integer;
    fecha_anho: integer;
  end;
//mira aca
  rMaestro = record
    nro_partida_nacimiento: integer;
    dni: integer;
    se_murio: boolean; //si o no
    matricula_medico_firma_deceso: integer;
    fecha_anho: integer;
  end;

  dNacimiento = file of acta_nacimiento;
  dFallecimiento = file of acta_fallecimiento;
  mMaestro = file of rMaestro;

  vector_nacimientos = array[1..dimF_detalle]of dNacimiento;
  vector_fallecimientos = array[1..dimF_detalle] of dFallecimiento;

  vector_r_nacimiento = array[1..dimF_detalle]of acta_nacimiento;
  vector_r_fallecimiento = array[1..dimF_detalle]of acta_fallecimiento;


procedure leer_dataN(var rN: acta_nacimiento);
begin
  Writeln('Ingrese el numero de partida');
  readln(rN.nro_partida_nacimiento);
  Writeln('Ingres el dni');
  rN.dni:= 00;
end;

procedure leer_dataF(var rN: acta_fallecimiento);
begin
  Writeln('Ingrese el numero de partida');
  readln(rN.nro_partida_nacimiento);
  Writeln('Ingres el dni');
  rN.dni:= 121;
  Writeln('Ingrese la matricula de la firma de deceso');
  rN.matricula_medico_firma_deceso:= 212;
  Writeln('Ingrese el anho');
  rN.fecha_anho:= 222;

end;

procedure generar_detalles(var vDN: vector_nacimientos; var vDF: vector_fallecimientos);
var
  i: integer;
  nD: dNacimiento;
  fD: dFallecimiento;
  direccion_inmutable, direccion_mutable, casa: string;
  rN: acta_nacimiento; rF: acta_fallecimiento;
begin
  direccion_inmutable:= 'D:\Codigo\Fundamentos-De-Organizacion-De-Datos-FOD\Practicas-Resueltas\1-Archivos\tp2_maestro_detalle_merge\archivos_txt\eje5Archivos\binarioNacimiento';
  Writeln('nacimiento');
  for i:= 1 to dimF_detalle do
    begin
      str(i, casa);
      direccion_mutable:= direccion_inmutable+casa;
      Assign(nD, direccion_mutable);
      rewrite(nD);
      leer_dataN(rN);
      write(nD, rN);
      close(nD);
      vDN[i]:= nD;
    end;
  Writeln('fallecimeinto');
  direccion_inmutable:= 'D:\Codigo\Fundamentos-De-Organizacion-De-Datos-FOD\Practicas-Resueltas\1-Archivos\tp2_maestro_detalle_merge\archivos_txt\eje5Archivos\binarioFallecimiento';
  for i:= 1 to dimF_detalle-1 do
    begin
      str(i, casa);
      direccion_mutable:= direccion_inmutable+casa; 
      Assign(fD, direccion_mutable);
      rewrite(fD);
      leer_dataF(rF);
      write(fD, rF);
      close(fD);
      vDF[i]:= fD;
    end;
end;

procedure leer_primera_vez(var vDN: vector_nacimientos; var vDF: vector_fallecimientos; var v1: vector_r_nacimiento; var v2: vector_r_fallecimiento);
var
  i: integer;
begin
  for i :=  1 to dimF_detalle do
    begin
      reset(vDN[i]);
      read(vDN[i], v1[i])
    end;
  for i:= 1 to dimF_detalle-1 do
    begin
      reset(vDF[i]);
      read(vDF[i], v2[i]);
    end;
end;

procedure leer(var archivo: dNacimiento; var dato: acta_nacimiento);
begin
  if(not eof (archivo))then
    begin
      read(archivo, dato);
    end
  else
    dato.nro_partida_nacimiento:= valorAlto;
end;

procedure minimo1(var vDN: vector_nacimientos; var v1: vector_r_nacimiento; var min1: acta_nacimiento);
var
  i,pos: integer;
begin
  min1.nro_partida_nacimiento:= valorAlto;
  for i:= 1 to dimF_detalle do
    begin
      if(v1[i].nro_partida_nacimiento < min1.nro_partida_nacimiento)then
        begin
          min1:= v1[i];
          pos:= i;
        end;
    end;
    if(min1.nro_partida_nacimiento <> valorAlto)then
      begin
        min1:= v1[pos];
        leer(vDN[pos], v1[pos]);
      end;
end;

procedure leer2(var archivo: dFallecimiento; var dato: acta_fallecimiento);
begin
  if(not eof(archivo))then
    begin
      read(archivo, dato);
    end
  else
    dato.nro_partida_nacimiento:= valorAlto;
end;

procedure minimo2(var vDF: vector_fallecimientos;var v2: vector_r_fallecimiento; var min2: acta_fallecimiento); 
var
  pos,i: integer;
begin
  min2.nro_partida_nacimiento:= valorAlto;  
  for i:= 1 to dimF_detalle-1 do
    begin
      if(v2[i].nro_partida_nacimiento < min2.nro_partida_nacimiento)then  
        begin
          min2:= v2[i];
          pos:= i;
        end;
    end;
    if(min2.nro_partida_nacimiento <> valorAlto)then
      begin
        min2:= v2[pos];
        leer2(vDF[pos], v2[pos]);
      end;
end;

procedure cerrar_todos(var vDN: vector_nacimientos;var vDF: vector_fallecimientos);
var i: integer;
begin
  for i:= 1 to dimF_detalle do
    begin
      close(vDN[i]);
    end;
  for i:= 1 to dimF_detalle-1 do
    begin
      close(vDF[i]);
    end;
end;

procedure crear_maestro(var vDN: vector_nacimientos; var vDF: vector_fallecimientos;var mae: mMaestro);
var
  r: rMaestro;
  v1: vector_r_nacimiento; v2: vector_r_fallecimiento;
  min1: acta_nacimiento;  min2: acta_fallecimiento;
begin
  Assign(mae, 'D:\Codigo\Fundamentos-De-Organizacion-De-Datos-FOD\Practicas-Resueltas\1-Archivos\tp2_maestro_detalle_merge\archivos_txt\eje5Archivos\binarioMaestro');
  rewrite(mae);
  leer_primera_vez(vDN,vDF,v1,v2);
  readln();
  minimo1(vDN,v1,min1);
  minimo2(vDF,v2, min2);
  while(min1.nro_partida_nacimiento <> valorAlto)do 
    begin
      if(min1.nro_partida_nacimiento <> min2.nro_partida_nacimiento)then 
        r.se_murio:= false  
      else  //se murio
        begin
          r.se_murio:= true;
          r.matricula_medico_firma_deceso:= min2.matricula_medico_firma_deceso;
          r.fecha_anho:= min2.fecha_anho;
          minimo2(vDF,v2, min2); 
        end;
      r.nro_partida_nacimiento:= min1.nro_partida_nacimiento;
      r.dni:= min1.dni;
      write(mae,r);
      minimo1(vDN,v1,min1);
    end;
  cerrar_todos(vDN,vDF);
  close(mae);
end;

procedure imprimir_maestro(var mae: mMaestro);
var
  r: rMaestro;
begin
  reset(mae);
  while(not eof(mae))do
    begin
      read(mae, r);
      Writeln('casa ', r.se_murio);
    end;
  close(mae);
end;

var
  vDN: vector_nacimientos;
  vDF: vector_fallecimientos;
  mae: mMaestro;

  a: acta_nacimiento;
  i: integer;
begin
  Writeln('creando detalles: ');
  generar_detalles(vDN, vDF);
  writeln('creando maestro');
  crear_maestro(vDN,vDF,mae);
  writeln('imprimeindo main');
  imprimir_maestro(mae);
end.














// //ANDANDO
// program eje5;
// const
//   dimF_detalle = 3;
//   valorAlto = 999;
// type
//   data_adulto = record
//     nombre_y_apellido__del_adulto: string;
//     dni: integer;
//   end;
// //mira aca
//   acta_nacimiento = record
//     nro_partida_nacimiento: integer;
//     dni: integer;
//   end;
//  //------------------------------------------------
 
// //mira aca
//   acta_fallecimiento = record
//     nro_partida_nacimiento: integer;
//     dni: integer;
//     matricula_medico_firma_deceso: integer;
//     fecha_anho: integer;
//   end;
// //mira aca
//   rMaestro = record
//     nro_partida_nacimiento: integer;
//     dni: integer;
//     se_murio: boolean; //si o no
//     matricula_medico_firma_deceso: integer;
//     fecha_anho: integer;
//   end;

//   dNacimiento = file of acta_nacimiento;
//   dFallecimiento = file of acta_fallecimiento;
//   mMaestro = file of rMaestro;

//   vector_nacimientos = array[1..dimF_detalle]of dNacimiento;
//   vector_fallecimientos = array[1..dimF_detalle] of dFallecimiento;

//   vector_r_nacimiento = array[1..dimF_detalle]of acta_nacimiento;
//   vector_r_fallecimiento = array[1..dimF_detalle]of acta_fallecimiento;


// procedure leer_dataN(var rN: acta_nacimiento);
// begin
//   Writeln('Ingrese el numero de partida');
//   readln(rN.nro_partida_nacimiento);
//   Writeln('Ingres el dni');
//   rN.dni:= 00;
// end;

// procedure leer_dataF(var rN: acta_fallecimiento);
// begin
//   Writeln('Ingrese el numero de partida');
//   readln(rN.nro_partida_nacimiento);
//   Writeln('Ingres el dni');
//   rN.dni:= 121;
//   Writeln('Ingrese la matricula de la firma de deceso');
//   rN.matricula_medico_firma_deceso:= 212;
//   Writeln('Ingrese el anho');
//   rN.fecha_anho:= 222;

// end;

// procedure generar_detalles(var vDN: vector_nacimientos; var vDF: vector_fallecimientos);
// var
//   i: integer;
//   nD: dNacimiento;
//   fD: dFallecimiento;
//   direccion_inmutable, direccion_mutable, casa: string;
//   rN: acta_nacimiento; rF: acta_fallecimiento;
// begin
//   //vamos a cargar 3 nacimiento y 2 fallecimientos
//   direccion_inmutable:= 'D:\Codigo\Fundamentos-De-Organizacion-De-Datos-FOD\Practicas-Resueltas\1-Archivos\tp2_maestro_detalle_merge\archivos_txt\eje5Archivos\binarioNacimiento';
//   //nacimiento
//   Writeln('nacimiento');
//   for i:= 1 to dimF_detalle do
//     begin
//       str(i, casa);
//       direccion_mutable:= direccion_inmutable+casa;
//       Assign(nD, direccion_mutable);
//       rewrite(nD);
//       leer_dataN(rN);
//       write(nD, rN);
//       close(nD);
//       vDN[i]:= nD;
//     end;
//   //fallecimiento
//   Writeln('fallecimeinto');
//   direccion_inmutable:= 'D:\Codigo\Fundamentos-De-Organizacion-De-Datos-FOD\Practicas-Resueltas\1-Archivos\tp2_maestro_detalle_merge\archivos_txt\eje5Archivos\binarioFallecimiento';
//   for i:= 1 to dimF_detalle-1 do
//     begin
//       str(i, casa);
//       direccion_mutable:= direccion_inmutable+casa; //jasjajsda q pelotudo, le pegaba 2 veces a la direccion abs
//       Assign(fD, direccion_mutable);
//       rewrite(fD);
//       leer_dataF(rF);
//       write(fD, rF);
//       close(fD);
//       vDF[i]:= fD;
//     end;
// end;

// procedure leer_primera_vez(var vDN: vector_nacimientos; var vDF: vector_fallecimientos; var v1: vector_r_nacimiento; var v2: vector_r_fallecimiento);
// var
//   i: integer;
// begin
//   //en este casp voy a tener que manejar 2 veces un for, por q en los de fallecimiento manejo -1
//   for i :=  1 to dimF_detalle do
//     begin
//       reset(vDN[i]);
//       read(vDN[i], v1[i])
//     end;
//   writeln('rompo 0');
//   for i:= 1 to dimF_detalle-1 do
//     begin
//       writeln('entro aca');
//       reset(vDF[i]);
//       writeln('entro aca2');
//       read(vDF[i], v2[i]);
//     end;
//   writeln('rompo 1');
// end;

// procedure leer(var archivo: dNacimiento; var dato: acta_nacimiento);
// begin
//   if(not eof (archivo))then
//     begin
//       read(archivo, dato);
//     end
//   else
//     dato.nro_partida_nacimiento:= valorAlto;
// end;

// procedure minimo1(var vDN: vector_nacimientos; var v1: vector_r_nacimiento; var min1: acta_nacimiento);
// var
//   i,pos: integer;
// begin
//   min1.nro_partida_nacimiento:= valorAlto;
//   for i:= 1 to dimF_detalle do
//     begin
//       if(v1[i].nro_partida_nacimiento < min1.nro_partida_nacimiento)then
//         begin
//           min1:= v1[i];
//           pos:= i;
//         end;
//     end;
//     if(min1.nro_partida_nacimiento <> valorAlto)then
//       begin
//         min1:= v1[pos];
//         leer(vDN[pos], v1[pos]);
//       end;
// end;

// procedure leer2(var archivo: dFallecimiento; var dato: acta_fallecimiento);
// begin
//   if(not eof(archivo))then
//     begin
//       read(archivo, dato);
//     end
//   else
//     dato.nro_partida_nacimiento:= valorAlto;
// end;

// procedure minimo2(var vDF: vector_fallecimientos;var v2: vector_r_fallecimiento; var min2: acta_fallecimiento); //el vector de registros son mis jugadores finalizadados
// var
//   pos,i: integer;
// begin
//   min2.nro_partida_nacimiento:= valorAlto;  //si soy el ultimo caso, reviento el corte y termina el programa
//   for i:= 1 to dimF_detalle-1 do
//     begin
//       if(v2[i].nro_partida_nacimiento < min2.nro_partida_nacimiento)then  //De todos los primeros registro cual es el menor
//         begin
//           min2:= v2[i];
//           pos:= i;
//         end;
//     end;
//     if(min2.nro_partida_nacimiento <> valorAlto)then
//       begin
//         min2:= v2[pos];
//         leer2(vDF[pos], v2[pos]);
//       end;
// end;

// procedure cerrar_todos(var vDN: vector_nacimientos;var vDF: vector_fallecimientos);
// var i: integer;
// begin
//   for i:= 1 to dimF_detalle do
//     begin
//       close(vDN[i]);
//     end;
//   for i:= 1 to dimF_detalle-1 do
//     begin
//       close(vDF[i]);
//     end;
// end;

// procedure crear_maestro(var vDN: vector_nacimientos; var vDF: vector_fallecimientos;var mae: mMaestro);
// var
//   r: rMaestro;
//   v1: vector_r_nacimiento; v2: vector_r_fallecimiento;
//   min1: acta_nacimiento;  min2: acta_fallecimiento;
// begin
//   Assign(mae, 'D:\Codigo\Fundamentos-De-Organizacion-De-Datos-FOD\Practicas-Resueltas\1-Archivos\tp2_maestro_detalle_merge\archivos_txt\eje5Archivos\binarioMaestro');
//   rewrite(mae);
//   writeln('llego aca 00');
//   leer_primera_vez(vDN,vDF,v1,v2);
//   writeln('llego aca 0 ');
//   readln();
//   minimo1(vDN,v1,min1);
//   writeln('llego aca 1 ');
//   minimo2(vDF,v2, min2);
//   writeln('llego aca 2');
//   while(min1.nro_partida_nacimiento <> valorAlto)do //la unica manera de cortar es q se acaben los q siguen vivos, solo se puede dar el caso como 3 nacimientos y 2 fallecimientos pero no 2 nacimientos, 3 fallecimientos explota pal carajo sino
//     begin
//       if(min1.nro_partida_nacimiento <> min2.nro_partida_nacimiento)then //no se murio... si me da distinto es porq el minimo nacido no se murio
//         r.se_murio:= false  
//       else  //se murio
//         begin
//           r.se_murio:= true;
//           r.matricula_medico_firma_deceso:= min2.matricula_medico_firma_deceso;
//           r.fecha_anho:= min2.fecha_anho;
//           minimo2(vDF,v2, min2); //si me mori, buscate otro, ejemplo.. 1 cod nacimiento, fallecimiento 2... el 1 vive, pero el minimo 2 todavia es valido, no lo encontre en 
//         end;
//       r.nro_partida_nacimiento:= min1.nro_partida_nacimiento;
//       r.dni:= min1.dni;
//       //si no se murio los campos de fallecimiento quedarian cargados con basura, pero ya tengo un identificador para saber si tiene basura o no, la variable booleana del campo maestro  r.se_murio
//       write(mae,r);
//       minimo1(vDN,v1,min1);
//       //minimo2(vDF,v2, min2);
//     end;
//   cerrar_todos(vDN,vDF);
//   close(mae);
// end;

// procedure imprimir_maestro(var mae: mMaestro);
// var
//   r: rMaestro;
// begin
//   reset(mae);
//   while(not eof(mae))do
//     begin
//       read(mae, r);
//       Writeln('casa ', r.se_murio);
//     end;
//   close(mae);
// end;

// var
//   vDN: vector_nacimientos;
//   vDF: vector_fallecimientos;
//   mae: mMaestro;

//   a: acta_nacimiento;
//   i: integer;
// begin
//   //aca todos nacieron, pero no todos murieron
//   Writeln('creando detalles: ');
//   generar_detalles(vDN, vDF);

//  { writeln(); writeln();
//   for i:= 1 to dimF_detalle do
//     begin
//       reset(vDN[i]);
//       while (not eof (vDN[i])) do
//         begin
//           read(vDN[i], a);
//           Writeln('jjeje ',a.nro_partida_nacimiento);
//         end;
//       close(vDN[i]);
//     end;
//   readln();}
//   writeln('creando maestro');
//   crear_maestro(vDN,vDF,mae);
//   writeln('imprimeindo main');
//   imprimir_maestro(mae);
// end.






{Mucho quilombo loco, me paso mas tiempo haciendo los registro q resolviendo el problema}
// program eje5;
// const
//   dimF_detalle = 3;
// type
//   data_direccion = record
//     calle: string;
//     nro: integer;
//     piso: integer;
//     depto: integer;
//     ciudad: string;
//   end;

//   data_adulto = record
//     nombre_y_apellido__del_adulto: string;
//     dni: integer;
//   end;
// //mira aca
//   acta_nacimiento = record
//     nro_partida_nacimiento: integer;
//     nombre: string;
//     apellido: string;
//     direccion: data_direccion;
//     matricula_del_medico: integer;
//     madre: data_adulto;
//     padre: data_adulto;
//   end;
//  //------------------------------------------------
//   data_fecha = record
//     anho: integer;
//     hora: string;
//     lugar: string;
//   end;
// //mira aca
//   acta_fallecimiento = record
//     nro_partida_nacimiento: integer;
//     dni: integer;
//     nombre_y_apellido_del_fallecido: string;
//     matricula_medico_firma_deceso: integer;
//     fecha: data_fecha;
//   end;
// //mira aca
//   rMaestro = record
//     nro_partida_nacimiento: integer;
//     nombre: string;
//     apellido: string;
//     direccion: data_direccion;
//     matricula_medico: integer;
//     madre: data_adulto;
//     padre: data_adulto;
//     fallecio: boolean;
//     matricula_medico_firma_deceso: integer;
//     fecha: data_fecha;
//   end;

//   dNacimiento = file of acta_nacimiento;
//   dFallecimiento = file of acta_fallecimiento;

//   vector_nacimientos = array[1..dimF_detalle]of dNacimiento;
//   vector_fallecimientos = array[1..dimF_detalle] of dFallecimiento;

//   vector_r_nacimiento = array[1..dimF_detalle]of acta_fallecimiento;
//   vector_r_fallecimiento = array[1..dimF_detalle]of acta_nacimiento;

//   {Realizar un programa que cree el archivo maestro a partir de toda la información de los
//   archivos detalles. Se debe almacenar en el maestro: nro partida nacimiento, nombre,
//   apellido, dirección detallada (calle,nro, piso, depto, ciudad), matrícula del médico, nombre y
//   apellido de la madre, DNI madre, nombre y apellido del padre, DNI del padre y si falleció,
//   además matrícula del médico que firma el deceso, fecha y hora del deceso y lugar. Se
//   deberá, además, listar en un archivo de texto la información recolectada de cada persona

//   Nota: Todos los archivos están ordenados por nro partida de nacimiento que es única.
//   Tenga en cuenta que no necesariamente va a fallecer en el distrito donde nació la persona y
//   además puede no haber fallecido.}


// {  acta_nacimiento = record
//     nro_partida_nacimiento: integer;
//     nombre: string;
//     apellido: string;
//     direccion: data_direccion;
//     matricula_del_medico: integer;
//     madre: data_adulto;
//     padre: data_adulto;
//   end;}
// procedure lectura_adulto(var a: data_adulto);
// begin
//   Writeln('Ingrese el nombre y apellido ');
//   a.nombre_y_apellido__del_adulto:= 'pepe fernandez';
//   Writeln('Ingrese el dni');
//   a.dni:= 22;
// end;
// {  data_direccion = record
//     calle: string;
//     nro: integer;
//     piso: integer;
//     depto: integer;
//     ciudad: string;
//   end;}
// procedure leer_direccion(var d: data_direccion);
// begin
//   Writeln('Ingrese la calle ');
//   d.calle:= '1221';
//   Writeln('Nro ');
//   d.nro:= 121;
//   Writeln('piso: ');
//   d.piso:= 2;
//   Writeln('Depto: ');
//   d.depto;
//   Writeln('Ciudad: ');
//   readln(d.ciudad);
// end;

// procedure leer_data(var rN: acta_nacimiento);
// var
//   a: acta_nacimiento
// begin
//   Writeln('Ingrese el numero de partida');
//   readln(a.nro_partida_nacimiento);
//   Writeln('Ingrese el nombre');
//   a.nombre:= 'casa';
//   Writeln('Ingrese el apellido ');
//   a.apellido:= 'casaApellido';
//   Writeln('Ingrese la direccion');
//   leer_direccion(a.direccion);
//   Writeln('ingrese la matricula del medico ');
//   readln(a.matricula_del_medico);
//   lectura_adulto(a.madre);
// end;

// procedure leer_dataF(var rN: acta_fallecimiento);
// begin

// end;

// procedure generar_detalles(var vDN: vector_nacimientos;var vDF: vector_fallecimientos);
// var
//   i: integer;
//   nD: dNacimiento;
//   fD: dFallecimiento;
//   direccion_inmutable, direccion_mutable, casa: string;
//   rN: acta_nacimiento; rF acta_fallecimiento;
// begin
//   //vamos a cargar 3 nacimiento y 2 fallecimientos
//   direccion_inmutable:= 'D:\Codigo\Fundamentos-De-Organizacion-De-Datos-FOD\Practicas-Resueltas\1-Archivos\tp2_maestro_detalle_merge\archivos_txt\eje5Archivos\binario';
//   //nacimiento
//   for i:= 1 to dimF_detalle do
//     begin
//       str(i, casa);
//       direccion_mutable:= direccion_inmutable+casa;
//       Assign(nD, direccion_mutable);
//       rewrite(nD);
//       leer_dataN(rN);
//     end;
//   //fallecimiento
//   for i:= 1 to dimF_detalle-1 do
//     begin
//       str(i, casa);
//       direccion_mutable:= direccion_inmutable+casa;
//       Assign(fD, direccion_mutable);
//       rewrite(fD);
//       leer_dataF(rN);
//     end;
// end;

// var
//   vDN: vector_nacimientos;
//   vDF: vector_fallecimientos;
// begin
//   //aca todos nacieron, pero no todos murieron
//   generar_detalles(vDN, vDF);
// end.