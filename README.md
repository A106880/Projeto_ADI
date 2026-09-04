# Energy Consumption Analysis with KNIME — Intelligent Learning and Decision-Making (ADI)

**Final grade: 18/20** · University of Minho, School of Engineering · BSc in Informatics Engineering · 2025/2026

> Practical assignment for the course *Aprendizagem e Decisão Inteligentes* — applying classification, regression, and clustering techniques to two electricity-consumption datasets, fully implemented in the **KNIME Analytics Platform** following the **CRISP-DM** methodology.

**Group 23**
- Samuel Gibson da Cunha Figueiredo Lobato — A106907
- Afonso Dinis Cerqueira Carpinteiro — A106909
- Afonso Miguel Carvalho de Jesus Quartas — A106880
- Bruno Daniel Lima Carvalho — A106809

---

## Table of Contents

- [Overview](#overview)
- [Workflow Architecture](#workflow-architecture)
- [Datasets Description](#datasets-description)
- [Key Results](#key-results)
- [Repository Structure](#repository-structure)
- [Extracting Split Workflow](#extracting-split-workflow)
- [Running the Workflow](#running-the-workflow)
- [Tools & Technologies](#tools--technologies)

---

## Overview

This repository contains the practical assignment for **Aprendizagem e Decisão Inteligentes** at the University of Minho. The project applies the **CRISP-DM** methodology to two complementary problems centered on electricity consumption across two scales:

1. **National Electricity Consumption (Assigned)** — hourly, national-level electricity consumption in Portugal combined with weather data, evaluated for **multiclass classification**.
2. **Individual Household Electric Power Consumption (Chosen)** — UCI dataset recorded minute-by-minute in a single home in Sceaux, France, analyzed for **classification, regression, and clustering**.

The entire pipeline (data ingestion, cleaning, feature engineering, exploratory analysis, model training, cross-validation, and evaluation) was developed end-to-end inside KNIME with zero manual preprocessing. The complete theoretical framing, methodology, and exhaustive metric tables are documented in the [project report](Relatorio_ADI_Grupo23.pdf) (written in Portuguese). The project was awarded a final grade of **18/20**.

---

## Workflow Architecture

The project features an automated, modular pipeline designed to be reusable rather than a one-off execution:

* **Macro-Components:**
  * **Load Data:** Ingestion of raw tabular data.
  * **Data Visualization, Treatment & Exploration:** Automates type conversion (`String to Number`), missing value handling via Machine Learning regressors (Gradient Boosted Trees), outlier detection, feature engineering (temporal binning, sub-metering decomposition), and exploratory statistics.
  * **Model Training:** Houses 17 supervised models (10 classifiers, 7 regressors adapted to classification) and a k-Medoids clustering module, routed dynamically via `CASE Switch` branches.
* **Interactive Data App:** The workflow exposes interactive widgets allowing the user to select the ML task, the algorithm, and the validation strategy (10-fold Cross-Validation vs. Hold-out Split) without modifying the underlying nodes.

---

## Datasets Description

### 1. National Electricity Consumption (Assigned)
Contains 8,736 hourly observations (2024–2026) combining consumption by voltage tier (Very High, High, Medium, Low) with weather parameters (temperature, humidity, precipitation, solar radiation, wind), labelled into five consumption classes (*Low* to *High Consumption*). Missing voltage entries were imputed using a **Gradient Boosted Trees regressor** ($R^2 = 0.876$).

### 2. Individual Household Electric Power Consumption (Chosen)
Over 2 million one-minute readings from a home in Sceaux, France (Dec 2006 – Nov 2010), downsampled to a 20,752-row stratified dataset. Validated against **Ohm's Law** ($P = V \times I$), demonstrating that active power is physically proportional to current intensity. A dedicated feature (`Sub_metering_other`) was engineered to capture unmonitored residual energy consumption.

---

## Key Results

### Classification — Best Models (10-fold Cross-Validation)

| Dataset | Best Model | Accuracy | Cohen's κ |
|---|---|---|---|
| National Consumption | KNN (auto-tuned *K*) | **95.67%** | 0.9458 |
| National Consumption | H2O GBM | 95.34% | 0.9417 |
| Household Consumption | Random Forest | **95.23%** | 0.9403 |
| Household Consumption | Tree Ensemble | 95.17% | 0.9396 |

### Regression — Household Dataset (Ablation Study)

| Predictors | Best Model | $R^2$ |
|---|---|---|
| With `Global_intensity` (Trivial: $P = V \times I$) | Linear Regression | 0.9984 |
| **Without** `Global_intensity` (Realistic scenario) | Random Forest | **0.8472** |

### Clustering (k-Medoids, Silhouette-Optimized)

| Dataset | Optimal *k* | Accuracy vs. 5 Real Classes |
|---|---|---|
| National Consumption | 2 | 30.69% |
| Household Consumption | 3 | 34.97% |

*Refer to [Relatorio_ADI_Grupo23.pdf](Relatorio_ADI_Grupo23.pdf) for confusion matrices, hyperparameter settings, and full benchmark tables.*

## Repository Structure

```
.
├── README.md
├── Relatorio_ADI_Grupo23.pdf
├── assigned_dataset/
│   ├── dataset/
│   │   ├── consumption_dataset.csv
│   │   └── consumption_explanation.txt
│   └── workflow/
│       ├── Consumption.knwf
│       └── Consumption.zip
└── chosen_dataset/
  ├── dataset/
  │   ├── dataset_url.txt
  │   ├── household_power_consumption.txt
  │   └── household_power_consumption.zip
  └── workflow/
    ├── LowConsumption.knwf
    ├── LowConsumption.zip
    └── LowConsumption.z01
```

## Extracting Split Workflow

### KNIME Workflow — LowConsumption (`LowConsumption.knwf`)

To use this workflow, merge and extract the split archive files (`.zip` and `.z01`) by running:

```bash
cd chosen_dataset/workflow
zip -F LowConsumption.zip --out merged_low.zip
unzip merged_low.zip
rm merged_low.zip
cd ../..
```

For the single archive files, extract them with:

```bash
cd assigned_dataset/workflow
unzip Consumption.zip
cd ../../chosen_dataset/dataset
unzip household_power_consumption.zip
cd ../..
```

## Running the Workflow

1. Install [KNIME Analytics Platform](https://www.knime.com/downloads).
2. Follow the extraction step above.
3. In KNIME: `File → Import KNIME Workflow…` and select the `.knwf` file from `assigned_dataset/workflow/` or `chosen_dataset/workflow/`.
4. Open the workflow's interactive Data App view to configure and execute tasks.

## Tools & Technologies

- **KNIME Analytics Platform** — Data ETL, pipeline orchestration & Data App UI
- **H2O Driverless/GBM** — Gradient Boosting implementation
- **Keras / TensorFlow** — Deep Learning KNIME integration
- **CRISP-DM** — Data science development lifecycle
- **Models Evaluated:** Decision Tree, Tree Ensemble, Random Forest, H2O GBM, KNN, Naive Bayes, MLP, PNN, Linear Regression, GBT Regression, Keras DNN, k-Medoids.
