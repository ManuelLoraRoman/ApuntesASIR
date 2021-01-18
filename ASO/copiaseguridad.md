# Sistema de copias de seguridad

Implementa un sistema de copias de seguridad para las instancias del cloud y el VPS, teniendo en cuenta las siguientes características:

    Selecciona una aplicación para realizar el proceso: bacula, amanda, shell script con tar, rsync, dar, afio, etc.
    Utiliza una de las instancias como servidor de copias de seguridad, añadiéndole un volumen y almacenando localmente las copias de seguridad que consideres adecuadas en él.
    El proceso debe realizarse de forma completamente automática
    Selecciona qué información es necesaria guardar (listado de paquetes, ficheros de configuración, documentos, datos, etc.)
    Realiza semanalmente una copia completa
    Realiza diariamente una copia incremental, diferencial o delta diferencial (decidir cual es más adecuada)
    Implementa una planificación del almacenamiento de copias de seguridad para una ejecución prevista de varios años, detallando qué copias completas se almacenarán de forma permanente y cuales se irán borrando.
    Crea un registro de las copias, indicando fecha, tipo de copia, si se realizó correctamente o no y motivo.
    Selecciona un directorio de datos "críticos" que deberá almacenarse cifrado en la copia de seguridad, bien encargándote de hacer la copia manualmente o incluyendo la contraseña de cifrado en el sistema
    Incluye en la copia los datos de las nuevas aplicaciones que se vayan instalando durante el resto del curso
    Utiliza saturno u otra opción que se te facilite como equipo secundario para almacenar las copias de seguridad. Solicita acceso o la instalación de las aplicaciones que sean precisas.

El sistema de copias debe estar operativo para la fecha de entrega, aunque se podrán hacer correcciones menores que se detecten a medida que vayan ejecutándose las copias. La corrección se realizará la última semana de curso y consistirá tanto en la restauración puntual de un fichero en cualquier fecha como la restauración completa de una de las máquinas.
