<h1 align="center">Generador de archivos .txt </h1>

```pas

    program eje3;
    uses
      SysUtils; //Permite parsear 
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

    procedure cargarData(i: integer;var data: informacion);
    begin
      data.cod_producto:= i;
      data.cant_vendida:= random(40);
    end;

    procedure generarador_detalles(cant: integer);  //recibe una cantidad y genera N archivos.txt con data para consumir
    {desarrollar logica para q al azar y de forma ordenada genere N de cada uno}
    var
      i,o: integer;
      data: informacion;
      logico: text;
      nombre: string;
    begin
      for i := 1 to cant do //va sin espacios el for 
        begin
          nombre:= 'sutaAbsoluta';
          nombre := nombre + IntToStr(i) + '.txt';  //Parsea char a int, solo con compiladora de free pascal y no turbo pascal
          Assign(logico, nombre);
          rewrite(logico);
          for o:= 1 to random(4)+1 do
            begin
              cargarData(i,data);
              writeln(logico, data.cod_producto, ' ',data.cant_vendida);
            end;
          close(logico);
        end;
    end;

    begin
      randomize;
      generarador_detalles(5);
    end.
  
```
<h1 align="center">Generador de archivos binarios </h1>

```pas

    procedure generarador_detalles(cant: integer);  //recibe una cantidad y genera N archivos.txt con data para consumir
    var
      i,o: integer;
      data: informacion;
      logico: archivo_informacion;
      nombre: string;
    begin
      for i := 1 to cant do //va sin espacios el for 
        begin
          nombre:= 'rutaAbsoluta';
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

```

<h1 align="center">acumulador de Bertone</h1>
<h2 align="center">Tengo 1 Maestro y un SOLO Detalle ordenado con o sin repetidos</h2>

```pas

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

```