{
  bajalogogica:  borrar elementos pero conservando su valor.. como borrar la referencia a algo
  bajafisica, se recupera el espacio
  saldu2
}
program parcial;
type  
  so = record
    nombreSo: string;
    cantInstalaciones: integer;
    esDeCodigoAbierto: boolean;
    tipoDeLicencia: string; //enum
  end;

  que = file of so;

procedure altaSistemaOperativo(var s: que; r: so);
var
  cabecera: so;
  rActual: so;
  pos: integer;
begin
  reset(s);
  read(s, cabecera);
  if(cabecera.cantInstalaciones < 0)then
    begin
      pos:= cabecera.cantInstalaciones*-1; //convierto a positivo
      seek(s, pos);
      read(s,cabecera);
      seek(s, filePos(s)-1);
      write(s, r);
      seek(s, 0);
      write(s,cabecera);
    end
  else
    begin
      seek(s, FileSize(s));
      write(s, r);
    end;
  close(s);
end;

procedure darDeBajaOperativo(var  arch: que; r: so);
var
  cabecera,soActual: r;
  encontrado: boolean;
begin
  reset(arch);
  encontrado:= false;
  read(arch,cabecera);
  while not eof(arch) and (not encontrado)do
    begin
      read(arch, soActual);
      encontrado:= r.nombreSo =soActual.nombreSo;
    end;
  if(encontrado)then
    begin
      seek(arch,filePos(arch)-1);
      write(arch,cabecera);
      cabecera.cantInstalaciones:= (filePos(arch)-1)*-1;
      seek(arch, 0);
      write(cabecera);
    end
  else
    Writeln('El sistema oprativo no se encotnraba en el archivo');
end;

var
  s: que;
  r: so;
begin
  assign(s,'yaSeDispone');
  //cargarSOS(s); //ya viene cargado
  leerData(r); //me retorna la data de un SO
  altaSistemaOperativo(s,r);
end.