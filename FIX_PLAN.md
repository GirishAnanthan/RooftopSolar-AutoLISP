# RooftopSolar.lsp — Comprehensive Fix Plan

**Project**: Commercial AutoCAD AddOn for Rooftop Solar PV Design  
**Total Issues**: 173+ findings  
**Estimated Effort**: 120-160 hours  
**Strategy**: Incremental fixes with continuous testing and version control

---

## Executive Summary

This plan addresses all 173+ issues found in the audit through a **7-phase approach**:
1. **Backup & Infrastructure** — Git version control, automated testing
2. **Critical Fixes** — Electrical safety, crash prevention
3. **Major Fixes** — BOM accuracy, DCL management, standards compliance
4. **Minor Fixes** — Code quality, UX improvements
5. **Professional Deployment** — License, CUI, help system
6. **Testing & Validation** — Regression suite, standards compliance verification
7. **Documentation** — User guide, API docs, developer notes

---

## Phase 1: Backup & Infrastructure Setup

### 1.1 Git Repository Initialization
```bash
# Create git repo with proper .gitignore
cd D:/VibeCoding/AUTOLISP/Rooftop
git init
git add RooftopSolar.lsp RooftopSolar.dcl PVCompLib.lsp solarpro_equipment_db.lsp
git commit -m "Baseline: Pre-fix snapshot of RooftopSolar v2.5"
git tag v2.5.0-baseline
```

### 1.2 Backup Strategy
- **Before each phase**: Create git tag (e.g., `v2.5.1-pre-phase2`)
- **After each fix batch**: Commit with descriptive message
- **Daily backups**: Push to remote repository
- **File backups**: Keep `.bak` files for first 3 phases

### 1.3 Test Infrastructure
Create `tests/` folder with:
```
tests/
├── test_math_functions.lsp      # dtr, rtd, tan, asin, acos
├── test_solar_geometry.lsp      # solar position, shadow calc
├── test_electrical.lsp          # voltage, current, cable sizing
├── test_bom.lsp                 # clamp counts, leg counts
├── test_yield.lsp               # energy calculations
└── test_runner.lsp              # executes all tests
```

### 1.4 Module Structure (Target Architecture)
```
RooftopSolar/
├── RooftopSolar-Loader.lsp      # Main entry point
├── Core/
│   ├── RS-Core-Math.lsp         # Math helpers
│   ├── RS-Core-Geometry.lsp     # Polygon, bbox, convex hull
│   ├── RS-Core-Entity.lsp       # Entity handling
│   └── RS-Core-Layer.lsp        # Layer management
├── Solar/
│   ├── RS-Solar-Geometry.lsp    # Solar position, declination
│   ├── RS-Solar-Shadow.lsp      # Shadow envelopes
│   ├── RS-Solar-Yield.lsp       # Energy calculations
│   └── RS-Solar-Standards.lsp   # IEC/NEC compliance checks
├── Electrical/
│   ├── RS-Electrical-Stringing.lsp    # DC stringing
│   ├── RS-Electrical-Cable.lsp        # Cable sizing, Vdrop
│   ├── RS-Electrical-Inverter.lsp     # Inverter sizing
│   └── RS-Electrical-SLD.lsp          # Single line diagram
├── Layout/
│   ├── RS-Layout-Generator.lsp        # Module placement
│   ├── RS-Layout-Obstacles.lsp        # Obstacle handling
│   └── RS-Layout-Walkway.lsp          # Walkway routing
├── Structure/
│   ├── RS-Structure-MMS.lsp           # Mounting structure
│   ├── RS-Structure-Safety.lsp        # Fall safety, handrails
│   └── RS-Structure-3D.lsp            # 3D visualization
├── UI/
│   ├── RS-UI-Dialog.lsp               # DCL management
│   └── RS-UI-Commands.lsp             # Command definitions
├── Reports/
│   ├── RS-Reports-BOM.lsp             # Bill of materials
│   ├── RS-Reports-Energy.lsp          # Energy tables
│   └── RS-Reports-Export.lsp          # CSV, PVsyst export
├── Config/
│   ├── RS-Config-Global.lsp           # Global variables
│   ├── RS-Config-Preferences.lsp      # User preferences
│   └── RS-Config-License.lsp          # License management
├── Resources/
│   ├── RooftopSolar.dcl               # Dialog definition
│   ├── RooftopSolar.cui               # Ribbon/toolbar
│   └── RooftopSolar-Help.pdf          # User guide
└── tests/                             # Test suite
```

---

## Phase 2: Critical Fixes (Safety & Crashes)

**Estimated Time**: 30-40 hours  
**Priority**: Must complete before any deployment

### 2.1 Electrical Safety Fixes

