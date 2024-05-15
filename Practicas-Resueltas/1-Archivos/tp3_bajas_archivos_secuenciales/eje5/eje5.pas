{
   Dada lasiguiente estructura:
    type
    reg_flor = record
      nombre: String[45];
      codigo:integer;
    end;
    tArchFlores = file of reg_flor;

    Las bajas se realizan apilando registros borrados y las altas reutilizando registros
    borrados. El registro 0 se usa como cabecera de la pila de registros borrados: el
    número 0 en el campo código implica que no hay registros borrados y-N indica que el
    próximo registro a reutilizar es el N, siendo éste un número relativo de registro válido.
    a. Implemente el siguiente módulo:
      // Abre el archivo y agrega una flor, recibida como parámetro
      // manteniendo la política descrita anteriormente
    procedure agregarFlor (var a: tArchFlores ; nombre: string; codigo:integer);
   
    b. Liste el contenido del archivo omitiendo las flores eliminadas. Modifique lo que
    considere necesario para obtener el listado.

}

program eje5;

type
  reg_flor = record
    nombre: String[45];
    codigo:integer;
  end;
  
  tArchFlores = file of reg_flor;
procedure leer_flor(var flor: reg_flor);
begin
  Writeln('Ingrese el nombre de la flor: ');
  Readln(flor.nombre);
  Writeln('Ingrese el codigo de la flor: ');
  Readln(flor.codigo);  
end;

procedure opcion_a(var flor: tArchFlores; flor_reg: reg_flor);
var
  puntero_cabecera: integer;
  cabecera: reg_flor;
  reg_apuntado: reg_flor;
begin
  reset(flor);
  //dimension fisica de un archivo
  read(flor,cabecera);
  if(cabecera.codigo = 0)then
    begin
      Seek(flor,FileSize(flor));
      write(flor,flor_reg);
    end
  else
    begin
      puntero_cabecera:= cabecera.codigo *-1; //saco la posicion del registro a reutilizar
      seek(flor,puntero_cabecera);
      read(flor,reg_apuntado);  //leo el registro apuntado
      Seek(flor,puntero_cabecera);
      write(flor,flor_reg); //escribo el nuevo registro
      seek(flor,0);
      write(flor,reg_apuntado); //actualizo la cabecera
    end;
  Close(flor);
end;

procedure opcion_b(var flor: tArchFlores);
var
  flor_reg: reg_flor;
begin
  reset(flor);
  Seek(flor,1);
  while not eof(flor) do begin
    read(flor,flor_reg);
    if(flor_reg.codigo > 0)then
      begin
        Writeln('Nombre: ',flor_reg.nombre);
        Writeln('Codigo: ',flor_reg.codigo);
      end;
  end;
  Close(flor);
end;

procedure opcion_c(var flor: tArchFlores; del: reg_flor);
var
  r: reg_flor;
  c: reg_flor;
  encontrado: boolean;
  pos_ultimo_eliminado: integer;
begin
  Reset(flor);  
  read(flor,c);
  encontrado:= false;
  while not eof(flor) and (not encontrado)do
  begin
    read(flor,r);
    if(r.codigo = del.codigo)then
      begin
        encontrado:= true;
        r.codigo:= c.codigo;  //actualizo el codigo del registro con el que tenia la cabecera
        seek(flor,FilePos(flor)-1); //me vuelvo a posicionar donde estaba
        pos_ultimo_eliminado:= FilePos(flor) * -1;// me guardo la posicion del registro eliminado negativo
        write(flor,r);
        Seek(flor,0);
        c.codigo:= pos_ultimo_eliminado;
        write(flor,c);
      end;
  end;
  Close(flor);
end;

var
  opcion: char;
  flor: tArchFlores;
  flor_reg: reg_flor;
  direccion_inmutable, direccion_mutable: string;
begin
  Writeln('Ingrese la opcion que desea realizar: ');
  Writeln('a. Agregar una flor');
  Writeln('b. Listar flores');
  Writeln('c. Salir');
  direccion_inmutable:= 'D:\Codigo\Fundamentos-De-Organizacion-De-Datos-FOD\Practicas-Resueltas\1-Archivos\tp3_bajas_archivos_secuenciales\eje5\archivo\';
  direccion_mutable:= 'flores';
  assign(flor,direccion_inmutable + direccion_mutable);
  Rewrite(flor);
  Close(flor);
  Readln(opcion);
  while opcion <> 'd' do begin
    case opcion of
      'a':
        begin
          leer_flor(flor_reg);
          opcion_a(flor,flor_reg);
        end; 
      'b': opcion_b(flor);
      'c': 
        begin
          Writeln('Ingrese el codigo de la flor a eliminar: ');
          Readln(flor_reg.codigo);
          opcion_c(flor,flor_reg);
        end;
    end;
    Writeln('Ingrese la opcion que desea realizar: ');
    Writeln('a. Agregar una flor');
    Writeln('b. Listar flores');
    writeln('c. eliminar una flor');
    Writeln('d. Salir');
    Readln(opcion);
  end;
end.