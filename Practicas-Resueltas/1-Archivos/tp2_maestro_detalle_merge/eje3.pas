{
Se cuenta con un archivo de productos de una cadena de venta de alimentos congelados.
De cada producto se almacena: código del producto, nombre, descripción, stock disponible,
stock mínimo y precio del producto.
Se recibe diariamente un archivo detalle de cada una de las 30 sucursales de la cadena. Se
debe realizar el procedimiento que recibe los 30 detalles y actualiza el stock del archivo
maestro. La información que se recibe en los detalles es: código de producto y cantidad
vendida. 
Además, se deberá informar en un archivo de texto: nombre de producto,
descripción, stock disponible y precio de aquellos productos que tengan stock disponible por
debajo del stock mínimo.
Nota: todos los archivos se encuentran ordenados por código de productos. En cada detalle
puede venir 0 o N registros de un determinado producto.
}


program eje3;
uses
  SysUtils; //Permite parsear
const 
  cant_archivos_detalles = 5; 
  cant_archivos_en_el_maestro = 5;
  fin = 9999;
type
  producto = record 
    cod_producto: integer;
    nombre: string;
    descripcion: string;
    stock_disponible: integer;
    stock_minimo: integer;
    precio_unitario: real;
  end;

  informacion = record
    cod_producto: integer;
    cant_vendida: integer;
  end;

  archivo_logico_producto = file of producto;
  archivo_informacion = file of informacion;

  vector = array[1..cant_archivos_detalles]of archivo_informacion;

procedure cargarData(i: integer;var data: informacion);
begin
  data.cod_producto:= i;
  data.cant_vendida:= random(10);
end;

procedure generarador_detalles(cant: integer);  //recibe una cantidad y genera N archivos.txt con data para consumir
var
  i,o: integer;
  data: informacion;
  logico: archivo_informacion;
  nombre: string;
begin
  for i := 1 to cant do //va sin espacios el for 
    begin
      nombre:= 'D:\Codigo\Fundamentos-De-Organizacion-De-Datos-FOD\Practicas-Resueltas\1-Archivos\tp2_maestro_detalle_merge\archivos_txt\eje3Archivos\detalle';
      nombre := nombre + IntToStr(i);  //Parsea char a int, solo con compiladora de free pascal y no turbo pascal
      Assign(logico, nombre);
      rewrite(logico);
      for o:= 1 to random(4)+1 do
        begin
          cargarData(i,data);
          write(logico, data);
        end;
      close(logico);
    end;
end;

procedure recoleccion_de_detalles(var vDetalles: vector); 
var
  i: integer;
  ruta_absoluta_constante,ruta_absoluta_mutable: string;
  actual_detalle: archivo_informacion;
  prueba: informacion;
begin
  ruta_absoluta_constante:= 'D:\Codigo\Fundamentos-De-Organizacion-De-Datos-FOD\Practicas-Resueltas\1-Archivos\tp2_maestro_detalle_merge\archivos_txt\eje3Archivos\detalle';
  for i:=  1 to cant_archivos_detalles do
    begin
      ruta_absoluta_mutable:= ruta_absoluta_constante+ IntToStr(i);
      Assign(actual_detalle, ruta_absoluta_mutable);
      vDetalles[i]:= actual_detalle;  //entonces guardo las direcciones   // de alguna forma magica estoy guardando los binarios, supongo q tendran un puntero para saber donde estan almcenados
    end;

  for i:= 1 to cant_archivos_detalles do
    begin
      actual_detalle:= vDetalles[i];
      reset(actual_detalle);
      while (not eof(actual_detalle))do
        begin
          read(actual_detalle, prueba);
          // writeln('codigo producto: ',prueba.cod_producto);
        end;
      close(actual_detalle);
      writeln();
    end;
end;

procedure crear_cargar_maestro(var maestro: archivo_logico_producto);

  procedure leer_data_maestro(var prod: producto; i: integer);  //modulo contenido
  begin
    Writeln('Ingrese el codigo: '); //1 2 3 4 5
    prod.cod_producto:= i;
    Writeln('Ingrese la descripcion: ');
    prod.nombre:= 'aaaa';
    Writeln('Ingrese la descripcion: ');
    prod.descripcion:= 'bbbb';
    Writeln('Ingrese el stock disponible: ');
    prod.stock_disponible:= 100;
    writeln('Ingrese el stock minimo: ');
    prod.stock_minimo:= 0;
    writeln('Ingrese el precio unitario: ');
    prod.precio_unitario:= 100;
  end;

var
  prod: producto;
  i: integer;
