program parcial;
const
  valorAlto = 999;
type
  prestamo = record
    numSucursal: integer;
    dniEmpleado: integer;
    numPrestamo: integer;
    fecha: string;
    montoOtorgado: real;
  end;

  pArch = file of prestamo;

procedure leer(var arch: pArch; var p: prestamo);
begin
  if( not eof (arch))then
    read(arch)
  else
    p.numSucursal:= valorAlto;
end;

procedure generarInforme(var arch: pArch);
var
  txt: text;
  p: prestamo;
  sucursalActual, dniActual: integer;
  fechaActual: string;
begin
  reset(arch);
  assign(txt, 'informeEmpresa.txt');
  rewrite(txt);
  leer(arch, p);
  write(txt, 'Informe de ventas de la empresa');
  montoEmpresa:= 0; cantEmpresa:= 0;
  while p.numSucursal <> valorAlto do
    begin
      sucursalActual = p.numSucursal;
      write(txt,  'numero de sucursal: ',sucursalActual);
      montoSucursal:= 0; cantSucursal:= 0;
      while sucursalActual = p.numSucursal do
        begin
          dniActual:= p.dniEmpleado;
          write(txt, 'Empleado: dni < ',p.dniEmpleado,' ,>');
          montoDni:= 0; totalVentasDni:= 0;
          while sucursalActual = p.numSucursal and dniActual = p.dniEmpleado do
            begin
              fechaActual = p.fecha;
              cantidadVentasFecha:= 0; montoFecha:= 0;
              while sucursalActual = p.numSucursal and dniActual = p.dniEmpleado and fechaActual = p.fecha do
                begin
                  cantidadVentasFecha:= cantidadVentasFecha+ 1;
                  montoFecha:= montoFecha+ p.montoOtorgado;
                  leer(arch, p);
                end;
              Write(txt, fechaActual, cantidadVentasFecha, montoFecha);
              montoDni:= montoDni+ montoFecha;
              totalVentasDni:= totalVentasDni;
            end;
          Writeln(txt, totalVentasDni,montoDni);
          write(txt, dniActual);
          montoSucursal:= montoSucursal+ montoDni;
          cantSucursal:= cantSucursal+ totalVentasDni;
        end;
      Writeln('cantidad de ventas de sucursal: ',cantSucursal);
      Writeln('Monto total vendido por sucursal: ',montoSucursal);
      montoEmpresa:= montoSucursal + montoEmpresa;
      cantEmpresa:= cantEmpresa+ cantSucursal;
    end;
  Writeln('Cantidad de ventas de la empresa: ',cantEmpresa);
  Writeln('Monto total de la empresa: ',montoEmpresa);
  close(txt);
  close(arch);
end;

var
  arch: pArch;
begin
  assig(arch, 'yaCargado');
  generarInforme(arch);
end.