#!/usr/bin/env bash
set -euo pipefail

INPUT="${1:-Covid19.csv}"   # CSV de entrada
SUBFOLDERS=10
N_LINES=300               # ¡NO usar LINES!
OUTDIR="BaseDatos"

mkdir -p "$OUTDIR"

# Verifica que el archivo tenga suficientes líneas
total_lines=$(wc -l < "$INPUT")
if (( total_lines < N_LINES )); then
  echo "ERROR: $INPUT tiene $total_lines líneas y se requieren $N_LINES." >&2
  exit 1
fi

for j in $(seq 1 "$SUBFOLDERS"); do
  subdir="$OUTDIR/Proceso_$j"
  echo "Creando $subdir"
  mkdir -p "$subdir"
  shuf -n "$N_LINES" "$INPUT" > "$subdir/muestra.csv"
done

echo "OK: creadas $SUBFOLDERS subcarpetas en '$OUTDIR', cada una con $N_LINES líneas."

