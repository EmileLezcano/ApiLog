require 'sinatra'
require 'json'
require 'active_record' 
require 'pg'

# Al ejecutar sinatra el servidor WEBrick está listo para recibir y manejar solicitudes HTTP en http://localhost:4567

#---------- Conexión BD ----------

# Configurar la conexión a la base de datos PostgreSQL  
ActiveRecord::Base.establish_connection(
  adapter:  'postgresql',
  host:     'localhost', # 'localhost' indica que la base de datos PostgreSQL está alojada en la misma máquina que la aplicación Ruby.
  username: 'coloca tú usuario de postgresql',
  password: 'coloca tú contraseña de postgresql',
  database: 'db_logs' 
)

# Definir el modelo para la tabla 'logs' que se encuentra en db_logs
class Log < ActiveRecord::Base
    self.table_name = 'logs'
end

#---------- API KEY ----------

API_KEY = 'kerberos' # clave que deben tener los servicios autorizados para enviar sus datos al servidor

# Filtro para verificar la API key
before do 
    api_key = request.env["HTTP_API_KEY"]
    halt 401, { error: "Unauthorized"}.to_json unless api_key == API_KEY
end

#---------- API ----------

# Ruta que recibe datos a través de POST
post '/log' do
    # Recibir datos en formato JSON
    log_data = JSON.parse(request.body.read)
  
    # Crear un nuevo registro en la tabla logs
    log = Log.new(log_data)
  
    if log.save
      # Si se crea correctamente, devolver un mensaje de éxito
      status 201
      "Log saved: #{log.to_json}"
    else
      status 422
      "Error saving log: #{log.errors.full_messages.to_json}"
    end
  end
  
  # Ruta para obtener todos los registros (desabilitando API KEY)
  # Abre tu navegador y visita: http://localhost:4567/logs.
  get '/logs' do
    logs = Log.all
    logs.to_json
  end

