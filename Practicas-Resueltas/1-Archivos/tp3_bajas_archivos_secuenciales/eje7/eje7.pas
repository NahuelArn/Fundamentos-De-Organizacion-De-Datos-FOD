{
  Se cuenta con un archivo que almacena información sobre especies de aves en vía
de extinción, para ello se almacena: código, nombre de la especie, familia de ave,
descripción y zona geográfica. El archivo no está ordenado por ningún criterio. Realice
un programa que elimine especies de aves, para ello se recibe por teclado las
especies a eliminar. Deberá realizar todas las declaraciones necesarias, implementar
todos los procedimientos que requiera y una alternativa para borrar los registros. Para
ello deberá implementar dos procedimientos, uno que marque los registros a borrar y
posteriormente otro procedimiento que compacte el archivo, quitando los registros
marcados. Para quitar los registros se deberá copiar el último registro del archivo en la
posición del registro a borrar y luego eliminar del archivo el último registro de forma tal
de evitar registros duplicados.
Nota: Las bajas deben finalizar al recibir el código 500000
}
program eje7;
const 
  fin = 5000;
type
  str20 = string[20];
  aves = record
    codigo: integer;  //LONGITUD FIJAA, ESTO SOLO SE PUEDE HACER CON ARCHIVOS DE LONGITUD FIJA
    nombre_de_especie: str20;
    familia: str20;
    descripcion: str20;
    zona: str20;
  end;
  archivo = file of aves;

procedure marcar_eliminados(var arch: archivo);
var
  especie: string;
  ave: aves;
begin
  reset(arch);
  writeln('Ingrese el nombre de la especie a eliminar');
  readln(especie);
  while especie <> 'fin' do begin
    while not eof(arch) do 
      begin
        read(arch, ave);
        if ave.nombre = especie then
          begin
            ave.nombre_de_especie := 'eliminado';
            seek(arch, filepos(arch)-1);
            write(arch, ave);
          end;
      end;
    writeln('Ingrese el nombre de la especie a eliminar');
    readln(especie);
    Seek(arch, 0);
  end;
  close(arch);
end;

procedure compactar(var arch: archivo);
  procedure encontrar_ultimo_valido(var arch: archivo; pos: integer); //pos es la posicion del registro a eliminar
  var
    ave: aves;
    i: integer;
    posActual: integer;
  begin
    i:= 1;
    seek(arch, filesize(arch)-i);
    Read(arch, ave);
    while (ave.nombre_de_especie = 'eliminado') do //Mientras el registro sea eliminado
      begin
        i:= i+2;
        Seek(arch, pos-i);
        posActual:= filepos(arch);
        Read(arch, ave);
        // i:= i+1;
      end;    
    if(ave.nombre_de_especie <> 'eliminado') and (posActual <> pos)then // encontro un registro valido
      begin
        seek(arch, pos);
        write(arch, ave);
        seek(arch, filesize(arch)-i);
        truncate(arch);
      end;
    if (posActual = pos) then //No encontro un registro valido, entonces trunca en el mismo por que vendria ser el mismo el ultimo valido
      begin
        seek(arch, pos);
        truncate(arch);
      end;
  end;
var
  ave: aves;
  pos: integer;
begin
  reset(arch);
  while not eof(arch) do
    begin
      read(arch, ave);
      if ave.nombre_de_especie = 'eliminado' then
        begin
          pos:= filepos(arch)-1;
          encontrar_ultimo_valido(arch,pos);
          Seek(arch, pos);  //Vuelve a la posicion del registro a eliminar, para volver a leer
        end;
    end;
  close(arch);
end;

var
  arch: archivo;
begin
  cargarArchivo(arch); //Carga el archivo
  marcar_eliminados(arch); //Marca los registros a eliminar
  compactar(arch); //Compacta el archivo
end.