begin
  Assign(maestro, 'D:\Codigo\Fundamentos-De-Organizacion-De-Datos-FOD\Practicas-Resueltas\1-Archivos\tp2_maestro_detalle_merge\archivos_txt\eje3Archivos\maestro');
  rewrite(maestro);
  for i:= 1 to cant_archivos_en_el_maestro do
    begin
      leer_data_maestro(prod,i);
      write(maestro, prod);
    end;
  close(maestro);
end;

procedure actualizar_maestro(var maestro: archivo_logico_producto;var vDetalles: vector); //modulo encapsulador
type
  vector_delles = array[1..cant_archivos_detalles]of informacion;
var //variables globales al modulo
  min: informacion; //regD1,regD2,regD3,regD4,
  regM: producto;

  procedure leer(var regD: archivo_informacion;  var dato: informacion);
  begin
    if(not eof(regD))then
      read (regD, dato)
    else
      dato.cod_producto:= fin;
  end;

  procedure minimo(var vD: vector_delles;var min: informacion; var vDetalles: vector);
  var
    i, pos: integer;
  begin
    min.cod_producto:= fin;
    for i:= 1 to cant_archivos_detalles do
      begin
        if((vD[i].cod_producto) < (min.cod_producto))then  //saco el min de todos los detalles en ese[i]
          begin
            min:= vD[i];
            pos:= i;
          end;
      end;
    if(min.cod_producto <> fin)then
      begin
        min:= vD[pos];
        leer(vDetalles[pos], vD[pos]);
      end;
  end;
//sub programa principal
var
  i, cod_actual,acumulador_cant_vendida: integer;
  vD: vector_delles;
begin
  for i := 1 to cant_archivos_detalles do //leo x5 detalle
    begin
      Reset(vDetalles[i]);
      leer(vDetalles[i], vD[i]);
    end;
  reset(maestro);
  read(maestro, regM);        //leo 1 de maestro
  minimo(vD,min,vDetalles);  //le mando el vector de registro 
  while(min.cod_producto <> fin)do
    begin
      cod_actual:= min.cod_producto;
      acumulador_cant_vendida:= 0;
      while(cod_actual = min.cod_producto)do  //acumulo todos los detalles del mismo cod
        begin
          acumulador_cant_vendida:= acumulador_cant_vendida + min.cant_vendida;
          minimo(vD,min,vDetalles);
        end;
      while (regM.cod_producto <> cod_actual) do //busco en el maestro
        read(maestro, regM);
      regM.stock_disponible:= regM.stock_disponible- acumulador_cant_vendida;
      Seek(maestro, filepos(maestro)-1);
      write(maestro,regM);
      if(not eof (maestro))then
        read(maestro,regM);
    end;
  for i := 1 to cant_archivos_detalles do
    begin
      Close(vDetalles[i]);
    end;
    close(maestro);
end;

procedure imprimirMaestro(var m: archivo_logico_producto);
var
  p: producto;
begin
  reset(m);
  while (not eof(m)) do
    begin
      read(m, p);
      Writeln('Codigo: ',p.cod_producto);
      Writeln('nombre: ',p.nombre);
      Writeln('stock: ',p.stock_disponible); //tendria q aparecer el stock restado
      writeln();
    end;  
  close(m);
end;

var
  maestro: archivo_logico_producto;
  vDetalles: vector;
begin
  randomize;
  generarador_detalles(cant_archivos_detalles);
  recoleccion_de_detalles(vDetalles); //me retorna un vector con los detalles ya generados en formato binario, (lo q me retorna son sus direcciones absolutas, por cual no estan abiertos los archivos)
  crear_cargar_maestro(maestro);
  Writeln();
  writeln('se pica');
  writeln();
  actualizar_maestro(maestro,vDetalles);
  writeln('saLI');
  imprimirMaestro(maestro);
end.


// program eje3;
// uses
//   SysUtils; //Permite parsear
// const 
//   cant_archivos_detalles = 5; 
// type
//   producto = record 
//     cod_producto: integer;
//     nombre: string;
//     descripcion: string;
//     stock_disponible: integer;
//     stock_minimo: integer;
//     precio_unitario: real;
//   end;

//   informacion = record
//     cod_producto: integer;
//     cant_vendida: integer;
//   end;

//   archivo_logico_producto = file of producto;
//   archivo_informacion = file of informacion;

//   vector = array[1..cant_archivos_detalles]of archivo_informacion;

// procedure cargarData(i: integer;var data: informacion);
// begin
//   data.cod_producto:= i;
//   data.cant_vendida:= random(40);
// end;

