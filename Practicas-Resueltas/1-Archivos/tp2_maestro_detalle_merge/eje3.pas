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
  data.cant_vendida:= random(40);
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
  ruta_absoluta:= 'D:\Codigo\Fundamentos-De-Organizacion-De-Datos-FOD\Practicas-Resueltas\1-Archivos\tp2_maestro_detalle_merge\archivos_txt\eje3Archivos\detalle';
  for i:=  1 to cant_archivos_detalles do
    begin
      ruta_absoluta_mutable:= ruta_absoluta+ IntToStr(i);
      // writeln('Empieza');
      // writeln(ruta_absoluta_mutable);
      Assign(actual_detalle, ruta_absoluta_mutable);
      //reset(actual_detalle); //lo necesito abrir? si solo lo quiero guardar en mi vector..
      vDetalles[i]:= actual_detalle;  //entonces guardo las direcciones   // de alguna forma magica estoy guardando los binarios, supongo q tendran un puntero para saber donde estan almcenados
      //close(actual_detalle);
    end;

  for i:= 1 to cant_archivos_detalles do
    begin
      actual_detalle:= vDetalles[i];
      reset(actual_detalle);
      while (not eof(actual_detalle))do
        begin
          read(actual_detalle, prueba);
          writeln('codigo producto: ',prueba.cod_producto);
        end;
      close(actual_detalle);
      writeln();
    end;
end;
var
  //maestro: archivo_logico_producto;
  vDetalles: vector;
begin
  randomize;
  generarador_detalles(cant_archivos_detalles);
  recoleccion_de_detalles(vDetalles); //me retorna un vector con los detalles ya generados en formato binario, (lo q me retorna son sus direcciones absolutas, por cual no estan abiertos los archivos)
end.








































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
