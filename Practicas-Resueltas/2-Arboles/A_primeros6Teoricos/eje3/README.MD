<P> 
  Los árboles B+ representan una mejora sobre los árboles B dado que conservan la
  propiedad de acceso indexado a los registros del archivo de datos por alguna clave,
  pero permiten además un recorrido secuencial rápido. Al igual que en el ejercicio 2,
  considere que por un lado se tiene el archivo que contiene la información de los
  alumnos de la Facultad de Informática (archivo de datos no ordenado) y por otro lado
  se tiene un índice al archivo de datos, pero en este caso el índice se estructura como
  un árbol B+ que ofrece acceso indizado por DNI al archivo de alumnos. Resuelva los
  siguientes incisos:

  a. ¿Cómo se organizan los elementos (claves) de un árbol B+? ¿Qué elementos se
  encuentran en los nodos internos y que elementos se encuentran en los nodos
  hojas?

  b. ¿Qué característica distintiva presentan los nodos hojas de un árbol B+? ¿Por
  qué?

  c. Defina en Pascal las estructuras de datos correspondientes para el archivo de
  alumnos y su índice (árbol B+). Por simplicidad, suponga que todos los nodos del
  árbol B+ (nodos internos y nodos hojas) tienen el mismo tamaño

  d. Describa, con sus palabras, el proceso de búsqueda de un alumno con un DNI
  específico haciendo uso de la estructura auxiliar (índice) que se organiza como
  un árbol B+. ¿Qué diferencia encuentra respecto a la búsqueda en un índice
  estructurado como un árbol B?

  e. Explique con sus palabras el proceso de búsqueda de los alumnos que tienen DNI
  en el rango entre 40000000 y 45000000, apoyando la búsqueda en un índice
  organizado como un árbol B+. ¿Qué ventajas encuentra respecto a este tipo de
  búsquedas en un árbol B?

</P>


<h3>A. ¿Cómo se organizan los elementos (claves) de un árbol B+? ¿Qué elementos se
  encuentran en los nodos internos y que elementos se encuentran en los nodos
  hojas?
 </h3> 
<p>
Los nodos internos, contienen los separadores que son puntos de decisión para dirigir la búsqueda hacia las hojas apropiadas.

Los nodos hojas contienen las claves y los punteros a los registros de datos asociados a las claves.
</p>

<h3>B ¿Qué característica distintiva presentan los nodos hojas de un árbol B+? ¿Porqué?</h3>
<p>
Los nodos hojas contienen las claves y los punteros a los registros de datos asociados pero tambien están enlazados entre si, formando una lista enlazada que permite recorrer los registros en orden y listar de una forma facil los elementos.
</p>

<h3>C Defina en Pascal las estructuras de datos correspondientes para el archivo de
  alumnos y su índice (árbol B+). Por simplicidad, suponga que todos los nodos del
  árbol B+ (nodos internos y nodos hojas) tienen el mismo tamaño</h3>

```pas

  program test;
  const 
    orden = 6;
  type
  TAlumno = record
    DNI: LongInt;
    Nombre: String[50];
    Apellido: String[50];
  end;

  TDataPointer = TAlumno; // Puntero al registro en el archivo de datos

  lista = ^ nodo;

  nodo = record
    Keys: array[1..orden-1] of LongInt; // Claves en el nodo
    child: array[0..orden-1] of lista; // Punteros a hijos
    enlaces: array[0..orden] of LongInt; // Puntero al siguiente nodo hoja (si es hoja)
    sig:lista;
  end;

  arbol = file of nodo;

```

<h3> 
  d. Describa, con sus palabras, el proceso de búsqueda de un alumno con un DNI
  específico haciendo uso de la estructura auxiliar (índice) que se organiza como
  un árbol B+. ¿Qué diferencia encuentra respecto a la búsqueda en un índice
  estructurado como un árbol B?

</h3>

<p>
  -Iniciar en la raíz del árbol B del índice.
  -Comparar el DNI con las claves del nodo actual PARA VER SI VOY IZQ O DER:
  -Llego a un nodo hoja:
    -Si el DNI coincide con alguna clave del nodo, se ha encontrado el registro.
    -Si no coincide, el DNI no está en el archivo.
  Siempre terminamos en un nodo hoja, para encontrar el registro. a diferencia de un arbol B donde se puede terminar en un nodo interno.
</p>

<h3> 
e. Explique con sus palabras el proceso de búsqueda de los alumnos que tienen DNI
en el rango entre 40000000 y 45000000, apoyando la búsqueda en un índice
organizado como un árbol B+. ¿Qué ventajas encuentra respecto a este tipo de
búsquedas en un árbol B?
</h3>

<p>
  Si Amato te robe este pseudocodigo asjdajsd
  El proceso consiste primero en buscar la clave con valor 40000000 o mayor pero < a 45000000, para lo cual se debe llegar 
  a una hoja. Una vez identificada dicha clave se continua de la siguiente manera:
      1-Quedan claves por leer en el nodo? Si->2 No-> 4
      2-Leo la proxima clave. Es menor o igual a 50000000? Si->3 No->6
      3-Tomo la clave. -> 1
      4-Quedan nodos hoja? Si->5 No->6
      5-Leo el proximo nodo. -> 1
      6-Termine el recorrido.
  La ventaja es que va directo al nodo minimo Valido y ahi recorre los nodos hojas en orden hasta 45..., sin necesidad de recorrer nodos internos de mas.
  --Iniciar en la raíz del árbol B+.
  --Desplazarse a través de los nodos internos hasta llegar al primer nodo hoja que puede contener el menor DNI del rango (40000000).
  --En el nodo hoja, buscar el primer DNI dentro del rango.
  --Utilizar los punteros secuenciales entre nodos hojas para recorrer y recoger todos los DNIs dentro del rango hasta llegar al final del rango (45000000).
</p>