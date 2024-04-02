{ 13. Suponga que usted es administrador de un servidor de correo electrónico. En los logs
 del mismo (información guardada acerca de los movimientos que ocurren en el server) que
 se encuentra en la siguiente ruta: /var/log/logmail.dat se guarda la siguiente información:
 nro_usuario, nombreUsuario, nombre, apellido, cantidadMailEnviados. Diariamente el
 servidor de correo genera un archivo con la siguiente información: nro_usuario,
 cuentaDestino, cuerpoMensaje. Este archivo representa todos los correos enviados por los
 usuarios en un día determinado. Ambos archivos están ordenados por nro_usuario y se
 sabe que un usuario puede enviar cero, uno o más mails por día.
    a- Realice el procedimiento necesario para actualizar la información del log en
    un día particular. Defina las estructuras de datos que utilice su procedimiento.
    b- Genere un archivo de texto que contenga el siguiente informe dado un archivo
    detalle de un día determinado:
    nro_usuarioX…………..cantidadMensajesEnviados
    ………….
    nro_usuarioX+n………..cantidadMensajesEnviados
    Nota: tener en cuenta que en el listado deberán aparecer todos los usuarios que
    existen en el sistema
}
program eje13;
const
  dimFUserInfo = 3;
  dimFServer = 3;
  valorAlto = 3;
type  
  server = record
    nro_usuario: integer;
    nombre_usuario: string;
    apellido: string;
    cantidadMailEnviados: integer;
  end;

  info_usuario = record 
    nro_usuario: integer;
    cuenta_destinatario: integer;
    cuerpo_del_mensaje: string;
  end;

  arch_server = file of server;
  arch_usuario = file of info_usuario;

//mismo dia
procedure cargarArchivoUsuarios(var archUser: arch_usuario);  //este detalle va tener varios usurios pero todos son del mismo dia

  procedure leerData(var u: info_usuario);
  begin
    Writeln('Nro usuario ');
    readln(u.nro_usuario);
    Writeln('Cuenta destinatario ');
    u.cuenta_destinatario:= 1;
    u.cuerpo_del_mensaje:= 'pepe';
  end;
var
  i: integer;
  u: info_usuario;
begin
  Assign(archUser, 'D:\Codigo\Fundamentos-De-Organizacion-De-Datos-FOD\Practicas-Resueltas\1-Archivos\tp2_maestro_detalle_merge\archivos_txt\eje13Archivos\binarioDetalle');
  rewrite(archUser);
  for i:=  1 to dimFUserInfo do
    begin
      leerData(u);
      write(archUser, u);
    end;
  close(archUser);
end;

procedure cargarServidor(var arch_server: arch_server);
  procedure leerData(var s: server);
  begin
    Writeln('Numero de usuario ');
    readln(s.nro_usuario);
    Writeln('Nombre de usuario ');
    s.nombre_usuario:= 'pepe';
    Writeln('Apellido ');
    s.apellido:= 'pepe';
    Writeln('Cantidad de mails enviados: ');
    readln(s.cantidadMailEnviados);
  end;
var
  s: server;
  i: integer;
begin
  Assign(arch_server, 'D:\Codigo\Fundamentos-De-Organizacion-De-Datos-FOD\Practicas-Resueltas\1-Archivos\tp2_maestro_detalle_merge\archivos_txt\eje13Archivos\binarioMaestro');
  rewrite(arch_server);
  for i:= 1 to dimFServer do
    begin
      leerData(s);
      write(arch_server, s);
    end;
  close(arch_server);
end;

procedure actualizarMaestro(var archServer: arch_server;var archUser: arch_usuario);
  procedure leerM(var archServer: arch_server; var s: server);
  begin
    if(not eof (archServer))then
      read(archServer, s)
    else
      s.nro_usuario:= valorAlto;
  end;

  procedure leerU(var archUser: arch_usuario; var u: info_usuario);
  begin
    if(not eof(archUser))then
      read(archUser, u)
    else
      u.nro_usuario:= valorAlto;
  end;
var
  s: server;
  cant: integer;
  actualUsuario: integer;
  u: info_usuario;
begin
  reset(archServer);
  reset(archUser);
  leerM(archServer,s);
  leerU(archUser, u);
  while (s.nro_usuario <> valorAlto) and (u.nro_usuario <> valorAlto) do
    begin
      while (s.nro_usuario <> valorAlto) and (u.nro_usuario <> valorAlto) and (s.nro_usuario <> u.nro_usuario) do
        begin
          leerM(archServer, s);
        end;
      if(s.nro_usuario = u.nro_usuario)then //esto ta al pedo, si o si tiene que estar, es una pre condicion... cada detalle seguro existe en el maestro
        begin
          cant:= 0;
          actualUsuario:= u.nro_usuario;
          while (u.nro_usuario <> valorAlto) and (actualUsuario = u.nro_usuario) do
            begin 
              cant:= cant+1;
              leerU(archUser, u);
            end;
          Seek(archServer, filepos(archServer)-1);
          s.cantidadMailEnviados:= s.cantidadMailEnviados+cant;
          write(archServer, s);
          if(not eof(archServer))then
            read(archServer, s);
        end;
    end;
end;

procedure imprimirMaestro(var archServer: arch_server);
var
  s: server;
begin
  reset(archServer);
  while(not eof (archServer))do
    begin
      read(archServer, s);
      Writeln('idUser: ',s.nro_usuario,' Cantidad: ',s.cantidadMailEnviados);
    end;
  close(archServer);
end;

procedure parteB(var archUser: arch_usuario);
var
  texto: text;
  u: info_usuario;
begin
  Assign(texto, 'D:\Codigo\Fundamentos-De-Organizacion-De-Datos-FOD\Practicas-Resueltas\1-Archivos\tp2_maestro_detalle_merge\archivos_txt\eje13Archivos\parteB.txt');
  Rewrite(texto);
  while (not eof(archUser)) do
    begin
      read(archUser, u);
      writeln(archUser, u.nro_usuario, u.cuenta_destinatario, u.cuerpo_del_mensaje);
    end;
  Close(texto);
end;

var
  archUser: arch_usuario;
  archServer: arch_server;
begin
  Writeln('Cargando usuarios');
  cargarArchivoUsuarios(archUser);
  Writeln('Cargando servidores');
  cargarServidor(archServer);
  Writeln('Actualizando Maestro');
  actualizarMaestro(archServer, archUser);
  imprimirMaestro(archServer);
  parteB(archUser);
end.
//busco en el maestro el detalle actual--> [corte de control de los repetidos, en el detalle, los contabilizo e impacto en el maestro]