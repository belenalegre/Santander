# Data Engineer Programming Test

### SQL

Para este test hemos creado un entorno inventado que simula situaciones de nuestra arquitectura actual. El candidato debe suponer que es un empleado del banco Santander y debe resolver una situación planteada por un área de negocio.

En este escenario, los datos de logueo de los usuarios del Santander se encuentran en una única tabla sobre BigQuery. En esta table se guarda toda la información referente a las actividades realizan los usuarios cuando ingresan al Home Banking de Santander. La estructura de dicha tabla se pueden ver a continuación:

![image](https://user-images.githubusercontent.com/62435760/127665003-e3aad47b-616d-44aa-af21-c25249e11123.png)

Basado en esa tabla, el área de la banca privada del banco desea que se arme un modelo dimensional en donde se contemplen dos tablas principales:

●	La primera vez que el usuario se logueo al Home Banking. Asumiendo que dicha situación es un tipo de evento.

●	La actividad diaria de cada usuario.

Tenga en cuenta las siguientes consideraciones técnicas:

1.	La table de origen contiene mil millones de registros.
2.	El modelo a construer debe poder ejecutarse tanto en consolas SQL o en herramientas de BI.
3.	Uno de los KPIs mas importantes que tiene la organización es la de retención de clientes. Dicho KPI es el porcentaje de usuarios que realizaron una actividad diferente al login durante 2 dos días consecutivos y cuya sesión haya durando al menos 5 minutos.

### Pregunta 1
Como resolvería este tipo de petición? Explique detalladamente el proceso de limpieza y transformación del modelo inicial. Que tecnologías utilizaría y por que?

> Dado que se trata de un origen de datos estructurado y estratégico para el negocio, que podría contener miles de millones de registros, lo recomendado para este caso es enviar los datos transaccionalmente a un Data Warehouse.  

> Por lo entendido durante el periodo de entrevistas, Santander cuenta con los servicios de AWS. En este caso el servicio recomendado es AWS Redshift, como uno de los esquemas de facturación de este servicio es por cantidad bytes analizados, con un mínimo de tamaño por consulta. Lo recomendado es envío de lotes de datos.

### Ejercicio 1
Realice el DER que de soporte al modelo dimensional solicitado por la banca privada.

<img width="557" alt="der" src="https://user-images.githubusercontent.com/69255326/131026928-0c586663-ef3c-46ec-96e4-7f46172bec90.PNG">

### Ejercicio 2 
Escriba las queries necesarias partiendo de la tabla inicial y que de como resultado el modelo planteado en el ejercicio anterior.

```
BEGIN TRANSACTION Test_Santander;

BEGIN TRY

    INSERT INTO dimCITYS (USER_CITY)
    SELECT DISTINCT src.USER_CITY
    FROM home_banking src
    LEFT JOIN dimCITYS dst ON (src.USER_CITY = dst.USER_CITY)
    WHERE dst.USER_CITY IS NULL;

    INSERT INTO dimEVENTS (EVENT_ID,EVENT_DESCRIPTION)
    SELECT DISTINCT src.EVENT_ID, src.EVENT_DESCRIPTION
    FROM home_banking src
    LEFT JOIN dimEVENTS dst ON (src.EVENT_ID = dst.EVENT_ID)
    WHERE dst.EVENT_ID IS NULL;

    INSERT INTO dimBROWSERS (DEVICE_BROWSER)
    SELECT DISTINCT src.DEVICE_BROWSER
    FROM home_banking src
    LEFT JOIN dimBROWSERS dst ON (src.DEVICE_BROWSER = dst.DEVICE_BROWSER)
    WHERE dst.DEVICE_BROWSER IS NULL;

    INSERT INTO dimMOBILES (DEVICE_MOBILE)
    SELECT DISTINCT src.DEVICE_MOBILE
    FROM home_banking src
    LEFT JOIN dimMOBILES dst ON (src.DEVICE_MOBILE = dst.DEVICE_MOBILE)
    WHERE dst.DEVICE_MOBILE IS NULL;

    INSERT INTO dimOS (DEVICE_OS)
    SELECT DISTINCT src.DEVICE_OS
    FROM home_banking src
    LEFT JOIN dimOS dst ON (src.DEVICE_OS = dst.DEVICE_OS)
    WHERE dst.DEVICE_OS IS NULL;

    INSERT INTO dimSEGMENTS (SEGMENT_ID, SEGMENT_DESCRIPTION)
    SELECT DISTINCT src.SEGMENT_ID, src.SEGMENT_DESCRIPTION
    FROM home_banking src
    LEFT JOIN dimSEGMENTS dst ON (src.SEGMENT_ID = dst.SEGMENT_ID)
    WHERE dst.SEGMENT_ID IS NULL;

    INSERT INTO USERS (USER_ID, SEGMENT_ID)
    SELECT DISTINCT src.USER_ID, src.SEGMENT_ID
    FROM home_banking src
    LEFT JOIN USERS dst ON (src.USER_ID = dst.USER_ID)
    WHERE dst.USER_ID IS NULL;

    INSERT INTO SESSIONS (
        SESSION_ID, 
        EVENT_ID, 
        USER_ID, 
        DEVICE_BROWSER_ID, 
        DEVICE_MOBILE_ID,
        DEVICE_OS_ID, 
        USER_CITY_ID, 
        SERVER_TIME, 
        TIME_SPENT, 
        CRASH_DETECTION
        )
    SELECT
        src.SESSION_ID,
        src.EVENT_ID,
        src.USER_ID,
        ( SELECT dimBROWSERS.DEVICE_BROWSER_ID FROM dimBROWSERS WHERE src.DEVICE_BROWSER = dimBROWSERS.DEVICE_BROWSER ),
        ( SELECT dimMOBILES.DEVICE_MOBILE_ID FROM dimMOBILES WHERE src.DEVICE_MOBILE = dimMOBILES.DEVICE_MOBILE ),
        ( SELECT dimOS.DEVICE_OS_ID FROM dimOS WHERE src.DEVICE_OS = dimOS.DEVICE_OS ),
        ( SELECT dimCITYS.USER_CITY_ID FROM dimCITYS WHERE src.USER_CITY = dimCITYS.USER_CITY ),
        src.SERVER_TIME,
        src.TIME_SPENT,
        src.CRASH_DETECTION
    FROM home_banking src
    LEFT JOIN (SELECT SESSION_ID FROM SESSIONS) dst ON (src.SESSION_ID = dst.SESSION_ID)
    WHERE dst.SESSION_ID IS NULL;

    COMMIT TRANSACTION Test_Santander;

END TRY

BEGIN CATCH

    ROLLBACK TRANSACTION Test_Santander;

END CATCH;
```

### Ejercicio 3
Escriba la consulta necesaria para obtener el KPI de retención de clientes para los 10 clientes que mas veces se hayan logueado en el último mes.

```

```

### Pregunta 2
Suponga que la ingesta de estos datos se realiza utilizando Apache Spark debido a que la tabla cruda tiene billones de registros. Que parametros de spark tendría en cuenta a la hora de realizar dicha ingesta? Explique brevemente en que consta cada uno de ellos. 
En que formato de compresión escribiría los resultados? Por que?

> Se debe tener en cuenta la cantidad de nodos en los cuales se particionara la ejecución para que de el procesamiento de los datos corra paralellamente si se quiere. A partir de un master node y una determinada cantidad de workers node. Para que suceda esto se debe ejecutar en cluster-mode.

> Por otro lado, se puede determinar la cantidad de memoria y nucleos a utilizar por cada node.

> Con respecto al formato de compresión se podrían escribir en Parquet dado que es un formato tabular que de por si posee una compresión que optimizaría en espacio.

### Pregunta 3

Existen varios problemas en cuanto a la calidad de datos de la tablas que consultan los usuarios de la banca privada, se esta investigando como mejorar y prevenir estos incidentes. Describa brevemente que implementaría para garantizar la confiabilidad de los datos.

>Cuando se habla de calidad de datos, hay varios motivos por los cuales podrían surgir incidentes que condicionen su calidad. Registros o columnas faltantes, formatos erróneos y significado en los datos.

>En la mayoría de los casos, las causas se deben a procesos en la ingesta de información o procedimientos pocos estandarizados (data entry o external sources). Asimismo, otra de las causantes de la falta de información o información errónea es la acumulación de silos de información a lo largo de la organización, donde en caso de compararse surgirían diferencias entre las mismas. Por último y en concordancia del Principle of least Privilege, se debe velar quién, cómo, cuando y donde se accede a la información, dado que el usuario podría generar algún incidente si tuviera mayores permisos que los correspondidos a su rol en la organización.

### Python 
(Para hacerlo interesante, usar Python 2.7)

Se deberá escribir un script que transforme el archivo datos_data_engineer.tsv en un archivo CSV que pueda ser insertado en una base de datos, y/o interpretado por cualquier parser estándar de archivos delimitados, de la manera más sencilla posible.

El archivo resultante debe tener las siguientes características:
* Cada row contiene la misma cantidad de campos
* Los campos se separan con un pipe |
* Se deben poder leer correctamente los caracteres especiales que estén presentes en los campos actuales del archivo. 
* El encoding del archivo final debe ser UTF-8 (datos_de_santander.tsv es un archivo UTF-16LE)
*

### Preguntas
* En qué requerimiento implementarías una cola de mensajes en una solución orientada a datos?  Que lenguaje utilizarías y porque?

> asd

* Que experiencia posees sobre py spark o spark scala? Contar breves experiencias, en caso de contar experiencia con otro framework de procesamiento distribuido, dar detalles también.

> 

* Qué funcionalidad podrías expandir desde el area de ingeniería de datos con una API y arquitectónicamente como lo modelarías?

> asd