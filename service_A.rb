require 'logger' # para generar mensajes de registro: Utiliza métodos como info, warn, error etc.
require 'net/http' # para enviar solicitudes HTTP (GET, POST, PUT, DELETE, etc.) y manejar las respuestas.
require 'json' # para convertir datos a y desde JSON

# Configurar el logger
logger = Logger.new(STDOUT) # crea una nueva instancia de la clase Logger y la configura para que envíe los mensajes de registro a la salida estándar (la consola o terminal).
logger.level = Logger::DEBUG # nivel de registro (DEBUG, INFO, WARN, ERROR, etc)
logger.progname = File.basename(__FILE__) # tomara el nombre del archibo en el que se eta ejecutando

# configuramos informacion que queremos muestren los logs y los enviamos al servidor
logger.formatter = proc do |severity, datetime, progname, msg|
    log_entry = {
        severity: severity,
        datetime: datetime,
        progname: progname,
        message: msg
    }.to_json #to_json: Convierte un objeto Ruby a una cadena JSON.

    # Enviar el log al servidor 
    uri = URI('http://localhost:4567/log') # Crea una URI con la dirección del servidor
    http = Net::HTTP.new(uri.host, uri.port) # Crea una nueva instancia de HTTP utilizando la URI
    request = Net::HTTP::Post.new(uri.path, 'Content-Type' => 'application/json') # Crear una solicitud HTTP de tipo POST con la ruta de la URI y el tipo de contenido como JSON
    request.body = log_entry # Establece el cuerpo de la solicitud HTTP como la cadena JSON

    request['API_KEY'] = "kerberos"  # Añadir la API Key en la cabecera

    response = http.request(request)

    # Retornar el log para la salida estandar(para que se muestren en la terminal)
    "#{datetime} #{progname} #{severity}: #{msg}\n"
end
puts "Logs enviados a la base de datos:"
logger.debug("Este es un mensaje de DEBUG")
logger.info("Este es un mensaje de INFO")
logger.warn("Este es un mensaje de WARN")
logger.error("Este es un mensaje de ERROR")
logger.fatal("Este es un mensaje de FATAL")