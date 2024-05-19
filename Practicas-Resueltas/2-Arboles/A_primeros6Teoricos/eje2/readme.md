<p>
Una mejora respecto a la solución propuesta en el ejercicio 1 sería mantener por un
lado el archivo que contiene la información de los alumnos de la Facultad de
Informática (archivo de datos no ordenado) y por otro lado mantener un índice al
archivo de datos que se estructura como un árbol B que ofrece acceso indizado por
DNI de los alumnos.

a. Defina en Pascal las estructuras de datos correspondientes para el archivo de
alumnos y su índice.

b. Suponga que cada nodo del árbol B cuenta con un tamaño de 512 bytes. ¿Cuál
sería el orden del árbol B (valor de M) que se emplea como índice? Asuma que
los números enteros ocupan 4 bytes. Para este inciso puede emplear una fórmula
similar al punto 1b, pero considere además que en cada nodo se deben
almacenar los M-1 enlaces a los registros correspondientes en el archivo de
datos.

c. ¿Qué implica que el orden del árbol B sea mayor que en el caso del ejercicio 1?

d. Describa con sus palabras el proceso para buscar el alumno con el DNI 12345678
usando el índice definido en este punto.

e. ¿Qué ocurre si desea buscar un alumno por su número de legajo? ¿Tiene sentido
usar el índice que organiza el acceso al archivo de alumnos por DNI? ¿Cómo
haría para brindar acceso indizado al archivo de alumnos por número de legajo?

f. Suponga que desea buscar los alumnas que tienen DNI en el rango entre
40000000 y 45000000. ¿Qué problemas tiene este tipo de búsquedas con apoyo
de un árbol B que solo provee acceso indizado por DNI al archivo de alumnos?

<p>

A
```pas

  program test;
  const 
      ORDEN = 5;
  type 
      talumno = record
          nombre:string[20];
          apellido:string[20];
          dni:longint;
          legajo:integer;
          anno:integer;
      end;

      //arbol = integer;  
      tnodo = record 
          hijos: array [1..ORDEN] of integer;  //NRRs
          elementos: array [1..(ORDEN-1)] of talumno;
          NHijos: integer;
      end;

      tarch = file of tnodo;

```

B
<img src= "https://github.com/NahuelArn/Algoritmos-Y-Estructura-De-Datos-AYED/assets/100500003/6af64e3c-f51e-41bc-960f-d729c4dc198e" autoplay alt="Descripción de la imagen"> 

C
<p>
    *Mayor capacidad de almacenamiento en cada nodo.
    *Mayor cantidad de claves por nodo.
    *Mayor cantidad de punteros por nodo.
    *Menor altura del arbol, respecto a otro arbol con menor orden.
 </p>

D
<p>
    leo la raiz
    leo cada clave de la raiz
    si encuentro la clave buscada y salvo el NNR para buscarlo en el archivo q esta la data, corta    //loop
    si es hoja, corta
    else{
        si la clave es menor que la buscada{
            voy al hijo derecho
        }else{
            voy al hijo izquierdo
        }
    }
 </p>

E
<p>
No seria eficiente usar el indice por DNI para buscar por legajo, ya que el arbol B esta organizado por DNI,
se tendria que hacer un recorrido por niveles para encontrar el legajo deseado. Para brindar acceso indizado por legajo o
contruir un nuevo arboles B con los legajos como claves
</p>


F
<p>
 El arbol B está diseñado para busquedas exactas, no para busquedas por rangos.
 Tendria que hacer varios recorridos por los mismos nodos, se podria usar la estructura de Arboles B+ para este tipo de busquedas, ya que tiene una lista enlazada.
</p>