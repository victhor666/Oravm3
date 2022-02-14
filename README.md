Este desarrollo desplegará una máquina con oracle en diferentes clouds.
Empezamos con azure y aws y luego lo iremos extendiendo.
Los pasos a seguir son los siguientes:

1.- Descargar este repositorio en una ruta de un servidor linux cualquiera
2.- Esto creará una carpeta Oravm3, entrar en ella. Aqui se encuentra este fichero readme
3.- Debes crear una clave ssh con la que acceder a la máquina que se cree. 
    # Creamos la cuenta ssh 
    # ssh-keygen -P "" -C "Usuario para Maquina Oracle" -t rsa -b 2048 -m pem -f ~/Oravm3/orauser 
    # eso crea la cuenta orauser (privada) y orauser.pub (publica)
4.1-Si vamos a configurar 