#### Fix #1: String Voc Temperature Correction (Line 4102-4105)
**Current Code**:
```lisp
(setq voc-str (* (if (> *PV_STRING_SIZE* 0) *PV_STRING_SIZE* 20) *PV_PAN_VOC*))
```

**Fixed Code**:
```lisp
;; Temperature correction per NEC 690.7(A)
;; Voc_max = Voc_STC × [1 + (T_coeff_Voc/100) × (T_min - 25)]
;; T_min = minimum expected ambient temperature (°C)
;; Default: -10°C for most climates, user configurable
(defun pv:calc-voc-max (/ t-min t-coeff-voc voc-max)
  (setq t-min (if *PV_T_MIN_AMBIENT* *PV_T_MIN_AMBIENT* -10.0))  ; °C
  (setq t-coeff-voc *PV_PAN_TEMP_VOC*)  ; %/°C (e.g., -0.25)
  ;; Calculate max Voc at coldest temperature
  (setq voc-max (* *PV_PAN_VOC* 
                   (+ 1.0 (* (/ t-coeff-voc 100.0) (- t-min 25.0)))))
  voc-max
)

;; Use in string sizing
(setq voc-str (* (if (> *PV_STRING_SIZE* 0) *PV_STRING_SIZE* 20) 
                 (pv:calc-voc-max)))
```

**Testing**:
- Unit test: `test_voc_temp_correction.lsp`
- Test cases: -40°C, -10°C, 0°C, +10°C minimum temps
- Verify: Voc_max > Voc_STC for negative temps

---

#### Fix #2: Cable Sizing with Derating Factors (Line 3577-3596)
**Current Code**:
```lisp
(setq req-amp (* 1.25 isc-mod))
```

**Fixed Code**:
```lisp
;; Cable sizing per IEC 60364-5-52 and NEC 690.8(B)
;; I_cable = Isc × 1.25 × derating_factors
(defun pv:calc-cable-ampacity (/ isc-mod base-current temp-factor 
                                grouping-factor install-factor total-factor req-amp)
  (setq isc-mod *PV_PAN_ISC*)
  
  ;; Base current (NEC 690.8(A)(1))
  (setq base-current (* 1.25 isc-mod))
  
  ;; Temperature derating (IEC 60364-5-52 Table B.52.14)
  ;; Default: 45°C ambient, 70°C rated cable
  (setq temp-factor 
    (cond
      ((<= *PV_AMBIENT_TEMP* 30) 1.00)
      ((<= *PV_AMBIENT_TEMP* 35) 0.96)
      ((<= *PV_AMBIENT_TEMP* 40) 0.91)
      ((<= *PV_AMBIENT_TEMP* 45) 0.87)
      ((<= *PV_AMBIENT_TEMP* 50) 0.82)
      ((<= *PV_AMBIENT_TEMP* 55) 0.76)
      (t 0.71)  ; >55°C
    )
  )
  
  ;; Grouping factor (IEC 60364-5-52 Table B.52.17)
  ;; Single layer, touching: 0.80 for 4-6 cables
  (setq grouping-factor 
    (cond
      ((<= *PV_CABLES_IN_TRAY* 3) 1.00)
      ((<= *PV_CABLES_IN_TRAY* 6) 0.80)
      ((<= *PV_CABLES_IN_TRAY* 9) 0.70)
      (t 0.60)  ; >9 cables
    )
  )
  
  ;; Installation method factor (Table B.52.18)
  ;; Perforated tray = Method E, factor = 1.0
  (setq install-factor 1.0)
  
  ;; Total derating
  (setq total-factor (* temp-factor grouping-factor install-factor))
  
  ;; Required ampacity
  (setq req-amp (/ base-current total-factor))
  
  ;; Select cable size
  (cond
    ((<= req-amp 41)  "4 mm²")   ; 4mm² rated ~41A
    ((<= req-amp 53)  "6 mm²")   ; 6mm² rated ~53A
    ((<= req-amp 75)  "10 mm²")  ; 10mm² rated ~75A
    ((<= req-amp 100) "16 mm²")  ; 16mm² rated ~100A
    ((<= req-amp 126) "25 mm²")  ; 25mm² rated ~126A
    (t "35 mm²")                 ; 35mm² rated ~154A
  )
)
```

**New Global Variables**:
```lisp
*PV_T_MIN_AMBIENT*      -10.0   ; Minimum ambient temp (°C)
*PV_AMBIENT_TEMP*       45.0    ; Design ambient temp (°C)
*PV_CABLES_IN_TRAY*     4       ; Number of DC cables in tray
```

---

