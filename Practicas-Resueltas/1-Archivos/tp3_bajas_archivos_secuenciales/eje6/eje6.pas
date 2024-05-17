{
  Una cadena de tiendas de indumentaria posee un archivo maestro no ordenado con
 la información correspondiente a las prendas que se encuentran a la venta. De cada
 prenda se registra: cod_prenda, descripción, colores, tipo_prenda, stock y
 precio_unitario. Ante un eventual cambio de temporada, se deben actualizar las
 prendas a la venta. Para ello reciben un archivo conteniendo: cod_prenda de las
 prendas que quedarán obsoletas. Deberá implementar un procedimiento que reciba

 ambos archivos y realice la baja lógica de las prendas, para ello deberá modificar el
 stock de la prenda correspondiente a valor negativo.
 Adicionalmente, deberá implementar otro procedimiento que se encargue de
 efectivizar las bajas lógicas que se realizaron sobre el archivo maestro con la
 información de las prendas a la venta. Para ello se deberá utilizar una estructura
 auxiliar (esto es, un archivo nuevo), en el cual se copien únicamente aquellas prendas
 que no están marcadas como borradas. Al finalizar este proceso de compactación
 del archivo, se deberá renombrar el archivo nuevo con el nombre del archivo maestro
 original
 
}

program eje6;
const
  valorAlto = 9999;
  nombreMaestro = 'D:\Codigo\Fundamentos-De-Organizacion-De-Datos-FOD\Practicas-Resueltas\1-Archivos\tp3_bajas_archivos_secuenciales\eje6\archivo\maestro';
type
  prenda = record
    cod_prenda: integer;
    stock: integer;
    precio_unitario: real;
    colores: string;
    descripcion: string;
    tipo_prenda: string;
  end;

  archivo_prenda_actual =file of prenda;

  prenda_baja = file of integer; // solo tiene el cod_prenda que va a ser dado de baja


procedure crear_maestro(var archivo_maestro: archivo_prenda_actual);
var
  pren: prenda;
  texto: Text;
begin
  Assign(texto, 'D:\Codigo\Fundamentos-De-Organizacion-De-Datos-FOD\Practicas-Resueltas\1-Archivos\tp3_bajas_archivos_secuenciales\eje6\archivo\maestro.txt');
  reset(texto);
  assign(archivo_maestro, 'D:\Codigo\Fundamentos-De-Organizacion-De-Datos-FOD\Practicas-Resueltas\1-Archivos\tp3_bajas_archivos_secuenciales\eje6\archivo\maestro');
  rewrite(archivo_maestro);
  while (not eof(texto))do
    begin
      readln(texto, pren.cod_prenda, pren.stock, pren.precio_unitario);
      readln(texto, pren.colores);
      readln(texto, pren.descripcion);
      readln(texto, pren.tipo_prenda);
      write(archivo_maestro, pren);
    end;
  close(texto);
  close(archivo_maestro);
end;

procedure crear_baja_logica(var archivo_baja_logica:prenda_baja);
var
  cod_baja: integer;
  direccion_inmutable: string;
  texto: text;
begin
  direccion_inmutable:= 'D:\Escritorio\FOD\Fundamentos-De-Organizacion-De-Datos-FOD\Practicas-Resueltas\1-Archivos\tp3_bajas_archivos_secuenciales\eje6\archivo\arch_baja.txt';
  assign (texto, direccion_inmutable);
  reset(texto);
  assign(archivo_baja_logica, 'D:\Escritorio\FOD\Fundamentos-De-Organizacion-De-Datos-FOD\Practicas-Resueltas\1-Archivos\tp3_bajas_archivos_secuenciales\eje6\archivo\archBaja');
  Rewrite(archivo_baja_logica);
  while (not eof (texto)) do
    begin
      readln(texto, cod_baja);
      write(archivo_baja_logica, cod_baja);
    end;
  Close(archivo_baja_logica);
  close(texto); 
end;

// procedure leer(var archivo_maestro: archivo_prenda_actual;var arch_baja: prenda);
// begin
//   if(not eof(archivo_maestro))then
//     read(archivo_maestro, arch_baja)
//   else
//     arch_baja.cod_prenda:= valorAlto  
// end;

procedure cambio_de_temporada(var archivo_maestro:archivo_prenda_actual;var archivo_baja_logica: prenda_baja); 
var
  cod_baja: integer;
  arch_baja: prenda;
  encontre: boolean;
begin
  reset(archivo_maestro);
  reset(archivo_baja_logica);
  while not eof(archivo_baja_logica) do //como no esta ordenado, agoto las bajas
    begin      
      read(archivo_baja_logica, cod_baja);
      encontre:= false;
      while not eof(archivo_maestro) and (not encontre)do //recorro por cada baja posible
        begin
          read(archivo_maestro, arch_baja);
          if (arch_baja.cod_prenda = cod_baja) then
            begin
              encontre = true;
              arch_baja.cod_prenda:= arch_baja.cod_prenda * -1;
              seek(archivo_maestro, filePos(archivo_maestro)-1);
              write(archivo_maestro,arch_baja);
            end;
        end;
      seek(archivo_maestro,0);
    end;
  Close(archivo_maestro);
  close(archivo_baja_logica);
end;

procedure compactacion(var m: archivo_prenda_actual);
var
  p: prenda;
  arch_aux: archivo_prenda_actual;
begin
  assign(arch_aux, 'D:\Escritorio\FOD\Fundamentos-De-Organizacion-De-Datos-FOD\Practicas-Resueltas\1-Archivos\tp3_bajas_archivos_secuenciales\eje6\archivo');
  rewrite(arch_aux);
  while not eof(m)do
    begin
      read(m, p);
      if(p.cod_prenda > 0)then
        begin
          write(arch_aux, p);
        end;
    end;
  close(m);
  close(arch_aux);
  erase(m);
  rename(arch_aux,nombreMaestro);
end;


procedure imprimi(var archivo_maestro: archivo_prenda_actual);
var
  p: prenda;
begin
  reset(archivo_maestro);
  writeln('condicion: ',eof(archivo_maestro));
  while (not eof(archivo_maestro))do
    begin
      read(archivo_maestro, p);
      writeln('cod prenda: ',p.cod_prenda, ' stock: ',p.stock, ' precio unitario: ',p.precio_unitario);
      writeln('color: ',p.colores);
      writeln('descripcion: ',p.descripcion);
      WriteLn('tipo de prenda: ',p.tipo_prenda);
    end;
  Close(archivo_maestro);
end;

var
  archivo_maestro: archivo_prenda_actual;
  archivo_baja_logica: prenda_baja;
begin
  crear_maestro(archivo_maestro);
  crear_baja_logica(archivo_baja_logica);
  cambio_de_temporada(archivo_maestro, archivo_baja_logica); 

  // imprimi(archivo_maestro);
  // Assign(archivo_baja_logica, 'D:\Codigo\Fundamentos-De-Organizacion-De-Datos-FOD\Practicas-Resueltas\1-Archivos\tp3_bajas_archivos_secuenciales\eje6\archivo\arch_baja.txt');
  // reset(archivo_baja_logica);
end.