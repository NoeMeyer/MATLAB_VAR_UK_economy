# Monetary Policy Shocks and the UK Economy — VAR & New Keynesian Analysis

Quantitative Macroeconomics assignment (HEC Lausanne, BSc in Economics, 3rd year).
It estimates the impact of an interest-rate (monetary policy) shock on **output,
inflation and unemployment** in the United Kingdom and compares the empirical
evidence with the predictions of a small New Keynesian model.

**Part 1 — Empirical (SVAR).** A structural VAR is estimated on UK quarterly data to
simulate the impulse responses of UK macroeconomic series, using a modified version
of Ambrogio Cesa-Bianchi's VAR Toolbox. A monetary policy shock is identified with a
recursive (Cholesky) ordering in which the policy rate is ordered last, and impulse
responses, forecast-error-variance decompositions and historical decompositions are
computed.

**Part 2 — Theoretical (New Keynesian model).** A standard three-equation New
Keynesian model (dynamic IS curve, New Keynesian Phillips curve, Taylor rule) is
solved and simulated in Dynare to obtain the theoretical impulse responses to an
interest-rate shock, which are then contrasted with the empirical VAR responses.

## Data

`Code/Part_1/CombinedData.xlsx` (sheet `Feuil1`), UK quarterly series 1975Q1–2025Q2:

| Column | Series | Source | Transformation used in the VAR |
|---|---|---|---|
| GDP | Real output | Office for National Statistics (2025) | log, then one-sided HP filter (lambda = 1600), x100 |
| Deflator | GDP deflator (price index) | Office for National Statistics (2025) | 400 x first difference of logs -> annualised inflation |
| Unemployment | Unemployment rate (%) | Office for National Statistics (2025) | log, then one-sided HP filter (lambda = 1600), x100 |
| Interest Rate | Nominal Bank Rate (%) | Bank of England Database (2025) | none (level) |

## Repository layout

```
Quant_Macro_Assignment/
├── Code/
│   ├── Part_1/                     Empirical VAR
│   │   ├── GO_SW.m                 Main script: 4-variable VAR + monetary policy IRFs
│   │   ├── GO_BQ.m                 Blanchard–Quah long-run identification (variant)
│   │   ├── one_sided_hp_filter_serial.m   Real-time (one-sided) HP filter
│   │   └── CombinedData.xlsx       Input data
│   ├── Part_2/
│   │   └── Dynare_Files/
│   │       └── NK_model.mod        New Keynesian model (Dynare source)
│   ├── VAR/  Stats/  Utils/  Figure/  Auxiliary/  ExportFig/
│   │                               VAR Toolbox 2.0 (A. Cesa-Bianchi) + helpers
└── Results/                        Exported figures (IRFs, etc.)
```

## Requirements

- MATLAB (Statistics/Econometrics toolboxes; `hpfilter` is used when available,
  with a built-in fallback).
- [Dynare](https://www.dynare.org/) (tested with version 6.5) for Part 2.
- The bundled **VAR Toolbox 2.0** by Ambrogio Cesa-Bianchi
  (https://sites.google.com/site/ambropo/MatlabCodes) — a modified version is
  included under `Code/`.

## How to run

**Part 1 (VAR):** open MATLAB in `Code/Part_1`, then run
```matlab
GO_SW      % main monetary-policy VAR and impulse responses
```

**Part 2 (New Keynesian model):** from the Dynare folder run
```matlab
dynare NK_model.mod
```
which produces the theoretical impulse responses to the `e_u` (interest-rate) and
`e_r` (natural-rate) shocks.

## Data sources

- Output, inflation (GDP deflator) and unemployment: Office for National Statistics (2025).
- Nominal interest rate (Bank Rate): Bank of England Database (2025).

## Credits

VAR estimation, identification and plotting routines are from the **VAR Toolbox 2.0**
by Ambrogio Cesa-Bianchi (BSD-licensed), included here (modified) for reproducibility.
All project-specific code (`GO_SW.m`, `GO_BQ.m`, `one_sided_hp_filter_serial.m`,
`NK_model.mod`) is by Noé Meyer.