#### Fix #3: MPPT Voltage Window Validation (New Function)
**New Code**:
```lisp
(defun pv:validate-string-voltage (/ vmp-str voc-max voc-str vmp-ok voc-ok msg)
  ;; Calculate string voltages
  (setq vmp-str (* *PV_STRING_SIZE* *PV_PAN_VMP*))
  (setq voc-max (pv:calc-voc-max))
  (setq voc-str (* *PV_STRING_SIZE* voc-max))
  
  ;; Check against inverter limits
  (setq vmp-ok (and (>= vmp-str *PV_INV_VMPP_MIN*)
                    (<= vmp-str *PV_INV_VMPP_MAX*)))
  (setq voc-ok (<= voc-str *PV_INV_VDC_MAX*))
  
  ;; Generate warnings
  (if (not vmp-ok)
    (progn
      (setq msg (strcat "WARNING: String Vmp = " (rtos vmp-str 2 1) 
                        "V outside MPPT range [" (rtos *PV_INV_VMPP_MIN* 2 0)
                        "V - " (rtos *PV_INV_VMPP_MAX* 2 0) "V]"))
      (alert msg)
    )
  )
  
  (if (not voc-ok)
    (progn
      (setq msg (strcat "CRITICAL: String Voc_max = " (rtos voc-str 2 1)
                        "V exceeds inverter max " (rtos *PV_INV_VDC_MAX* 2 0) "V"))
      (alert msg)
      nil  ; Return nil to block string creation
    )
    t    ; Return t to allow string creation
  )
)
```

**Integration**: Call before creating strings in `c:pv-stringing`

---

#### Fix #4: Voltage Drop with Correct Resistivity (Line 2829)
**Current Code**:
```lisp
(setq v-drop (/ (* 2.0 avg-homerun *PV_PAN_IMP* 0.0185) 4.0))
```

**Fixed Code**:
```lisp
;; Voltage drop per IEC 60364-7-712
;; Vdrop = 2 × L × I × ρ / A
;; ρ = resistivity at operating temperature (Ω·mm²/m)
;; Copper at 20°C = 0.0175, at 70°C = 0.0214, at 90°C = 0.0227
(defun pv:calc-voltage-drop (length-m current-amp cable-mm2 / rho vdrop)
  ;; Use resistivity at 70°C operating temp (IEC standard)
  (setq rho 0.0214)  ; Ω·mm²/m
  
  ;; Calculate voltage drop (round trip = 2 × length)
  (setq vdrop (/ (* 2.0 length-m current-amp rho) cable-mm2))
  
  ;; Return as percentage of Vmp
  (* (/ vdrop (* *PV_STRING_SIZE* *PV_PAN_VMP*)) 100.0)
)
```

---

#### Fix #5: Inverter Sizing Validation (Line 1693-1731)
**New Function**:
```lisp
(defun pv:validate-inverter-sizing (/ string-isc total-isc-per-input input-ok)
  ;; Check string Isc against inverter input limit
  (setq string-isc (* *PV_STRING_SIZE* *PV_PAN_ISC* 1.25))
  (setq total-isc-per-input string-isc)  ; For single string per input
  
  (setq input-ok (<= total-isc-per-input *PV_INV_IMAX_DC*))
  
  (if (not input-ok)
    (progn
      (alert (strcat "WARNING: String Isc × 1.25 = " (rtos string-isc 2 2)
                     "A exceeds inverter input limit " (rtos *PV_INV_IMAX_DC* 2 1) "A"))
      nil
    )
    t
  )
)
```

---

### 2.2 Crash Prevention Fixes

#### Fix #6: tan() Division by Zero (Line 180-183)
**Current Code**:
```lisp
(defun tan (a)
  (if (equal (cos a) 0.0 1e-6)
    1e6
    (/ (sin a) (cos a))
  )
)
```

**Fixed Code**:
```lisp
(defun tan (a / cos-val)
  (setq cos-val (cos a))
  (cond
    ;; Near 90° or 270° - return large value with sign
    ((< (abs cos-val) 1e-6)
     (if (> (sin a) 0) 1e10 -1e10))
    ;; Normal case
    (t (/ (sin a) cos-val))
  )
)
```

---

#### Fix #7: Shadow Length Division by Zero (Line 310)
**Current Code**:
```lisp
(setq shadow-len (/ h-rise (tan sol-alt)))
```

**Fixed Code**:
```lisp
(setq shadow-len
  (if (< sol-alt (dtr 5.0))  ; Sun below 5° elevation
    100.0  ; Use maximum practical shadow length
    (/ h-rise (tan sol-alt))
  )
)
```

---

#### Fix #8: Array Unpacking Warning (Line 401-427)
**Current Code**:
```lisp
(while (and (< safety-limit 2000) (setq ent (ssname ss i)))
  ...
)
```

