<h1 align="center">Archivardos</h1>
<!-- <p align="center">
  <img src=  autoplay alt="Descripción de la imagen">
</p> -->

<h1 align="center"> a tener en cuenta </h1>

<p> 
FilePos(nombre_logico) //me dice la posicion actual del archivo ("indice")

FileSize(nombre_logico); //me la pos maxima del archivo (el tamanho)

Seek(nombre_logico, posicion) // vas a una posicion en el archivo (la pos tiene q ser valida)

Eof(nombre_logico) //va preguntando si estas en el final de archivo

read / write
en ambos casos el sp aumenta en 1 automaticamente

  read(nombre_logico, variable1) //se va leer lo que tiene [nombre logico] y se va hacer una copia a variable1
  write(nombre_logico, variable2) // se va escribir el contenido de variable2 en nombre_logico

</p>