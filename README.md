# 🍑 Giant pulse search
This repository contains a bash script and supporting tools for processing and analyzing radio pulsar data to identify giant pulses. The pipeline performs the following steps:  

1. **DM correction and pscrunching** using `pam`
2. **RFI zapping** using `paz`
3. **Pulse properties estimation** e.g., S/N, width using `xprof`
4. **Output formatting** for further analysis

---

## Dependencies

Make sure the following software is installed and available in your environment:

- [**PSRCHIVE**](http://psrchive.sourceforge.net/) (`pam`, `paz`)
- `bash`, `awk`, `find`
- `python` (used for the final result extraction)
- `xprof` (a custom pulse profile scoring tool, can be replaced by `psrstat` or `pdmp`)

## Usage
Before running the pipeline, you'll need `.ar` files created with dspsr   

```bash
dspsr -K -s -E <your_pulsar_par.par> <your_dada.dada>
```

Make sure `get-xprof-filenames.py` is in the same directory  

```bash
bash run_giant_pulse_search.sh
```
## Example Data Layout

```csv
pulse_80930723977.zapp 6 5.454247 -0.045275 983
pulse_80930723978.zapp 20 5.727708 0.013087 151
pulse_80930723979.zapp 4 5.098361 -0.064022 412
pulse_80930723980.zapp 3 5.506632 0.008135 284
pulse_80930723981.zapp 20 5.256887 0.054118 914
pulse_80930723982.zapp 28 5.630466 0.042092 960
pulse_80930723983.zapp 9 5.652157 0.055533 589
```

The colums of the `xprof.stats` are:  

1. filename
2. Pulse width (in bin number)
3. Detection SNR
4. Difference in dispersion measure trial
5. Starting bin


## Citation
Please cite [Ho et al. 2025, MNRAS](https://academic.oup.com/mnras/advance-article/doi/10.1093/mnras/staf995/8168211?utm_source=advanceaccess&utm_campaign=mnras&utm_medium=email&login=false), PSRCHIVE ([van Straten et al. 2012](https://ui.adsabs.harvard.edu/abs/2012AR%26T....9..237V/abstract)) and dspsr ([van Straten & Bailes 2013](https://www.cambridge.org/core/journals/publications-of-the-astronomical-society-of-australia/article/dspsr-digital-signal-processing-software-for-pulsar-astronomy/187B3FC44A3610F092A337FF6A7CB0A6)) if you use the pipeline in your paper.
