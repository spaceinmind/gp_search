# Giant pulse search
This repository contains a bash script and supporting tools for processing and analyzing radio pulsar data to identify giant pulses. The pipeline performs the following steps:  

1. **DM correction and pscrunching** using `pam`
2. **RFI zapping** using `paz`
3. **Pulse properties estimation e.g., S/N, width** using `xprof`
4. **Output formatting** for further analysis

---

## Dependencies

Make sure the following software is installed and available in your environment:

- [**PSRCHIVE**](http://psrchive.sourceforge.net/) (`pam`, `paz`)
- `bash`, `awk`, `find`
- `python` (used for the final result extraction)
- `xprof` (a custom pulse profile scoring tool, can be replaced by psrstat or pdmp)

## Example Data Layout

Place your `.ar` files in a working directory (e.g., `test2/`) with the following naming scheme:

## Citation
Please cite [Ho et al. 2025, MNRAS](https://academic.oup.com/mnras/advance-article/doi/10.1093/mnras/staf995/8168211?utm_source=advanceaccess&utm_campaign=mnras&utm_medium=email&login=false) if you use the pipline in your paper.
