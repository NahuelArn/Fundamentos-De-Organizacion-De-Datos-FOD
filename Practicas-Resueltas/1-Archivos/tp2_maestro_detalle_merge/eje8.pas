{
   8. Se cuenta con un archivo que posee información de las ventas que realiza una empresa a
  los diferentes clientes. Se necesita obtener un reporte con las ventas organizadas por
  cliente. Para ello, se deberá informar por pantalla: los datos personales del cliente, el total
  mensual (mes por mes cuánto compró) y finalmente el monto total comprado en el año por el
  cliente.
  Además, al finalizar el reporte, se debe informar el monto total de ventas obtenido por la
  empresa.
  El formato del archivo maestro está dado por: cliente (cod cliente, nombre y apellido), año,
  mes, día y monto de la venta.
  El orden del archivo está dado por: cod cliente, año y mes.

  Nota: tenga en cuenta que puede haber meses en los que los clientes no realizaron
  compras

}

program eje8;
const
  dimF = 3;
  valorAlto = 999;
type

  cliente = record
    codCliente: integer;
    nombre: string;
    apellido: string;
    anho: integer;
    mes: integer;
    dia: integer;
    montoVenta: real;
  end;

  archivo_cliente = file of cliente;

{El orden del archivo está dado por: cod cliente, año y mes.}
procedure cargarData(var archCli: archivo_cliente); //tipo normal //tipo matriz // tipo lineal
  procedure leerData(var cli: cliente);
  begin
    Writeln('-----------------------------------------');
    Writeln('ingrese el cod del cliente ');
    readln(cli.codCliente);
    Writeln('Ingrese el nombre ');
    cli.nombre:= 'pepe';
    Writeln('Ingrese el apellido ');
    cli.apellido:= 'fernandez';
    Writeln('Ingrese el anho ');
    readln(cli.anho);
    Writeln('Ingrese el mes');
    readln(cli.mes);
    Writeln('Ingrese el dia');
    cli.dia:= 2;
    Writeln('Ingrese el monto de la venta');
    cli.montoVenta:= 10;
    Writeln();
  end;

var
  cli: cliente;
  direcion_mutable, direccion_inmutable, casa: string;
  i: integer;
begin
  direccion_inmutable:= 'D:\Codigo\Fundamentos-De-Organizacion-De-Datos-FOD\Practicas-Resueltas\1-Archivos\tp2_maestro_detalle_merge\archivos_txt\eje8Archivos\binarioMaestro';
  Assign(archCli, direccion_inmutable);  
  rewrite(archCli); 
  for i:= 1 to dimF do
    begin
      // str(i,casa);  
      // direcion_mutable:= direccion_inmutable + casa;  
      //Assign(archCli, direccion_inmutable);   
      leerData(cli);  
      write(archCli, cli); 
    end;
  close(archCli);
  // reset(archCli);
  // for i:= 1 to dimF do
  //   begin
  //     Read(archCli, cli);
  //     writeln('mes: ',cli.mes);
  //   end;
  // close(archCli);
end;

