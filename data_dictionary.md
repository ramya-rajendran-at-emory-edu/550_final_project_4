# 📘 Data Dictionary  
**Dataset:** AH Provisional Cancer Death Counts by Month and Year, 2020–2021  
**Source:** [CDC NCHS](https://data.cdc.gov/NCHS/AH-Provisional-Cancer-Death-Counts-by-Month-and-Ye/2na8-fe6s/about_data)

---

## 🧾 General Information Variables

| Variable Name            | Description                                               | Data Type          |
|:-------------------------|:----------------------------------------------------------|:-------------------|
| Data As Of               | Date the dataset was generated or last updated.           | Floating Timestamp |
| Start Date               | First date of data reporting period.                      | Floating Timestamp |
| End Date                 | Last date of data reporting period.                       | Floating Timestamp |
| Country                  | Jurisdiction of occurrence (U.S. states and territories). | Text               |
| Year                     | Year of death occurrence.                                 | Number             |
| Month                    | Month of death occurrence.                                | Number             |
| Sex                      | Biological sex of the decedent.                           | Text               |
| Age Group                | Age category of the decedent.                             | Text               |
| Race and Hispanic Origin | Combined race/ethnicity classification.                   | Text               |

---

## 🧬 Cancer-Specific Cause of Death Variables

| Variable Name                                                     | Description                                       | ICD Code(s)                               | Data Type   |
|:------------------------------------------------------------------|:--------------------------------------------------|:------------------------------------------|:------------|
| Malignant neoplasms (C00–C97)                                     | Total cancer deaths (all sites).                  | C00–C97                                   | Number      |
| Malignant neoplasms of lip, oral cavity and pharynx               | Cancers of mouth/throat.                          | C00–C14                                   | Number      |
| Malignant neoplasm of esophagus                                   | Cancer of the esophagus.                          | C15                                       | Number      |
| Malignant neoplasm of stomach                                     | Stomach cancer.                                   | C16                                       | Number      |
| Malignant neoplasms of colon, rectum and anus                     | Colorectal cancer.                                | C18–C21                                   | Number      |
| Malignant neoplasms of liver and intrahepatic bile ducts          | Liver cancer.                                     | C22                                       | Number      |
| Malignant neoplasm of pancreas                                    | Pancreatic cancer.                                | C25                                       | Number      |
| Malignant neoplasm of larynx                                      | Laryngeal cancer.                                 | C32                                       | Number      |
| Malignant neoplasms of trachea, bronchus and lung                 | Lung cancer.                                      | C33–C34                                   | Number      |
| Malignant melanoma of skin                                        | Skin cancer.                                      | C43                                       | Number      |
| Malignant neoplasm of breast                                      | Breast cancer.                                    | C50                                       | Number      |
| Malignant neoplasm of cervix uteri                                | Cervical cancer.                                  | C53                                       | Number      |
| Malignant neoplasms of corpus uteri and uterus, part unspecified  | Uterine cancers (other/unspecified).              | C54–C55                                   | Number      |
| Malignant neoplasm of ovary                                       | Ovarian cancer.                                   | C56                                       | Number      |
| Malignant neoplasm of prostate                                    | Prostate cancer.                                  | C61                                       | Number      |
| Malignant neoplasms of kidney and renal pelvis                    | Kidney cancers.                                   | C64–C65                                   | Number      |
| Malignant neoplasm of bladder                                     | Bladder cancer.                                   | C67                                       | Number      |
| Malignant neoplasms of meninges, brain and other parts of CNS     | Brain/CNS cancers.                                | C70–C72                                   | Number      |
| Malignant neoplasms of lymphoid, hematopoietic and related tissue | Blood-related cancers (e.g., lymphoma, leukemia). | C81–C96                                   | Number      |
| All other and unspecified malignant neoplasms                     | All other cancers not listed individually.        | Multiple (e.g., C17, C23–C24, C26–C31...) | Number      |

---

## Notes
- **Suppressed Values**: Death counts between 1–9 are often suppressed for privacy protection.
- **Data Status**: Data are provisional and may change as more death certificates are processed.
- **Source**: National Center for Health Statistics (NCHS), CDC.