**Fixed Code**:
```lisp
(setq safety-limit 0)
(while (and (< safety-limit 2000) (setq ent (ssname ss i)))
  ...
  (setq safety-limit (1+ safety-limit))
)

;; Warn if limit hit
(if (>= safety-limit 2000)
  (alert (strcat "WARNING: Array unpacking limited to 2000 entities.\n"
                 "Some objects may not have been processed.\n"
                 "Consider exploding arrays manually before processing."))
)
```

---

#### Fix #9: Offset Polygon Near-Zero Check (Line 660-741)
**Add Guard**:
```lisp
(defun pv:offset-polygon-inward (pts dist / ... det ...)
  ...
  ;; Before division by det
  (if (< (abs det) 1e-10)
    (progn
      (alert "WARNING: Degenerate polygon detected in offset calculation.")
      nil  ; Return nil to indicate failure
    )
    ;; Normal calculation
    (/ ... det)
  )
)
```

---

#### Fix #10: Module Count Overflow (Line 5721)
**Current Code**:
```lisp
(fix (+ 0.9999 (/ (* *PV_TARGET_KW* 1000.0) *PV_MOD_WATT*)))
```

**Fixed Code**:
```lisp
;; Validate inputs first
(if (or (null *PV_MOD_WATT*) (<= *PV_MOD_WATT* 0))
  (progn
    (alert "ERROR: Module wattage must be a positive value.")
    (exit)
  )
)

(if (or (null *PV_TARGET_KW*) (<= *PV_TARGET_KW* 0))
  (progn
    (alert "ERROR: Target capacity must be a positive value.")
    (exit)
  )
)

;; Calculate with bounds
(setq target-modules 
  (min 100000  ; Max 100,000 modules per layout
       (fix (+ 0.9999 (/ (* *PV_TARGET_KW* 1000.0) *PV_MOD_WATT*))))
)
```

---

### 2.3 Safety System Fixes

#### Fix #11: Fall Safety Anchor Spacing (Line 1824-1872)
**Current Code**: Fixed 8m spacing

**Fixed Code**:
```lisp
;; EN 795 and OSHA 1926.502 require 4.5-6m (15-20ft)
;; Default to conservative 5m, make configurable
(setq *PV_FALL_SAFETY_ANCHOR_SPACING* 5.0)  ; meters

;; In drawing function
(setq num-inter (max 0 (fix (/ seg-len *PV_FALL_SAFETY_ANCHOR_SPACING*))))
```

**Add to DCL**:
```dcl
: edit_box {
  label = "Intermediate Anchor Spacing (m):";
  key = "fall_safety_spacing";
  edit_width = 8;
}
```

---

#### Fix #12: Handrail Height Validation (Line 2148-2163)
**Add Validation**:
```lisp
(defun pv:validate-handrail-height (/ ht)
  (setq ht *PV_HANDRAIL_HEIGHT*)
  (cond
    ((< ht 0.90)
     (alert "WARNING: Handrail height < 0.90m violates OSHA 1910.29.")
     nil)
    ((> ht 1.20)
     (alert "WARNING: Handrail height > 1.20m may not meet local codes.")
     t)  ; Allow but warn
    (t t)  ; Valid range
  )
)
```

---

## Phase 3: Major Fixes (Engineering Accuracy)

**Estimated Time**: 40-50 hours

### 3.1 BOM Calculation Fixes

#### Fix #13: End Clamps Calculation (Line 6658-6659)
**Fixed Code**:
```lisp
;; End clamps: 2 per table end
;; For single-row tables: 4 end clamps total
;; For multi-row elevated with continuous rails: 4 per table, not per row
(setq end-clamps
  (cond
    ;; Elevated mode with continuous rails
    ((= *PV_MOUNT_OPT* "Elevated Canopy Structure")
     (* *PV_TABLE_COUNT* 4))
    ;; Flush mount or discrete MMS
    (t
     (* *PV_TABLE_COUNT* *PV_TABLE_ROWS* 4))
  )
)
```

---

#### Fix #14: Mid Clamps with Orientation (Line 6659)
**Fixed Code**:
```lisp
;; Mid clamps: 2 per inter-module gap
;; Portrait: gaps = cols - 1
;; Landscape: gaps = cols - 1 (same formula)
(setq mid-clamps 
  (* *PV_TABLE_COUNT* 
     *PV_TABLE_ROWS* 
     (max 0 (1- *PV_TABLE_COLS*))  ; Can't be negative
     2))
```

---

#### Fix #15: MC4 Connector Count (Line 6691)
**Fixed Code**:
```lisp
;; MC4 pairs: 2 per string (positive + negative terminals)
;; Plus any parallel connections within strings
(setq mc4-pairs (* (length *PV_STRING_LIST*) 2))
```

