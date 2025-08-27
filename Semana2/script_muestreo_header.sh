#!/usr/bin/env bash
set -euo pipefail

INPUT="${1:-Covid19.csv}"   # CSV de entrada
SUBFOLDERS=10
N_LINES=300               # número de líneas de datos por archivo (sin contar cabecera)
OUTDIR="BaseDatos"

mkdir -p "$OUTDIR"

# Extraer cabecera
header=$(head -n 1 "$INPUT")

# Guardar el resto de los datos en un temporal
DATA_TMP=$(mktemp)
tail -n +2 "$INPUT" > "$DATA_TMP"

# Verifica que haya suficientes líneas de datos
total_lines=$(wc -l < "$DATA_TMP")
if (( total_lines < N_LINES )); then
  echo "ERROR: $INPUT tiene solo $total_lines filas de datos y se requieren $N_LINES." >&2
  rm -f "$DATA_TMP"
  exit 1
fi

# Crear subcarpetas con muestras
for j in $(seq 1 "$SUBFOLDERS"); do
  subdir="$OUTDIR/Proceso_Header_$j"
  mkdir -p "$subdir"

  echo "Creando $subdir"

  out="$subdir/muestra.csv"
  {
    echo "$header"
    shuf -n "$N_LINES" "$DATA_TMP"
  } > "$out"
done

rm -f "$DATA_TMP"

echo "OK: creadas $SUBFOLDERS subcarpetas en '$OUTDIR', cada una con cabecera + $N_LINES filas."

