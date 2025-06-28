from flask import Flask, jsonify
import psutil
from prometheus_client import Counter, Gauge, generate_latest, CONTENT_TYPE_LATEST

app = Flask(__name__)

cpt_requetes = Counter('app_requetes_total', 'Nombre total de requêtes HTTP')
jauge_cpu = Gauge('app_cpu_pourcent', 'Utilisation CPU')
jauge_ram = Gauge('app_ram_pourcent', 'Utilisation RAM')

@app.route('/')
def accueil():
    cpt_requetes.inc()
    return "Hello, DevOps!"

@app.route('/health')
def sante():
    cpu = psutil.cpu_percent()
    ram = psutil.virtual_memory().percent
    jauge_cpu.set(cpu)
    jauge_ram.set(ram)
    return jsonify(statut="ok", cpu_pourcent=cpu, ram_pourcent=ram)

@app.route('/metrics')
def metriques():
    return generate_latest(), 200, {'Content-Type': CONTENT_TYPE_LATEST}

if __name__ == '__main__':
    app.run(host='0.0.0.0')