---

#### Fix #16: Missing BOM Items
**Add to BOM Function**:
```lisp
;; Earthing hardware
(setq earth-lugs (* *PV_TABLE_COUNT* 2))  ; 2 per table
(setq earth-wire-m (* *PV_TABLE_COUNT* *PV_MOD_LEN* 1.1))  ; Along array length

;; String combiner boxes
(setq combiner-boxes (max 1 (fix (/ (length *PV_STRING_LIST*) 12.0))))  ; 12 strings per box

;; Cable glands (for combiner boxes)
(setq cable-glands (* combiner-boxes (+ 1 (* 2 (min 12 (length *PV_STRING_LIST*))))))

;; Module bonding jumpers (if required by local code)
(setq bonding-jumpers (* *PV_MODULE_COUNT* 0.5))  ; ~50% of modules

;; Inverter mounting hardware
(setq inv-mounting-kit *PV_INV_COUNT*)  ; 1 per inverter
```

---

### 3.2 IEC 61724 Yield Model Fixes

#### Fix #17: Implement Perez Transposition Model
**New File**: `RS-Solar-Yield.lsp`

```lisp
;; Perez transposition model for tilted irradiance
;; Reference: Perez et al. (1990)
(defun pv:perez-transposition (ghi dni dif tilt azimuth lat / 
                                ... calculation variables ...)
  ;; Implementation of Perez model
  ;; Returns POA (Plane of Array) irradiance in W/m²
  ...
)

;; Replace simple model at line 6339-6342
```

---

#### Fix #18: Add Missing Loss Factors (Line 6361-6362)
**Fixed Code**:
```lisp
;; IEC 61724 loss factors
(setq loss-factors
  (list
    (cons "Soiling"           -0.03)   ; -3% (site dependent)
    (cons "Shading"           *PV_SHADING_LOSS*)  ; Calculated
    (cons "Mismatch"          -0.02)   ; -2% string mismatch
    (cons "DC wiring"         -0.01)   ; -1% cable losses
    (cons "Inverter"          (- 1.0 (/ *PV_INV_EFF_EURO* 100.0)))
    (cons "Temperature"       *PV_TEMP_LOSS*)  ; Calculated
    (cons "LID (Year 1 only)" -0.02)   ; -2% light induced degradation
    (cons "Availability"      -0.02)   ; -2% downtime
    (cons "AC wiring"         -0.005)  ; -0.5% AC losses
  )
)

;; Apply losses
(setq total-loss-factor 
  (apply '* (mapcar '(lambda (x) (+ 1.0 (cdr x))) loss-factors)))
```

---

#### Fix #19: Fix Degradation Model (Line 6385-6392)
**Current Code**:
```lisp
(setq yr-gen (* yr1-gen (- 1.0 (+ deg-y1 (* deg-yr (- yr 2))))))
```

**Fixed Code**:
```lisp
;; Linear degradation model
;; Year 1: LID effect (separate from annual degradation)
;; Year 2+: Annual degradation compounds
(defun pv:calc-year-generation (yr yr1-gen deg-yr1 deg-annual)
  (cond
    ((= yr 1) yr1-gen)
    (t (* yr1-gen (- 1.0 (* deg-annual (- yr 1)))))
  )
)

;; In simulation loop
(setq yr-gen (pv:calc-year-generation yr yr1-gen *PV_PAN_DEG_YR1* *PV_PAN_DEG_ANNUAL*))
```

---

### 3.3 DCL Dialog Management Fixes

#### Fix #20: Tab State Persistence (Line 7467-7472)
**Fixed Code**:
```lisp
(defun pv:save-tab-values (tab-id / saved-values)
  ;; Store current values in backup before saving
  (setq saved-values (pv:get-all-tab-values tab-id))
  
  ;; Attempt save with error handling
  (if (not (vl-catch-all-error-p
             (vl-catch-all-apply 
               '(lambda ()
                  ;; Save logic here
                  ...
                ))))
    saved-values  ; Return saved values on success
    (progn
      (alert "ERROR: Failed to save tab values. Previous state restored.")
      nil
    )
  )
)
```

---

#### Fix #21: Reset Current Tab on Fallback (Line 7986-8090)
**Fixed Code**:
```lisp
;; In fallback handler
(if (not dialog-ok)
  (progn
    (setq *PV_CURRENT_TAB* "tab_site_roof")  ; Reset to first tab
    (pv:full-designer-dialog)  ; Open fallback
  )
)
```

---

### 3.4 Input Validation

#### Fix #22: Add Comprehensive Input Validation
**New File**: `RS-Core-Validation.lsp`

