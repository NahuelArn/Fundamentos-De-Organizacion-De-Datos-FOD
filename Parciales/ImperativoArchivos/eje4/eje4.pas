program eje4;
const
  valorAlto = 9999;
type
  log = record
    numUsuario: integer;
    nombreUsuario: string;
    nombre: string;
    apellido: string;
    cantMailsEnviados: integer;
  end;

  infoEnviada = record
    numeroUsuario: integer;
    cuentaDestino: integer;
    cuerpoMensaje: string;
  end;

  maestro = file of log;
  detalle = file of infoEnviada;

procedure leer(var archD: detalle;var rD: infoEnviada);
begin
  if(not eof(archD))then
    read(archD,rD)
  else
    rD.numeroUsuario:= valorAlto;
end;

procedure actualizarMaestro(var archM:maestro;var archD: detalle);
var
  rM:log;
  rD: infoEnviada;
  numeroDeUsuarioActual,cantMensajesEnviados: integer;
begin
  reset(archM);
  reset(archD);
  leer(archD,rD);
  read(archM,rM);
  while(rD.numeroUsuario <> valorAlto)do
    begin
      numeroDeUsuarioActual:= rD.numeroUsuario;
      cantMensajesEnviados:= 0;
      while(numeroDeUsuarioActual = rD.numeroUsuario)do
        begin
          cantMensajesEnviados:= cantMensajesEnviados+1;
          leer(archD,rD);
        end;
      while(rM.numUsuario <> numeroDeUsuarioActual)do
        begin
          read(archM, rM);
        end;
      rM.cantMailsEnviados:= rM.cantMailsEnviados+cantMensajesEnviados;
      seek(archM, filePos(archM)-1);
      write(archM,rM);
      if(not eof(archM))then
        read(archM,rM);
    end;
  Close(archM);
  close(archD);
end;

procedure generarTxt(var archM: maestro;var txt: text);
var
  l: log;
begin
  assign(txt, 'archivoTexto.txt');
  rewrite(txt);
  reset(archM);
  while not eof(archM)do
    begin
      read(archM, l);
      writeln(txt, 'Numero de usuario: ',l.numUsuario, 'Nombre de Usuario: ', l.nombreUsuario, 'Cantidad de mensajes: ',l.cantMailsEnviados);
    end;
  close(archM);
  close(txt);
end;

var
  archM: maestro;
  archD: detalle;
  opcion: Char;
  txt: text;
begin
  assign(archM, '/var/log/logsmail.dat');
  assign(archD, 'logmail.dat');
  writeln('Ingrese una cosa ha hacer');
  readln(opcion);
  Case opcion of
    'a': actualizarMaestro(archM,archD);
    'b': generarTxt(archM,txt);
  end;
end.