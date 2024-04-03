{ 10. Se tiene información en un archivo de las horas extras realizadas por los empleados de
 una empresa en un mes. Para cada empleado se tiene la siguiente información:
 departamento, división, número de empleado, categoría y cantidad de horas extras
 realizadas por el empleado. Se sabe que el archivo se encuentra ordenado por
 departamento, luego por división, y por último, por número de empleados. Presentar en
 pantalla un listado con el siguiente formato:
 Departamento
 División
 Número de Empleado Total de Hs. Importe a cobrar
 ......
 ......
 ..........
 ..........
 Total de horas división: ____
 Monto total por división: ____
 División
 .................
 .........
 .........
 Total horas departamento: ___
 
 Monto total departamento: ____
 Para obtener el valor de la hora se debe cargar un arreglo desde un archivo de texto al
 iniciar el programa con el valor de la hora extra para cada categoría. La categoría varía
 de 1 a15. En el archivo de texto debe haber una línea para cada categoría con el número
 de categoría y el valor de la hora, pero el arreglo debe ser de valores de horas, con la
 posición del valor coincidente con el número de categoría.
 
 
 
 }

program eje10;
const
  dimFV = 5;
  valorAlto = 999;
type
  empleado = record   //ordenado por departamento --> division --> numEmpleado
    departamento: integer;
    division: integer;
    numEmpleados: integer;
    cataegoria: Integer;
    cantHorasExtra: real;
  end;

  vectorCosto = array[1..dimFV]of real;

procedure cargarVector(var v: vectorCosto);
var
  texto: text;
  meInteresa,basura: real;
  i: integer;
begin
  Assign(texto, 'D:\Codigo\Fundamentos-De-Organizacion-De-Datos-FOD\Practicas-Resueltas\1-Archivos\tp2_maestro_detalle_merge\archivos_txt\eje10Archivos\costos.txt');
  reset(texto);
  for i:= 1 to dimFV do
    begin
      if(not eof(texto))then
        begin
          read(texto, basura,meInteresa);
          v[i]:= meInteresa;
        end;
    end;
  close(texto);
  // for i:= 1 to dimFV do
  //   begin
  //     Writeln(' vector: ',v[i]:2:2);
  //   end;
end;

procedure mostrarMaestro(var v: vectorCosto); //si quiero mostrar data, sin mucha algoritmia hago las operaciones sobre un txt
  procedure leer(var mae: text;var e:empleado);
  begin
    if(not eof(mae))then
      read(mae, e.departamento, e.division, e.numEmpleados, e.cataegoria, e.cantHorasExtra)
    else
      e.departamento:= valorAlto;
  end;

var
  mae: text;
  e: empleado;
  departamentoActual,  divisinActual, numEmpleados: integer;
  //ordenado por departamento --> division --> numEmpleado
  totalMontodivision,totalHorasDivision,totalHorasDepartamento: real;
begin
  Assign(mae, 'D:\Codigo\Fundamentos-De-Organizacion-De-Datos-FOD\Practicas-Resueltas\1-Archivos\tp2_maestro_detalle_merge\archivos_txt\eje10Archivos\maestro.txt');
  reset(mae);
  leer(mae, e);
  totalHorasDepartamento:= 0;
  while(e.departamento <> valorAlto)do
    begin
      departamentoActual:= e.departamento;
      while ((e.departamento <> valorAlto) and ( departamentoActual = e.departamento)) do
        begin
          divisinActual:= e.division;
          totalMontodivision:= 0;
          totalHorasDivision:= 0;
          while ((e.departamento <> valorAlto) and ( departamentoActual = e.departamento) and  (divisinActual = e.division)) do
            begin
              numEmpleados:= e.numEmpleados;
              while ((e.departamento <> valorAlto) and ( departamentoActual = e.departamento) and  (divisinActual = e.division) and (numEmpleados = e.numEmpleados)) do
                begin
                  totalMontodivision:= totalMontodivision + ( v[e.cataegoria]* e.cantHorasExtra);
                  totalHorasDivision:= totalHorasDivision+ e.cantHorasExtra;
                  leer(mae, e);
                end;
            end;
            Writeln('Total monto de la diivision: ',totalMontodivision);
            Writeln('Total horas division: ',totalHorasDivision);
            totalHorasDepartamento:= totalHorasDepartamento+ totalHorasDivision;
        end;
        Writeln('Total horas departamento: ',totalHorasDepartamento:2:2);
    end;
    close(mae);
end;  

var
  v: vectorCosto;
begin
  cargarVector(v);
  mostrarMaestro(v);
end.