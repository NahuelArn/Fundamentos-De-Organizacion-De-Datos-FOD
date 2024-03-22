program eje1;
type
  empleado = record
    cod_empleado: integer;
    nombre: string;
    monto_comision: real;
  end;

  archivo_fisico= file of empleado; // 
procedure traerme_el_archivo(var archivo_provisto: text);
var
  empl: empleado;
begin
  Writeln('ESTOY TRAYENDO BIEN???');
  Assign(archivo_provisto, 'D:\Codigo\Fundamentos-De-Organizacion-De-Datos-FOD\Practicas-Resueltas\1-Archivos\tp2_maestro_detalle_merge\archivos_txt\archivo_provisto.txt');
  //no lo dejo abierto, cuando lo necesite lo abro
  reset(archivo_provisto);
  while (not eof (archivo_provisto)) do
    begin
      readln(archivo_provisto, empl.cod_empleado, empl.nombre,empl.monto_comision);
      Writeln('Cod de empleado: ',empl.cod_empleado,' comision: ',empl.monto_comision, ' nombre empleado: ',empl.nombre, ' | ');
    end;
    Close(archivo_provisto);
    Writeln('ESTOY TRAYENDO BIEN???');
end;

procedure inicializar_nuevo_archivo(var archivo_compactado: archivo_fisico);
begin //ASSIGN (ARCHIVOLOGICO, ARCHIVOFISICO) =>  n_lógico, N_físico)
  Assign(archivo_compactado, 'D:\Codigo\Fundamentos-De-Organizacion-De-Datos-FOD\Practicas-Resueltas\1-Archivos\tp2_maestro_detalle_merge\archivos_txt\archivo_compacto_logico');  //va a la ruta, como no encuentra el archivo con en ese nombre lo crea en ese lugar
  rewrite(archivo_compactado);
end;

procedure inicializar_acumulador(var acumulador:empleado; cod_actual: integer; nombre: string);
begin
  acumulador.cod_empleado:= cod_actual;
  acumulador.nombre:= nombre;
  acumulador.monto_comision:= 0;
end;

procedure cargar_nuevo_archivo(var archivo_compactado: archivo_fisico; acumulador: empleado);
begin
  write(archivo_compactado,acumulador); //writeln no iba? only write?
end;
//implementa el corte de control, con variables acumuladoras, para actualizar el nuevo archivo
procedure compactar_archivo(var archivo_provisto: text;var  archivo_compactado:archivo_fisico);
var
  empl: empleado;
  cod_actual: integer;
  acumulador: empleado; //mejor tenerlo como registro
begin
  reset(archivo_provisto);  //arch consumbo abierto
  readln(archivo_provisto, empl.cod_empleado, empl.nombre,empl.monto_comision);
  while((not eof(archivo_provisto)))do
    begin
      // readln(archivo_provisto, empl.cod_empleado, empl.nombre,empl.monto_comision);
      cod_actual:= empl.cod_empleado;
      // acumulador:= 0;
      inicializar_acumulador(acumulador,cod_actual,empl.nombre); 
      while((not eof(archivo_provisto) and (cod_actual = empl.cod_empleado)))do
        begin
          acumulador.monto_comision:= empl.monto_comision+ acumulador.monto_comision;
          readln(archivo_provisto, empl.cod_empleado, empl.nombre,empl.monto_comision);
          WriteLn('LLego aca0?');
        end;
        //sali, 2 motivos, finalizo el recorrido o cambio de codigo
        WriteLn('LLego aca1?');
        cargar_nuevo_archivo(archivo_compactado,acumulador);
        WriteLn('LLego aca2?');
    end;
  close(archivo_provisto);
  close(archivo_compactado);
  WriteLn('LLego aca2?');
end;

{test}
procedure imprimir(var archivo_compactado: archivo_fisico);
var
  empl: empleado;
begin
  reset(archivo_compactado);
  Writeln();
  Writeln('Imprimiendo el nuevo archivo compactado');
  while(not eof(archivo_compactado))do
    begin
      // read(archivo_compactado, empl.cod_empleado, empl.nombre, empl.monto_comision); //solo los archivos ya cargados te lo traes campo x campo
      read(archivo_compactado, empl);
      Write('Cod de empleado: ',empl.cod_empleado, ' nombre: empleado: ',empl.nombre,' comision: ',empl.monto_comision, ' | ');
    end;
  close(archivo_compactado);
end;

var
  archivo_provisto: text;
  archivo_compactado: archivo_fisico;
begin
  traerme_el_archivo(archivo_provisto);
  // inicializar_nuevo_archivo(archivo_compactado);
  // {Q tengo en este punto? cree y abri el archivo compactado, el archivo de consumo lo tengo cerrado}
  // compactar_archivo(archivo_provisto, archivo_compactado);
  // //en este punto ya genere el nuevo archivo y lo tendria que tener cargado (dentro del modulo cerre los 2 archivos)
  
  // {So good?}
  // imprimir(archivo_compactado); 
end.