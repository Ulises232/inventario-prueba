# Inventario

La aplicación se desarrolló en IntelliJ IDEA con Java 21 y Spring Boot Utiliza MySQL Server 8.4.13.

## Cómo ejecutar la aplicación

1. Con el JDK 21 y Maven instalados, abre en IntelliJ IDEA la carpeta que contiene `pom.xml`.
2. En MySQL (`localhost:3306`), crea la base de datos y sus tablas ejecutando [SCRIPTS/init.sql](SCRIPTS/init.sql).
3. Desde la raíz del proyecto, ejecuta estos comandos en PowerShell con tus credenciales de MySQL.

   ```powershell
   $env:DB_USER = 'tu_usuario'
   $env:DB_PASSWORD = 'tu_contraseña'
   mvn spring-boot:run
   ```

4. Abre la [pantalla de inicio de sesión](http://localhost:8080/login).