```lisp
(defun pv:validate-all-inputs (/ errors)
  (setq errors nil)
  
  ;; Latitude: -90 to +90
  (if (or (null *PV_LAT*) (< *PV_LAT* -90) (> *PV_LAT* 90))
    (setq errors (cons "Latitude must be between -90° and +90°" errors))
  )
  
  ;; Longitude: -180 to +180
  (if (or (null *PV_LON*) (< *PV_LON* -180) (> *PV_LON* 180))
    (setq errors (cons "Longitude must be between -180° and +180°" errors))
  )
  
  ;; Tilt: 0 to 90
  (if (or (null *PV_TILT*) (< *PV_TILT* 0) (> *PV_TILT* 90))
    (setq errors (cons "Tilt angle must be between 0° and 90°" errors))
  )
  
  ;; Azimuth: 0 to 360
  (if (or (null *PV_AZIMUTH*) (< *PV_AZIMUTH* 0) (> *PV_AZIMUTH* 360))
    (setq errors (cons "Azimuth must be between 0° and 360°" errors))
  )
  
  ;; Module dimensions: 0.5 to 3.0 meters
  (if (or (null *PV_MOD_LEN*) (< *PV_MOD_LEN* 0.5) (> *PV_MOD_LEN* 3.0))
    (setq errors (cons "Module length must be between 0.5m and 3.0m" errors))
  )
  (if (or (null *PV_MOD_WID*) (< *PV_MOD_WID* 0.5) (> *PV_MOD_WID* 3.0))
    (setq errors (cons "Module width must be between 0.5m and 3.0m" errors))
  )
  
  ;; Module wattage: positive
  (if (or (null *PV_MOD_WATT*) (<= *PV_MOD_WATT* 0))
    (setq errors (cons "Module wattage must be positive" errors))
  )
  
  ;; PR: 50 to 95
  (if (or (null *PV_PR*) (< *PV_PR* 50) (> *PV_PR* 95))
    (setq errors (cons "Performance Ratio must be between 50% and 95%" errors))
  )
  
  ;; String size vs inverter inputs
  (if (> *PV_STRING_SIZE* (* *PV_INV_MPPT_COUNT* *PV_INV_INPUTS*))
    (setq errors (cons "String count exceeds inverter MPPT inputs" errors))
  )
  
  ;; Return errors
  (reverse errors)
)

;; Call at start of layout generation
(defun c:pv-generate-layout (/ validation-errors)
  (setq validation-errors (pv:validate-all-inputs))
  (if validation-errors
    (progn
      (alert (strcat "INPUT ERRORS:\n\n" 
                     (apply 'strcat 
                            (mapcar '(lambda (e) (strcat "• " e "\n")) 
                                    validation-errors))))
      (exit)
    )
  )
  ;; Continue with layout...
)
```

---

## Phase 4: Minor Fixes & Code Quality

**Estimated Time**: 20-25 hours

### 4.1 AutoLISP Best Practices

#### Fix #23: Error Handling Wrapper
**Add to all command functions**:
```lisp
(defun c:pv-example (/ *error* old-cmdecho old-osmode)
  ;; Save system variables
  (setq old-cmdecho (getvar "CMDECHO"))
  (setq old-osmode (getvar "OSMODE"))
  
  ;; Define local error handler
  (defun *error* (msg)
    (if old-cmdecho (setvar "CMDECHO" old-cmdecho))
    (if old-osmode (setvar "OSMODE" old-osmode))
    (if (and msg (not (wcmatch (strcase msg) "*BREAK*,*CANCEL*,*EXIT*")))
      (princ (strcat "\nError: " msg))
    )
    (princ)
  )
  
  ;; Main function body
  (setvar "CMDECHO" 0)
  (setvar "OSMODE" 0)
  
  ;; ... function logic ...
  
  ;; Restore and exit
  (setvar "CMDECHO" old-cmdecho)
  (setvar "OSMODE" old-osmode)
  (princ)
)
```

---

#### Fix #24: Global Variable Protection
**Replace direct setq with safe-setq**:
```lisp
(defun pv:safe-setq (sym val / existing)
  (if (not (boundp sym))
    (set sym val)
    (progn
      (setq existing (eval sym))
      (if (not (equal existing val))
        (set sym val)
      )
    )
  )
)

;; Use instead of setq for globals
(pv:safe-setq '*PV_LAT* 13.0827)
```

---

#### Fix #25: Remove Duplicate Function (Line 1068-1074)
**Action**: Remove second `pv:tan` definition. Keep only the corrected version at line 180.

---

