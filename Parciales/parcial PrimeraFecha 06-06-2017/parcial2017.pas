program parcial2017;
const
  valorAlto = 9999;
type
  log = record
    numUsuario: integer;
    nombreDeUsuario: string;
    nombre: string;
    apellido: string;
    cantidadDeMailsEnviados: integer;
  end;

  info = record 
    numeroDeUsuario: integer;
    cuentaDestino: integer;
    cuerpoMensaje: integer;
  end;

  maestro = file of log;
  detalle = file of info;

procedure leer(var d: detalle; var i: info);
begin
  if(not eof (d))then
    read(d, i)
  else
    i.numeroDeUsuario := valorAlto;
end;

procedure actualizarInformacion(var m:maestro; var d: detalle);
var
  i: info;
  l: log;
  numUsuarioActual: integer; //num 
  cantMensajes: integer;
begin
  reset(m);
  reset(d);
  leer(d, i); //leo detalle
  read(m, l); //leo maestro
  while d.numeroDeUsuario <> valorAlto do
    begin
      numUsuarioActual:= d.numeroDeUsuario;
      cantMensajes:= 0;
      while numUsuarioActual = d.numeroDeUsuario do
        begin
          cantMensajes:= cantMensajes+1;
          leer(d, i);
        end;  
      while(numUsuarioActual <> l.numUsuario)do
        begin
          read(m,l);
        end;
      l.cantidadDeMailsEnviados:= l.cantidadDeMailsEnviados + cantMensajes;
      seek(m, filePos(m)-1);
      write(m,l);
      if(not eof(m))then
        read(m,l);
    end;
  close(m);
  close(d);
end;

//se podria hacer de una, sin el detalle pero como te da ha entender que uses el detalle
//se tendria que usar M y D 
// em detalle solo tengo el nro de usuario y en M tengo todo, vuelvo a meter corte de control
//saco la cantidad y busco el nombre de usuario en el maestro
procedure geneneraTexto(var m: maestro;var d: detalle);
var 
  texto: txt;
  i: info;
  l: log;
  cantidadDeMensaje,usuarioActual: integer;
begin
  assig(texto, 'listado.txt');
  rewrite(texto);
  reset(m);
  reset(d);
  leer(d, i);
  read(m,l);
  while(i.numeroDeUsuario <> valorAlto)do
    begin
      cantidadDeMensaje:= 0;
      usuarioActual:= i.numeroDeUsuario;
      while usuarioActual = i.numeroDeUsuario do
        begin
          cantidadDeMensaje:= cantidadDeMensaje+1;
          leer(d,i);
        end;
      while(usuarioActual <> l.numUsuario)do  //saco el nombreDelUser
        begin
          read(m,l);
        end;
      writeln(texto, usuarioActual, m.nombreDeUsuario);
      writeln(texto, cantidadDeMensaje);
    end;
  Close(m);
  close(d);
  close(texto);
end;

var
  m: maestro;
  d: detalle;
begin
  assign(m, '/var/log/logsmail.dat');
  assign(d, '6junio2017.dat');
  actualizarInformacion(m, d); //maestro detalle,
  geneneraTexto(m,d);
end.