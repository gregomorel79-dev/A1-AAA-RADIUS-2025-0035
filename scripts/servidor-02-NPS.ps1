# ===== NPS / RADIUS (PowerShell como Administrador) =====
Install-WindowsFeature NPAS -IncludeAllSubFeature -IncludeManagementTools
netsh nps add registeredserver
netsh nps add client name="R1"  address="10.20.35.1" state="enable" sharedsecret="Radius2025Lab"
netsh nps add client name="SW1" address="10.20.35.2" state="enable" sharedsecret="Radius2025Lab"

# Directivas de red (se crean en la consola nps.msc > Directivas > Directivas de red):
#  Nombre   Condicion (Grupos de Windows)   Autenticacion  Atributos
#  Nivel5   LAB20250035\Nivel5              PAP/SPAP       Service-Type=Login ; Cisco-AV-Pair = shell:priv-lvl=5
#  Nivel10  LAB20250035\Nivel10             PAP/SPAP       Service-Type=Login ; Cisco-AV-Pair = shell:priv-lvl=10
#  Nivel0   LAB20250035\Nivel0              PAP/SPAP       Service-Type=Login ; Cisco-AV-Pair = shell:priv-lvl=0
#  (las 2 directivas por defecto de NPS quedan deshabilitadas)