#### Fix #26: Add Undo Groups
**Add to multi-step commands**:
```lisp
(defun c:pv-fall-safety (/ ...)
  ;; Start undo group
  (vl-cmdf "._UNDO" "_Begin")
  
  ;; ... command logic ...
  
  ;; End undo group
  (vl-cmdf "._UNDO" "_End")
  (princ)
)
```

---

### 4.2 UX Improvements

#### Fix #27: Progress Indicator for Large Layouts
```lisp
(defun pv:progress-update (current total message)
  (if (= (rem current 100) 0)  ; Update every 100 modules
    (progn
      (princ (strcat "\r" message " " (itoa current) "/" (itoa total) 
                     " (" (rtos (* 100.0 (/ current total)) 2 1) "%)"))
      (princ)
    )
  )
)

;; In layout loop
(pv:progress-update i total-modules "Placing modules...")
```

---

#### Fix #28: Consistent Command Aliases
**Remove duplicates and standardize**:
```lisp
;; Keep one canonical alias per function
;; Remove: PVPVSYST, PVEXPORTPVSYST
;; Keep: PVPVSYSTEXPORT

;; Document all aliases in README
```

---

## Phase 5: Professional Deployment Features

**Estimated Time**: 25-35 hours

### 5.1 License Management

**New File**: `RS-Config-License.lsp`

```lisp
(setq *PV_LICENSE_TYPE* "trial")      ; "trial", "standard", "professional"
(setq *PV_LICENSE_EXPIRY* nil)         ; Date string or nil
(setq *PV_LICENSE_SEAT* nil)           ; Machine ID
(setq *PV_TRIAL_DAYS* 30)              ; Trial period

(defun pv:check-license (/ days-left)
  (cond
    ;; Professional license
    ((= *PV_LICENSE_TYPE* "professional")
     t)
    
    ;; Standard license
    ((= *PV_LICENSE_TYPE* "standard")
     (if (and *PV_LICENSE_EXPIRY* 
              (< (getvar "DATE") (atof *PV_LICENSE_EXPIRY*)))
       t
       (progn
         (alert "License expired. Please renew to continue.")
         nil
       )
     ))
    
    ;; Trial license
    ((= *PV_LICENSE_TYPE* "trial")
     (setq days-left (pv:trial-days-remaining))
     (if (> days-left 0)
       (progn
         (princ (strcat "\nRooftopSolar Trial: " (itoa days-left) " days remaining."))
         t)
       (progn
         (alert "Trial period expired. Please purchase a license.")
         nil
       )
     ))
    
    ;; No license
    (t
     (alert "No valid license found. Running in demo mode.")
     (setq *PV_DEMO_MODE* t)
     t)
  )
)
```

---

### 5.2 Version Management

```lisp
(setq *PV_VERSION_MAJOR* 3)
(setq *PV_VERSION_MINOR* 0)
(setq *PV_VERSION_PATCH* 0)
(setq *PV_VERSION_STRING* "3.0.0")
(setq *PV_BUILD_DATE* "2026-10-28")

(defun pv:get-version ()
  (strcat "RooftopSolar v" *PV_VERSION_STRING* 
          " (Build " *PV_BUILD_DATE* ")")
)

(defun pv:check-updates (/ latest)
  ;; Check GitHub for latest release
  ;; (Implementation depends on network access)
)
```

---

### 5.3 User Preferences Persistence

**New File**: `RS-Config-Preferences.lsp`

```lisp
(defun pv:save-preferences (/ prefs-file)
  (setq prefs-file (strcat (getenv "APPDATA") "\\RooftopSolar\\config.json"))
  
  ;; Write JSON with user preferences
  (vl-file-write prefs-file
    (pv:to-json
      (list
        (cons "latitude" *PV_LAT*)
        (cons "longitude" *PV_LON*)
        (cons "currency" *PV_CURRENCY_CODE*)
        (cons "tariff" *PV_GRID_TARIFF*)
        (cons "epc_cost" *PV_EPC_COST_PER_W*)
      )
    )
  )
)

(defun pv:load-preferences (/ prefs-file data)
  (setq prefs-file (strcat (getenv "APPDATA") "\\RooftopSolar\\config.json"))
  
  (if (findfile prefs-file)
    (progn
      (setq data (pv:read-json prefs-file))
      (if (assoc "latitude" data)
        (setq *PV_LAT* (cdr (assoc "latitude" data))))
      ;; ... load other preferences
    )
  )
)
```

---

### 5.4 CUI/Ribbon Integration

**New File**: `RooftopSolar.cui`

