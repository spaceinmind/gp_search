#!/bin/bash -f

set -euo pipefail

#####################################
# CONFIGURATION - MODIFY AS NEEDED  #
#####################################

WORKDIR="/fred/oz002/users/sho/J1823-3021A/test2"
DM=86.8909
ZAP_RANGES=("651 671" "736 782" "901 920" "934 938" "955 966" "1010 1023")
XPROF_BIN="${MATTHEW:-/path/to/xprof}"   # Set $MATTHEW env var or override here
XPROF_OUTPUT="xprof_output.txt"

#####################################
# BEGIN PROCESSING                  #
#####################################

cd "$WORKDIR"
echo "Start giant pulses search! Go Giants!"

echo "Step 1: pscrunch and apply DM ($DM)"
for ar_file in pulse*.ar; do
    p_file="${ar_file%.ar}.p"
    if [ ! -e "$p_file" ]; then
        pam -e p -p -d "$DM" -m "$ar_file"
        echo "Processed $ar_file → $p_file"
    else
        echo "Skipped $ar_file (already processed)"
    fi
done

echo "Step 2: Zapping RFI"
for p_file in pulse*.p; do
    zapp_file="${p_file%.p}.zapp"
    if [ ! -e "$zapp_file" ]; then
        zap_args=()
        for range in "${ZAP_RANGES[@]}"; do
            zap_args+=("-Z" "$range")
        done
        paz "${zap_args[@]}" "$p_file" -e zapp
        echo "Zapped $p_file → $zapp_file"
    else
        echo "Skipped $p_file (already zapped)"
    fi
done

echo "Step 3: Cleaning old xprof output"
rm -f "$XPROF_OUTPUT" xprof.stats xprof.stats.test

echo "Step 4: Running xprof in chunks"
zapped_files=(pulse*.zapp)
chunk_size=10
total=${#zapped_files[@]}
num_chunks=$(( (total + chunk_size - 1) / chunk_size ))

for (( chunk = 0; chunk < num_chunks; chunk++ )); do
    start=$((chunk * chunk_size))
    chunk_files=("${zapped_files[@]:$start:$chunk_size}")
    
    cmd="$XPROF_BIN/xprof -g /null -O 0,0.1 -w 0.001,0.03,1 -D 0 -f8 ${chunk_files[*]}"
    
    echo "Running chunk $((chunk + 1))/$num_chunks" >> "$XPROF_OUTPUT"
    echo "$cmd" >> "$XPROF_OUTPUT"
    eval "$cmd" >> "$XPROF_OUTPUT" 2>&1
    echo "Finished chunk $((chunk + 1))/$num_chunks" >> "$XPROF_OUTPUT"
done

echo "Step 5: Extracting and formatting xprof results"
python get-xprof-filenames.py | awk '{print $2, $4, $6, $8, $10}' > xprof.stats
awk -F'.raw' '{print $1, $2}' xprof.stats > xprof.stats.test
cp xprof.stats.test xprof.stats

echo "All done!"
