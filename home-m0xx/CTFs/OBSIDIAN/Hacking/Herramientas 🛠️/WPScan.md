----------
##### TAGS: #web #wordpress #reconocimiento #herramientas #terminal  

------
# CONCEPTO

> **WPScan** es una herramienta de código abierto diseñada para escanear y enumerar vulnerabilidades en sitios web que utilizan el sistema de gestión de contenidos (CMS) [[WordPress]], **WPScan** utiliza técnicas de enumeración y escaneo para encontrar información sobre versiones de WordPress, temas, plugins y usuarios, así como posibles vulnerabilidades que podrían ser explotadas por atacantes.

------------
## USO:
Para realizar un escaneo con esta herramienta podríamos ejecutar un comando de Bash con la siguiente estructura:

```BASH
wpscan --url https://google.com
```

Si lo que quisiéramos es enumerar los usuarios existentes en el [[WordPress]] como gestor de contenido de esta pagina, debemos agregar el parámetro _"--enumerate"_ y le indicamos el valor u para usuarios:

```BASH
wpscan --url https://google.com --enumerate u
```

Otra utilidad que tiene esta herramienta es la de aplicar fuerza bruta para descubrir credenciales validas basándonos en algún diccionario de contraseñas o usuarios para esto podemos usar el parámetro _"-U"_ para indicar el usuario al que le queremos realizar el ataque de fuerza bruta  y agregamos un segundo parámetro _"-P"_ para agregar el diccionario que contiene las posibles contraseñas que tenemos, en este caso usaremos el diccionario **rockyou.txt**
```BASH
wpscan --url https://google.com -U M0xX -P /usr/share/wordlists/rockyou.txt
```
#### Proyecto de GitHub:
- **GitHub by wpscanteam** [WPScan](https://github.com/wpscanteam/wpscan)