```xml
<?xml version="1.0" encoding="UTF-8"?>
<PartialCustFiles>
  <RibbonPanel>
    <Name>RooftopSolar</Name>
    <RibbonRow>
      <RibbonButton>
        <Label>Site &amp; Roof</Label>
        <Macro>^C^CPVPICKBOUNDARY</Macro>
      </RibbonButton>
      <RibbonButton>
        <Label>Generate Layout</Label>
        <Macro>^C^CPVLAYOUT</Macro>
      </RibbonButton>
      <RibbonButton>
        <Label>DC Stringing</Label>
        <Macro>^C^CPVSTRING</Macro>
      </RibbonButton>
    </RibbonRow>
    <!-- More buttons -->
  </RibbonPanel>
</PartialCustFiles>
```

---

### 5.5 Error Logging

**New File**: `RS-Core-Logging.lsp`

```lisp
(defun pv:log-error (error-msg / log-file)
  (setq log-file (strcat (getenv "APPDATA") "\\RooftopSolar\\logs\\error.log"))
  
  ;; Ensure log directory exists
  (vl-file-delete log-file)  ; Create parent if needed
  
  ;; Append error with timestamp
  (vl-file-write log-file
    (strcat (menucmd "M=$(edtime,$(getvar,date),YYYY-MO-DD HH:MM:SS)")
            " | " error-msg "\n")
    t  ; Append mode
  )
)

;; Use in error handlers
(defun *error* (msg)
  (pv:log-error msg)
  ;; ... restore state
)
```

---

## Phase 6: Testing & Validation

**Estimated Time**: 15-20 hours

### 6.1 Unit Test Suite

**Test Files to Create**:

```
tests/
├── test_math.lsp              # dtr, rtd, tan, asin, acos
├── test_geometry.lsp          # bbox, convex-hull, offset-polygon
├── test_solar_position.lsp    # solar position at known locations/times
├── test_shadow.lsp            # shadow length calculations
├── test_voc_temp.lsp          # Voc temperature correction
├── test_cable_sizing.lsp      # Cable derating
├── test_bom.lsp               # Clamp/leg counts
├── test_yield.lsp             # Energy calculations
└── test_validation.lsp        # Input validation
```

### 6.2 Integration Tests

- Full layout generation on test DWG
- DC stringing on 1000-module array
- BOM generation and export
- PVsyst export validation
- 3D visualization without crashes

### 6.3 Standards Compliance Tests

- NEC 690 voltage limits at various temperatures
- IEC 61724 yield accuracy vs. PVsyst
- EN 795 fall safety spacing

---

## Phase 7: Documentation

**Estimated Time**: 10-15 hours

### 7.1 User Documentation
- Update `USER_GUIDE.md` with new features
- Create context-sensitive help topics
- Add troubleshooting FAQ

### 7.2 Developer Documentation
- API reference for all `pv:` functions
- Architecture diagram of module structure
- Contribution guidelines

### 7.3 Standards Compliance Documentation
- IEC 62446 checklist
- NEC 690 compliance matrix
- Local code adaptation guide

---

## Implementation Schedule

| Phase | Duration | Start | End |
|-------|----------|-------|-----|
| 1. Backup & Infrastructure | 5h | Day 1 | Day 1 |
| 2. Critical Fixes | 35h | Day 2 | Day 5 |
| 3. Major Fixes | 45h | Day 6 | Day 10 |
| 4. Minor Fixes | 25h | Day 11 | Day 13 |
| 5. Professional Features | 30h | Day 14 | Day 17 |
| 6. Testing | 18h | Day 18 | Day 19 |
| 7. Documentation | 12h | Day 20 | Day 20 |
| **Total** | **170h** | **20 days** | |

---

## Risk Mitigation

### Backup Strategy
1. **Git commit after each fix** with descriptive message
2. **Tag before each phase**: `v2.5.1-pre-phase2`, etc.
3. **Daily push to remote** repository
4. **Keep `.bak` files** for first 3 phases

### Testing Strategy
1. **Unit test each fix** before moving to next
2. **Integration test after each phase**
3. **Manual regression test** on sample DWG files
4. **Standards compliance verification** before release

### Rollback Strategy
```bash
# If critical bug found, rollback to last known good state
git checkout v2.5.2-phase2-complete
# Or revert specific commit
git revert <commit-hash>
```

---

## Success Criteria

### Before Release
- [ ] All Critical issues resolved
- [ ] All Major issues resolved
- [ ] Unit tests passing (100%)
- [ ] Integration tests passing
- [ ] Standards compliance verified
- [ ] Documentation updated
- [ ] User acceptance testing complete

### Quality Metrics
- Zero crashes on 10,000+ module layouts
- BOM accuracy > 99%
- Yield accuracy within 3% of PVsyst
- Voltage calculations IEC/NEC compliant
- User preferences persist across sessions
- License management functional

---

**Plan Status**: Ready for implementation  
**Next Step**: Execute Phase 1 (Git initialization and backup)
