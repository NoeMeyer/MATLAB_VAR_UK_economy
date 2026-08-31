# UK Monetary Policy: SVAR & New Keynesian Analysis

Estimating the effect of an interest-rate shock on UK output, inflation, and unemployment — measured empirically from 50 years of data and benchmarked against a theoretical model.

**Author:** Noé Meyer — Quantitative Macroeconomics, HEC Lausanne (BSc Economics)
**Stack:** MATLAB · Dynare · Structural VAR · New Keynesian (DSGE) modelling

## Overview

The project quantifies how a surprise change in the Bank of England's policy rate propagates through the UK economy, using two complementary approaches:

- **Part 1 : Empirical.** A Structural VAR (SVAR) estimated on UK quarterly data (1975-2025) for output, inflation, unemployment, and the Bank Rate. The monetary policy shock is identified with a recursive (Cholesky) ordering, and its effects are traced through impulse-response functions, forecast-error-variance decompositions, and historical decompositions.
- **Part 2 : Theoretical.** A three-equation New Keynesian DSGE model (IS curve, Phillips curve, Taylor rule) built and solved in Dynare, producing the model-implied response to an interest-rate shock as a benchmark for the empirical estimates.

## Methodology

- Assembled and transformed UK quarterly macro data: log-levels, a one-sided HP filter for the output and unemployment gaps, and log-differencing for inflation.
- Estimated a 4-variable reduced-form VAR (4 lags) and recovered structural shocks via Cholesky identification, with the policy rate ordered last (standard recursive monetary-policy identification).
- Computed impulse responses over a 24-quarter horizon with 66% bootstrap confidence bands.
- Calibrated and solved the New Keynesian model in Dynare, then compared its impulse responses to the empirical ones.

## Results

A contractionary interest-rate shock produces the responses standard theory predicts:

- **Output** declines, reaching its trough roughly 1-2 years after the shock, then recovers.
- **Unemployment** rises, peaking around 2 years out — a clear lagged labour-market response.
- **Inflation** eases over the medium term (after a small short-run "price puzzle").
- Effects dissipate within about 4-6 years as the economy returns to trend.

The New Keynesian model reproduces the same qualitative dynamics (output and inflation both fall after a rate rise), confirming the empirical results align with mainstream theory.

![Estimated impulse responses of the UK economy. The bottom row is the interest-rate (Bank Rate) shock: output dips, unemployment rises to a peak near two years, and inflation cools. Dashed lines are 66% confidence bands.](Quant_Macro_Assignment_No%C3%A9_Meyer/Results/MyImpulseResponse.png)

*Columns are variables (GDP, inflation, unemployment, Bank Rate); rows are shocks. The bottom row — the interest-rate shock — is the focus of the study.*

## Tech & skills

Structural VAR estimation · shock identification (Cholesky) · impulse-response / FEVD / historical decomposition · New Keynesian DSGE modelling in Dynare · macro data processing (detrending, HP filtering, stationarity) · MATLAB.

## Repository structure

```
Quant_Macro_Assignment/
├── Code/
│   ├── Part_1/   Empirical SVAR — main script GO_SW.m + input data
│   ├── Part_2/   New Keynesian model — NK_model.mod (Dynare)
│   └── VAR/ Stats/ Utils/ ...   Supporting econometrics routines
└── Results/      Output figures (impulse responses, etc.)
```

## Data

UK quarterly series, 1975Q1-2025Q2 (`Code/Part_1/CombinedData.xlsx`):

| Variable | Source |
|---|---|
| Output (GDP) | Office for National Statistics (2025) |
| Inflation (GDP deflator) | Office for National Statistics (2025) |
| Unemployment rate | Office for National Statistics (2025) |
| Nominal interest rate (Bank Rate) | Bank of England Database (2025) |

## Running it

Empirical VAR (MATLAB) — open `Code/Part_1` and run:
```matlab
GO_SW
```

New Keynesian model (Dynare) — from `Code/Part_2/Dynare_Files` run:
```matlab
dynare NK_model.mod
```

## Credits

VAR estimation and plotting routines build on a modified version of the **VAR Toolbox** by Ambrogio Cesa-Bianchi (BSD-licensed). All project-specific modelling and analysis code is by Noé Meyer.