{

  Para ello, se deberá informar por pantalla: los datos personales del cliente, el total
  mensual (mes por mes cuánto compró) y finalmente el monto total comprado en el año por el
  cliente.
  Además, al finalizar el reporte, se debe informar el monto total de ventas obtenido por la
  empresa.
}
procedure informarReporte(var archCli: archivo_cliente);
  procedure informarDataCliente(cli: cliente);
  begin
    writeln();
    Writeln('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
    Writeln('Cod cliente ',cli.codCliente);
    Writeln('Nombre ',cli.nombre);
    Writeln('Apellido: ',cli.apellido);
    Writeln('Anho ',cli.anho);
    Writeln('Mes ',cli.mes);
    Writeln('Dia ',cli.dia);
    Writeln('Monto venta ',cli.montoVenta);
    Writeln('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
    writeln();
  end;

  procedure leer(var archCli: archivo_cliente; var cli: cliente);
  begin
    if(not eof(archCli))then
      read(archCli, cli)
    else
      cli.codCliente:= valorAlto;
  end;

var
  mesActual,anhoActual, codActual: integer;
  cli: cliente;
  totalMensual, totalAnho,totalVentasPorLaEmpresa: real;
begin
  reset(archCli);
  totalVentasPorLaEmpresa:= 0;
  leer(archCli,cli);
  while (cli.codCliente <> valorAlto)do
    begin
      codActual:= cli.codCliente;
      while ((cli.codCliente <> valorAlto) and (codActual = cli.codCliente))do
        begin
          anhoActual:= cli.anho;
          informarDataCliente(cli);
          totalAnho:= 0;
          while ((cli.codCliente <> valorAlto) and (codActual = cli.codCliente) and (cli.anho = anhoActual))do
            begin
              mesActual:= cli.mes;
              totalMensual:= 0;
              while ((cli.codCliente <> valorAlto) and (codActual = cli.codCliente) and (cli.anho = anhoActual) and (mesActual = cli.mes))do
                begin
                  totalMensual:= totalMensual + cli.montoVenta;
                  leer(archCli,cli);
                end;
              Writeln('En el mes: ',mesActual,' gasto: ',totalMensual:2:2);
              totalAnho:= totalAnho+ totalMensual;
            end;
            Writeln('En el anho: ',anhoActual, ' gasto: ',totalAnho:2:2);
            totalVentasPorLaEmpresa:= totalVentasPorLaEmpresa + totalAnho;
        end;
    end;
    Writeln('Total ventas obtenido por la empresa: ',totalVentasPorLaEmpresa:2:2);
    close(archCli);
end;

var
  archCli: archivo_cliente;
begin
  cargarData(archCli);
  wRITELN();wRITELN();
  informarReporte(archCli);
end.


// program eje8;
// const
//   dimF = 3;
//   valorAlto = 999;
// type

//   cliente = record
//     codCliente: integer;
//     nombre: string;
//     apellido: string;
//     anho: integer;
//     mes: integer;
//     dia: integer;
//     montoVenta: real;
//   end;

//   archivo_cliente = file of cliente;

// {El orden del archivo está dado por: cod cliente, año y mes.}
// procedure cargarData(var archCli: archivo_cliente); //tipo normal //tipo matriz // tipo lineal
//   procedure leerData(var cli: cliente);
//   begin
//     Writeln('-----------------------------------------');
//     Writeln('ingrese el cod del cliente ');
//     readln(cli.codCliente);
//     Writeln('Ingrese el nombre ');
//     cli.nombre:= 'pepe';
//     Writeln('Ingrese el apellido ');
//     cli.apellido:= 'fernandez';
//     Writeln('Ingrese el anho ');
//     readln(cli.anho);
//     Writeln('Ingrese el mes');
//     readln(cli.mes);
//     Writeln('Ingrese el dia');
//     cli.dia:= 2;
//     Writeln('Ingrese el monto de la venta');
//     cli.montoVenta:= 10;
//     Writeln();
//   end;

// var
//   cli: cliente;
//   direcion_mutable, direccion_inmutable, casa: string;
//   i: integer;
// begin
//   direccion_inmutable:= 'D:\Codigo\Fundamentos-De-Organizacion-De-Datos-FOD\Practicas-Resueltas\1-Archivos\tp2_maestro_detalle_merge\archivos_txt\eje8Archivos\binarioMaestro';
//   Assign(archCli, direccion_inmutable);  
//   rewrite(archCli); 
//   for i:= 1 to dimF do
//     begin
//       // str(i,casa);  
//       // direcion_mutable:= direccion_inmutable + casa;  
//       //Assign(archCli, direccion_inmutable);   
//       leerData(cli);  
//       write(archCli, cli); 
//     end;
//   close(archCli);
//   // reset(archCli);
//   // for i:= 1 to dimF do
//   //   begin
//   //     Read(archCli, cli);
//   //     writeln('mes: ',cli.mes);
//   //   end;
//   // close(archCli);
// end;

// {

//   Para ello, se deberá informar por pantalla: los datos personales del cliente, el total
//   mensual (mes por mes cuánto compró) y finalmente el monto total comprado en el año por el
//   cliente.
//   Además, al finalizar el reporte, se debe informar el monto total de ventas obtenido por la
//   empresa.
// }
// procedure informarReporte(var archCli: archivo_cliente);
//   procedure informarDataCliente(cli: cliente);
//   begin
//     writeln();
//     Writeln('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
//     Writeln('Cod cliente ',cli.codCliente);
//     Writeln('Nombre ',cli.nombre);
//     Writeln('Apellido: ',cli.apellido);
//     Writeln('Anho ',cli.anho);
//     Writeln('Mes ',cli.mes);
//     Writeln('Dia ',cli.dia);
//     Writeln('Monto venta ',cli.montoVenta);
//     Writeln('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
//     writeln();
//   end;

//   procedure leer(var archCli: archivo_cliente; var cli: cliente);
//   begin
//     if(not eof(archCli))then
//       read(archCli, cli)
//     else
//       cli.codCliente:= valorAlto;
//   end;

// var
//   mesActual,anhoActual, codActual: integer;
//   cli: cliente;
//   totalMensual, totalAnho,totalVentasPorLaEmpresa: real;
// begin
//   reset(archCli);
//   totalVentasPorLaEmpresa:= 0;
//   while (not eof(archCli))do
//     begin
//       read(archCli, cli);
//       codActual:= cli.codCliente;
//       while ((not eof(archCli)) and (codActual = cli.codCliente))do
//         begin
//           anhoActual:= cli.anho;
//           informarDataCliente(cli);
//           totalAnho:= 0;
//           while ((not eof(archCli)) and (codActual = cli.codCliente) and (cli.anho = anhoActual))do
//             begin
//               mesActual:= cli.mes;
//               totalMensual:= 0;
//               while ((not eof(archCli)) and (codActual = cli.codCliente) and (cli.anho = anhoActual) and (mesActual = cli.mes))do
//                 begin
//                   totalMensual:= totalMensual + cli.montoVenta;
//                   WRITELN('MESSSSSS: ',cli.mes);
//                   read(archCli, cli);
//                 end;
//               Writeln('En el mes: ',mesActual,' gasto: ',totalMensual:2:2);
//               totalAnho:= totalAnho+ totalMensual;
//             end;
//             Writeln('En el anho: ',anhoActual, ' gasto: ',totalAnho:2:2);
//             totalVentasPorLaEmpresa:= totalVentasPorLaEmpresa + totalAnho;
//         end;
//     end;
//     Writeln('Total ventas obtenido por la empresa: ',totalVentasPorLaEmpresa:2:2);
//     close(archCli);
// end;

// var
//   archCli: archivo_cliente;
// begin
//   cargarData(archCli);
//   wRITELN();wRITELN();
//   informarReporte(archCli);
// end.