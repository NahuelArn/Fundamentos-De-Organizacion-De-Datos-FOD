program maestroDetalle;
const valoralto = 'ZZZZ';
type 
  str4 = string[4]; 
  producto = record
    cod: str4;
    descripcion: string[30];     
    pu: real;                    
    stock: integer;               
  end;
  venta_prod = record
    cod: str4; 
    cant_vendida: integer;   
  end;
  detalle = file of venta_prod;     
  maestro = file of producto;
  
procedure leer( var archivo: detalle; var dato: venta_prod);  // solo verifica si el archivo pasado, no es el final, si no es devuelve su contenido
begin
  if (not(EOF(archivo))) then 
    read (archivo, dato)
  else 
    dato.cod := valoralto;
end;
var
  mae: maestro; regm: producto;   
  det: detalle; regd: venta_prod;
  total: integer; aux: str4;  
begin
  {programa principal}
  assign(mae, 'maestro');
  assign(det, 'detalle');
  reset(mae);
  reset(det);
  read(mae, regm);  //registro maestro
  leer(det, regd);
  {Se procesan todos los registros del archivo 
  detalle}
  while (regd.cod <> valoralto) do 
    begin
      aux := regd.cod;
      total := 0;
      {Se totaliza la cantidad vendida de 
      productos iguales en el archivo de 
      detalle}
      while (aux = regd.cod) do 
        begin
          total := total + regd.cant_vendida; 
          leer(det, regd);
        end;
      {se busca el producto del detalle en el maestro}  //ya acumulo ahora se busca y se va actualizar 
      while (regm.cod <> aux) do
        begin
          read (mae, regm);
        end;
      {se modifica el stock del producto con 
      la cantidad total vendida de ese producto}
      regm.cant := regm.cant - total;
      {se reubica el puntero en el maestro}
      seek(mae, filepos(mae)-1);
      {se actualiza el maestro}
      write(mae, regm);
      {se avanza en el maestro}
      if (not(EOF(mae))) then 
        read(mae, regm);
    end;
  close(det);
  close(mae);
end.
