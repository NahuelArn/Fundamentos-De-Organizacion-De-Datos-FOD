<p> 
Considere que desea almacenar en un archivo la información correspondiente a los
alumnos de la Facultad de Informática de la UNLP. De los mismos deberá guardarse
nombre y apellido, DNI, legajo y año de ingreso. Suponga que dicho archivo se organiza
como un árbol B de orden M.

a. Defina en Pascal las estructuras de datos necesarias para organizar el archivo de
alumnos como un árbol B de orden M.

b. Suponga que la estructura de datos que representa una persona (registro de
persona) ocupa 64 bytes, que cada nodo del árbol B tiene un tamaño de 512
bytes y que los números enteros ocupan 4 bytes, ¿cuántos registros de persona
entrarían en un nodo del árbol B? ¿Cuál sería el orden del árbol B en este caso (el
valor de M)? Para resolver este inciso, puede utilizar la fórmula N = (M-1) * A + M *
B + C, donde N es el tamaño del nodo (en bytes), A es el tamaño de un registro
(en bytes), B es el tamaño de cada enlace a un hijo y C es el tamaño que ocupa
el campo referido a la cantidad de claves. El objetivo es reemplazar estas
variables con los valores dados y obtener el valor de M (M debe ser un número
entero, ignorar la parte decimal).

c. ¿Qué impacto tiene sobre el valor de M organizar el archivo con toda la
información de los alumnos como un árbol B?

d. ¿Qué dato seleccionaría como clave de identificación para organizar los
elementos (alumnos) en el árbol B? ¿Hay más de una opción?

e. Describa el proceso de búsqueda de un alumno por el criterio de ordenamiento
especificado en el punto previo. ¿Cuántas lecturas de nodos se necesitan para
encontrar un alumno por su clave de identificación en el peor y en el mejor de
los casos? ¿Cuáles serían estos casos?</p>


A-
```pas

  const
    M = 5; // Ejemplo de orden del árbol B
    //integer = 4 bytes
  type
    TAlumno = record        //64 bytes
      NombreApellido: string[50];
      DNI: string[10];
      Legajo: string[10];
      AñoIngreso: integer;
    end;

    TClave = record
      Clave: string[10]; // Puede ser DNI, Legajo, etc.
      Info: TAlumno;
    end;

    TNodo = record  //512 bytes
      Claves: array[1..M-1] of TClave;
      Hijos: array[0..M] of ^TNodo;
      CantClaves: integer;
      EsHoja: boolean;
    end;

  var
    Raiz: ^TNodo;


```

B
<img src= "https://github.com/NahuelArn/Algoritmos-Y-Estructura-De-Datos-AYED/assets/100500003/398e7215-7b03-4b5a-a990-76b2a8a0f867" autoplay alt="Descripción de la imagen"> 

C
<img src= "https://github.com/NahuelArn/Algoritmos-Y-Estructura-De-Datos-AYED/assets/100500003/fc163581-472d-4fac-9dec-f8fa648100c4" autoplay alt="Descripción de la imagen"> 

D
<img src= "https://github.com/NahuelArn/Algoritmos-Y-Estructura-De-Datos-AYED/assets/100500003/9d0734b8-d19c-4bbd-b0df-7efe1057d81c" autoplay alt="Descripción de la imagen"> 

E
<img src= "https://github.com/NahuelArn/Algoritmos-Y-Estructura-De-Datos-AYED/assets/100500003/2360ef64-1a4c-4bb0-8075-06633e6ba036" autoplay alt="Descripción de la imagen"> 
D
<img src= "https://github.com/NahuelArn/Algoritmos-Y-Estructura-De-Datos-AYED/assets/100500003/ee73c543-2d0b-4377-a810-7472d39b8e08" autoplay alt="Descripción de la imagen"> 


