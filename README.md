#DESPLIEGUE DE SERVIDOR ORACLE

###Este desarrollo desplegará una máquina con oracle en diferentes clouds.
Empezamos con azure y aws y luego lo iremos extendiendo.

##### Los pasos a seguir son los siguientes:

1. Descargar este repositorio en una ruta de un servidor linux cualquiera
2. Esto creará una carpeta Oravm3, entrar en ella. Aqui se encuentra este fichero readme
3. Debes crear una clave ssh con la que acceder a la máquina que se cree. 
    > Creamos la cuenta ssh 
    > #ssh-keygen -P "" -C "Usuario para Maquina Oracle" -t rsa -b 2048 -m pem -f ~/Oravm3/orauser 
    > eso crea la cuenta orauser (privada) y orauser.pub (publica)

4. Si vamos a configurar aws recomendamos hacer el login del usuario con aws configure (en la máquina desde la que vayamos a desplegar) mejor que meter claves en el tfvars. 
5.- Si vamos a instalar la infra en azure tenemos dos opciones. La primera & recomendada es usar el cloudshell. Un usuario con permisos puede ejecutar desde ahi todo aquello para lo que tenga permisos. Además git y terraform ya están instalados por lo que no hay que hacer nada más que clonar el repo y seguir los pasos siguientes

4.1. Para desplegar en aws haremos lo siguiente
    > # cd setup-aws
    > modificamos el fichero tfvars poniendo las variables que queramos para nuestro entorno. Si no cambiamos nada, debería funcionar.
    > Ejecutamos # terraform init 
        que inicializa terraform
    > # Terraform plan 
        que nos mostrará lo que va a aprovisionar
    > # Terraform apply 
        que despliega la infra de forma efectiva (pide confirmación)

Luego podemos ir a la consola de aws en la region que hemos elegido y ver como los recursos han sido desplegados

5.1. Para desplegar en azure  haremos lo siguiente
    > Si no estamos en el cloudshell lo más sencillo es autenticar con [azure-cli] (https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
    > # cd setup-azure
    > modificamos el fichero tfvars poniendo las variables que queramos para nuestro entorno. Si no cambiamos nada, debería funcionar.
    > Ejecutamos # terraform init 
        que inicializa terraform
    > # Terraform plan 
        que nos mostrará lo que va a aprovisionar
    > # Terraform apply 
        que despliega la infra de forma efectiva (pide confirmación)  