import logging
import requests
import json
from datetime import datetime

# Configurar el logger
logger = logging.getLogger(__name__)
logger.setLevel(logging.DEBUG)

# Configurar el formateador para enviar logs al servidor
class CustomFormatter(logging.Formatter):
    def format(self, record):
        # Crear la entrada de log en formato JSON
        log_entry = {
            'severity': record.levelname,
            'datetime': datetime.now().isoformat(),
            'progname': record.filename,
            'message': record.getMessage()
        }

        # Enviar el log al servidor
        url = 'http://localhost:4567/log'
        headers = {'Content-Type': 'application/json', 'API_KEY': 'kerberos'}
        response = requests.post(url, headers=headers, data=json.dumps(log_entry))

        # Retornar el log para la salida estándar(consola o terminal)
        return f"{log_entry['datetime']} {log_entry['progname']} {log_entry['severity']}: {log_entry['message']}"

# Crear un manejador de logs que envíe los logs a la salida estándar (consola)
console_handler = logging.StreamHandler()
console_handler.setFormatter(CustomFormatter())

# Agregar el manejador al logger
logger.addHandler(console_handler)

# Usar el logger para registrar mensajes
logger.debug("Este es un mensaje de DEBUG")
logger.info("Este es un mensaje de INFO")
logger.warn("Este es un mensaje de WARN")
logger.error("Este es un mensaje de ERROR")
logger.critical("Este es un mensaje de CRITICAL")