// procedure generarador_detalles(cant: integer);  //recibe una cantidad y genera N archivos.txt con data para consumir
// var
//   i,o: integer;
//   data: informacion;
//   logico: archivo_informacion;
//   nombre: string;
// begin
//   for i := 1 to cant do //va sin espacios el for 
//     begin
//       nombre:= 'D:\Codigo\Fundamentos-De-Organizacion-De-Datos-FOD\Practicas-Resueltas\1-Archivos\tp2_maestro_detalle_merge\archivos_txt\eje3Archivos\detalle';
//       nombre := nombre + IntToStr(i);  //Parsea char a int, solo con compiladora de free pascal y no turbo pascal
//       Assign(logico, nombre);
//       rewrite(logico);
//       for o:= 1 to random(4)+1 do
//         begin
//           cargarData(i,data);
//           write(logico, data);
//         end;
//       close(logico);
//     end;
// end;

// procedure recoleccion_de_detalles(var vDetalles: vector); 
// var
//   i: integer;
//   ruta_absoluta_constante,ruta_absoluta_mutable: string;
//   actual_detalle: archivo_informacion;
//   prueba: informacion;
// begin
//   ruta_absoluta:= 'D:\Codigo\Fundamentos-De-Organizacion-De-Datos-FOD\Practicas-Resueltas\1-Archivos\tp2_maestro_detalle_merge\archivos_txt\eje3Archivos\detalle';
//   for i:=  1 to cant_archivos_detalles do
//     begin
//       ruta_absoluta_mutable:= ruta_absoluta+ IntToStr(i);
//       // writeln('Empieza');
//       // writeln(ruta_absoluta_mutable);
//       Assign(actual_detalle, ruta_absoluta_mutable);
//       //reset(actual_detalle); //lo necesito abrir? si solo lo quiero guardar en mi vector..
//       vDetalles[i]:= actual_detalle;  //entonces guardo las direcciones   // de alguna forma magica estoy guardando los binarios, supongo q tendran un puntero para saber donde estan almcenados
//       //close(actual_detalle);
//     end;

//   for i:= 1 to cant_archivos_detalles do
//     begin
//       actual_detalle:= vDetalles[i];
//       reset(actual_detalle);
//       while (not eof(actual_detalle))do
//         begin
//           read(actual_detalle, prueba);
//           writeln('codigo producto: ',prueba.cod_producto);
//         end;
//       close(actual_detalle);
//       writeln();
//     end;
// end;
// var
//   //maestro: archivo_logico_producto;
//   vDetalles: vector;
// begin
//   randomize;
//   generarador_detalles(cant_archivos_detalles);
//   recoleccion_de_detalles(vDetalles); //me retorna un vector con los detalles ya generados en formato binario, (lo q me retorna son sus direcciones absolutas, por cual no estan abiertos los archivos)
// end.








































// program eje3;
// const 
//   cant_archivos_detalles = 5;
// uses
//   SysUtils; //Permite parsear 
// type
//   producto = record 
//     cod_producto: integer;
//     nombre: string;
//     descripcion: string;
//     stock_disponible: integer;
//     stock_minimo: integer;
//     precio_unitario: real;
//   end;

//   informacion = record
//     cod_producto: integer;
//     cant_vendida: integer;
//   end;

//   archivo_logico_producto = file of producto;
//   archivo_informacion_informacion = file of informacion;

//   vector = array[1..cant_archivos_detalles]of cant_archivos_detalles;

// procedure cargarData(i: integer;var data: informacion);
// begin
//   data.cod_producto:= i;
//   data.cant_vendida:= random(40);
// end;

// procedure generarador_detalles(cant: integer);  //recibe una cantidad y genera N archivos.txt con data para consumir
// {desarrollar logica para q al azar y de forma ordenada genere N de cada uno}
// var
//   i,o: integer;
//   data: informacion;
//   logico: text;
//   nombre: string;
// begin
//   for i := 1 to cant do //va sin espacios el for 
//     begin
//       nombre:= 'D:\Codigo\Fundamentos-De-Organizacion-De-Datos-FOD\Practicas-Resueltas\1-Archivos\tp2_maestro_detalle_merge\archivos_txt\eje3Archivos\detalle';
//       nombre := nombre + IntToStr(i) + '.txt';  //Parsea char a int, solo con compiladora de free pascal y no turbo pascal
//       Assign(logico, nombre);
//       rewrite(logico);
//       for o:= 1 to random(4)+1 do
//         begin
//           cargarData(i,data);
//           writeln(logico, data.cod_producto, ' ',data.cant_vendida);
//         end;
//       close(logico);
//     end;
// end;

// {//recolecto el detalle en si? o la direccion
// de igual manera tengo que parsearlo a binario
// for: parseo[i] = guardo

// //me rendia mas directamente generar los binarios y no en formato txt
// }
// procedure recoleccion_de_detalles(var vDetalles: vector); 
// var
//   i: integer;
// begin
  
// end;

//   maestro: archivo_logico_producto;
//   vDetalles: vector;
// begin
//   randomize;
//   generarador_detalles(cant_archivos_detalles);
//   recoleccion_de_detalles(vDetalles);
// end.
