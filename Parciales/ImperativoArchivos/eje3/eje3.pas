program eje3;

type
  clienteSuport = record
    nombre: string;
    apellido: string;
    domicilio: string;
    telefono: integer;
  end;

  cliente = record
    data: string; // nombre, apellido, domicilio, telefono
  end;

  archivo = file of cliente;

procedure leerData(var cS: clienteSuport);
begin
  Writeln('Ingrese el telefono: ');
  Readln(cS.telefono);
  if (cS.telefono <> 0) then
  begin
    Writeln('Ingrese el nombre: ');
    Readln(cS.nombre);
    Writeln('Ingrese el apellido: ');
    Readln(cS.apellido);
    Writeln('Ingrese el domicilio: ');
    Readln(cS.domicilio);
  end;
end;

procedure transferirData(var arch: archivo; cS: clienteSuport);
var
  aux, stringCel: string;
  c: cliente;
begin
  // Junto la data en un string
  Str(cS.telefono, stringCel);
  aux := cS.nombre + '$' + cS.apellido + '$' + cS.domicilio + '$' + stringCel + '&';
  c.data := aux;
  // Impacto en el archivo
  Write(arch, c);
end;

procedure cargarArchivo(var arch: archivo);
var
  cS: clienteSuport;
begin
  Rewrite(arch);
  leerData(cS);
  while cS.telefono <> 0 do
  begin
    transferirData(arch, cS);
    leerData(cS);
  end;
  Close(arch);
end;

procedure busqueda(var arch: archivo; numBuscado: string; var retorno: string);
var
  encontre: boolean;
  dataActual: cliente;
  fields: array of string;
begin
  Reset(arch);
  encontre := False;
  while (not Eof(arch)) and (not encontre) do
  begin
    Read(arch, dataActual);
    fields := dataActual.data.Split('$');
    if (fields[3] = numBuscado) then
    begin
      retorno := fields[2]; // domicilio
      encontre := True;
    end;
  end;
  if not encontre then
    retorno := 'Telefono no encontrado';
  Close(arch);
end;

var
  arch: archivo;
  numBuscado, retorno: string;
begin
  Assign(arch, 'infoClientes.dat');
  cargarArchivo(arch);
  Writeln('Ingrese un numero de telefono para buscar en el archivo: ');
  Readln(numBuscado);
  busqueda(arch, numBuscado, retorno);
  Writeln('Direccion del cliente: ', retorno);
end.


// program eje3;
// type
//   clienteSuport = record
//     nombre: string;
//     apellido: string;
//     domicilio: string;
//     telefono: integer;
//   end;
  
//   cliente = record
//     data: string; //nombre, apellido, domicilio, telefono
//   end;
//   archivo = file of cliente;

// procedure leerData(var cS: clienteSuport);
// begin
//   Writeln('Ingrese el telefono ');
//   read(cS.telefono);
//   if(cel <> 0)then
//     begin
//       writeln('Ingrese el nombre ');
//       read(cS.nombre);
//       writeln('Ingrese el apellido ');
//       read(cS.apellido);
//       writeln('Ingrese el domicilio ');
//       read(cS.domicilio);
//     end;
// end;

// procedure transferirData(var arch: archivo; cS:clienteSuport);
// var 
//   aux,stringCel: string;
//   c: cliente;
// begin
//   //junto la data en un string
//   str(cS.telefono,stringCel );
//   aux:= aux+cS.nombre +$+cS.apellido+$+cS.domicilio+$+stringCel+&;
//   //impacto en el archivo
//   c.data := aux;
//   write(arch,c);
// end;

// procedure cargarArchivo(var arch: archivo);
// var
//   cS: clienteSuport;
// begin
//   leerData(cS);
//   rewrite(arch);
//   while cS.telefono <> 0 do
//     begin
//       transferirData(arch,cS);
//       leerData(cS);
//     end;
//   close(arch);
// end;

// procedure busqueda(var arch: archivo; numBuscado: string;var retorno: string);
// var
//   encontre: boolean
//   dataActual: string;
// begin
//   reset(arch);
//   encontre:= false;
//   while (not eof(arch) and not encontre)do
//     begin
//       read(arch,dataActual);
//       fields := dataActual.data.Split('$');
//       if (fields[3] = numBuscado) then
//         begin
//           retorno := fields[2]; // domicilio
//           encontre := True;
//         end;
//     end;
//   if not encontre then
//     retorno := 'Telefono no encontrado';
//   close(arch);
// end;

// var
//   arch: archivo;
//   numBuscado,retorno: string;
// begin
//   assing(arch,'infoClientes');
//   cargarArchivo(arch);
//   writeln('Ingrese un numero de telefeno para buscar en el archivo');
//   busqueda(arch,numBuscado,retorno);
// end.