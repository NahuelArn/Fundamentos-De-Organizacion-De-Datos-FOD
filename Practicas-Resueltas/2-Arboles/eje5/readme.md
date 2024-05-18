<p>
  5. Defina los siguientes conceptos:
  ● Overflow: se prodece cuando un nodo se llena y no hay espacio para insertar una nueva clave.  (Inserccion)

  ● Underflow: se produce cuando un nodo no tiene suficientes claves para realizar una operación de eliminación.  (Eliminacion)

  ● Redistribución: consiste en mover una clave de un nodo a otro para que ambos tengan la cantidad de claves necesarias.  (Eliminacion/Inserccion)

  ● Fusión o concatenación: consiste en unir dos nodos en uno solo, por convencion se guarda en el nodo izquierdo la fusion.  (Eliminacion)
  En los dos últimos casos, ¿cuándo se aplica cada uno?

  En el caso de la redistribución se aplica cuando un nodo no tiene suficientes claves para realizar una operación de eliminación, pero tiene un hermano con el cual se puede compartir una clave.

  En el caso de la fusión se aplica cuando ya se intento redistribuir, no tiene suficientes claves para realizar una operación de eliminación y no tiene un hermano con el cual compartir una clave.
</p>