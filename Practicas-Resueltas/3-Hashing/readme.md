
<h1 align='center'> Práctica 5</h1>

<h2 align='center'>Hashing (Dispersión)<h2>

## Los primeros 6 Ejercicios
<!-- despues ordenarlo -->

<h3 align='center'> Eje 1,2,3,4,5,6</h3>

### Ordered

1. Defina el concepto de hashing (o dispersión). ¿Cómo se relaciona este concepto con archivos?
    <h4>Respuesta</h4>
    <p> es una tecnica utilizada para mapear datos de tamaño variable a un tamaño fijo, que genera una direccion base unica, para una clave dada(un dato de entrada), generalmente con el propósito de busqueda rapida y eficiente.
En contenxto archivos se van a utilizar para administrar la busquedas a X archivo y hacerlo de manera eficiente, ya que permite el acceso directo a registros especificos. Por ejemplo las bases de datos
que tienen un campo clave en cada registro, que puede ser proporcionado por una funcion de dispersion, para determinar la ubicacion del registro en el archivo.

</p>
<br>
2. Explique el concepto de función de dispersión. Enumere al menos tres funciones de
 dispersión y explique brevemente cómo funciona cada una.
    <h4>Respuesta</h4>
    <p> Una función de dispersión es un algoritmo que toma una entrada (o clave) y devuelve un valor hash, que es un numero entero utilizado como índice en una tabla de hash.
    
*SHA-256 (Secure Hash Algorithm 256-bit):
    Funcionamiento: SHA-256 toma un mensaje de cualquier longitud y lo procesa en bloques de 512 bits. A través de varias rondas de procesamiento, utilizando operaciones lógicas y aritméticas, produce un valor hash de 256 bits. Es ampliamente utilizado en criptografía debido a su alta seguridad.
    Ejemplo: Si se toma el mensaje "hello world", el hash SHA-256 sería "b94d27b9934d3e08a52e52d7da7dabfade634d8e94d6d09e1e1b73b7f77c5104".
    
-Bcrypt
    Funcionamiento: bcrypt es una función de hash diseñada específicamente para contraseñas. Utiliza el cifrado Blowfish y aplica una función de costo que controla cuántas iteraciones del algoritmo se ejecutan, lo que permite ajustar la dificultad y proteger contra ataques de fuerza bruta con hardware moderno.
    Salting: Añade un valor aleatorio (sal) a cada contraseña antes de hashearla para asegurar que dos contraseñas idénticas no produzcan el mismo hash.
    Adaptive: Permite aumentar el número de iteraciones con el tiempo para mantenerse seguro contra el aumento de la potencia de procesamiento.
    </p>
<br>
3. Explique los conceptos de sinónimo, colisión y desborde (overflow). ¿Qué condición es
 necesaria en el archivo directo para que pueda ocurrir una colisión y no un desborde?
    <h4>Respuesta</h4>
    <p> Colision: cuando se hashea una clave, se busca el lugar donde ubicarlo pero ya esta ocupado(tiene sus claves maximas que soporta la cubeta/nodo)</p>
4.  ¿Qué alternativas existen para reducir el número de colisiones (y por ende de
 desbordes) en un archivo organizado mediante la técnica de hashing?
    <h4>Respuesta</h4>
    <p> 
        Saturacion progesiva: busca desde la direccion base que me dio la funcion de hasheo/dispercion,
        para abajo, hasta encontrar una cubeta/nodo con espacio suficiente
        
Encadenada: la funcion de dispersion/hashing me da una direccion y resulta que esa direccion           esta ocupada, se busca secuencialmente para abajo y una vez que encuentra un lugar, en la              direccion base que me habia dado se guarda un registro donde se termino guardado el nuevo     registro 

Con Area de desborde: me llega una direccionde hasheo, esa direccion esta ocupada entonces en otra tabla, se almacena la clave y en la tabla original en la direccion 
base q medio la direccion de hasheo guardo una referencia a ese campo de la nueva tabla
        
Dispersion Doble: me da un direccion la funcion de hasheo, se da cuenta que la direccion esta ocupada, entonces genera un hash nuevo
</p>
    
5.  Explique brevemente qué es la densidad de empaquetamiento. ¿Cuáles son las
 consecuencias de tener una menor densidad de empaquetamiento en un archivo
 directo?
    <h4>Respuesta</h4>
    <p> Relación entre el espacio disponible para el archivo de datos y la cantidad de registros que integran el mismo. (Te dice que tan lleno esta tu tabla de hash.. Formula: DE: numero de registros/cant total)
</p>
<br>
<div>
6.  Explique brevemente cómo funcionan las siguientes técnicas de resolución de
 desbordes que se pueden utilizar en hashing estático.
    * Saturación progresiva
        <h4>Respuesta</h4>
        <p> 
            1-Funcionamiento: Cuando ocurre una colisión, se busca la siguiente 
            posición libre en la tabla de hash linealmente.
            2-Ventaja: Sencillo de implementar.
            3-Desventaja: Puede llevar a clustering, donde las 
            colisiones provocan más colisiones cercanas.
        </p>
    * Saturación progresiva encadenada
       <h4>Respuesta</h4>
        <p> 
            1-Funcionamiento: Cada posición en la tabla de hash apunta a una lista enlazada que                    contiene 
            todos los elementos que colisionan en esa posición.
            2-Ventaja: Resuelve colisiones eficientemente.
            3-Desventaja: Mayor uso de memoria y complejidad en la implementación.
        </p>
    * Saturación progresiva encadenada con área de desborde separada
    *   <h4>Respuesta</h4>
        <p> 
           1-Funcionamiento: Los elementos que colisionan son almacenados en una área de desborde                 separada en lugar de en listas enlazadas.
           2-Ventaja: Mantiene la tabla de hash principal limpia y organizada.
           3-Desventaja: Puede requerir más gestión de memoria.
        </p>
    * Dispersión doble
        <h4>Respuesta</h4>
        <p> 
            1-Funcionamiento: Utiliza una segunda función de hash cuando ocurre una colisión para                  determinar el salto o incremento para la búsqueda de una posición libre.
            2-Ventaja: Reduce clustering comparado con la saturación progresiva.
            3-Desventaja: Más complejidad en la función de dispersión y su implementación.
        </p>

</div>

