----------
##### TAGS: #programacion #codigo #scripting #pearl

------
# CONCEPTO

> **Perl** es un lenguaje de programación muy versátil y poderoso, utilizado en diversos campos, como desarrollo web, scripting, automatización y análisis de datos. Su nombre "Perl" proviene de "Practical Extraction and Reporting Language" lo que refleja su capacidad para extraer información y generar informes de manera práctica.

------------
## USO:
Para ejecutar un script que este hecho en **Perl** debemos ejecutar el comando **"perl"** en nuestra consola de comandos seguido del nombre del script:

```BASH
pearl ejemplo.pl
```

Si quisiéramos crear un script en **Perl** lo primero que tenemos que hacer es definir la estructura y para ello utilizamos el shebang **(`#!`)** de perl:  

```PERL
#!/usr/bin/perl
```

Y podríamos continuar con el resto de nuestro código:

```PERL
#!/usr/bin/perl

use strict;
use warnings;

print "Hola, esto es Perl!\n";

```
