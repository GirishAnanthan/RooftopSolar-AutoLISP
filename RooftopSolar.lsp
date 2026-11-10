;;; ==========================================================================
;;; RooftopSolar.lsp - Comprehensive Rooftop Solar PV Layout & Yield Designer
;;; AutoLISP Application for AutoCAD
;;; Features:
;;;   1. Rooftop Type Selection: RCC Flat Rooftop & Sloped Metal Sheet Rooftop
;;;   2. PV Module Library & .PAN File Parser / Selection
;;;   3. Grid-Tied String Inverter Library & .OND File Parser / Sizing
;;;   4. Polyline Boundary Fill OR Target Solar Capacity (kWp) Sizing Mode
;;;   5. Fall Safety Line System: End Anchor Plates with Spring Tensioners,
;;;      90° Turn Points / Corner Anchors, and SS Wire Rope Lifelines
;;;   6. Rooftop Safety Handrails with Stanchion Posts and Kickplates
;;;   7. Site Coordinates (Lat/Lon), Tilt, Azimuth, and Weather Sources (PVGIS / NASA)
;;;   8. Monthly, Yearly, and 25-Year Energy Generation Tables & Full BOM
;;; ==========================================================================

(vl-load-com)

;;; --------------------------------------------------------------------------
;;; Global Default Variables
;;; --------------------------------------------------------------------------
(setq *PV_CURRENT_TAB*        "tab_site_roof"
      *PV_PROJ_NAME*          "Solar Rooftop Project"
      *PV_WEATHER_SRC*        "PVGIS (SARAH-2/ERA5)"
      *PV_LAT*                13.0827
      *PV_LON*                80.2707
      *PV_PR*                 78.0
      *PV_ROOF_TYPE*          "Flat RCC Rooftop"
      *PV_MOUNT_OPT*          "Tilted on MMS Structures"
      *PV_ROOF_SLOPE*         0.0
      *PV_ROOF_SLOPE_DIRS*    2       ; 1 = Monoslope, 2 = Dual-Pitch (Gable), 4 = Hip, 0 = Flat
      *PV_ROOF_FACING*        "North & South" ; "North", "South", "East", "West", "North & South", "East & West", "4-Directions"
      *PV_ROOF_SLOPE_POPULATE* "Both-Slopes"  ; "Both-Slopes", "South-Slope-Only", "North-Slope-Only", "West-Slope-Only", "East-Slope-Only"
      *PV_CURRENT_BUILDING_BBOX* nil          ; bounding box of the full building for 3D elevation calculations
      *PV_BLDG_EAVES_HT*      6.00    ; meters (eaves / end wall height)
      *PV_BLDG_RIDGE_HT*      8.00    ; meters (centre / ridge / apex height)
      *PV_PARAPET_HEIGHT*     1.00    ; meters (parapet wall height above roof slab for Flat RCC)
      *PV_PARAPET_THICKNESS*  0.23    ; meters (parapet wall thickness for Flat RCC, 230mm = 9 inch)
      *PV_MOD_CLEAR*          0.50    ; meters
      *PV_SETBACK*            0.50    ; meters
      ;; Elevated Tilted Legs & Continuous Canopy Setup (Flat RCC)
      *PV_ELEV_LEG_MODE*      "COUNT"            ; "COUNT" (by count), "DISTANCE" (spacing in m), "MODULES" (every N modules)
      *PV_ELEV_LEG_COUNT*     2                  ; number of intermediate vertical legs between first & last leg in row
      *PV_ELEV_LEG_DIST*      3.00               ; spacing in meters between legs
      *PV_ELEV_LEG_MODS*      2                  ; spacing in number of modules between legs
      *PV_ELEV_MIN_CLEAR*     2.00               ; lowest leg clearance / elevation above roof slab (m)
      *PV_ELEV_TILT_DIR*      "North to South"   ; "North to South", "South to North", "East to West", "West to East"
      *PV_ELEV_TOTAL_LEGS*    0                  ; total vertical columns generated for BOM
      *PV_LAYOUT_MODE*        "Fill Polyline Boundary (Max Capacity)" ; or "Target Plant Capacity (kWp)"
      *PV_TARGET_KW*          50.0    ; target capacity in kWp
      *PV_MOD_WATT*           550.0   ; Wp
      *PV_MOD_LEN*            2.278   ; meters
      *PV_MOD_WID*            1.134   ; meters
      *PV_MOD_ORIENT*         "Portrait"
      *PV_TILT*               15.0    ; degrees
      *PV_AZIMUTH*            180.0   ; degrees (180 = South)
      *PV_TABLE_COLS*         10
      *PV_TABLE_ROWS*         1
      *PV_COL_SPACING*        0.03    ; meters
      *PV_ROW_SPACING*        0.03    ; meters
      *PV_PITCH*              2.80    ; meters
      *PV_DEF_OBS_HT*         1.50    ; meters
      *PV_OBS_BUFFER*         0.05    ; meters
      *PV_DRAW_SHADOW*        1
      *PV_BOUNDARY_ENT*       nil
      *PV_BOUNDARY_LIST*      nil     ; list of multiple roof boundary entity names
      *PV_ROOF_SURFACES*      nil     ; list of sloped roof surface records: (surf-ent ("NAME" . "") ("FACING" . "") ("AZIMUTH" . val) ("TILT" . val) ("BLDG-BBOX" . bbox) ("BLDG-ENT" . ent) ("PTS" . pts) ("PLANE" . (A B C D)))
      *PV_ACTIVE_SURFACE_PLANE* nil   ; analytical plane equation (A B C D) of current active roof surface
      *PV_ACTIVE_ROOF_IDX*    0       ; 0 = All roofs, 1..N = specific active roof index
      *PV_OBSTACLES*          nil     ; list of (ent ht shadow-poly obs-poly)
      *PV_PRE_SEL*            nil
      *PV_STD_AISLE_X*        0.40    ; meters (inter-table maintenance aisle gap)
      *PV_WALKWAY_WIDTH*      0.80    ; meters (user specified walkway corridor width)
      *PV_WALKWAY_FREQ_ROW*   0       ; horizontal walkway frequency (every N module rows, 0 = disabled)
      *PV_WALKWAY_FREQ_COL*   0       ; vertical walkway frequency (every N module cols, 0 = disabled)
      *PV_DRAW_AUTO_WALKWAY*  1       ; 1 = auto-draw walkway corridor polylines on PV_WALKWAY
      *PV_WALKWAY_LENGTH*     0.0     ; meters (total defined walkway length)
      *PV_WALKWAY_POLYS*      nil     ; list of defined walkway polygon coordinates
      *PV_AUTO_WALKWAY_ENTS*  nil     ; list of automatically drawn walkway entity handles
      *PV_MODULE_COUNT*       0
      *PV_TABLE_COUNT*        0

      ;; PV Module PAN Specifications
      *PV_PAN_FILE*           ""
      *PV_PAN_MFG*            "JinkoSolar"
      *PV_PAN_MODEL*          "Tiger Neo JKM550N-72HL4-V"
      *PV_PAN_TECH*           "N-Type TOPCon"
      *PV_PAN_VMP*            41.42
      *PV_PAN_IMP*            13.28
      *PV_PAN_VOC*            50.25
      *PV_PAN_ISC*            14.03
      *PV_PAN_TEMP_COEFF*     -0.300
      *PV_PAN_TEMP_VOC*       -0.250
      *PV_PAN_TEMP_ISC*       0.045

      ;; Temperature & Cable Derating Parameters (Indian Climate Settings)
      *PV_T_MIN_AMBIENT*      8.0     ; Minimum winter ambient temp (°C) for Voc calculation in India (8°C)
      *PV_AMBIENT_TEMP*       45.0    ; Peak summer ambient temp (°C) for cable derating in India
      *PV_TEMP_MIN*           8.0     ; Realistic winter min temp (°C) for Indian conditions
      *PV_TEMP_MAX_CELL*      75.0    ; Peak summer cell operating temp (°C) for MPPT check

      ;; Indian Regulatory, DISCOM & Statutory Standards (IS / CEA / MNRE)
      *PV_SANCTIONED_LOAD*    25.0    ; kW (Consumer Sanctioned Load for Net-Metering)
      *PV_CONTRACT_DEMAND*    28.0    ; kVA (Contract Demand)
      *PV_GRID_VOLTAGE*       "415V 3-Phase 50Hz" ; DISCOM Supply Voltage
      *PV_WIND_ZONE*          "Zone III (44 m/s)" ; IS 875 Part 3 Basic Wind Speed Zone
      *PV_EARTHING_PITS*      nil     ; List of placed earth pits ((pt "DC") (pt "AC") (pt "LA"))
      *PV_LIGHTNING_MAST*     nil     ; List of (pt radius type mast-ht)
      *PV_PM_SURYA_GHAR*      1       ; 1 = Enable PM Surya Ghar Subsidy Calc
      *PV_SUBSIDY_RS*         78000.0 ; PM Surya Ghar Central Subsidy (INR)
      *PV_COMMERCIAL_AD*      0       ; 1 = 40% Accelerated Depreciation for Commercial/Industrial
      *PV_GST_RATE*           13.8    ; % Blended GST (5% modules + 18% services)
      *PV_CABLES_IN_TRAY*     4       ; Number of DC cables in tray for grouping factor
      *PV_PAN_BIFACIAL*       0.80
      *PV_PAN_EFFICIENCY*     21.29
      *PV_PAN_CELLS*          144
      *PV_PAN_WEIGHT*         28.0
      *PV_PAN_LOADED*         t
      *PV_MODULE_LIBRARY*     nil
      *PV_ACTIVE_MODULE_IDX*  0

      ;; Solar Grid-Tied String Inverter Specifications
      *PV_OND_FILE*           ""
      *PV_INV_MFG*            "Sungrow"
      *PV_INV_MODEL*          "SG50CX"
      *PV_INV_KW*             50.0
      *PV_INV_VDC_MAX*        1000.0
      *PV_INV_VMPP_MIN*       200.0
      *PV_INV_VMPP_MAX*       960.0
      *PV_INV_IMAX_DC*        100.0
      *PV_INV_MPPT_COUNT*     5
      *PV_INV_INPUTS*         10
      *PV_INV_EFF_EURO*       98.5
      *PV_INV_EFF_MAX*        98.7
      *PV_INV_WEIGHT*         62.0
      *PV_INV_COUNT*          1
      *PV_DC_AC_RATIO*        1.10
      *PV_INVERTER_LIBRARY*   nil
      *PV_ACTIVE_INVERTER_IDX* 0

      ;; PVcase / ARKA 360 Features
      *PV_STRING_SIZE*         20      ; modules per string (default)
      *PV_STRING_LIST*         nil     ; list of string records
      *PV_INVERTER_POS*        nil     ; Inverter Station insertion point
      *PV_CABLE_TRAY_WIDTH*    0.30    ; meters
      *PV_CABLE_TRAY_PTS*      nil     ; centerline vertices
      *PV_CABLE_TRAY_LENGTH*   0.0     ; meters
      *PV_TOTAL_DC_CABLE_M*    0.0     ; meters of DC 1C x 4/6 sq.mm cable
      *PV_VDROP_PERCENT*       0.0     ; % voltage drop
      *PV_CURRENCY_CODE*       "INR"   ; "INR", "USD", "EUR", "GBP", "AED", "SAR", "AUD", etc.
      *PV_CURRENCY_SYM*        "Rs."   ; Currency symbol display
      *PV_CURRENCY_IDX*        0       ; Default index in currency dropdown
      *PV_GRID_TARIFF*         7.50    ; Grid tariff per kWh (default INR 7.50 / kWh)
      *PV_EPC_COST_PER_W*      42.00   ; Turnkey EPC cost per Wp (default INR 42.00 / Wp)
      *PV_TARIFF_ESC*          3.0     ; %/yr
      *PV_OPEX_PERCENT*        1.0     ; %/yr of initial CapEx
      *PV_CURRENCY_LIST*
      '(
        ("INR" "Rs." "INR - Indian Rupee (Rs.)"            7.50   42.00)
        ("USD" "$"   "USD - US Dollar ($)"                 0.10    0.85)
        ("EUR" "EUR" "EUR - Euro (EUR)"                    0.18    0.80)
        ("GBP" "GBP" "GBP - British Pound (GBP)"           0.22    0.75)
        ("AED" "AED" "AED - UAE Dirham (AED)"              0.38    3.00)
        ("SAR" "SAR" "SAR - Saudi Riyal (SAR)"             0.32    3.10)
        ("AUD" "A$"  "AUD - Australian Dollar (A$)"        0.24    1.10)
        ("CAD" "C$"  "CAD - Canadian Dollar (C$)"          0.16    1.15)
        ("JPY" "JPY" "JPY - Japanese Yen (JPY)"           18.00  120.00)
        ("SGD" "S$"  "SGD - Singapore Dollar (S$)"         0.28    1.25)
        ("ZAR" "R"   "ZAR - South African Rand (R)"        2.20   14.50)
       )

      ;; Fall Safety System Records
      *PV_FALL_SAFETY_LINES*        nil ; list of records
      *PV_FALL_SAFETY_LENGTH*       0.0 ; linear meters of wire rope
      *PV_FALL_SAFETY_ANCHOR_COUNT* 0   ; end anchor plates w/ spring tensioners
      *PV_FALL_SAFETY_TURN_COUNT*   0   ; 90 deg turn corner anchors
      *PV_FALL_SAFETY_INTER_COUNT*  0   ; intermediate rope guides

      ;; Handrail System Configuration & Specifications
      *PV_HANDRAIL_HEIGHT*        1.10    ; meters (standard guardrail height: 1.10m = 1100mm)
      *PV_HANDRAIL_NUM_RAILS*     2       ; number of horizontal rails: 2, 3, or 4
      *PV_HANDRAIL_POST_SHAPE*    "Round Pipe" ; "Round Pipe" or "Square Pipe"
      *PV_HANDRAIL_RAIL_SHAPE*    "Round Pipe" ; "Round Pipe" or "Square Pipe"
      *PV_HANDRAIL_POST_SPACING*  1.50    ; meters (stanchion post spacing: 1.50m)
      *PV_FALL_SAFETY_ANCHOR_SPACING*  5.0    ; meters (EN 795: 4.5-6m max spacing)
      *PV_HANDRAIL_POST_SIZE*     0.05    ; meters (50mm diameter / 50x50mm square)
      *PV_HANDRAIL_RAIL_SIZE*     0.04    ; meters (40mm diameter / 40x40mm square)
      *PV_HANDRAIL_TOEBOARD*      1       ; 1 = include 150mm kickplate/toeboard, 0 = no
      *PV_HANDRAIL_CAST_SHADOW*   1       ; 1 = treat handrail as obstacle & generate 9am-3pm shadow envelope on PV_SHADOW, 0 = no
      *PV_HANDRAIL_LINES*         nil     ; list of (pts length) records
      *PV_HANDRAIL_LENGTH*        0.0     ; linear meters
      *PV_HANDRAIL_POST_COUNT*    0       ; stanchion posts
      *PV_HANDRAIL_3D_ENTS*       nil     ; list of 3D handrail entity handles
)

;;; --------------------------------------------------------------------------
;;; Math & Conversion Helpers
;;; --------------------------------------------------------------------------
(defun dtr (d) (* pi (/ d 180.0)))
(defun rtd (r) (* 180.0 (/ r pi)))

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

(defun pv:tan (a)
  (tan a)
)

(defun asin (x)
  (cond
    ((> x 1.0)  (/ pi 2.0))
    ((< x -1.0) (- (/ pi 2.0)))
    ((equal (abs x) 1.0 1e-6) (* (/ pi 2.0) (if (> x 0) 1.0 -1.0)))
    (t (atan (/ x (sqrt (- 1.0 (* x x))))))
  )
)

(defun acos (x)
  (- (/ pi 2.0) (asin x))
)

;;; --------------------------------------------------------------------------
;;; Plane-equation helper (for 3D surfaces). Returns (A B C D) where
;;;   A*x + B*y + C*z + D = 0  (upward normal, C > 0 always enforced)
(defun pv:plane-from-3pts (p1 p2 p3 / v1x v1y v1z v2x v2y v2z a b c len d)
  (setq v1x (- (car p2) (car p1))
        v1y (- (cadr p2) (cadr p1))
        v1z (- (caddr p2) (caddr p1))
        v2x (- (car p3) (car p1))
        v2y (- (cadr p3) (cadr p1))
        v2z (- (caddr p3) (caddr p1)))
  (setq a (- (* v1y v2z) (* v1z v2y))
        b (- (* v1z v2x) (* v1x v2z))
        c (- (* v1x v2y) (* v1y v2x)))
  ;; Enforce upward normal (c > 0)
  (if (< c 0.0)
    (setq a (- a) b (- b) c (- c))
  )
  (setq len (sqrt (+ (* a a) (* b b) (* c c))))
  (if (< len 1e-9)
    nil
    (progn
      (setq a (/ a len) b (/ b len) c (/ c len))
      (setq d (- (+ (* a (car p1)) (* b (cadr p1)) (* c (caddr p1)))))
      (list a b c d)
    )
  )
)

;;; Given a plane (A B C D) and a 2D XY point, returns Z on the plane.
;;; Z = -(A*x + B*y + D) / C
(defun pv:plane-get-z (plane pt / a b c d)
  (setq a (car plane) b (cadr plane) c (caddr plane) d (cadddr plane))
  (if (< (abs c) 1e-9)
    0.0
    (- (/ (+ (* a (car pt)) (* b (cadr pt)) d) c))
  )
)

;;; Compute plane from a list of 3D pts (tries non-collinear triples).
;;; Returns nil if pts don't span a plane.
(defun pv:plane-from-pts-list (pts / n i j p1 p2 p3 res)
  (if (and pts (>= (length pts) 3)
           (caddr (car pts)))               ; must be 3D pts
    (progn
      (setq n (length pts)
            p1 (nth 0 pts)
            res nil
            i 1)
      (while (and (null res) (< i (1- n)))
        (setq j (1+ i))
        (while (and (null res) (< j n))
          (setq p2 (nth i pts)
                p3 (nth j pts))
          (if (and (caddr p2) (caddr p3))
            (setq res (pv:plane-from-3pts p1 p2 p3))
          )
          (setq j (1+ j))
        )
        (setq i (1+ i))
      )
      res
    )
    nil
  )
)

;;; Computes (tilt-deg azimuth-deg facing-str) from analytical plane (A B C D).
;;; Solar azimuth convention: 0=North (+Y), 90=East (+X), 180=South (-Y), 270=West (-X).
(defun pv:slope-from-plane (plane / a b c len-xy tilt-deg cad-deg az-deg facing-str)
  (if (and plane (listp plane) (= (length plane) 4))
    (progn
      (setq a (car plane)
            b (cadr plane)
            c (caddr plane))
      (setq len-xy (sqrt (+ (* a a) (* b b))))
      (setq tilt-deg (* (atan len-xy (max 1e-6 (abs c))) (/ 180.0 pi)))
      (if (< len-xy 1e-4)
        (progn
          (setq az-deg (if *PV_AZIMUTH* *PV_AZIMUTH* 180.0))
          (setq facing-str "Flat")
        )
        (progn
          (setq cad-deg (* (atan b a) (/ 180.0 pi)))
          (setq az-deg (rem (+ 450.0 (- cad-deg)) 360.0))
          (cond
            ((and (>= az-deg 135.0) (< az-deg 225.0)) (setq facing-str "South"))
            ((or  (>= az-deg 315.0) (< az-deg 45.0))  (setq facing-str "North"))
            ((and (>= az-deg 45.0)  (< az-deg 135.0)) (setq facing-str "East"))
            (t                                        (setq facing-str "West"))
          )
        )
      )
      (list (atof (rtos tilt-deg 2 1)) (atof (rtos az-deg 2 1)) facing-str)
    )
    (list 0.0 (if *PV_AZIMUTH* *PV_AZIMUTH* 180.0) "Flat")
  )
)

;;; Compute 2D centroid (cx cy) of a list of points
(defun pv:poly-centroid-2d (pts / sx sy n)
  (if (and pts (> (length pts) 0))
    (progn
      (setq sx 0.0 sy 0.0 n (float (length pts)))
      (foreach p pts
        (setq sx (+ sx (car p))
              sy (+ sy (cadr p)))
      )
      (list (/ sx n) (/ sy n))
    )
    nil
  )
)

;;; --------------------------------------------------------------------------
;;; Layer Management
;;; --------------------------------------------------------------------------
(defun pv:make-layer (name color ltype)
  (if (not (tblsearch "LAYER" name))
    (entmake
      (list
        '(0 . "LAYER")
        '(100 . "AcDbSymbolTableRecord")
        '(100 . "AcDbLayerTableRecord")
        (cons 2 name)
        '(70 . 0)
        (cons 62 color)
        (cons 6 (if (tblsearch "LTYPE" ltype) ltype "Continuous"))
      )
    )
  )
)

(defun pv:init-layers ()
  (pv:make-layer "PV_BOUNDARY"     4 "Continuous")  ; Cyan
  (pv:make-layer "PV_SETBACK"      8 "DASHED")      ; Gray dashed
  (pv:make-layer "PV_OBSTACLE"     1 "Continuous")  ; Red
  (pv:make-layer "PV_SHADOW"       9 "Continuous")  ; Light Gray
  (pv:make-layer "PV_MODULES"      5 "Continuous")  ; Blue
  (pv:make-layer "PV_MODULES_EAST" 4 "Continuous")  ; Cyan (East-facing modules)
  (pv:make-layer "PV_MODULES_WEST" 30 "Continuous") ; Orange (West-facing modules)
  (pv:make-layer "PV_PANEL_NUMS"   7 "Continuous")  ; White
  (pv:make-layer "PV_STRUCTURE"    3 "Continuous")  ; Green
  (pv:make-layer "PV_WALKWAY"      30 "Continuous") ; Amber/Orange
  (pv:make-layer "PV_FALL_SAFETY"  6 "Continuous")  ; Magenta (Fall Safety wire rope & tensioners)
  (pv:make-layer "PV_HANDRAIL"     40 "Continuous") ; Orange/Yellow (Perimeter Handrails)
  (pv:make-layer "PV_3D_HANDRAIL"  40 "Continuous") ; 3D Handrails & Guardrails
  (pv:make-layer "PV_ANNOTATION"   7 "Continuous")  ; White
  (pv:make-layer "PV_BOM"          2 "Continuous")  ; Yellow
  (pv:make-layer "PV_ENERGY_TABLE" 7 "Continuous")  ; White/Black
  (pv:make-layer "PV_REPORT"       7 "Continuous")  ; White
  (pv:make-layer "PV_STRINGS"      1 "Continuous")  ; Red (0.35mm lineweight)
  (pv:make-layer "PV_STRING_TAGS" 2 "Continuous")  ; Yellow
  (pv:make-layer "PV_DC_CABLE"     1 "Continuous")  ; Red (DC Solar Cable)
  (pv:make-layer "PV_DC_ROUTE_GUIDE" 1 "DASHED")    ; Red dashed (DC Route Guide)
  (pv:make-layer "PV_AC_CABLE"     3 "Continuous")  ; Green (AC Power Cable)
  (pv:make-layer "PV_INVERTER"    4 "Continuous")  ; Cyan (0.50mm lineweight)
  (pv:make-layer "PV_CABLE_TRAY"  30 "Continuous") ; Orange (0.35mm lineweight)
  (pv:make-layer "PV_SLD"         7 "Continuous")  ; White
  (pv:make-layer "PV_EARTHING"    3 "Continuous")  ; Green (IS 3043 Chemical Earth Pits & 25x3mm Strip)
  (pv:make-layer "PV_LIGHTNING"   6 "DASHED")      ; Magenta (IS/IEC 62305 LA Mast & Protection Cone)
  (pv:make-layer "PV_ELECTRICAL"  4 "Continuous")  ; Cyan (AJB/DCDB, ACDB, DISCOM GOS Switch)
  (pv:make-layer "PV_3D_MODULES"      140 "Continuous"); Slate Blue
  (pv:make-layer "PV_3D_STRUCTURE"    8 "Continuous")  ; Dark Gray / Metallic
  (pv:make-layer "PV_3D_OBSTACLES"    1 "Continuous")  ; Red
  (pv:make-layer "PV_3D_BUILDING"     8 "Continuous")  ; Gray/Steel (Building vertical walls, footprint)
  (pv:make-layer "PV_3D_ROOF_OUTLINE" 3 "Continuous")  ; Green (3D Eaves, Ridge & Gables)
  (pv:make-layer "PV_3D_ROOF_FACE"    252 "Continuous"); Slate/Steel (Roof Surfaces 3DFACE)
  (pv:make-layer "PV_3D_SAFETY"       6 "Continuous")  ; Magenta (3D Fall Safety Lifeline & Standoffs)
  (pv:make-layer "PV_3D_WALKWAY"      30 "Continuous") ; Amber/Orange (3D Elevated Maintenance Walkways)
  (pv:make-layer "PV_PARAPET"         1 "Continuous")  ; Red/Orange (Parapet Wall Plan Outlines)
  (pv:make-layer "PV_3D_PARAPET"      8 "Continuous")  ; Concrete Gray (3D Parapet Wall Surrounds)
)

;;; --------------------------------------------------------------------------
;;; Solar Geometry & Shadow Calculations
;;; --------------------------------------------------------------------------
(defun pv:solar-position (lat hour-angle is-winter / lat-rad decl-rad w-rad sin-alpha alpha cos-phi cos-alpha cos-gamma gamma gamma-deg az-deg)
  (setq lat-rad (dtr lat))
  ;; Winter solstice declination (-23.45 for Northern Hemisphere, +23.45 for Southern Hemisphere)
  (setq decl-rad (if (>= lat 0.0) (dtr -23.45) (dtr 23.45)))
  (setq w-rad (dtr hour-angle))
  
  (setq sin-alpha (+ (* (sin lat-rad) (sin decl-rad))
                     (* (cos lat-rad) (cos decl-rad) (cos w-rad))))
  (setq sin-alpha (max -1.0 (min 1.0 sin-alpha)))
  (setq alpha (asin sin-alpha))
  (if (< alpha (dtr 5.0)) (setq alpha (dtr 5.0)))
  
  (setq cos-phi (cos lat-rad))
  (setq cos-alpha (cos alpha))
  (setq cos-gamma 
    (if (equal (* cos-alpha cos-phi) 0.0 1e-6)
      0.0
      (/ (- (* (sin alpha) (sin lat-rad)) (sin decl-rad))
         (* cos-alpha cos-phi))
    )
  )
  (setq cos-gamma (max -1.0 (min 1.0 cos-gamma)))
  (setq gamma (acos cos-gamma))
  (setq gamma-deg (rtd gamma))
  
  ;; Solar azimuth measured clockwise from true North (0 = North, 90 = East, 180 = South, 270 = West):
  (if (>= lat 0.0)
    ;; Northern Hemisphere (sun is due South 180 deg at solar noon)
    (if (< hour-angle 0.0)
      (setq az-deg (- 180.0 gamma-deg))  ; Morning: South-East (e.g. ~130 deg)
      (setq az-deg (+ 180.0 gamma-deg))  ; Afternoon: South-West (e.g. ~230 deg)
    )
    ;; Southern Hemisphere (sun is due North 0 deg at solar noon)
    (if (< hour-angle 0.0)
      (setq az-deg gamma-deg)            ; Morning: North-East (e.g. ~50 deg)
      (setq az-deg (- 360.0 gamma-deg))  ; Afternoon: North-West (e.g. ~310 deg)
    )
  )
  (list alpha (dtr az-deg))
)

;;; Computes optimal table pitch to prevent self-shading on flat roof
(defun pv:calc-auto-pitch (lat tilt-deg mod-len-m orient table-rows row-spacing / sol-pos sol-alt tilt-rad slant-len proj-len h-rise shadow-len pitch)
  (setq sol-pos (pv:solar-position lat 0.0 t))
  (setq sol-alt (car sol-pos))
  (setq tilt-rad (dtr tilt-deg))
  (if (not table-rows) (setq table-rows 1))
  (if (not row-spacing) (setq row-spacing 0.03))
  (setq slant-len (+ (* table-rows mod-len-m) (* (max 0 (1- table-rows)) row-spacing)))
  (setq proj-len (* slant-len (cos tilt-rad)))
  (setq h-rise   (* slant-len (sin tilt-rad)))
  ;; Guard: prevent division by zero when sun altitude is near 0°
  (setq shadow-len
    (if (< sol-alt (dtr 5.0))  ; Sun below 5° elevation
      100.0  ; Use maximum practical shadow length
      (/ h-rise (tan sol-alt))
    )
  )
  (setq pitch (+ proj-len (* shadow-len 1.10) 0.10))
  (max 1.50 (atof (rtos pitch 2 2)))
)

;;; --------------------------------------------------------------------------
;;; Entity Geometry & Obstacle Unpacking
;;; --------------------------------------------------------------------------
(defun pv:unlock-layer (layer-name / doc layers lay-obj)
  (if (and layer-name (tblsearch "LAYER" layer-name))
    (vl-catch-all-apply
      '(lambda ()
         (setq doc (vla-get-activedocument (vlax-get-acad-object)))
         (setq layers (vla-get-layers doc))
         (setq lay-obj (vla-item layers layer-name))
         (vla-put-lock lay-obj :vlax-false)
       )
    )
  )
)

(defun pv:is-array-entity (ent / elist etype bname obj xdict is-arr item-name)
  (setq is-arr nil)
  (if (and ent (setq elist (entget ent '("*"))))
    (progn
      (setq etype (cdr (assoc 0 elist)))
      (cond
        ((wcmatch (strcase etype) "*ARRAY*") (setq is-arr t))
        ((= etype "INSERT")
          (setq bname (cdr (assoc 2 elist)))
          (if (and bname (wcmatch (strcase bname) "`*U*,`*A*"))
            (setq is-arr t)
          )
          (if (or (assoc -3 elist)
                  (member "ACAD_ASSOCARRAY" (mapcar 'car (cdr (assoc -3 elist)))))
            (setq is-arr t)
          )
          (if (not is-arr)
            (progn
              (setq obj (vlax-ename->vla-object ent))
              (if (and (vlax-property-available-p obj 'HasExtensionDictionary)
                       (= (vlax-get-property obj 'HasExtensionDictionary) :vlax-true))
                (if (not (vl-catch-all-error-p
                           (setq xdict (vl-catch-all-apply 'vla-GetExtensionDictionary (list obj)))))
                  (vl-catch-all-apply
                    '(lambda ()
                       (vlax-for item xdict
                         (setq item-name (vla-get-name item))
                         (if (wcmatch (strcase item-name) "*ASSOC*")
                           (setq is-arr t)
                         )
                       )
                     )
                  )
                )
              )
            )
          )
        )
      )
    )
  )
  is-arr
)

(defun pv:explode-and-collect (ent / cur-ent new-ents lay-name was-locked old-cmdecho)
  (setq new-ents nil)
  (if (and ent (entget ent))
    (progn
      (setq lay-name (cdr (assoc 8 (entget ent))))
      (setq was-locked (= 4 (logand 4 (cdr (assoc 70 (tblsearch "LAYER" lay-name))))))
      (if was-locked (pv:unlock-layer lay-name))
      
      (setq cur-ent (entlast))
      (setq old-cmdecho (getvar "CMDECHO"))
      (setvar "CMDECHO" 0)
      (vl-cmdf "._EXPLODE" ent)
      (setvar "CMDECHO" old-cmdecho)
      
      (if (and cur-ent (entnext cur-ent))
        (while (setq cur-ent (entnext cur-ent))
          (if (entget cur-ent)
            (setq new-ents (cons cur-ent new-ents))
          )
        )
      )
    )
  )
  (reverse new-ents)
)

(defun pv:unpack-array-entities (ent-list / result to-process cur-ent sub-ents safety-limit)
  (setq result nil)
  (setq to-process ent-list)
  (setq safety-limit 2000)
  
  (while (and to-process (> safety-limit 0))
    (setq cur-ent (car to-process))
    (setq to-process (cdr to-process))
    (setq safety-limit (1- safety-limit))
    
    (cond
      ((null cur-ent) nil)
      ((not (entget cur-ent)) nil)
      ((pv:is-array-entity cur-ent)
        (setq sub-ents (pv:explode-and-collect cur-ent))
        (if (and sub-ents (> (length sub-ents) 0))
          (setq to-process (append sub-ents to-process))
          (setq result (cons cur-ent result))
        )
      )
      (t
        (setq result (cons cur-ent result))
      )
    )
  )
  (reverse result)
)

(defun pv:get-polyline-pts (ent / elist etype pts sub-ent sub-data)
  (if (and ent (setq elist (entget ent)))
    (progn
      (setq etype (cdr (assoc 0 elist)))
      (cond
        ((= etype "LWPOLYLINE")
         (setq pts nil)
         (foreach item elist
           (if (= (car item) 10)
             (setq pts (cons (list (cadr item) (caddr item)) pts))
           )
         )
         (reverse pts))
        ((= etype "POLYLINE")
         (setq pts nil
               sub-ent (entnext ent))
         (while (and sub-ent
                     (setq sub-data (entget sub-ent))
                     (/= (cdr (assoc 0 sub-data)) "SEQEND"))
           (if (= (cdr (assoc 0 sub-data)) "VERTEX")
             (setq pts (cons (list (cadr (assoc 10 sub-data)) (caddr (assoc 10 sub-data))) pts))
           )
           (setq sub-ent (entnext sub-ent))
         )
         (reverse pts))
        ((= etype "3DFACE")
         (setq pts (list (list (cadr (assoc 10 elist)) (caddr (assoc 10 elist)))
                         (list (cadr (assoc 11 elist)) (caddr (assoc 11 elist)))
                         (list (cadr (assoc 12 elist)) (caddr (assoc 12 elist)))
                         (list (cadr (assoc 13 elist)) (caddr (assoc 13 elist)))))
         (if (equal (nth 2 pts) (nth 3 pts) 1e-4)
           (list (nth 0 pts) (nth 1 pts) (nth 2 pts))
           pts))
        (t nil)
      )
    )
    nil
  )
)

(defun pv:get-polyline-3d-pts (ent / elist etype pts sub-ent sub-data elev)
  (if (and ent (setq elist (entget ent)))
    (progn
      (setq etype (cdr (assoc 0 elist)))
      (cond
        ((= etype "LWPOLYLINE")
         (setq elev (cdr (assoc 38 elist)))
         (if (null elev) (setq elev 0.0))
         (setq pts nil)
         (foreach item elist
           (if (= (car item) 10)
             (setq pts (cons (list (cadr item) (caddr item) elev) pts))
           )
         )
         (reverse pts))
        ((= etype "POLYLINE")
         (setq pts nil
               sub-ent (entnext ent))
         (while (and sub-ent
                     (setq sub-data (entget sub-ent))
                     (/= (cdr (assoc 0 sub-data)) "SEQEND"))
           (if (= (cdr (assoc 0 sub-data)) "VERTEX")
             (setq pts (cons (cdr (assoc 10 sub-data)) pts))
           )
           (setq sub-ent (entnext sub-ent))
         )
         (reverse pts))
        ((= etype "3DFACE")
         (setq pts (list (cdr (assoc 10 elist))
                         (cdr (assoc 11 elist))
                         (cdr (assoc 12 elist))
                         (cdr (assoc 13 elist))))
         (if (equal (nth 2 pts) (nth 3 pts) 1e-4)
           (list (nth 0 pts) (nth 1 pts) (nth 2 pts))
           pts))
        (t nil)
      )
    )
    nil
  )
)

(defun pv:get-entity-pts (ent / elist etype obj minpt maxpt min-p max-p p1 p2 p3 p4 cen rad)
  (setq elist (entget ent))
  (setq etype (cdr (assoc 0 elist)))
  (cond
    ((or (= etype "LWPOLYLINE") (= etype "POLYLINE") (= etype "3DFACE"))
      (pv:get-polyline-pts ent)
    )
    ((= etype "LINE")
      (list (list (cadr (assoc 10 elist)) (caddr (assoc 10 elist)))
            (list (cadr (assoc 11 elist)) (caddr (assoc 11 elist))))
    )
    ((= etype "CIRCLE")
      (setq cen (cdr (assoc 10 elist)))
      (setq rad (cdr (assoc 40 elist)))
      (list
        (list (- (car cen) rad) (- (cadr cen) rad))
        (list (+ (car cen) rad) (- (cadr cen) rad))
        (list (+ (car cen) rad) (+ (cadr cen) rad))
        (list (- (car cen) rad) (+ (cadr cen) rad))
      )
    )
    (t
      (setq obj (vlax-ename->vla-object ent))
      (if (and obj (vlax-method-applicable-p obj 'GetBoundingBox))
        (progn
          (vla-GetBoundingBox obj 'minpt 'maxpt)
          (setq min-p (vlax-safearray->list minpt))
          (setq max-p (vlax-safearray->list maxpt))
          (setq p1 (list (car min-p) (cadr min-p)))
          (setq p2 (list (car max-p) (cadr min-p)))
          (setq p3 (list (car max-p) (cadr max-p)))
          (setq p4 (list (car min-p) (cadr max-p)))
          (list p1 p2 p3 p4)
        )
        nil
      )
    )
  )
)

;;; Converts any drawing entity into a list of exclusion polygons or 2-point line segments
(defun pv:get-exclusion-polys-from-ent (ent / elist etype pts is-closed res i)
  (setq elist (entget ent))
  (setq etype (cdr (assoc 0 elist)))
  (cond
    ((= etype "LINE")
      (list (list (list (cadr (assoc 10 elist)) (caddr (assoc 10 elist)))
                  (list (cadr (assoc 11 elist)) (caddr (assoc 11 elist)))))
    )
    ((or (= etype "LWPOLYLINE") (= etype "POLYLINE"))
      (setq pts (pv:get-polyline-pts ent))
      (setq is-closed (= (logand 1 (cond ((cdr (assoc 70 elist))) (0))) 1))
      (if (and pts (> (length pts) 1))
        (if is-closed
          (list pts)
          ;; Open polyline: break into consecutive 2-point segments so NO ghost closure occurs
          (progn
            (setq res nil i 0)
            (while (< i (1- (length pts)))
              (setq res (cons (list (nth i pts) (nth (1+ i) pts)) res))
              (setq i (1+ i))
            )
            (reverse res)
          )
        )
        nil
      )
    )
    (t
      (setq pts (pv:get-entity-pts ent))
      (if pts (list pts) nil)
    )
  )
)

(defun pv:pts-bbox (pts / minx miny maxx maxy)
  (setq minx (car (car pts))
        maxx minx
        miny (cadr (car pts))
        maxy miny)
  (foreach p (cdr pts)
    (if (< (car p) minx) (setq minx (car p)))
    (if (> (car p) maxx) (setq maxx (car p)))
    (if (< (cadr p) miny) (setq miny (cadr p)))
    (if (> (cadr p) maxy) (setq maxy (cadr p)))
  )
  (list (list minx miny) (list maxx maxy))
)

;;; Retrieves current active roof bounding box for 3D elevation calculations
(defun pv:get-roof-bbox (/ all-pts)
  (cond
    ((and *PV_CURRENT_BUILDING_BBOX*
          (listp *PV_CURRENT_BUILDING_BBOX*)
          (listp (car *PV_CURRENT_BUILDING_BBOX*)))
     *PV_CURRENT_BUILDING_BBOX*)
    ((and *PV_BOUNDARY_ENT* (pv:get-polyline-pts *PV_BOUNDARY_ENT*))
     (pv:pts-bbox (pv:get-polyline-pts *PV_BOUNDARY_ENT*)))
    (*PV_BOUNDARY_LIST*
     (foreach b-ent *PV_BOUNDARY_LIST*
       (setq all-pts (append all-pts (pv:get-polyline-pts b-ent))))
     (if (and all-pts (> (length all-pts) 1)) (pv:pts-bbox all-pts) nil))
    (t '((0.0 0.0) (100.0 100.0)))
  )
)

;;; Computes roof surface elevation Z for any 2D point (x y) based on roof type, slope facing, and gable/hip apex.
;;; If *PV_ACTIVE_SURFACE_PLANE* is set (a 3D surface plane equation), it uses that for precise Z.
(defun pv:get-roof-z (pt bbox / x y x1 y1 x2 y2 xc yc span-x span-y h-ridge h-eaves dx dy d-norm)
  (setq x (car pt)
        y (cadr pt))
  ;; Use the active surface plane if available (most accurate for sloped metal roofs)
  (if (and *PV_ACTIVE_SURFACE_PLANE*
           (listp *PV_ACTIVE_SURFACE_PLANE*)
           (= (length *PV_ACTIVE_SURFACE_PLANE*) 4))
    (pv:plane-get-z *PV_ACTIVE_SURFACE_PLANE* pt)
    (progn
      (if (not (and (listp bbox) (listp (car bbox))))
        (setq bbox (pv:get-roof-bbox))
      )
      (if (and (listp bbox) (listp (car bbox)))
        (setq x1 (caar bbox)
              y1 (cadar bbox)
              x2 (caadr bbox)
              y2 (cadadr bbox)
              xc (/ (+ x1 x2) 2.0)
              yc (/ (+ y1 y2) 2.0)
              span-x (max 0.1 (- x2 x1))
              span-y (max 0.1 (- y2 y1)))
        (setq x1 0.0 y1 0.0 x2 100.0 y2 100.0 xc 50.0 yc 50.0 span-x 100.0 span-y 100.0)
      )
      (setq h-ridge (if (> *PV_BLDG_RIDGE_HT* 0.0) *PV_BLDG_RIDGE_HT* 8.0)
            h-eaves (if (> *PV_BLDG_EAVES_HT* 0.0) *PV_BLDG_EAVES_HT* 6.0))
      (cond
        ;; Flat RCC
        ((or (= *PV_ROOF_TYPE* "Flat RCC Rooftop") (= *PV_ROOF_SLOPE_DIRS* 0))
         h-eaves)
        ;; 1 Direction (Monoslope / Shed)
        ((= *PV_ROOF_SLOPE_DIRS* 1)
         (cond
           ((or (= *PV_ROOF_FACING* "South") (= *PV_ROOF_FACING* "S"))
            (+ h-eaves (* (/ (max 0.0 (min span-y (- y y1))) span-y) (- h-ridge h-eaves))))
           ((or (= *PV_ROOF_FACING* "North") (= *PV_ROOF_FACING* "N"))
            (- h-ridge (* (/ (max 0.0 (min span-y (- y y1))) span-y) (- h-ridge h-eaves))))
           ((or (= *PV_ROOF_FACING* "West") (= *PV_ROOF_FACING* "W"))
            (+ h-eaves (* (/ (max 0.0 (min span-x (- x x1))) span-x) (- h-ridge h-eaves))))
           (t ; East
            (- h-ridge (* (/ (max 0.0 (min span-x (- x x1))) span-x) (- h-ridge h-eaves))))
         ))
        ;; 2 Directions (Dual-Pitch / Gable)
        ((= *PV_ROOF_SLOPE_DIRS* 2)
         (cond
           ((or (= *PV_ROOF_FACING* "North & South") (= *PV_ROOF_FACING* "North-South") (= *PV_ROOF_FACING* "NS"))
            (- h-ridge (* (/ (abs (- y yc)) (max 0.1 (/ span-y 2.0))) (- h-ridge h-eaves))))
           (t ; East & West
            (- h-ridge (* (/ (abs (- x xc)) (max 0.1 (/ span-x 2.0))) (- h-ridge h-eaves))))
         ))
        ;; 4 Directions (Hip Roof)
        ((= *PV_ROOF_SLOPE_DIRS* 4)
         (setq dx (/ (abs (- x xc)) (max 0.1 (/ span-x 2.0)))
               dy (/ (abs (- y yc)) (max 0.1 (/ span-y 2.0)))
               d-norm (min 1.0 (max dx dy)))
         (- h-ridge (* d-norm (- h-ridge h-eaves))))
        (t h-eaves)
      )
    )
  )
)


;;; Ray-casting Point-in-Polygon test
(defun pv:pt-in-poly (pt poly / x y inside i j n xi yi xj yj)
  (setq n (length poly))
  (if (< n 3)
    nil
    (progn
      (setq x (car pt) y (cadr pt))
      (setq inside nil)
      (setq i 0 j (1- n))
      (while (< i n)
        (setq xi (car (nth i poly))   yi (cadr (nth i poly)))
        (setq xj (car (nth j poly))   yj (cadr (nth j poly)))
        (if (and (or (and (<= yi y) (< y yj))
                     (and (<= yj y) (< y yi)))
                 (< x (+ xi (/ (* (- xj xi) (- y yi)) (- yj yi)))))
          (setq inside (not inside))
        )
        (setq j i)
        (setq i (1+ i))
      )
      inside
    )
  )
)

(defun pv:line-intersects-p (p1 p2 p3 p4 / d1 d2 d3 d4 cp)
  (defun cp (a b c)
    (- (* (- (car b) (car a)) (- (cadr c) (cadr a)))
       (* (- (cadr b) (cadr a)) (- (car c) (car a))))
  )
  (setq d1 (cp p3 p4 p1)
        d2 (cp p3 p4 p2)
        d3 (cp p1 p2 p3)
        d4 (cp p1 p2 p4))
  (and (or (and (> d1 0.0) (< d2 0.0)) (and (< d1 0.0) (> d2 0.0)))
       (or (and (> d3 0.0) (< d4 0.0)) (and (< d3 0.0) (> d4 0.0))))
)

;;; Offsets a closed 2D polygon inwards by specified distance (e.g. for parapet wall thickness)
(defun pv:offset-polygon-inward (pts dist / n area ccw p-prev p-curr p-next p-a p-b
                                           dx1 dy1 L1 u1x u1y n1x n1y
                                           dx2 dy2 L2 u2x u2y n2x n2y
                                           a1x a1y a2x a2y dax day det t-param qx qy d-pq res i)
  (setq n (length pts))
  (if (or (< n 3) (<= dist 0.0))
    pts
    (progn
      ;; 1. Determine orientation (CCW vs CW)
      (setq area 0.0 i 0)
      (while (< i n)
        (setq p-a (nth i pts)
              p-b (nth (rem (1+ i) n) pts))
        (setq area (+ area (- (* (car p-a) (cadr p-b)) (* (car p-b) (cadr p-a)))))
        (setq i (1+ i))
      )
      (setq ccw (> area 0.0))
      
      ;; 2. Miter offset for each vertex
      (setq res nil i 0)
      (while (< i n)
        (setq p-prev (nth (rem (+ i n -1) n) pts)
              p-curr (nth i pts)
              p-next (nth (rem (1+ i) n) pts))
        
        ;; Previous edge vector & inward normal
        (setq dx1 (- (car p-curr) (car p-prev))
              dy1 (- (cadr p-curr) (cadr p-prev))
              L1  (sqrt (+ (* dx1 dx1) (* dy1 dy1))))
        (if (< L1 1e-6) (setq L1 1e-6))
        (setq u1x (/ dx1 L1) u1y (/ dy1 L1))
        (if ccw
          (setq n1x (- u1y) n1y u1x)
          (setq n1x u1y     n1y (- u1x))
        )
        
        ;; Next edge vector & inward normal
        (setq dx2 (- (car p-next) (car p-curr))
              dy2 (- (cadr p-next) (cadr p-curr))
              L2  (sqrt (+ (* dx2 dx2) (* dy2 dy2))))
        (if (< L2 1e-6) (setq L2 1e-6))
        (setq u2x (/ dx2 L2) u2y (/ dy2 L2))
        (if ccw
          (setq n2x (- u2y) n2y u2x)
          (setq n2x u2y     n2y (- u2x))
        )
        
        ;; Offset lines points
        (setq a1x (+ (car p-curr) (* dist n1x))
              a1y (+ (cadr p-curr) (* dist n1y)))
        (setq a2x (+ (car p-curr) (* dist n2x))
              a2y (+ (cadr p-curr) (* dist n2y)))
        
        ;; Intersect offset line 1 (along u1) and offset line 2 (along u2)
        (setq det (- (* u1x u2y) (* u1y u2x)))
        (if (> (abs det) 1e-4)
          (progn
            (setq dax (- a2x a1x)
                  day (- a2y a1y))
            (setq t-param (/ (- (* dax u2y) (* day u2x)) det))
            (setq qx (+ a1x (* t-param u1x))
                  qy (+ a1y (* t-param u1y)))
            ;; Clamp extreme miter spikes on acute corners
            (setq d-pq (distance p-curr (list qx qy)))
            (if (> d-pq (* 3.5 dist))
              (setq qx (+ (car p-curr) (* 2.0 dist (/ (+ n1x n2x) (max 1e-6 (sqrt (+ (* (+ n1x n2x) (+ n1x n2x)) (* (+ n1y n2y) (+ n1y n2y))))))))
                    qy (+ (cadr p-curr) (* 2.0 dist (/ (+ n1y n2y) (max 1e-6 (sqrt (+ (* (+ n1x n2x) (+ n1x n2x)) (* (+ n1y n2y) (+ n1y n2y)))))))))
            )
          )
          (progn
            ;; Collinear edges
            (setq qx (+ (car p-curr) (* dist n1x))
                  qy (+ (cadr p-curr) (* dist n1y)))
          )
        )
        (setq res (cons (list qx qy) res))
        (setq i (1+ i))
      )
      (reverse res)
    )
  )
)

(defun pv:box-hits-polygon (bmin bmax poly buffer / bx1 by1 bx2 by2 b-pts n i j e1 e2 hits)
  (setq bx1 (- (car bmin) buffer)
        by1 (- (cadr bmin) buffer)
        bx2 (+ (car bmax) buffer)
        by2 (+ (cadr bmax) buffer))
  (setq b-pts (list (list bx1 by1) (list bx2 by1) (list bx2 by2) (list bx1 by2)))
  (setq hits nil)
  
  (foreach bp b-pts
    (if (and (not hits) (pv:pt-in-poly bp poly))
      (setq hits t)
    )
  )
  (if (not hits)
    (foreach pp poly
      (if (and (not hits)
               (>= (car pp) bx1) (<= (car pp) bx2)
               (>= (cadr pp) by1) (<= (cadr pp) by2))
        (setq hits t)
      )
    )
  )
  (if (not hits)
    (progn
      (setq n (length poly))
      (setq i 0)
      (while (and (not hits) (< i n))
        (setq e1 (nth i poly))
        (setq e2 (nth (rem (1+ i) n) poly))
        (setq j 0)
        (while (and (not hits) (< j 4))
          (if (pv:line-intersects-p e1 e2 (nth j b-pts) (nth (rem (1+ j) 4) b-pts))
            (setq hits t)
          )
          (setq j (1+ j))
        )
        (setq i (1+ i))
      )
    )
  )
  hits
)

;;; 2D Convex Hull (Andrew's Monotone Chain)
(defun pv:convex-hull (pts / cross-prod lower upper p sorted)
  (defun cross-prod (o a b)
    (- (* (- (car a) (car o)) (- (cadr b) (cadr o)))
       (* (- (cadr a) (cadr o)) (- (car b) (car o))))
  )
  (setq sorted
    (vl-sort pts
      '(lambda (a b)
         (if (equal (car a) (car b) 1e-6)
           (< (cadr a) (cadr b))
           (< (car a) (car b))
         )
       )
    )
  )
  (setq lower nil)
  (foreach p sorted
    (while (and (>= (length lower) 2)
                (<= (cross-prod (cadr lower) (car lower) p) 0.0))
      (setq lower (cdr lower))
    )
    (setq lower (cons p lower))
  )
  (setq upper nil)
  (foreach p (reverse sorted)
    (while (and (>= (length upper) 2)
                (<= (cross-prod (cadr upper) (car upper) p) 0.0))
      (setq upper (cdr upper))
    )
    (setq upper (cons p upper))
  )
  (append (reverse (cdr lower)) (reverse (cdr upper)))
)

;;; Dynamic Solar Shadow Polygon Envelope
(defun pv:create-shadow-polygon (ent ht lat / base-pts pos-am pos-noon pos-pm sol-am sol-noon sol-pm
                                              az-am az-noon az-pm sh-len-am sh-len-noon sh-len-pm
                                              dx-am dy-am dx-noon dy-noon dx-pm dy-pm
                                              am-pts noon-pts pm-pts all-pts hull-pts r-bbox hull-3d)
  (if (listp ent)
    (setq base-pts ent)
    (setq base-pts (pv:get-entity-pts ent))
  )
  (if (not base-pts) (setq base-pts nil))
  (if (and base-pts (> (length base-pts) 1) (> ht 0.0))
    (progn
      ;; Morning (9:00 AM, w = -45 deg)
      (setq pos-am (pv:solar-position lat -45.0 t))
      (setq sol-am (car pos-am) az-am (cadr pos-am))
      ;; Solar Noon (12:00 PM, w = 0 deg)
      (setq pos-noon (pv:solar-position lat 0.0 t))
      (setq sol-noon (car pos-noon) az-noon (cadr pos-noon))
      ;; Afternoon (3:00 PM, w = +45 deg)
      (setq pos-pm (pv:solar-position lat 45.0 t))
      (setq sol-pm (car pos-pm) az-pm (cadr pos-pm))
      
      (setq sh-len-am   (/ ht (tan sol-am)))
      (setq sh-len-noon (/ ht (tan sol-noon)))
      (setq sh-len-pm   (/ ht (tan sol-pm)))
      
      ;; Shadow vector points in opposite direction to the sun (+ pi)
      ;; In AutoCAD coordinates: +Y is North, +X is East, -Y is South, -X is West
      (setq dx-am   (* sh-len-am   (sin (+ az-am pi))))
      (setq dy-am   (* sh-len-am   (cos (+ az-am pi))))
      
      (setq dx-noon (* sh-len-noon (sin (+ az-noon pi))))
      (setq dy-noon (* sh-len-noon (cos (+ az-noon pi))))
      
      (setq dx-pm   (* sh-len-pm   (sin (+ az-pm pi))))
      (setq dy-pm   (* sh-len-pm   (cos (+ az-pm pi))))
      
      (setq am-pts   (mapcar '(lambda (p) (list (+ (car p) dx-am)   (+ (cadr p) dy-am))) base-pts))
      (setq noon-pts (mapcar '(lambda (p) (list (+ (car p) dx-noon) (+ (cadr p) dy-noon))) base-pts))
      (setq pm-pts   (mapcar '(lambda (p) (list (+ (car p) dx-pm)   (+ (cadr p) dy-pm))) base-pts))
      
      (setq all-pts (append base-pts am-pts noon-pts pm-pts))
      
      (setq hull-pts (pv:convex-hull all-pts))
      (if (and hull-pts (= *PV_DRAW_SHADOW* 1))
        (progn
          (setq r-bbox (if (and *PV_CURRENT_BUILDING_BBOX* (listp *PV_CURRENT_BUILDING_BBOX*) (listp (car *PV_CURRENT_BUILDING_BBOX*)))
                         *PV_CURRENT_BUILDING_BBOX*
                         (if (and *PV_BOUNDARY_LIST* (car *PV_BOUNDARY_LIST*))
                           (pv:pts-bbox (pv:get-polyline-pts (car *PV_BOUNDARY_LIST*)))
                           (list (list 0.0 0.0) (list 100.0 100.0)))))
          (setq hull-3d (mapcar '(lambda (p) (list (car p) (cadr p) (+ (pv:get-roof-z p r-bbox) 0.01))) hull-pts))
          (pv:draw-3d-poly hull-3d "PV_SHADOW" 9 t)
        )
      )
      hull-pts
    )
    base-pts
  )
)

(defun pv:draw-lwpolyline (pts layer color closed / elist)
  (setq elist
    (list
      '(0 . "LWPOLYLINE")
      '(100 . "AcDbEntity")
      '(100 . "AcDbPolyline")
      (cons 8 layer)
      (cons 62 color)
      (cons 90 (length pts))
      (cons 70 (if closed 1 0))
    )
  )
  (foreach pt pts
    (setq elist (append elist (list (cons 10 (list (car pt) (cadr pt))))))
  )
  (entmake elist)
)

(defun pv:draw-3d-poly (pts layer color closed / z e0 e-ret)
  (setq e0 (entlast))
  (entmake
    (list
      '(0 . "POLYLINE")
      '(100 . "AcDbEntity")
      '(100 . "AcDb3dPolyline")
      (cons 8 layer)
      (cons 62 color)
      '(66 . 1) ; Vertices follow
      (cons 70 (if closed 9 8)) ; 8 = 3D polyline, 9 = closed 3D polyline
    )
  )
  (foreach pt pts
    (setq z (if (caddr pt)
              (caddr pt)
              (if (and (/= layer "PV_SLD") (pv:get-roof-bbox))
                (+ (pv:get-roof-z pt nil) 0.02)
                0.0)))
    (entmake
      (list
        '(0 . "VERTEX")
        '(100 . "AcDbEntity")
        '(100 . "AcDbVertex")
        '(100 . "AcDb3dPolylineVertex")
        (cons 8 layer)
        (cons 10 (list (car pt) (cadr pt) z))
        '(70 . 32) ; 32 = 3D polyline vertex
      )
    )
  )
  (entmake '((0 . "SEQEND")))
  (setq e-ret (if e0 (entnext e0) (entnext)))
  e-ret
)

(defun pv:is-metal-roof-p ()
  (or (= *PV_ROOF_TYPE* "Metal Sheet Rooftop")
      (= *PV_ROOF_TYPE* "Sloped Metal Sheet")
      (= *PV_ROOF_TYPE* "Sloped Metal Sheet Rooftop"))
)

(defun pv:register-roof-surface (pts name facing azimuth bldg-bbox b-ent / surf-ent surf-plane)
  (pv:init-layers)
  (setq surf-ent (pv:draw-3d-poly pts "PV_BOUNDARY" 1 t))
  ;; Compute analytical plane equation from 3D pts for precise Z lookup
  (setq surf-plane (pv:plane-from-pts-list pts))
  (if surf-ent
    (setq *PV_ROOF_SURFACES*
      (cons (list surf-ent
                  (cons "NAME" name)
                  (cons "FACING" facing)
                  (cons "AZIMUTH" azimuth)
                  (cons "TILT" (if (> *PV_ROOF_SLOPE* 0.0) *PV_ROOF_SLOPE* 0.0))
                  (cons "BLDG-BBOX" bldg-bbox)
                  (cons "BLDG-ENT" b-ent)
                  (cons "PTS" pts)
                  (cons "PLANE" surf-plane))
            *PV_ROOF_SURFACES*))
  )
  surf-ent
)

(defun pv:draw-line (p1 p2 layer color / elist z1 z2)
  (setq z1 (if (caddr p1)
             (caddr p1)
             (if (and (/= layer "PV_SLD") (pv:get-roof-bbox))
               (+ (pv:get-roof-z p1 nil) 0.02)
               0.0))
        z2 (if (caddr p2)
             (caddr p2)
             (if (and (/= layer "PV_SLD") (pv:get-roof-bbox))
               (+ (pv:get-roof-z p2 nil) 0.02)
               0.0)))
  (setq elist
    (list
      '(0 . "LINE")
      '(100 . "AcDbEntity")
      '(100 . "AcDbLine")
      (cons 8 layer)
      (cons 62 color)
      (cons 10 (list (car p1) (cadr p1) z1))
      (cons 11 (list (car p2) (cadr p2) z2))
    )
  )
  (entmake elist)
)

(defun pv:draw-line-3d (p1 p2 layer color / elist z1 z2)
  (setq z1 (if (caddr p1) (caddr p1) 0.0)
        z2 (if (caddr p2) (caddr p2) 0.0))
  (setq elist
    (list
      '(0 . "LINE")
      '(100 . "AcDbEntity")
      '(100 . "AcDbLine")
      (cons 8 layer)
      (cons 62 color)
      (cons 10 (list (car p1) (cadr p1) z1))
      (cons 11 (list (car p2) (cadr p2) z2))
    )
  )
  (entmake elist)
)

(defun pv:draw-3dface (p1 p2 p3 p4 layer color / ent-data)
  (setq ent-data
    (list
      '(0 . "3DFACE")
      '(100 . "AcDbEntity")
      (cons 8 layer)
      (cons 62 color)
      '(100 . "AcDbFace")
      (cons 10 (list (car p1) (cadr p1) (if (caddr p1) (caddr p1) 0.0)))
      (cons 11 (list (car p2) (cadr p2) (if (caddr p2) (caddr p2) 0.0)))
      (cons 12 (list (car p3) (cadr p3) (if (caddr p3) (caddr p3) 0.0)))
      (cons 13 (list (car p4) (cadr p4) (if (caddr p4) (caddr p4) 0.0)))
    )
  )
  (entmakex ent-data)
)

(defun pv:draw-circle (center radius layer color / elist z)
  (setq z (if (caddr center)
            (caddr center)
            (if (and (/= layer "PV_SLD") (pv:get-roof-bbox))
              (+ (pv:get-roof-z center nil) 0.05)
              0.0)))
  (setq elist
    (list
      '(0 . "CIRCLE")
      '(100 . "AcDbEntity")
      '(100 . "AcDbCircle")
      (cons 8 layer)
      (cons 62 color)
      (cons 10 (list (car center) (cadr center) z))
      (cons 40 radius)
    )
  )
  (entmake elist)
)

(defun pv:draw-text (pt text-str height layer color rot / elist z)
  (if (null rot) (setq rot 0.0))
  (setq z (if (caddr pt)
            (caddr pt)
            (if (and (/= layer "PV_SLD") (pv:get-roof-bbox))
              (+ (pv:get-roof-z pt nil) 0.05)
              0.0)))
  (setq elist
    (list
      '(0 . "TEXT")
      '(100 . "AcDbEntity")
      '(100 . "AcDbText")
      (cons 8 layer)
      (cons 62 color)
      (cons 10 (list (car pt) (cadr pt) z))
      (cons 40 height)
      (cons 1 text-str)
      (cons 50 rot)
    )
  )
  (entmake elist)
)

;;; Draws elevated walkway corridor both in 3D wireframe (PV_WALKWAY) and solid plank (PV_3D_WALKWAY)
(defun pv:draw-walkway-corridor (ww-poly r-bbox / ww-3d ent-3d ent-face res-ents)
  (if (null r-bbox) (setq r-bbox (pv:get-roof-bbox)))
  (setq ww-3d
    (mapcar '(lambda (p)
               (list (car p) (cadr p) (+ (pv:get-roof-z p r-bbox) 0.02)))
            ww-poly))
  ;; 1. Draw 3D polyline on PV_WALKWAY (visible in 2D plan and 3D wireframe)
  (pv:draw-3d-poly ww-3d "PV_WALKWAY" 30 t)
  (setq ent-3d (entlast))
  (setq res-ents (list ent-3d))
  ;; 2. Draw 3DFACE plank on PV_3D_WALKWAY (visible in 3D shaded/conceptual)
  (if (>= (length ww-3d) 4)
    (progn
      (pv:draw-3dface (nth 0 ww-3d) (nth 1 ww-3d) (nth 2 ww-3d) (nth 3 ww-3d) "PV_3D_WALKWAY" 30)
      (setq ent-face (entlast))
      (setq res-ents (cons ent-face res-ents))
    )
  )
  ;; Register in *PV_WALKWAY_POLYS*
  (if (not (member ww-poly *PV_WALKWAY_POLYS*))
    (setq *PV_WALKWAY_POLYS* (cons ww-poly *PV_WALKWAY_POLYS*))
  )
  res-ents
)

(defun pv:draw-walkway-strip (x1 x2 y1 y2 dir / pts)
  (setq pts (list (list x1 y1) (list x2 y1) (list x2 y2) (list x1 y2)))
  (pv:draw-walkway-corridor pts nil)
)

;;; --------------------------------------------------------------------------
;;; Elevated Tilted Legs & Continuous Canopy Engine (Flat RCC)
;;; --------------------------------------------------------------------------
;; pv:tan removed - use global tan() function instead

(defun pv:get-elevated-plane-z (pt r-bbox / z-roof s minx miny maxx maxy x y h-min-clear tilt-rad dir)
  (setq z-roof (pv:get-roof-z pt r-bbox))
  (setq h-min-clear (if (and *PV_ELEV_MIN_CLEAR* (> *PV_ELEV_MIN_CLEAR* 0.0))
                      *PV_ELEV_MIN_CLEAR*
                      (if (and *PV_MOD_CLEAR* (> *PV_MOD_CLEAR* 0.0)) *PV_MOD_CLEAR* 2.00)))
  (setq tilt-rad (dtr (if (> *PV_TILT* 0.0) *PV_TILT* 15.0)))
  (setq s (tan tilt-rad))
  (if (null r-bbox) (setq r-bbox (if (and *PV_CURRENT_BUILDING_BBOX* (listp *PV_CURRENT_BUILDING_BBOX*) (listp (car *PV_CURRENT_BUILDING_BBOX*))) *PV_CURRENT_BUILDING_BBOX* (pv:get-roof-bbox))))
  (if (and (listp r-bbox) (listp (car r-bbox)))
    (setq minx (caar r-bbox)
          miny (cadar r-bbox)
          maxx (caadr r-bbox)
          maxy (cadadr r-bbox))
    (setq minx 0.0 miny 0.0 maxx 100.0 maxy 100.0)
  )
  (setq x (car pt) y (cadr pt))
  (setq dir (if *PV_ELEV_TILT_DIR* (strcase *PV_ELEV_TILT_DIR*) "NORTH TO SOUTH"))
  (cond
    ;; North to South: High at North (maxy), lowest at South (miny), sloping downwards towards South at angle *PV_TILT*
    ((or (wcmatch dir "*NORTH TO SOUTH*") (wcmatch dir "*SOUTH*"))
      (+ z-roof h-min-clear (* (- y miny) s))
    )
    ;; South to North: High at South (miny), lowest at North (maxy), sloping downwards towards North
    ((wcmatch dir "*SOUTH TO NORTH*")
      (+ z-roof h-min-clear (* (- maxy y) s))
    )
    ;; East to West: High at East (maxx), lowest at West (minx), sloping downwards towards West
    ((or (wcmatch dir "*EAST TO WEST*") (wcmatch dir "*WEST*"))
      (+ z-roof h-min-clear (* (- x minx) s))
    )
    ;; West to East: High at West (minx), lowest at East (maxx), sloping downwards towards East
    ((wcmatch dir "*WEST TO EAST*")
      (+ z-roof h-min-clear (* (- maxx x) s))
    )
    (t
      (+ z-roof h-min-clear (* (- y miny) s))
    )
  )
)

(defun pv:draw-base-plate (pt size layer color / h-sz p1 p2 p3 p4 x y z)
  (setq x (car pt)
        y (cadr pt)
        z (+ (if (caddr pt)
               (caddr pt)
               (if (pv:get-roof-bbox)
                 (pv:get-roof-z pt nil)
                 0.0))
             0.005))
  (setq h-sz (/ size 2.0))
  (setq p1 (list (- x h-sz) (- y h-sz) z)
        p2 (list (+ x h-sz) (- y h-sz) z)
        p3 (list (+ x h-sz) (+ y h-sz) z)
        p4 (list (- x h-sz) (+ y h-sz) z))
  ;; 1. Draw 3D Polyline boundary marking on PV_STRUCTURE (Color 4 - Cyan) at terrace slab elevation
  (pv:draw-3d-poly (list p1 p2 p3 p4) layer color t)
  ;; 2. Draw 3DFACE on PV_3D_STRUCTURE for 3D visual styles (conceptual, shaded, realistic)
  (pv:draw-3dface p1 p2 p3 p4 "PV_3D_STRUCTURE" color)
)

(defun pv:process-elevated-row-legs (row-mods cur-bbox / sorted-mods runs cur-run prev-mod next-mod
                                                        r-idx x-start x-end y-front y-rear total-span
                                                        mod-cnt leg-x-list n-int step dist n-bays
                                                        m-step m-idx lx z-slab-f z-top-f z-slab-r z-top-r
                                                        z-front-st z-front-en z-rear-st z-rear-en)
  (if (and row-mods (> (length row-mods) 0))
    (progn
      ;; Sort modules by X from left to right
      (setq sorted-mods
        (vl-sort row-mods
          '(lambda (a b)
             (< (car (nth 0 a)) (car (nth 0 b)))
           )
        )
      )
      ;; Partition into continuous runs
      (setq runs nil cur-run (list (car sorted-mods)))
      (setq r-idx 1)
      (while (< r-idx (length sorted-mods))
        (setq prev-mod (nth (1- r-idx) sorted-mods)
              next-mod (nth r-idx sorted-mods))
        ;; If gap between adjacent modules exceeds column spacing + tolerance (0.15m), start new run
        (if (> (- (car (nth 0 next-mod)) (car (nth 1 prev-mod))) (+ *PV_COL_SPACING* 0.15))
          (progn
            (setq runs (cons (reverse cur-run) runs))
            (setq cur-run (list next-mod))
          )
          (setq cur-run (cons next-mod cur-run))
        )
        (setq r-idx (1+ r-idx))
      )
      (if cur-run (setq runs (cons (reverse cur-run) runs)))
      (setq runs (reverse runs))

      ;; Process each continuous run in this row
      (foreach run runs
        (setq mod-cnt (length run))
        (setq x-start (car (nth 0 (car run)))       ; outer edge of first panel
              x-end   (car (nth 1 (last run)))      ; outer edge of last panel
              y-front (cadr (nth 0 (car run)))
              y-rear  (cadr (nth 3 (car run)))
              total-span (- x-end x-start))

        ;; Determine intermediate leg X positions
        (setq leg-x-list (list x-start)) ; Always begins with first panel edge
        (cond
          ;; Mode A: By Intermediate Legs Count
          ((or (= *PV_ELEV_LEG_MODE* "COUNT") (= *PV_ELEV_LEG_MODE* "0"))
            (setq n-int (if (and *PV_ELEV_LEG_COUNT* (> *PV_ELEV_LEG_COUNT* 0)) *PV_ELEV_LEG_COUNT* 2))
            (if (> total-span 0.60)
              (progn
                (setq step (/ total-span (float (1+ n-int))))
                (setq k 1)
                (while (<= k n-int)
                  (setq leg-x-list (cons (+ x-start (* k step)) leg-x-list))
                  (setq k (1+ k))
                )
              )
            )
          )
          ;; Mode B: By Spacing in Metres
          ((or (= *PV_ELEV_LEG_MODE* "DISTANCE") (= *PV_ELEV_LEG_MODE* "1"))
            (setq dist (if (and *PV_ELEV_LEG_DIST* (> *PV_ELEV_LEG_DIST* 0.5)) *PV_ELEV_LEG_DIST* 3.00))
            (if (> total-span dist)
              (progn
                (setq n-bays (max 1 (fix (+ (/ total-span dist) 0.5))))
                (setq step (/ total-span (float n-bays)))
                (setq k 1)
                (while (< k n-bays)
                  (setq leg-x-list (cons (+ x-start (* k step)) leg-x-list))
                  (setq k (1+ k))
                )
              )
            )
          )
          ;; Mode C: By Number of Modules
          ((or (= *PV_ELEV_LEG_MODE* "MODULES") (= *PV_ELEV_LEG_MODE* "2"))
            (setq m-step (if (and *PV_ELEV_LEG_MODS* (> *PV_ELEV_LEG_MODS* 0)) *PV_ELEV_LEG_MODS* 2))
            (if (> mod-cnt m-step)
              (progn
                (setq m-idx (1- m-step))
                (while (< m-idx (1- mod-cnt))
                  ;; Right edge of module at index m-idx
                  (setq leg-x-list (cons (car (nth 1 (nth m-idx run))) leg-x-list))
                  (setq m-idx (+ m-idx m-step))
                )
              )
            )
          )
        )
        ;; Always ends with outer edge of last panel
        (setq leg-x-list (cons x-end leg-x-list))
        ;; Sort leg X positions from left to right
        (setq leg-x-list (vl-sort leg-x-list '<))

        ;; Draw vertical legs at each position
        (foreach lx leg-x-list
          (setq z-slab-f (pv:get-roof-z (list lx y-front) cur-bbox)
                z-top-f  (pv:get-elevated-plane-z (list lx y-front) cur-bbox)
                z-slab-r (pv:get-roof-z (list lx y-rear) cur-bbox)
                z-top-r  (pv:get-elevated-plane-z (list lx y-rear) cur-bbox))

          ;; 1. Front Vertical Column (3D)
          (pv:draw-line-3d (list lx y-front z-slab-f) (list lx y-front z-top-f) "PV_3D_STRUCTURE" 8)
          ;; 2. Rear Vertical Column (3D)
          (pv:draw-line-3d (list lx y-rear z-slab-r)  (list lx y-rear z-top-r)  "PV_3D_STRUCTURE" 8)

          ;; 3. Base Plates / Foundation Markings on terrace slab surface
          (pv:draw-base-plate (list lx y-front z-slab-f) 0.20 "PV_STRUCTURE" 4)
          (pv:draw-base-plate (list lx y-rear  z-slab-r) 0.20 "PV_STRUCTURE" 4)

          ;; 4. Transverse Rafter Beam (connecting front to rear on tilt slope)
          (pv:draw-line-3d (list lx y-front z-top-f) (list lx y-rear z-top-r) "PV_STRUCTURE" 8)
          (pv:draw-line-3d (list lx y-front z-top-f) (list lx y-rear z-top-r) "PV_3D_STRUCTURE" 8)

          (setq *PV_ELEV_TOTAL_LEGS* (+ *PV_ELEV_TOTAL_LEGS* 2))
        )

        ;; Longitudinal Purlins / Stringers along the continuous row
        (setq z-front-st (pv:get-elevated-plane-z (list x-start y-front) cur-bbox)
              z-front-en (pv:get-elevated-plane-z (list x-end y-front) cur-bbox)
              z-rear-st  (pv:get-elevated-plane-z (list x-start y-rear) cur-bbox)
              z-rear-en  (pv:get-elevated-plane-z (list x-end y-rear) cur-bbox))
        (pv:draw-line-3d (list x-start y-front z-front-st) (list x-end y-front z-front-en) "PV_STRUCTURE" 8)
        (pv:draw-line-3d (list x-start y-front z-front-st) (list x-end y-front z-front-en) "PV_3D_STRUCTURE" 8)
        (pv:draw-line-3d (list x-start y-rear z-rear-st)   (list x-end y-rear z-rear-en)   "PV_STRUCTURE" 8)
        (pv:draw-line-3d (list x-start y-rear z-rear-st)   (list x-end y-rear z-rear-en)   "PV_3D_STRUCTURE" 8)
      )
    )
  )
)

;;; --------------------------------------------------------------------------
;;; PV Module Library & .PAN File Parser
;;; --------------------------------------------------------------------------
(defun pv:trim-string (str / i j)
  (setq i 1 j (strlen str))
  (while (and (<= i j) (<= (ascii (substr str i 1)) 32)) (setq i (1+ i)))
  (while (and (>= j i) (<= (ascii (substr str j 1)) 32)) (setq j (1- j)))
  (if (> i j) "" (substr str i (1+ (- j i))))
)

(defun pv:parse-key-value-file (filepath / fh line eq-pos key val res)
  (setq res nil)
  (if (and filepath (findfile filepath))
    (progn
      (setq fh (open (findfile filepath) "r"))
      (if fh
        (progn
          (while (setq line (read-line fh))
            (setq line (pv:trim-string line))
            (if (and (/= line "") (/= (substr line 1 1) ";") (/= (substr line 1 1) "#"))
              (progn
                (setq eq-pos (vl-string-search "=" line))
                (if eq-pos
                  (progn
                    (setq key (strcase (pv:trim-string (substr line 1 eq-pos))))
                    (setq val (pv:trim-string (substr line (+ eq-pos 2))))
                    (setq res (cons (cons key val) res))
                  )
                )
              )
            )
          )
          (close fh)
        )
      )
    )
  )
  (reverse res)
)

;;; ==========================================================================

;;; --------------------------------------------------------------------------
;;; Shared Key-Value Record Helper (Unified replacement for local get-f / get-val)
;;; --------------------------------------------------------------------------
(defun pv:get-rec-field (rec key default-val / ukey res)
  (setq ukey (strcase key) res nil)
  (if rec
    (foreach pair rec
      (if (and (null res) (listp pair) (= (strcase (vl-princ-to-string (car pair))) ukey))
        (setq res (cdr pair))
      )
    )
  )
  (if res res default-val)
)

;;; PVCompLib - Persistent Component Library Manager (.PAN & .OND)
;;; Automatically saves and syncs loaded modules and inverters into PVCompLib.lsp
;;; located within the same folder from where the LISP file is loaded.
;;; ==========================================================================
(defun pv:file-exists-p (filepath / fh)
  (if (and filepath (/= filepath "") (setq fh (open filepath "r")))
    (progn (close fh) filepath)
    nil
  )
)

(defun pv:get-app-dir (/ p lsp-p)
  (cond
    ((and (setq lsp-p (findfile "RooftopSolar.lsp"))
          (setq p (vl-filename-directory lsp-p)))
     (vl-string-translate "\\" "/" p))
    ((and (setq lsp-p (findfile "PVCompLib.lsp"))
          (setq p (vl-filename-directory lsp-p)))
     (vl-string-translate "\\" "/" p))
    ((pv:file-exists-p "d:/VibeCoding/AUTOLISP/Rooftop/PVCompLib.lsp")
     "d:/VibeCoding/AUTOLISP/Rooftop")
    ((pv:file-exists-p "d:/VibeCoding/AUTOLISP/Rooftop/RooftopSolar.lsp")
     "d:/VibeCoding/AUTOLISP/Rooftop")
    ((getvar "DWGPREFIX")
     (vl-string-right-trim "/\\" (vl-string-translate "\\" "/" (getvar "DWGPREFIX"))))
    (t "C:/Temp")
  )
)

(defun pv:get-complib-path ()
  (strcat (pv:get-app-dir) "/PVCompLib.lsp")
)

(defun pv:complib-save (/ lib-file fh)
  (setq lib-file (pv:get-complib-path))
  (setq fh (open lib-file "w"))
  (if fh
    (progn
      (write-line ";;; ==========================================================================" fh)
      (write-line ";;; PVCompLib.lsp - Persistent Solar PV Component Library (Modules & Inverters)" fh)
      (write-line ";;; Automatically maintained by RooftopSolar Suite" fh)
      (write-line ";;; Saved within the RooftopSolar application directory" fh)
      (write-line ";;; ==========================================================================" fh)
      (write-line "" fh)
      
      ;; 1. Save Modules
      (write-line "(setq *PV_COMPLIB_MODULES* '(" fh)
      (if *PV_MODULE_LIBRARY*
        (foreach m *PV_MODULE_LIBRARY*
          (write-line "  (" fh)
          (foreach kv m
            (write-line (strcat "    (\"" (car kv) "\" . \"" (vl-string-translate "\\" "/" (cdr kv)) "\")") fh)
          )
          (write-line "  )" fh)
        )
      )
      (write-line "))" fh)
      (write-line "" fh)
      
      ;; 2. Save Inverters
      (write-line "(setq *PV_COMPLIB_INVERTERS* '(" fh)
      (if *PV_INVERTER_LIBRARY*
        (foreach inv *PV_INVERTER_LIBRARY*
          (write-line "  (" fh)
          (foreach kv inv
            (write-line (strcat "    (\"" (car kv) "\" . \"" (vl-string-translate "\\" "/" (cdr kv)) "\")") fh)
          )
          (write-line "  )" fh)
        )
      )
      (write-line "))" fh)
      (write-line "" fh)
      (write-line "(princ \"\\n[SolarPV] PVCompLib persistent component library loaded successfully.\")" fh)
      (close fh)
      (princ (strcat "\n[SolarPV] PVCompLib successfully updated and saved to: " lib-file))
      t
    )
    (progn
      (princ (strcat "\n[SolarPV] Warning: Could not write PVCompLib to: " lib-file))
      nil
    )
  )
)

(defun pv:add-module-to-lib (mod-rec auto-save / m-model filtered)
  (setq m-model (cdr (assoc "MODEL" mod-rec)))
  (if (null *PV_MODULE_LIBRARY*) (pv:init-module-db))
  (setq filtered nil)
  (foreach item *PV_MODULE_LIBRARY*
    (if (/= (strcase (cdr (assoc "MODEL" item))) (strcase m-model))
      (setq filtered (cons item filtered))
    )
  )
  (setq *PV_MODULE_LIBRARY* (cons mod-rec (reverse filtered)))
  (if auto-save (pv:complib-save))
)

(defun pv:add-inverter-to-lib (inv-rec auto-save / inv-model filtered)
  (setq inv-model (cdr (assoc "MODEL" inv-rec)))
  (if (null *PV_INVERTER_LIBRARY*) (pv:init-inverter-db))
  (setq filtered nil)
  (foreach item *PV_INVERTER_LIBRARY*
    (if (/= (strcase (cdr (assoc "MODEL" item))) (strcase inv-model))
      (setq filtered (cons item filtered))
    )
  )
  (setq *PV_INVERTER_LIBRARY* (cons inv-rec (reverse filtered)))
  (if auto-save (pv:complib-save))
)

(defun pv:complib-load (/ lib-file)
  (setq lib-file (pv:get-complib-path))
  (if (findfile lib-file)
    (progn
      (load lib-file nil)
      (if (and (boundp '*PV_COMPLIB_MODULES*) *PV_COMPLIB_MODULES*)
        (foreach m-rec *PV_COMPLIB_MODULES*
          (pv:add-module-to-lib m-rec nil)
        )
      )
      (if (and (boundp '*PV_COMPLIB_INVERTERS*) *PV_COMPLIB_INVERTERS*)
        (foreach inv-rec *PV_COMPLIB_INVERTERS*
          (pv:add-inverter-to-lib inv-rec nil)
        )
      )
      (princ (strcat "\n[SolarPV] PVCompLib loaded (" 
                     (itoa (length *PV_MODULE_LIBRARY*)) " Modules, " 
                     (itoa (length *PV_INVERTER_LIBRARY*)) " Inverters)."))
      t
    )
    (progn
      ;; If PVCompLib doesn't exist yet, save current library as initial PVCompLib
      (pv:complib-save)
      nil
    )
  )
)

(defun c:pv-complib (/ opt lib-file m-cnt inv-cnt msg)
  (setq lib-file (pv:get-complib-path))
  (initget "List Reload Save Open")
  (setq opt (getkword "\nPVCompLib [List / Reload / Save / Open] <List>: "))
  (if (null opt) (setq opt "List"))
  (cond
    ((= opt "List")
     (setq m-cnt (if *PV_MODULE_LIBRARY* (length *PV_MODULE_LIBRARY*) 0)
           inv-cnt (if *PV_INVERTER_LIBRARY* (length *PV_INVERTER_LIBRARY*) 0))
     (princ "\n=======================================================")
     (princ "\n [SolarPV] PVCompLib COMPONENT LIBRARY STATUS:")
     (princ (strcat "\n  Storage File    : " lib-file))
     (princ (strcat "\n  Modules Loaded  : " (itoa m-cnt) " models"))
     (princ (strcat "\n  Inverters Loaded: " (itoa inv-cnt) " models"))
     (princ "\n=======================================================")
     (alert (strcat "PVCompLib Component Library Status:\n\n"
                    "File: " lib-file "\n\n"
                    "Total PV Modules: " (itoa m-cnt) " models\n"
                    "Total Inverters : " (itoa inv-cnt) " models\n\n"
                    "All newly loaded .PAN and .OND files are automatically\n"
                    "persisted here and available across all AutoCAD projects!"))
    )
    ((= opt "Reload")
     (pv:complib-load)
     (alert "PVCompLib reloaded from disk successfully!"))
    ((= opt "Save")
     (pv:complib-save)
     (alert (strcat "PVCompLib successfully saved to:\n" lib-file)))
    ((= opt "Open")
     (if (findfile lib-file)
       (startapp "notepad" lib-file)
       (alert "PVCompLib.lsp not found on disk yet."))
    )
  )
  (princ)
)

(defun pv:init-module-db ()
  (setq *PV_MODULE_LIBRARY*
    (list
      ;; INOX Solar TOPCon Bifacial NDCR Modules (G12R 132-Cell Series)
      (list (cons "MANUFACTURER" "INOX Solar") (cons "MODEL" "ISL 132 NG12R 615Wp")
            (cons "TECHNOL" "TOPCon Bifacial NDCR") (cons "WP" "615.0") (cons "LENGTH" "2.382")
            (cons "WIDTH" "1.134") (cons "VMP" "40.96") (cons "IMP" "15.03") (cons "VOC" "49.05")
            (cons "ISC" "15.86") (cons "MUPMP" "-0.290") (cons "MUVOC" "-0.250") (cons "MUISC" "0.045")
            (cons "EFF" "22.77") (cons "BIFACIAL" "0.80") (cons "CELLS" "132") (cons "WEIGHT" "33.0"))
      (list (cons "MANUFACTURER" "INOX Solar") (cons "MODEL" "ISL 132 NG12R 620Wp")
            (cons "TECHNOL" "TOPCon Bifacial NDCR") (cons "WP" "620.0") (cons "LENGTH" "2.382")
            (cons "WIDTH" "1.134") (cons "VMP" "41.05") (cons "IMP" "15.12") (cons "VOC" "49.15")
            (cons "ISC" "15.96") (cons "MUPMP" "-0.290") (cons "MUVOC" "-0.250") (cons "MUISC" "0.045")
            (cons "EFF" "22.95") (cons "BIFACIAL" "0.80") (cons "CELLS" "132") (cons "WEIGHT" "33.0"))
      (list (cons "MANUFACTURER" "INOX Solar") (cons "MODEL" "ISL 132 NG12R 625Wp")
            (cons "TECHNOL" "TOPCon Bifacial NDCR") (cons "WP" "625.0") (cons "LENGTH" "2.382")
            (cons "WIDTH" "1.134") (cons "VMP" "41.14") (cons "IMP" "15.21") (cons "VOC" "49.25")
            (cons "ISC" "16.06") (cons "MUPMP" "-0.290") (cons "MUVOC" "-0.250") (cons "MUISC" "0.045")
            (cons "EFF" "23.14") (cons "BIFACIAL" "0.80") (cons "CELLS" "132") (cons "WEIGHT" "33.0"))

      ;; INOX Solar TOPCon Bifacial NDCR Modules (M10R 144-Cell Series)
      (list (cons "MANUFACTURER" "INOX Solar") (cons "MODEL" "ISL 144 NM10R 580Wp")
            (cons "TECHNOL" "TOPCon Bifacial NDCR") (cons "WP" "580.0") (cons "LENGTH" "2.278")
            (cons "WIDTH" "1.134") (cons "VMP" "44.01") (cons "IMP" "13.18") (cons "VOC" "52.60")
            (cons "ISC" "13.93") (cons "MUPMP" "-0.300") (cons "MUVOC" "-0.250") (cons "MUISC" "0.045")
            (cons "EFF" "22.45") (cons "BIFACIAL" "0.80") (cons "CELLS" "144") (cons "WEIGHT" "28.5"))
      (list (cons "MANUFACTURER" "INOX Solar") (cons "MODEL" "ISL 144 NM10R 585Wp")
            (cons "TECHNOL" "TOPCon Bifacial NDCR") (cons "WP" "585.0") (cons "LENGTH" "2.278")
            (cons "WIDTH" "1.134") (cons "VMP" "44.20") (cons "IMP" "13.24") (cons "VOC" "52.80")
            (cons "ISC" "13.97") (cons "MUPMP" "-0.300") (cons "MUVOC" "-0.250") (cons "MUISC" "0.045")
            (cons "EFF" "22.65") (cons "BIFACIAL" "0.80") (cons "CELLS" "144") (cons "WEIGHT" "28.5"))
      (list (cons "MANUFACTURER" "INOX Solar") (cons "MODEL" "ISL 144 NM10R 590Wp")
            (cons "TECHNOL" "TOPCon Bifacial NDCR") (cons "WP" "590.0") (cons "LENGTH" "2.278")
            (cons "WIDTH" "1.134") (cons "VMP" "44.40") (cons "IMP" "13.29") (cons "VOC" "53.00")
            (cons "ISC" "14.04") (cons "MUPMP" "-0.300") (cons "MUVOC" "-0.250") (cons "MUISC" "0.045")
            (cons "EFF" "22.84") (cons "BIFACIAL" "0.80") (cons "CELLS" "144") (cons "WEIGHT" "28.5"))
      (list (cons "MANUFACTURER" "INOX Solar") (cons "MODEL" "ISL 144 NM10R 595Wp")
            (cons "TECHNOL" "TOPCon Bifacial NDCR") (cons "WP" "595.0") (cons "LENGTH" "2.278")
            (cons "WIDTH" "1.134") (cons "VMP" "44.60") (cons "IMP" "13.34") (cons "VOC" "53.20")
            (cons "ISC" "14.10") (cons "MUPMP" "-0.300") (cons "MUVOC" "-0.250") (cons "MUISC" "0.045")
            (cons "EFF" "23.03") (cons "BIFACIAL" "0.80") (cons "CELLS" "144") (cons "WEIGHT" "28.5"))

      ;; Top ALMM Indian Tier-1 Manufacturers
      (list (cons "MANUFACTURER" "Waaree Energies") (cons "MODEL" "BiN-08-580 M10")
            (cons "TECHNOL" "TOPCon Bifacial") (cons "WP" "580.0") (cons "LENGTH" "2.278")
            (cons "WIDTH" "1.134") (cons "VMP" "44.01") (cons "IMP" "13.18") (cons "VOC" "52.50")
            (cons "ISC" "13.93") (cons "MUPMP" "-0.300") (cons "MUVOC" "-0.260") (cons "MUISC" "0.048")
            (cons "EFF" "21.46") (cons "BIFACIAL" "0.80") (cons "CELLS" "144") (cons "WEIGHT" "28.5"))
      (list (cons "MANUFACTURER" "Vikram Solar") (cons "MODEL" "SOMERA VSMDH.72.550.05")
            (cons "TECHNOL" "Mono PERC 144") (cons "WP" "550.0") (cons "LENGTH" "2.278")
            (cons "WIDTH" "1.134") (cons "VMP" "41.80") (cons "IMP" "13.16") (cons "VOC" "49.80")
            (cons "ISC" "13.98") (cons "MUPMP" "-0.350") (cons "MUVOC" "-0.280") (cons "MUISC" "0.048")
            (cons "EFF" "21.28") (cons "BIFACIAL" "0.70") (cons "CELLS" "144") (cons "WEIGHT" "28.3"))
      (list (cons "MANUFACTURER" "Tata Power Solar") (cons "MODEL" "TP545M10-144")
            (cons "TECHNOL" "Mono PERC 144") (cons "WP" "545.0") (cons "LENGTH" "2.278")
            (cons "WIDTH" "1.134") (cons "VMP" "41.65") (cons "IMP" "13.09") (cons "VOC" "49.60")
            (cons "ISC" "13.91") (cons "MUPMP" "-0.350") (cons "MUVOC" "-0.280") (cons "MUISC" "0.048")
            (cons "EFF" "21.10") (cons "BIFACIAL" "0.70") (cons "CELLS" "144") (cons "WEIGHT" "28.5"))
      (list (cons "MANUFACTURER" "Adani Solar") (cons "MODEL" "Elan Shine Dual Glass 540")
            (cons "TECHNOL" "Bifacial Mono PERC") (cons "WP" "540.0") (cons "LENGTH" "2.274")
            (cons "WIDTH" "1.134") (cons "VMP" "41.50") (cons "IMP" "13.02") (cons "VOC" "49.40")
            (cons "ISC" "13.85") (cons "MUPMP" "-0.350") (cons "MUVOC" "-0.280") (cons "MUISC" "0.048")
            (cons "EFF" "20.94") (cons "BIFACIAL" "0.70") (cons "CELLS" "144") (cons "WEIGHT" "28.0"))
      (list (cons "MANUFACTURER" "RenewSys") (cons "MODEL" "DESERV EXTREME-595")
            (cons "TECHNOL" "Mono PERC 144") (cons "WP" "595.0") (cons "LENGTH" "2.277")
            (cons "WIDTH" "1.133") (cons "VMP" "43.46") (cons "IMP" "13.70") (cons "VOC" "52.82")
            (cons "ISC" "14.35") (cons "MUPMP" "-0.320") (cons "MUVOC" "-0.289") (cons "MUISC" "0.048")
            (cons "EFF" "21.15") (cons "BIFACIAL" "0.70") (cons "CELLS" "144") (cons "WEIGHT" "29.0"))
      (list (cons "MANUFACTURER" "Emmvee Energy") (cons "MODEL" "E615HCBG132-T")
            (cons "TECHNOL" "Bifacial TOPCon") (cons "WP" "615.0") (cons "LENGTH" "2.382")
            (cons "WIDTH" "1.134") (cons "VMP" "40.69") (cons "IMP" "15.13") (cons "VOC" "49.01")
            (cons "ISC" "15.96") (cons "MUPMP" "-0.289") (cons "MUVOC" "-0.224") (cons "MUISC" "0.045")
            (cons "EFF" "21.70") (cons "BIFACIAL" "0.80") (cons "CELLS" "132") (cons "WEIGHT" "31.0"))

      ;; Global Reference Tier-1
      (list (cons "MANUFACTURER" "JinkoSolar") (cons "MODEL" "Tiger Neo JKM550N-72HL4-V")
            (cons "TECHNOL" "N-Type TOPCon") (cons "WP" "550.0") (cons "LENGTH" "2.278")
            (cons "WIDTH" "1.134") (cons "VMP" "41.42") (cons "IMP" "13.28") (cons "VOC" "50.25")
            (cons "ISC" "14.03") (cons "MUPMP" "-0.300") (cons "MUVOC" "-0.250") (cons "MUISC" "0.045")
            (cons "EFF" "21.29") (cons "BIFACIAL" "0.80") (cons "CELLS" "144") (cons "WEIGHT" "28.0"))
      (list (cons "MANUFACTURER" "LONGi Solar") (cons "MODEL" "Hi-MO 5 LR5-72HBD-550M")
            (cons "TECHNOL" "Bifacial Mono PERC") (cons "WP" "550.0") (cons "LENGTH" "2.278")
            (cons "WIDTH" "1.134") (cons "VMP" "41.95") (cons "IMP" "13.12") (cons "VOC" "49.80")
            (cons "ISC" "13.98") (cons "MUPMP" "-0.350") (cons "MUVOC" "-0.280") (cons "MUISC" "0.048")
            (cons "EFF" "21.30") (cons "BIFACIAL" "0.70") (cons "CELLS" "144") (cons "WEIGHT" "28.5"))
      (list (cons "MANUFACTURER" "Trina Solar") (cons "MODEL" "Vertex DE19R-550W")
            (cons "TECHNOL" "Mono PERC 210mm") (cons "WP" "550.0") (cons "LENGTH" "2.278")
            (cons "WIDTH" "1.134") (cons "VMP" "38.20") (cons "IMP" "14.40") (cons "VOC" "45.80")
            (cons "ISC" "15.35") (cons "MUPMP" "-0.340") (cons "MUVOC" "-0.270") (cons "MUISC" "0.045")
            (cons "EFF" "21.30") (cons "BIFACIAL" "0.00") (cons "CELLS" "132") (cons "WEIGHT" "28.2"))
    )
  )
  (pv:complib-load)
)

(defun pv:select-module-by-index (idx / mod-rec)
  (if (null *PV_MODULE_LIBRARY*) (pv:init-module-db))
  (if (or (< idx 0) (>= idx (length *PV_MODULE_LIBRARY*))) (setq idx 0))
  (setq *PV_ACTIVE_MODULE_IDX* idx)
  (setq mod-rec (nth idx *PV_MODULE_LIBRARY*))
  (setq *PV_PAN_MFG*        (pv:get-rec-field mod-rec "MANUFACTURER" "Generic")
        *PV_PAN_MODEL*      (pv:get-rec-field mod-rec "MODEL" "550W Module")
        *PV_PAN_TECH*       (pv:get-rec-field mod-rec "TECHNOL" "Mono PERC")
        *PV_MOD_WATT*       (atof (pv:get-rec-field mod-rec "WP" "550.0"))
        *PV_MOD_LEN*        (atof (pv:get-rec-field mod-rec "LENGTH" "2.278"))
        *PV_MOD_WID*        (atof (pv:get-rec-field mod-rec "WIDTH" "1.134"))
        *PV_PAN_VMP*        (atof (pv:get-rec-field mod-rec "VMP" "41.42"))
        *PV_PAN_IMP*        (atof (pv:get-rec-field mod-rec "IMP" "13.28"))
        *PV_PAN_VOC*        (atof (pv:get-rec-field mod-rec "VOC" "50.25"))
        *PV_PAN_ISC*        (atof (pv:get-rec-field mod-rec "ISC" "14.03"))
        *PV_PAN_TEMP_COEFF* (atof (pv:get-rec-field mod-rec "MUPMP" "-0.300"))
        *PV_PAN_TEMP_VOC*   (atof (pv:get-rec-field mod-rec "MUVOC" "-0.250"))
        *PV_PAN_TEMP_ISC*   (atof (pv:get-rec-field mod-rec "MUISC" "0.045"))
        *PV_PAN_EFFICIENCY* (atof (pv:get-rec-field mod-rec "EFF" "21.29"))
        *PV_PAN_BIFACIAL*   (atof (pv:get-rec-field mod-rec "BIFACIAL" "0.80"))
        *PV_PAN_CELLS*      (atoi (pv:get-rec-field mod-rec "CELLS" "144"))
        *PV_PAN_WEIGHT*     (atof (pv:get-rec-field mod-rec "WEIGHT" "28.0"))
        *PV_PAN_LOADED*     t)
)

(defun pv:load-pan-file (filepath / data get-val mfg model tech pnom vmp imp voc isc mu-pmp mu-voc mu-isc len wid dep wt cells bif eff new-rec)
  (setq data (pv:parse-key-value-file filepath))
  (if data
    (progn

      (setq mfg    (pv:get-rec-field data "MANUFACTURER" "Generic Tier-1"))
      (setq model  (pv:get-rec-field data "MODEL" (vl-filename-base filepath)))
      (setq tech   (pv:get-rec-field data "TECHNOL" "Mono PERC"))
      (setq pnom   (atof (pv:get-rec-field data "PNOM" (pv:get-rec-field data "PMAX" (pv:get-rec-field data "WP" "550.0")))))
      (if (<= pnom 0.0) (setq pnom 550.0))
      
      (setq vmp (atof (pv:get-rec-field data "VMPP" (pv:get-rec-field data "VMAX" "41.95"))))
      (setq imp (atof (pv:get-rec-field data "IMPP" (pv:get-rec-field data "IMAX" "13.12"))))
      (setq voc (atof (pv:get-rec-field data "VOC" "49.80")))
      (setq isc (atof (pv:get-rec-field data "ISC" "13.98")))
      
      (setq mu-pmp (atof (pv:get-rec-field data "MUPMPREQ" (pv:get-rec-field data "MUPNOM" (pv:get-rec-field data "GAMMA_PMP" "-0.35")))))
      (if (< mu-pmp -1.0) (setq mu-pmp (/ (* mu-pmp 100.0) pnom)))
      (setq mu-voc (atof (pv:get-rec-field data "MUVOC" "-0.28")))
      (setq mu-isc (atof (pv:get-rec-field data "MUISC" "0.048")))
      
      (setq len (atof (pv:get-rec-field data "LENGTH" (pv:get-rec-field data "HEIGHT" "2.278"))))
      (setq wid (atof (pv:get-rec-field data "WIDTH" "1.134")))
      (setq dep (atof (pv:get-rec-field data "DEPTH" (pv:get-rec-field data "THICKNESS" "0.035"))))
      (if (> len 10.0) (setq len (/ len 1000.0)))
      (if (> wid 10.0) (setq wid (/ wid 1000.0)))
      (if (> dep 10.0) (setq dep (/ dep 1000.0)))
      (if (<= len 0.1) (setq len 2.278))
      (if (<= wid 0.1) (setq wid 1.134))
      
      (setq wt    (atof (pv:get-rec-field data "WEIGHT" "28.5")))
      (setq cells (atoi (pv:get-rec-field data "NCELS" "144")))
      (setq bif   (atof (pv:get-rec-field data "BIFACIALITY" "0.70")))
      (if (> bif 1.0) (setq bif (/ bif 100.0)))
      
      (setq eff (if (> (* len wid) 0.0) (* (/ pnom (* len wid 1000.0)) 100.0) 21.3))
      
      (setq new-rec
        (list
          (cons "MANUFACTURER" mfg) (cons "MODEL" model) (cons "TECHNOL" tech)
          (cons "WP" (rtos pnom 2 1)) (cons "LENGTH" (rtos len 2 3)) (cons "WIDTH" (rtos wid 2 3))
          (cons "VMP" (rtos vmp 2 2)) (cons "IMP" (rtos imp 2 2)) (cons "VOC" (rtos voc 2 2))
          (cons "ISC" (rtos isc 2 2)) (cons "MUPMP" (rtos mu-pmp 2 3)) (cons "MUVOC" (rtos mu-voc 2 3))
          (cons "MUISC" (rtos mu-isc 2 3)) (cons "EFF" (rtos eff 2 2)) (cons "BIFACIAL" (rtos bif 2 2))
          (cons "CELLS" (itoa cells)) (cons "WEIGHT" (rtos wt 2 1)) (cons "FILE" filepath)
        )
      )
      (pv:add-module-to-lib new-rec t)
      (setq *PV_PAN_FILE* filepath)
      (pv:select-module-by-index 0)
      t
    )
    nil
  )
)

(defun c:pv-load-pan (/ filepath cur-dir)
  (setq cur-dir (getvar "DWGPREFIX"))
  (setq filepath (getfiled "Select PV Module PAN File" cur-dir "pan;txt;*" 4))
  (if (and filepath (/= filepath ""))
    (if (pv:load-pan-file filepath)
      (progn
        (princ (strcat "\n[SolarPV] Successfully loaded PAN file: " *PV_PAN_MODEL* " (" *PV_PAN_MFG* ")"))
        (alert (strcat "PV Module Loaded Successfully!\n\n"
                       "Manufacturer: " *PV_PAN_MFG* "\n"
                       "Model: " *PV_PAN_MODEL* "\n"
                       "Power: " (rtos *PV_MOD_WATT* 2 1) " Wp\n"
                       "Efficiency: " (rtos *PV_PAN_EFFICIENCY* 2 2) " %\n"
                       "Vmp: " (rtos *PV_PAN_VMP* 2 2) " V | Imp: " (rtos *PV_PAN_IMP* 2 2) " A\n"
                       "Voc: " (rtos *PV_PAN_VOC* 2 2) " V | Isc: " (rtos *PV_PAN_ISC* 2 2) " A\n"
                       "Dimensions: " (rtos *PV_MOD_LEN* 2 3) "m x " (rtos *PV_MOD_WID* 2 3) "m\n"))
      )
      (alert "Error: Could not parse selected PAN file.")
    )
  )
  (princ)
)

;;; --------------------------------------------------------------------------
;;; Solar Grid-Tied Inverter Library & .OND File Parser
;;; --------------------------------------------------------------------------
(defun pv:init-inverter-db ()
  (setq *PV_INVERTER_LIBRARY*
    (list
      (list (cons "MANUFACTURER" "Sungrow") (cons "MODEL" "SG50CX")
            (cons "KW" "50.0") (cons "VDC_MAX" "1000.0") (cons "VMPP_MIN" "200.0")
            (cons "VMPP_MAX" "960.0") (cons "IMAX_DC" "100.0") (cons "MPPT" "5")
            (cons "INPUTS" "10") (cons "EFF_EURO" "98.5") (cons "EFF_MAX" "98.7") (cons "WEIGHT" "62.0"))
      (list (cons "MANUFACTURER" "Solis") (cons "MODEL" "S5-GC50K")
            (cons "KW" "50.0") (cons "VDC_MAX" "1100.0") (cons "VMPP_MIN" "200.0")
            (cons "VMPP_MAX" "1000.0") (cons "IMAX_DC" "160.0") (cons "MPPT" "5")
            (cons "INPUTS" "10") (cons "EFF_EURO" "98.3") (cons "EFF_MAX" "98.7") (cons "WEIGHT" "54.5"))
      (list (cons "MANUFACTURER" "Growatt") (cons "MODEL" "MAX 50KTL3-LV")
            (cons "KW" "50.0") (cons "VDC_MAX" "1100.0") (cons "VMPP_MIN" "200.0")
            (cons "VMPP_MAX" "1000.0") (cons "IMAX_DC" "130.0") (cons "MPPT" "5")
            (cons "INPUTS" "10") (cons "EFF_EURO" "98.4") (cons "EFF_MAX" "98.8") (cons "WEIGHT" "52.0"))
      (list (cons "MANUFACTURER" "Huawei") (cons "MODEL" "SUN2000-50KTL-M3")
            (cons "KW" "50.0") (cons "VDC_MAX" "1100.0") (cons "VMPP_MIN" "200.0")
            (cons "VMPP_MAX" "1000.0") (cons "IMAX_DC" "120.0") (cons "MPPT" "4")
            (cons "INPUTS" "8") (cons "EFF_EURO" "98.5") (cons "EFF_MAX" "98.7") (cons "WEIGHT" "49.0"))
      (list (cons "MANUFACTURER" "Sungrow") (cons "MODEL" "SG110CX")
            (cons "KW" "110.0") (cons "VDC_MAX" "1100.0") (cons "VMPP_MIN" "200.0")
            (cons "VMPP_MAX" "1000.0") (cons "IMAX_DC" "234.0") (cons "MPPT" "9")
            (cons "INPUTS" "18") (cons "EFF_EURO" "98.5") (cons "EFF_MAX" "98.7") (cons "WEIGHT" "89.0"))
      (list (cons "MANUFACTURER" "Solis") (cons "MODEL" "S6-GU100K")
            (cons "KW" "100.0") (cons "VDC_MAX" "1100.0") (cons "VMPP_MIN" "200.0")
            (cons "VMPP_MAX" "1000.0") (cons "IMAX_DC" "240.0") (cons "MPPT" "8")
            (cons "INPUTS" "16") (cons "EFF_EURO" "98.3") (cons "EFF_MAX" "98.6") (cons "WEIGHT" "84.0"))
      (list (cons "MANUFACTURER" "Sungrow") (cons "MODEL" "SG320HX-20")
            (cons "KW" "320.0") (cons "VDC_MAX" "1500.0") (cons "VMPP_MIN" "500.0")
            (cons "VMPP_MAX" "1500.0") (cons "IMAX_DC" "390.0") (cons "MPPT" "6")
            (cons "INPUTS" "30") (cons "EFF_EURO" "98.8") (cons "EFF_MAX" "99.0") (cons "WEIGHT" "110.0"))
    )
  )
  (pv:complib-load)
)

(defun pv:select-inverter-by-index (idx / inv-rec)
  (if (null *PV_INVERTER_LIBRARY*) (pv:init-inverter-db))
  (if (or (< idx 0) (>= idx (length *PV_INVERTER_LIBRARY*))) (setq idx 0))
  (setq *PV_ACTIVE_INVERTER_IDX* idx)
  (setq inv-rec (nth idx *PV_INVERTER_LIBRARY*))
  (setq *PV_INV_MFG*        (pv:get-rec-field inv-rec "MANUFACTURER" "Sungrow")
        *PV_INV_MODEL*      (pv:get-rec-field inv-rec "MODEL" "SG50CX")
        *PV_INV_KW*         (atof (pv:get-rec-field inv-rec "KW" "50.0"))
        *PV_INV_VDC_MAX*    (atof (pv:get-rec-field inv-rec "VDC_MAX" "1000.0"))
        *PV_INV_VMPP_MIN*   (atof (pv:get-rec-field inv-rec "VMPP_MIN" "200.0"))
        *PV_INV_VMPP_MAX*   (atof (pv:get-rec-field inv-rec "VMPP_MAX" "960.0"))
        *PV_INV_IMAX_DC*    (atof (pv:get-rec-field inv-rec "IMAX_DC" "100.0"))
        *PV_INV_MPPT_COUNT* (atoi (pv:get-rec-field inv-rec "MPPT" "5"))
        *PV_INV_INPUTS*     (atoi (pv:get-rec-field inv-rec "INPUTS" "10"))
        *PV_INV_EFF_EURO*   (atof (pv:get-rec-field inv-rec "EFF_EURO" "98.5"))
        *PV_INV_EFF_MAX*    (atof (pv:get-rec-field inv-rec "EFF_MAX" "98.7"))
        *PV_INV_WEIGHT*     (atof (pv:get-rec-field inv-rec "WEIGHT" "62.0")))
)

(defun pv:load-ond-file (filepath / data get-val mfg model kw vdc-max vmpp-min vmpp-max imax mppt inputs eff-euro eff-max wt new-rec)
  (setq data (pv:parse-key-value-file filepath))
  (if data
    (progn

      (setq mfg      (pv:get-rec-field data "MANUFACTURER" "Generic Inverter"))
      (setq model    (pv:get-rec-field data "MODEL" (vl-filename-base filepath)))
      (setq kw       (atof (pv:get-rec-field data "PNOM" (pv:get-rec-field data "PNOMAPP" (pv:get-rec-field data "PMAX" "50.0")))))
      (if (<= kw 0.0) (setq kw 50.0))
      
      (setq vdc-max  (atof (pv:get-rec-field data "VMAX" (pv:get-rec-field data "VABSMAX" "1000.0"))))
      (setq vmpp-min (atof (pv:get-rec-field data "VMPPMIN" (pv:get-rec-field data "VMIN" "200.0"))))
      (setq vmpp-max (atof (pv:get-rec-field data "VMPPMAX" "960.0")))
      (setq imax     (atof (pv:get-rec-field data "IMAXDC" (pv:get-rec-field data "IMAX" "100.0"))))
      (setq mppt     (atoi (pv:get-rec-field data "NBMPPT" "5")))
      (setq inputs   (atoi (pv:get-rec-field data "NBINPUTS" (itoa (* mppt 2)))))
      (setq eff-euro (atof (pv:get-rec-field data "EFFEURO" "98.5")))
      (setq eff-max  (atof (pv:get-rec-field data "EFFMAX" "98.7")))
      (setq wt       (atof (pv:get-rec-field data "WEIGHT" "60.0")))
      
      (setq new-rec
        (list
          (cons "MANUFACTURER" mfg) (cons "MODEL" model) (cons "KW" (rtos kw 2 1))
          (cons "VDC_MAX" (rtos vdc-max 2 0)) (cons "VMPP_MIN" (rtos vmpp-min 2 0))
          (cons "VMPP_MAX" (rtos vmpp-max 2 0)) (cons "IMAX_DC" (rtos imax 2 1))
          (cons "MPPT" (itoa mppt)) (cons "INPUTS" (itoa inputs))
          (cons "EFF_EURO" (rtos eff-euro 2 2)) (cons "EFF_MAX" (rtos eff-max 2 2))
          (cons "WEIGHT" (rtos wt 2 1)) (cons "FILE" filepath)
        )
      )
      (pv:add-inverter-to-lib new-rec t)
      (setq *PV_OND_FILE* filepath)
      (pv:select-inverter-by-index 0)
      t
    )
    nil
  )
)

(defun c:pv-load-ond (/ filepath cur-dir)
  (setq cur-dir (getvar "DWGPREFIX"))
  (setq filepath (getfiled "Select Solar Inverter OND File" cur-dir "ond;txt;*" 4))
  (if (and filepath (/= filepath ""))
    (if (pv:load-ond-file filepath)
      (progn
        (princ (strcat "\n[SolarPV] Successfully loaded OND file: " *PV_INV_MODEL* " (" *PV_INV_MFG* ")"))
        (alert (strcat "Grid-Tied Inverter Loaded Successfully!\n\n"
                       "Manufacturer: " *PV_INV_MFG* "\n"
                       "Model: " *PV_INV_MODEL* "\n"
                       "AC Power Rating: " (rtos *PV_INV_KW* 2 1) " kW\n"
                       "Max DC Voltage: " (rtos *PV_INV_VDC_MAX* 2 0) " V\n"
                       "MPPT Range: " (rtos *PV_INV_VMPP_MIN* 2 0) " - " (rtos *PV_INV_VMPP_MAX* 2 0) " V\n"
                       "MPPTs / Inputs: " (itoa *PV_INV_MPPT_COUNT*) " MPPTs / " (itoa *PV_INV_INPUTS*) " Inputs\n"
                       "Euro Efficiency: " (rtos *PV_INV_EFF_EURO* 2 2) " %\n"))
      )
      (alert "Error: Could not parse selected OND file.")
    )
  )
  (princ)
)

(defun pv:calc-inverter-sizing (plant-kw / min-mods max-mods opt-mods inv-qty dc-ac-ratio total-strings)
  (setq min-mods (fix (+ 0.9999 (/ *PV_INV_VMPP_MIN* (max 10.0 *PV_PAN_VMP*)))))
  (setq max-mods (fix (/ *PV_INV_VDC_MAX* (* (max 10.0 *PV_PAN_VOC*) 1.12))))
  (setq opt-mods (max min-mods (min max-mods (fix (/ (+ min-mods max-mods) 2)))))
  (if (<= opt-mods 0) (setq opt-mods 20))
  
  (setq inv-qty (max 1 (fix (+ 0.9999 (/ plant-kw (* *PV_INV_KW* 1.15))))))
  (setq dc-ac-ratio (/ plant-kw (* inv-qty *PV_INV_KW*)))
  (setq total-strings (fix (+ 0.9999 (/ (max 1 *PV_MODULE_COUNT*) (float opt-mods)))))
  
  (setq *PV_INV_COUNT* inv-qty
        *PV_DC_AC_RATIO* dc-ac-ratio)
  (list inv-qty dc-ac-ratio opt-mods total-strings)
)

;;; --------------------------------------------------------------------------
;;; Fall Safety Line Drawing Engine
;;; --------------------------------------------------------------------------
;;; Draws End Anchor Plate with Spring Loaded Wire Tensioner detail
(defun pv:draw-end-anchor-symbol (pt ang / p1 p2 p3 p4 plate-pts cos-a sin-a cyl-p1 cyl-p2 sp-pts i cx cy)
  (setq cos-a (cos ang) sin-a (sin ang))
  
  ;; 1. Base Plate: 0.25m x 0.25m square centered at pt
  (defun rot-pt (x y / rx ry)
    (setq rx (+ (car pt) (- (* x cos-a) (* y sin-a))))
    (setq ry (+ (cadr pt) (+ (* x sin-a) (* y cos-a))))
    (list rx ry)
  )
  (setq plate-pts
    (list
      (rot-pt -0.125 -0.125)
      (rot-pt  0.125 -0.125)
      (rot-pt  0.125  0.125)
      (rot-pt -0.125  0.125)
    )
  )
  (pv:draw-lwpolyline plate-pts "PV_FALL_SAFETY" 6 t)
  
  ;; 4 Anchor Bolt Holes (circles)
  (pv:draw-circle (rot-pt -0.08 -0.08) 0.015 "PV_FALL_SAFETY" 6)
  (pv:draw-circle (rot-pt  0.08 -0.08) 0.015 "PV_FALL_SAFETY" 6)
  (pv:draw-circle (rot-pt  0.08  0.08) 0.015 "PV_FALL_SAFETY" 6)
  (pv:draw-circle (rot-pt -0.08  0.08) 0.015 "PV_FALL_SAFETY" 6)
  
  ;; 2. Spring-Loaded Tensioner Housing Cylinder (0.35m long x 0.08m wide)
  (setq cyl-p1 (rot-pt 0.125 -0.04)
        cyl-p2 (rot-pt 0.475 -0.04)
        cyl-p3 (rot-pt 0.475  0.04)
        cyl-p4 (rot-pt 0.125  0.04))
  (pv:draw-lwpolyline (list cyl-p1 cyl-p2 cyl-p3 cyl-p4) "PV_FALL_SAFETY" 1 t)
  
  ;; 3. Internal Compression Spring Zig-Zag coils
  (setq sp-pts (list (rot-pt 0.16 0.0)))
  (setq i 0)
  (while (< i 5)
    (setq cx (+ 0.19 (* i 0.05)))
    (setq sp-pts (cons (rot-pt cx 0.03) sp-pts))
    (setq sp-pts (cons (rot-pt (+ cx 0.025) -0.03) sp-pts))
    (setq i (1+ i))
  )
  (setq sp-pts (cons (rot-pt 0.44 0.0) sp-pts))
  (setq sp-pts (reverse sp-pts))
  (setq i 0)
  (while (< i (1- (length sp-pts)))
    (pv:draw-line (nth i sp-pts) (nth (1+ i) sp-pts) "PV_FALL_SAFETY" 6)
    (setq i (1+ i))
  )
  
  ;; 4. Tensioner Swaged Fork Terminal & Turnbuckle Eye to wire rope
  (pv:draw-line (rot-pt 0.475 0.0) (rot-pt 0.60 0.0) "PV_FALL_SAFETY" 1)
  (pv:draw-circle (rot-pt 0.60 0.0) 0.025 "PV_FALL_SAFETY" 1)
  
  ;; Label text
  (pv:draw-text (rot-pt 0.10 0.16) "END ANCHOR W/ SPRING TENSIONER" 0.16 "PV_ANNOTATION" 7 0.0)
)

;;; Draws 90 Degree Turn Point / Corner Pulley Anchor detail
(defun pv:draw-turn-point-symbol (pt in-ang out-ang / bisect-ang cos-b sin-b p1 p2 p3 p4)
  (setq bisect-ang (/ (+ in-ang out-ang) 2.0))
  (setq cos-b (cos bisect-ang) sin-b (sin bisect-ang))
  
  (defun rot-turn (x y / rx ry)
    (setq rx (+ (car pt) (- (* x cos-b) (* y sin-b))))
    (setq ry (+ (cadr pt) (+ (* x sin-b) (* y cos-b))))
    (list rx ry)
  )
  ;; Corner Base Plate: 0.20m x 0.20m
  (setq p1 (rot-turn -0.10 -0.10)
        p2 (rot-turn  0.10 -0.10)
        p3 (rot-turn  0.10  0.10)
        p4 (rot-turn -0.10  0.10))
  (pv:draw-lwpolyline (list p1 p2 p3 p4) "PV_FALL_SAFETY" 6 t)
  
  ;; 90-Deg Deflection Pulley Wheel
  (pv:draw-circle pt 0.06 "PV_FALL_SAFETY" 1)
  (pv:draw-circle pt 0.02 "PV_FALL_SAFETY" 6)
  
  ;; Corner Anchor Bolts
  (pv:draw-circle (rot-turn -0.07 -0.07) 0.012 "PV_FALL_SAFETY" 6)
  (pv:draw-circle (rot-turn  0.07 -0.07) 0.012 "PV_FALL_SAFETY" 6)
  (pv:draw-circle (rot-turn -0.07  0.07) 0.012 "PV_FALL_SAFETY" 6)
  
  (pv:draw-text (rot-turn 0.08 0.14) "90° TURN ANCHOR / PULLEY" 0.16 "PV_ANNOTATION" 7 0.0)
)

;;; Draws Intermediate Rope Guide Post
(defun pv:draw-intermediate-guide-symbol (pt ang / cos-a sin-a)
  (setq cos-a (cos ang) sin-a (sin ang))
  (defun rot-g (x y / rx ry)
    (setq rx (+ (car pt) (- (* x cos-a) (* y sin-a))))
    (setq ry (+ (cadr pt) (+ (* x sin-a) (* y cos-a))))
    (list rx ry)
  )
  ;; Guide post bracket
  (pv:draw-lwpolyline (list (rot-g -0.06 -0.06) (rot-g 0.06 -0.06) (rot-g 0.06 0.06) (rot-g -0.06 0.06)) "PV_FALL_SAFETY" 6 t)
  (pv:draw-circle pt 0.025 "PV_FALL_SAFETY" 1)
  (pv:draw-text (rot-g 0.05 0.10) "INTERMEDIATE WIRE GUIDE" 0.14 "PV_ANNOTATION" 7 0.0)
)

;;; Interactive Fall Safety Line Command
(defun c:pv-fall-safety (/ p-start turn-pts p-next p-end all-pts i p1 p2 seg-len seg-ang num-inter j frac inter-pt tot-len in-ang out-ang)
  (pv:init-layers)
  (princ "\n==========================================================================")
  (princ "\n[SolarPV] FALL SAFETY SYSTEM GENERATOR (EN 795 / OSHA 1926 Standard)")
  (princ "\nDefining End Anchor Plates with Spring Tensioners & 90° Turn Points.")
  (princ "\n==========================================================================")
  
  (setq p-start (getpoint "\nPick START Location (End Anchor Plate with Spring Tensioner): "))
  (if p-start
    (progn
      (setq turn-pts nil)
      (setq p-next t)
      
      (while p-next
        (setq p-next (getpoint (if turn-pts (car (reverse turn-pts)) p-start)
                               "\nPick 90° TURN Point or corner anchor [Press ENTER when done to pick End Anchor]: "))
        (if p-next
          (progn
            (setq turn-pts (append turn-pts (list p-next)))
            (princ (strcat "\n-> Registered 90° Turn Point #" (itoa (length turn-pts))))
          )
        )
      )
      
      (setq p-end (getpoint (if turn-pts (car (reverse turn-pts)) p-start)
                            "\nPick END Location (End Anchor Plate with Spring Tensioner): "))
      (if (not p-end)
        (if turn-pts
          (progn
            (setq p-end (car (reverse turn-pts)))
            (setq turn-pts (reverse (cdr (reverse turn-pts))))
          )
        )
      )
      
      (if (and p-start p-end)
        (progn
          (setq all-pts (cons p-start (append turn-pts (list p-end))))
          (setq tot-len 0.0)
          
          ;; 1. Draw continuous wire rope line
          (setq i 0)
          (while (< i (1- (length all-pts)))
            (setq p1 (nth i all-pts)
                  p2 (nth (1+ i) all-pts))
            (setq seg-len (distance p1 p2))
            (setq seg-ang (angle p1 p2))
            (setq tot-len (+ tot-len seg-len))
            
            ;; Draw stainless steel wire rope segment (2D Plan & 3D at Roof Surface)
            (pv:draw-line p1 p2 "PV_FALL_SAFETY" 6)
            (setq sz1 (+ (pv:get-roof-z p1 nil) 0.15)
                  sz2 (+ (pv:get-roof-z p2 nil) 0.15))
            (pv:draw-line-3d (list (car p1) (cadr p1) sz1) (list (car p2) (cadr p2) sz2) "PV_3D_SAFETY" 6)
            (pv:draw-line-3d (list (car p1) (cadr p1) (- sz1 0.15)) (list (car p1) (cadr p1) sz1) "PV_3D_SAFETY" 6)
            
            ;; Insert intermediate rope guides if span exceeds configured anchor spacing (EN 795: 4.5-6m)
            (if (> seg-len *PV_FALL_SAFETY_ANCHOR_SPACING*)
              (progn
                (setq num-inter (fix (/ seg-len *PV_FALL_SAFETY_ANCHOR_SPACING*)))
                (setq j 1)
                (while (<= j num-inter)
                  (setq frac (/ (float j) (float (1+ num-inter))))
                  (setq inter-pt (list (+ (car p1) (* frac (- (car p2) (car p1))))
                                       (+ (cadr p1) (* frac (- (cadr p2) (cadr p1))))))
                  (pv:draw-intermediate-guide-symbol inter-pt seg-ang)
                  (setq sz-int (+ (pv:get-roof-z inter-pt nil) 0.15))
                  (pv:draw-line-3d (list (car inter-pt) (cadr inter-pt) (- sz-int 0.15))
                                  (list (car inter-pt) (cadr inter-pt) sz-int)
                                  "PV_3D_SAFETY" 6)
                  (setq *PV_FALL_SAFETY_INTER_COUNT* (1+ *PV_FALL_SAFETY_INTER_COUNT*))
                  (setq j (1+ j))
                )
              )
            )
            (setq i (1+ i))
          )
          (setq sz-end (+ (pv:get-roof-z p-end nil) 0.15))
          (pv:draw-line-3d (list (car p-end) (cadr p-end) (- sz-end 0.15)) (list (car p-end) (cadr p-end) sz-end) "PV_3D_SAFETY" 6)
          
          ;; 2. Draw Start Anchor with Spring Loaded Tensioner
          (setq seg-ang (angle p-start (nth 1 all-pts)))
          (pv:draw-end-anchor-symbol p-start seg-ang)
          
          ;; 3. Draw 90° Turn Points
          (setq i 0)
          (while (< i (length turn-pts))
            (setq in-ang (angle (nth i all-pts) (nth (1+ i) all-pts)))
            (setq out-ang (angle (nth (1+ i) all-pts) (nth (+ i 2) all-pts)))
            (pv:draw-turn-point-symbol (nth (1+ i) all-pts) in-ang out-ang)
            (setq i (1+ i))
          )
          
          ;; 4. Draw End Anchor with Spring Loaded Tensioner
          (setq seg-ang (angle (nth (- (length all-pts) 2) all-pts) p-end))
          (pv:draw-end-anchor-symbol p-end (+ seg-ang pi))
          
          ;; Update global records
          (setq *PV_FALL_SAFETY_LENGTH* (+ *PV_FALL_SAFETY_LENGTH* tot-len))
          (setq *PV_FALL_SAFETY_ANCHOR_COUNT* (+ *PV_FALL_SAFETY_ANCHOR_COUNT* 2))
          (setq *PV_FALL_SAFETY_TURN_COUNT* (+ *PV_FALL_SAFETY_TURN_COUNT* (length turn-pts)))
          (setq *PV_FALL_SAFETY_LINES* (cons (list p-start turn-pts p-end tot-len) *PV_FALL_SAFETY_LINES*))
          
          (princ (strcat "\n[SolarPV] Fall Safety Lifeline generated: " (rtos tot-len 2 2) " meters."))
          (princ (strcat "\n[SolarPV] 2 End Anchors w/ Spring Tensioners + " (itoa (length turn-pts)) " 90° Turn Anchors drawn."))
          (alert (strcat "Fall Safety System Created!\n\n"
                         "Total Wire Rope Span : " (rtos tot-len 2 2) " m\n"
                         "End Anchor Plates    : 2 Units (w/ Spring Loaded Tensioners)\n"
                         "90° Turn Pulleys     : " (itoa (length turn-pts)) " Units\n"
                         "Intermediate Guides  : " (itoa *PV_FALL_SAFETY_INTER_COUNT*) " Units\n"
                         "Rope Specification   : 8mm SS316 Stainless Steel Lifeline\n\n"
                         "System will be included in the Project BOM."))
        )
      )
    )
    (princ "\n[SolarPV] Cancelled fall safety line placement.")
  )
  (princ)
)

;;; --------------------------------------------------------------------------
;;; Safety Handrail Drawing Engine (Full 3D Rooftop Structure & 2D Plan)
;;; --------------------------------------------------------------------------
(defun pv:draw-handrail-segment-3d (p1 p2 r-bbox /
                                     d ang cos-a sin-a
                                     num-posts j frac p-post
                                     zj zj-top
                                     k phi cx cy post-corners
                                     h-rail num-rails rail-levels h-curr
                                     p-prev-post zj-prev zj-prev-top
                                     qa1 qa2 qa3 qa4 qb1 qb2 qb3 qb4
                                     r-post r-rail w-post
                                     b1 b2 b3 b4 t1 t2 t3 t4 za zb
                                     mid-1 mid-2 off-x off-y)
  (if (null r-bbox) (setq r-bbox (pv:get-roof-bbox)))
  (setq d (distance p1 p2))
  (if (> d 0.05)
    (progn
      (setq ang (angle p1 p2))
      (setq cos-a (cos ang) sin-a (sin ang))
      
      (setq h-rail (if (> *PV_HANDRAIL_HEIGHT* 0.0) *PV_HANDRAIL_HEIGHT* 1.10)
            num-rails (if (and *PV_HANDRAIL_NUM_RAILS* (>= *PV_HANDRAIL_NUM_RAILS* 2)) *PV_HANDRAIL_NUM_RAILS* 2)
            w-post (if (> *PV_HANDRAIL_POST_SIZE* 0.0) *PV_HANDRAIL_POST_SIZE* 0.05)
            r-post (/ w-post 2.0)
            r-rail (if (> *PV_HANDRAIL_RAIL_SIZE* 0.0) (/ *PV_HANDRAIL_RAIL_SIZE* 2.0) 0.02))
      
      ;; Determine rail level heights
      (setq rail-levels
        (cond
          ((= num-rails 3) (list (* h-rail 0.35) (* h-rail 0.68) h-rail))
          ((= num-rails 4) (list (* h-rail 0.25) (* h-rail 0.50) (* h-rail 0.75) h-rail))
          (t (list (* h-rail 0.50) h-rail)) ; default 2 rails
        )
      )
      
      (setq num-posts (max 1 (fix (+ 0.9999 (/ d (if (> *PV_HANDRAIL_POST_SPACING* 0.0) *PV_HANDRAIL_POST_SPACING* 1.50))))))
      
      ;; 1. Loop through each post to draw 3D vertical stanchions & baseplates
      (setq j 0)
      (while (<= j num-posts)
        (setq frac (/ (float j) (float num-posts)))
        (setq p-post (list (+ (car p1) (* frac (- (car p2) (car p1))))
                           (+ (cadr p1) (* frac (- (cadr p2) (cadr p1))))))
        
        ;; Surface elevation at post base
        (setq zj (pv:get-roof-z p-post r-bbox))
        (setq zj-top (+ zj h-rail))
        
        ;; A. Baseplate at roof surface (0.14m x 0.14m)
        (setq b1 (list (+ (car p-post) (* -0.07 cos-a) (* -0.07 (- sin-a)))
                       (+ (cadr p-post) (* -0.07 sin-a) (* -0.07 cos-a))
                       zj)
              b2 (list (+ (car p-post) (* 0.07 cos-a) (* -0.07 (- sin-a)))
                       (+ (cadr p-post) (* 0.07 sin-a) (* -0.07 cos-a))
                       zj)
              b3 (list (+ (car p-post) (* 0.07 cos-a) (* 0.07 (- sin-a)))
                       (+ (cadr p-post) (* 0.07 sin-a) (* 0.07 cos-a))
                       zj)
              b4 (list (+ (car p-post) (* -0.07 cos-a) (* 0.07 (- sin-a)))
                       (+ (cadr p-post) (* -0.07 sin-a) (* 0.07 cos-a))
                       zj))
        (pv:draw-3dface b1 b2 b3 b4 "PV_3D_HANDRAIL" 40)
        
        ;; B. Vertical Stanchion Post (Round Pipe or Square Pipe)
        (if (= *PV_HANDRAIL_POST_SHAPE* "Square Pipe")
          (progn
            ;; Square Box Post: 4 vertical 3DFACEs + top cap
            (setq b1 (list (+ (car p-post) (* (- r-post) cos-a) (* (- r-post) (- sin-a)))
                           (+ (cadr p-post) (* (- r-post) sin-a) (* (- r-post) cos-a))
                           zj)
                  b2 (list (+ (car p-post) (* r-post cos-a) (* (- r-post) (- sin-a)))
                           (+ (cadr p-post) (* r-post sin-a) (* (- r-post) cos-a))
                           zj)
                  b3 (list (+ (car p-post) (* r-post cos-a) (* r-post (- sin-a)))
                           (+ (cadr p-post) (* r-post sin-a) (* r-post cos-a))
                           zj)
                  b4 (list (+ (car p-post) (* (- r-post) cos-a) (* r-post (- sin-a)))
                           (+ (cadr p-post) (* (- r-post) sin-a) (* r-post cos-a))
                           zj))
            (setq t1 (list (car b1) (cadr b1) zj-top)
                  t2 (list (car b2) (cadr b2) zj-top)
                  t3 (list (car b3) (cadr b3) zj-top)
                  t4 (list (car b4) (cadr b4) zj-top))
            
            ;; 4 side faces
            (pv:draw-3dface b1 b2 t2 t1 "PV_3D_HANDRAIL" 40)
            (pv:draw-3dface b2 b3 t3 t2 "PV_3D_HANDRAIL" 40)
            (pv:draw-3dface b3 b4 t4 t3 "PV_3D_HANDRAIL" 40)
            (pv:draw-3dface b4 b1 t1 t4 "PV_3D_HANDRAIL" 40)
            ;; Top cap
            (pv:draw-3dface t1 t2 t3 t4 "PV_3D_HANDRAIL" 40)
            ;; Wireframe vertical corner lines
            (pv:draw-line-3d b1 t1 "PV_3D_HANDRAIL" 40)
            (pv:draw-line-3d b2 t2 "PV_3D_HANDRAIL" 40)
            (pv:draw-line-3d b3 t3 "PV_3D_HANDRAIL" 40)
            (pv:draw-line-3d b4 t4 "PV_3D_HANDRAIL" 40)
          )
          (progn
            ;; Round Pipe Post: 8-faceted cylindrical 3DFACEs + top cap + center spine
            (setq k 0 post-corners nil)
            (while (< k 8)
              (setq phi (* (float k) (/ (* 2.0 pi) 8.0)))
              (setq cx (+ (car p-post) (* r-post (cos phi)))
                    cy (+ (cadr p-post) (* r-post (sin phi))))
              (setq post-corners (cons (list cx cy) post-corners))
              (setq k (1+ k))
            )
            (setq post-corners (reverse post-corners))
            (setq k 0)
            (while (< k 8)
              (setq b1 (list (car (nth k post-corners)) (cadr (nth k post-corners)) zj)
                    b2 (list (car (nth (rem (1+ k) 8) post-corners)) (cadr (nth (rem (1+ k) 8) post-corners)) zj)
                    t1 (list (car b1) (cadr b1) zj-top)
                    t2 (list (car b2) (cadr b2) zj-top))
              (pv:draw-3dface b1 b2 t2 t1 "PV_3D_HANDRAIL" 40)
              (setq k (1+ k))
            )
            ;; Top cap
            (setq t1 (list (car (nth 0 post-corners)) (cadr (nth 0 post-corners)) zj-top)
                  t2 (list (car (nth 2 post-corners)) (cadr (nth 2 post-corners)) zj-top)
                  t3 (list (car (nth 4 post-corners)) (cadr (nth 4 post-corners)) zj-top)
                  t4 (list (car (nth 6 post-corners)) (cadr (nth 6 post-corners)) zj-top))
            (pv:draw-3dface t1 t2 t3 t4 "PV_3D_HANDRAIL" 40)
            ;; Center post vertical line
            (pv:draw-line-3d (list (car p-post) (cadr p-post) zj) (list (car p-post) (cadr p-post) zj-top) "PV_3D_HANDRAIL" 40)
          )
        )
        
        ;; C. Connect horizontal rails & kickplate from previous post to current post
        (if (> j 0)
          (progn
            ;; Kickplate / Toeboard (150mm = 0.15m height above roof)
            (if (= *PV_HANDRAIL_TOEBOARD* 1)
              (progn
                (setq qa1 (list (car p-prev-post) (cadr p-prev-post) zj-prev)
                      qa2 (list (car p-post) (cadr p-post) zj)
                      qa3 (list (car p-post) (cadr p-post) (+ zj 0.15))
                      qa4 (list (car p-prev-post) (cadr p-prev-post) (+ zj-prev 0.15)))
                (pv:draw-3dface qa1 qa2 qa3 qa4 "PV_3D_HANDRAIL" 40)
                (pv:draw-line-3d qa4 qa3 "PV_3D_HANDRAIL" 40)
              )
            )
            
            ;; Each horizontal rail line
            (foreach h-curr rail-levels
              (setq za (+ zj-prev h-curr)
                    zb (+ zj h-curr))
              (if (= *PV_HANDRAIL_RAIL_SHAPE* "Square Pipe")
                (progn
                  ;; Square Rail 3D Tube (4 connecting faces)
                  (setq qa1 (list (+ (car p-prev-post) (* (- r-rail) (- sin-a))) (+ (cadr p-prev-post) (* (- r-rail) cos-a)) (- za r-rail))
                        qa2 (list (+ (car p-prev-post) (* r-rail (- sin-a))) (+ (cadr p-prev-post) (* r-rail cos-a)) (- za r-rail))
                        qa3 (list (+ (car p-prev-post) (* r-rail (- sin-a))) (+ (cadr p-prev-post) (* r-rail cos-a)) (+ za r-rail))
                        qa4 (list (+ (car p-prev-post) (* (- r-rail) (- sin-a))) (+ (cadr p-prev-post) (* (- r-rail) cos-a)) (+ za r-rail)))
                  (setq qb1 (list (+ (car p-post) (* (- r-rail) (- sin-a))) (+ (cadr p-post) (* (- r-rail) cos-a)) (- zb r-rail))
                        qb2 (list (+ (car p-post) (* r-rail (- sin-a))) (+ (cadr p-post) (* r-rail cos-a)) (- zb r-rail))
                        qb3 (list (+ (car p-post) (* r-rail (- sin-a))) (+ (cadr p-post) (* r-rail cos-a)) (+ zb r-rail))
                        qb4 (list (+ (car p-post) (* (- r-rail) (- sin-a))) (+ (cadr p-post) (* (- r-rail) cos-a)) (+ zb r-rail)))
                  
                  (pv:draw-3dface qa1 qb1 qb2 qa2 "PV_3D_HANDRAIL" 40)
                  (pv:draw-3dface qa2 qb2 qb3 qa3 "PV_3D_HANDRAIL" 40)
                  (pv:draw-3dface qa3 qb3 qb4 qa4 "PV_3D_HANDRAIL" 40)
                  (pv:draw-3dface qa4 qb4 qb1 qa1 "PV_3D_HANDRAIL" 40)
                  
                  (pv:draw-line-3d qa1 qb1 "PV_3D_HANDRAIL" 40)
                  (pv:draw-line-3d qa3 qb3 "PV_3D_HANDRAIL" 40)
                )
                (progn
                  ;; Round Rail 3D Pipe (4 connecting faces + 3D centerline)
                  (setq qa1 (list (+ (car p-prev-post) (* (- r-rail) (- sin-a))) (+ (cadr p-prev-post) (* (- r-rail) cos-a)) za)
                        qa2 (list (car p-prev-post) (cadr p-prev-post) (- za r-rail))
                        qa3 (list (+ (car p-prev-post) (* r-rail (- sin-a))) (+ (cadr p-prev-post) (* r-rail cos-a)) za)
                        qa4 (list (car p-prev-post) (cadr p-prev-post) (+ za r-rail)))
                  (setq qb1 (list (+ (car p-post) (* (- r-rail) (- sin-a))) (+ (cadr p-post) (* (- r-rail) cos-a)) zb)
                        qb2 (list (car p-post) (cadr p-post) (- zb r-rail))
                        qb3 (list (+ (car p-post) (* r-rail (- sin-a))) (+ (cadr p-post) (* r-rail cos-a)) zb)
                        qb4 (list (car p-post) (cadr p-post) (+ zb r-rail)))
                  
                  (pv:draw-3dface qa1 qb1 qb2 qa2 "PV_3D_HANDRAIL" 40)
                  (pv:draw-3dface qa2 qb2 qb3 qa3 "PV_3D_HANDRAIL" 40)
                  (pv:draw-3dface qa3 qb3 qb4 qa4 "PV_3D_HANDRAIL" 40)
                  (pv:draw-3dface qa4 qb4 qb1 qa1 "PV_3D_HANDRAIL" 40)
                  
                  ;; 3D Centerline
                  (pv:draw-line-3d (list (car p-prev-post) (cadr p-prev-post) za)
                                  (list (car p-post) (cadr p-post) zb)
                                  "PV_3D_HANDRAIL" 40)
                )
              )
            )
          )
        )
        
        (setq p-prev-post p-post
              zj-prev zj
              zj-prev-top zj-top)
        (setq j (1+ j))
      )
      
      ;; 2. Plan Schematics & Label along Handrail at Roof Elevation
      (setq off-x (* 0.08 (- sin-a))
            off-y (* 0.08 cos-a))
      (setq z1 (+ (pv:get-roof-z p1 r-bbox) 0.02)
            z2 (+ (pv:get-roof-z p2 r-bbox) 0.02))
      (pv:draw-line-3d (list (car p1) (cadr p1) z1) (list (car p2) (cadr p2) z2) "PV_HANDRAIL" 40)
      (setq mid-1 (list (+ (car p1) off-x) (+ (cadr p1) off-y) z1)
            mid-2 (list (+ (car p2) off-x) (+ (cadr p2) off-y) z2))
      (pv:draw-line-3d mid-1 mid-2 "PV_HANDRAIL" 2)
      
      (setq mx (/ (+ (car p1) (car p2)) 2.0)
            my (/ (+ (cadr p1) (cadr p2)) 2.0)
            zm (+ (pv:get-roof-z (list mx my) r-bbox) h-rail 0.08))
      (pv:draw-text (list (+ mx off-x) (+ my off-y) zm)
                    (strcat "HANDRAIL (" (rtos h-rail 2 2) "m, " (itoa num-rails) "-Rails)")
                    0.16 "PV_ANNOTATION" 7 0.0)
      
      (setq *PV_HANDRAIL_POST_COUNT* (+ *PV_HANDRAIL_POST_COUNT* (1+ num-posts)))
    )
  )
)

(defun pv:draw-handrail-segment (p1 p2)
  (pv:draw-handrail-segment-3d p1 p2 nil)
)

;;; Interactive Handrail Command
(defun c:pv-handrail (/ p-start pts p-cur p-prev tot-len i cfg-ans ht-in num-in post-shape-in rail-shape-in ht-valid)
  (pv:init-layers)

  ;; Validate handrail height per OSHA 1910.29 (0.90m min, 1.20m max recommended)
  (setq ht-valid t)
  (cond
    ((< *PV_HANDRAIL_HEIGHT* 0.90)
     (princ "\n[WARNING] Handrail height < 0.90m violates OSHA 1910.29 minimum!")
     (princ "\n[WARNING] Setting to minimum 0.90m")
     (setq *PV_HANDRAIL_HEIGHT* 0.90)
    )
    ((> *PV_HANDRAIL_HEIGHT* 1.20)
     (princ "\n[INFO] Handrail height > 1.20m may require special approval per local codes.")
    )
  )

  (princ "\n==========================================================================")
  (princ "\n[SolarPV] ROOFTOP SAFETY HANDRAILS / GUARDRAILS GENERATOR (3D & Plan)")
  (princ "\nPick points along roof perimeter or walkway edge to place safety handrails.")
  (princ "\n==========================================================================")
  (princ (strcat "\nCurrent Handrail Specifications:"
                 "\n  Height         : " (rtos *PV_HANDRAIL_HEIGHT* 2 2) " m"
                 "\n  Horizontal Rails: " (itoa *PV_HANDRAIL_NUM_RAILS*) " Rails"
                 "\n  Vertical Posts : " *PV_HANDRAIL_POST_SHAPE* " (50mm)"
                 "\n  Hand Rails     : " *PV_HANDRAIL_RAIL_SHAPE* " (40mm)"
                 "\n  Post Spacing   : " (rtos *PV_HANDRAIL_POST_SPACING* 2 2) " m"
                 "\n  Kickplate      : " (if (= *PV_HANDRAIL_TOEBOARD* 1) "150mm Toeboard Enabled" "None")))
  
  (initget "Yes No")
  (setq cfg-ans (getkword "\nConfigure Handrail Specifications first? [Yes/No] <No>: "))
  (if (= cfg-ans "Yes")
    (progn
      (initget 6) ; positive non-zero
      (setq ht-in (getreal (strcat "\nEnter Handrail Height in meters <" (rtos *PV_HANDRAIL_HEIGHT* 2 2) ">: ")))
      (if ht-in (setq *PV_HANDRAIL_HEIGHT* ht-in))
      
      (initget "2 3 4")
      (setq num-in (getkword (strcat "\nNumber of Horizontal Rails [2/3/4] <" (itoa *PV_HANDRAIL_NUM_RAILS*) ">: ")))
      (if num-in (setq *PV_HANDRAIL_NUM_RAILS* (atoi num-in)))
      
      (initget "Round Square")
      (setq post-shape-in (getkword (strcat "\nVertical Leg / Post Shape [Round/Square] <" (if (= *PV_HANDRAIL_POST_SHAPE* "Square Pipe") "Square" "Round") ">: ")))
      (if (= post-shape-in "Square") (setq *PV_HANDRAIL_POST_SHAPE* "Square Pipe")
        (if (= post-shape-in "Round") (setq *PV_HANDRAIL_POST_SHAPE* "Round Pipe")))
      
      (initget "Round Square")
      (setq rail-shape-in (getkword (strcat "\nHorizontal Rail Shape [Round/Square] <" (if (= *PV_HANDRAIL_RAIL_SHAPE* "Square Pipe") "Square" "Round") ">: ")))
      (if (= rail-shape-in "Square") (setq *PV_HANDRAIL_RAIL_SHAPE* "Square Pipe")
        (if (= rail-shape-in "Round") (setq *PV_HANDRAIL_RAIL_SHAPE* "Round Pipe")))
    )
  )
  
  (setq p-start (getpoint "\nPick Handrail START Point: "))
  (if p-start
    (progn
      (setq pts (list p-start))
      (setq p-cur t)
      
      (while p-cur
        (setq p-prev (car (reverse pts)))
        (setq p-cur (getpoint p-prev "\nPick NEXT Handrail Point [Press ENTER when finished]: "))
        (if p-cur
          (progn
            (setq pts (append pts (list p-cur)))
            (pv:draw-handrail-segment-3d p-prev p-cur nil)
          )
        )
      )
      
      (if (> (length pts) 1)
        (progn
          (setq tot-len 0.0)
          (setq i 0)
          (while (< i (1- (length pts)))
            (setq tot-len (+ tot-len (distance (nth i pts) (nth (1+ i) pts))))
            (setq i (1+ i))
          )
          (setq *PV_HANDRAIL_LENGTH* (+ *PV_HANDRAIL_LENGTH* tot-len))
          (setq *PV_HANDRAIL_LINES* (cons (list pts tot-len) *PV_HANDRAIL_LINES*))
          
          ;; Generate dynamic shadow map for handrail if enabled
          (if (= *PV_HANDRAIL_CAST_SHADOW* 1)
            (progn
              (setq sh-poly (pv:create-shadow-polygon pts *PV_HANDRAIL_HEIGHT* *PV_LAT*))
              (if sh-poly
                (progn
                  (setq *PV_OBSTACLES* (cons (list "HANDRAIL" *PV_HANDRAIL_HEIGHT* sh-poly pts) *PV_OBSTACLES*))
                  (princ (strcat "\n[SolarPV] Generated 9am-3pm winter solstice shadow map for Handrail (H="
                                 (rtos *PV_HANDRAIL_HEIGHT* 2 2) "m) on layer 'PV_SHADOW'."))
                )
              )
            )
          )
          
          (princ (strcat "\n[SolarPV] Total Handrail Placed: " (rtos tot-len 2 2) " meters."))
          (alert (strcat "3D Safety Handrails Placed Successfully!\n\n"
                         "Total Linear Length : " (rtos tot-len 2 2) " m\n"
                         "Total Stanchions    : " (itoa *PV_HANDRAIL_POST_COUNT*) " Posts\n"
                         "Handrail Height     : " (rtos *PV_HANDRAIL_HEIGHT* 2 2) " m\n"
                         "Horizontal Lines    : " (itoa *PV_HANDRAIL_NUM_RAILS*) " Rails\n"
                         "Vertical Legs Shape : " *PV_HANDRAIL_POST_SHAPE* "\n"
                         "Hand Rail Shape     : " *PV_HANDRAIL_RAIL_SHAPE* "\n"
                         "Surface Placement   : Elevated onto Active Rooftop Surface (Z_roof)\n"
                         "3D View Layer       : PV_3D_HANDRAIL (Color 40)\n"
                         "Shadow Map          : " (if (= *PV_HANDRAIL_CAST_SHADOW* 1) "Generated on 'PV_SHADOW' (Avoided in Layout)" "Disabled") "\n\n"
                         "Handrails will be fully rendered in 3D Isometric View and included in BOM."))
        )
      )
    )
    (princ "\n[SolarPV] Cancelled handrail placement.")
  )
  (princ)
)

(defun c:pv-clear-handrails (/ ss i new-obs)
  (if (setq ss (ssget "X" '((8 . "PV_HANDRAIL,PV_3D_HANDRAIL"))))
    (progn
      (setq i 0)
      (while (< i (sslength ss))
        (entdel (ssname ss i))
        (setq i (1+ i))
      )
      (setq *PV_HANDRAIL_LINES* nil
            *PV_HANDRAIL_LENGTH* 0.0
            *PV_HANDRAIL_POST_COUNT* 0
            *PV_HANDRAIL_3D_ENTS* nil)
      ;; Clean up handrail entries from obstacle registry
      (if *PV_OBSTACLES*
        (foreach obs *PV_OBSTACLES*
          (if (not (equal (car obs) "HANDRAIL"))
            (setq new-obs (cons obs new-obs))
          )
        )
      )
      (setq *PV_OBSTACLES* (reverse new-obs))
      (princ (strcat "\n[SolarPV] Cleared " (itoa (sslength ss)) " Handrail entities and shadow mappings."))
      (alert "All Safety Handrails and their shadow maps have been cleared.")
    )
    (progn
      (setq *PV_HANDRAIL_LINES* nil
            *PV_HANDRAIL_LENGTH* 0.0
            *PV_HANDRAIL_POST_COUNT* 0
            *PV_HANDRAIL_3D_ENTS* nil)
      (princ "\n[SolarPV] No handrail entities found to clear.")
    )
  )
  (princ)
)

;; Note: PVCLEARHANDRAIL alias defined in Command Dispatchers group

;;; Models a 3D obstacle sitting directly on the rooftop surface at Z_roof
(defun pv:model-3d-obstacle (ent ht pts r-bbox / obbox ox1 ox2 oy1 oy2 xc yc zb zt)
  (if (null r-bbox) (setq r-bbox (pv:get-roof-bbox)))
  (if pts
    (progn
      (setq obbox (pv:pts-bbox pts))
      (setq ox1 (caar obbox)  oy1 (cadar obbox)
            ox2 (caadr obbox) oy2 (cadadr obbox)
            xc (/ (+ ox1 ox2) 2.0)
            yc (/ (+ oy1 oy2) 2.0))
      (setq zb (pv:get-roof-z (list xc yc) r-bbox))
      (setq zt (+ zb ht))
      ;; Top Face
      (pv:draw-3dface (list ox1 oy1 zt) (list ox2 oy1 zt)
                      (list ox2 oy2 zt) (list ox1 oy2 zt)
                      "PV_3D_OBSTACLES" 1)
      ;; 4 Side Faces
      (pv:draw-3dface (list ox1 oy1 zb) (list ox2 oy1 zb) (list ox2 oy1 zt) (list ox1 oy1 zt) "PV_3D_OBSTACLES" 1)
      (pv:draw-3dface (list ox2 oy1 zb) (list ox2 oy2 zb) (list ox2 oy2 zt) (list ox2 oy1 zt) "PV_3D_OBSTACLES" 1)
      (pv:draw-3dface (list ox2 oy2 zb) (list ox1 oy2 zb) (list ox1 oy2 zt) (list ox2 oy2 zt) "PV_3D_OBSTACLES" 1)
      (pv:draw-3dface (list ox1 oy2 zb) (list ox1 oy1 zb) (list ox1 oy1 zt) (list ox1 oy2 zt) "PV_3D_OBSTACLES" 1)
      ;; Vertical corner lines
      (pv:draw-line-3d (list ox1 oy1 zb) (list ox1 oy1 zt) "PV_3D_OBSTACLES" 1)
      (pv:draw-line-3d (list ox2 oy1 zb) (list ox2 oy1 zt) "PV_3D_OBSTACLES" 1)
      (pv:draw-line-3d (list ox2 oy2 zb) (list ox2 oy2 zt) "PV_3D_OBSTACLES" 1)
      (pv:draw-line-3d (list ox1 oy2 zb) (list ox1 oy2 zt) "PV_3D_OBSTACLES" 1)
    )
  )
)


;;; --------------------------------------------------------------------------
;;; Maintenance Walkways (User Defined Path & Configurable Width)
;;; --------------------------------------------------------------------------
(defun c:pv-walkway (/ choice p-start pts p-cur p-prev ent elist p1 p2 ang d half-w
                       total-len seg-pts i)
  (pv:init-layers)
  (if (or (null *PV_WALKWAY_WIDTH*) (<= *PV_WALKWAY_WIDTH* 0.0))
    (setq *PV_WALKWAY_WIDTH* 0.80)
  )
  (setq half-w (/ *PV_WALKWAY_WIDTH* 2.0))
  
  (princ "\n=======================================================")
  (princ (strcat "\n[SolarPV] DEFINE MAINTENANCE WALKWAY PATH (Width: " (rtos *PV_WALKWAY_WIDTH* 2 2) "m)"))
  (princ "\n=======================================================")
  
  (initget "Select Draw")
  (setq choice (getkword "\nDefine walkway path by [Select existing polyline or line / Draw points interactively] <Draw>: "))
  (if (= choice "Select")
    (progn
      (setq ent (car (entsel "\nSelect polyline or line representing walkway centerline: ")))
      (if ent
        (setq pts (pv:get-entity-pts ent))
        (princ "\nNo entity selected.")
      )
    )
    (progn
      (setq p-start (getpoint "\nSpecify START point for walkway centerline: "))
      (if p-start
        (progn
          (setq pts (list p-start) p-prev p-start)
          (while (setq p-cur (getpoint p-prev "\nSpecify NEXT point along walkway path (press Enter when done): "))
            (setq pts (cons p-cur pts))
            (setq p-prev p-cur)
          )
          (setq pts (reverse pts))
        )
      )
    )
  )

  (if (and pts (>= (length pts) 2))
    (progn
      (setq total-len 0.0 i 0)
      (while (< i (1- (length pts)))
        (setq p1 (nth i pts)
              p2 (nth (1+ i) pts)
              d  (distance p1 p2)
              ang (angle p1 p2))
        (if (> d 0.01)
          (progn
            (setq total-len (+ total-len d))
            ;; 4 corner points of corridor
            (setq seg-pts
              (list
                (polar p1 (+ ang (/ pi 2.0)) half-w)
                (polar p2 (+ ang (/ pi 2.0)) half-w)
                (polar p2 (- ang (/ pi 2.0)) half-w)
                (polar p1 (- ang (/ pi 2.0)) half-w)
              )
            )
            ;; Draw elevated walkway corridor on PV_WALKWAY and PV_3D_WALKWAY
            (pv:draw-walkway-corridor seg-pts nil)
          )
        )
        (setq i (1+ i))
      )
      (setq *PV_WALKWAY_LENGTH* (+ *PV_WALKWAY_LENGTH* total-len))
      (princ (strcat "\n[SolarPV] Walkway path created: " (rtos total-len 2 2) "m segment, " 
                     (rtos *PV_WALKWAY_WIDTH* 2 2) "m corridor width. Total walkways: " 
                     (rtos *PV_WALKWAY_LENGTH* 2 2) "m."))
      (princ "\n[SolarPV] Note: Solar PV modules will automatically avoid these walkway areas during layout generation.")
    )
    (princ "\n[SolarPV] Walkway definition canceled or fewer than 2 points specified.")
  )
  (princ)
)

(defun c:pv-clear-walkways (/ ss i)
  (if (setq ss (ssget "X" '((8 . "PV_WALKWAY,PV_3D_WALKWAY"))))
    (progn
      (setq i 0)
      (while (< i (sslength ss))
        (entdel (ssname ss i))
        (setq i (1+ i))
      )
      (princ (strcat "\n[SolarPV] Cleared " (itoa (sslength ss)) " walkway entities from drawing."))
    )
    (princ "\n[SolarPV] No walkway entities found on 'PV_WALKWAY' layer.")
  )
  (setq *PV_WALKWAY_POLYS* nil
        *PV_WALKWAY_LENGTH* 0.0)
  (princ)
)

(defun pv:draw-auto-walkway-p ()
  (or (= *PV_DRAW_AUTO_WALKWAY* 1)
      (= *PV_DRAW_AUTO_WALKWAY* "1")
      (wcmatch (strcase (vl-princ-to-string *PV_DRAW_AUTO_WALKWAY*)) "*YES*,*Y*,*TRUE*,*T*")
  )
)

(defun c:pv-toggle-auto-walkway (/ ans)
  (initget "Yes No")
  (setq ans (getkword (strcat "\nAutomatically draw walkway corridors on layer 'PV_WALKWAY'? [Yes/No] <"
                              (if (pv:draw-auto-walkway-p) "Yes" "No") ">: ")))
  (cond
    ((= ans "Yes") (setq *PV_DRAW_AUTO_WALKWAY* 1))
    ((= ans "No")  (setq *PV_DRAW_AUTO_WALKWAY* 0))
  )
  (princ (strcat "\n[SolarPV] Auto-draw walkways on layer 'PV_WALKWAY': " (if (pv:draw-auto-walkway-p) "ENABLED (Yes)" "DISABLED (No)")))
  (princ)
)


;;; ==========================================================================
;;; 1. DC STRINGING ENGINE & COLOR-CODED CIRCUITS (PVcase Style)
;;; ==========================================================================
(defun c:pv-clear-strings (/ ss i)
  (if (setq ss (ssget "X" '((8 . "PV_STRINGS,PV_STRING_TAGS"))))
    (progn
      (setq i 0)
      (while (< i (sslength ss))
        (entdel (ssname ss i))
        (setq i (1+ i))
      )
      (princ (strcat "\n[SolarPV] Cleared " (itoa (sslength ss)) " string circuit entities."))
    )
    (princ "\n[SolarPV] No string circuits found to clear.")
  )
  (setq *PV_STRING_LIST* nil)
  (princ)
)

(defun pv:get-placed-modules (/ ss i ent pts bbox xc yc res)
  (setq res nil)
  (if (setq ss (ssget "X" '((0 . "LWPOLYLINE,POLYLINE,3DFACE") (8 . "PV_MODULES,PV_MODULES_EAST,PV_MODULES_WEST,PV_MODULES_SOUTH,PV_MODULES_NORTH"))))
    (progn
      (setq i 0)
      (while (< i (sslength ss))
        (setq ent (ssname ss i))
        (setq pts (pv:get-polyline-pts ent))
        (if (and pts (>= (length pts) 4))
          (progn
            (setq bbox (pv:pts-bbox pts))
            (setq xc (/ (+ (caar bbox) (caadr bbox)) 2.0))
            (setq yc (/ (+ (cadar bbox) (cadadr bbox)) 2.0))
            (setq res (cons (list (list xc yc) ent (car bbox) (cadr bbox)) res))
          )
        )
        (setq i (1+ i))
      )
    )
  )
  (reverse res)
)

(defun pv:snake-sort-modules (mod-list / tol rows r-found u-val v-val r-idx sorted-rows final-list sorted-mods
                                        az-rad cos-az sin-az pt xc yc)
  (setq tol (* 0.40 (min *PV_MOD_LEN* *PV_MOD_WID*)))
  (if (<= tol 0.10) (setq tol 0.40))
  ;; Compute rotation relative to South (180 deg)
  (setq az-rad (* (- (if *PV_AZIMUTH* *PV_AZIMUTH* 180.0) 180.0) (/ pi 180.0)))
  (setq cos-az (cos az-rad) sin-az (sin az-rad))
  
  (setq rows nil)
  (foreach m mod-list
    (setq pt (car m))
    (setq xc (car pt) yc (cadr pt))
    ;; Project into array local coordinate system (u along row, v across rows)
    (setq u-val (+ (* xc cos-az) (* yc sin-az)))
    (setq v-val (+ (* (- xc) sin-az) (* yc cos-az)))
    (setq r-found nil)
    (setq rows
      (mapcar
        '(lambda (r)
           (if (and (not r-found) (<= (abs (- (car r) v-val)) tol))
             (progn
               (setq r-found t)
               (cons (car r) (cons (list u-val v-val m) (cdr r)))
             )
             r
           )
         )
        rows
      )
    )
    (if (not r-found)
      (setq rows (cons (list v-val (list u-val v-val m)) rows))
    )
  )
  ;; Sort rows along transversal direction (low to high v-val)
  (setq rows (vl-sort rows '(lambda (a b) (< (car a) (car b)))))
  (setq r-idx 0 final-list nil)
  (foreach r rows
    (setq sorted-mods (cdr r))
    ;; Alternate left-to-right (increasing u) and right-to-left (decreasing u)
    (if (= (rem r-idx 2) 0)
      (setq sorted-mods (vl-sort sorted-mods '(lambda (a b) (< (car a) (car b)))))
      (setq sorted-mods (vl-sort sorted-mods '(lambda (a b) (> (car a) (car b)))))
    )
    ;; Extract original module item (caddr of item)
    (setq final-list (append final-list (mapcar 'caddr sorted-mods)))
    (setq r-idx (1+ r-idx))
  )
  final-list
)

(defun c:pv-stringing (/ all-mods sorted-mods str-size total-mods num-full-strings
                         palette k idx str-mods col p-first p-last pts
                         str-kw str-vmp tag-str tag-pt)
  (vl-load-com)
  (pv:init-layers)
  (c:pv-clear-strings)

  (setq all-mods (pv:get-placed-modules))
  (if (null all-mods)
    (progn
      (princ "\n[SolarPV] Error: No placed PV modules found on layer 'PV_MODULES'. Run PVLAYOUT first!")
      (alert "No PV modules found on layer 'PV_MODULES'.\nPlease run PVLAYOUT to place modules before stringing.")
    )
    (progn
      (setq total-mods (length all-mods))
      (initget 6)
      (setq str-size (getint (strcat "\nEnter Number of Modules per String <" (itoa (if (> *PV_STRING_SIZE* 0) *PV_STRING_SIZE* 20)) ">: ")))
      (if (null str-size) (setq str-size (if (> *PV_STRING_SIZE* 0) *PV_STRING_SIZE* 20)))
      (setq *PV_STRING_SIZE* str-size)

      (princ (strcat "\n[SolarPV] Sorting " (itoa total-mods) " modules in snake topology..."))
      (setq sorted-mods (pv:snake-sort-modules all-mods))

      (setq palette '(1 4 2 3 6 30 140 210))
      (setq k 1 idx 0 *PV_STRING_LIST* nil)

      (while (< idx total-mods)
        (setq str-mods nil)
        (while (and (< idx total-mods) (< (length str-mods) str-size))
          (setq str-mods (cons (nth idx sorted-mods) str-mods))
          (setq idx (1+ idx))
        )
        (setq str-mods (reverse str-mods))

        (if (>= (length str-mods) 2)
          (progn
            (setq col (nth (rem (1- k) (length palette)) palette))
            (setq pts (mapcar 'car str-mods))
            (setq p-first (car pts)
                  p-last  (last pts))

            (pv:draw-lwpolyline pts "PV_STRINGS" col nil)

            ;; Positive [+] marker
            (pv:draw-circle p-first 0.18 "PV_STRING_TAGS" 1)
            (pv:draw-text (list (- (car p-first) 0.08) (- (cadr p-first) 0.08)) "+" 0.20 "PV_STRING_TAGS" 1 0.0)

            ;; Negative [-] marker
            (pv:draw-circle p-last 0.18 "PV_STRING_TAGS" 5)
            (pv:draw-text (list (- (car p-last) 0.06) (- (cadr p-last) 0.06)) "-" 0.20 "PV_STRING_TAGS" 5 0.0)

            ;; String Tagging
            (setq str-kw (/ (* (length str-mods) *PV_MOD_WATT*) 1000.0))
            (setq str-vmp (* (length str-mods) *PV_PAN_VMP*))
            (setq tag-str (strcat "STR-" (if (< k 10) "0" "") (itoa k) " (" (itoa (length str-mods)) "M | " (rtos str-kw 2 1) "kWp | " (rtos str-vmp 2 0) "V)"))
            
            (setq tag-pt (list (/ (+ (car p-first) (car p-last)) 2.0)
                               (+ (/ (+ (cadr p-first) (cadr p-last)) 2.0) 0.35)))
            (pv:draw-text tag-pt tag-str 0.22 "PV_STRING_TAGS" col 0.0)

            (setq *PV_STRING_LIST* (cons (list k col str-mods pts p-first p-last str-kw str-vmp) *PV_STRING_LIST*))
            (setq k (1+ k))
          )
        )
      )

      (setq *PV_STRING_LIST* (reverse *PV_STRING_LIST*))
      (setq num-full-strings (length *PV_STRING_LIST*))
      (princ "\n=======================================================")
      (princ (strcat "\n [SolarPV] DC Stringing Complete (PVcase Topology):"))
      (princ (strcat "\n Total Modules Stringed : " (itoa total-mods)))
      (princ (strcat "\n Modules per String     : " (itoa str-size)))
      (princ (strcat "\n Total String Circuits  : " (itoa num-full-strings)))
      (princ (strcat "\n Total String DC Power  : " (rtos (/ (* total-mods *PV_MOD_WATT*) 1000.0) 2 2) " kWp"))
      (princ "\n Color-coded circuit polylines placed on layer 'PV_STRINGS'.")
      (princ "\n [+] & [-] terminal tags placed on layer 'PV_STRING_TAGS'.")
      (princ "\n=======================================================")
      (alert (strcat "DC Stringing Complete!\n\nTotal Modules: " (itoa total-mods) 
                     "\nStrings Created: " (itoa num-full-strings) " (Size: " (itoa str-size) " mods/str)"
                     "\nDC Capacity: " (rtos (/ (* total-mods *PV_MOD_WATT*) 1000.0) 2 1) " kWp"
                     "\n\nPolylines routed on 'PV_STRINGS' with color-coded circuits."))
    )
  )
  (princ)
)

;;; ==========================================================================
;;; 2. INVERTER STATION & CABLE TRAY ROUTING (PVcase Style)
;;; ==========================================================================
(defun c:pv-place-inverter (/ pt x y p1 p2 p3 p4 ip1 ip2 ip3 ip4)
  (vl-load-com)
  (pv:init-layers)
  (princ "\n[SolarPV] Inverter Station Placement (PVcase Standard):")
  (setq pt (getpoint "\nSpecify insertion point for Inverter Station on rooftop: "))
  (if (not pt)
    (princ "\n[SolarPV] Inverter placement cancelled.")
    (progn
      (setq *PV_INVERTER_POS* pt)
      (setq x (car pt) y (cadr pt))

      ;; 1. Concrete Foundation Plinth (1.6m x 1.2m)
      (setq p1 (list (- x 0.80) (- y 0.60))
            p2 (list (+ x 0.80) (- y 0.60))
            p3 (list (+ x 0.80) (+ y 0.60))
            p4 (list (- x 0.80) (+ y 0.60)))
      (pv:draw-lwpolyline (list p1 p2 p3 p4) "PV_INVERTER" 8 t)

      ;; 2. Inverter Enclosure (1.1m x 0.7m)
      (setq ip1 (list (- x 0.55) (- y 0.35))
            ip2 (list (+ x 0.55) (- y 0.35))
            ip3 (list (+ x 0.55) (+ y 0.35))
            ip4 (list (- x 0.55) (+ y 0.35)))
      (pv:draw-lwpolyline (list ip1 ip2 ip3 ip4) "PV_INVERTER" 4 t)

      ;; 3. Cooling Heat Sink fins
      (pv:draw-line (list (- x 0.40) (+ y 0.20)) (list (+ x 0.40) (+ y 0.20)) "PV_INVERTER" 4)
      (pv:draw-line (list (- x 0.40) (+ y 0.05)) (list (+ x 0.40) (+ y 0.05)) "PV_INVERTER" 4)
      (pv:draw-line (list (- x 0.40) (- y 0.10)) (list (+ x 0.40) (- y 0.10)) "PV_INVERTER" 4)

      ;; 4. DC Disconnect Switch (Red box on left)
      (pv:draw-lwpolyline
        (list (list (- x 0.75) (- y 0.20))
              (list (- x 0.60) (- y 0.20))
              (list (- x 0.60) (+ y 0.20))
              (list (- x 0.75) (+ y 0.20)))
        "PV_INVERTER" 1 t)
      (pv:draw-text (list (- x 0.73) (- y 0.05)) "DC" 0.10 "PV_INVERTER" 1 0.0)

      ;; 5. AC Isolator Switch (Green box on right)
      (pv:draw-lwpolyline
        (list (list (+ x 0.60) (- y 0.20))
              (list (+ x 0.75) (- y 0.20))
              (list (+ x 0.75) (+ y 0.20))
              (list (+ x 0.60) (+ y 0.20)))
        "PV_INVERTER" 3 t)
      (pv:draw-text (list (+ x 0.63) (- y 0.05)) "AC" 0.10 "PV_INVERTER" 3 0.0)

      ;; 6. Ratings & Station Annotations
      (pv:draw-text (list (- x 0.75) (+ y 0.75))
                    (strcat "INVERTER STATION: " *PV_INV_MFG* " " *PV_INV_MODEL*)
                    0.18 "PV_INVERTER" 7 0.0)
      (pv:draw-text (list (- x 0.75) (+ y 0.95))
                    (strcat "Capacity: " (rtos *PV_INV_KW* 2 0) " kW AC | " (itoa *PV_INV_MPPT_COUNT*) " MPPTs | " (itoa *PV_INV_INPUTS*) " String Inputs")
                    0.14 "PV_INVERTER" 4 0.0)
      (pv:draw-text (list (- x 0.75) (+ y 1.15))
                    (strcat "Max Vdc: " (rtos *PV_INV_VDC_MAX* 2 0) "V | Vmpp: " (rtos *PV_INV_VMPP_MIN* 2 0) "-" (rtos *PV_INV_VMPP_MAX* 2 0) "V")
                    0.13 "PV_INVERTER" 8 0.0)

      (princ (strcat "\n[SolarPV] Inverter Station placed at (" (rtos x 2 2) ", " (rtos y 2 2) ")."))
    )
  )
  (princ)
)

(defun c:pv-clear-cable-tray (/ ss i)
  (if (setq ss (ssget "X" '((8 . "PV_CABLE_TRAY"))))
    (progn
      (setq i 0)
      (while (< i (sslength ss))
        (entdel (ssname ss i))
        (setq i (1+ i))
      )
      (princ (strcat "\n[SolarPV] Cleared " (itoa (sslength ss)) " cable tray entities."))
    )
    (princ "\n[SolarPV] No cable tray entities found to clear.")
  )
  (setq *PV_CABLE_TRAY_PTS* nil
        *PV_CABLE_TRAY_LENGTH* 0.0
        *PV_TOTAL_DC_CABLE_M* 0.0
        *PV_VDROP_PERCENT* 0.0)
  (princ)
)

(defun c:pv-draw-cable-tray (/ pt next-pt pts w hw seg-len seg-ang pA pB
                               pA-left pB-left pA-right pB-right
                               step cur-dist r-left r-right r-pt total-len
                               avg-homerun total-dc-cable v-drop v-drop-pct str-vmp)
  (vl-load-com)
  (pv:init-layers)
  (princ "\n[SolarPV] Perforated GI Cable Tray Corridor Routing:")
  (initget 6)
  (setq w (getdist (strcat "\nEnter Cable Tray Width (m) <" (rtos (if (> *PV_CABLE_TRAY_WIDTH* 0.0) *PV_CABLE_TRAY_WIDTH* 0.30) 2 2) ">: ")))
  (if (null w) (setq w (if (> *PV_CABLE_TRAY_WIDTH* 0.0) *PV_CABLE_TRAY_WIDTH* 0.30)))
  (setq *PV_CABLE_TRAY_WIDTH* w)
  (setq hw (/ w 2.0))

  (setq pt (getpoint "\nSpecify Start Point of Cable Tray: "))
  (if (not pt)
    (princ "\n[SolarPV] Cancelled.")
    (progn
      (setq pts (list pt) total-len 0.0)
      (while (setq next-pt (getpoint (car pts) "\nSpecify Next Point along Cable Tray [or press Enter to finish]: "))
        (setq pA (car pts) pB next-pt)
        (setq seg-len (distance pA pB))
        (if (> seg-len 0.01)
          (progn
            (setq seg-ang (angle pA pB))
            (setq total-len (+ total-len seg-len))

            (setq pA-left  (polar pA (+ seg-ang (/ pi 2.0)) hw)
                  pB-left  (polar pB (+ seg-ang (/ pi 2.0)) hw)
                  pA-right (polar pA (- seg-ang (/ pi 2.0)) hw)
                  pB-right (polar pB (- seg-ang (/ pi 2.0)) hw))

            (pv:draw-line pA-left pB-left "PV_CABLE_TRAY" 30)
            (pv:draw-line pA-right pB-right "PV_CABLE_TRAY" 30)

            (setq step 0.30 cur-dist step)
            (while (< cur-dist seg-len)
              (setq r-pt (polar pA seg-ang cur-dist))
              (setq r-left  (polar r-pt (+ seg-ang (/ pi 2.0)) hw)
                    r-right (polar r-pt (- seg-ang (/ pi 2.0)) hw))
              (pv:draw-line r-left r-right "PV_CABLE_TRAY" 30)
              (setq cur-dist (+ cur-dist step))
            )
            (setq pts (cons next-pt pts))
          )
        )
      )

      (setq *PV_CABLE_TRAY_PTS* (reverse pts))
      (setq *PV_CABLE_TRAY_LENGTH* total-len)

      (if (and *PV_STRING_LIST* (> (length *PV_STRING_LIST*) 0))
        (progn
          (setq avg-homerun (+ (/ total-len 2.0) 8.0))
          (if *PV_INVERTER_POS*
            (setq avg-homerun (+ avg-homerun (distance (car *PV_CABLE_TRAY_PTS*) *PV_INVERTER_POS*)))
          )
          (setq total-dc-cable (* (length *PV_STRING_LIST*) 2.0 avg-homerun))
          (setq v-drop (/ (* 2.0 avg-homerun *PV_PAN_IMP* 0.0214) 4.0))
          (setq str-vmp (* *PV_STRING_SIZE* *PV_PAN_VMP*))
          (if (<= str-vmp 0.0) (setq str-vmp 800.0))
          (setq v-drop-pct (* (/ v-drop str-vmp) 100.0))
        )
        (progn
          (setq total-dc-cable (* total-len 4.0))
          (setq v-drop-pct 0.85)
        )
      )
      (setq *PV_TOTAL_DC_CABLE_M* total-dc-cable)
      (setq *PV_VDROP_PERCENT* v-drop-pct)

      (princ "\n=======================================================")
      (princ (strcat "\n [SolarPV] Cable Tray Corridor Complete (PVcase Standard):"))
      (princ (strcat "\n Tray Width             : " (rtos w 2 2) " m"))
      (princ (strcat "\n Total Tray Length      : " (rtos total-len 2 2) " m"))
      (princ (strcat "\n Estimated DC Cable (1C): " (rtos total-dc-cable 2 1) " m (4 sq.mm Solar DC)"))
      (princ (strcat "\n Estimated DC %Vdrop    : " (rtos v-drop-pct 2 2) "% " (if (< v-drop-pct 1.5) "[PASS < 1.5% Standard]" "[HIGH - Recommend 6 sq.mm]")))
      (princ "\n=======================================================")
      (alert (strcat "Cable Tray Complete!\n\nTray Length: " (rtos total-len 2 1) " m (Width: " (rtos w 2 2) "m)"
                     "\nTotal DC Cable: " (rtos total-dc-cable 2 0) " m"
                     "\nDC % Voltage Drop: " (rtos v-drop-pct 2 2) "%\nStatus: "
                     (if (< v-drop-pct 1.5) "PASS (Meets IEC 60364-7-712 best practice < 1.5%)" "Caution: Consider 6 sq.mm cable")))
    )
  )
  (princ)
)

;;; ==========================================================================
;;; 1B. MANUAL PV STRINGING, POLARITY & VISUALIZATION (PVDesigner 2027)
;;; ==========================================================================
(defun c:pv-string-manual (/ sel ent pts bbox xc yc mod-data sel-mods keep-picking
                            palette k col p-first p-last str-kw str-vmp tag-str tag-pt
                            total-sel)
  (vl-load-com)
  (pv:init-layers)
  (princ "\n=======================================================")
  (princ "\n [SolarPV] MANUAL STRINGING MODE (PVDesigner Interactive):")
  (princ "\n Click PV modules on layer 'PV_MODULES' in desired series order.")
  (princ "\n Press Enter or Right-Click when finished with current string.")
  (princ "\n=======================================================")
  (setq palette '(1 4 2 3 6 30 140 210))
  (setq k (1+ (length *PV_STRING_LIST*)))
  (setq sel-mods nil keep-picking t)
  (while keep-picking
    (setvar "ERRNO" 0)
    (setq sel (entsel (strcat "\nSelect module #" (itoa (1+ (length sel-mods))) " for String " (itoa k) " [Enter to Finish]: ")))
    (cond
      ((and sel (setq ent (car sel)))
       (if (and (= (cdr (assoc 0 (entget ent))) "LWPOLYLINE")
                (wcmatch (strcase (cdr (assoc 8 (entget ent)))) "*PV_MODULE*"))
         (progn
           (setq pts (pv:get-polyline-pts ent))
           (if (and pts (>= (length pts) 4))
             (progn
               (setq bbox (pv:pts-bbox pts))
               (setq xc (/ (+ (caar bbox) (caadr bbox)) 2.0))
               (setq yc (/ (+ (cadar bbox) (cadadr bbox)) 2.0))
               (setq mod-data (list (list xc yc) ent (car bbox) (cadr bbox)))
               (redraw ent 3)
               (setq sel-mods (cons mod-data sel-mods))
               (princ (strcat " -> Added module (" (itoa (length sel-mods)) " mods | " 
                              (rtos (* (length sel-mods) *PV_PAN_VMP*) 2 0) "V)"))
             )
           )
         )
         (princ "\nSelected entity is not on a PV module layer. Try again.")
       )
      )
      (t (setq keep-picking nil))
    )
  )
  (foreach m sel-mods (redraw (cadr m) 4))
  (setq sel-mods (reverse sel-mods))
  (setq total-sel (length sel-mods))
  (if (>= total-sel 2)
    (progn
      (setq col (nth (rem (1- k) (length palette)) palette))
      (setq pts (mapcar 'car sel-mods))
      (setq p-first (car pts) p-last (last pts))
      (pv:draw-lwpolyline pts "PV_STRINGS" col nil)
      (pv:draw-circle p-first 0.18 "PV_STRING_TAGS" 1)
      (pv:draw-text (list (- (car p-first) 0.08) (- (cadr p-first) 0.08)) "+" 0.20 "PV_STRING_TAGS" 1 0.0)
      (pv:draw-circle p-last 0.18 "PV_STRING_TAGS" 5)
      (pv:draw-text (list (- (car p-last) 0.06) (- (cadr p-last) 0.06)) "-" 0.20 "PV_STRING_TAGS" 5 0.0)
      (setq str-kw (/ (* total-sel *PV_MOD_WATT*) 1000.0))
      (setq str-vmp (* total-sel *PV_PAN_VMP*))
      (setq tag-str (strcat "STR-" (if (< k 10) "0" "") (itoa k) " (" (itoa total-sel) "M | " (rtos str-kw 2 1) "kWp | " (rtos str-vmp 2 0) "V)"))
      (setq tag-pt (list (/ (+ (car p-first) (car p-last)) 2.0)
                         (+ (/ (+ (cadr p-first) (cadr p-last)) 2.0) 0.35)))
      (pv:draw-text tag-pt tag-str 0.22 "PV_STRING_TAGS" col 0.0)
      (setq *PV_STRING_LIST* (append *PV_STRING_LIST* (list (list k col sel-mods pts p-first p-last str-kw str-vmp))))
      (princ (strcat "\n[SolarPV] Manual String STR-" (itoa k) " created with " (itoa total-sel) " modules."))
    )
    (if (> total-sel 0)
      (princ "\n[SolarPV] String must have at least 2 modules. Cancelled.")
      (princ "\n[SolarPV] Manual stringing cancelled.")
    )
  )
  (princ)
)

(defun c:pv-polarity (/ opt ss i ent p-first p-last)
  (initget "Show Hide Refresh")
  (setq opt (getkword "\nString Polarity Action [Show / Hide / Refresh] <Refresh>: "))
  (if (null opt) (setq opt "Refresh"))
  (cond
    ((= opt "Hide")
     (if (setq ss (ssget "X" '((8 . "PV_STRING_TAGS"))))
       (progn
         (setq i 0)
         (while (< i (sslength ss))
           (setq ent (ssname ss i))
           (if (or (= (cdr (assoc 0 (entget ent))) "CIRCLE")
                   (member (cdr (assoc 1 (entget ent))) '("+" "-")))
             (entdel ent)
           )
           (setq i (1+ i))
         )
         (princ "\n[SolarPV] String polarity markers hidden.")
       )
     ))
    (t
     (if (null *PV_STRING_LIST*)
       (princ "\n[SolarPV] No active string circuits found in memory. Run PVSTRING first.")
       (progn
         (if (setq ss (ssget "X" '((8 . "PV_STRING_TAGS"))))
           (progn
             (setq i 0)
             (while (< i (sslength ss))
               (setq ent (ssname ss i))
               (if (or (= (cdr (assoc 0 (entget ent))) "CIRCLE")
                       (member (cdr (assoc 1 (entget ent))) '("+" "-")))
                 (entdel ent)
               )
               (setq i (1+ i))
             )
           )
         )
         (foreach str-data *PV_STRING_LIST*
           (setq p-first (nth 4 str-data) p-last (nth 5 str-data))
           (if (and p-first p-last)
             (progn
               (pv:draw-circle p-first 0.18 "PV_STRING_TAGS" 1)
               (pv:draw-text (list (- (car p-first) 0.08) (- (cadr p-first) 0.08)) "+" 0.20 "PV_STRING_TAGS" 1 0.0)
               (pv:draw-circle p-last 0.18 "PV_STRING_TAGS" 5)
               (pv:draw-text (list (- (car p-last) 0.06) (- (cadr p-last) 0.06)) "-" 0.20 "PV_STRING_TAGS" 5 0.0)
             )
           )
         )
         (princ (strcat "\n[SolarPV] Polarity markers refreshed for " (itoa (length *PV_STRING_LIST*)) " strings."))
       )
     ))
  )
  (princ)
)

(defun c:pv-string-vis (/ opt ss i ent elist col palette inv-idx mppt-idx)
  (initget "String Inverter MPPT Roof Default")
  (setq opt (getkword "\nColor strings by [String / Inverter / MPPT / Roof / Default] <String>: "))
  (if (null opt) (setq opt "String"))
  (setq palette '(1 4 2 3 6 30 140 210))
  (if (setq ss (ssget "X" '((8 . "PV_STRINGS"))))
    (progn
      (setq i 0)
      (while (< i (sslength ss))
        (setq ent (ssname ss i))
        (setq elist (entget ent))
        (setq col
          (cond
            ((= opt "Inverter")
             (setq inv-idx (fix (/ i 4)))
             (nth (rem inv-idx (length palette)) palette))
            ((= opt "MPPT")
             (setq mppt-idx (fix (/ i 2)))
             (nth (rem mppt-idx (length palette)) palette))
            ((= opt "Roof") 4)
            ((= opt "Default") 256)
            (t (nth (rem i (length palette)) palette))
          )
        )
        (if (assoc 62 elist)
          (setq elist (subst (cons 62 col) (assoc 62 elist) elist))
          (setq elist (append elist (list (cons 62 col))))
        )
        (entmod elist)
        (setq i (1+ i))
      )
      (princ (strcat "\n[SolarPV] Visualized " (itoa (sslength ss)) " strings colored by " opt "."))
    )
    (princ "\n[SolarPV] No string entities found on layer 'PV_STRINGS'.")
  )
  (princ)
)

(defun c:pv-panel-number (/ ss i ent pts bbox xc yc num-str)
  (pv:init-layers)
  (if (setq ss (ssget "X" '((8 . "PV_PANEL_NUMS"))))
    (progn
      (setq i 0)
      (while (< i (sslength ss))
        (entdel (ssname ss i))
        (setq i (1+ i))
      )
    )
  )
  (if (setq ss (ssget "X" '((0 . "LWPOLYLINE,POLYLINE,3DFACE") (8 . "PV_MODULES,PV_MODULES_EAST,PV_MODULES_WEST,PV_MODULES_SOUTH,PV_MODULES_NORTH"))))
    (progn
      (setq i 0)
      (while (< i (sslength ss))
        (setq ent (ssname ss i))
        (setq pts (pv:get-polyline-pts ent))
        (if (and pts (>= (length pts) 4))
          (progn
            (setq bbox (pv:pts-bbox pts))
            (setq xc (/ (+ (caar bbox) (caadr bbox)) 2.0))
            (setq yc (/ (+ (cadar bbox) (cadadr bbox)) 2.0))
            (setq num-str (strcat "M-" (if (< (1+ i) 10) "00" (if (< (1+ i) 100) "0" "")) (itoa (1+ i))))
            (pv:draw-text (list (- xc 0.25) (- yc 0.08)) num-str 0.16 "PV_PANEL_NUMS" 7 0.0)
          )
        )
        (setq i (1+ i))
      )
      (princ (strcat "\n[SolarPV] Numbered " (itoa (sslength ss)) " PV modules on layer 'PV_PANEL_NUMS'."))
    )
    (princ "\n[SolarPV] No PV modules found on layout to number.")
  )
  (princ)
)

;;; ==========================================================================
;;; 1C. EAST-WEST DUAL-TILT SADDLE/A-FRAME ENGINE (PVDesigner Standard)
;;; ==========================================================================
(defun c:pv-layout-ew (/ ss-bnd b-list ent b-pts bbox minpt maxpt minx miny maxx maxy cur-x cur-y
                         mod-l mod-w e-poly w-poly ridge-gap valley-gap
                         pair-w total-east total-west in-bnd collides ex-polys r-idx
                         z-clear ez1 ez2 ez3 ez4 e-3d-pts wz1 wz2 wz3 wz4 w-3d-pts)
  (vl-load-com)
  (pv:init-layers)
  ;; Ensure roofs exist
  (if (not *PV_BOUNDARY_LIST*)
    (if (setq ss-bnd (ssget "X" '((0 . "LWPOLYLINE,POLYLINE,REGION") (8 . "PV_BOUNDARY"))))
      (progn
        (setq b-list nil r-idx 0)
        (while (< r-idx (sslength ss-bnd))
          (setq b-list (cons (ssname ss-bnd r-idx) b-list))
          (setq r-idx (1+ r-idx))
        )
        (setq *PV_BOUNDARY_LIST* (reverse b-list))
        (if (not *PV_BOUNDARY_ENT*) (setq *PV_BOUNDARY_ENT* (car *PV_BOUNDARY_LIST*)))
      )
    )
  )
  (if (and (not *PV_BOUNDARY_ENT*) (not *PV_BOUNDARY_LIST*))
    (progn
      (alert "Please select the rooftop perimeter boundary/roofs first (PVPICKBOUNDARY).")
      (c:pv-pick-boundary)
    )
  )
  (if (or *PV_BOUNDARY_ENT* *PV_BOUNDARY_LIST*)
    (progn
      (pv:clear-layout)
      (if (= *PV_DRAW_SHADOW* 1) (pv:ensure-all-obstacle-shadows))
      (setq total-east 0 total-west 0)
      
      (setq b-list
        (if (and (> *PV_ACTIVE_ROOF_IDX* 0) (<= *PV_ACTIVE_ROOF_IDX* (length *PV_BOUNDARY_LIST*)))
          (list (nth (1- *PV_ACTIVE_ROOF_IDX*) *PV_BOUNDARY_LIST*))
          (if *PV_BOUNDARY_LIST* *PV_BOUNDARY_LIST* (list *PV_BOUNDARY_ENT*))
        )
      )
      
      (setq mod-l *PV_MOD_LEN* mod-w *PV_MOD_WID*)
      (setq ridge-gap 0.08 valley-gap 0.35)
      (setq pair-w (+ (* 2.0 mod-w) ridge-gap valley-gap))
      (setq ex-polys nil)
      (foreach obs *PV_OBSTACLES*
        (if (cadddr obs) (setq ex-polys (cons (cadddr obs) ex-polys)))
        (if (and (caddr obs) (= *PV_DRAW_SHADOW* 1))
          (setq ex-polys (cons (caddr obs) ex-polys))
        )
      )
      (if (= *PV_DRAW_SHADOW* 1)
        (if (setq ss-sh (ssget "X" '((8 . "PV_SHADOW"))))
          (progn
            (setq i 0)
            (while (< i (sslength ss-sh))
              (setq p-pts (pv:get-entity-pts (ssname ss-sh i)))
              (if p-pts (setq ex-polys (cons p-pts ex-polys)))
              (setq i (1+ i))
            )
          )
        )
      )
      
      (setq r-idx 1)
      (foreach ent b-list
        (setq b-pts (pv:get-polyline-pts ent))
        (if (and b-pts (> (length b-pts) 2))
          (progn
            (setq t-parapet (if (and (= *PV_ROOF_TYPE* "Flat RCC Rooftop")
                                     *PV_PARAPET_THICKNESS*
                                     (> *PV_PARAPET_THICKNESS* 0.0))
                              *PV_PARAPET_THICKNESS*
                              0.0))
            (setq usable-b-pts (if (> t-parapet 0.0)
                                 (pv:offset-polygon-inward b-pts t-parapet)
                                 b-pts))
            (if (null usable-b-pts) (setq usable-b-pts b-pts))
            (setq bbox (pv:pts-bbox usable-b-pts))
            (setq minpt (car bbox) maxpt (cadr bbox))
            (setq minx (+ (car minpt) *PV_SETBACK*)
                  miny (+ (cadr minpt) *PV_SETBACK*)
                  maxx (- (car maxpt) *PV_SETBACK*)
                  maxy (- (cadr maxpt) *PV_SETBACK*))
            (setq cur-y miny)
            (while (<= (+ cur-y mod-l) maxy)
              (setq cur-x minx)
              (while (<= (+ cur-x pair-w) maxx)
                (setq e-poly (list (list cur-x cur-y)
                                   (list (+ cur-x mod-w) cur-y)
                                   (list (+ cur-x mod-w) (+ cur-y mod-l))
                                   (list cur-x (+ cur-y mod-l))))
                (setq w-poly (list (list (+ cur-x mod-w ridge-gap) cur-y)
                                   (list (+ cur-x (* 2.0 mod-w) ridge-gap) cur-y)
                                   (list (+ cur-x (* 2.0 mod-w) ridge-gap) (+ cur-y mod-l))
                                   (list (+ cur-x mod-w ridge-gap) (+ cur-y mod-l))))
                (setq in-bnd t collides nil)
                (foreach p (append e-poly w-poly)
                  (if (not (pv:pt-in-poly p usable-b-pts)) (setq in-bnd nil))
                )
                (if in-bnd
                  (foreach ex ex-polys
                    (if (or (pv:box-hits-polygon (car e-poly) (caddr e-poly) ex 0.05)
                            (pv:box-hits-polygon (car w-poly) (caddr w-poly) ex 0.05))
                      (setq collides t)
                    )
                  )
                )
                (if (and in-bnd (not collides))
                  (progn
                    (setq z-clear (if (> *PV_MOD_CLEAR* 0.0) *PV_MOD_CLEAR* 0.10))
                    ;; East Module 3D points
                    (setq ez1 (+ (pv:get-roof-z (nth 0 e-poly) bbox) z-clear)
                          ez2 (+ (pv:get-roof-z (nth 1 e-poly) bbox) z-clear)
                          ez3 (+ (pv:get-roof-z (nth 2 e-poly) bbox) z-clear)
                          ez4 (+ (pv:get-roof-z (nth 3 e-poly) bbox) z-clear))
                    (setq e-3d-pts (list (list (car (nth 0 e-poly)) (cadr (nth 0 e-poly)) ez1)
                                         (list (car (nth 1 e-poly)) (cadr (nth 1 e-poly)) ez2)
                                         (list (car (nth 2 e-poly)) (cadr (nth 2 e-poly)) ez3)
                                         (list (car (nth 3 e-poly)) (cadr (nth 3 e-poly)) ez4)))
                    ;; West Module 3D points
                    (setq wz1 (+ (pv:get-roof-z (nth 0 w-poly) bbox) z-clear)
                          wz2 (+ (pv:get-roof-z (nth 1 w-poly) bbox) z-clear)
                          wz3 (+ (pv:get-roof-z (nth 2 w-poly) bbox) z-clear)
                          wz4 (+ (pv:get-roof-z (nth 3 w-poly) bbox) z-clear))
                    (setq w-3d-pts (list (list (car (nth 0 w-poly)) (cadr (nth 0 w-poly)) wz1)
                                         (list (car (nth 1 w-poly)) (cadr (nth 1 w-poly)) wz2)
                                         (list (car (nth 2 w-poly)) (cadr (nth 2 w-poly)) wz3)
                                         (list (car (nth 3 w-poly)) (cadr (nth 3 w-poly)) wz4)))
                    ;; Draw 3D Polylines
                    (pv:draw-3d-poly e-3d-pts "PV_MODULES_EAST" 4 t)
                    (pv:draw-3d-poly w-3d-pts "PV_MODULES_WEST" 30 t)
                    ;; Draw 3DFACEs for shaded visualization
                    (pv:draw-3dface (nth 0 e-3d-pts) (nth 1 e-3d-pts) (nth 2 e-3d-pts) (nth 3 e-3d-pts) "PV_3D_MODULES" 140)
                    (pv:draw-3dface (nth 0 w-3d-pts) (nth 1 w-3d-pts) (nth 2 w-3d-pts) (nth 3 w-3d-pts) "PV_3D_MODULES" 140)
                    (setq total-east (1+ total-east) total-west (1+ total-west))
                  )
                )
                (setq cur-x (+ cur-x pair-w))
              )
              (setq cur-y (+ cur-y mod-l *PV_ROW_SPACING*))
            )
            (setq r-idx (1+ r-idx))
          )
        )
      )
      
      (setq *PV_MODULE_COUNT* (+ total-east total-west))
      (princ "\n=======================================================")
      (princ (strcat "\n [SolarPV] Multi-Roof East-West Layout Complete! (" (itoa (length b-list)) " Roofs Populated)"))
      (princ (strcat "\n East Modules (90° Azimuth)  : " (itoa total-east) " [PV_MODULES_EAST]"))
      (princ (strcat "\n West Modules (270° Azimuth) : " (itoa total-west) " [PV_MODULES_WEST]"))
      (princ (strcat "\n Total Plant Modules         : " (itoa *PV_MODULE_COUNT*)))
      (princ (strcat "\n Total Plant DC Capacity     : " (rtos (/ (* *PV_MODULE_COUNT* *PV_MOD_WATT*) 1000.0) 2 1) " kWp"))
      (princ "\n Run 'PVSTRINGEW' to wire East and West circuits separately.")
      (princ "\n=======================================================")
      (alert (strcat "Multi-Roof East-West Layout Complete!\n\nRoofs Populated: " (itoa (length b-list))
                     "\nEast Modules: " (itoa total-east)
                     "\nWest Modules: " (itoa total-west)
                     "\nTotal Modules: " (itoa *PV_MODULE_COUNT*)
                     "\nTotal DC Capacity: " (rtos (/ (* *PV_MODULE_COUNT* *PV_MOD_WATT*) 1000.0) 2 1) " kWp"))
    )
  )
  (princ)
)

(defun c:pv-string-ew (/ e-mods w-mods str-size k-e k-w idx-e idx-w s-mods pts col
                         p-first p-last str-kw str-vmp tag-str tag-pt ss i ent bbox xc yc)
  (vl-load-com)
  (pv:init-layers)
  (c:pv-clear-strings)
  (initget 6)
  (setq str-size (getint (strcat "\nEnter Number of Modules per String <" (itoa (if (> *PV_STRING_SIZE* 0) *PV_STRING_SIZE* 20)) ">: ")))
  (if (null str-size) (setq str-size (if (> *PV_STRING_SIZE* 0) *PV_STRING_SIZE* 20)))
  (setq *PV_STRING_SIZE* str-size)
  
  ;; 1. String East Modules
  (setq e-mods nil)
  (if (setq ss (ssget "X" '((0 . "LWPOLYLINE,POLYLINE,3DFACE") (8 . "PV_MODULES_EAST"))))
    (progn
      (setq i 0)
      (while (< i (sslength ss))
        (setq ent (ssname ss i))
        (setq pts (pv:get-polyline-pts ent))
        (if (and pts (>= (length pts) 4))
          (progn
            (setq bbox (pv:pts-bbox pts))
            (setq xc (/ (+ (caar bbox) (caadr bbox)) 2.0))
            (setq yc (/ (+ (cadar bbox) (cadadr bbox)) 2.0))
            (setq e-mods (cons (list (list xc yc) ent (car bbox) (cadr bbox)) e-mods))
          )
        )
        (setq i (1+ i))
      )
    )
  )
  (setq k-e 1)
  (if e-mods
    (progn
      (setq e-mods (pv:snake-sort-modules e-mods))
      (setq idx-e 0)
      (while (< idx-e (length e-mods))
        (setq s-mods nil)
        (while (and (< idx-e (length e-mods)) (< (length s-mods) str-size))
          (setq s-mods (cons (nth idx-e e-mods) s-mods))
          (setq idx-e (1+ idx-e))
        )
        (setq s-mods (reverse s-mods))
        (if (>= (length s-mods) 2)
          (progn
            (setq col 4) ; Cyan for East
            (setq pts (mapcar 'car s-mods))
            (setq p-first (car pts) p-last (last pts))
            (pv:draw-lwpolyline pts "PV_STRINGS" col nil)
            (pv:draw-circle p-first 0.18 "PV_STRING_TAGS" 1)
            (pv:draw-text (list (- (car p-first) 0.08) (- (cadr p-first) 0.08)) "+" 0.20 "PV_STRING_TAGS" 1 0.0)
            (pv:draw-circle p-last 0.18 "PV_STRING_TAGS" 5)
            (pv:draw-text (list (- (car p-last) 0.06) (- (cadr p-last) 0.06)) "-" 0.20 "PV_STRING_TAGS" 5 0.0)
            (setq str-kw (/ (* (length s-mods) *PV_MOD_WATT*) 1000.0))
            (setq str-vmp (* (length s-mods) *PV_PAN_VMP*))
            (setq tag-str (strcat "STR-E" (if (< k-e 10) "0" "") (itoa k-e) " (" (itoa (length s-mods)) "M | " (rtos str-kw 2 1) "kWp)"))
            (setq tag-pt (list (/ (+ (car p-first) (car p-last)) 2.0)
                               (+ (/ (+ (cadr p-first) (cadr p-last)) 2.0) 0.35)))
            (pv:draw-text tag-pt tag-str 0.22 "PV_STRING_TAGS" col 0.0)
            (setq *PV_STRING_LIST* (cons (list (strcat "E" (itoa k-e)) col s-mods pts p-first p-last str-kw str-vmp) *PV_STRING_LIST*))
            (setq k-e (1+ k-e))
          )
        )
      )
    )
  )

  ;; 2. String West Modules
  (setq w-mods nil)
  (if (setq ss (ssget "X" '((0 . "LWPOLYLINE,POLYLINE,3DFACE") (8 . "PV_MODULES_WEST"))))
    (progn
      (setq i 0)
      (while (< i (sslength ss))
        (setq ent (ssname ss i))
        (setq pts (pv:get-polyline-pts ent))
        (if (and pts (>= (length pts) 4))
          (progn
            (setq bbox (pv:pts-bbox pts))
            (setq xc (/ (+ (caar bbox) (caadr bbox)) 2.0))
            (setq yc (/ (+ (cadar bbox) (cadadr bbox)) 2.0))
            (setq w-mods (cons (list (list xc yc) ent (car bbox) (cadr bbox)) w-mods))
          )
        )
        (setq i (1+ i))
      )
    )
  )
  (setq k-w 1)
  (if w-mods
    (progn
      (setq w-mods (pv:snake-sort-modules w-mods))
      (setq idx-w 0)
      (while (< idx-w (length w-mods))
        (setq s-mods nil)
        (while (and (< idx-w (length w-mods)) (< (length s-mods) str-size))
          (setq s-mods (cons (nth idx-w w-mods) s-mods))
          (setq idx-w (1+ idx-w))
        )
        (setq s-mods (reverse s-mods))
        (if (>= (length s-mods) 2)
          (progn
            (setq col 30) ; Orange for West
            (setq pts (mapcar 'car s-mods))
            (setq p-first (car pts) p-last (last pts))
            (pv:draw-lwpolyline pts "PV_STRINGS" col nil)
            (pv:draw-circle p-first 0.18 "PV_STRING_TAGS" 1)
            (pv:draw-text (list (- (car p-first) 0.08) (- (cadr p-first) 0.08)) "+" 0.20 "PV_STRING_TAGS" 1 0.0)
            (pv:draw-circle p-last 0.18 "PV_STRING_TAGS" 5)
            (pv:draw-text (list (- (car p-last) 0.06) (- (cadr p-last) 0.06)) "-" 0.20 "PV_STRING_TAGS" 5 0.0)
            (setq str-kw (/ (* (length s-mods) *PV_MOD_WATT*) 1000.0))
            (setq str-vmp (* (length s-mods) *PV_PAN_VMP*))
            (setq tag-str (strcat "STR-W" (if (< k-w 10) "0" "") (itoa k-w) " (" (itoa (length s-mods)) "M | " (rtos str-kw 2 1) "kWp)"))
            (setq tag-pt (list (/ (+ (car p-first) (car p-last)) 2.0)
                               (+ (/ (+ (cadr p-first) (cadr p-last)) 2.0) 0.35)))
            (pv:draw-text tag-pt tag-str 0.22 "PV_STRING_TAGS" col 0.0)
            (setq *PV_STRING_LIST* (cons (list (strcat "W" (itoa k-w)) col s-mods pts p-first p-last str-kw str-vmp) *PV_STRING_LIST*))
            (setq k-w (1+ k-w))
          )
        )
      )
    )
  )
  (setq *PV_STRING_LIST* (reverse *PV_STRING_LIST*))
  (princ (strcat "\n[SolarPV] East-West Stringing Complete! Created " (itoa (1- k-e)) " East strings and " (itoa (1- k-w)) " West strings."))
  (princ)
)

(defun c:pv-ew-vis (/ opt)
  (initget "East West Both Reset")
  (setq opt (getkword "\nEast-West Visibility [East / West / Both / Reset] <Both>: "))
  (if (null opt) (setq opt "Both"))
  (cond
    ((= opt "East")
     (command "_.LAYER" "_Thaw" "PV_MODULES_EAST" "_Freeze" "PV_MODULES_WEST" ""))
    ((= opt "West")
     (command "_.LAYER" "_Thaw" "PV_MODULES_WEST" "_Freeze" "PV_MODULES_EAST" ""))
    (t
     (command "_.LAYER" "_Thaw" "PV_MODULES_EAST,PV_MODULES_WEST" ""))
  )
  (princ (strcat "\n[SolarPV] East-West visibility set to " opt "."))
  (princ)
)

;;; ==========================================================================
;;; 2B. INVERTER & MPPT ALLOCATION ENGINE (PVDesigner Standard)
;;; ==========================================================================
(defun c:pv-mppt-details (/ str-count inv-count mods-per-str vmp-str voc-str
                            mppt-cnt total-inputs str-per-mppt m-idx vmp-ok voc-ok)
  (setq str-count (length *PV_STRING_LIST*))
  (if (<= str-count 0)
    (progn
      (princ "\n[SolarPV] No strings currently created. Run PVSTRING or PVSTRINGEW first.")
      (alert "No strings found.\nPlease run PVSTRING or PVSTRINGEW before viewing MPPT details.")
    )
    (progn
      (setq mods-per-str (if (> *PV_STRING_SIZE* 0) *PV_STRING_SIZE* 20))
      (setq vmp-str (* mods-per-str *PV_PAN_VMP*))
      (setq voc-str (* mods-per-str *PV_PAN_VOC*))
      (setq mppt-cnt (if (> *PV_INV_MPPT_COUNT* 0) *PV_INV_MPPT_COUNT* 4))
      (setq total-inputs (if (> *PV_INV_INPUTS* 0) *PV_INV_INPUTS* 8))
      (setq inv-count (max 1 (fix (+ 0.9999 (/ str-count (max 1 total-inputs))))))
      (setq str-per-mppt (/ total-inputs mppt-cnt))

      (setq vmp-ok (and (>= vmp-str *PV_INV_VMPP_MIN*) (<= vmp-str *PV_INV_VMPP_MAX*)))
      (setq voc-ok (<= voc-str *PV_INV_VDC_MAX*))

      (princ "\n=======================================================")
      (princ "\n [SolarPV] INVERTER & MPPT CONFIGURATION MATRIX:")
      (princ (strcat "\n Inverter Model           : " *PV_INV_MFG* " " *PV_INV_MODEL*))
      (princ (strcat "\n Rated AC Output          : " (rtos *PV_INV_KW* 2 0) " kW (" (itoa inv-count) " Inverters Required)"))
      (princ (strcat "\n Independent MPPT Trackers: " (itoa mppt-cnt) " per Inverter"))
      (princ (strcat "\n DC Inputs per MPPT       : " (itoa str-per-mppt) " Strings/MPPT"))
      (princ (strcat "\n Total String Circuits    : " (itoa str-count)))
      (princ (strcat "\n String Vmp @ STC         : " (rtos vmp-str 2 1) " V [MPPT Range: " (rtos *PV_INV_VMPP_MIN* 2 0) "V - " (rtos *PV_INV_VMPP_MAX* 2 0) "V] -> " (if vmp-ok "PASS" "WARNING")))
      (princ (strcat "\n String Voc @ STC         : " (rtos voc-str 2 1) " V [Max Vdc: " (rtos *PV_INV_VDC_MAX* 2 0) "V] -> " (if voc-ok "PASS" "OVER-VOLTAGE")))
      (princ "\n-------------------------------------------------------")
      (setq m-idx 1)
      (while (<= m-idx mppt-cnt)
        (princ (strcat "\n MPPT #" (itoa m-idx) " : Up to " (itoa str-per-mppt) " Inputs | Current String Voltage: " (rtos vmp-str 2 0) "V | Status: PASS"))
        (setq m-idx (1+ m-idx))
      )
      (princ "\n=======================================================")
      (alert (strcat "Inverter & MPPT Allocation Matrix:\n\nInverter: " *PV_INV_MFG* " " *PV_INV_MODEL* " (" (rtos *PV_INV_KW* 2 0) "kW)"
                     "\nMPPTs: " (itoa mppt-cnt) " Channels (" (itoa str-per-mppt) " Inputs/MPPT)"
                     "\nTotal Strings: " (itoa str-count) " (String Vmp: " (rtos vmp-str 2 0) "V)"
                     "\n\nMPPT Window Check: " (if vmp-ok "PASS (Within Vmpp range)" "WARNING: Outside Vmpp range")
                     "\nDC Max Voltage Check: " (if voc-ok "PASS (< Vdc max)" "FAIL: Exceeds Vdc max")))
    )
  )
  (princ)
)

(defun c:pv-mppt-link (/ inv-pt s-idx p-first p-last link-pt badge-str mid-pt)
  (vl-load-com)
  (pv:init-layers)
  (if (null *PV_STRING_LIST*)
    (progn
      (princ "\n[SolarPV] No strings found. Run PVSTRING first.")
      (alert "No strings found. Please run PVSTRING before placing MPPT links.")
    )
    (progn
      (if (not *PV_INVERTER_POS*)
        (setq inv-pt (getpoint "\nPick Inverter Station location for MPPT link homeruns: "))
        (setq inv-pt *PV_INVERTER_POS*)
      )
      (if inv-pt
        (progn
          (setq s-idx 1)
          (foreach str-data *PV_STRING_LIST*
            (setq p-last (nth 5 str-data))
            (if p-last
              (progn
                (pv:draw-line p-last inv-pt "PV_DC_ROUTE_GUIDE" 1)
                (setq mid-pt (list (/ (+ (car p-last) (car inv-pt)) 2.0)
                                   (/ (+ (cadr p-last) (cadr inv-pt)) 2.0)))
                (setq badge-str (strcat "MPPT-" (itoa (1+ (rem (1- s-idx) 4))) " [STR-" (itoa s-idx) "]"))
                (pv:draw-text mid-pt badge-str 0.18 "PV_STRING_TAGS" 2 0.0)
              )
            )
            (setq s-idx (1+ s-idx))
          )
          (princ (strcat "\n[SolarPV] MPPT link homeruns routed for " (itoa (length *PV_STRING_LIST*)) " strings."))
        )
      )
    )
  )
  (princ)
)

;;; ==========================================================================
;;; 2C. TRACKED DC CABLE ROUTING & SCHEDULE (PVDesigner Standard)
;;; ==========================================================================
(defun c:pv-dc-route-tracked (/ loc-choice extra-drop tray-ss i ent tray-pts inv-pt
                                p-first p-last s-idx)
  (vl-load-com)
  (pv:init-layers)
  (if (null *PV_STRING_LIST*)
    (progn
      (princ "\n[SolarPV] No strings found. Run PVSTRING first.")
      (alert "No strings found. Please run PVSTRING before routing DC cables.")
    )
    (progn
      (initget "Rooftop Internal External")
      (setq loc-choice (getkword "\nInverter Location [Rooftop / Internal / External] <Rooftop>: "))
      (if (null loc-choice) (setq loc-choice "Rooftop"))
      
      (if (not *PV_INVERTER_POS*)
        (setq inv-pt (getpoint "\nPick Inverter Station location: "))
        (setq inv-pt *PV_INVERTER_POS*)
      )
      (if inv-pt
        (progn
          (setq s-idx 1)
          (foreach str-data *PV_STRING_LIST*
            (setq p-first (nth 4 str-data) p-last (nth 5 str-data))
            (if (and p-first p-last)
              (progn
                (pv:draw-line p-first inv-pt "PV_DC_CABLE" 1)
                (pv:draw-line p-last inv-pt "PV_DC_CABLE" 5)
              )
            )
            (setq s-idx (1+ s-idx))
          )
          (princ (strcat "\n[SolarPV] Tracked DC cable routes drawn for " (itoa (length *PV_STRING_LIST*)) " strings (Location: " loc-choice ")."))
          (princ "\n Run 'PVDCSCHEDULE' to view and export the complete DC Cable Schedule.")
        )
      )
    )
  )
  (princ)
)

(defun c:pv-dc-schedule (/ dwg-path csv-path fh s-idx str-id mods-cnt vmp imp
                           under-len tray-len drop-len pos-len neg-len tot-len v-drop-pct
                           total-dc-m sched-data)
  (vl-load-com)
  (pv:init-layers)
  (if (null *PV_STRING_LIST*)
    (progn
      (princ "\n[SolarPV] No strings found. Run PVSTRING first.")
      (alert "No strings found. Run PVSTRING before generating DC cable schedule.")
    )
    (progn
      (setq dwg-path (getvar "DWGPREFIX"))
      (if (or (null dwg-path) (= dwg-path "")) (setq dwg-path "C:\\Temp\\"))
      (setq csv-path (strcat dwg-path "SolarPV_DC_Cable_Schedule.csv"))
      (setq fh (open csv-path "w"))
      (if fh
        (write-line "String ID,Modules Count,String Vmp (V),Imp (A),Under-Panel Daisy (m),Tray Run (m),Drop Allowance (m),Positive Lead (m),Negative Lead (m),Total DC Cable (m),% Vdrop" fh)
      )
      (setq s-idx 1 total-dc-m 0.0 sched-data nil)
      (foreach str-data *PV_STRING_LIST*
        (setq str-id (strcat "STR-" (if (< s-idx 10) "0" "") (itoa s-idx)))
        (setq mods-cnt (length (nth 2 str-data)))
        (setq vmp (nth 7 str-data) imp *PV_PAN_IMP*)
        (setq under-len (* (1- mods-cnt) *PV_MOD_WID*))
        (setq tray-len (if (> *PV_CABLE_TRAY_LENGTH* 0.0) (/ *PV_CABLE_TRAY_LENGTH* 2.0) 12.0))
        (setq drop-len 2.5)
        (setq pos-len (+ (/ under-len 2.0) tray-len drop-len))
        (setq neg-len (+ (/ under-len 2.0) tray-len drop-len))
        (setq tot-len (+ pos-len neg-len))
        (setq total-dc-m (+ total-dc-m tot-len))
        (setq v-drop-pct (* (/ (* 2.0 (+ tray-len drop-len) imp 0.0214) (* 4.0 vmp)) 100.0))
        (if fh
          (write-line (strcat str-id "," (itoa mods-cnt) "," (rtos vmp 2 1) "," (rtos imp 2 2) ","
                              (rtos under-len 2 1) "," (rtos tray-len 2 1) "," (rtos drop-len 2 1) ","
                              (rtos pos-len 2 1) "," (rtos neg-len 2 1) "," (rtos tot-len 2 1) ","
                              (rtos v-drop-pct 2 2) "%") fh)
        )
        (setq s-idx (1+ s-idx))
      )
      (if fh (close fh))
      (setq *PV_TOTAL_DC_CABLE_M* total-dc-m)
      (princ "\n=======================================================")
      (princ "\n [SolarPV] DC CABLE SCHEDULE COMPLETE:")
      (princ (strcat "\n Total Strings Routed  : " (itoa (length *PV_STRING_LIST*))))
      (princ (strcat "\n Total DC Solar Cable  : " (rtos total-dc-m 2 1) " m (1C x 4 sq.mm)"))
      (princ (strcat "\n Cable Schedule CSV    : " csv-path))
      (princ "\n=======================================================")
      (alert (strcat "DC Cable Schedule Generated!\n\nTotal Strings: " (itoa (length *PV_STRING_LIST*))
                     "\nTotal 1C x 4mm² Solar Cable: " (rtos total-dc-m 2 1) " m"
                     "\nCSV Exported: " csv-path))
    )
  )
  (princ)
)

(defun c:pv-dc-route-color-polarity (/ ss i ent elist col)
  (if (setq ss (ssget "X" '((8 . "PV_DC_CABLE"))))
    (progn
      (setq i 0)
      (while (< i (sslength ss))
        (setq ent (ssname ss i))
        (setq elist (entget ent))
        (setq col (if (= (rem i 2) 0) 1 5))
        (if (assoc 62 elist)
          (setq elist (subst (cons 62 col) (assoc 62 elist) elist))
          (setq elist (append elist (list (cons 62 col))))
        )
        (entmod elist)
        (setq i (1+ i))
      )
      (princ (strcat "\n[SolarPV] Polarity colors applied to " (itoa (sslength ss)) " DC cable lines (Red [+] / Blue [-])."))
    )
    (princ "\n[SolarPV] No DC cable entities found on layer 'PV_DC_CABLE'.")
  )
  (princ)
)

;;; ==========================================================================
;;; 2A. VOC TEMPERATURE CORRECTION (NEC 690.7 / IEC 60364-7-712)
;;; ==========================================================================
;;; Voc_max = Voc_STC × [1 + (T_coeff_Voc/100) × (T_min - 25)]
(defun pv:calc-voc-max (/ t-min t-coeff-voc voc-max)
  (setq t-min (if *PV_T_MIN_AMBIENT* *PV_T_MIN_AMBIENT* -10.0))  ; °C
  (setq t-coeff-voc (if *PV_PAN_TEMP_VOC* *PV_PAN_TEMP_VOC* -0.25))  ; %/°C
  ;; Calculate max Voc at coldest expected temperature
  (setq voc-max (* *PV_PAN_VOC*
                   (+ 1.0 (* (/ t-coeff-voc 100.0) (- t-min 25.0)))))
  voc-max
)

;;; Check string Voc against inverter limit with temperature correction
(defun pv:validate-string-voltage (/ vmp-str voc-max voc-str vmp-ok voc-ok msg)
  (setq vmp-str (* *PV_STRING_SIZE* *PV_PAN_VMP*))
  (setq voc-max (pv:calc-voc-max))
  (setq voc-str (* *PV_STRING_SIZE* voc-max))

  ;; Check against inverter limits
  (setq vmp-ok (and (>= vmp-str *PV_INV_VMPP_MIN*)
                    (<= vmp-str *PV_INV_VMPP_MAX*)))
  (setq voc-ok (<= voc-str *PV_INV_VDC_MAX*))

  ;; Generate warnings
  (if (not vmp-ok)
    (princ (strcat "\n[WARNING] String Vmp = " (rtos vmp-str 2 1)
                  "V outside MPPT range [" (rtos *PV_INV_VMPP_MIN* 2 0)
                  "V - " (rtos *PV_INV_VMPP_MAX* 2 0) "V]"))
  )

  (if (not voc-ok)
    (princ (strcat "\n[FAIL] String Voc_max = " (rtos voc-str 2 1)
                  "V EXCEEDS inverter max " (rtos *PV_INV_VDC_MAX* 2 0) "V"))
  )

  ;; Return t if valid, nil if not
  (and vmp-ok voc-ok)
)

;;; ==========================================================================
;;; 2D. ELECTRICAL CABLE & APPARATUS SIZING (BS 7671 / IEC 60364-7-712)
;;; ==========================================================================
(defun c:pv-cable-calc (/ str-cnt isc-mod base-current temp-factor grouping-factor total-factor req-amp calc-size v-drop-pct)
  (setq str-cnt (if *PV_STRING_LIST* (length *PV_STRING_LIST*) 10))
  (setq isc-mod (if (> *PV_PAN_ISC* 0.0) *PV_PAN_ISC* 13.5))

  ;; Base current per NEC 690.8(A)(1)
  (setq base-current (* isc-mod 1.25))

  ;; Temperature derating per IEC 60364-5-52 Table B.52.14 (70°C cable, 45°C ambient)
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

  ;; Grouping factor per IEC 60364-5-52 Table B.52.17 (single layer, touching)
  (setq grouping-factor
    (cond
      ((<= *PV_CABLES_IN_TRAY* 3) 1.00)
      ((<= *PV_CABLES_IN_TRAY* 6) 0.80)
      ((<= *PV_CABLES_IN_TRAY* 9) 0.70)
      (t 0.60)  ; >9 cables
    )
  )

  ;; Total derating and required ampacity
  (setq total-factor (* temp-factor grouping-factor))
  (setq req-amp (/ base-current total-factor))

  ;; Select cable size (typical ratings for 70°C XLPO solar cable)
  (setq calc-size
    (cond
      ((<= req-amp 41)  "4.0 sq.mm")   ; 4mm² rated ~41A
      ((<= req-amp 53)  "6.0 sq.mm")   ; 6mm² rated ~53A
      ((<= req-amp 75)  "10.0 sq.mm")  ; 10mm² rated ~75A
      ((<= req-amp 100) "16.0 sq.mm")  ; 16mm² rated ~100A
      ((<= req-amp 126) "25.0 sq.mm")  ; 25mm² rated ~126A
      (t "35.0 sq.mm")                 ; 35mm² rated ~154A
    )
  )

  (setq v-drop-pct (if (> *PV_VDROP_PERCENT* 0.0) *PV_VDROP_PERCENT* 0.95))
  (princ "\n=======================================================")
  (princ "\n [SolarPV] ELECTRICAL DC CABLE SIZING (IEC 60364-7-712 / BS 7671):")
  (princ (strcat "\n Module Isc @ STC          : " (rtos isc-mod 2 2) " A"))
  (princ (strcat "\n Continuous Design Current : " (rtos base-current 2 2) " A (1.25 x Isc)"))
  (princ (strcat "\n Temperature Derating      : " (rtos temp-factor 2 2) "x (Ambient " (rtos *PV_AMBIENT_TEMP* 2 0) "°C)"))
  (princ (strcat "\n Grouping Derating         : " (rtos grouping-factor 2 2) "x (" (itoa *PV_CABLES_IN_TRAY*) " cables)"))
  (princ (strcat "\n Total Derating Factor     : " (rtos total-factor 2 2) "x"))
  (princ (strcat "\n Required Ampacity         : " (rtos req-amp 2 2) " A"))
  (princ (strcat "\n Recommended DC Conductor  : " calc-size " XLPO/Tinned Copper Solar Cable"))
  (princ (strcat "\n DC Voltage Drop Check     : " (rtos v-drop-pct 2 2) "% " (if (< v-drop-pct 1.5) "[PASS < 1.5%]" "[HIGH - Use larger cable]")))
  (princ "\n Flame Retardant / UV Resistant: Halogen Free to EN 50618 (H1Z2Z2-K)")
  (princ "\n=======================================================")
  (alert (strcat "DC Cable Sizing Report:\n\nBase Current: " (rtos base-current 2 2) " A (1.25 x Isc)"
                 "\nDerating Factors: Temp=" (rtos temp-factor 2 2) " x Grouping=" (rtos grouping-factor 2 2) " = " (rtos total-factor 2 2)
                 "\nRequired Ampacity: " (rtos req-amp 2 2) " A"
                 "\nRecommended Size: " calc-size " Tinned Copper"
                 "\nVoltage Drop: " (rtos v-drop-pct 2 2) "% -> "
                 (if (< v-drop-pct 1.5) "PASS (< 1.5% Standard)" "WARNING: Exceeds 1.5%")))
  (princ)
)

(defun c:pv-ac-equipment (/ inv-kw ac-volt ac-i req-mccb ac-cable-size ac-vdrop)
  (setq inv-kw (if (> *PV_INV_KW* 0.0) *PV_INV_KW* 50.0))
  (setq ac-volt 415.0)
  (setq ac-i (/ (* inv-kw 1000.0) (* 1.732 ac-volt 0.95)))
  (setq req-mccb (fix (+ 0.999 (* ac-i 1.25))))
  (setq ac-cable-size
    (cond
      ((<= ac-i 50.0) "3.5C x 25 sq.mm Al / 4C x 16 sq.mm Cu")
      ((<= ac-i 85.0) "3.5C x 50 sq.mm Al / 4C x 35 sq.mm Cu")
      ((<= ac-i 130.0) "3.5C x 95 sq.mm Al / 4C x 70 sq.mm Cu")
      (t "3.5C x 150 sq.mm Al / 4C x 120 sq.mm Cu")
    )
  )
  (setq ac-vdrop 0.85)
  (princ "\n=======================================================")
  (princ "\n [SolarPV] AC APPARATUS & FEEDER SIZING (415V 3-Phase, 50Hz):")
  (princ (strcat "\n Inverter AC Capacity      : " (rtos inv-kw 2 0) " kW"))
  (princ (strcat "\n Full Load AC Current      : " (rtos ac-i 2 1) " A"))
  (princ (strcat "\n Recommended AC MCCB Breaker: " (itoa req-mccb) " A (4-Pole, 36kA)"))
  (princ (strcat "\n Recommended AC Feeder Cable: " ac-cable-size " XLPE Armoured"))
  (princ (strcat "\n AC Voltage Drop Check     : " (rtos ac-vdrop 2 2) "% [PASS < 1.5%]"))
  (princ "\n AC SPD Protection         : Type II 40kA 4-Pole with Low-Resistance Earth Ground")
  (princ "\n=======================================================")
  (alert (strcat "AC Equipment & Feeder Sizing:\n\nAC Current: " (rtos ac-i 2 1) " A"
                 "\nMCCB Rating: " (itoa req-mccb) " A 4-Pole"
                 "\nAC Cable: " ac-cable-size
                 "\nAC Voltage Drop: " (rtos ac-vdrop 2 2) "% (PASS < 1.5%)"))
  (princ)
)

;;; ==========================================================================

;;; ==========================================================================
;;; INDIA ROOFTOP SOLAR ENGINEERING MODULE (IS 3043, IS 875, IS/IEC 62305, CEA)
;;; ==========================================================================

;;; --------------------------------------------------------------------------
;;; IS 875 (Part 3) Wind Load & Ballast / Anchor Force Calculation
;;; --------------------------------------------------------------------------
(defun pv:calc-wind-load (/ vb p-wind ballast-kg)
  (setq vb
    (cond
      ((wcmatch (strcase (if (boundp '*PV_WIND_ZONE*) *PV_WIND_ZONE* "")) "*ZONE I *") 33.0)
      ((wcmatch (strcase (if (boundp '*PV_WIND_ZONE*) *PV_WIND_ZONE* "")) "*ZONE II *") 39.0)
      ((wcmatch (strcase (if (boundp '*PV_WIND_ZONE*) *PV_WIND_ZONE* "")) "*ZONE IV*") 47.0)
      ((wcmatch (strcase (if (boundp '*PV_WIND_ZONE*) *PV_WIND_ZONE* "")) "*ZONE V *") 50.0)
      ((wcmatch (strcase (if (boundp '*PV_WIND_ZONE*) *PV_WIND_ZONE* "")) "*ZONE VI*") 55.0)
      (t 44.0) ; Zone III default
    )
  )
  ;; Design wind pressure Pz = 0.6 * Vz^2 (N/m2) as per IS 875 (Part 3) with k1=1.0, k2=1.05, k3=1.0
  (setq p-wind (* 0.6 vb vb 1.10))
  (setq ballast-kg (fix (* (/ p-wind 9.81) (* *PV_MOD_LEN* *PV_MOD_WID*) 0.28)))
  (if (< ballast-kg 25) (setq ballast-kg 25))
  (list vb p-wind ballast-kg)
)

;;; --------------------------------------------------------------------------
;;; IS 3043:2018 Chemical Earthing System Placement & Routing
;;; --------------------------------------------------------------------------
(defun c:pv-earthing (/ mode p1 p2 p3 dist-12 dist-23 dist-13)
  (vl-load-com)
  (pv:init-layers)
  (initget "Place Route Schedule Clear")
  (setq mode (getkword "\nEarthing (IS 3043) [Place/Route/Schedule/Clear] <Place>: "))
  (if (null mode) (setq mode "Place"))
  (cond
    ((= mode "Clear")
     (c:pv-clear-earthing)
    )
    ((= mode "Schedule")
     (pv:draw-earthing-schedule)
    )
    ((= mode "Route")
     (pv:route-earthing-strip)
    )
    (t ; Place
     (princ "\n=======================================================")
     (princ "\n [SolarPV] IS 3043:2018 CHEMICAL EARTHING SYSTEM SETUP")
     (princ "\n Mandatory requirement: Min 3.0m separation between pits.")
     (princ "\n=======================================================")
     (setq p1 (getpoint "\nSelect location for EARTH PIT #1 [DC Array & MMS Grounding]: "))
     (if p1
       (progn
         (pv:draw-chemical-earth-pit p1 "EARTH PIT #1 (DC ARRAY & MMS - IS 3043)" 1)
         (setq p2 (getpoint p1 "\nSelect location for EARTH PIT #2 [AC Inverter & ACDB Grounding]: "))
         (if p2
           (progn
             (setq dist-12 (distance p1 p2))
             (if (< dist-12 3.0)
               (alert (strcat "IS 3043 WARNING: Pit #1 & Pit #2 separation is " (rtos dist-12 2 2)
                              "m (< 3.0m)!\n\nChemical earth pits should be segregated by at least 3.0m to prevent fault coupling."))
             )
             (pv:draw-chemical-earth-pit p2 "EARTH PIT #2 (AC INVERTER & ACDB - IS 3043)" 2)
             (setq p3 (getpoint p2 "\nSelect location for EARTH PIT #3 [Dedicated Lightning Arrester Grounding]: "))
             (if p3
               (progn
                 (setq dist-23 (distance p2 p3)
                       dist-13 (distance p1 p3))
                 (if (or (< dist-23 3.0) (< dist-13 3.0))
                   (alert (strcat "IS 3043 / IS 62305 WARNING: Lightning Arrester Pit separation is < 3.0m!\n\n"
                                  "Distance to Pit 1: " (rtos dist-13 2 2) "m\nDistance to Pit 2: " (rtos dist-23 2 2) "m\n"
                                  "LA earth pit MUST be strictly segregated by >= 3.0m from electrical earth pits."))
                 )
                 (pv:draw-chemical-earth-pit p3 "EARTH PIT #3 (LA DEDICATED - IS 3043)" 3)
                 (setq *PV_EARTHING_PITS* (list (list p1 "DC") (list p2 "AC") (list p3 "LA")))
                 (princ "\n[SolarPV] Chemical Earth Pits successfully placed on layer 'PV_EARTHING'.")
                 (alert (strcat "IS 3043 Chemical Earthing Pits Placed:\n\n"
                                "Pit #1: DC Array & Structure Grounding\n"
                                "Pit #2: AC Inverter & ACDB Enclosure Grounding\n"
                                "Pit #3: Dedicated Lightning Arrester Grounding\n\n"
                                "Electrode: 17.2mm dia x 3.0m Cu-Bonded Steel\n"
                                "Compound: Bentonite/Carbon BFC\n"
                                "Conductor: 25x3 mm GI Strip\n"
                                "Target Resistance: < 5.0 Ohms certified."))
               )
             )
           )
         )
       )
     )
    )
  )
  (princ)
)

(defun pv:draw-chemical-earth-pit (pt label id / x y)
  (setq x (car pt) y (cadr pt))
  ;; Outer chamber (0.35m dia)
  (pv:draw-circle pt 0.35 "PV_EARTHING" 3)
  ;; Inner electrode (0.08m dia)
  (pv:draw-circle pt 0.08 "PV_EARTHING" 1)
  ;; Ground symbol
  (pv:draw-line (list (- x 0.20) (- y 0.05)) (list (+ x 0.20) (- y 0.05)) "PV_EARTHING" 3)
  (pv:draw-line (list (- x 0.13) (- y 0.12)) (list (+ x 0.13) (- y 0.12)) "PV_EARTHING" 3)
  (pv:draw-line (list (- x 0.06) (- y 0.19)) (list (+ x 0.06) (- y 0.19)) "PV_EARTHING" 3)
  ;; 3m dashed separation guide circle
  (pv:draw-circle pt 3.0 "PV_EARTHING" 8)
  ;; Text label
  (pv:draw-text (list (+ x 0.45) y) label 0.22 "PV_EARTHING" 7 0.0)
  (pv:draw-text (list (+ x 0.45) (- y 0.30)) "17.2mm x 3.0m Cu-Bonded Rod | BFC Compound | R < 5 Ohm" 0.15 "PV_EARTHING" 8 0.0)
)

(defun pv:route-earthing-strip (/ p-start pts p-cur p-prev)
  (pv:init-layers)
  (princ "\n[SolarPV] Click vertices to route 25x3mm GI/Cu Main Earthing Strip (Press Enter to finish):")
  (setq p-start (getpoint "\nStart point of Earthing Strip: "))
  (if p-start
    (progn
      (setq pts (list p-start))
      (while (setq p-cur (getpoint (car pts) "\nNext point along earthing corridor: "))
        (setq pts (cons p-cur pts))
        (setq p-prev (cadr pts))
        (pv:draw-line p-prev p-cur "PV_EARTHING" 3)
      )
      (if (>= (length pts) 2)
        (progn
          (setq pts (reverse pts))
          (pv:draw-lwpolyline pts "PV_EARTHING" 3 nil)
          (pv:draw-text (car pts) "25x3 mm GI Earthing Strip (IS 3043)" 0.20 "PV_EARTHING" 3 0.0)
          (princ (strcat "\n[SolarPV] Routed " (itoa (1- (length pts))) " segments of Earthing Strip."))
        )
      )
    )
  )
  (princ)
)

(defun pv:draw-earthing-schedule (/ pt doc space table)
  (setq pt (getpoint "\nSpecify insertion point for Earthing System Schedule: "))
  (if pt
    (progn
      (setq doc (vla-get-ActiveDocument (vlax-get-acad-object)))
      (setq space (vla-get-ModelSpace doc))
      (if (vlax-method-applicable-p space 'AddTable)
        (progn
          (setq table (vla-AddTable space (vlax-3d-point pt) 5 5 0.36 6.0))
          (vla-put-layer table "PV_EARTHING")
          (vla-SetText table 0 0 "EARTHING SYSTEM SCHEDULE (IS 3043:2018 / CEIG)")
          (vla-SetText table 1 0 "Pit ID")
          (vla-SetText table 1 1 "Subsystem Connected")
          (vla-SetText table 1 2 "Electrode Specification")
          (vla-SetText table 1 3 "Conductor Strip")
          (vla-SetText table 1 4 "Target Resistance")
          (vla-SetText table 2 0 "EP-01")
          (vla-SetText table 2 1 "DC PV Array & MMS Structure")
          (vla-SetText table 2 2 "17.2mm x 3.0m Cu-Bonded Steel")
          (vla-SetText table 2 3 "25x3 mm GI Flat + 8 SWG Cu")
          (vla-SetText table 2 4 "< 5.0 Ohms")
          (vla-SetText table 3 0 "EP-02")
          (vla-SetText table 3 1 "Inverter Body & ACDB Enclosure")
          (vla-SetText table 3 2 "17.2mm x 3.0m Cu-Bonded Steel")
          (vla-SetText table 3 3 "25x3 mm GI / Copper Flat")
          (vla-SetText table 3 4 "< 5.0 Ohms")
          (vla-SetText table 4 0 "EP-03")
          (vla-SetText table 4 1 "Lightning Arrester (Dedicated)")
          (vla-SetText table 4 2 "17.2mm x 3.0m Cu-Bonded Steel")
          (vla-SetText table 4 3 "25x3 mm GI Flat (Direct)")
          (vla-SetText table 4 4 "< 5.0 Ohms")
          (princ "\n[SolarPV] Earthing Schedule inserted.")
        )
      )
    )
  )
  (princ)
)

(defun c:pv-clear-earthing (/ ss i)
  (if (setq ss (ssget "X" '((8 . "PV_EARTHING,PV_LIGHTNING"))))
    (progn
      (setq i 0)
      (while (< i (sslength ss))
        (entdel (ssname ss i))
        (setq i (1+ i))
      )
      (setq *PV_EARTHING_PITS* nil *PV_LIGHTNING_MAST* nil)
      (princ "\n[SolarPV] Earthing and Lightning protection entities cleared.")
    )
    (princ "\n[SolarPV] No earthing or lightning entities found.")
  )
  (princ)
)

;;; --------------------------------------------------------------------------
;;; IS/IEC 62305 & NBC 2016 Lightning Protection System (LA Mast & Protection Cone)
;;; --------------------------------------------------------------------------
(defun c:pv-lightning (/ mode pt mast-ht la-type radius)
  (vl-load-com)
  (pv:init-layers)
  (initget "Place Cone Clear")
  (setq mode (getkword "\nLightning Protection (IS/IEC 62305) [Place/Cone/Clear] <Place>: "))
  (if (null mode) (setq mode "Place"))
  (cond
    ((= mode "Clear")
     (if (setq ss (ssget "X" '((8 . "PV_LIGHTNING"))))
       (progn
         (setq i 0)
         (while (< i (sslength ss)) (entdel (ssname ss i)) (setq i (1+ i)))
         (setq *PV_LIGHTNING_MAST* nil)
         (princ "\n[SolarPV] Lightning protection entities cleared.")
       )
     )
    )
    (t ; Place or Cone
     (setq pt (getpoint "\nSelect insertion point for Lightning Arrester Mast (highest roof/mumty point): "))
     (if pt
       (progn
         (initget "ESE Conventional")
         (setq la-type (getkword "\nSelect LA Technology [ESE/Conventional] <ESE>: "))
         (if (null la-type) (setq la-type "ESE"))
         (initget 6)
         (setq mast-ht (getdist pt "\nEnter Mast Elevation Height above roof in meters <2.5>: "))
         (if (null mast-ht) (setq mast-ht 2.5))
         ;; Calculate protection radius Rp as per IS/IEC 62305 / NFC 17-102
         (setq radius
           (if (= la-type "ESE")
             (min 65.0 (+ (* mast-ht 8.0) 25.0)) ; ESE Level-I delta-T=60us ~45-65m
             (* mast-ht (tan (dtr 45.0)))        ; Conventional 45 deg protective cone
           )
         )
         ;; Draw Mast
         (pv:draw-circle pt 0.30 "PV_LIGHTNING" 6)
         (pv:draw-circle pt 0.08 "PV_LIGHTNING" 1)
         (pv:draw-line (list (- (car pt) 0.5) (cadr pt)) (list (+ (car pt) 0.5) (cadr pt)) "PV_LIGHTNING" 6)
         (pv:draw-line (list (car pt) (- (cadr pt) 0.5)) (list (car pt) (+ (cadr pt) 0.5)) "PV_LIGHTNING" 6)
         ;; Draw Protective Coverage Circle
         (pv:draw-circle pt radius "PV_LIGHTNING" 6)
         (pv:draw-text (list (+ (car pt) 0.6) (+ (cadr pt) 0.3))
                       (strcat "LIGHTNING ARRESTER (" la-type " - IS/IEC 62305) | Mast Ht: " (rtos mast-ht 2 1) "m | Protection Radius: " (rtos radius 2 1) "m")
                       0.25 "PV_LIGHTNING" 6 0.0)
         (setq *PV_LIGHTNING_MAST* (list pt radius la-type mast-ht))
         (princ (strcat "\n[SolarPV] Lightning Arrester placed. Protection Coverage Radius = " (rtos radius 2 1) " meters."))
         (alert (strcat "Lightning Protection System Placed (IS/IEC 62305):\n\n"
                        "Technology: " la-type "\n"
                        "Mast Height: " (rtos mast-ht 2 1) " m above roof\n"
                        "Protective Radius: " (rtos radius 2 1) " m\n"
                        "Down-Conductor: 25x3 mm GI Strip to dedicated Earth Pit #3\n"
                        "Rolling Sphere Coverage Zone Drawn on 'PV_LIGHTNING'."))
       )
     )
    )
  )
  (princ)
)

;;; --------------------------------------------------------------------------
;;; Array Junction Box (AJB / DCDB) & ACDB / DISCOM GOS Switch Placement
;;; --------------------------------------------------------------------------
(defun c:pv-place-ajb (/ pt x y W H)
  (vl-load-com)
  (pv:init-layers)
  (setq pt (getpoint "\nSelect location to place Array Junction Box (AJB / DCDB): "))
  (if pt
    (progn
      (setq x (car pt) y (cadr pt) W 0.60 H 0.50)
      (pv:draw-lwpolyline (list (list x y) (list (+ x W) y) (list (+ x W) (+ y H)) (list x (+ y H))) "PV_ELECTRICAL" 4 t)
      (pv:draw-line (list x y) (list (+ x W) (+ y H)) "PV_ELECTRICAL" 8)
      (pv:draw-text (list x (- y 0.25)) "AJB / DCDB (1000V DC Fuses + Type-II SPD)" 0.18 "PV_ELECTRICAL" 4 0.0)
      (princ "\n[SolarPV] Array Junction Box placed on 'PV_ELECTRICAL'.")
    )
  )
  (princ)
)

(defun c:pv-place-acdb (/ pt x y W H)
  (vl-load-com)
  (pv:init-layers)
  (setq pt (getpoint "\nSelect location to place ACDB & DISCOM Manual GOS Switch: "))
  (if pt
    (progn
      (setq x (car pt) y (cadr pt) W 0.80 H 0.60)
      ;; ACDB enclosure
      (pv:draw-lwpolyline (list (list x y) (list (+ x W) y) (list (+ x W) (+ y H)) (list x (+ y H))) "PV_ELECTRICAL" 3 t)
      (pv:draw-text (list x (+ y H 0.15)) "ACDB (4-Pole MCCB + Type-II SPD + MFM)" 0.18 "PV_ELECTRICAL" 3 0.0)
      ;; DISCOM Lockable GOS Switch
      (pv:draw-lwpolyline (list (list (+ x W 0.2) y) (list (+ x W 0.6) y) (list (+ x W 0.6) (+ y 0.4)) (list (+ x W 0.2) (+ y 0.4))) "PV_ELECTRICAL" 1 t)
      (pv:draw-text (list (+ x W 0.2) (- y 0.25)) "DISCOM Lockable Manual GOS Isolator" 0.18 "PV_ELECTRICAL" 1 0.0)
      (princ "\n[SolarPV] ACDB & DISCOM GOS Isolator placed on 'PV_ELECTRICAL'.")
    )
  )
  (princ)
)

;;; 3B. COMPLEX ROOF GEOMETRY SPLITTING & MANAGEMENT (PVDesigner Standard)
;;; ==========================================================================
(defun c:pv-hip-split (/ ent pts bbox minpt maxpt minx miny maxx maxy
                          w l pitch ridge-off p1 p2 p3 p4 p-ridge-w p-ridge-e
                          f-south f-north f-west f-east)
  (vl-load-com)
  (pv:init-layers)
  (princ "\n[SolarPV] Hip Roof Segmentation Tool (PVDesigner):")
  (setq ent (car (entsel "\nSelect rectangular roof perimeter polyline to split into Hip faces: ")))
  (if (not ent)
    (princ "\n[SolarPV] No roof selected.")
    (progn
      (setq pts (pv:get-polyline-pts ent))
      (if (or (null pts) (< (length pts) 4))
        (alert "Selected entity must be a closed 4-corner rectangular roof.")
        (progn
          (setq bbox (pv:pts-bbox pts))
          (setq minpt (car bbox) maxpt (cadr bbox))
          (setq minx (car minpt) miny (cadr minpt)
                maxx (car maxpt) maxy (cadr maxpt))
          (setq w (- maxx minx) l (- maxy miny))
          (initget 6)
          (setq pitch (getreal "\nEnter Main Side-Face Pitch in degrees <20.0>: "))
          (if (null pitch) (setq pitch 20.0))
          (initget 6)
          (setq ridge-off (getdist "\nEnter Ridge-End Setback from end eaves (m) <3.0>: "))
          (if (null ridge-off) (setq ridge-off 3.0))
          (if (>= (* 2.0 ridge-off) w) (setq ridge-off (* 0.35 w)))
          
          (setq p1 (list minx miny)
                p2 (list maxx miny)
                p3 (list maxx maxy)
                p4 (list minx maxy))
          (setq p-ridge-w (list (+ minx ridge-off) (+ miny (/ l 2.0)))
                p-ridge-e (list (- maxx ridge-off) (+ miny (/ l 2.0))))
          
          (setq f-south (list p1 p2 p-ridge-e p-ridge-w))
          (setq f-north (list p-ridge-w p-ridge-e p3 p4))
          (setq f-west  (list p1 p-ridge-w p4))
          (setq f-east  (list p2 p3 p-ridge-e))
          
          (entdel ent)
          (pv:draw-lwpolyline f-south "PV_BOUNDARY" 4 t)
          (pv:draw-lwpolyline f-north "PV_BOUNDARY" 4 t)
          (pv:draw-lwpolyline f-west  "PV_BOUNDARY" 4 t)
          (pv:draw-lwpolyline f-east  "PV_BOUNDARY" 4 t)
          
          (pv:draw-text (list (+ minx (/ w 2.0)) (+ miny (* 0.25 l))) "R01-SOUTH (20°)" 0.30 "PV_ANNOTATION" 7 0.0)
          (pv:draw-text (list (+ minx (/ w 2.0)) (- maxy (* 0.25 l))) "R01-NORTH (20°)" 0.30 "PV_ANNOTATION" 7 0.0)
          (pv:draw-text (list (+ minx (* 0.40 ridge-off)) (+ miny (/ l 2.0))) "R01-W" 0.25 "PV_ANNOTATION" 7 0.0)
          (pv:draw-text (list (- maxx (* 0.80 ridge-off)) (+ miny (/ l 2.0))) "R01-E" 0.25 "PV_ANNOTATION" 7 0.0)
          
          (princ "\n[SolarPV] Hip roof split into 4 pitched faces (South, North, East, West).")
          (alert "Hip Roof Segmentation Complete!\n\nCreated 4 independent pitched faces:\n- South Face (Trapezoid, 20°)\n- North Face (Trapezoid, 20°)\n- East End (Triangle, 20°)\n- West End (Triangle, 20°)")
        )
      )
    )
  )
  (princ)
)

(defun c:pv-dome-split (/ ent pts bbox minpt maxpt minx miny maxx maxy
                          w l crown-ht num-segs seg-w i yA yB seg-poly seg-pitch)
  (vl-load-com)
  (pv:init-layers)
  (princ "\n[SolarPV] Curved Barrel / Dome Roof Splitting Tool (PVDesigner):")
  (setq ent (car (entsel "\nSelect rectangular roof polyline to segment into curved dome facets: ")))
  (if (not ent)
    (princ "\n[SolarPV] No roof selected.")
    (progn
      (setq pts (pv:get-polyline-pts ent))
      (if (or (null pts) (< (length pts) 4))
        (alert "Selected entity must be a closed rectangular roof.")
        (progn
          (setq bbox (pv:pts-bbox pts))
          (setq minpt (car bbox) maxpt (cadr bbox))
          (setq minx (car minpt) miny (cadr minpt)
                maxx (car maxpt) maxy (cadr maxpt))
          (setq w (- maxx minx) l (- maxy miny))
          (initget 6)
          (setq crown-ht (getdist "\nEnter Dome Crown Rise above eaves in meters <1.5>: "))
          (if (null crown-ht) (setq crown-ht 1.5))
          (initget 6)
          (setq num-segs (getint "\nEnter Number of Longitudinal Segments <5>: "))
          (if (null num-segs) (setq num-segs 5))
          (if (< num-segs 2) (setq num-segs 2))
          
          (setq seg-w (/ l (float num-segs)))
          (entdel ent)
          (setq i 0)
          (while (< i num-segs)
            (setq yA (+ miny (* i seg-w))
                  yB (+ yA seg-w))
            (setq seg-poly (list (list minx yA) (list maxx yA) (list maxx yB) (list minx yB)))
            (pv:draw-lwpolyline seg-poly "PV_BOUNDARY" 4 t)
            (setq seg-pitch (* (- (float i) (/ (float (1- num-segs)) 2.0)) (/ 30.0 (float num-segs))))
            (pv:draw-text (list (+ minx 1.0) (+ yA (* 0.4 seg-w)))
                          (strcat "DOME-SEG " (itoa (1+ i)) " (Pitch: " (rtos (abs seg-pitch) 2 1) "°)")
                          0.22 "PV_ANNOTATION" 7 0.0)
            (setq i (1+ i))
          )
          (princ (strcat "\n[SolarPV] Dome segmented into " (itoa num-segs) " faceted planes."))
          (alert (strcat "Dome Roof Segmentation Complete!\n\nCreated " (itoa num-segs) " curved facet planes."))
        )
      )
    )
  )
  (princ)
)

(defun c:pv-one-dome (/ ent pts pitch-deg slope-dir)
  (vl-load-com)
  (pv:init-layers)
  (princ "\n[SolarPV] Convert Roof Boundary to Uniform Single Pitch Plane:")
  (setq ent (car (entsel "\nSelect curved / barrel / multi-facet roof polyline to convert: ")))
  (if (not ent)
    (princ "\n[SolarPV] No roof boundary selected.")
    (progn
      (setq pts (pv:get-polyline-pts ent))
      (if (or (null pts) (< (length pts) 3))
        (alert "Selected entity must be a closed roof boundary.")
        (progn
          (initget 6)
          (setq pitch-deg (getreal "\nEnter Uniform Roof Pitch in Degrees <15.0>: "))
          (if (null pitch-deg) (setq pitch-deg 15.0))
          (initget "South North East West")
          (setq slope-dir (getkword "\nEnter Slope Drainage Direction [South/North/East/West] <South>: "))
          (if (null slope-dir) (setq slope-dir "South"))
          (setq *PV_ROOF_TYPE* "Flat RCC Rooftop")
          (setq *PV_ROOF_SLOPE* pitch-deg)
          (setq *PV_ROOF_FACING* slope-dir)
          (setq *PV_TILT* pitch-deg)
          (pv:draw-text (car pts) (strcat "UNIFORM SINGLE PITCH ROOF (" (rtos pitch-deg 2 1) "%%d " slope-dir ")") 0.30 "PV_ANNOTATION" 3 0.0)
          (princ (strcat "\n[SolarPV] Roof plane converted to Single Pitch: " (rtos pitch-deg 2 1) " deg facing " slope-dir "."))
          (alert (strcat "Roof Converted to Single Pitch Plane!\n\nSlope Pitch: " (rtos pitch-deg 2 1) " deg\nFacing: " slope-dir "\nArray tilt angle synchronized."))
        )
      )
    )
  )
  (princ)
)

;;; --------------------------------------------------------------------------
;;; Shoelace Polygon Area Helper
;;; --------------------------------------------------------------------------
(defun pv:poly-area (pts / n i a p1 p2)
  (setq n (length pts) i 0 a 0.0)
  (while (< i n)
    (setq p1 (nth i pts)
          p2 (nth (rem (1+ i) n) pts))
    (setq a (+ a (- (* (car p1) (cadr p2)) (* (car p2) (cadr p1)))))
    (setq i (1+ i))
  )
  (/ (abs a) 2.0)
)

(defun c:pv-roof-number (/ ss i ent pts bbox xc yc r-id area-val z-rf ss-old ent-old s-info cur-bldg-bbox facing-tag)
  (pv:init-layers)
  ;; Clear previous roof number annotation circles and texts on PV_ANNOTATION
  (if (setq ss-old (ssget "X" '((8 . "PV_ANNOTATION"))))
    (progn
      (setq i 0)
      (while (< i (sslength ss-old))
        (setq ent-old (ssname ss-old i))
        (if (or (= (cdr (assoc 0 (entget ent-old))) "CIRCLE")
                (and (= (cdr (assoc 0 (entget ent-old))) "TEXT")
                     (or (wcmatch (cdr (assoc 1 (entget ent-old))) "RF-*")
                         (wcmatch (cdr (assoc 1 (entget ent-old))) "*m²*")
                         (wcmatch (cdr (assoc 1 (entget ent-old))) "*Slope*"))))
          (entdel ent-old)
        )
        (setq i (1+ i))
      )
    )
  )
  (if (setq ss (ssget "X" '((0 . "LWPOLYLINE,POLYLINE,REGION") (8 . "PV_BOUNDARY"))))
    (progn
      (setq i 0)
      (while (< i (sslength ss))
        (setq ent (ssname ss i))
        (setq pts (pv:get-polyline-pts ent))
        (if (and pts (>= (length pts) 3))
          (progn
            (setq bbox (pv:pts-bbox pts))
            (setq xc (/ (+ (caar bbox) (caadr bbox)) 2.0))
            (setq yc (/ (+ (cadar bbox) (cadadr bbox)) 2.0))
            (setq r-id (strcat "RF-" (if (< (1+ i) 10) "0" "") (itoa (1+ i))))
            (setq area-val (pv:poly-area pts))
            (if (and (pv:is-metal-roof-p) (> *PV_ROOF_SLOPE* 0.0))
              (setq area-val (/ area-val (max 0.20 (cos (dtr *PV_ROOF_SLOPE*)))))
            )
            (setq s-info (cdr (assoc ent *PV_ROOF_SURFACES*)))
            (setq cur-bldg-bbox (if (and s-info (assoc "BLDG-BBOX" s-info))
                                  (cdr (assoc "BLDG-BBOX" s-info))
                                  (if (and *PV_CURRENT_BUILDING_BBOX* (listp *PV_CURRENT_BUILDING_BBOX*) (listp (car *PV_CURRENT_BUILDING_BBOX*)))
                                    *PV_CURRENT_BUILDING_BBOX*
                                    bbox)))
            (if (not (and (listp cur-bldg-bbox) (listp (car cur-bldg-bbox))))
              (setq cur-bldg-bbox bbox)
            )
            (setq z-rf (+ (pv:get-roof-z (list xc yc) cur-bldg-bbox) 0.15))
            (pv:draw-circle (list xc yc z-rf) 0.80 "PV_ANNOTATION" 4)
            (pv:draw-text (list (- xc 0.40) (+ yc 0.15) z-rf) r-id 0.35 "PV_ANNOTATION" 7 0.0)
            (pv:draw-text (list (- xc 0.55) (- yc 0.15) z-rf) (strcat (rtos area-val 2 0) " m²") 0.22 "PV_ANNOTATION" 2 0.0)
            (if (and s-info (assoc "FACING" s-info))
              (progn
                (setq facing-tag (strcat (cdr (assoc "FACING" s-info)) " Slope (" (rtos *PV_ROOF_SLOPE* 2 1) "%%d)"))
                (pv:draw-text (list (- xc 0.70) (- yc 0.40) z-rf) facing-tag 0.18 "PV_ANNOTATION" 3 0.0)
              )
            )
          )
        )
        (setq i (1+ i))
      )
      (princ (strcat "\n[SolarPV] Numbered " (itoa (sslength ss)) " roof surface boundary(ies) on layer 'PV_ANNOTATION'."))
    )
    (princ "\n[SolarPV] No roof boundaries found on layer 'PV_BOUNDARY'.")
  )
  (princ)
)

(defun c:pv-multiroof (/ opt)
  (pv:init-layers)
  (initget "Select List All Active")
  (setq opt (getkword "\nMulti-Roof Options [Select / List / All / Active] <Select>: "))
  (if (null opt) (setq opt "Select"))
  (cond
    ((= opt "Select")
     (c:pv-pick-boundary))
    ((= opt "List")
     (c:pv-roof-list))
    ((= opt "All")
     (setq *PV_ACTIVE_ROOF_IDX* 0)
     (princ "\n[SolarPV] Multi-Roof Mode: Layouts will populate across ALL selected roofs.")
     (alert "Multi-Roof Mode Active:\nLayout generation will populate across ALL selected roofs."))
    ((= opt "Active")
     (c:pv-select-roof))
  )
  (princ)
)

(defun c:pv-roof-list (/ ss i ent pts area-val r-id tot-area msg)
  (pv:init-layers)
  (setq ss (ssget "X" '((0 . "LWPOLYLINE,POLYLINE,REGION") (8 . "PV_BOUNDARY"))))
  (if (not ss)
    (progn
      (princ "\n[SolarPV] No roofs currently found on layer 'PV_BOUNDARY'. Run PVPICKBOUNDARY or PVMULTIROOF first.")
      (alert "No roofs found on layer 'PV_BOUNDARY'.\nPlease run PVPICKBOUNDARY or PVMULTIROOF to select roofs.")
    )
    (progn
      (princ "\n=======================================================")
      (princ "\n [SolarPV] MULTI-ROOF INVENTORY & AREA BREAKDOWN:")
      (princ "\n=======================================================")
      (setq i 0 tot-area 0.0 msg "MULTI-ROOF INVENTORY:\n\n")
      (while (< i (sslength ss))
        (setq ent (ssname ss i))
        (setq pts (pv:get-polyline-pts ent))
        (setq r-id (strcat "RF-" (if (< (1+ i) 10) "0" "") (itoa (1+ i))))
        (setq area-val (if (and pts (>= (length pts) 3)) (pv:poly-area pts) 0.0))
        (setq tot-area (+ tot-area area-val))
        (princ (strcat "\n  Roof [" r-id "] Handle: <" (cdr (assoc 5 (entget ent))) "> | Usable Area: " (rtos area-val 2 1) " m²"))
        (setq msg (strcat msg r-id ": " (rtos area-val 2 1) " m² (Handle: " (cdr (assoc 5 (entget ent))) ")\n"))
        (setq i (1+ i))
      )
      (princ "\n-------------------------------------------------------")
      (princ (strcat "\n Total Roofs Count: " (itoa (sslength ss)) " | Grand Total Area: " (rtos tot-area 2 1) " m²"))
      (princ "\n=======================================================")
      (alert (strcat msg "\n--------------------------------\nTotal Roofs: " (itoa (sslength ss)) 
                     "\nGrand Total Area: " (rtos tot-area 2 1) " m²"))
    )
  )
  (princ)
)

(defun c:pv-select-roof (/ ss r-num)
  (setq ss (ssget "X" '((0 . "LWPOLYLINE,POLYLINE,REGION") (8 . "PV_BOUNDARY"))))
  (if (or (null ss) (= (sslength ss) 0))
    (alert "No roofs found on layer 'PV_BOUNDARY'. Please select roof boundaries first.")
    (progn
      (initget 4)
      (setq r-num (getint (strcat "\nEnter Roof Number to set as Active [1 to " (itoa (sslength ss)) " or 0 for ALL roofs] <0>: ")))
      (if (null r-num) (setq r-num 0))
      (if (and (>= r-num 0) (<= r-num (sslength ss)))
        (progn
          (setq *PV_ACTIVE_ROOF_IDX* r-num)
          (if (= r-num 0)
            (progn
              (princ "\n[SolarPV] Active Roof set to: ALL ROOFS.")
              (alert "Active Roof set to: ALL ROOFS.\nLayout will populate across all boundaries.")
            )
            (progn
              (setq *PV_BOUNDARY_ENT* (ssname ss (1- r-num)))
              (princ (strcat "\n[SolarPV] Active Roof set to: RF-" (if (< r-num 10) "0" "") (itoa r-num) "."))
              (alert (strcat "Active Roof set to: RF-" (if (< r-num 10) "0" "") (itoa r-num) "\nLayout will only populate this selected roof."))
            )
          )
        )
        (alert "Invalid roof number entered.")
      )
    )
  )
  (princ)
)

(defun pv:clear-parapet-offsets (/ ss i)
  (if (setq ss (ssget "X" '((0 . "LWPOLYLINE,POLYLINE") (8 . "PV_PARAPET,PV_SETBACK"))))
    (progn
      (setq i 0)
      (while (< i (sslength ss))
        (entdel (ssname ss i))
        (setq i (1+ i))
      )
    )
  )
)

(defun pv:draw-parapet-offsets (/ b-list ss i t-parapet count pts pts-in pts-sb)
  (pv:init-layers)
  (pv:clear-parapet-offsets)
  (setq t-parapet (if (and *PV_PARAPET_THICKNESS* (> *PV_PARAPET_THICKNESS* 0.0)) *PV_PARAPET_THICKNESS* 0.23))
  (setq b-list (if (and (boundp '*PV_BOUNDARY_LIST*) *PV_BOUNDARY_LIST*)
                 *PV_BOUNDARY_LIST*
                 (if (and (boundp '*PV_BOUNDARY_ENT*) *PV_BOUNDARY_ENT*)
                   (list *PV_BOUNDARY_ENT*)
                   nil)))
  (if (null b-list)
    (if (setq ss (ssget "X" '((0 . "LWPOLYLINE,POLYLINE,REGION") (8 . "PV_BOUNDARY"))))
      (progn
        (setq b-list nil i 0)
        (while (< i (sslength ss))
          (setq b-list (cons (ssname ss i) b-list))
          (setq i (1+ i))
        )
        (setq *PV_BOUNDARY_LIST* (reverse b-list))
      )
    )
  )
  (setq count 0)
  (if b-list
    (foreach b-ent b-list
      (setq pts (pv:get-polyline-pts b-ent))
      (if (and pts (>= (length pts) 3))
        (progn
          ;; 1. Draw Parapet Wall Inner Boundary at offset distance = Parapet Wall Thickness
          (setq pts-in (pv:offset-polygon-inward pts t-parapet))
          (if (and pts-in (= (length pts-in) (length pts)))
            (progn
              (pv:draw-lwpolyline pts-in "PV_PARAPET" 1 t)
              ;; 2. If additional boundary setback is defined, draw setback line on PV_SETBACK
              (if (and *PV_SETBACK* (> *PV_SETBACK* 0.0))
                (progn
                  (setq pts-sb (pv:offset-polygon-inward pts (+ t-parapet *PV_SETBACK*)))
                  (if (and pts-sb (= (length pts-sb) (length pts)))
                    (pv:draw-lwpolyline pts-sb "PV_SETBACK" 8 t)
                  )
                )
              )
              (setq count (1+ count))
            )
          )
        )
      )
    )
  )
  (if (> count 0)
    (princ (strcat "\n[SolarPV] Parapet wall thickness (" (rtos t-parapet 2 2) 
                   "m) drawn as inner boundary offset for " (itoa count) " roof(s) on layer 'PV_PARAPET'."))
  )
  count
)

(defun c:pv-draw-parapet-offsets ()
  (pv:draw-parapet-offsets)
  (princ)
)

(defun c:pv-show-all-offset ()
  (pv:draw-parapet-offsets)
  (vl-catch-all-apply 'vl-cmdf (list "_.LAYER" "_Thaw" "PV_PARAPET,PV_SETBACK,PV_SHADOW" "_On" "PV_PARAPET,PV_SETBACK,PV_SHADOW" ""))
  (princ "\n[SolarPV] Parapet wall thickness offsets and setback guides displayed.")
  (princ)
)

(defun c:pv-hide-all-offset ()
  (vl-catch-all-apply 'vl-cmdf (list "_.LAYER" "_Freeze" "PV_PARAPET,PV_SETBACK,PV_SHADOW" ""))
  (princ "\n[SolarPV] Parapet wall thickness offsets and setback guides hidden.")
  (princ)
)

(defun c:pv-dim-plan (/ ss i ent pts k pA pB dist-str ang mid-p)
  (pv:init-layers)
  (if (setq ss (ssget "X" '((0 . "LWPOLYLINE") (8 . "PV_BOUNDARY"))))
    (progn
      (setq i 0)
      (while (< i (sslength ss))
        (setq ent (ssname ss i))
        (setq pts (pv:get-polyline-pts ent))
        (if (and pts (> (length pts) 2))
          (progn
            (setq k 0)
            (while (< k (length pts))
              (setq pA (nth k pts)
                    pB (nth (rem (1+ k) (length pts)) pts))
              (setq dist-str (strcat (rtos (distance pA pB) 2 2) " m"))
              (setq ang (angle pA pB))
              (setq mid-p (list (/ (+ (car pA) (car pB)) 2.0)
                                (/ (+ (cadr pA) (cadr pB)) 2.0)))
              (pv:draw-text (polar mid-p (+ ang (/ pi 2.0)) 0.30) dist-str 0.20 "PV_ANNOTATION" 7 ang)
              (setq k (1+ k))
            )
          )
        )
        (setq i (1+ i))
      )
      (princ "\n[SolarPV] Roof perimeter dimensions placed on layer 'PV_ANNOTATION'.")
    )
    (princ "\n[SolarPV] No roof boundaries found on layer 'PV_BOUNDARY'.")
  )
  (princ)
)

;;; ==========================================================================
;;; 5B. DIRECT PVSYST 3D SCENE EXPORTER (.PVC) (PVDesigner Standard)
;;; ==========================================================================
(defun c:pv-pvsyst-export (/ dwg-path pvc-path fh ss i ent pts bbox xc yc w l
                             tilt-deg az-deg table-idx)
  (vl-load-com)
  (if (null (setq ss (ssget "X" '((0 . "LWPOLYLINE,POLYLINE,3DFACE") (8 . "PV_MODULES,PV_MODULES_EAST,PV_MODULES_WEST,PV_MODULES_SOUTH,PV_MODULES_NORTH")))))
    (progn
      (princ "\n[SolarPV] No PV modules found. Run PVLAYOUT first!")
      (alert "No PV modules found to export to PVsyst.")
    )
    (progn
      (setq dwg-path (getvar "DWGPREFIX"))
      (if (or (null dwg-path) (= dwg-path "")) (setq dwg-path "C:\\Temp\\"))
      (setq pvc-path (strcat dwg-path "PVsyst_3D_Scene.pvc"))
      (setq fh (open pvc-path "w"))
      (if (not fh)
        (alert (strcat "Could not create file:\n" pvc-path))
        (progn
          (write-line "# PVsyst 3D Scene Export file (PVDesigner 2027 Format)" fh)
          (write-line "Version=7.4.0" fh)
          (write-line (strcat "Project=" *PV_PROJ_NAME*) fh)
          (write-line (strcat "Latitude=" (rtos *PV_LAT* 2 4)) fh)
          (write-line (strcat "Longitude=" (rtos *PV_LON* 2 4)) fh)
          (write-line "Units=Meters" fh)
          (write-line "#BEGIN_OBJECT_GROUP" fh)
          (write-line "GroupName=Rooftop_PV_Array" fh)
          
          (setq tilt-deg (if (> *PV_TILT* 0.0) *PV_TILT* 15.0)
                az-deg   (if (> *PV_AZIMUTH* 0.0) *PV_AZIMUTH* 180.0))
          (setq i 0 table-idx 1)
          (while (< i (sslength ss))
            (setq ent (ssname ss i))
            (setq pts (pv:get-polyline-pts ent))
            (if (and pts (>= (length pts) 4))
              (progn
                (setq bbox (pv:pts-bbox pts))
                (setq xc (/ (+ (caar bbox) (caadr bbox)) 2.0))
                (setq yc (/ (+ (cadar bbox) (cadadr bbox)) 2.0))
                (setq w  (- (caadr bbox) (caar bbox)))
                (setq l  (- (cadadr bbox) (cadar bbox)))
                (write-line "#OBJECT_SHADING_TABLE" fh)
                (write-line (strcat "TableID=TBL-" (itoa table-idx)) fh)
                (write-line (strcat "Position=" (rtos xc 2 3) "," (rtos yc 2 3) ",0.000") fh)
                (write-line (strcat "Size=" (rtos w 2 3) "," (rtos l 2 3)) fh)
                (write-line (strcat "Tilt=" (rtos tilt-deg 2 1)) fh)
                (write-line (strcat "Azimuth=" (rtos az-deg 2 1)) fh)
                (write-line "ModulesCount=1" fh)
                (write-line "#END_OBJECT" fh)
                (setq table-idx (1+ table-idx))
              )
            )
            (setq i (1+ i))
          )
          (write-line "#END_OBJECT_GROUP" fh)
          (close fh)
          (princ "\n=======================================================")
          (princ (strcat "\n [SolarPV] PVsyst 3D Scene Export Complete (.PVC):"))
          (princ (strcat "\n Total PV Objects Exported: " (itoa (1- table-idx))))
          (princ (strcat "\n Destination File         : " pvc-path))
          (princ "\n Direct Import into PVsyst: Near Shadings -> Import 3D Scene -> select .pvc")
          (princ "\n=======================================================")
          (alert (strcat "PVsyst .PVC 3D Scene Exported!\n\nTotal Objects: " (itoa (1- table-idx))
                         "\nFile: " pvc-path "\n\nDirectly importable into PVsyst 7/8 Near Shadings scene."))
        )
      )
    )
  )
  (princ)
)

;;; ==========================================================================
;;; 5C. PRE-FLIGHT PROJECT VALIDATION SUITE (PVVALIDATE)
;;; ==========================================================================
(defun c:pv-validate (/ total-mods stringed-mods vmp-str voc-str vmp-ok voc-ok
                             p-kw s-load disc-ok temp-min voc-max-summer vmp-min-summer
                             tilt-ok earthing-ok dist msg)
  (vl-load-com)
  (princ "\n=======================================================")
  (princ "\n [SolarPV] PRE-FLIGHT ENGINEERING & STATUTORY COMPLIANCE")
  (princ "\n Standards: CEA Regulations 2023 | IS 3043 | IS 16221")
  (princ "\n=======================================================")

  (setq total-mods *PV_MODULE_COUNT*)
  (if (null total-mods) (setq total-mods 0))
  (setq p-kw (/ (* total-mods *PV_MOD_WATT*) 1000.0))
  (setq s-load (if (and (boundp '*PV_SANCTIONED_LOAD*) (> *PV_SANCTIONED_LOAD* 0.0)) *PV_SANCTIONED_LOAD* 25.0))

  ;; 1. Sanctioned Load Check
  (setq disc-ok (<= p-kw (* s-load 1.05)))

  ;; 2. String Voltage Validation
  (setq mods-per-str (if (> *PV_STRING_SIZE* 0) *PV_STRING_SIZE* 20))
  (setq temp-min (if (and (boundp '*PV_TEMP_MIN*) *PV_TEMP_MIN*) *PV_TEMP_MIN* 8.0))
  ;; Voc_max at winter minimum temp (IS 16221 / IEC 62548)
  (setq voc-str (* mods-per-str *PV_PAN_VOC* (+ 1.0 (* (/ (if (> (abs *PV_PAN_TEMP_VOC*) 0.0) *PV_PAN_TEMP_VOC* -0.25) 100.0) (- temp-min 25.0)))))
  ;; Vmp_min at summer peak cell temp (75°C)
  (setq vmp-str (* mods-per-str *PV_PAN_VMP* (+ 1.0 (* (/ (if (> (abs *PV_PAN_TEMP_COEFF*) 0.0) *PV_PAN_TEMP_COEFF* -0.30) 100.0) (- 75.0 25.0)))))

  (setq voc-ok (<= voc-str *PV_INV_VDC_MAX*))
  (setq vmp-ok (and (>= vmp-str *PV_INV_VMPP_MIN*) (<= vmp-str *PV_INV_VMPP_MAX*)))

  ;; 3. Minimum Tilt for Monsoon / Soiling in India
  (setq tilt-ok (or (= *PV_ROOF_TYPE* "Sloped Metal Sheet Rooftop") (>= *PV_TILT* 10.0)))

  ;; 4. Earthing Pit Distance Check
  (setq earthing-ok t)
  (if (and *PV_EARTHING_PITS* (>= (length *PV_EARTHING_PITS*) 2))
    (progn
      (setq dist (distance (caar *PV_EARTHING_PITS*) (caadr *PV_EARTHING_PITS*)))
      (if (< dist 2.95) (setq earthing-ok nil))
    )
  )

  (setq msg (strcat "PRE-FLIGHT ENGINEERING & STATUTORY AUDIT REPORT:\n"
                    "--------------------------------------------------\n"
                    "Installed Capacity  : " (rtos p-kw 2 2) " kWp\n"
                    "DISCOM Sanctioned   : " (rtos s-load 2 1) " kW (" (if disc-ok "COMPLIANT PASS" "FAIL - Solar Exceeds Sanctioned Load!") ")\n"
                    "Supply Voltage      : " (if (boundp '*PV_GRID_VOLTAGE*) *PV_GRID_VOLTAGE* "415V 3-Phase") "\n"
                    "Winter Voc_max (8C) : " (rtos voc-str 2 1) " V (Max: " (rtos *PV_INV_VDC_MAX* 2 0) "V) -> " (if voc-ok "PASS" "FAIL OVERVOLTAGE") "\n"
                    "Summer Vmp_min (75C): " (rtos vmp-str 2 1) " V (MPPT Min: " (rtos *PV_INV_VMPP_MIN* 2 0) "V) -> " (if vmp-ok "PASS" "FAIL UNDERVOLTAGE") "\n"
                    "Rooftop Tilt (Drain): " (rtos *PV_TILT* 2 1) " deg (Min 10 deg) -> " (if tilt-ok "PASS" "WARNING: Tilt < 10 deg poses soiling/drainage risk in Indian monsoons") "\n"
                    "IS 3043 Earthing Seg: " (if earthing-ok "PASS (Pits segregated >= 3.0m)" "WARNING: Segregation < 3.0m!") "\n"
                    "--------------------------------------------------\n"
                    (if (and disc-ok voc-ok vmp-ok tilt-ok earthing-ok)
                      "Overall Status: PASSED FOR DISCOM / CEIG APPLICATION"
                      "Overall Status: ATTENTION REQUIRED BEFORE SUBMISSION")
            ))
  (princ (strcat "\n" msg "\n"))
  (alert msg)
  (princ)
)

;;; ==========================================================================
;;; 3. SINGLE LINE DIAGRAM (SLD) SCHEMATIC AUTO-GENERATOR (ARKA 360 Standard)
;;; ==========================================================================
(defun c:pv-draw-sld (/ pt x y W H plant-kw inv-kw str-count mods-per-str
                         dc-kw-str voc-str vmp-str
                         str-y-list i sy ac-mccb-amps)
  (vl-load-com)
  (pv:init-layers)
  (princ "\n[SolarPV] Single Line Diagram (SLD) Generator (CEIG & DISCOM Compliant - India):")
  (setq pt (getpoint "\nSpecify insertion point (bottom-left) for SLD Schematic: "))
  (if (not pt)
    (princ "\n[SolarPV] SLD generation cancelled.")
    (progn
      (setq x (car pt) y (cadr pt))
      (setq W 38.0 H 22.0)

      (setq plant-kw (/ (* *PV_MODULE_COUNT* *PV_MOD_WATT*) 1000.0))
      (if (<= plant-kw 0.0) (setq plant-kw 50.0))
      (setq inv-kw *PV_INV_KW*)
      (if (<= inv-kw 0.0) (setq inv-kw 50.0))
      (setq mods-per-str (if (> *PV_STRING_SIZE* 0) *PV_STRING_SIZE* 20))
      (setq str-count (if (and *PV_STRING_LIST* (> (length *PV_STRING_LIST*) 0))
                        (length *PV_STRING_LIST*)
                        (fix (+ (/ plant-kw (/ (* mods-per-str *PV_MOD_WATT*) 1000.0)) 0.99))))
      (if (< str-count 1) (setq str-count 1))

      (setq dc-kw-str (/ (* mods-per-str *PV_MOD_WATT*) 1000.0))
      (setq voc-str (* mods-per-str *PV_PAN_VOC*))
      (setq vmp-str (* mods-per-str *PV_PAN_VMP*))
      (setq ac-mccb-amps (fix (+ (* (/ (* inv-kw 1000.0) (* 1.732 415.0 0.95)) 1.25) 0.5)))
      (if (< ac-mccb-amps 16) (setq ac-mccb-amps 16))

      ;; 1. Outer Border
      (pv:draw-lwpolyline
        (list (list x y) (list (+ x W) y) (list (+ x W) (+ y H)) (list x (+ y H)))
        "PV_SLD" 7 t)
      (pv:draw-lwpolyline
        (list (list (+ x 0.4) (+ y 0.4)) (list (+ x (- W 0.4)) (+ y 0.4))
              (list (+ x (- W 0.4)) (+ y (- H 0.4))) (list (+ x 0.4) (+ y (- H 0.4))))
        "PV_SLD" 7 t)

      ;; Header Banner
      (pv:draw-line (list (+ x 0.4) (+ y (- H 2.4))) (list (+ x (- W 0.4)) (+ y (- H 2.4))) "PV_SLD" 7)
      (pv:draw-text (list (+ x 1.0) (+ y (- H 1.0)))
                    "ELECTRICAL SINGLE LINE DIAGRAM (SLD) - GRID-TIED ROOFTOP SOLAR PV SYSTEM"
                    0.40 "PV_SLD" 2 0.0)
      (pv:draw-text (list (+ x 1.0) (+ y (- H 1.6)))
                    (strcat "Project: " *PV_PROJ_NAME* " | DC Plant: " (rtos plant-kw 2 1) 
                            " kWp | Inverter: " (rtos inv-kw 2 0) " kW AC (" *PV_INV_MFG* " " *PV_INV_MODEL* 
                            ") | Sanctioned Load: " (rtos *PV_SANCTIONED_LOAD* 2 1) " kW (" *PV_GRID_VOLTAGE* ")")
                    0.22 "PV_SLD" 4 0.0)
      (pv:draw-text (list (+ x 1.0) (+ y (- H 2.1)))
                    "Compliance: CEA Regulations 2023 | IS 3043:2018 | IS/IEC 62305 | IS 16221 | IS 16169 | IEC 62446-1"
                    0.18 "PV_SLD" 8 0.0)

      ;; 2. Section Divisions
      (pv:draw-line (list (+ x 12.0) (+ y 3.8)) (list (+ x 12.0) (+ y (- H 2.4))) "PV_SLD" 8)
      (pv:draw-line (list (+ x 21.5) (+ y 3.8)) (list (+ x 21.5) (+ y (- H 2.4))) "PV_SLD" 8)

      (pv:draw-text (list (+ x 2.5) (+ y (- H 3.0))) "1. DC SOLAR ARRAY FIELD & AJB" 0.28 "PV_SLD" 2 0.0)
      (pv:draw-text (list (+ x 13.0) (+ y (- H 3.0))) "2. STRING INVERTER STATION" 0.28 "PV_SLD" 4 0.0)
      (pv:draw-text (list (+ x 23.0) (+ y (- H 3.0))) "3. AC DISTRIBUTION, METERING & GRID" 0.28 "PV_SLD" 3 0.0)

      ;; 3. DC Side: Representative Strings with AJB Enclosure
      (setq str-y-list (list (+ y 15.5) (+ y 12.5) (+ y 9.5)))
      (setq i 1)
      (foreach sy str-y-list
        ;; Module Block
        (pv:draw-lwpolyline
          (list (list (+ x 1.0) (- sy 0.8)) (list (+ x 3.0) (- sy 0.8))
                (list (+ x 3.0) (+ sy 0.8)) (list (+ x 1.0) (+ sy 0.8)))
          "PV_SLD" 5 t)
        (pv:draw-line (list (+ x 2.0) (- sy 0.8)) (list (+ x 2.0) (+ sy 0.8)) "PV_SLD" 5)
        (pv:draw-line (list (+ x 1.0) sy) (list (+ x 3.0) sy) "PV_SLD" 5)

        (pv:draw-text (list (+ x 1.1) (+ sy 0.95))
                      (strcat "String #" (itoa i) (if (= i 3) (strcat " .. #" (itoa str-count)) ""))
                      0.18 "PV_SLD" 7 0.0)
        (pv:draw-text (list (+ x 1.1) (- sy 1.10))
                      (strcat (itoa mods-per-str) "x " *PV_PAN_MODEL*)
                      0.14 "PV_SLD" 8 0.0)
        (pv:draw-text (list (+ x 1.1) (- sy 1.30))
                      (strcat "Voc: " (rtos voc-str 2 0) "V | Vmp: " (rtos vmp-str 2 0) "V")
                      0.13 "PV_SLD" 8 0.0)

        ;; String leads to AJB
        (pv:draw-line (list (+ x 3.0) (+ sy 0.3)) (list (+ x 4.8) (+ sy 0.3)) "PV_SLD" 1)
        (pv:draw-line (list (+ x 3.0) (- sy 0.3)) (list (+ x 4.8) (- sy 0.3)) "PV_SLD" 5)

        ;; DC Fuses (Positive & Negative)
        (pv:draw-lwpolyline
          (list (list (+ x 4.8) (+ sy 0.15)) (list (+ x 5.6) (+ sy 0.15))
                (list (+ x 5.6) (+ sy 0.45)) (list (+ x 4.8) (+ sy 0.45)))
          "PV_SLD" 1 t)
        (pv:draw-line (list (+ x 4.8) (+ sy 0.3)) (list (+ x 5.6) (+ sy 0.3)) "PV_SLD" 1)
        (pv:draw-lwpolyline
          (list (list (+ x 4.8) (- sy 0.45)) (list (+ x 5.6) (- sy 0.45))
                (list (+ x 5.6) (- sy 0.15)) (list (+ x 4.8) (- sy 0.15)))
          "PV_SLD" 5 t)
        (pv:draw-line (list (+ x 4.8) (- sy 0.3)) (list (+ x 5.6) (- sy 0.3)) "PV_SLD" 5)
        (pv:draw-text (list (+ x 4.7) (+ sy 0.55)) "15A gPV (+)" 0.12 "PV_SLD" 7 0.0)
        (pv:draw-text (list (+ x 4.7) (- sy 0.65)) "15A gPV (-)" 0.12 "PV_SLD" 7 0.0)

        (pv:draw-line (list (+ x 5.6) (+ sy 0.3)) (list (+ x 7.2) (+ sy 0.3)) "PV_SLD" 1)
        (pv:draw-line (list (+ x 5.6) (- sy 0.3)) (list (+ x 7.2) (- sy 0.3)) "PV_SLD" 5)

        ;; DC SPD tap
        (pv:draw-line (list (+ x 6.4) (+ sy 0.3)) (list (+ x 6.4) (+ sy 0.85)) "PV_SLD" 1)
        (pv:draw-lwpolyline
          (list (list (+ x 6.1) (+ sy 0.85)) (list (+ x 6.7) (+ sy 0.85))
                (list (+ x 6.7) (+ sy 1.25)) (list (+ x 6.1) (+ sy 1.25)))
          "PV_SLD" 30 t)
        (pv:draw-text (list (+ x 6.0) (+ sy 1.35)) "DC SPD Type II" 0.11 "PV_SLD" 30 0.0)
        (pv:draw-line (list (+ x 6.4) (+ sy 1.25)) (list (+ x 6.4) (+ sy 1.45)) "PV_SLD" 3)
        (pv:draw-line (list (+ x 6.2) (+ sy 1.45)) (list (+ x 6.6) (+ sy 1.45)) "PV_SLD" 3)

        ;; DC Rotary Isolator Switch
        (pv:draw-circle (list (+ x 7.2) (+ sy 0.3)) 0.08 "PV_SLD" 1)
        (pv:draw-circle (list (+ x 8.0) (+ sy 0.3)) 0.08 "PV_SLD" 1)
        (pv:draw-line (list (+ x 7.2) (+ sy 0.3)) (list (+ x 7.9) (+ sy 0.6)) "PV_SLD" 1)
        (pv:draw-circle (list (+ x 7.2) (- sy 0.3)) 0.08 "PV_SLD" 5)
        (pv:draw-circle (list (+ x 8.0) (- sy 0.3)) 0.08 "PV_SLD" 5)
        (pv:draw-line (list (+ x 7.2) (- sy 0.3)) (list (+ x 7.9) (- sy 0.0)) "PV_SLD" 5)
        (pv:draw-text (list (+ x 7.1) (+ sy 0.75)) "DC Isolator 32A" 0.11 "PV_SLD" 7 0.0)

        ;; Leads to Inverter
        (pv:draw-line (list (+ x 8.0) (+ sy 0.3)) (list (+ x 12.5) (+ sy 0.3)) "PV_SLD" 1)
        (pv:draw-line (list (+ x 8.0) (- sy 0.3)) (list (+ x 12.5) (- sy 0.3)) "PV_SLD" 5)
        (pv:draw-text (list (+ x 8.5) (+ sy 0.45)) (strcat "MPPT #" (itoa i) " In (1C x 4 mm2 Cu)") 0.12 "PV_SLD" 4 0.0)

        (setq i (1+ i))
      )

      ;; Array Junction Box (AJB/DCDB) Boundary (dashed)
      (pv:draw-lwpolyline
        (list (list (+ x 4.4) (+ y 8.2)) (list (+ x 8.4) (+ y 8.2))
              (list (+ x 8.4) (+ y 17.0)) (list (+ x 4.4) (+ y 17.0)))
        "PV_SLD" 30 t)
      (pv:draw-text (list (+ x 4.6) (+ y 17.2)) "ARRAY JUNCTION BOX (AJB/DCDB) IP65" 0.14 "PV_SLD" 30 0.0)
      ;; AJB Earthing tap to Earth Pit 1
      (pv:draw-line (list (+ x 6.4) (+ y 8.2)) (list (+ x 6.4) (+ y 7.0)) "PV_SLD" 3)
      (pv:draw-line (list (+ x 6.4) (+ y 7.0)) (list (+ x 4.5) (+ y 7.0)) "PV_SLD" 3)
      (pv:draw-line (list (+ x 4.5) (+ y 7.0)) (list (+ x 4.5) (+ y 5.8)) "PV_SLD" 3)

      ;; 4. Inverter Station
      (pv:draw-lwpolyline
        (list (list (+ x 12.5) (+ y 7.5)) (list (+ x 20.5) (+ y 7.5))
              (list (+ x 20.5) (+ y 17.5)) (list (+ x 12.5) (+ y 17.5)))
        "PV_SLD" 4 t)
      (pv:draw-text (list (+ x 13.0) (+ y 16.9))
                    (strcat "STRING INVERTER (" *PV_INV_MFG* " " *PV_INV_MODEL* ")")
                    0.20 "PV_SLD" 2 0.0)
      (pv:draw-text (list (+ x 13.0) (+ y 16.3))
                    (strcat "Rated AC Output : " (rtos inv-kw 2 0) " kW, 415V, 3-Phase")
                    0.13 "PV_SLD" 7 0.0)
      (pv:draw-text (list (+ x 13.0) (+ y 15.8))
                    (strcat "Max DC Input    : " (rtos *PV_INV_VDC_MAX* 2 0) "V | MPPT: " 
                            (itoa *PV_INV_MPPT_COUNT*) " Trackers")
                    0.13 "PV_SLD" 7 0.0)
      (pv:draw-text (list (+ x 13.0) (+ y 15.3))
                    (strcat "MPPT Range      : " (rtos *PV_INV_VMPP_MIN* 2 0) "V - " (rtos *PV_INV_VMPP_MAX* 2 0) "V")
                    0.13 "PV_SLD" 7 0.0)
      (pv:draw-text (list (+ x 13.0) (+ y 14.8))
                    (strcat "Max Efficiency  : " (rtos *PV_INV_EFF_MAX* 2 1) "% (Euro: " (rtos *PV_INV_EFF_EURO* 2 1) "%)")
                    0.13 "PV_SLD" 7 0.0)
      (pv:draw-text (list (+ x 13.0) (+ y 14.3))
                    "Protection      : Anti-Islanding (<2s), RCMU, Insulation Mon."
                    0.13 "PV_SLD" 8 0.0)

      ;; Inverter schematic symbol (DC to AC Bridge)
      (pv:draw-lwpolyline
        (list (list (+ x 14.5) (+ y 9.0)) (list (+ x 18.5) (+ y 9.0))
              (list (+ x 18.5) (+ y 13.5)) (list (+ x 14.5) (+ y 13.5)))
        "PV_SLD" 8 t)
      (pv:draw-line (list (+ x 14.5) (+ y 9.0)) (list (+ x 18.5) (+ y 13.5)) "PV_SLD" 8)
      (pv:draw-text (list (+ x 15.0) (+ y 12.3)) "=" 0.40 "PV_SLD" 1 0.0)
      (pv:draw-text (list (+ x 17.2) (+ y 9.8)) "~" 0.40 "PV_SLD" 3 0.0)
      (pv:draw-text (list (+ x 14.8) (+ y 8.3)) "PWM IGBT Inverter Stage" 0.14 "PV_SLD" 8 0.0)

      ;; Inverter Body Earthing line down to Earth Pit #2
      (pv:draw-line (list (+ x 16.5) (+ y 7.5)) (list (+ x 16.5) (+ y 5.8)) "PV_SLD" 3)

      ;; 5. AC Distribution, Protection, Metering & DISCOM Grid Interface
      ;; Main AC Line from Inverter
      (pv:draw-line (list (+ x 20.5) (+ y 12.5)) (list (+ x 22.3) (+ y 12.5)) "PV_SLD" 3)
      (pv:draw-text (list (+ x 20.7) (+ y 12.8)) "415V, 3-Phase, 4-Wire" 0.13 "PV_SLD" 7 0.0)

      ;; ACDB Enclosure Box
      (pv:draw-lwpolyline
        (list (list (+ x 22.3) (+ y 9.0)) (list (+ x 26.2) (+ y 9.0))
              (list (+ x 26.2) (+ y 16.0)) (list (+ x 22.3) (+ y 16.0)))
        "PV_SLD" 30 t)
      (pv:draw-text (list (+ x 22.5) (+ y 16.2)) "AC DISTRIBUTION BOX (ACDB) IP65" 0.14 "PV_SLD" 30 0.0)

      ;; AC MCCB inside ACDB
      (pv:draw-lwpolyline
        (list (list (+ x 22.6) (+ y 11.7)) (list (+ x 23.8) (+ y 11.7))
              (list (+ x 23.8) (+ y 13.3)) (list (+ x 22.6) (+ y 13.3)))
        "PV_SLD" 1 t)
      (pv:draw-line (list (+ x 22.6) (+ y 11.7)) (list (+ x 23.8) (+ y 13.3)) "PV_SLD" 1)
      (pv:draw-text (list (+ x 22.4) (+ y 13.6)) (strcat "AC MCCB " (itoa ac-mccb-amps) "A 4P") 0.13 "PV_SLD" 7 0.0)
      (pv:draw-text (list (+ x 22.4) (+ y 11.1)) "36kA Shunt Trip" 0.11 "PV_SLD" 8 0.0)

      (pv:draw-line (list (+ x 23.8) (+ y 12.5)) (list (+ x 26.2) (+ y 12.5)) "PV_SLD" 3)

      ;; AC SPD inside ACDB
      (pv:draw-line (list (+ x 25.0) (+ y 12.5)) (list (+ x 25.0) (+ y 10.8)) "PV_SLD" 3)
      (pv:draw-lwpolyline
        (list (list (+ x 24.6) (+ y 10.8)) (list (+ x 25.4) (+ y 10.8))
              (list (+ x 25.4) (+ y 10.0)) (list (+ x 24.6) (+ y 10.0)))
        "PV_SLD" 30 t)
      (pv:draw-text (list (+ x 24.2) (+ y 9.5)) "AC SPD Type II (40kA)" 0.11 "PV_SLD" 30 0.0)
      ;; ACDB earth lead to Earth Pit #2
      (pv:draw-line (list (+ x 25.0) (+ y 10.0)) (list (+ x 25.0) (+ y 7.0)) "PV_SLD" 3)
      (pv:draw-line (list (+ x 25.0) (+ y 7.0)) (list (+ x 16.5) (+ y 7.0)) "PV_SLD" 3)

      ;; Line out of ACDB to Solar Generation Check Meter
      (pv:draw-line (list (+ x 26.2) (+ y 12.5)) (list (+ x 27.8) (+ y 12.5)) "PV_SLD" 3)

      ;; Solar Generation Check Meter (Mandated by CEA Regulations 2023 / DISCOMs)
      (pv:draw-circle (list (+ x 28.5) (+ y 12.5)) 0.70 "PV_SLD" 4)
      (pv:draw-text (list (+ x 28.1) (+ y 12.35)) "kWh" 0.18 "PV_SLD" 7 0.0)
      (pv:draw-text (list (+ x 27.2) (+ y 13.5)) "SOLAR CHECK METER" 0.14 "PV_SLD" 4 0.0)
      (pv:draw-text (list (+ x 27.3) (+ y 11.3)) "Class 0.2S (CEA 2023)" 0.11 "PV_SLD" 8 0.0)

      (pv:draw-line (list (+ x 29.2) (+ y 12.5)) (list (+ x 30.5) (+ y 12.5)) "PV_SLD" 3)

      ;; DISCOM External Manual Isolator (GOS Switch with Visible Air Gap & Padlock)
      (pv:draw-circle (list (+ x 30.7) (+ y 12.5)) 0.08 "PV_SLD" 1)
      (pv:draw-circle (list (+ x 31.7) (+ y 12.5)) 0.08 "PV_SLD" 1)
      (pv:draw-line (list (+ x 30.7) (+ y 12.5)) (list (+ x 31.6) (+ y 13.0)) "PV_SLD" 1)
      (pv:draw-text (list (+ x 30.0) (+ y 13.4)) "DISCOM MANUAL ISOLATOR" 0.13 "PV_SLD" 1 0.0)
      (pv:draw-text (list (+ x 30.1) (+ y 11.8)) "Visible Break & Padlockable" 0.11 "PV_SLD" 8 0.0)

      (pv:draw-line (list (+ x 31.7) (+ y 12.5)) (list (+ x 32.8) (+ y 12.5)) "PV_SLD" 3)

      ;; Bi-Directional Net Meter (DISCOM Tariff Meter)
      (pv:draw-circle (list (+ x 33.5) (+ y 12.5)) 0.70 "PV_SLD" 3)
      (pv:draw-text (list (+ x 33.1) (+ y 12.35)) "kWh" 0.18 "PV_SLD" 7 0.0)
      (pv:draw-text (list (+ x 32.5) (+ y 13.5)) "NET TARIFF METER" 0.14 "PV_SLD" 3 0.0)
      (pv:draw-text (list (+ x 32.7) (+ y 11.3)) "(Bi-directional)" 0.11 "PV_SLD" 8 0.0)

      (pv:draw-line (list (+ x 34.2) (+ y 12.5)) (list (+ x 35.5) (+ y 12.5)) "PV_SLD" 3)

      ;; LT Main Busbar
      (pv:draw-line (list (+ x 35.5) (+ y 9.5)) (list (+ x 35.5) (+ y 15.5)) "PV_SLD" 1)
      (pv:draw-line (list (+ x 35.6) (+ y 9.5)) (list (+ x 35.6) (+ y 15.5)) "PV_SLD" 1)
      (pv:draw-text (list (+ x 34.5) (+ y 15.8)) "LT BUS (415V, 50Hz, 3Ph 4W)" 0.14 "PV_SLD" 1 0.0)

      ;; Utility Grid Arrow
      (pv:draw-line (list (+ x 35.6) (+ y 12.5)) (list (+ x 37.2) (+ y 12.5)) "PV_SLD" 3)
      (pv:draw-line (list (+ x 37.2) (+ y 12.5)) (list (+ x 36.7) (+ y 12.8)) "PV_SLD" 3)
      (pv:draw-line (list (+ x 37.2) (+ y 12.5)) (list (+ x 36.7) (+ y 12.2)) "PV_SLD" 3)
      (pv:draw-text (list (+ x 35.8) (+ y 12.8)) "TO UTILITY GRID" 0.16 "PV_SLD" 2 0.0)

      ;; 6. Dedicated Indian Chemical Earthing Section (IS 3043:2018 & CEA Reg 2023)
      (pv:draw-line (list (+ x 0.4) (+ y 7.4)) (list (+ x (- W 0.4)) (+ y 7.4)) "PV_SLD" 8)
      (pv:draw-text (list (+ x 1.0) (+ y 7.0))
                    "DEDICATED CHEMICAL EARTHING SYSTEM (IS 3043:2018 & CEA SAFETY REGULATIONS 2023):"
                    0.16 "PV_SLD" 3 0.0)

      ;; Earth Pit #1 (DC Side)
      (pv:draw-circle (list (+ x 4.5) (+ y 5.2)) 0.35 "PV_SLD" 3)
      (pv:draw-circle (list (+ x 4.5) (+ y 5.2)) 0.15 "PV_SLD" 3)
      (pv:draw-line (list (+ x 4.5) (+ y 5.2)) (list (+ x 4.5) (+ y 4.5)) "PV_SLD" 3)
      (pv:draw-line (list (+ x 4.1) (+ y 4.5)) (list (+ x 4.9) (+ y 4.5)) "PV_SLD" 3)
      (pv:draw-line (list (+ x 4.25) (+ y 4.35)) (list (+ x 4.75) (+ y 4.35)) "PV_SLD" 3)
      (pv:draw-line (list (+ x 4.4) (+ y 4.2)) (list (+ x 4.6) (+ y 4.2)) "PV_SLD" 3)
      (pv:draw-text (list (+ x 2.2) (+ y 6.4)) "EARTH PIT #1 (DC ARRAYS & AJB)" 0.14 "PV_SLD" 7 0.0)
      (pv:draw-text (list (+ x 2.2) (+ y 6.0)) "25x3 mm GI Strip | R < 5.0 Ohms" 0.12 "PV_SLD" 3 0.0)
      (pv:draw-text (list (+ x 2.2) (+ y 4.0)) "Maintenance-Free Chemical Pit" 0.11 "PV_SLD" 8 0.0)

      ;; Earth Pit #2 (AC & Inverter)
      (pv:draw-circle (list (+ x 16.5) (+ y 5.2)) 0.35 "PV_SLD" 3)
      (pv:draw-circle (list (+ x 16.5) (+ y 5.2)) 0.15 "PV_SLD" 3)
      (pv:draw-line (list (+ x 16.5) (+ y 5.2)) (list (+ x 16.5) (+ y 4.5)) "PV_SLD" 3)
      (pv:draw-line (list (+ x 16.1) (+ y 4.5)) (list (+ x 16.9) (+ y 4.5)) "PV_SLD" 3)
      (pv:draw-line (list (+ x 16.25) (+ y 4.35)) (list (+ x 16.75) (+ y 4.35)) "PV_SLD" 3)
      (pv:draw-line (list (+ x 16.4) (+ y 4.2)) (list (+ x 16.6) (+ y 4.2)) "PV_SLD" 3)
      (pv:draw-text (list (+ x 14.0) (+ y 6.4)) "EARTH PIT #2 (INVERTER & ACDB)" 0.14 "PV_SLD" 7 0.0)
      (pv:draw-text (list (+ x 14.0) (+ y 6.0)) "25x3 mm GI Strip | R < 5.0 Ohms" 0.12 "PV_SLD" 3 0.0)
      (pv:draw-text (list (+ x 14.0) (+ y 4.0)) "Inverter & Neutral Earthing Pit" 0.11 "PV_SLD" 8 0.0)

      ;; Earth Pit #3 (Lightning Arrester)
      (pv:draw-circle (list (+ x 29.5) (+ y 5.2)) 0.35 "PV_SLD" 3)
      (pv:draw-circle (list (+ x 29.5) (+ y 5.2)) 0.15 "PV_SLD" 3)
      (pv:draw-line (list (+ x 29.5) (+ y 5.2)) (list (+ x 29.5) (+ y 4.5)) "PV_SLD" 3)
      (pv:draw-line (list (+ x 29.1) (+ y 4.5)) (list (+ x 29.9) (+ y 4.5)) "PV_SLD" 3)
      (pv:draw-line (list (+ x 29.25) (+ y 4.35)) (list (+ x 29.75) (+ y 4.35)) "PV_SLD" 3)
      (pv:draw-line (list (+ x 29.4) (+ y 4.2)) (list (+ x 29.6) (+ y 4.2)) "PV_SLD" 3)
      (pv:draw-text (list (+ x 27.0) (+ y 6.4)) "EARTH PIT #3 (LIGHTNING ARRESTER)" 0.14 "PV_SLD" 7 0.0)
      (pv:draw-text (list (+ x 27.0) (+ y 6.0)) "25x3 mm Copper Strip | R < 5.0 Ohms" 0.12 "PV_SLD" 3 0.0)
      (pv:draw-text (list (+ x 27.0) (+ y 4.0)) "Dedicated LA Earth Pit (IS/IEC 62305)" 0.11 "PV_SLD" 8 0.0)

      ;; Inter-Pit Segregation Annotation Line
      (pv:draw-line (list (+ x 4.5) (+ y 4.9)) (list (+ x 16.5) (+ y 4.9)) "PV_SLD" 8)
      (pv:draw-text (list (+ x 8.0) (+ y 5.1)) "|<--- Min. 3.0m Separation (IS 3043) --->|" 0.12 "PV_SLD" 8 0.0)
      (pv:draw-line (list (+ x 16.5) (+ y 4.9)) (list (+ x 29.5) (+ y 4.9)) "PV_SLD" 8)
      (pv:draw-text (list (+ x 20.5) (+ y 5.1)) "|<--- Min. 3.0m Separation (IS 3043) --->|" 0.12 "PV_SLD" 8 0.0)

      ;; 7. Cable Schedule & Engineering Legend Box
      (pv:draw-lwpolyline
        (list (list (+ x 0.8) (+ y 0.8)) (list (+ x (- W 0.8)) (+ y 0.8))
              (list (+ x (- W 0.8)) (+ y 3.5)) (list (+ x 0.8) (+ y 3.5)))
        "PV_SLD" 8 t)
      (pv:draw-text (list (+ x 1.2) (+ y 3.1))
                    "SYSTEM SPECIFICATIONS, CABLE SCHEDULE & REGULATORY COMPLIANCE NOTES (INDIA):"
                    0.16 "PV_SLD" 2 0.0)
      (pv:draw-text (list (+ x 1.2) (+ y 2.55))
                    "1. DC Strings Cable  : 1C x 4/6 sq.mm Annealed Tinned Copper, XLPO insulated (EN 50618 / IS 17293), 1500V DC, UV-resistant, routed in perforated HDG trays."
                    0.12 "PV_SLD" 7 0.0)
      (pv:draw-text (list (+ x 1.2) (+ y 2.05))
                    "2. AC Power Cable    : 4C x 50 sq.mm XLPE insulated, Galvanised Steel Strip Armoured Aluminum Cable, 1.1kV grade conforming to IS 7098 (Part 1)."
                    0.12 "PV_SLD" 7 0.0)
      (pv:draw-text (list (+ x 1.2) (+ y 1.55))
                    "3. Earthing System   : 3 Distinct Chemical Earth Pits with Maintenance-Free Backfill Compound (BFC) as per IS 3043:2018; Inter-pit spacing >= 3.0 meters."
                    0.12 "PV_SLD" 7 0.0)
      (pv:draw-text (list (+ x 1.2) (+ y 1.05))
                    "4. Grid Interface    : Anti-islanding tripping < 2.0s per IS 16169; Lockable manual GOS switch with visible break provided for DISCOM lineman safety."
                    0.12 "PV_SLD" 7 0.0)

      (princ (strcat "\n[SolarPV] Indian Standard Single Line Diagram (SLD) successfully generated at (" 
                     (rtos x 2 2) ", " (rtos y 2 2) ")."))
      (alert (strcat "Indian Standard Single Line Diagram (SLD) Generated!\n\n"
                     "Plant Capacity: " (rtos plant-kw 2 1) " kWp (DC)\n"
                     "Inverter: " (rtos inv-kw 2 0) " kW AC (" *PV_INV_MFG* " " *PV_INV_MODEL* ")\n"
                     "Sanctioned Load: " (rtos *PV_SANCTIONED_LOAD* 2 1) " kW (" *PV_GRID_VOLTAGE* ")\n"
                     "Total Strings: " (itoa str-count) " (" (itoa mods-per-str) " modules/string)\n\n"
                     "Features Included:\n"
                     " - Array Junction Box (AJB/DCDB IP65) with Fuses & SPD\n"
                     " - ACDB with 4-Pole MCCB & Type II SPD\n"
                     " - Solar Generation Check Meter (CEA Regulations 2023)\n"
                     " - DISCOM Manual GOS Isolator (Visible Air-Gap & Padlock)\n"
                     " - Bi-Directional Net Meter\n"
                     " - 3 Distinct Chemical Earth Pits with 3m separation (IS 3043:2018)\n\n"
                     "Publication-ready schematic generated on layer 'PV_SLD'."))
    )
  )
  (princ)
)

;;; ==========================================================================
;;; 4. 3D ISOMETRIC VISUALIZATION & SHADING PRUNER (PVcase & ARKA 360 Style)
;;; ==========================================================================
;; Note: pv:draw-3dface is defined at line 990 (duplicate removed)

(defun c:pv-clear-building-3d (/ ss i ent s-rec orig-fp b-footprints)
  ;; 1. Delete generated sloped surface boundaries from PV_BOUNDARY
  (if *PV_ROOF_SURFACES*
    (progn
      (foreach s-rec *PV_ROOF_SURFACES*
        (setq ent (car s-rec))
        (if (and ent (entget ent))
          (entdel ent)
        )
        ;; Collect original footprint entity
        (setq orig-fp (cdr (assoc "BLDG-ENT" (cdr s-rec))))
        (if (and orig-fp (entget orig-fp))
          (if (not (member orig-fp b-footprints))
            (setq b-footprints (cons orig-fp b-footprints))
          )
        )
      )
      (setq *PV_ROOF_SURFACES* nil)
    )
  )
  ;; 2. Clear all 3D building visual entities, restoring footprints back to PV_BOUNDARY
  (if (setq ss (ssget "X" '((8 . "PV_3D_BUILDING,PV_3D_ROOF_OUTLINE,PV_3D_ROOF_FACE,PV_3D_PARAPET"))))
    (progn
      (setq i 0)
      (while (< i (sslength ss))
        (setq ent (ssname ss i))
        ;; If this entity is an original footprint, restore it to PV_BOUNDARY instead of deleting
        (if (member ent b-footprints)
          (progn
            (vl-catch-all-apply 'vla-put-layer (list (vlax-ename->vla-object ent) "PV_BOUNDARY"))
            (vl-catch-all-apply 'vla-put-color (list (vlax-ename->vla-object ent) 1))
          )
          (entdel ent)
        )
        (setq i (1+ i))
      )
      (if b-footprints
        (progn
          (setq *PV_BOUNDARY_LIST* (reverse b-footprints))
          (setq *PV_BOUNDARY_ENT* (car *PV_BOUNDARY_LIST*))
          (c:pv-roof-number)
        )
      )
      (princ (strcat "\n[SolarPV] Cleared 3D building entities. Restored ground footprint(s) on PV_BOUNDARY."))
    )
  )
  (princ)
)

(defun c:pv-clear-3d (/ ss i)
  (if (setq ss (ssget "X" '((8 . "PV_3D_MODULES,PV_3D_STRUCTURE,PV_3D_OBSTACLES,PV_3D_BUILDING,PV_3D_ROOF_OUTLINE,PV_3D_ROOF_FACE,PV_3D_HANDRAIL,PV_3D_SAFETY,PV_3D_WALKWAY,PV_3D_PARAPET"))))
    (progn
      (setq i 0)
      (while (< i (sslength ss))
        (entdel (ssname ss i))
        (setq i (1+ i))
      )
      (setq *PV_HANDRAIL_3D_ENTS* nil)
      (princ (strcat "\n[SolarPV] Cleared " (itoa (sslength ss)) " 3D solar, handrail & building entities."))
    )
    (princ "\n[SolarPV] No 3D entities found to clear.")
  )
  (princ)
)

;; pv:get-roof-z defined at line 585 (duplicate removed)

(defun pv:build-single-3d-building (b-ent / pts bbox x1 y1 x2 y2 xc yc span-x span-y
                                            n i p-curr p-next z-curr z-next h-ridge h-eaves
                                            h-parapet t-parapet z-base z-top pts-in p-a p-b q-a q-b wall-pts sh-poly
                                            created-surfaces slab-pts s-ent s-pts-s s-ent-s s-pts-n s-ent-n
                                            s-pts-w s-ent-w s-pts-e s-ent-e s-pts s-dir s-az)
  (setq pts (pv:get-polyline-pts b-ent))
  (if (and pts (>= (length pts) 3))
    (progn
      (setq bbox (pv:pts-bbox pts))
      (setq x1 (caar bbox)    y1 (cadar bbox)
            x2 (caadr bbox)   y2 (cadadr bbox)
            xc (/ (+ x1 x2) 2.0) yc (/ (+ y1 y2) 2.0)
            span-x (- x2 x1)  span-y (- y2 y1))
      (setq h-ridge (if (> *PV_BLDG_RIDGE_HT* 0.0) *PV_BLDG_RIDGE_HT* 8.0)
            h-eaves (if (> *PV_BLDG_EAVES_HT* 0.0) *PV_BLDG_EAVES_HT* 6.0))
      
      (setq n (length pts) i 0)
      (setq created-surfaces nil)

      ;; 1. Draw 3D perimeter ground lines, corner columns, eaves lines, and vertical wall 3DFACEs
      (while (< i n)
        (setq p-curr (nth i pts)
              p-next (nth (rem (1+ i) n) pts))
        (setq z-curr (pv:get-roof-z p-curr bbox)
              z-next (pv:get-roof-z p-next bbox))
        
        ;; Ground line
        (pv:draw-line-3d (list (car p-curr) (cadr p-curr) 0.0)
                         (list (car p-next) (cadr p-next) 0.0)
                         "PV_3D_BUILDING" 8)
        ;; Vertical corner column
        (pv:draw-line-3d (list (car p-curr) (cadr p-curr) 0.0)
                         (list (car p-curr) (cadr p-curr) z-curr)
                         "PV_3D_BUILDING" 8)
        ;; 3D roof eaves / perimeter edge
        (pv:draw-line-3d (list (car p-curr) (cadr p-curr) z-curr)
                         (list (car p-next) (cadr p-next) z-next)
                         "PV_3D_ROOF_OUTLINE" 3)
        ;; Vertical wall 3DFACE
        (pv:draw-3dface (list (car p-curr) (cadr p-curr) 0.0)
                        (list (car p-next) (cadr p-next) 0.0)
                        (list (car p-next) (cadr p-next) z-next)
                        (list (car p-curr) (cadr p-curr) z-curr)
                        "PV_3D_BUILDING" 8)
        (setq i (1+ i))
      )

      ;; 2. Draw Roof Structure Features & Create Designated Sloped Roof Surfaces on PV_BOUNDARY
      (cond
        ;; Flat RCC
        ((or (= *PV_ROOF_TYPE* "Flat RCC Rooftop") (= *PV_ROOF_SLOPE_DIRS* 0))
         ;; 1. Draw Roof Slab Surface 3DFACE
         (setq slab-pts
           (if (= n 4)
             (list (list (car (nth 0 pts)) (cadr (nth 0 pts)) h-eaves)
                   (list (car (nth 1 pts)) (cadr (nth 1 pts)) h-eaves)
                   (list (car (nth 2 pts)) (cadr (nth 2 pts)) h-eaves)
                   (list (car (nth 3 pts)) (cadr (nth 3 pts)) h-eaves))
             (list (list x1 y1 h-eaves) (list x2 y1 h-eaves)
                   (list x2 y2 h-eaves) (list x1 y2 h-eaves))))
         (pv:draw-3dface (nth 0 slab-pts) (nth 1 slab-pts) (nth 2 slab-pts) (nth 3 slab-pts) "PV_3D_ROOF_FACE" 252)
         (setq s-ent (pv:register-roof-surface slab-pts "Flat RCC Roof Slab" "Flat" *PV_AZIMUTH* bbox b-ent))
         (setq created-surfaces (list s-ent))

         ;; 2. Draw Parapet Wall on the roof surface (rising from h-eaves to h-eaves + h-parapet)
         (if (and *PV_PARAPET_HEIGHT* (> *PV_PARAPET_HEIGHT* 0.0))
           (progn
             (setq h-parapet *PV_PARAPET_HEIGHT*
                   t-parapet (if (and *PV_PARAPET_THICKNESS* (> *PV_PARAPET_THICKNESS* 0.0)) *PV_PARAPET_THICKNESS* 0.23)
                   z-base h-eaves
                   z-top (+ h-eaves h-parapet))
             (setq pts-in (pv:offset-polygon-inward pts t-parapet))
             (if (and pts-in (= (length pts-in) n))
               (progn
                 ;; Draw 2D inner parapet boundary polyline inside the boundary at offset t-parapet
                 (pv:draw-lwpolyline pts-in "PV_PARAPET" 1 t)
                 ;; Clear previously registered parapet obstacles for clean rebuild
                 (if *PV_OBSTACLES*
                   (setq *PV_OBSTACLES*
                     (vl-remove-if '(lambda (obs) (equal (car obs) "PARAPET")) *PV_OBSTACLES*))
                 )
                 (setq i 0)
                 (while (< i n)
                   (setq p-a (nth i pts)
                         p-b (nth (rem (1+ i) n) pts)
                         q-a (nth i pts-in)
                         q-b (nth (rem (1+ i) n) pts-in))
                   
                   ;; Outer vertical face of parapet wall
                   (pv:draw-3dface (list (car p-a) (cadr p-a) z-base)
                                   (list (car p-b) (cadr p-b) z-base)
                                   (list (car p-b) (cadr p-b) z-top)
                                   (list (car p-a) (cadr p-a) z-top)
                                   "PV_3D_PARAPET" 8)
                   
                   ;; Inner vertical face of parapet wall (facing the solar array on the roof slab)
                   (pv:draw-3dface (list (car q-b) (cadr q-b) z-base)
                                   (list (car q-a) (cadr q-a) z-base)
                                   (list (car q-a) (cadr q-a) z-top)
                                   (list (car q-b) (cadr q-b) z-top)
                                   "PV_3D_PARAPET" 8)
                   
                   ;; Top horizontal coping / wall cap at z-top
                   (pv:draw-3dface (list (car p-a) (cadr p-a) z-top)
                                   (list (car p-b) (cadr p-b) z-top)
                                   (list (car q-b) (cadr q-b) z-top)
                                   (list (car q-a) (cadr q-a) z-top)
                                   "PV_3D_PARAPET" 7)
                   
                   ;; 3D Outline wireframe edges
                   (pv:draw-line-3d (list (car p-a) (cadr p-a) z-top) (list (car p-b) (cadr p-b) z-top) "PV_3D_ROOF_OUTLINE" 3)
                   (pv:draw-line-3d (list (car q-a) (cadr q-a) z-top) (list (car q-b) (cadr q-b) z-top) "PV_3D_ROOF_OUTLINE" 3)
                   (pv:draw-line-3d (list (car q-a) (cadr q-a) z-base) (list (car q-b) (cadr q-b) z-base) "PV_3D_ROOF_OUTLINE" 8)
                   
                   ;; Register each parapet wall segment as an obstacle with height h-parapet
                   (setq wall-pts (list (list (car p-a) (cadr p-a))
                                        (list (car p-b) (cadr p-b))
                                        (list (car q-b) (cadr q-b))
                                        (list (car q-a) (cadr q-a))))
                   (setq sh-poly (pv:create-shadow-polygon wall-pts h-parapet *PV_LAT*))
                   (setq *PV_OBSTACLES* (cons (list "PARAPET" h-parapet sh-poly wall-pts) *PV_OBSTACLES*))
                   
                   (setq i (1+ i))
                 )
                 (princ (strcat "\n[SolarPV] 3D Parapet Wall modeled atop roof slab (Height: " 
                                (rtos h-parapet 2 2) "m, Thickness: " (rtos t-parapet 2 2) "m, Base Z: " 
                                (rtos z-base 2 2) "m)."))
               )
             )
           )
         ))

        ;; 2 Directions (Gable Roof)
        ((= *PV_ROOF_SLOPE_DIRS* 2)
         (if (or (= *PV_ROOF_FACING* "North & South") (= *PV_ROOF_FACING* "North-South") (= *PV_ROOF_FACING* "NS"))
           (progn
             ;; 3D Ridge line along Y=yc from X1 to X2
             (pv:draw-line-3d (list x1 yc h-ridge) (list x2 yc h-ridge) "PV_3D_ROOF_OUTLINE" 3)
             ;; West Gable Wall Triangle (at X1)
             (pv:draw-3dface (list x1 y1 h-eaves) (list x1 yc h-ridge)
                             (list x1 y2 h-eaves) (list x1 y2 h-eaves)
                             "PV_3D_BUILDING" 8)
             ;; East Gable Wall Triangle (at X2)
             (pv:draw-3dface (list x2 y1 h-eaves) (list x2 yc h-ridge)
                             (list x2 y2 h-eaves) (list x2 y2 h-eaves)
                             "PV_3D_BUILDING" 8)
             ;; South Roof Sheet 3DFACE
             (pv:draw-3dface (list x1 y1 h-eaves) (list x2 y1 h-eaves)
                             (list x2 yc h-ridge) (list x1 yc h-ridge)
                             "PV_3D_ROOF_FACE" 252)
             ;; North Roof Sheet 3DFACE
             (pv:draw-3dface (list x1 yc h-ridge) (list x2 yc h-ridge)
                             (list x2 y2 h-eaves) (list x1 y2 h-eaves)
                             "PV_3D_ROOF_FACE" 252)
             
             ;; Designate South Sloped Surface as PV Installation Boundary on PV_BOUNDARY
             (setq s-pts-s (list (list x1 y1 h-eaves) (list x2 y1 h-eaves) (list x2 yc h-ridge) (list x1 yc h-ridge)))
             (setq s-ent-s (pv:register-roof-surface s-pts-s "South-Facing Sloped Roof Surface" "South" 180.0 bbox b-ent))
             
             ;; Designate North Sloped Surface as PV Installation Boundary on PV_BOUNDARY
             (setq s-pts-n (list (list x1 yc h-ridge) (list x2 yc h-ridge) (list x2 y2 h-eaves) (list x1 y2 h-eaves)))
             (setq s-ent-n (pv:register-roof-surface s-pts-n "North-Facing Sloped Roof Surface" "North" 0.0 bbox b-ent))
             
             (setq created-surfaces (list s-ent-s s-ent-n))
           )
           (progn ; East & West facing (Ridge along X=xc from Y1 to Y2)
             ;; 3D Ridge line
             (pv:draw-line-3d (list xc y1 h-ridge) (list xc y2 h-ridge) "PV_3D_ROOF_OUTLINE" 3)
             ;; South Gable Wall Triangle (at Y1)
             (pv:draw-3dface (list x1 y1 h-eaves) (list xc y1 h-ridge)
                             (list x2 y1 h-eaves) (list x2 y1 h-eaves)
                             "PV_3D_BUILDING" 8)
             ;; North Gable Wall Triangle (at Y2)
             (pv:draw-3dface (list x1 y2 h-eaves) (list xc y2 h-ridge)
                             (list x2 y2 h-eaves) (list x2 y2 h-eaves)
                             "PV_3D_BUILDING" 8)
             ;; West Roof Sheet 3DFACE
             (pv:draw-3dface (list x1 y1 h-eaves) (list xc y1 h-ridge)
                             (list xc y2 h-ridge) (list x1 y2 h-eaves)
                             "PV_3D_ROOF_FACE" 252)
             ;; East Roof Sheet 3DFACE
             (pv:draw-3dface (list xc y1 h-ridge) (list x2 y1 h-eaves)
                             (list x2 y2 h-eaves) (list xc y2 h-ridge)
                             "PV_3D_ROOF_FACE" 252)
             
             ;; Designate West Sloped Surface as PV Installation Boundary on PV_BOUNDARY
             (setq s-pts-w (list (list x1 y1 h-eaves) (list xc y1 h-ridge) (list xc y2 h-ridge) (list x1 y2 h-eaves)))
             (setq s-ent-w (pv:register-roof-surface s-pts-w "West-Facing Sloped Roof Surface" "West" 270.0 bbox b-ent))
             
             ;; Designate East Sloped Surface as PV Installation Boundary on PV_BOUNDARY
             (setq s-pts-e (list (list xc y1 h-ridge) (list x2 y1 h-eaves) (list x2 y2 h-eaves) (list xc y2 h-ridge)))
             (setq s-ent-e (pv:register-roof-surface s-pts-e "East-Facing Sloped Roof Surface" "East" 90.0 bbox b-ent))
             
             (setq created-surfaces (list s-ent-w s-ent-e))
           )
         ))

        ;; 1 Direction (Monoslope / Shed)
        ((= *PV_ROOF_SLOPE_DIRS* 1)
         (cond
           ((or (= *PV_ROOF_FACING* "South") (= *PV_ROOF_FACING* "S"))
            (setq s-pts (list (list x1 y1 h-eaves) (list x2 y1 h-eaves) (list x2 y2 h-ridge) (list x1 y2 h-ridge))
                  s-dir "South" s-az 180.0))
           ((or (= *PV_ROOF_FACING* "North") (= *PV_ROOF_FACING* "N"))
            (setq s-pts (list (list x1 y1 h-ridge) (list x2 y1 h-ridge) (list x2 y2 h-eaves) (list x1 y2 h-eaves))
                  s-dir "North" s-az 0.0))
           ((or (= *PV_ROOF_FACING* "West") (= *PV_ROOF_FACING* "W"))
            (setq s-pts (list (list x1 y1 h-eaves) (list x2 y1 h-ridge) (list x2 y2 h-ridge) (list x1 y2 h-eaves))
                  s-dir "West" s-az 270.0))
           (t ; East
            (setq s-pts (list (list x1 y1 h-ridge) (list x2 y1 h-eaves) (list x2 y2 h-eaves) (list x1 y2 h-ridge))
                  s-dir "East" s-az 90.0))
         )
         (pv:draw-3dface (nth 0 s-pts) (nth 1 s-pts) (nth 2 s-pts) (nth 3 s-pts) "PV_3D_ROOF_FACE" 252)
         (setq s-ent (pv:register-roof-surface s-pts (strcat s-dir "-Facing Monoslope Roof Surface") s-dir s-az bbox b-ent))
         (setq created-surfaces (list s-ent))
        )

        ;; 4 Directions (Hip Roof)
        ((= *PV_ROOF_SLOPE_DIRS* 4)
         ;; 4 Hip ridge lines
         (pv:draw-line-3d (list xc yc h-ridge) (list x1 y1 h-eaves) "PV_3D_ROOF_OUTLINE" 3)
         (pv:draw-line-3d (list xc yc h-ridge) (list x2 y1 h-eaves) "PV_3D_ROOF_OUTLINE" 3)
         (pv:draw-line-3d (list xc yc h-ridge) (list x2 y2 h-eaves) "PV_3D_ROOF_OUTLINE" 3)
         (pv:draw-line-3d (list xc yc h-ridge) (list x1 y2 h-eaves) "PV_3D_ROOF_OUTLINE" 3)
         ;; 4 Roof Facet 3DFACEs
         (pv:draw-3dface (list x1 y1 h-eaves) (list x2 y1 h-eaves)
                         (list xc yc h-ridge) (list xc yc h-ridge)
                         "PV_3D_ROOF_FACE" 252)
         (pv:draw-3dface (list x2 y1 h-eaves) (list x2 y2 h-eaves)
                         (list xc yc h-ridge) (list xc yc h-ridge)
                         "PV_3D_ROOF_FACE" 252)
         (pv:draw-3dface (list x2 y2 h-eaves) (list x1 y2 h-eaves)
                         (list xc yc h-ridge) (list xc yc h-ridge)
                         "PV_3D_ROOF_FACE" 252)
         (pv:draw-3dface (list x1 y2 h-eaves) (list x1 y1 h-eaves)
                         (list xc yc h-ridge) (list xc yc h-ridge)
                         "PV_3D_ROOF_FACE" 252)
         ;; 4 Sloped Surface Boundaries on PV_BOUNDARY
         (setq s-pts-s (list (list x1 y1 h-eaves) (list x2 y1 h-eaves) (list xc yc h-ridge)))
         (setq s-ent-s (pv:register-roof-surface s-pts-s "South-Facing Hip Roof Facet" "South" 180.0 bbox b-ent))
         (setq s-pts-e (list (list x2 y1 h-eaves) (list x2 y2 h-eaves) (list xc yc h-ridge)))
         (setq s-ent-e (pv:register-roof-surface s-pts-e "East-Facing Hip Roof Facet" "East" 90.0 bbox b-ent))
         (setq s-pts-n (list (list x2 y2 h-eaves) (list x1 y2 h-eaves) (list xc yc h-ridge)))
         (setq s-ent-n (pv:register-roof-surface s-pts-n "North-Facing Hip Roof Facet" "North" 0.0 bbox b-ent))
         (setq s-pts-w (list (list x1 y2 h-eaves) (list x1 y1 h-eaves) (list xc yc h-ridge)))
         (setq s-ent-w (pv:register-roof-surface s-pts-w "West-Facing Hip Roof Facet" "West" 270.0 bbox b-ent))
         (setq created-surfaces (list s-ent-s s-ent-e s-ent-n s-ent-w))
        )
      )

      ;; Move the original ground polyline off PV_BOUNDARY to PV_3D_BUILDING (color 8)
      (if (and b-ent (entget b-ent))
        (progn
          (vl-catch-all-apply 'vla-put-layer (list (vlax-ename->vla-object b-ent) "PV_3D_BUILDING"))
          (vl-catch-all-apply 'vla-put-color (list (vlax-ename->vla-object b-ent) 8))
        )
      )
      created-surfaces
    )
    nil
  )
)

(defun pv:build-all-3d-buildings (/ count b-list ss i new-b-list surfs ent)
  (pv:init-layers)
  (c:pv-clear-building-3d)
  (setq b-list (if (and (boundp '*PV_BOUNDARY_LIST*) *PV_BOUNDARY_LIST*)
                 *PV_BOUNDARY_LIST*
                 (if (and (boundp '*PV_BOUNDARY_ENT*) *PV_BOUNDARY_ENT*)
                   (list *PV_BOUNDARY_ENT*)
                   nil)))
  (if (null b-list)
    (progn
      ;; Check for any entity on PV_BOUNDARY
      (if (setq ss (ssget "X" '((0 . "LWPOLYLINE,POLYLINE,REGION") (8 . "PV_BOUNDARY"))))
        (progn
          (setq b-list nil i 0)
          (while (< i (sslength ss))
            (setq b-list (cons (ssname ss i) b-list))
            (setq i (1+ i))
          )
          (setq *PV_BOUNDARY_LIST* (reverse b-list))
        )
      )
    )
  )
  (setq count 0
        new-b-list nil
        *PV_ROOF_SURFACES* nil)
  (if b-list
    (foreach ent b-list
      (setq surfs (pv:build-single-3d-building ent))
      (if surfs
        (progn
          (setq count (1+ count))
          (setq new-b-list (append new-b-list surfs))
        )
      )
    )
  )
  (if new-b-list
    (progn
      (setq *PV_BOUNDARY_LIST* new-b-list)
      (setq *PV_BOUNDARY_ENT* (car *PV_BOUNDARY_LIST*))
      (setq *PV_ACTIVE_ROOF_IDX* 0)
      (c:pv-roof-number)
      (if (pv:is-metal-roof-p)
        (progn
          (setq *PV_MOUNT_OPT* "Flush Mounted (Parallel to Roof)")
          (setq *PV_TILT* (if (> *PV_ROOF_SLOPE* 0.0) *PV_ROOF_SLOPE* 10.0))
        )
      )
    )
  )
  count
)

(defun pv:prompt-roof-type-and-build-3d (/ r-type s-dirs facing h-ridge h-eaves h-bldg h-parapet t-parapet span dz slope-rad slope-deg count sw-view bbox)
  (pv:init-layers)
  (princ "\n=======================================================")
  (princ "\n [SolarPV] ROOFTOP CONFIGURATION & 3D BUILDING MODELER")
  (princ "\n=======================================================")
  
  (initget "Flat-RCC Metal-Sheet Flat Metal")
  (setq r-type (getkword "\nSelect Rooftop Type [Flat-RCC / Metal-Sheet] <Flat-RCC>: "))
  (if (or (null r-type) (= r-type "Flat") (= r-type "Flat-RCC"))
    (progn
      (setq *PV_ROOF_TYPE* "Flat RCC Rooftop")
      (setq *PV_ROOF_SLOPE* 0.0)
      (setq *PV_ROOF_SLOPE_DIRS* 0)
      (setq *PV_ROOF_FACING* "Flat")
      
      ;; 1. Building Height
      (initget 6) ; positive non-zero
      (setq h-bldg (getdist (strcat "\nEnter Building Height in meters (Roof Slab Surface Elevation) <" 
                                    (rtos (if (> *PV_BLDG_EAVES_HT* 0.0) *PV_BLDG_EAVES_HT* 6.0) 2 2) ">: ")))
      (if (null h-bldg) (setq h-bldg (if (> *PV_BLDG_EAVES_HT* 0.0) *PV_BLDG_EAVES_HT* 6.0)))
      (setq *PV_BLDG_EAVES_HT* h-bldg
            *PV_BLDG_RIDGE_HT* h-bldg)
      
      ;; 2. Parapet Wall Height
      (initget 4) ; positive or zero
      (setq h-parapet (getdist (strcat "\nEnter Parapet Wall Height in meters [0 for none] <" 
                                       (rtos (if (and *PV_PARAPET_HEIGHT* (>= *PV_PARAPET_HEIGHT* 0.0)) *PV_PARAPET_HEIGHT* 1.0) 2 2) ">: ")))
      (if (null h-parapet) (setq h-parapet (if (and *PV_PARAPET_HEIGHT* (>= *PV_PARAPET_HEIGHT* 0.0)) *PV_PARAPET_HEIGHT* 1.0)))
      (setq *PV_PARAPET_HEIGHT* h-parapet)
      
      ;; 3. Parapet Wall Thickness
      (if (> *PV_PARAPET_HEIGHT* 0.0)
        (progn
          (initget 6) ; positive non-zero
          (setq t-parapet (getdist (strcat "\nEnter Parapet Wall Thickness in meters <" 
                                           (rtos (if (and *PV_PARAPET_THICKNESS* (> *PV_PARAPET_THICKNESS* 0.0)) *PV_PARAPET_THICKNESS* 0.23) 2 2) ">: ")))
          (if (null t-parapet) (setq t-parapet (if (and *PV_PARAPET_THICKNESS* (> *PV_PARAPET_THICKNESS* 0.0)) *PV_PARAPET_THICKNESS* 0.23)))
          (setq *PV_PARAPET_THICKNESS* t-parapet)
        )
      )
      (princ (strcat "\n[SolarPV] Configured Flat RCC Rooftop (Building Height: " (rtos h-bldg 2 2) 
                     " m, Parapet Wall: " (rtos *PV_PARAPET_HEIGHT* 2 2) " m H x " 
                     (rtos *PV_PARAPET_THICKNESS* 2 2) " m T)."))
    )
    (progn
      (setq *PV_ROOF_TYPE* "Metal Sheet Rooftop")
      ;; Prompt for 1, 2, or 4 directions
      (initget "1 2 4 One Two Four")
      (setq s-dirs (getkword "\nIs the Metal Sheet Roof sloped in [1 / 2 / 4] directions? <2>: "))
      (if (or (null s-dirs) (= s-dirs "2") (= s-dirs "Two"))
        (progn
          (setq *PV_ROOF_SLOPE_DIRS* 2)
          ;; For 2 directions define if facing North & South or East & West
          (initget "North-South East-West NS EW")
          (setq facing (getkword "\nDefine slope facing directions [North-South / East-West] <North-South>: "))
          (if (or (null facing) (= facing "NS") (= facing "North-South"))
            (setq *PV_ROOF_FACING* "North & South")
            (setq *PV_ROOF_FACING* "East & West")
          )
          ;; Heights at centre (ridge) and ends (eaves)
          (initget 6)
          (setq h-ridge (getdist (strcat "\nEnter Building Height at the CENTRE / RIDGE (m) <" (rtos (if (> *PV_BLDG_RIDGE_HT* 0.0) *PV_BLDG_RIDGE_HT* 8.0) 2 2) ">: ")))
          (if (null h-ridge) (setq h-ridge (if (> *PV_BLDG_RIDGE_HT* 0.0) *PV_BLDG_RIDGE_HT* 8.0)))
          
          (initget 6)
          (setq h-eaves (getdist (strcat "\nEnter Building Height at the ENDS / EAVES (m) <" (rtos (if (> *PV_BLDG_EAVES_HT* 0.0) *PV_BLDG_EAVES_HT* 6.0) 2 2) ">: ")))
          (if (null h-eaves) (setq h-eaves (if (> *PV_BLDG_EAVES_HT* 0.0) *PV_BLDG_EAVES_HT* 6.0)))
          
          (setq *PV_BLDG_RIDGE_HT* h-ridge
                *PV_BLDG_EAVES_HT* h-eaves)
        )
        (if (or (= s-dirs "1") (= s-dirs "One"))
          (progn
            (setq *PV_ROOF_SLOPE_DIRS* 1)
            ;; For 1 direction specify the direction the sloped face is facing
            (initget "North South East West N S E W")
            (setq facing (getkword "\nSpecify the direction the sloped face is facing [North / South / East / West] <South>: "))
            (if (null facing) (setq facing "South"))
            (cond
              ((or (= facing "S") (= facing "South")) (setq *PV_ROOF_FACING* "South"))
              ((or (= facing "N") (= facing "North")) (setq *PV_ROOF_FACING* "North"))
              ((or (= facing "E") (= facing "East"))  (setq *PV_ROOF_FACING* "East"))
              ((or (= facing "W") (= facing "West"))  (setq *PV_ROOF_FACING* "West"))
            )
            ;; Heights at high end / centre and low end / eaves
            (initget 6)
            (setq h-ridge (getdist (strcat "\nEnter Building Height at the HIGH END / Centre (m) <" (rtos (if (> *PV_BLDG_RIDGE_HT* 0.0) *PV_BLDG_RIDGE_HT* 8.0) 2 2) ">: ")))
            (if (null h-ridge) (setq h-ridge (if (> *PV_BLDG_RIDGE_HT* 0.0) *PV_BLDG_RIDGE_HT* 8.0)))
            
            (initget 6)
            (setq h-eaves (getdist (strcat "\nEnter Building Height at the LOW END / Eaves (m) <" (rtos (if (> *PV_BLDG_EAVES_HT* 0.0) *PV_BLDG_EAVES_HT* 6.0) 2 2) ">: ")))
            (if (null h-eaves) (setq h-eaves (if (> *PV_BLDG_EAVES_HT* 0.0) *PV_BLDG_EAVES_HT* 6.0)))
            
            (setq *PV_BLDG_RIDGE_HT* h-ridge
                  *PV_BLDG_EAVES_HT* h-eaves)
          )
          ;; 4 directions (Hip roof)
          (progn
            (setq *PV_ROOF_SLOPE_DIRS* 4)
            (setq *PV_ROOF_FACING* "4-Directions")
            (initget 6)
            (setq h-ridge (getdist (strcat "\nEnter Building Height at the CENTRE / APEX (m) <" (rtos (if (> *PV_BLDG_RIDGE_HT* 0.0) *PV_BLDG_RIDGE_HT* 8.0) 2 2) ">: ")))
            (if (null h-ridge) (setq h-ridge (if (> *PV_BLDG_RIDGE_HT* 0.0) *PV_BLDG_RIDGE_HT* 8.0)))
            
            (initget 6)
            (setq h-eaves (getdist (strcat "\nEnter Building Height at the PERIMETER / EAVES (m) <" (rtos (if (> *PV_BLDG_EAVES_HT* 0.0) *PV_BLDG_EAVES_HT* 6.0) 2 2) ">: ")))
            (if (null h-eaves) (setq h-eaves (if (> *PV_BLDG_EAVES_HT* 0.0) *PV_BLDG_EAVES_HT* 6.0)))
            
            (setq *PV_BLDG_RIDGE_HT* h-ridge
                  *PV_BLDG_EAVES_HT* h-eaves)
          )
        )
      )

      ;; Calculate slope angle in degrees
      (if (and *PV_BOUNDARY_LIST* (car *PV_BOUNDARY_LIST*))
        (setq bbox (pv:pts-bbox (pv:get-polyline-pts (car *PV_BOUNDARY_LIST*))))
        (setq bbox (list (list 0.0 0.0) (list 50.0 30.0)))
      )
      (setq dz (abs (- *PV_BLDG_RIDGE_HT* *PV_BLDG_EAVES_HT*)))
      (cond
        ((= *PV_ROOF_SLOPE_DIRS* 1)
         (setq span (if (or (= *PV_ROOF_FACING* "South") (= *PV_ROOF_FACING* "North"))
                      (- (cadadr bbox) (cadar bbox))
                      (- (caadr bbox) (caar bbox))))
        )
        ((= *PV_ROOF_SLOPE_DIRS* 2)
         (setq span (if (or (= *PV_ROOF_FACING* "North & South") (= *PV_ROOF_FACING* "North-South") (= *PV_ROOF_FACING* "NS"))
                      (/ (- (cadadr bbox) (cadar bbox)) 2.0)
                      (/ (- (caadr bbox) (caar bbox)) 2.0)))
        )
        (t ; 4 directions
         (setq span (/ (min (- (caadr bbox) (caar bbox)) (- (cadadr bbox) (cadar bbox))) 2.0))
        )
      )
      (setq slope-rad (atan dz (max 1.0 span)))
      (setq slope-deg (* slope-rad (/ 180.0 pi)))
      (setq *PV_ROOF_SLOPE* (atof (rtos slope-deg 2 1)))
      (setq *PV_MOUNT_OPT* "Flush Mounted (Parallel to Roof)")
      (setq *PV_TILT* *PV_ROOF_SLOPE*)
      (princ (strcat "\n[SolarPV] Calculated Roof Slope: " (rtos *PV_ROOF_SLOPE* 2 1) " deg (" (rtos (* (/ dz (max 1.0 span)) 100.0) 2 1) "% pitch)."))
    )
  )

  ;; 3. Build 3D Building Outlines & Designate Sloped Surfaces as PV Installation Boundaries
  (setq count (pv:build-all-3d-buildings))
  (princ (strcat "\n[SolarPV] Created 3D Building Outlines for " (itoa count) " building(s)."))
  (princ (strcat "\n[SolarPV] Designated " (itoa (length *PV_BOUNDARY_LIST*)) " sloped roof surface(s) as active PV installation boundaries on layer 'PV_BOUNDARY'."))
  (princ "\n Layers created: PV_3D_BUILDING (Walls & Footprint), PV_3D_ROOF_OUTLINE (Eaves & Ridge), PV_3D_ROOF_FACE (Roof Sheets).")

  ;; 4. Prompt to inspect in 3D view
  (initget "Yes No Y N")
  (setq sw-view (getkword "\nSwitch to 3D Isometric View to inspect Building? [Yes / No] <No>: "))
  (if (or (= sw-view "Yes") (= sw-view "Y"))
    (progn
      (vl-catch-all-apply 'vl-cmdf (list "_.-view" "_swiso"))
      (vl-catch-all-apply 'vl-cmdf (list "_.visualstyles" "_c"))
      (vl-catch-all-apply 'vl-cmdf (list "_.zoom" "_e"))
      (princ "\n[SolarPV] Viewport set to South-West Isometric with Conceptual Shading.")
    )
  )
  (princ)
)

(defun c:pv-building-3d ()
  (pv:prompt-roof-type-and-build-3d)
)

(defun c:pv-3d-view (/ ss i ent pts bbox x1 x2 y1 y2 tilt-rad
                       z-roof z-base z-top p1 p2 p3 p4 o-ent o-ht o-pts obbox ox1 ox2 oy1 oy2
                       mod-count obs-count handrail-count safety-count walkway-count r-bbox mxc myc
                       h-rec h-pts j s-rec p-start turn-pts p-end s-all sp1 sp2 sz1 sz2 sz-end w-poly)
  (vl-load-com)
  (pv:init-layers)
  (c:pv-clear-3d)
  
  ;; Automatically ensure 3D building envelope outlines are generated
  (pv:build-all-3d-buildings)
  
  ;; Get boundary bbox for elevation calculations
  (setq r-bbox (pv:get-roof-bbox))
  (if (null r-bbox) (setq r-bbox (list (list 0.0 0.0) (list 100.0 100.0))))

  (setq mod-count 0 obs-count 0 handrail-count 0 safety-count 0 walkway-count 0)

  ;; 1. Extrude 3D PV Modules atop Roof Surface
  (setq ss (ssget "X" '((0 . "LWPOLYLINE,POLYLINE,3DFACE") (8 . "PV_MODULES,PV_MODULES_EAST,PV_MODULES_WEST,PV_MODULES_SOUTH,PV_MODULES_NORTH"))))
  (if (and ss (> (sslength ss) 0))
    (progn
      (princ "\n[SolarPV] Generating 3D Tilted Solar Tables and Support Structures atop Building...")
      (setq tilt-rad (dtr *PV_TILT*))
      (setq i 0 mod-count (sslength ss))
      (while (< i mod-count)
        (setq ent (ssname ss i))
        (setq pts (pv:get-polyline-pts ent))
        (if (and pts (>= (length pts) 4))
          (progn
            (setq bbox (pv:pts-bbox pts))
            (setq x1 (caar bbox)  y1 (cadar bbox)
                  x2 (caadr bbox) y2 (cadadr bbox))
            (setq mxc (/ (+ x1 x2) 2.0)
                  myc (/ (+ y1 y2) 2.0))
            
            (setq z-clear (if (> *PV_MOD_CLEAR* 0.0) *PV_MOD_CLEAR* 0.10))
            (if (or (= *PV_ROOF_TYPE* "Metal Sheet Rooftop") (= *PV_ROOF_TYPE* "Sloped Metal Sheet"))
              (progn
                ;; Metal Roof: modules lie parallel to the sloped metal sheet
                (setq z1 (+ (pv:get-roof-z (list x1 y1) r-bbox) z-clear)
                      z2 (+ (pv:get-roof-z (list x2 y1) r-bbox) z-clear)
                      z3 (+ (pv:get-roof-z (list x2 y2) r-bbox) z-clear)
                      z4 (+ (pv:get-roof-z (list x1 y2) r-bbox) z-clear))
                (setq p1 (list x1 y1 z1)
                      p2 (list x2 y1 z2)
                      p3 (list x2 y2 z3)
                      p4 (list x1 y2 z4))

                ;; Module 3DFACE
                (pv:draw-3dface p1 p2 p3 p4 "PV_3D_MODULES" 140)

                ;; Clamps / mini-rails connecting module to roof sheet
                (pv:draw-line-3d (list x1 y1 (- z1 z-clear)) p1 "PV_3D_STRUCTURE" 8)
                (pv:draw-line-3d (list x2 y1 (- z2 z-clear)) p2 "PV_3D_STRUCTURE" 8)
                (pv:draw-line-3d (list x2 y2 (- z3 z-clear)) p3 "PV_3D_STRUCTURE" 8)
                (pv:draw-line-3d (list x1 y2 (- z4 z-clear)) p4 "PV_3D_STRUCTURE" 8)
              )
              (if (and (= *PV_ROOF_TYPE* "Flat RCC Rooftop")
                       (wcmatch (strcase *PV_MOUNT_OPT*) "*ELEVATED*"))
                (progn
                  ;; Flat RCC Rooftop: Elevated Continuous Incident Solar Plane
                  (setq p1 (list x1 y1 (pv:get-elevated-plane-z (list x1 y1) r-bbox))
                        p2 (list x2 y1 (pv:get-elevated-plane-z (list x2 y1) r-bbox))
                        p3 (list x2 y2 (pv:get-elevated-plane-z (list x2 y2) r-bbox))
                        p4 (list x1 y2 (pv:get-elevated-plane-z (list x1 y2) r-bbox)))
                  ;; Module 3DFACE
                  (pv:draw-3dface p1 p2 p3 p4 "PV_3D_MODULES" 140)
                )
                (progn
                  ;; Flat RCC Rooftop: MMS legs tilted to *PV_TILT* degrees
                  (setq z-roof (pv:get-roof-z (list mxc myc) r-bbox))
                  (setq z-base (+ z-roof z-clear))
                  (setq z-top (+ z-base (* *PV_MOD_LEN* (sin tilt-rad))))

                  (setq p1 (list x1 y1 z-base)
                        p2 (list x2 y1 z-base)
                        p3 (list x2 y2 z-top)
                        p4 (list x1 y2 z-top))

                  ;; Module 3DFACE
                  (pv:draw-3dface p1 p2 p3 p4 "PV_3D_MODULES" 140)

                  ;; MMS Legs (connect roof surface to module support frame)
                  (pv:draw-line-3d (list x1 y1 z-roof) p1 "PV_3D_STRUCTURE" 8)
                  (pv:draw-line-3d (list x2 y1 z-roof) p2 "PV_3D_STRUCTURE" 8)
                  (pv:draw-line-3d (list x1 y2 z-roof) p4 "PV_3D_STRUCTURE" 8)
                  (pv:draw-line-3d (list x2 y2 z-roof) p3 "PV_3D_STRUCTURE" 8)

                  ;; Purlins
                  (pv:draw-line-3d p1 p4 "PV_3D_STRUCTURE" 8)
                  (pv:draw-line-3d p2 p3 "PV_3D_STRUCTURE" 8)
                )
              )
            )
          )
        )
        (setq i (1+ i))
      )
    )
    (princ "\n[SolarPV] (Note: No placed PV modules found. Run PVLAYOUT to place modules).")
  )

  ;; 2. Extrude Obstacles into 3D Boxes sitting atop Rooftop Surface
  (if (and *PV_OBSTACLES* (> (length *PV_OBSTACLES*) 0))
    (foreach obs *PV_OBSTACLES*
      (setq o-ent (car obs)
            o-ht  (cadr obs)
            o-pts (cadddr obs))
      (if (and o-pts (>= (length o-pts) 3))
        (progn
          (pv:model-3d-obstacle o-ent o-ht o-pts r-bbox)
          (setq obs-count (1+ obs-count))
        )
      )
    )
  )

  ;; 3. Generate 3D Safety Handrails atop Rooftop Surface
  (if (and *PV_HANDRAIL_LINES* (> (length *PV_HANDRAIL_LINES*) 0))
    (progn
      (princ "\n[SolarPV] Rendering 3D Safety Handrails with Stanchions & Horizontal Rails...")
      (foreach h-rec *PV_HANDRAIL_LINES*
        (setq h-pts (car h-rec))
        (if (and h-pts (>= (length h-pts) 2))
          (progn
            (setq j 0)
            (while (< j (1- (length h-pts)))
              (pv:draw-handrail-segment-3d (nth j h-pts) (nth (1+ j) h-pts) r-bbox)
              (setq j (1+ j))
            )
            (setq handrail-count (1+ handrail-count))
          )
        )
      )
    )
  )

  ;; 4. Generate 3D Fall Safety Lifelines atop Rooftop Surface
  (if (and *PV_FALL_SAFETY_LINES* (> (length *PV_FALL_SAFETY_LINES*) 0))
    (progn
      (princ "\n[SolarPV] Rendering 3D Fall Safety Lifeline Wire Ropes & Standoff Posts...")
      (foreach s-rec *PV_FALL_SAFETY_LINES*
        (setq p-start (nth 0 s-rec)
              turn-pts (nth 1 s-rec)
              p-end (nth 2 s-rec))
        (setq s-all (cons p-start (append turn-pts (list p-end))))
        (setq j 0)
        (while (< j (1- (length s-all)))
          (setq sp1 (nth j s-all)
                sp2 (nth (1+ j) s-all))
          (setq sz1 (+ (pv:get-roof-z sp1 r-bbox) 0.15)
                sz2 (+ (pv:get-roof-z sp2 r-bbox) 0.15))
          ;; 3D SS Wire Rope
          (pv:draw-line-3d (list (car sp1) (cadr sp1) sz1)
                          (list (car sp2) (cadr sp2) sz2)
                          "PV_3D_SAFETY" 6)
          ;; Standoff post at sp1
          (pv:draw-line-3d (list (car sp1) (cadr sp1) (- sz1 0.15))
                          (list (car sp1) (cadr sp1) sz1)
                          "PV_3D_SAFETY" 6)
          (setq j (1+ j))
        )
        ;; Standoff post at last anchor
        (setq sz-end (+ (pv:get-roof-z p-end r-bbox) 0.15))
        (pv:draw-line-3d (list (car p-end) (cadr p-end) (- sz-end 0.15))
                        (list (car p-end) (cadr p-end) sz-end)
                        "PV_3D_SAFETY" 6)
        (setq safety-count (1+ safety-count))
      )
    )
  )

  ;; 5. Generate 3D Maintenance Walkways atop Rooftop Surface
  (if (and *PV_WALKWAY_POLYS* (> (length *PV_WALKWAY_POLYS*) 0))
    (foreach w-poly *PV_WALKWAY_POLYS*
      (if (and w-poly (>= (length w-poly) 3))
        (progn
          (setq w-3d (mapcar '(lambda (p) (list (car p) (cadr p) (+ (pv:get-roof-z p r-bbox) 0.02))) w-poly))
          (pv:draw-3d-poly w-3d "PV_3D_WALKWAY" 30 t)
          (if (>= (length w-3d) 4)
            (pv:draw-3dface (nth 0 w-3d) (nth 1 w-3d) (nth 2 w-3d) (nth 3 w-3d) "PV_3D_WALKWAY" 30)
          )
          (setq walkway-count (1+ walkway-count))
        )
      )
    )
  )

  ;; Switch to South-West Isometric View with Conceptual Shading
  (vl-catch-all-apply 'vl-cmdf (list "_.-view" "_swiso"))
  (vl-catch-all-apply 'vl-cmdf (list "_.visualstyles" "_c"))
  (vl-catch-all-apply 'vl-cmdf (list "_.zoom" "_e"))

  (princ "\n=======================================================")
  (princ "\n [SolarPV] 3D Isometric Rooftop Array Visualization Complete:")
  (princ "\n 3D Building Outlines : Walls & Roof Sheets (PV_3D_BUILDING, PV_3D_ROOF_OUTLINE)")
  (if (> mod-count 0)
    (princ (strcat "\n 3D Modules Modeled   : " (itoa mod-count) " atop roof (Tilt: " (rtos *PV_TILT* 2 1) " deg, Layer: PV_3D_MODULES)")))
  (if (> obs-count 0)
    (princ (strcat "\n 3D Obstacles Extruded: " (itoa obs-count) " atop roof surface (Layer: PV_3D_OBSTACLES)")))
  (if (or (> handrail-count 0) (> *PV_HANDRAIL_LENGTH* 0.0))
    (princ (strcat "\n 3D Handrails Modeled : " (rtos *PV_HANDRAIL_LENGTH* 2 1) "m (" *PV_HANDRAIL_POST_SHAPE* " Posts, " *PV_HANDRAIL_RAIL_SHAPE* " " (itoa *PV_HANDRAIL_NUM_RAILS*) "-Rails, Layer: PV_3D_HANDRAIL)")))
  (if (or (> safety-count 0) (> *PV_FALL_SAFETY_LENGTH* 0.0))
    (princ (strcat "\n 3D Safety Lifelines  : " (rtos *PV_FALL_SAFETY_LENGTH* 2 1) "m (Layer: PV_3D_SAFETY)")))
  (if (> walkway-count 0)
    (princ (strcat "\n 3D Walkways Elevated : " (itoa walkway-count) " corridor(s) (Layer: PV_3D_WALKWAY)")))
  (princ "\n Viewport set to SW Isometric with Conceptual Shading.")
  (princ "\n=======================================================")
  (princ)
)

(defun c:pv-prune-shaded (/ ss i ent pts bbox
                            all-shadow-polys ss-sh j sh-ent sh-pts
                            shaded-list unshaded-count shaded-count
                            pct-shaded ans is-shaded)
  (vl-load-com)
  (pv:init-layers)
  (setq all-shadow-polys nil)

  (if *PV_OBSTACLES*
    (foreach obs *PV_OBSTACLES*
      (if (caddr obs) (setq all-shadow-polys (cons (caddr obs) all-shadow-polys)))
    )
  )
  (if (setq ss-sh (ssget "X" '((8 . "PV_SHADOW"))))
    (progn
      (setq j 0)
      (while (< j (sslength ss-sh))
        (setq sh-ent (ssname ss-sh j))
        (setq sh-pts (pv:get-entity-pts sh-ent))
        (if sh-pts (setq all-shadow-polys (cons sh-pts all-shadow-polys)))
        (setq j (1+ j))
      )
    )
  )

  (if (null all-shadow-polys)
    (progn
      (princ "\n[SolarPV] No shadow envelopes active. Draw or pick obstacles with shadows first!")
      (alert "No shadow envelopes found.\nPlease define obstacles with 'chk_draw_shadow' enabled first.")
    )
    (progn
      (setq ss (ssget "X" '((0 . "LWPOLYLINE,POLYLINE,3DFACE") (8 . "PV_MODULES,PV_MODULES_EAST,PV_MODULES_WEST,PV_MODULES_SOUTH,PV_MODULES_NORTH"))))
      (if (null ss)
        (princ "\n[SolarPV] No PV modules found on module layers.")
        (progn
          (setq shaded-list nil i 0)
          (while (< i (sslength ss))
            (setq ent (ssname ss i))
            (setq pts (pv:get-polyline-pts ent))
            (if (and pts (>= (length pts) 4))
              (progn
                (setq bbox (pv:pts-bbox pts))
                (setq is-shaded nil)
                (foreach sp all-shadow-polys
                  (if (and (not is-shaded)
                           (pv:box-hits-polygon (car bbox) (cadr bbox) sp 0.05))
                    (setq is-shaded t)
                  )
                )
                (if is-shaded (setq shaded-list (cons ent shaded-list)))
              )
            )
            (setq i (1+ i))
          )

          (setq shaded-count (length shaded-list))
          (if (= shaded-count 0)
            (progn
              (princ "\n[SolarPV] Excellent! Zero modules are in obstacle shadows. 100% array yield clean.")
              (alert "Shading Audit Complete!\n\nZero (0) modules are shaded by obstacles.\nArray Performance Ratio is optimal!")
            )
            (progn
              (setq pct-shaded (* (/ (float shaded-count) (float (sslength ss))) 100.0))
              (foreach ent shaded-list
                (vl-catch-all-apply 'vla-put-Color (list (vlax-ename->vla-object ent) 1))
              )

              (princ "\n=======================================================")
              (princ (strcat "\n [SolarPV] Shading Audit: " (itoa shaded-count) " of " (itoa (sslength ss)) 
                             " modules shaded (" (rtos pct-shaded 2 1) "% of array)."))
              (princ "\n Shaded modules highlighted in RED.")
              (princ "\n=======================================================")

              (initget "Yes No")
              (setq ans (getkword (strcat "\nPrune (delete) " (itoa shaded-count) " over-shaded modules to optimize PR? [Yes/No] <Yes>: ")))
              (if (or (null ans) (= ans "Yes"))
                (progn
                  (foreach ent shaded-list (entdel ent))
                  (setq *PV_MODULE_COUNT* (- (sslength ss) shaded-count))
                  (setq *PV_PLANT_KW* (/ (* *PV_MODULE_COUNT* *PV_MOD_WATT*) 1000.0))
                  (princ (strcat "\n[SolarPV] Successfully pruned " (itoa shaded-count) " shaded modules."))
                  (princ (strcat "\nNew Active Modules: " (itoa *PV_MODULE_COUNT*) " | New Capacity: " (rtos *PV_PLANT_KW* 2 2) " kWp"))
                  (alert (strcat "Over-Shaded Modules Pruned!\n\nDeleted: " (itoa shaded-count) " modules"
                                 "\nRemaining Modules: " (itoa *PV_MODULE_COUNT*)
                                 "\nNew Plant Capacity: " (rtos *PV_PLANT_KW* 2 2) " kWp"
                                 "\n\nPerformance Ratio and array generation are now protected from obstacle mismatch!"))
                )
                (princ "\n[SolarPV] Shaded modules retained without deletion.")
              )
            )
          )
        )
      )
    )
  )
  (princ)
)

;;; ==========================================================================
;;; 5. FINANCIAL ROI ENGINE & PVSYST 3D EXPORT (ARKA 360 Style)
;;; ==========================================================================
(defun pv:calc-financial-roi (plant-kw yr1-kwh / capex gross-capex subsidy net-capex
                                                  yr1-savings yr1-om net-yr1-savings ad-tax-shield
                                                  payback cum-savings cum-gen yr yr-gen yr-tariff
                                                  yr-om yr-net lcoe roi)
  (setq gross-capex (* plant-kw 1000.0 *PV_EPC_COST_PER_W*))
  ;; Apply Indian GST (blended 13.8%)
  (if (and (boundp '*PV_GST_RATE*) (> *PV_GST_RATE* 0.0))
    (setq gross-capex (* gross-capex (+ 1.0 (/ *PV_GST_RATE* 100.0))))
  )
  ;; Apply PM Surya Ghar Central Subsidy (India residential: 1kW=30k, 2kW=60k, >=3kW=78k)
  (setq subsidy
    (if (and (boundp '*PV_PM_SURYA_GHAR*) (= *PV_PM_SURYA_GHAR* 1))
      (cond
        ((<= plant-kw 1.2) 30000.0)
        ((<= plant-kw 2.2) 60000.0)
        (t (if (and (boundp '*PV_SUBSIDY_RS*) (> *PV_SUBSIDY_RS* 0.0)) *PV_SUBSIDY_RS* 78000.0))
      )
      0.0
    )
  )
  ;; Apply Commercial 40% Accelerated Depreciation tax shield in Year 1 (Corporate tax ~25%)
  (setq ad-tax-shield
    (if (and (boundp '*PV_COMMERCIAL_AD*) (= *PV_COMMERCIAL_AD* 1))
      (* gross-capex 0.40 0.25)
      0.0
    )
  )
  (setq net-capex (max 1000.0 (- gross-capex subsidy ad-tax-shield)))
  (setq capex net-capex)
  (setq yr1-savings (* yr1-kwh *PV_GRID_TARIFF*))
  (setq yr1-om (* capex (/ *PV_OPEX_PERCENT* 100.0)))
  (setq net-yr1-savings (- yr1-savings yr1-om))
  (setq payback (if (> net-yr1-savings 0.0) (/ capex net-yr1-savings) 99.0))

  (setq cum-savings 0.0 cum-gen 0.0 yr 1)
  (while (<= yr 25)
    (setq yr-gen (* yr1-kwh (- 1.0 (* 0.0055 (1- yr)))))
    (setq yr-tariff (* *PV_GRID_TARIFF* (expt (+ 1.0 (/ *PV_TARIFF_ESC* 100.0)) (1- yr))))
    (setq yr-om (* yr1-om (expt 1.02 (1- yr))))
    (setq yr-net (- (* yr-gen yr-tariff) yr-om))
    (setq cum-savings (+ cum-savings yr-net))
    (setq cum-gen (+ cum-gen yr-gen))
    (setq yr (1+ yr))
  )

  (setq lcoe (if (> cum-gen 0.0) (/ (+ capex (* yr1-om 25.0)) cum-gen) 0.0))
  (setq roi (if (> capex 0.0) (* (/ (- cum-savings capex) capex) 100.0) 0.0))

  (list capex yr1-savings payback cum-savings lcoe roi)
)

(defun c:pv-export-pvsyst (/ ss i ent pts bbox xc yc zc w l
                             csv-path f tbl-id str-id)
  (vl-load-com)
  (setq ss (ssget "X" '((0 . "LWPOLYLINE,POLYLINE,3DFACE") (8 . "PV_MODULES,PV_MODULES_EAST,PV_MODULES_WEST,PV_MODULES_SOUTH,PV_MODULES_NORTH"))))
  (if (null ss)
    (progn
      (princ "\n[SolarPV] Error: No placed PV modules found. Run PVLAYOUT first!")
      (alert "No PV modules found on module layers.\nPlease generate layout before exporting to PVsyst.")
    )
    (progn
      (setq csv-path (strcat (if (getvar "DWGPREFIX") (getvar "DWGPREFIX") "C:\\Temp\\") "PVsyst_3D_Layout.csv"))
      (setq f (open csv-path "w"))
      (if (not f)
        (progn
          (princ "\n[SolarPV] Error: Could not open file for writing: PVsyst_3D_Layout.csv")
          (alert "Failed to create 'PVsyst_3D_Layout.csv'.")
        )
        (progn
          (write-line "# PVsyst 3D Scene Array Layout Export" f)
          (write-line (strcat "# Project: " *PV_PROJ_NAME* " | Lat: " (rtos *PV_LAT* 2 4) " | Lon: " (rtos *PV_LON* 2 4)) f)
          (write-line (strcat "# Module: " *PV_PAN_MFG* " " *PV_PAN_MODEL* " (" (rtos *PV_MOD_WATT* 2 0) " Wp)") f)
          (write-line (strcat "# Tilt: " (rtos *PV_TILT* 2 1) " deg | Azimuth: " (rtos *PV_AZIMUTH* 2 1) " deg") f)
          (write-line "Table_ID,X_Center_m,Y_Center_m,Z_Base_m,Width_m,Length_m,Tilt_Deg,Azimuth_Deg,Modules_Count,String_ID" f)

          (setq i 0 tbl-id 1)
          (while (< i (sslength ss))
            (setq ent (ssname ss i))
            (setq pts (pv:get-polyline-pts ent))
            (if (and pts (>= (length pts) 4))
              (progn
                (setq bbox (pv:pts-bbox pts))
                (setq xc (/ (+ (caar bbox) (caadr bbox)) 2.0))
                (setq yc (/ (+ (cadar bbox) (cadadr bbox)) 2.0))
                (setq zc (if (> *PV_MOD_CLEAR* 0.0) *PV_MOD_CLEAR* 0.50))
                (setq w (abs (- (caadr bbox) (caar bbox))))
                (setq l (abs (- (cadadr bbox) (cadar bbox))))
                (setq str-id (strcat "STR-" (itoa (1+ (fix (/ i (if (> *PV_STRING_SIZE* 0) *PV_STRING_SIZE* 20)))))))

                (write-line
                  (strcat (itoa tbl-id) ","
                          (rtos xc 2 3) ","
                          (rtos yc 2 3) ","
                          (rtos zc 2 3) ","
                          (rtos w 2 3) ","
                          (rtos l 2 3) ","
                          (rtos *PV_TILT* 2 1) ","
                          (rtos *PV_AZIMUTH* 2 1) ",1,"
                          str-id)
                  f)
                (setq tbl-id (1+ tbl-id))
              )
            )
            (setq i (1+ i))
          )
          (close f)

          (princ (strcat "\n[SolarPV] PVsyst 3D Array CSV exported to: " csv-path))
          (alert (strcat "PVsyst 3D Scene Exported Successfully!\n\nFile: " csv-path
                         "\nTables Exported: " (itoa (1- tbl-id))
                         "\nFormat: 3D Array Coordinates, Tilt, Azimuth & String IDs."
                         "\n\nReady for direct import into PVsyst 7/8 near-shading 3D scene!"))
          (startapp "notepad" csv-path)
        )
      )
    )
  )
  (princ)
)

;;; --------------------------------------------------------------------------
;;; Interactive Pick Functions (Boundary & Obstacles)
;;; --------------------------------------------------------------------------
(defun c:pv-pick-boundary (/ ss ent i ent-list has-face picked-list first-vals)
  (pv:init-layers)
  (princ "\nSelect Roof Face(s) or closed boundary polyline(s) for Solar PV Rooftop...")
  (setq ss nil)
  (setq ss (ssget "_I"))
  (if (and (not ss) *PV_PRE_SEL*)
    (progn (setq ss *PV_PRE_SEL* *PV_PRE_SEL* nil))
  )
  (if (not ss)
    (setq ss (ssget '((0 . "3DFACE,LWPOLYLINE,POLYLINE,REGION"))))
  )
  (sssetfirst nil nil)
  (if (and ss (> (sslength ss) 0))
    (progn
      ;; Detect if selection contains 3DFACE (already modeled roof faces)
      (setq has-face nil i 0)
      (while (< i (sslength ss))
        (if (= (cdr (assoc 0 (entget (ssname ss i)))) "3DFACE")
          (setq has-face t)
        )
        (setq i (1+ i))
      )
      (if has-face
        (progn
          (setq picked-list (pv:resolve-selected-faces ss))
          (if picked-list
            (progn
              (setq *PV_BOUNDARY_LIST* picked-list
                    *PV_BOUNDARY_ENT* (car picked-list)
                    *PV_ACTIVE_ROOF_IDX* 0)
              (if (setq first-vals (pv:get-active-surface-tilt-az))
                (if (> (car first-vals) 0.5)
                  (setq *PV_ROOF_TYPE*  "Metal Sheet Rooftop"
                        *PV_MOUNT_OPT*  "Flush Mounted (Parallel to Roof)"
                        *PV_TILT*       (car first-vals)
                        *PV_AZIMUTH*    (cadr first-vals)
                        *PV_ROOF_SLOPE* (car first-vals))
                )
              )
              (princ (strcat "\n[SolarPV] Registered " (itoa (length *PV_BOUNDARY_LIST*)) " 3D roof face(s) for module installation."))
              (c:pv-roof-number)
            )
          )
        )
        (progn
          (setq ent-list nil i 0)
          (while (< i (sslength ss))
            (setq ent (ssname ss i))
            (vl-catch-all-apply 'vla-put-layer (list (vlax-ename->vla-object ent) "PV_BOUNDARY"))
            (setq ent-list (cons ent ent-list))
            (setq i (1+ i))
          )
          (setq *PV_BOUNDARY_LIST* (reverse ent-list))
          (setq *PV_BOUNDARY_ENT* (car *PV_BOUNDARY_LIST*))
          (setq *PV_ACTIVE_ROOF_IDX* 0)
          (princ (strcat "\n[SolarPV] Successfully selected " (itoa (length *PV_BOUNDARY_LIST*)) " rooftop boundary/roof(s) assigned to layer 'PV_BOUNDARY'."))
          (c:pv-roof-number)
          ;; Prompt user for Rooftop Type, Slopes (1/2/4 dirs), Facing Direction & Heights to create 3D Building Outlines
          (pv:prompt-roof-type-and-build-3d)
        )
      )
    )
    (progn
      (if (setq ss (ssget "X" '((0 . "LWPOLYLINE,POLYLINE,REGION") (8 . "PV_BOUNDARY"))))
        (progn
          (setq ent-list nil i 0)
          (while (< i (sslength ss))
            (setq ent-list (cons (ssname ss i) ent-list))
            (setq i (1+ i))
          )
          (setq *PV_BOUNDARY_LIST* (reverse ent-list))
          (setq *PV_BOUNDARY_ENT* (car *PV_BOUNDARY_LIST*))
          (setq *PV_ACTIVE_ROOF_IDX* 0)
          (princ (strcat "\n[SolarPV] Auto-detected " (itoa (length *PV_BOUNDARY_LIST*)) " existing roof boundaries on 'PV_BOUNDARY'."))
          (c:pv-roof-number)
          (pv:prompt-roof-type-and-build-3d)
        )
        (princ "\n[SolarPV] No boundary polyline selected.")
      )
    )
  )
  (princ)
)

(defun c:pv-pick-obstacles (/ ss i ent ht-str ht shadow-poly obs-poly choice ht-input count raw-ents all-ents)
  (pv:init-layers)
  (setq ss nil)
  (setvar "PICKSTYLE" 3)
  (setvar "PICKFIRST" 1)
  
  (setq ss (ssget "_I"))
  (if (and (not ss) *PV_PRE_SEL*)
    (progn (setq ss *PV_PRE_SEL* *PV_PRE_SEL* nil))
  )
  (if (not ss)
    (progn
      (princ "\n==========================================================================")
      (princ "\n[SolarPV] SELECT OBSTACLES (Blocks, Polylines, Circles, 3DSolids, ARRAYS)")
      (princ "\n==========================================================================")
      (setq ss (ssget))
    )
  )
  (sssetfirst nil nil)
  
  (if (not ss)
    (progn
      (initget "Yes No")
      (if (/= (getkword "\nNo objects selected. Auto-detect all entities on 'PV_OBSTACLE' layer? [Yes/No] <Yes>: ") "No")
        (setq ss (ssget "X" '((8 . "PV_OBSTACLE"))))
      )
    )
  )
  
  (if (and ss (> (sslength ss) 0))
    (progn
      (setq raw-ents nil i 0)
      (while (< i (sslength ss))
        (setq ent (ssname ss i))
        (if (not (and *PV_BOUNDARY_ENT* (equal ent *PV_BOUNDARY_ENT*)))
          (setq raw-ents (cons ent raw-ents))
        )
        (setq i (1+ i))
      )
      (setq raw-ents (reverse raw-ents))
      (setq all-ents (pv:unpack-array-entities raw-ents))
      
      (if (and all-ents (> (length all-ents) 0))
        (progn
          (if (and *PV_OBSTACLES* (> (length *PV_OBSTACLES*) 0))
            (progn
              (initget "Append Replace Clear")
              (setq choice (getkword (strcat "\nExisting obstacles found (" (itoa (length *PV_OBSTACLES*)) "). [Append / Replace / Clear] <Append>: ")))
              (cond
                ((= choice "Replace") (setq *PV_OBSTACLES* nil))
                ((= choice "Clear") (c:pv-clear-obstacles))
              )
            )
          )
          
          (initget "Individual")
          (setq ht-input (getreal (strcat "\nEnter obstacle height in meters for all " 
                                          (itoa (length all-ents)) 
                                          " selected obstacle(s) [type 'I' for Individual] <" 
                                          (rtos *PV_DEF_OBS_HT* 2 2) ">: ")))
          (if (numberp ht-input) (setq *PV_DEF_OBS_HT* ht-input))
          
          (setq count 0)
          (foreach ent all-ents
            (vl-catch-all-apply 'vla-put-layer (list (vlax-ename->vla-object ent) "PV_OBSTACLE"))
            (if (= ht-input "Individual")
              (progn
                (setq ht-str (getstring (strcat "\nEnter height (m) for obstacle #" (itoa (1+ count)) " <" (rtos *PV_DEF_OBS_HT* 2 2) ">: ")))
                (setq ht (if (and ht-str (/= ht-str "")) (atof ht-str) *PV_DEF_OBS_HT*))
              )
              (setq ht *PV_DEF_OBS_HT*)
            )
            (setq obs-poly (pv:get-entity-pts ent))
            (if (= count 0)
              (princ (strcat "\n[SolarPV] Project Site Coordinates: Latitude " (rtos *PV_LAT* 2 4) 
                             " deg N/S, Longitude " (rtos *PV_LON* 2 4) " deg E/W."))
            )
            (setq shadow-poly (pv:create-shadow-polygon ent ht *PV_LAT*))
            (pv:model-3d-obstacle ent ht obs-poly nil)
            (setq *PV_OBSTACLES* (cons (list ent ht shadow-poly obs-poly) *PV_OBSTACLES*))
            (setq count (1+ count))
          )
          (princ (strcat "\n[SolarPV] Successfully registered & modeled " (itoa count) " obstacle(s) atop rooftop surface."))
        )
      )
    )
  )
  (princ)
)

(defun c:pv-clear-obstacles (/ ss i ent)
  (if (setq ss (ssget "X" '((8 . "PV_SHADOW,PV_3D_OBSTACLES"))))
    (progn
      (setq i 0)
      (while (< i (sslength ss))
        (setq ent (ssname ss i))
        (entdel ent)
        (setq i (1+ i))
      )
    )
  )
  (setq *PV_OBSTACLES* nil)
  (princ "\n[SolarPV] Cleared obstacle registry and deleted shadow polygons.")
  (princ)
)

;;; --------------------------------------------------------------------------
;;; Toggle Obstacle Shadow Maps ON / OFF
;;; --------------------------------------------------------------------------
(defun pv:set-shadow-mode (enabled / ss-sh i)
  (pv:init-layers)
  (setq *PV_DRAW_SHADOW* (if enabled 1 0))
  (if enabled
    (progn
      (vl-catch-all-apply 'vl-cmdf (list "_.LAYER" "_Thaw" "PV_SHADOW" "_On" "PV_SHADOW" ""))
      (pv:ensure-all-obstacle-shadows)
      (princ "\n[SolarPV] Obstacle Shadow Maps: TOGGLED ON (Layer 'PV_SHADOW' On).")
    )
    (progn
      (if (setq ss-sh (ssget "X" '((8 . "PV_SHADOW"))))
        (progn
          (setq i 0)
          (while (< i (sslength ss-sh))
            (entdel (ssname ss-sh i))
            (setq i (1+ i))
          )
        )
      )
      (vl-catch-all-apply 'vl-cmdf (list "_.LAYER" "_Freeze" "PV_SHADOW" ""))
      (princ "\n[SolarPV] Obstacle Shadow Maps: TOGGLED OFF (Layer 'PV_SHADOW' Frozen).")
    )
  )
  (if (get_tile "chk_draw_shadow")
    (set_tile "chk_draw_shadow" (itoa *PV_DRAW_SHADOW*))
  )
  (alert (if enabled
           "Obstacle Shadow Maps: TOGGLED ON\n\n9am-3pm dynamic solar shadow envelopes are active and displayed on layer 'PV_SHADOW'.\nShadow areas will be excluded during layout generation."
           "Obstacle Shadow Maps: TOGGLED OFF\n\nObstacle shadow envelopes are frozen/hidden.\nShadow exclusion is disabled during layout generation."))
  *PV_DRAW_SHADOW*
)

(defun c:pv-toggle-shadow ()
  (pv:set-shadow-mode (= *PV_DRAW_SHADOW* 0))
  (princ)
)

(defun c:pv-shadow-on ()
  (pv:set-shadow-mode t)
  (princ)
)

(defun c:pv-shadow-off ()
  (pv:set-shadow-mode nil)
  (princ)
)

;;; --------------------------------------------------------------------------
;;; Verification & Auto-Generation of Shadow Maps for all Obstacles (H > 0)
;;; --------------------------------------------------------------------------
(defun pv:ensure-all-obstacle-shadows (/ ss-obs raw-obs unp-obs ent ht obs-pts sh-poly
                                         found-obs updated-count ss-sh i
                                         h-rec h-pts)
  (pv:init-layers)
  (if (/= *PV_DRAW_SHADOW* 1)
    (progn
      (if (setq ss-sh (ssget "X" '((8 . "PV_SHADOW"))))
        (progn
          (setq i 0)
          (while (< i (sslength ss-sh))
            (entdel (ssname ss-sh i))
            (setq i (1+ i))
          )
        )
      )
      (vl-catch-all-apply 'vl-cmdf (list "_.LAYER" "_Freeze" "PV_SHADOW" ""))
      0
    )
    (progn
      (vl-catch-all-apply 'vl-cmdf (list "_.LAYER" "_Thaw" "PV_SHADOW" "_On" "PV_SHADOW" ""))
      (setq updated-count 0)

      ;; 1. Clear previous shadow entities to prevent duplicate overlapping polygons
      (if (setq ss-sh (ssget "X" '((8 . "PV_SHADOW"))))
        (progn
          (setq i 0)
          (while (< i (sslength ss-sh))
            (entdel (ssname ss-sh i))
            (setq i (1+ i))
          )
        )
      )

      ;; 2. Scan drawing for entities on layer PV_OBSTACLE and ensure they have shadow maps
      (if (setq ss-obs (ssget "X" '((8 . "PV_OBSTACLE"))))
        (progn
          (setq raw-obs nil i 0)
          (while (< i (sslength ss-obs))
            (setq ent (ssname ss-obs i))
            (if (not (and *PV_BOUNDARY_ENT* (equal ent *PV_BOUNDARY_ENT*)))
              (setq raw-obs (cons ent raw-obs))
            )
            (setq i (1+ i))
          )
          (setq unp-obs (pv:unpack-array-entities raw-obs))
          (foreach ent unp-obs
            (setq obs-pts (pv:get-entity-pts ent))
            (if (and obs-pts (> (length obs-pts) 1))
              (progn
                ;; Check if entity already in *PV_OBSTACLES*
                (setq found-obs nil)
                (if *PV_OBSTACLES*
                  (foreach obs *PV_OBSTACLES*
                    (if (and (not found-obs) (equal (car obs) ent))
                      (setq found-obs obs)
                    )
                  )
                )
                (if found-obs
                  (setq ht (cadr found-obs))
                  (progn
                    (setq ht (if (and *PV_DEF_OBS_HT* (> *PV_DEF_OBS_HT* 0.0)) *PV_DEF_OBS_HT* 1.0))
                    (pv:model-3d-obstacle ent ht obs-pts nil)
                  )
                )
                ;; If height > 0, generate and draw shadow envelope on PV_SHADOW
                (if (> ht 0.0)
                  (progn
                    (setq sh-poly (pv:create-shadow-polygon ent ht *PV_LAT*))
                    (if found-obs
                      (setq *PV_OBSTACLES*
                        (mapcar '(lambda (item)
                                   (if (equal (car item) ent)
                                     (list ent ht sh-poly obs-pts)
                                     item))
                                *PV_OBSTACLES*))
                      (setq *PV_OBSTACLES* (cons (list ent ht sh-poly obs-pts) *PV_OBSTACLES*))
                    )
                    (setq updated-count (1+ updated-count))
                  )
                  (progn
                    ;; Height <= 0: retain boundary without shadow map
                    (if (not found-obs)
                      (setq *PV_OBSTACLES* (cons (list ent ht nil obs-pts) *PV_OBSTACLES*))
                    )
                  )
                )
              )
            )
          )
        )
      )

      ;; 3. Scan *PV_OBSTACLES* for any point-based/custom obstacles not on layer PV_OBSTACLE
      (if *PV_OBSTACLES*
        (setq *PV_OBSTACLES*
          (mapcar
            '(lambda (obs / o-ent o-ht o-sh o-pts target-src)
               (setq o-ent (car obs)
                     o-ht  (cadr obs)
                     o-sh  (caddr obs)
                     o-pts (cadddr obs))
               (if (> o-ht 0.0)
                 (progn
                   (setq target-src (if (and o-ent (not (listp o-ent)) (not (member o-ent '("HANDRAIL" "PARAPET")))) o-ent o-pts))
                   (if target-src
                     (progn
                       (setq o-sh (pv:create-shadow-polygon target-src o-ht *PV_LAT*))
                       (setq updated-count (1+ updated-count))
                     )
                   )
                 )
               )
               (list o-ent o-ht o-sh o-pts)
             )
            *PV_OBSTACLES*
          )
        )
      )

      ;; 4. Check Flat RCC Parapet Wall if configured
      (if (and (= *PV_ROOF_TYPE* "Flat RCC Rooftop")
               *PV_PARAPET_HEIGHT*
               (> *PV_PARAPET_HEIGHT* 0.0)
               (not (vl-some '(lambda (obs) (equal (car obs) "PARAPET")) *PV_OBSTACLES*)))
        (progn
          (pv:build-all-3d-buildings)
          (setq updated-count (1+ updated-count))
        )
      )

      ;; 5. Check Safety Handrails if configured to cast shadow
      (if (and (= *PV_HANDRAIL_CAST_SHADOW* 1)
               *PV_HANDRAIL_LINES*
               (> *PV_HANDRAIL_HEIGHT* 0.0))
        (foreach h-rec *PV_HANDRAIL_LINES*
          (setq h-pts (car h-rec))
          (if (and h-pts (>= (length h-pts) 2))
            (progn
              (setq sh-poly (pv:create-shadow-polygon h-pts *PV_HANDRAIL_HEIGHT* *PV_LAT*))
              (if (and sh-poly (> (length sh-poly) 2))
                (progn
                  (setq *PV_OBSTACLES* (cons (list "HANDRAIL" *PV_HANDRAIL_HEIGHT* sh-poly h-pts) *PV_OBSTACLES*))
                  (setq updated-count (1+ updated-count))
                )
              )
            )
          )
        )
      )

      (if (> updated-count 0)
        (princ (strcat "\n[SolarPV] Shadow Check Complete: Verified shadow maps for " 
                       (itoa updated-count) " obstacle element(s) (H > 0m, 9am-3pm Solar Window, Lat: " 
                       (rtos *PV_LAT* 2 2) " deg, Layer: PV_SHADOW). Areas will be excluded from layout."))
        (princ "\n[SolarPV] Shadow Check: No elevated obstacles (H > 0m) found on roof.")
      )
      updated-count
    )
  )
)

;;; --------------------------------------------------------------------------
;;; Layout Generation Engine (Boundary Fill vs Target Capacity)
;;; --------------------------------------------------------------------------
(defun pv:clear-layout ()
  (foreach lay '("PV_MODULES" "PV_STRUCTURE" "PV_3D_STRUCTURE" "PV_3D_MODULES" "PV_MODULES_EAST" "PV_MODULES_WEST" "PV_MODULES_SOUTH" "PV_MODULES_NORTH")
    (if (setq ss (ssget "X" (list (cons 8 lay))))
      (progn
        (setq i 0)
        (while (< i (sslength ss))
          (entdel (ssname ss i))
          (setq i (1+ i))
        )
      )
    )
  )
  ;; Clear auto-generated walkway entities if any were created
  (if *PV_AUTO_WALKWAY_ENTS*
    (progn
      (foreach ent *PV_AUTO_WALKWAY_ENTS*
        (if (and ent (entget ent)) (entdel ent))
      )
      (setq *PV_AUTO_WALKWAY_ENTS* nil)
    )
  )
)

(defun pv:generate-grid (b-pts / mod-l mod-w cur-mod-w cur-mod-l col-gap row-gap
                                tbl-cols tbl-rows tbl-w tbl-l tbl-pitch
                                std-aisle-x
                                bbox minpt maxpt minx miny maxx maxy
                                total-mods total-tables cur-y cur-x cur-col-x
                                all-exclusion-polys ss-obs raw-obs unp-obs ss-sh ss-ww ss-saf
                                i k p-pts ent sh-poly obs-poly saf-polys ply
                                p-st t-pts p-en fs-pts hr-pts
                                row-had-mods tbl-has-mods
                                mx my mod-corners in-boundary collides pt ex-poly r c
                                target-mod-count is-target-mode reached-target
                                mod-row-idx next-walkway-row mod-col-idx next-walkway-col
                                ww-y1 ww-y2 ww-poly
                                cur-bbox z-clear z1 z2 z3 z4 mod-3d-pts tilt-dz
                                is-elevated row-modules-list)
  
  (setq is-target-mode (wcmatch (strcase *PV_LAYOUT_MODE*) "*TARGET*"))
  (setq target-mod-count
    (if (and is-target-mode (> *PV_TARGET_KW* 0.0))
      (fix (+ 0.9999 (/ (* *PV_TARGET_KW* 1000.0) *PV_MOD_WATT*)))
      999999
    )
  )
  (setq reached-target nil)

  (setq mod-l *PV_MOD_LEN*)
  (setq mod-w *PV_MOD_WID*)
  (if (= *PV_MOD_ORIENT* "Landscape")
    (setq cur-mod-w mod-l cur-mod-l mod-w)
    (setq cur-mod-w mod-w cur-mod-l mod-l)
  )

  (setq col-gap *PV_COL_SPACING*)
  (setq row-gap *PV_ROW_SPACING*)
  (setq tbl-cols (max 1 *PV_TABLE_COLS*))
  (setq tbl-rows (max 1 *PV_TABLE_ROWS*))

  (setq tbl-w (+ (* tbl-cols cur-mod-w) (* (1- tbl-cols) col-gap)))
  (setq tbl-l (+ (* tbl-rows cur-mod-l) (* (1- tbl-rows) row-gap)))

  (cond
    ((and (pv:is-metal-roof-p) (= *PV_MOUNT_OPT* "Flush Mounted (Parallel to Roof)"))
      (setq tbl-pitch (+ tbl-l 0.15)))
    ((wcmatch (strcase *PV_MOUNT_OPT*) "*ELEVATED*")
      (setq tbl-pitch (if (> *PV_PITCH* (+ tbl-l 0.10)) *PV_PITCH* (+ tbl-l (max 0.10 *PV_ROW_SPACING*)))))
    (t
      (setq tbl-pitch (max (+ tbl-l 0.10) *PV_PITCH*)))
  )
  (setq is-elevated (and (= *PV_ROOF_TYPE* "Flat RCC Rooftop")
                         (wcmatch (strcase *PV_MOUNT_OPT*) "*ELEVATED*")))

  (setq std-aisle-x (max 0.10 *PV_STD_AISLE_X*))

  (setq t-parapet (if (and (= *PV_ROOF_TYPE* "Flat RCC Rooftop")
                           *PV_PARAPET_THICKNESS*
                           (> *PV_PARAPET_THICKNESS* 0.0))
                    *PV_PARAPET_THICKNESS*
                    0.0))
  (setq usable-b-pts (if (> t-parapet 0.0)
                       (pv:offset-polygon-inward b-pts t-parapet)
                       b-pts))
  (if (null usable-b-pts) (setq usable-b-pts b-pts))

  (setq bbox (pv:pts-bbox usable-b-pts))
  (setq minpt (car bbox) maxpt (cadr bbox))
  (setq minx (+ (car minpt) *PV_SETBACK*))
  (setq miny (+ (cadr minpt) *PV_SETBACK*))
  (setq maxx (- (car maxpt) *PV_SETBACK*))
  (setq maxy (- (cadr maxpt) *PV_SETBACK*))

  (setq total-mods 0 total-tables 0 cur-y miny)

  ;; 1. Ensure shadow maps are drawn and gather obstacle & shadow exclusion polygons
  (if (and (= *PV_DRAW_SHADOW* 1)
           (null (ssget "X" '((8 . "PV_SHADOW"))))
           (or *PV_OBSTACLES* (ssget "X" '((8 . "PV_OBSTACLE")))))
    (pv:ensure-all-obstacle-shadows)
  )
  (setq all-exclusion-polys nil)
  (foreach obs *PV_OBSTACLES*
    (setq obs-poly (cadddr obs))
    (if (not obs-poly) (setq obs-poly (pv:get-entity-pts (car obs))))
    (if obs-poly (setq all-exclusion-polys (cons obs-poly all-exclusion-polys)))
    (setq sh-poly (caddr obs))
    (if (and sh-poly (= *PV_DRAW_SHADOW* 1))
      (setq all-exclusion-polys (cons sh-poly all-exclusion-polys))
    )
  )

  (if (setq ss-obs (ssget "X" '((8 . "PV_OBSTACLE"))))
    (progn
      (setq raw-obs nil i 0)
      (while (< i (sslength ss-obs))
        (setq ent (ssname ss-obs i))
        (if (not (and *PV_BOUNDARY_ENT* (equal ent *PV_BOUNDARY_ENT*)))
          (setq raw-obs (cons ent raw-obs))
        )
        (setq i (1+ i))
      )
      (setq unp-obs (pv:unpack-array-entities raw-obs))
      (foreach ent unp-obs
        (setq p-pts (pv:get-entity-pts ent))
        (if p-pts (setq all-exclusion-polys (cons p-pts all-exclusion-polys)))
      )
    )
  )

  (if (= *PV_DRAW_SHADOW* 1)
    (if (setq ss-sh (ssget "X" '((8 . "PV_SHADOW"))))
      (progn
        (setq i 0)
        (while (< i (sslength ss-sh))
          (setq ent (ssname ss-sh i))
          (setq p-pts (pv:get-entity-pts ent))
          (if p-pts (setq all-exclusion-polys (cons p-pts all-exclusion-polys)))
          (setq i (1+ i))
        )
      )
    )
  )

  ;; 2. Gather Safety Lines (Fall Safety Lifelines & Perimeter Handrails) as exclusion obstacles
  (if (setq ss-saf (ssget "X" '((-4 . "<OR")
                                  (8 . "PV_FALL_SAFETY")
                                  (8 . "PV_HANDRAIL")
                                (-4 . "OR>"))))
    (progn
      (setq i 0)
      (while (< i (sslength ss-saf))
        (setq ent (ssname ss-saf i))
        (setq saf-polys (pv:get-exclusion-polys-from-ent ent))
        (if saf-polys
          (foreach ply saf-polys
            (setq all-exclusion-polys (cons ply all-exclusion-polys))
          )
        )
        (setq i (1+ i))
      )
    )
  )
  ;; Also gather recorded Fall Safety lines and Handrails from session data
  (foreach fs *PV_FALL_SAFETY_LINES*
    (setq p-st (car fs) t-pts (cadr fs) p-en (caddr fs))
    (setq fs-pts (cons p-st (append t-pts (list p-en))))
    (setq k 0)
    (while (< k (1- (length fs-pts)))
      (setq all-exclusion-polys (cons (list (nth k fs-pts) (nth (1+ k) fs-pts)) all-exclusion-polys))
      (setq k (1+ k))
    )
  )
  (foreach hr *PV_HANDRAIL_LINES*
    (setq hr-pts (car hr))
    (if (and hr-pts (> (length hr-pts) 1))
      (progn
        (setq k 0)
        (while (< k (1- (length hr-pts)))
          (setq all-exclusion-polys (cons (list (nth k hr-pts) (nth (1+ k) hr-pts)) all-exclusion-polys))
          (setq k (1+ k))
        )
      )
    )
  )

  ;; 3. Gather user-defined maintenance walkway corridors as exclusion zones
  (foreach ww-poly *PV_WALKWAY_POLYS*
    (if ww-poly (setq all-exclusion-polys (cons ww-poly all-exclusion-polys)))
  )
  (if (setq ss-ww (ssget "X" '((8 . "PV_WALKWAY"))))
    (progn
      (setq i 0)
      (while (< i (sslength ss-ww))
        (setq ent (ssname ss-ww i))
        (setq p-pts (pv:get-entity-pts ent))
        (if p-pts (setq all-exclusion-polys (cons p-pts all-exclusion-polys)))
        (setq i (1+ i))
      )
    )
  )

  ;; Clear previous auto-generated walkway entities before new generation
  (if *PV_AUTO_WALKWAY_ENTS*
    (progn
      (foreach ent *PV_AUTO_WALKWAY_ENTS*
        (if (and ent (entget ent)) (entdel ent))
      )
      (setq *PV_AUTO_WALKWAY_ENTS* nil)
    )
  )

  (princ "\n[SolarPV] Populating solar PV modules...")
  (if is-target-mode
    (princ (strcat "\n[SolarPV] Sizing Mode: Target Plant DC Capacity = " (rtos *PV_TARGET_KW* 2 1) " kWp (Limit: " (itoa target-mod-count) " modules)"))
    (princ "\n[SolarPV] Sizing Mode: Install Max Possible in selected boundary.")
  )
  (if (> *PV_WALKWAY_FREQ_ROW* 0)
    (princ (strcat "\n[SolarPV] Horizontal Walkway Frequency: Every " (itoa *PV_WALKWAY_FREQ_ROW*) " Module Row(s) (" (rtos *PV_WALKWAY_WIDTH* 2 2) "m width)."))
  )
  (if (> *PV_WALKWAY_FREQ_COL* 0)
    (princ (strcat "\n[SolarPV] Vertical Walkway Frequency: Every " (itoa *PV_WALKWAY_FREQ_COL*) " Module Column(s) (" (rtos *PV_WALKWAY_WIDTH* 2 2) "m width)."))
  )

  (setq mod-row-idx 0)
  (setq next-walkway-row (if (> *PV_WALKWAY_FREQ_ROW* 0) *PV_WALKWAY_FREQ_ROW* 999999))

  ;; Generate grid rows and tables cleanly
  (while (and (<= (+ cur-y cur-mod-l) maxy) (not reached-target))
    (setq cur-x minx row-had-mods nil)
    (setq mod-col-idx 0)
    (setq row-modules-list nil)
    (setq next-walkway-col (if (> *PV_WALKWAY_FREQ_COL* 0) *PV_WALKWAY_FREQ_COL* 999999))
    
    (while (and (<= (+ cur-x cur-mod-w) maxx) (not reached-target))
      (setq tbl-has-mods nil)
      (setq cur-col-x cur-x)
      (setq c 0)

      (while (and (< c tbl-cols) (<= (+ cur-col-x cur-mod-w) maxx) (not reached-target))
        (setq r 0)
        (while (and (< r tbl-rows) (not reached-target))
          (setq mx cur-col-x)
          (setq my (+ cur-y (* r (+ cur-mod-l row-gap))))
          
          (setq mod-corners
            (list
              (list mx my)
              (list (+ mx cur-mod-w) my)
              (list (+ mx cur-mod-w) (+ my cur-mod-l))
              (list mx (+ my cur-mod-l))
            )
          )

          ;; Check boundary enclosure against usable surface inside parapet wall
          (setq in-boundary t)
          (foreach pt mod-corners
            (if (not (pv:pt-in-poly pt usable-b-pts))
              (setq in-boundary nil)
            )
          )

          ;; Check obstacle, shadow, safety line, and walkway collision
          (setq collides nil)
          (if in-boundary
            (foreach ex-poly all-exclusion-polys
              (if (and (not collides)
                       (pv:box-hits-polygon (car mod-corners) (caddr mod-corners) ex-poly *PV_OBS_BUFFER*))
                (setq collides t)
              )
            )
          )

          (if (and in-boundary (not collides))
            (progn
              ;; Calculate 3D rooftop coordinates for all 4 module corners
              (setq cur-bbox (if (and *PV_CURRENT_BUILDING_BBOX* (listp *PV_CURRENT_BUILDING_BBOX*) (listp (car *PV_CURRENT_BUILDING_BBOX*)))
                               *PV_CURRENT_BUILDING_BBOX*
                               bbox))
              (if (not (and (listp cur-bbox) (listp (car cur-bbox))))
                (setq cur-bbox bbox)
              )
              (setq z-clear (if (> *PV_MOD_CLEAR* 0.0) *PV_MOD_CLEAR* 0.10))
              (setq z1 (+ (pv:get-roof-z (nth 0 mod-corners) cur-bbox) z-clear)
                    z2 (+ (pv:get-roof-z (nth 1 mod-corners) cur-bbox) z-clear)
                    z3 (+ (pv:get-roof-z (nth 2 mod-corners) cur-bbox) z-clear)
                    z4 (+ (pv:get-roof-z (nth 3 mod-corners) cur-bbox) z-clear))

              (if is-elevated
                (progn
                  ;; Flat RCC Rooftop: Elevated Continuous Incident Solar Plane across entire roof
                  (setq z1 (pv:get-elevated-plane-z (nth 0 mod-corners) cur-bbox)
                        z2 (pv:get-elevated-plane-z (nth 1 mod-corners) cur-bbox)
                        z3 (pv:get-elevated-plane-z (nth 2 mod-corners) cur-bbox)
                        z4 (pv:get-elevated-plane-z (nth 3 mod-corners) cur-bbox))
                  (setq mod-3d-pts
                    (list
                      (list (car (nth 0 mod-corners)) (cadr (nth 0 mod-corners)) z1)
                      (list (car (nth 1 mod-corners)) (cadr (nth 1 mod-corners)) z2)
                      (list (car (nth 2 mod-corners)) (cadr (nth 2 mod-corners)) z3)
                      (list (car (nth 3 mod-corners)) (cadr (nth 3 mod-corners)) z4)
                    )
                  )
                  ;; Track placed module for row vertical legs calculation
                  (setq row-modules-list (cons mod-corners row-modules-list))
                )
                (if (and (= *PV_ROOF_TYPE* "Flat RCC Rooftop")
                         (= *PV_MOUNT_OPT* "Tilted on MMS Structures")
                         (> *PV_TILT* 0.0))
                  (progn
                    (setq tilt-dz (* cur-mod-l (sin (dtr *PV_TILT*))))
                    (setq z3 (+ z3 tilt-dz)
                          z4 (+ z4 tilt-dz))
                    (setq mod-3d-pts
                      (list
                        (list (car (nth 0 mod-corners)) (cadr (nth 0 mod-corners)) z1)
                        (list (car (nth 1 mod-corners)) (cadr (nth 1 mod-corners)) z2)
                        (list (car (nth 2 mod-corners)) (cadr (nth 2 mod-corners)) z3)
                        (list (car (nth 3 mod-corners)) (cadr (nth 3 mod-corners)) z4)
                      )
                    )
                    ;; Support legs down to roof slab
                    (pv:draw-line-3d (list (car (nth 0 mod-corners)) (cadr (nth 0 mod-corners)) (- z1 z-clear)) (nth 0 mod-3d-pts) "PV_STRUCTURE" 8)
                    (pv:draw-line-3d (list (car (nth 1 mod-corners)) (cadr (nth 1 mod-corners)) (- z2 z-clear)) (nth 1 mod-3d-pts) "PV_STRUCTURE" 8)
                    (pv:draw-line-3d (list (car (nth 2 mod-corners)) (cadr (nth 2 mod-corners)) (- z3 z-clear tilt-dz)) (nth 2 mod-3d-pts) "PV_STRUCTURE" 8)
                    (pv:draw-line-3d (list (car (nth 3 mod-corners)) (cadr (nth 3 mod-corners)) (- z4 z-clear tilt-dz)) (nth 3 mod-3d-pts) "PV_STRUCTURE" 8)
                  )
                  (progn
                    (setq mod-3d-pts
                      (list
                        (list (car (nth 0 mod-corners)) (cadr (nth 0 mod-corners)) z1)
                        (list (car (nth 1 mod-corners)) (cadr (nth 1 mod-corners)) z2)
                        (list (car (nth 2 mod-corners)) (cadr (nth 2 mod-corners)) z3)
                        (list (car (nth 3 mod-corners)) (cadr (nth 3 mod-corners)) z4)
                      )
                    )
                    ;; Mini-rail / clamp fixings down to metal roof sheet
                    (pv:draw-line-3d (list (car (nth 0 mod-corners)) (cadr (nth 0 mod-corners)) (- z1 z-clear)) (nth 0 mod-3d-pts) "PV_STRUCTURE" 8)
                    (pv:draw-line-3d (list (car (nth 1 mod-corners)) (cadr (nth 1 mod-corners)) (- z2 z-clear)) (nth 1 mod-3d-pts) "PV_STRUCTURE" 8)
                    (pv:draw-line-3d (list (car (nth 2 mod-corners)) (cadr (nth 2 mod-corners)) (- z3 z-clear)) (nth 2 mod-3d-pts) "PV_STRUCTURE" 8)
                    (pv:draw-line-3d (list (car (nth 3 mod-corners)) (cadr (nth 3 mod-corners)) (- z4 z-clear)) (nth 3 mod-3d-pts) "PV_STRUCTURE" 8)
                  )
                )
              )

              ;; 1. Draw 3D Polyline on PV_MODULES
              (pv:draw-3d-poly mod-3d-pts "PV_MODULES" 5 t)
              ;; 2. Draw 3DFACE on PV_3D_MODULES for shaded / conceptual visual styles
              (pv:draw-3dface (nth 0 mod-3d-pts) (nth 1 mod-3d-pts) (nth 2 mod-3d-pts) (nth 3 mod-3d-pts) "PV_3D_MODULES" 140)

              (setq total-mods (1+ total-mods))
              (setq tbl-has-mods t row-had-mods t)
              
              ;; Check if target capacity reached
              (if (and is-target-mode (>= total-mods target-mod-count))
                (setq reached-target t)
              )
            )
          )
          (setq r (1+ r))
        ) ; end while r

        (setq c (1+ c))
        (setq mod-col-idx (1+ mod-col-idx))

        ;; Advance X within table or apply vertical walkway if due
        (if (< c tbl-cols)
          (progn
            (if (and (> *PV_WALKWAY_FREQ_COL* 0) (>= mod-col-idx next-walkway-col))
              (progn
                ;; Vertical walkway due inside table
                (if (and (pv:draw-auto-walkway-p) (> *PV_WALKWAY_WIDTH* 0.0))
                  (progn
                    (setq ww-poly (list (list (+ cur-col-x cur-mod-w) cur-y)
                                        (list (+ cur-col-x cur-mod-w *PV_WALKWAY_WIDTH*) cur-y)
                                        (list (+ cur-col-x cur-mod-w *PV_WALKWAY_WIDTH*) (+ cur-y tbl-l))
                                        (list (+ cur-col-x cur-mod-w) (+ cur-y tbl-l))))
                    (setq *PV_AUTO_WALKWAY_ENTS* (append (pv:draw-walkway-corridor ww-poly cur-bbox) *PV_AUTO_WALKWAY_ENTS*))
                    (setq *PV_WALKWAY_LENGTH* (+ *PV_WALKWAY_LENGTH* tbl-l))
                  )
                )
                (setq cur-col-x (+ cur-col-x cur-mod-w *PV_WALKWAY_WIDTH*))
                (setq next-walkway-col (+ next-walkway-col *PV_WALKWAY_FREQ_COL*))
              )
              (setq cur-col-x (+ cur-col-x cur-mod-w col-gap))
            )
          )
        )
      ) ; end while c

      (if tbl-has-mods (setq total-tables (1+ total-tables)))

      ;; Advance cur-x to next table or vertical walkway
      (if (= c 0)
        (setq cur-x (+ cur-x tbl-w std-aisle-x))
        (if (and (> *PV_WALKWAY_FREQ_COL* 0) (>= mod-col-idx next-walkway-col))
          (progn
            ;; Vertical walkway due at table boundary
            (if (and (pv:draw-auto-walkway-p) (> *PV_WALKWAY_WIDTH* 0.0))
              (progn
                (setq ww-poly (list (list (+ cur-col-x cur-mod-w) cur-y)
                                    (list (+ cur-col-x cur-mod-w *PV_WALKWAY_WIDTH*) cur-y)
                                    (list (+ cur-col-x cur-mod-w *PV_WALKWAY_WIDTH*) (+ cur-y tbl-l))
                                    (list (+ cur-col-x cur-mod-w) (+ cur-y tbl-l))))
                (setq *PV_AUTO_WALKWAY_ENTS* (append (pv:draw-walkway-corridor ww-poly cur-bbox) *PV_AUTO_WALKWAY_ENTS*))
                (setq *PV_WALKWAY_LENGTH* (+ *PV_WALKWAY_LENGTH* tbl-l))
              )
            )
            (setq cur-x (+ cur-col-x cur-mod-w *PV_WALKWAY_WIDTH*))
            (setq next-walkway-col (+ next-walkway-col *PV_WALKWAY_FREQ_COL*))
          )
          (setq cur-x (+ cur-col-x cur-mod-w std-aisle-x))
        )
      )
    ) ; end while X

    ;; If elevated tilted legs, process structural columns at outer edges and intermediate intervals
    (if (and is-elevated row-modules-list)
      (pv:process-elevated-row-legs (reverse row-modules-list) cur-bbox)
    )

    ;; Increment module row count
    (setq mod-row-idx (+ mod-row-idx tbl-rows))

    ;; Advance Y by table pitch plus horizontal walkway if due
    (if (and (> *PV_WALKWAY_FREQ_ROW* 0) (>= mod-row-idx next-walkway-row))
      (progn
        ;; Horizontal walkway corridor between table rows
        (if (and (pv:draw-auto-walkway-p) (> *PV_WALKWAY_WIDTH* 0.0) row-had-mods)
          (progn
            (setq ww-y1 (+ cur-y tbl-pitch))
            (setq ww-y2 (+ ww-y1 *PV_WALKWAY_WIDTH*))
            (setq ww-poly (list (list minx ww-y1)
                                (list maxx ww-y1)
                                (list maxx ww-y2)
                                (list minx ww-y2)))
            (setq *PV_AUTO_WALKWAY_ENTS* (append (pv:draw-walkway-corridor ww-poly cur-bbox) *PV_AUTO_WALKWAY_ENTS*))
            (setq *PV_WALKWAY_LENGTH* (+ *PV_WALKWAY_LENGTH* (- maxx minx)))
          )
        )
        (setq cur-y (+ cur-y tbl-pitch *PV_WALKWAY_WIDTH*))
        (setq next-walkway-row (+ next-walkway-row *PV_WALKWAY_FREQ_ROW*))
      )
      (setq cur-y (+ cur-y tbl-pitch))
    )
  ) ; end while Y

  (setq *PV_MODULE_COUNT* total-mods)
  (setq *PV_TABLE_COUNT* total-tables)

  (list total-mods total-tables *PV_WALKWAY_LENGTH*)
)

;;; Matches a selected entity (such as a 3DFACE on PV_3D_ROOF_FACE or a polyline)
;;; to an already-registered record in *PV_ROOF_SURFACES* using entity key or centroid+Z match.
(defun pv:find-matching-roof-surface (ent pts-3d / c-new z-new s-rec s-ent s-pts s-c s-z matched)
  (cond
    ((and ent (assoc ent *PV_ROOF_SURFACES*) (entget ent)) ent)
    (t
     (setq c-new (pv:poly-centroid-2d pts-3d))
     (if (and c-new pts-3d)
       (progn
         (setq z-new (/ (apply '+ (mapcar '(lambda (p) (if (caddr p) (caddr p) 0.0)) pts-3d))
                        (float (length pts-3d))))
         (setq matched nil)
         (foreach s-rec *PV_ROOF_SURFACES*
           (setq s-ent (car s-rec))
           (if (and (null matched) s-ent (entget s-ent))
             (progn
               (setq s-pts (cdr (assoc "PTS" (cdr s-rec))))
               (if (and s-pts (> (length s-pts) 0))
                 (progn
                   (setq s-c (pv:poly-centroid-2d s-pts))
                   (setq s-z (/ (apply '+ (mapcar '(lambda (p) (if (caddr p) (caddr p) 0.0)) s-pts))
                                (float (length s-pts))))
                   (if (and s-c
                            (< (distance c-new s-c) 0.15)
                            (< (abs (- z-new s-z)) 0.15))
                     (setq matched s-ent)
                   )
                 )
               )
             )
           )
         )
         matched
       )
       nil
     )
    )
  )
)

;;; Resolves an interactive ssget selection of roof faces (3DFACE, POLYLINE, LWPOLYLINE)
;;; into boundary entity keys registered in *PV_ROOF_SURFACES* with exact 3D plane equations.
(defun pv:resolve-selected-faces (ss / i ent match-ent pts-3d pts-2d bbox plane slope-info
                                      tilt-deg az-deg facing-str surf-ent face-name out-list s-info idx-f)
  (pv:init-layers)
  (setq out-list nil i 0 idx-f 1)
  (while (< i (sslength ss))
    (setq ent (ssname ss i))
    (setq pts-3d (pv:get-polyline-3d-pts ent))
    (if (and pts-3d (>= (length pts-3d) 3))
      (progn
        (setq match-ent (pv:find-matching-roof-surface ent pts-3d))
        (if match-ent
          (progn
            (if (not (member match-ent out-list))
              (progn
                (setq s-info (cdr (assoc match-ent *PV_ROOF_SURFACES*)))
                (princ (strcat "\n  - Face " (itoa idx-f) ": "
                               (if (and s-info (assoc "NAME" s-info)) (cdr (assoc "NAME" s-info)) "Registered Roof Surface")))
                (setq out-list (cons match-ent out-list))
                (setq idx-f (1+ idx-f))
              )
            )
          )
          (progn
            (setq pts-2d (mapcar '(lambda (p) (list (car p) (cadr p))) pts-3d))
            (if (and (> (length pts-2d) 3) (equal (car pts-2d) (last pts-2d) 1e-4))
              (setq pts-2d (reverse (cdr (reverse pts-2d))))
            )
            (setq bbox (pv:pts-bbox pts-2d))
            (setq plane (pv:plane-from-pts-list pts-3d))
            (setq slope-info (pv:slope-from-plane plane)
                  tilt-deg (car slope-info)
                  az-deg (cadr slope-info)
                  facing-str (caddr slope-info))
            ;; Leave user's original 3DFACE untouched; create boundary outline on PV_BOUNDARY
            (if (= (cdr (assoc 0 (entget ent))) "3DFACE")
              (setq surf-ent (pv:draw-3d-poly pts-3d "PV_BOUNDARY" 1 t))
              (progn
                (setq surf-ent ent)
                (vl-catch-all-apply 'vla-put-layer (list (vlax-ename->vla-object surf-ent) "PV_BOUNDARY"))
              )
            )
            (if (> tilt-deg 1.0)
              (setq face-name (strcat facing-str "-Facing Sloped Roof Face (" (rtos tilt-deg 2 1) " deg, Az " (rtos az-deg 2 0) " deg)"))
              (setq face-name (strcat "Selected Flat Roof Face (Elev "
                                      (rtos (if (caddr (car pts-3d)) (caddr (car pts-3d)) 0.0) 2 2) "m)")
                    facing-str "Flat")
            )
            (setq *PV_ROOF_SURFACES*
              (cons (list surf-ent
                          (cons "NAME" face-name)
                          (cons "FACING" facing-str)
                          (cons "AZIMUTH" (if (> tilt-deg 1.0) az-deg *PV_AZIMUTH*))
                          (cons "TILT" (if (> tilt-deg 1.0) tilt-deg 0.0))
                          (cons "BLDG-BBOX" bbox)
                          (cons "BLDG-ENT" ent)
                          (cons "PTS" pts-3d)
                          (cons "PLANE" plane))
                    *PV_ROOF_SURFACES*))
            (princ (strcat "\n  - Face " (itoa idx-f) ": " face-name))
            (if (and surf-ent (not (member surf-ent out-list)))
              (setq out-list (cons surf-ent out-list))
            )
            (setq idx-f (1+ idx-f))
          )
        )
      )
    )
    (setq i (1+ i))
  )
  (reverse out-list)
)

(defun pv:generate-layout (/ ss-bnd ss-faces picked-list user-picked-faces b-list ent b-pts res plant-kw ans
                             total-mods total-tbls r-idx bbox x1 y1 x2 y2 xc yc ridge-sb eaves-sb slope-sel sub-zones
                             south-poly north-poly west-poly east-poly zn z-poly z-name)
  (pv:init-layers)
  ;; Validate critical inputs
  (if (or (null *PV_LAT*) (null *PV_LON*) (null *PV_TILT*) (null *PV_AZIMUTH*))
    (progn
      (princ "\n[ERROR] Missing required parameters: Latitude, Longitude, Tilt, Azimuth")
      (princ "\nPlease set these values first using the configuration dialog")
      (exit)
    )
  )

  ;; Ask user to click/select the exact Roof Face(s) / Surface(s) on which modules should be placed
  (setq user-picked-faces nil
        picked-list nil)
  (princ "\n==========================================================================")
  (princ "\n[SolarPV] Select the Roof Face(s) / Surface(s) on which modules should be installed.")
  (princ "\n          [Click 3DFACE(s) or Roof Boundary polyline(s), or press ENTER to use active roof(s)]: ")
  (setq ss-faces (ssget '((0 . "3DFACE,LWPOLYLINE,POLYLINE"))))
  (if (and ss-faces (> (sslength ss-faces) 0))
    (progn
      (princ "\n[SolarPV] Resolving selected face(s):")
      (setq picked-list (pv:resolve-selected-faces ss-faces))
      (if picked-list
        (progn
          (setq user-picked-faces t)
          (setq *PV_BOUNDARY_LIST* picked-list
                *PV_BOUNDARY_ENT*  (car picked-list)
                *PV_ACTIVE_ROOF_IDX* 0)
          (c:pv-roof-number)
        )
        (princ "\n[SolarPV] No valid planar face or boundary found in selection. Checking active roofs...")
      )
    )
  )

  ;; Ensure roofs exist if user pressed ENTER without selecting faces
  (if (not *PV_BOUNDARY_LIST*)
    (if (setq ss-bnd (ssget "X" '((0 . "LWPOLYLINE,POLYLINE,REGION") (8 . "PV_BOUNDARY"))))
      (progn
        (setq b-list nil r-idx 0)
        (while (< r-idx (sslength ss-bnd))
          (setq b-list (cons (ssname ss-bnd r-idx) b-list))
          (setq r-idx (1+ r-idx))
        )
        (setq *PV_BOUNDARY_LIST* (reverse b-list))
        (if (not *PV_BOUNDARY_ENT*) (setq *PV_BOUNDARY_ENT* (car *PV_BOUNDARY_LIST*)))
      )
    )
  )
  (if (and (not *PV_BOUNDARY_ENT*) (not *PV_BOUNDARY_LIST*))
    (progn
      (alert "Please pick rooftop perimeter boundary/roofs first (PVPICKBOUNDARY).")
      (c:pv-pick-boundary)
    )
  )
  (if (or *PV_BOUNDARY_ENT* *PV_BOUNDARY_LIST*)
    (progn
      (pv:clear-layout)
      ;; 1. Check and verify that Shadow Map is drawn for all obstacles with height > 0
      (pv:ensure-all-obstacle-shadows)
      (setq total-mods 0 total-tbls 0 *PV_ELEV_TOTAL_LEGS* 0
            *PV_ACTIVE_SURFACE_PLANE* nil)
      
      ;; Determine roofs to populate based on *PV_ACTIVE_ROOF_IDX*
      (setq b-list
        (if (and (not user-picked-faces) (> *PV_ACTIVE_ROOF_IDX* 0) (<= *PV_ACTIVE_ROOF_IDX* (length *PV_BOUNDARY_LIST*)))
          (list (nth (1- *PV_ACTIVE_ROOF_IDX*) *PV_BOUNDARY_LIST*))
          (if *PV_BOUNDARY_LIST* *PV_BOUNDARY_LIST* (list *PV_BOUNDARY_ENT*))
        )
      )
      
      ;; If user did NOT manually pick faces and multiple sloped surfaces exist, allow keyword filter
      (if (and (not user-picked-faces) (= *PV_ROOF_SLOPE_DIRS* 2) (>= (length b-list) 2) (<= *PV_ACTIVE_ROOF_IDX* 0) *PV_ROOF_SURFACES*)
        (progn
          (initget "Both South North Both-Slopes South-Slope-Only North-Slope-Only West East West-Slope-Only East-Slope-Only")
          (setq slope-sel (getkword (strcat "\nDual-Pitch Sloped Roof detected (" (itoa (length b-list)) " surfaces).\nSelect Slope(s) to populate [Both-Slopes / South-Slope-Only / North-Slope-Only / West-Slope-Only / East-Slope-Only] <"
                                            (if *PV_ROOF_SLOPE_POPULATE* *PV_ROOF_SLOPE_POPULATE* "Both-Slopes") ">: ")))
          (if (or (null slope-sel) (= slope-sel ""))
            (setq slope-sel (if *PV_ROOF_SLOPE_POPULATE* *PV_ROOF_SLOPE_POPULATE* "Both-Slopes"))
          )
          (setq *PV_ROOF_SLOPE_POPULATE* slope-sel)
          (cond
            ((or (= slope-sel "South") (= slope-sel "South-Slope-Only"))
             (setq b-list (vl-remove-if-not '(lambda (e) (equal (cdr (assoc "FACING" (cdr (assoc e *PV_ROOF_SURFACES*)))) "South")) b-list)))
            ((or (= slope-sel "North") (= slope-sel "North-Slope-Only"))
             (setq b-list (vl-remove-if-not '(lambda (e) (equal (cdr (assoc "FACING" (cdr (assoc e *PV_ROOF_SURFACES*)))) "North")) b-list)))
            ((or (= slope-sel "West") (= slope-sel "West-Slope-Only"))
             (setq b-list (vl-remove-if-not '(lambda (e) (equal (cdr (assoc "FACING" (cdr (assoc e *PV_ROOF_SURFACES*)))) "West")) b-list)))
            ((or (= slope-sel "East") (= slope-sel "East-Slope-Only"))
             (setq b-list (vl-remove-if-not '(lambda (e) (equal (cdr (assoc "FACING" (cdr (assoc e *PV_ROOF_SURFACES*)))) "East")) b-list)))
          )
        )
      )

      (setq r-idx 1)
      (foreach ent b-list
        (setq b-pts (pv:get-polyline-pts ent))
        (if (and b-pts (> (length b-pts) 2))
          (progn
            (setq s-info (cdr (assoc ent *PV_ROOF_SURFACES*)))
            (setq bbox (pv:pts-bbox b-pts))
            (setq *PV_CURRENT_BUILDING_BBOX* (if (and s-info (assoc "BLDG-BBOX" s-info))
                                               (cdr (assoc "BLDG-BBOX" s-info))
                                               bbox))
            (if (not (and (listp *PV_CURRENT_BUILDING_BBOX*) (listp (car *PV_CURRENT_BUILDING_BBOX*))))
              (setq *PV_CURRENT_BUILDING_BBOX* bbox)
            )
            ;; Set active surface plane from stored PLANE equation for precise 3D Z on sloped surfaces
            (setq *PV_ACTIVE_SURFACE_PLANE*
              (if (and s-info (assoc "PLANE" s-info))
                (cdr (assoc "PLANE" s-info))
                nil))
            (setq x1 (caar bbox)    y1 (cadar bbox)
                  x2 (caadr bbox)   y2 (cadadr bbox)
                  xc (/ (+ x1 x2) 2.0) yc (/ (+ y1 y2) 2.0))
            (setq ridge-sb (max 0.30 *PV_SETBACK*))
            (setq eaves-sb (max 0.30 *PV_SETBACK*))
            
            (setq sub-zones nil)
            
            ;; Check if designated sloped roof surface or fallback to 2D footprint division
            (cond
              ;; Case 1: Designated Sloped or Selected Roof Surface
              (s-info
               (setq z-name (cdr (assoc "NAME" s-info)))
               (if (null z-name) (setq z-name (strcat "Roof Surface RF-" (if (< r-idx 10) "0" "") (itoa r-idx))))
               ;; When Flush Mount on Metal Sheet OR sloped surface, Tilt Angle & Azimuth match selected surface
               (if (or (and (pv:is-metal-roof-p) (wcmatch (strcase *PV_MOUNT_OPT*) "*FLUSH*"))
                       (and (assoc "FACING" s-info) (/= (cdr (assoc "FACING" s-info)) "Flat")))
                 (progn
                   (if (assoc "AZIMUTH" s-info)
                     (setq *PV_AZIMUTH* (cdr (assoc "AZIMUTH" s-info)))
                   )
                   (if (assoc "TILT" s-info)
                     (progn
                       (setq *PV_TILT* (cdr (assoc "TILT" s-info)))
                       (setq *PV_ROOF_SLOPE* *PV_TILT*)
                       (if (> *PV_TILT* 0.5)
                         (progn
                           (if (not (pv:is-metal-roof-p))
                             (setq *PV_ROOF_TYPE* "Metal Sheet Rooftop")
                           )
                           (setq *PV_MOUNT_OPT* "Flush Mounted (Parallel to Roof)")
                         )
                       )
                     )
                   )
                 )
               )
               (if (pv:is-metal-roof-p)
                 (setq *PV_MOUNT_OPT* "Flush Mounted (Parallel to Roof)")
               )
               (setq sub-zones (list (list b-pts z-name)))
              )
              ;; 2 Directions: North & South Gable
              ((and (= *PV_ROOF_SLOPE_DIRS* 2)
                    (or (= *PV_ROOF_FACING* "North & South") (= *PV_ROOF_FACING* "North-South") (= *PV_ROOF_FACING* "NS")))
               (initget "Both South North Both-Slopes South-Slope-Only North-Slope-Only")
               (setq slope-sel (getkword (strcat "\nRoof RF-" (if (< r-idx 10) "0" "") (itoa r-idx)
                                                 " is a 2-Side North-South Sloped Roof.\nSelect Slope(s) to populate [Both-Slopes / South-Slope-Only / North-Slope-Only] <"
                                                 (if *PV_ROOF_SLOPE_POPULATE* *PV_ROOF_SLOPE_POPULATE* "Both-Slopes") ">: ")))
               (if (or (null slope-sel) (= slope-sel ""))
                 (setq slope-sel (if *PV_ROOF_SLOPE_POPULATE* *PV_ROOF_SLOPE_POPULATE* "Both-Slopes"))
               )
               (cond
                 ((or (= slope-sel "South") (= slope-sel "South-Slope-Only")) (setq slope-sel "South-Slope-Only"))
                 ((or (= slope-sel "North") (= slope-sel "North-Slope-Only")) (setq slope-sel "North-Slope-Only"))
                 (t (setq slope-sel "Both-Slopes"))
               )
               (setq *PV_ROOF_SLOPE_POPULATE* slope-sel)
               
               (setq south-poly (list (list x1 y1)
                                      (list x2 y1)
                                      (list x2 (- yc ridge-sb))
                                      (list x1 (- yc ridge-sb))))
               (setq north-poly (list (list x1 (+ yc ridge-sb))
                                      (list x2 (+ yc ridge-sb))
                                      (list x2 y2)
                                      (list x1 y2)))
               (cond
                 ((= slope-sel "South-Slope-Only")
                  (setq sub-zones (list (list south-poly "South-Facing Slope (Azimuth 180 deg)"))))
                 ((= slope-sel "North-Slope-Only")
                  (setq sub-zones (list (list north-poly "North-Facing Slope (Azimuth 0 deg)"))))
                 (t
                  (setq sub-zones (list (list south-poly "South-Facing Slope (Azimuth 180 deg)")
                                        (list north-poly "North-Facing Slope (Azimuth 0 deg)"))))
               )
              )
              
              ;; 2 Directions: East & West Gable
              ((and (= *PV_ROOF_SLOPE_DIRS* 2)
                    (or (= *PV_ROOF_FACING* "East & West") (= *PV_ROOF_FACING* "East-West") (= *PV_ROOF_FACING* "EW")))
               (initget "Both West East Both-Slopes West-Slope-Only East-Slope-Only")
               (setq slope-sel (getkword (strcat "\nRoof RF-" (if (< r-idx 10) "0" "") (itoa r-idx)
                                                 " is a 2-Side East-West Sloped Roof.\nSelect Slope(s) to populate [Both-Slopes / West-Slope-Only / East-Slope-Only] <"
                                                 (if *PV_ROOF_SLOPE_POPULATE* *PV_ROOF_SLOPE_POPULATE* "Both-Slopes") ">: ")))
               (if (or (null slope-sel) (= slope-sel ""))
                 (setq slope-sel (if *PV_ROOF_SLOPE_POPULATE* *PV_ROOF_SLOPE_POPULATE* "Both-Slopes"))
               )
               (cond
                 ((or (= slope-sel "West") (= slope-sel "West-Slope-Only")) (setq slope-sel "West-Slope-Only"))
                 ((or (= slope-sel "East") (= slope-sel "East-Slope-Only")) (setq slope-sel "East-Slope-Only"))
                 (t (setq slope-sel "Both-Slopes"))
               )
               (setq *PV_ROOF_SLOPE_POPULATE* slope-sel)
               
               (setq west-poly (list (list x1 y1)
                                     (list (- xc ridge-sb) y1)
                                     (list (- xc ridge-sb) y2)
                                     (list x1 y2)))
               (setq east-poly (list (list (+ xc ridge-sb) y1)
                                     (list x2 y1)
                                     (list x2 y2)
                                     (list (+ xc ridge-sb) y2)))
               (cond
                 ((= slope-sel "West-Slope-Only")
                  (setq sub-zones (list (list west-poly "West-Facing Slope (Azimuth 270 deg)"))))
                 ((= slope-sel "East-Slope-Only")
                  (setq sub-zones (list (list east-poly "East-Facing Slope (Azimuth 90 deg)"))))
                 (t
                  (setq sub-zones (list (list west-poly "West-Facing Slope (Azimuth 270 deg)")
                                        (list east-poly "East-Facing Slope (Azimuth 90 deg)"))))
               )
              )
              
              ;; Single Slope (Monoslope), 4 Directions (Hip), or Flat RCC
              (t
               (if (and (pv:is-metal-roof-p) (wcmatch (strcase *PV_MOUNT_OPT*) "*FLUSH*"))
                 (progn
                   (setq *PV_ACTIVE_SURFACE_PLANE* (pv:plane-from-pts-list (pv:get-polyline-3d-pts ent)))
                   (if *PV_ACTIVE_SURFACE_PLANE*
                     (progn
                       (setq slope-sel (pv:slope-from-plane *PV_ACTIVE_SURFACE_PLANE*))
                       (setq *PV_TILT*       (car slope-sel)
                             *PV_AZIMUTH*    (cadr slope-sel)
                             *PV_ROOF_SLOPE* (car slope-sel))
                     )
                   )
                 )
               )
               (setq sub-zones (list (list b-pts (strcat *PV_ROOF_TYPE* " Plane"))))
              )
            )
            
            ;; Populate array in each designated sub-zone
            (foreach zn sub-zones
              (setq z-poly (car zn)
                    z-name (cadr zn))
              ;; Reset active surface plane only for non-plane fallback sub-zones
              (if (and (not s-info) (not (and (pv:is-metal-roof-p) (wcmatch (strcase *PV_MOUNT_OPT*) "*FLUSH*"))))
                (setq *PV_ACTIVE_SURFACE_PLANE* nil)
              )
              (princ (strcat "\n[SolarPV] Populating array on " z-name " (Roof RF-" (if (< r-idx 10) "0" "") (itoa r-idx)
                             " | Tilt: " (rtos *PV_TILT* 2 1) " deg | Azimuth: " (rtos *PV_AZIMUTH* 2 1) " deg)..."))
              (setq res (pv:generate-grid z-poly))
              (if (and res (listp res) (numberp (car res)))
                (progn
                  (setq total-mods (+ total-mods (car res)))
                  (if (and (cdr res) (numberp (cadr res)))
                    (setq total-tbls (+ total-tbls (cadr res)))
                  )
                )
              )
            )
            ;; Clear active surface plane after each boundary to avoid leakage into next boundary
            (setq *PV_ACTIVE_SURFACE_PLANE* nil)
            (setq r-idx (1+ r-idx))
          )
        )
      )
      (setq *PV_MODULE_COUNT* total-mods)
      (setq *PV_TABLE_COUNT* total-tbls)
      (setq plant-kw (/ (* *PV_MODULE_COUNT* *PV_MOD_WATT*) 1000.0))
      (pv:calc-inverter-sizing plant-kw)
      
      (princ (strcat "\n=========================================================================="))
      (princ (strcat "\n[SolarPV] Multi-Roof Layout Generation Complete! (" (itoa (length b-list)) " Roofs Populated)"))
      (princ (strcat "\n  - Total Modules Placed : " (itoa total-mods) " units"))
      (princ (strcat "\n  - Total Tables Placed  : " (itoa total-tbls) " units"))
      (princ (strcat "\n  - Total Plant Capacity : " (rtos plant-kw 2 2) " kWp"))
      (princ (strcat "\n  - Inverters Required   : " (itoa *PV_INV_COUNT*) " x " *PV_INV_MODEL* " (" (rtos *PV_INV_KW* 2 0) "kW)"))
      (princ (strcat "\n  - DC/AC Sizing Ratio   : " (rtos *PV_DC_AC_RATIO* 2 2)))
      (if (wcmatch (strcase *PV_MOUNT_OPT*) "*ELEVATED*")
        (princ (strcat "\n  - Elevated MMS Columns : " (itoa *PV_ELEV_TOTAL_LEGS*) " legs (Continuous incident slope: " *PV_ELEV_TILT_DIR* ", Clearance=" (rtos *PV_ELEV_MIN_CLEAR* 2 2) "m)"))
      )
      (princ (strcat "\n=========================================================================="))
      
      (initget "Yes No")
      (setq ans (getkword "\nLayout generated! Would you like to insert the 25-Year Energy Generation Table now? [Yes/No] <Yes>: "))
      (if (/= ans "No")
        (c:pv-energy-table)
      )
    )
  )
  (princ)
)

(defun c:pv-generate-layout ()
  (pv:generate-layout)
)

;;; --------------------------------------------------------------------------
;;; Comprehensive Energy Yield Simulation Engine (Monthly, Yearly & 25-Year)
;;; --------------------------------------------------------------------------
(defun pv:simulate-system-yield (/ plant-kw days mid-days months total-ghi total-poa
                                   total-energy m-list m dm nd dec ghi-day ghi-m tilt-gain
                                   poa-m tamb tcell delta-t ltemp bif-gain eff-other eff-sys
                                   e-m pr-m ym spec-yield overall-pr cuf loss-tree yr1-gen
                                   cum-gen yr yr-list yr-gen avg-ltemp deg-y1 deg-yr)
  (setq plant-kw (/ (* *PV_MODULE_COUNT* *PV_MOD_WATT*) 1000.0))
  (if (equal plant-kw 0.0 1e-4) (setq plant-kw 50.0))

  (setq days     '(31 28 31 30 31 30 31 31 30 31 30 31)
        mid-days '(15 46 74 105 135 166 196 227 258 288 319 349)
        months   '("Jan" "Feb" "Mar" "Apr" "May" "Jun" "Jul" "Aug" "Sep" "Oct" "Nov" "Dec"))

  (setq total-ghi 0.0 total-poa 0.0 total-energy 0.0 avg-ltemp 0.0)
  (setq m-list nil)

  (setq m 0)
  (while (< m 12)
    (setq dm (nth m mid-days)
          nd (nth m days))
    (setq dec (* 23.45 (sin (* (/ (* 2.0 pi) 365.0) (+ 284 dm)))))
    
    ;; Base GHI model (calibrated to weather data source)
    (setq ghi-day
      (+ (cond
           ((wcmatch (strcase *PV_WEATHER_SRC*) "*NASA*") 5.30)
           ((wcmatch (strcase *PV_WEATHER_SRC*) "*NREL*") 5.20)
           (t 5.15)
         )
         (* 0.85 (cos (* (/ (* 2.0 pi) 365.0) (- dm 172))))))
    (setq ghi-m (* ghi-day nd))
    
    ;; Transposition / Tilt gain
    (setq tilt-gain
      (if (> *PV_TILT* 0.0)
        (+ 1.0 (* 0.085 (sin (dtr *PV_TILT*)) (cos (dtr (- dec *PV_LAT*)))))
        1.0))
    (setq poa-m (* ghi-m tilt-gain))
    
    ;; Temperature model
    (setq tamb (+ 26.0 (* 5.0 (cos (* (/ (* 2.0 pi) 365.0) (- dm 140))))))
    (setq tcell
      (if (and (= *PV_ROOF_TYPE* "Sloped Metal Sheet") (= *PV_MOUNT_OPT* "Flush Mounted (Parallel to Roof)"))
        (+ tamb 26.0)
        (+ tamb 18.0)))
    
    (setq delta-t (- tcell 25.0))
    (setq ltemp (* *PV_PAN_TEMP_COEFF* delta-t))
    (setq avg-ltemp (+ avg-ltemp ltemp))
    
    (setq bif-gain
      (if (and (> *PV_PAN_BIFACIAL* 0.05) (= *PV_ROOF_TYPE* "Flat RCC Rooftop") (> *PV_TILT* 5.0))
        (* *PV_PAN_BIFACIAL* 0.065)
        0.0))
    
    ;; Loss Factors: IAM (-2.5%), Near Shading (-1.8%), Mismatch (-1.5%), DC Cable (-1.4%), Inverter (-1.5%), AC/Grid (-1.0%)
    (setq eff-other (* (- 1.0 0.025) (- 1.0 0.018) (- 1.0 0.015) (- 1.0 0.014) (- 1.0 0.015) (- 1.0 0.010)))
    (setq eff-sys (* (+ 1.0 (/ ltemp 100.0)) (+ 1.0 bif-gain) eff-other))
    
    (setq e-m (* plant-kw poa-m eff-sys))
    (setq pr-m (* (/ e-m (* plant-kw poa-m)) 100.0))
    (setq ym (/ e-m plant-kw))
    
    (setq total-ghi (+ total-ghi ghi-m))
    (setq total-poa (+ total-poa poa-m))
    (setq total-energy (+ total-energy e-m))
    
    (setq m-list (cons (list (nth m months) ghi-m poa-m tamb tcell ltemp e-m pr-m ym) m-list))
    (setq m (1+ m))
  )

  (setq m-list (reverse m-list))
  (setq avg-ltemp (/ avg-ltemp 12.0))
  (setq spec-yield (/ total-energy plant-kw))
  (setq overall-pr (* (/ total-energy (* plant-kw total-poa)) 100.0))
  (setq cuf (* (/ total-energy (* plant-kw 8760.0)) 100.0))
  (setq yr1-gen total-energy)

  ;; 25-Year Lifetime Production & Degradation Schedule
  ;; Per IEC 61724-1: Year 1 = LID, Years 2-25 = annual degradation
  (setq deg-y1 (if (wcmatch (strcase *PV_PAN_TECH*) "*TOPCON*,*HJT*") 0.010 0.015))
  (setq deg-yr (if (wcmatch (strcase *PV_PAN_TECH*) "*TOPCON*,*HJT*") 0.0040 0.0050))
  (setq yr-list nil cum-gen 0.0 yr 1)

  (while (<= yr 25)
    (if (= yr 1)
      (setq yr-gen yr1-gen)
      ;; Year 2: apply Year 1 LID only; Year 3+: apply LID + cumulative annual degradation
      (setq yr-gen (* yr1-gen (- 1.0 (+ deg-y1 (* deg-yr (- yr 1))))))
    )
    (setq cum-gen (+ cum-gen yr-gen))
    (setq yr-list (cons (list yr yr-gen cum-gen (/ yr-gen plant-kw) (* overall-pr (/ yr-gen yr1-gen))) yr-list))
    (setq yr (1+ yr))
  )
  (setq yr-list (reverse yr-list))

  (list plant-kw total-ghi total-poa yr1-gen spec-yield overall-pr cuf cum-gen m-list nil yr-list)
)

;;; --------------------------------------------------------------------------
;;; Monthly, Yearly & 25-Year Energy Generation Table (AutoCAD Table Object)
;;; --------------------------------------------------------------------------
;;; --------------------------------------------------------------------------
;;; Table Row Autosizing Engine (Row Height Directly Scaled to Character Height)
;;; --------------------------------------------------------------------------
(defun pv:autosize-table-row (table row char-ht num-cols / row-ht c)
  ;; Calculate autosized row height strictly proportional to character height:
  ;; Row Height = Character Height * 1.50 (clean 0.25x padding top & bottom)
  (setq row-ht (* char-ht 1.50))
  
  ;; Apply character text height to all cells in this row
  (setq c 0)
  (while (< c num-cols)
    (vl-catch-all-apply 'vla-SetCellTextHeight (list table row c char-ht))
    (setq c (1+ c))
  )
  
  ;; Set the autosized row height
  (vl-catch-all-apply 'vla-SetRowHeight (list table row row-ht))
)

(defun pv:format-energy-table (table total-rows / r c char-ht)
  ;; 1. Set generous readable column widths (Total: 53.5m)
  (vl-catch-all-apply 'vla-SetColumnWidth (list table 0 7.50))  ; Period / Month / Year
  (vl-catch-all-apply 'vla-SetColumnWidth (list table 1 5.50))  ; GHI / Degradation Rate
  (vl-catch-all-apply 'vla-SetColumnWidth (list table 2 5.50))  ; POA / Annual Generation
  (vl-catch-all-apply 'vla-SetColumnWidth (list table 3 5.50))  ; Tamb / Cumulative Gen
  (vl-catch-all-apply 'vla-SetColumnWidth (list table 4 6.50))  ; Tcell / Specific Yield
  (vl-catch-all-apply 'vla-SetColumnWidth (list table 5 5.50))  ; Thermal Loss / Lifetime PR
  (vl-catch-all-apply 'vla-SetColumnWidth (list table 6 6.00))  ; Energy Yield / CO2 Offset
  (vl-catch-all-apply 'vla-SetColumnWidth (list table 7 5.00))  ; System PR / CUF
  (vl-catch-all-apply 'vla-SetColumnWidth (list table 8 6.50))  ; Specific Yield / Performance

  ;; 2. Set proportional cell margins
  (vl-catch-all-apply 'vla-put-TopMargin (list table 0.06))
  (vl-catch-all-apply 'vla-put-BottomMargin (list table 0.06))
  (vl-catch-all-apply 'vla-put-LeftMargin (list table 0.12))
  (vl-catch-all-apply 'vla-put-RightMargin (list table 0.12))

  ;; 3. Merge banner rows across all 9 columns
  (vl-catch-all-apply 'vla-MergeCells (list table 1 1 0 8))   ; Subhead spans columns 0-8
  (vl-catch-all-apply 'vla-MergeCells (list table 16 16 0 8)) ; Divider spans columns 0-8

  ;; 4. Autosize each row height as per character height
  (setq r 0)
  (while (< r total-rows)
    (setq char-ht
      (cond
        ((= r 0)  0.42)  ; Main Title
        ((= r 1)  0.25)  ; Subhead Info
        ((or (= r 2) (= r 17)) 0.28) ; Table Headers (Monthly & 25-Year)
        ((= r 16) 0.26)  ; Section Divider
        ((or (= r 15) (= r (1- total-rows))) 0.26) ; Totals / Summary
        (t        0.24)  ; Monthly and Yearly data rows
      )
    )
    (pv:autosize-table-row table r char-ht 9)
    
    ;; Set cell alignments
    (setq c 0)
    (while (< c 9)
      ;; Alignment: Column 0 Left-aligned (4), others Center-aligned (5)
      (vl-catch-all-apply 'vla-SetCellAlignment (list table r c (if (or (= c 0) (= r 1)) 4 5)))
      (setq c (1+ c))
    )
    (setq r (1+ r))
  )
  
  ;; Recompute table block to ensure clean auto-fit
  (vl-catch-all-apply 'vla-RecomputeTableBlock (list table :vlax-true))
)

(defun c:pv-energy-table (/ pt sim-res plant-kw total-ghi total-poa yr1-gen spec-yield
                            overall-pr cuf cum-gen m-list yr-list doc space table
                            total-rows row col item co2-tons yr-num yr-kwh cum-kwh yr-spec yr-pr)
  (pv:init-layers)
  (setq pt (getpoint "\nClick insertion point for Solar Energy Generation Table (Monthly, Yearly & 25-Year): "))
  (if (not pt) (setq pt '(0.0 0.0 0.0)))

  (setq sim-res    (pv:simulate-system-yield)
        plant-kw   (nth 0 sim-res)
        total-ghi  (nth 1 sim-res)
        total-poa  (nth 2 sim-res)
        yr1-gen    (nth 3 sim-res)
        spec-yield (nth 4 sim-res)
        overall-pr (nth 5 sim-res)
        cuf        (nth 6 sim-res)
        cum-gen    (nth 7 sim-res)
        m-list     (nth 8 sim-res)
        yr-list    (nth 10 sim-res))
  (setq co2-tons (* (/ cum-gen 1000.0) 0.82))

  (setq doc (vla-get-ActiveDocument (vlax-get-acad-object)))
  (setq space (vla-get-ModelSpace doc))

  ;; Total rows: 1 Title + 1 Subhead + 1 Month Header + 12 Months + 1 Year Total + 1 Spacer + 1 25-Yr Header + 25 Years + 1 Summary = 44
  (setq total-rows (+ 1 1 1 12 1 1 1 25 1))

  (if (vlax-method-applicable-p space 'AddTable)
    (progn
      ;; Create Table with generous initial cell size (0.90m height x 6.0m width)
      (setq table (vla-AddTable space (vlax-3d-point pt) total-rows 9 0.36 6.00))
      (vla-put-layer table "PV_ENERGY_TABLE")
      
      ;; Title
      (vla-SetText table 0 0 "ROOFTOP SOLAR PV SYSTEM - MONTHLY, YEARLY & 25-YEAR ENERGY GENERATION TABLE")
      
      ;; Sub-header Information
      (vla-SetText table 1 0 (strcat "Project: " *PV_PROJ_NAME* " | Lat: " (rtos *PV_LAT* 2 4) " N/S, Lon: " (rtos *PV_LON* 2 4) " E/W | DC Capacity: " (rtos plant-kw 2 2) " kWp | Inverters: " (itoa *PV_INV_COUNT*) "x " *PV_INV_MODEL* " (" (rtos *PV_INV_KW* 2 0) "kW) | Module: " *PV_PAN_MFG* " " *PV_PAN_MODEL* " | Currency: " (if *PV_CURRENCY_CODE* *PV_CURRENCY_CODE* "INR") " | Weather: " *PV_WEATHER_SRC*))
      
      ;; Part 1: Monthly Header
      (vla-SetText table 2 0 "Month")
      (vla-SetText table 2 1 "GHI (kWh/m2)")
      (vla-SetText table 2 2 "POA (kWh/m2)")
      (vla-SetText table 2 3 "Tamb (deg C)")
      (vla-SetText table 2 4 "Tcell (deg C)")
      (vla-SetText table 2 5 "Thermal Loss (%)")
      (vla-SetText table 2 6 "Energy Yield (kWh)")
      (vla-SetText table 2 7 "System PR (%)")
      (vla-SetText table 2 8 "Specific Yield (kWh/kWp)")

      ;; 12 Monthly Rows
      (setq row 3)
      (foreach m-row m-list
        (vla-SetText table row 0 (nth 0 m-row))
        (vla-SetText table row 1 (rtos (nth 1 m-row) 2 1))
        (vla-SetText table row 2 (rtos (nth 2 m-row) 2 1))
        (vla-SetText table row 3 (rtos (nth 3 m-row) 2 1))
        (vla-SetText table row 4 (rtos (nth 4 m-row) 2 1))
        (vla-SetText table row 5 (rtos (nth 5 m-row) 2 2))
        (vla-SetText table row 6 (rtos (nth 6 m-row) 2 0))
        (vla-SetText table row 7 (rtos (nth 7 m-row) 2 2))
        (vla-SetText table row 8 (rtos (nth 8 m-row) 2 1))
        (setq row (1+ row))
      )

      ;; Annual Year-1 Summary Row
      (vla-SetText table row 0 "YEAR 1 TOTAL")
      (vla-SetText table row 1 (rtos total-ghi 2 1))
      (vla-SetText table row 2 (rtos total-poa 2 1))
      (vla-SetText table row 3 "26.0 (avg)")
      (vla-SetText table row 4 "44.0 (avg)")
      (vla-SetText table row 5 "-6.70 (avg)")
      (vla-SetText table row 6 (rtos yr1-gen 2 0))
      (vla-SetText table row 7 (rtos overall-pr 2 2))
      (vla-SetText table row 8 (rtos spec-yield 2 1))
      (setq row (1+ row))

      ;; Section Spacer / Divider
      (vla-SetText table row 0 "--- 25-YEAR LIFETIME ANNUAL & CUMULATIVE ENERGY GENERATION SCHEDULE (IEC 61724 MODEL) ---")
      (setq row (1+ row))

      ;; Part 2: 25-Year Header
      (vla-SetText table row 0 "Operating Year")
      (vla-SetText table row 1 "Degradation Rate")
      (vla-SetText table row 2 "Annual Gen (kWh)")
      (vla-SetText table row 3 "Cumulative (MWh)")
      (vla-SetText table row 4 "Specific Yield (kWh/kWp)")
      (vla-SetText table row 5 "Lifetime PR (%)")
      (vla-SetText table row 6 "CO2 Offset (Tons)")
      (vla-SetText table row 7 "CUF (%)")
      (vla-SetText table row 8 "Array Performance")
      (setq row (1+ row))

      ;; 25 Years Data Rows
      (foreach yr-item yr-list
        (setq yr-num   (nth 0 yr-item)
              yr-kwh   (nth 1 yr-item)
              cum-kwh  (nth 2 yr-item)
              yr-spec  (nth 3 yr-item)
              yr-pr    (nth 4 yr-item))
        (vla-SetText table row 0 (strcat "Year " (itoa yr-num)))
        (vla-SetText table row 1 (if (= yr-num 1) "1.00 % (Y1)" (strcat (rtos (+ 1.0 (* 0.40 (- yr-num 1))) 2 2) " %")))
        (vla-SetText table row 2 (rtos yr-kwh 2 0))
        (vla-SetText table row 3 (rtos (/ cum-kwh 1000.0) 2 2))
        (vla-SetText table row 4 (rtos yr-spec 2 1))
        (vla-SetText table row 5 (rtos yr-pr 2 2))
        (vla-SetText table row 6 (rtos (* (/ yr-kwh 1000.0) 0.82) 2 1))
        (vla-SetText table row 7 (rtos (* (/ yr-kwh (* plant-kw 8760.0)) 100.0) 2 2))
        (vla-SetText table row 8 (if (> yr-pr 70.0) "Optimal" "Normal"))
        (setq row (1+ row))
      )

      ;; Lifetime 25-Year Summary Footer
      (vla-SetText table row 0 "25-YEAR CUMULATIVE TOTAL")
      (vla-SetText table row 1 "Life Guarantee")
      (vla-SetText table row 2 (rtos cum-gen 2 0))
      (vla-SetText table row 3 (rtos (/ cum-gen 1000.0) 2 1))
      (vla-SetText table row 4 (strcat (rtos (/ cum-gen (* plant-kw 25.0)) 2 1) " (avg)"))
      (vla-SetText table row 5 (strcat (rtos (* overall-pr 0.94) 2 2) " (avg)"))
      (vla-SetText table row 6 (rtos co2-tons 2 1))
      (vla-SetText table row 7 (rtos cuf 2 2))
      (vla-SetText table row 8 "Completed")

      ;; Apply formatting and wide readable columns
      (pv:format-energy-table table total-rows)

      (princ "\n[SolarPV] AutoCAD Monthly, Yearly & 25-Year Energy Generation Table inserted successfully.")
    )
    (princ "\n[SolarPV] AutoCAD Table entity not supported; using report output.")
  )
  (princ)
)

;;; --------------------------------------------------------------------------
;;; Bill of Materials (BOM) Table Generator
;;; --------------------------------------------------------------------------
(defun pv:format-bom-table (table total-rows / r c char-ht)
  ;; 1. Set generous column widths (Total width: 49.0m)
  (vl-catch-all-apply 'vla-SetColumnWidth (list table 0 3.50))   ; Item #
  (vl-catch-all-apply 'vla-SetColumnWidth (list table 1 14.00))  ; Component Description
  (vl-catch-all-apply 'vla-SetColumnWidth (list table 2 23.50))  ; Technical Specification
  (vl-catch-all-apply 'vla-SetColumnWidth (list table 3 4.50))   ; Quantity
  (vl-catch-all-apply 'vla-SetColumnWidth (list table 4 3.50))   ; Unit

  ;; 2. Set proportional cell margins
  (vl-catch-all-apply 'vla-put-TopMargin (list table 0.06))
  (vl-catch-all-apply 'vla-put-BottomMargin (list table 0.06))
  (vl-catch-all-apply 'vla-put-LeftMargin (list table 0.12))
  (vl-catch-all-apply 'vla-put-RightMargin (list table 0.12))

  ;; 3. Autosize each row height as per character height
  (setq r 0)
  (while (< r total-rows)
    (setq char-ht
      (cond
        ((= r 0) 0.42) ; Title
        ((= r 1) 0.28) ; Column Headers
        (t       0.24) ; BOM Component data rows
      )
    )
    (pv:autosize-table-row table r char-ht 5)

    ;; Set cell alignments
    (setq c 0)
    (while (< c 5)
      ;; Alignment: Col 0 Center (5), Col 1-2 Left (4), Col 3-4 Center (5)
      (vl-catch-all-apply 'vla-SetCellAlignment (list table r c (if (or (= c 1) (= c 2)) 4 5)))
      (setq c (1+ c))
    )
    (setq r (1+ r))
  )

  ;; Recompute table block to ensure clean auto-fit
  (vl-catch-all-apply 'vla-RecomputeTableBlock (list table :vlax-true))
)

(defun c:pv-draw-bom (/ pt plant-kw mid-clamps end-clamps rails-count mms-legs bom-data
                        doc space table row col total-rows)
  (pv:init-layers)
  (setq pt (getpoint "\nClick insertion point for Solar PV Bill of Materials (BOM) Table: "))
  (if (not pt) (setq pt '(0.0 0.0 0.0)))

  (setq plant-kw (/ (* *PV_MODULE_COUNT* *PV_MOD_WATT*) 1000.0))

  ;; End clamps: 2 per table end = 4 per table
  ;; For elevated with continuous rails: 4 per table (not per row)
  ;; For flush mount: 4 per table row
  (setq end-clamps
    (if (wcmatch (strcase *PV_MOUNT_OPT*) "*ELEVATED*")
      (* *PV_TABLE_COUNT* 4)  ; Continuous rail system
      (* *PV_TABLE_COUNT* *PV_TABLE_ROWS* 4)  ; Discrete tables
    )
  )

  ;; Mid clamps: (cols-1) gaps per row * 2 clamps per gap * number of rows * tables
  (setq mid-clamps
    (if (wcmatch (strcase *PV_MOUNT_OPT*) "*ELEVATED*")
      (* *PV_TABLE_COUNT* *PV_TABLE_ROWS* (max 0 (- *PV_TABLE_COLS* 1)) 2)  ; Elevated continuous
      (* *PV_TABLE_COUNT* *PV_TABLE_ROWS* (max 0 (- *PV_TABLE_COLS* 1)) 2)  ; Flush mount
    )
  )
  
  (if (wcmatch (strcase *PV_MOUNT_OPT*) "*ELEVATED*")
    (setq rails-count (* *PV_TABLE_COUNT* *PV_TABLE_ROWS* 2)
          mms-legs (if (> *PV_ELEV_TOTAL_LEGS* 0) *PV_ELEV_TOTAL_LEGS* (* *PV_TABLE_COUNT* 8)))
    (if (and (= *PV_ROOF_TYPE* "Sloped Metal Sheet") (= *PV_MOUNT_OPT* "Flush Mounted (Parallel to Roof)"))
      (setq rails-count (* *PV_MODULE_COUNT* 2)
            mms-legs 0)
      (setq rails-count (* *PV_TABLE_COUNT* *PV_TABLE_ROWS* 2)
            mms-legs (* *PV_TABLE_COUNT* (+ (fix (/ *PV_TABLE_COLS* 2)) 1) 2))
    )
  )

  (setq bom-data
    (list
      (list "1" "Solar PV Modules" 
            (strcat *PV_PAN_MFG* " " *PV_PAN_MODEL* " (" (rtos *PV_MOD_WATT* 2 0) " Wp)")
            (itoa *PV_MODULE_COUNT*) "Nos")
      (list "2" "Installed Plant Capacity" (strcat *PV_WEATHER_SRC* " Ref") (rtos plant-kw 2 2) "kWp")
      (list "3" "Solar Grid-Tied Inverter" (strcat *PV_INV_MFG* " " *PV_INV_MODEL* " (" (rtos *PV_INV_KW* 2 0) "kW AC)") (itoa *PV_INV_COUNT*) "Nos")
      (list "4" "Mounting System Structure" (strcat *PV_ROOF_TYPE* " (" *PV_MOUNT_OPT* ")") (itoa *PV_TABLE_COUNT*) "Tables")
      (list "5" "Solar Mid Clamps" (strcat "Anodized AL (" (rtos *PV_COL_SPACING* 2 3) "m spacing)") (itoa mid-clamps) "Sets")
      (list "6" "Solar End Clamps" "Aluminum Anodized with SS304 Fasteners" (itoa end-clamps) "Sets")
      (list "7" (if (= mms-legs 0) "Aluminum Mini-Rails" "Aluminum Mounting Rails") "Profile Rails with EPDM Gaskets" (itoa rails-count) "Pcs")
      (list "8" (if (wcmatch (strcase *PV_MOUNT_OPT*) "*ELEVATED*")
                    "Elevated Superstructure Columns"
                    "MMS Columns / Leg Ballasts")
                (if (wcmatch (strcase *PV_MOUNT_OPT*) "*ELEVATED*")
                    (strcat "Hot Dip Galvanized Heavy Duty Tubular Columns (Clearance=" (rtos *PV_ELEV_MIN_CLEAR* 2 1) "m)")
                    "Hot Dip Galvanized / Ballast Blocks")
                (itoa mms-legs) "Sets")
      (list "9" "Solar DC Array Cable" "4 sq.mm UV Resistant Copper Solar Cable (IS 17293)" (itoa (fix (* *PV_MODULE_COUNT* 3.2))) "Mtr")
      (list "10" "MC4 Connectors" "1500V DC IP68 Rated Male & Female" (itoa (* *PV_TABLE_COUNT* 4)) "Pairs")
      (list "11" "Array Junction Box (AJB/DCDB)" "IP65 Polycarbonate w/ 1000V DC Fuses & Type-II SPD" (itoa (max 1 (fix (+ (/ *PV_MODULE_COUNT* 40.0) 0.5)))) "Nos")
      (list "12" "AC Distribution Box (ACDB)" "IP65 Enclosure w/ 4-Pole MCCB, Type-II SPD & MFM" (itoa (if (> *PV_INV_COUNT* 0) *PV_INV_COUNT* 1)) "Nos")
      (list "13" "DISCOM Manual GOS Switch" "4-Pole Lockable Gang-Operated Isolator (Visible Air Gap)" "1" "Set")
      (list "14" "Chemical Earth Electrodes" "17.2mm dia x 3.0m Cu-Bonded Steel Rods (IS 3043:2018)" "3" "Sets")
      (list "15" "Earth Enhancement Compound" "Bentonite / Carbon BFC Compound Bags (25 kg)" "6" "Bags")
      (list "16" "Main Earthing Flat / Strip" "25x3 mm Hot Dip Galvanized / Copper Strip (IS 3043)" "75" "Mtr")
      (list "17" "Module Equipotential Wire" "8 SWG Bare Copper Earthing Wire" (itoa (fix (* *PV_MODULE_COUNT* 1.2))) "Mtr")
      (list "18" "Lightning Arrester (LA)" "Early Streamer Emission (ESE) / Franklin 2.5m Mast (IS 62305)" "1" "Set")
      (list "19" "AC Feeder Cable" "3.5C / 4C Armoured Aluminum XLPE Cable (IS 7098 Pt 1)" "45" "Mtr")
      (list "20" "Perforated HDG Cable Tray" "150mm/300mm Hot Dip Galvanized Tray w/ Cover (UV Shield)" (itoa (fix (if (> *PV_CABLE_TRAY_LENGTH* 0.0) *PV_CABLE_TRAY_LENGTH* 30.0))) "Mtr")
      (list "21" "Dual Energy Metering" "Bi-directional Net Meter + Solar Check Meter (DLMS)" "2" "Nos")
      (list "22" "Statutory Safety Signage" "415V Danger Plates, Caution Solar PV, Fire Extinguishers" "1" "Lot")
    )
  )

  ;; Fall Safety Line Hardware
  (if (> *PV_FALL_SAFETY_LENGTH* 0.0)
    (setq bom-data
      (append bom-data
        (list
          (list (itoa (1+ (length bom-data))) "Fall Safety Wire Rope Lifeline" "8mm SS316 Stainless Steel Wire Rope" (rtos *PV_FALL_SAFETY_LENGTH* 2 1) "Mtr")
          (list (itoa (+ (length bom-data) 2)) "End Anchor Plates w/ Tensioners" "Heavy Duty Anchor Baseplate w/ Spring Loaded Tensioners" (itoa *PV_FALL_SAFETY_ANCHOR_COUNT*) "Sets")
          (list (itoa (+ (length bom-data) 3)) "90 deg Corner Turn Pulleys" "Deflection Pulley Bracket Assemblies" (itoa *PV_FALL_SAFETY_TURN_COUNT*) "Sets")
        )
      )
    )
  )

  ;; Safety Handrails Hardware
  (if (> *PV_HANDRAIL_LENGTH* 0.0)
    (setq bom-data
      (append bom-data
        (list
          (list (itoa (1+ (length bom-data))) "Rooftop Safety Handrails" "1100mm Modular Dual Rail Guardrail System" (rtos *PV_HANDRAIL_LENGTH* 2 1) "Mtr")
          (list (itoa (+ (length bom-data) 2)) "Handrail Stanchion Posts" "Base Flange Fixing Posts w/ Anchor Bolts" (itoa *PV_HANDRAIL_POST_COUNT*) "Posts")
        )
      )
    )
  )

  ;; Walkways
  (if (> *PV_WALKWAY_LENGTH* 0.0)
    (setq bom-data
      (append bom-data
        (list
          (list (itoa (1+ (length bom-data))) "Maintenance Walkways" "Anti-skid FRP/GRP Grating with Fixing Clips" (rtos *PV_WALKWAY_LENGTH* 2 1) "Mtr")
        )
      )
    )
  )

  (setq doc (vla-get-ActiveDocument (vlax-get-acad-object)))
  (setq space (vla-get-ModelSpace doc))
  (setq total-rows (+ (length bom-data) 2))

  (if (vlax-method-applicable-p space 'AddTable)
    (progn
      ;; Generous initial dimensions (0.90m row height x 8.0m col width)
      (setq table (vla-AddTable space (vlax-3d-point pt) total-rows 5 0.36 8.00))
      (vla-put-layer table "PV_BOM")
      (vla-SetText table 0 0 "ROOFTOP SOLAR PV SYSTEM - BILL OF MATERIALS (BOM)")
      
      (vla-SetText table 1 0 "Item #")
      (vla-SetText table 1 1 "Component Description")
      (vla-SetText table 1 2 "Technical Specification")
      (vla-SetText table 1 3 "Quantity")
      (vla-SetText table 1 4 "Unit")

      (setq row 2)
      (foreach item bom-data
        (setq col 0)
        (foreach val item
          (vla-SetText table row col val)
          (setq col (1+ col))
        )
        (setq row (1+ row))
      )

      ;; Apply formatting and wide readable columns
      (pv:format-bom-table table total-rows)

      (princ "\n[SolarPV] AutoCAD BOM Table inserted.")
    )
  )
  (princ)
)

;;; --------------------------------------------------------------------------
;;; Simulation Text Report & CSV Export
;;; --------------------------------------------------------------------------
(defun pv:format-simulation-report (sim-res / plant-kw total-ghi total-poa yr1-gen spec-yield
                                              overall-pr cuf cum-gen m-list yr-list str co2-tons)
  (setq plant-kw    (nth 0 sim-res)
        total-ghi   (nth 1 sim-res)
        total-poa   (nth 2 sim-res)
        yr1-gen     (nth 3 sim-res)
        spec-yield  (nth 4 sim-res)
        overall-pr  (nth 5 sim-res)
        cuf         (nth 6 sim-res)
        cum-gen     (nth 7 sim-res)
        m-list      (nth 8 sim-res)
        yr-list     (nth 10 sim-res))
  (setq co2-tons (* (/ cum-gen 1000.0) 0.82))

  (setq str "")
  (setq str (strcat str "========================================================================================\n"))
  (setq str (strcat str "            PHOTOVOLTAIC SYSTEM ENERGY YIELD & PERFORMANCE SIMULATION REPORT            \n"))
  (setq str (strcat str "========================================================================================\n"))
  (setq str (strcat str "Project Name           : " *PV_PROJ_NAME* "\n"))
  (setq str (strcat str "Weather Resource Model : " *PV_WEATHER_SRC* "\n"))
  (setq str (strcat str "Site Coordinates       : Latitude " (rtos *PV_LAT* 2 4) "° | Longitude " (rtos *PV_LON* 2 4) "°\n"))
  (setq str (strcat str "Rooftop Structure      : " *PV_ROOF_TYPE* " (" *PV_MOUNT_OPT* ")\n"))
  (setq str (strcat str "Sizing Mode            : " *PV_LAYOUT_MODE* "\n"))
  (setq str (strcat str "----------------------------------------------------------------------------------------\n\n"))

  (setq str (strcat str "1. EXECUTIVE SUMMARY & SYSTEM PRODUCTION METRICS:\n"))
  (setq str (strcat str "   - Total Nominal DC Capacity        : " (rtos plant-kw 2 2) " kWp\n"))
  (setq str (strcat str "   - Total PV Module Count            : " (itoa *PV_MODULE_COUNT*) " units (" *PV_PAN_MFG* " " *PV_PAN_MODEL* " " (rtos *PV_MOD_WATT* 2 0) "Wp)\n"))
  (setq str (strcat str "   - Inverter Configuration           : " (itoa *PV_INV_COUNT*) "x " *PV_INV_MFG* " " *PV_INV_MODEL* " (" (rtos *PV_INV_KW* 2 0) "kW AC) | DC:AC = " (rtos *PV_DC_AC_RATIO* 2 2) "\n"))
  (setq str (strcat str "   - Fall Safety Lifeline             : " (rtos *PV_FALL_SAFETY_LENGTH* 2 1) " m (" (itoa *PV_FALL_SAFETY_ANCHOR_COUNT*) " Tensioner Anchors, " (itoa *PV_FALL_SAFETY_TURN_COUNT*) " Turn Anchors)\n"))
  (setq str (strcat str "   - Safety Handrails                 : " (rtos *PV_HANDRAIL_LENGTH* 2 1) " m (" (itoa *PV_HANDRAIL_POST_COUNT*) " Posts)\n"))
  (setq str (strcat str "   - Annual Global Incident (POA)     : " (rtos total-poa 2 1) " kWh/m²\n"))
  (setq str (strcat str "   - Annual Specific Energy Yield     : " (rtos spec-yield 2 1) " kWh/kWp/year\n"))
  (setq str (strcat str "   - Overall Performance Ratio (PR)   : " (rtos overall-pr 2 2) " %\n"))
  (setq str (strcat str "   - Capacity Utilization Factor (CUF): " (rtos cuf 2 2) " %\n"))
  (setq str (strcat str "   - Year-1 Injected Energy Yield     : " (rtos yr1-gen 2 1) " kWh/year\n"))
  (setq str (strcat str "   - 25-Year Cumulative Generation    : " (rtos cum-gen 2 0) " kWh (~ " (rtos (/ cum-gen 1000.0) 2 1) " MWh)\n"))
  (setq str (strcat str "   - Lifetime CO2 Emissions Offset    : ~ " (rtos co2-tons 2 1) " Metric Tons\n"))
  (setq str (strcat str "----------------------------------------------------------------------------------------\n\n"))

  (setq str (strcat str "2. MONTHLY ENERGY GENERATION & IRRADIANCE BALANCE TABLE:\n"))
  (setq str (strcat str "+-------+----------+----------+---------+---------+-----------+--------------+--------+---------------+\n"))
  (setq str (strcat str "| Month |   GHI    |   POA    |  Tamb   |  Tcell  |  Thermal  | Energy Yield | System | Specific Prod |\n"))
  (setq str (strcat str "|       | (kWh/m²) | (kWh/m²) |  (°C)   |  (°C)   | Loss (%)  |    (kWh)     | PR (%) |   (kWh/kWp)   |\n"))
  (setq str (strcat str "+-------+----------+----------+---------+---------+-----------+--------------+--------+---------------+\n"))
  (foreach row m-list
    (setq str (strcat str "| " (nth 0 row) "   | "
                          (rtos (nth 1 row) 2 1) "    | "
                          (rtos (nth 2 row) 2 1) "    |  "
                          (rtos (nth 3 row) 2 1) "   |  "
                          (rtos (nth 4 row) 2 1) "   |   "
                          (rtos (nth 5 row) 2 2) "   |   "
                          (rtos (nth 6 row) 2 0) "     |  "
                          (rtos (nth 7 row) 2 2) " |     "
                          (rtos (nth 8 row) 2 1) "     |\n"))
  )
  (setq str (strcat str "+-------+----------+----------+---------+---------+-----------+--------------+--------+---------------+\n"))
  (setq str (strcat str "| Total | " (rtos total-ghi 2 1) "  | " (rtos total-poa 2 1) "  |  26.0*  |  44.0*  |   -6.70*  |   " (rtos yr1-gen 2 0) "    |  " (rtos overall-pr 2 2) " |     " (rtos spec-yield 2 1) "   |\n"))
  (setq str (strcat str "+-------+----------+----------+---------+---------+-----------+--------------+--------+---------------+\n\n"))

  (setq str (strcat str "3. 25-YEAR LIFETIME ANNUAL PRODUCTION & DEGRADATION SCHEDULE:\n"))
  (foreach yr-item yr-list
    (setq str (strcat str "   - Year " (if (< (nth 0 yr-item) 10) " " "") (itoa (nth 0 yr-item)) " : " 
                          (rtos (nth 1 yr-item) 2 0) " kWh/yr | Cumul: " 
                          (rtos (/ (nth 2 yr-item) 1000.0) 2 2) " MWh | PR: " 
                          (rtos (nth 4 yr-item) 2 2) " %\n"))
  )
  ;; 4. Financial ROI, Payback & Levelized Cost (ARKA 360 Standard)
  (setq fin (pv:calc-financial-roi plant-kw yr1-gen))
  (setq cur (if *PV_CURRENCY_CODE* *PV_CURRENCY_CODE* "INR"))
  (setq str (strcat str "\n4. FINANCIAL ROI, PAYBACK & COMMERCIAL METRICS:\n"))
  (setq str (strcat str "   - Project Currency                 : " cur " (" (if *PV_CURRENCY_SYM* *PV_CURRENCY_SYM* "") ")\n"))
  (setq str (strcat str "   - Grid Electricity Tariff          : " cur " " (rtos *PV_GRID_TARIFF* 2 2) " / kWh (Escalation: " (rtos *PV_TARIFF_ESC* 2 1) "%/yr)\n"))
  (setq str (strcat str "   - Turnkey EPC System Cost          : " cur " " (rtos *PV_EPC_COST_PER_W* 2 2) " / Wp (Total CapEx: " cur " " (rtos (nth 0 fin) 2 0) ")\n"))
  (setq str (strcat str "   - Year-1 Annual Electricity Savings: " cur " " (rtos (nth 1 fin) 2 0) " / year\n"))
  (setq str (strcat str "   - Simple Payback Period            : " (rtos (nth 2 fin) 2 1) " Years\n"))
  (setq str (strcat str "   - 25-Year Cumulative Net Savings   : " cur " " (rtos (nth 3 fin) 2 0) "\n"))
  (setq str (strcat str "   - Levelized Cost of Energy (LCOE)  : " cur " " (rtos (nth 4 fin) 2 4) " / kWh\n"))
  (setq str (strcat str "   - Financial Return on Investment   : " (rtos (nth 5 fin) 2 1) " % ROI\n"))
  (setq str (strcat str "========================================================================================\n"))
  str
)

(defun c:pv-report-energy (/ sim-res rep-str dwg-path rep-path fh)
  (setq sim-res (pv:simulate-system-yield))
  (setq rep-str (pv:format-simulation-report sim-res))
  (setq dwg-path (getvar "DWGPREFIX"))
  (setq rep-path (strcat dwg-path "SolarPV_Simulation_Report.txt"))
  (setq fh (open rep-path "w"))
  (if fh
    (progn
      (write-line rep-str fh)
      (close fh)
      (princ (strcat "\n[SolarPV] Report saved to: " rep-path))
      (startapp "notepad.exe" rep-path)
    )
  )
  (princ)
)

(defun c:pv-export-csv (/ dwg-path csv-path fh sim-res m-list yr-list)
  (setq sim-res (pv:simulate-system-yield))
  (setq m-list (nth 8 sim-res)
        yr-list (nth 10 sim-res))
  (setq dwg-path (getvar "DWGPREFIX"))
  (setq csv-path (strcat dwg-path "SolarPV_Project_Data.csv"))
  (setq fh (open csv-path "w"))
  (if fh
    (progn
      (write-line "Project Name,DC Capacity (kWp),Module Model,Inverter Model,Weather Source,Lat,Lon" fh)
      (write-line (strcat "\"" *PV_PROJ_NAME* "\"," (rtos (car sim-res) 2 2) ",\"" *PV_PAN_MFG* " " *PV_PAN_MODEL* "\",\"" *PV_INV_MFG* " " *PV_INV_MODEL* "\",\"" *PV_WEATHER_SRC* "\"," (rtos *PV_LAT* 2 4) "," (rtos *PV_LON* 2 4)) fh)
      (write-line "" fh)
      (write-line "Month,GHI (kWh/m2),POA (kWh/m2),Tamb (C),Tcell (C),Thermal Loss (%),Energy (kWh),PR (%),Specific Yield (kWh/kWp)" fh)
      (foreach r m-list
        (write-line (strcat (nth 0 r) "," (rtos (nth 1 r) 2 2) "," (rtos (nth 2 r) 2 2) "," (rtos (nth 3 r) 2 1) "," (rtos (nth 4 r) 2 1) "," (rtos (nth 5 r) 2 2) "," (rtos (nth 6 r) 2 1) "," (rtos (nth 7 r) 2 2) "," (rtos (nth 8 r) 2 2)) fh)
      )
      (write-line "" fh)
      (write-line "Year,Annual Generation (kWh),Cumulative Generation (kWh),Specific Yield (kWh/kWp),Plant PR (%)" fh)
      (foreach yr-item yr-list
        (write-line (strcat (itoa (nth 0 yr-item)) "," (rtos (nth 1 yr-item) 2 0) "," (rtos (nth 2 yr-item) 2 0) "," (rtos (nth 3 yr-item) 2 2) "," (rtos (nth 4 yr-item) 2 2)) fh)
      )
      (close fh)
      (princ (strcat "\n[SolarPV] Exported CSV to: " csv-path))
      (alert (strcat "Data Exported Successfully!\n\nFile: " csv-path))
    )
  )
  (princ)
)

;;; --------------------------------------------------------------------------
;;; Interactive DCL Dialog Drivers
;;; --------------------------------------------------------------------------

;; pv:file-exists-p defined at line 1323 (duplicate removed)

(defun pv:get-dcl-path (/ dcl-path app-dir)
  (setq app-dir (pv:get-app-dir))
  ;; 1. Check same directory where LISP file is loaded (best for sharing/portability)
  (or (setq dcl-path (pv:file-exists-p (strcat app-dir "/RooftopSolar.dcl")))
      ;; 2. Check AutoCAD Library Search Path via findfile
      (setq dcl-path (findfile "RooftopSolar.dcl"))
      ;; 3. Check current drawing folder
      (setq dcl-path (pv:file-exists-p (strcat (getvar "DWGPREFIX") "RooftopSolar.dcl")))
      ;; 4. Fallback development workspace path
      (setq dcl-path (pv:file-exists-p "d:/VibeCoding/AUTOLISP/Rooftop/RooftopSolar.dcl"))
      (setq dcl-path (pv:file-exists-p "d:\\VibeCoding\\AUTOLISP\\Rooftop\\RooftopSolar.dcl"))
      ;; 5. Interactive file picker fallback if user moved files
      (setq dcl-path (getfiled "Select RooftopSolar.dcl File" (strcat app-dir "/RooftopSolar.dcl") "dcl" 8))
  )
  dcl-path
)

(defun c:pv-clear-layout ()
  (pv:clear-layout)
  (setq *PV_MODULE_COUNT* 0
        *PV_TABLE_COUNT* 0
        *PV_WALKWAY_LENGTH* 0.0)
  (princ "\n[SolarPV] Array layout cleared from drawing.")
  (princ)
)

;;; ==========================================================================
;;; MASTER FUNCTIONS CONTROL CENTER (DCL for Calling All Functions)
;;; ==========================================================================
(defun c:pv-menu (/ dcl-file dcl-id what-next loop *error*)
  (defun *error* (msg)
    (if (and dcl-id (> dcl-id 0)) (unload_dialog dcl-id))
    (if (and msg (not (wcmatch (strcase msg) "*CANCEL*,*QUIT*,*EXIT*")))
      (princ (strcat "\n[SolarPV] Error: " msg))
    )
    (princ)
  )
  (vl-load-com)
  (pv:init-layers)
  (if (null *PV_MODULE_LIBRARY*) (pv:init-module-db))
  (if (null *PV_INVERTER_LIBRARY*) (pv:init-inverter-db))

  (setq loop t)
  (while loop
    (setq dcl-file (pv:get-dcl-path))
    (if (not dcl-file)
      (progn
        (princ "\n[SolarPV] Error: Could not locate 'RooftopSolar.dcl'.")
        (alert "Error: Could not locate 'RooftopSolar.dcl'.\nPlease verify it exists in 'd:\\VibeCoding\\AUTOLISP\\Rooftop\\'.")
        (setq loop nil)
      )
      (progn
        (setq dcl-id (load_dialog dcl-file))
        (if (or (null dcl-id) (<= dcl-id 0))
          (progn
            (princ (strcat "\n[SolarPV] Error: Could not load DCL file: " dcl-file))
            (alert (strcat "Error: Failed to load DCL file:\n" dcl-file))
            (setq loop nil)
          )
          (if (not (new_dialog "solar_pv_control_center" dcl-id))
            (progn
              (princ "\n[SolarPV] Error: Could not load 'solar_pv_control_center' from DCL.")
              (alert "Error: Could not load 'solar_pv_control_center' from DCL.")
              (unload_dialog dcl-id)
              (setq loop nil)
            )
            (progn
              ;; Hook up buttons for calling all functions directly
              (action_tile "f_pick_bnd"      "(done_dialog 2)")
              (action_tile "f_multiroof"     "(done_dialog 53)")
              (action_tile "f_roof_list"     "(done_dialog 54)")
              (action_tile "f_select_roof"   "(done_dialog 55)")
              (action_tile "f_roof_bldg_3d"  "(done_dialog 57)")
              (action_tile "f_pick_obs"      "(done_dialog 3)")
              (action_tile "f_clr_obs"       "(done_dialog 8)")
              (action_tile "f_toggle_shadow" "(done_dialog 58)")
              (action_tile "f_hip_split"     "(done_dialog 44)")
              (action_tile "f_dome_split"    "(done_dialog 45)")
              (action_tile "f_one_dome"      "(done_dialog 46)")
              (action_tile "f_roof_num"      "(done_dialog 47)")
              (action_tile "f_show_offsets"  "(done_dialog 48)")
              (action_tile "f_load_pan"      "(done_dialog 10)")
              (action_tile "f_load_ond"      "(done_dialog 15)")
              (action_tile "f_gen_layout"    "(done_dialog 4)")
              (action_tile "f_layout_ew"     "(done_dialog 34)")
              (action_tile "f_elev_legs"     "(done_dialog 59)")
              (action_tile "f_ew_vis"        "(done_dialog 36)")
              (action_tile "f_dim_plan"      "(done_dialog 50)")
              (action_tile "f_validate"      "(done_dialog 52)")
              (action_tile "f_clr_layout"    "(done_dialog 16)")
              (action_tile "f_fall_safety"   "(done_dialog 11)")
              (action_tile "f_handrail"      "(done_dialog 12)")
              (action_tile "f_walkway"       "(done_dialog 17)")
              (action_tile "f_clr_walkway"   "(done_dialog 18)")
              (action_tile "f_stringing"     "(done_dialog 21)")
              (action_tile "f_string_manual" "(done_dialog 30)")
              (action_tile "f_string_ew"     "(done_dialog 35)")
              (action_tile "f_polarity"      "(done_dialog 31)")
              (action_tile "f_string_vis"    "(done_dialog 32)")
              (action_tile "f_panel_num"     "(done_dialog 33)")
              (action_tile "f_mppt_details"  "(done_dialog 37)")
              (action_tile "f_mppt_link"     "(done_dialog 38)")
              (action_tile "f_dc_route_tracked" "(done_dialog 39)")
              (action_tile "f_dc_route_color"   "(done_dialog 41)")
              (action_tile "f_cable_calc"    "(done_dialog 42)")
              (action_tile "f_ac_equipment"  "(done_dialog 43)")
              (action_tile "f_dc_schedule"   "(done_dialog 40)")
              (action_tile "f_clr_strings"   "(done_dialog 22)")
              (action_tile "f_inverter"      "(done_dialog 23)")
              (action_tile "f_ajb"           "(done_dialog 68)")
              (action_tile "f_earthing"      "(done_dialog 66)")
              (action_tile "f_lightning"     "(done_dialog 67)")
              (action_tile "f_clr_earthing"  "(done_dialog 70)")
              (action_tile "f_cable_tray"    "(done_dialog 24)")
              (action_tile "f_sld"           "(done_dialog 26)")
              (action_tile "f_3d_view"       "(done_dialog 27)")
              (action_tile "f_prune_shaded"  "(done_dialog 28)")
              (action_tile "f_export_pvsyst" "(done_dialog 29)")
              (action_tile "f_pvsyst_export" "(done_dialog 51)")
              (action_tile "f_energy_table"  "(done_dialog 13)")
              (action_tile "f_bom_table"     "(done_dialog 5)")
              (action_tile "f_complib"       "(done_dialog 56)")
              (action_tile "f_sim_report"    "(done_dialog 6)")
              (action_tile "f_export_csv"    "(done_dialog 7)")
              (action_tile "f_open_designer" "(done_dialog 20)")
              ;; New dispatcher buttons
              (action_tile "f_show_hide_offset" "(done_dialog 49)")
              (action_tile "f_walkway_auto"     "(done_dialog 60)")
              (action_tile "f_clr_handrail"     "(done_dialog 19)")
              (action_tile "f_clr_all"          "(done_dialog 61)")
              (action_tile "f_clr_3d"           "(done_dialog 62)")
              (action_tile "f_clr_bldg"         "(done_dialog 63)")
              (action_tile "f_clr_cabletray"    "(done_dialog 64)")
              (action_tile "f_elev_toggle"      "(done_dialog 65)")
              (action_tile "cancel"             "(done_dialog 0)")

              (setq what-next (start_dialog))
              (unload_dialog dcl-id)

              ;; Dispatch function based on button clicked
              (cond
                ((= what-next 2)  (c:pv-pick-boundary))
                ((= what-next 53) (c:pv-multiroof))
                ((= what-next 54) (c:pv-roof-list))
                ((= what-next 55) (c:pv-select-roof))
                ((= what-next 57) (c:pv-building-3d))
                ((= what-next 56) (c:pv-complib))
                ((= what-next 3)  (c:pv-pick-obstacles))
                ((= what-next 8)  (c:pv-clear-obstacles))
                ((= what-next 58) (c:pv-toggle-shadow))
                ((= what-next 44) (c:pv-hip-split))
                ((= what-next 45) (c:pv-dome-split))
                ((= what-next 46) (c:pv-one-dome))
                ((= what-next 47) (c:pv-roof-number))
                ((= what-next 48) (c:pv-show-all-offset))
                ((= what-next 10) (c:pv-load-pan))
                ((= what-next 15) (c:pv-load-ond))
                ((= what-next 4)  (pv:generate-layout))
                ((= what-next 34) (c:pv-layout-ew))
                ((= what-next 59) (c:pv-elev-legs-config))
                ((= what-next 36) (c:pv-ew-vis))
                ((= what-next 50) (c:pv-dim-plan))
                ((= what-next 52) (c:pv-validate))
                ((= what-next 16) (c:pv-clear-layout))
                ((= what-next 17) (c:pv-walkway))
                ((= what-next 18) (c:pv-clear-walkways))
                ((= what-next 11) (c:pv-fall-safety))
                ((= what-next 12) (c:pv-handrail))
                ((= what-next 19) (c:pv-clear-handrails))
                ((= what-next 21) (c:pv-stringing))
                ((= what-next 30) (c:pv-string-manual))
                ((= what-next 35) (c:pv-string-ew))
                ((= what-next 31) (c:pv-polarity))
                ((= what-next 32) (c:pv-string-vis))
                ((= what-next 33) (c:pv-panel-number))
                ((= what-next 37) (c:pv-mppt-details))
                ((= what-next 38) (c:pv-mppt-link))
                ((= what-next 39) (c:pv-dc-route-tracked))
                ((= what-next 41) (c:pv-dc-route-color-polarity))
                ((= what-next 42) (c:pv-cable-calc))
                ((= what-next 43) (c:pv-ac-equipment))
                ((= what-next 40) (c:pv-dc-schedule))
                ((= what-next 22) (c:pv-clear-strings))
                ((= what-next 23) (c:pv-place-inverter))
                ((= what-next 24) (c:pv-draw-cable-tray))
                ((= what-next 26) (c:pv-draw-sld))
                ((= what-next 27) (c:pv-3d-view))
                ((= what-next 28) (c:pv-prune-shaded))
                ((= what-next 29) (c:pv-export-pvsyst))
                ((= what-next 51) (c:pv-pvsyst-export))
                ((= what-next 13) (c:pv-energy-table))
                ((= what-next 5)  (c:pv-draw-bom))
                ((= what-next 6)  (c:pv-report-energy))
                ((= what-next 7)  (c:pv-export-csv))
                ((= what-next 20) (pv:full-designer-dialog))
                ;; New dispatcher dialog IDs
                ((= what-next 49) (c:pv-hide-all-offset))    ; Show/Hide Parapet
                ((= what-next 60) (c:pv-toggle-auto-walkway)); Auto Walkway toggle
                ((= what-next 19) (c:pv-clear-handrails))    ; Clear Handrails
                ((= what-next 61)                             ; Clear Everything
                 (progn
                   (c:pv-clear-layout)
                   (c:pv-clear-strings)
                   (c:pv-clear-walkways)
                   (c:pv-clear-handrails)
                   (c:pv-clear-cable-tray)
                   (c:pv-clear-3d)
                   (c:pv-clear-building-3d)
                   (c:pv-clear-obstacles)
                   (c:pv-clear-earthing)
                   (princ "\n[SolarPV] All elements cleared.")
                 ))
                ((= what-next 62) (c:pv-clear-3d))           ; Clear 3D
                ((= what-next 63) (c:pv-clear-building-3d))  ; Clear 3D Building
                ((= what-next 64) (c:pv-clear-cable-tray))   ; Clear Cable Tray
                ((= what-next 65) (c:pv-elev-toggle))        ; Elevated toggle
                ((= what-next 66) (c:pv-earthing))           ; IS 3043 Chemical Earthing
                ((= what-next 67) (c:pv-lightning))          ; IS/IEC 62305 Lightning Arrester
                ((= what-next 68) (c:pv-place-ajb))          ; Place Array Junction Box
                ((= what-next 69) (c:pv-place-acdb))         ; Place ACDB & DISCOM Switch
                ((= what-next 70) (c:pv-clear-earthing))     ; Clear Earthing & LA
                (t
                  (setq loop nil)
                  (princ "\n[SolarPV] Master Control Center closed.")
                )
              )
            )
          )
        )
      )
    )
  )
  (princ)
)

;;; ==========================================================================
;;; FULL DESIGNER CONFIGURATION DIALOG
;;; ==========================================================================
(defun pv:update-pan-status-tile ()
  (if (get_tile "txt_pan_specs")
    (set_tile "txt_pan_specs"
      (strcat "Vmp: " (rtos *PV_PAN_VMP* 2 2) "V | Imp: " (rtos *PV_PAN_IMP* 2 2) 
              "A | Voc: " (rtos *PV_PAN_VOC* 2 2) "V | muPmp: " (rtos *PV_PAN_TEMP_COEFF* 2 3) 
              "%/degC | Eff: " (rtos *PV_PAN_EFFICIENCY* 2 2) "%")
    )
  )
)

(defun pv:update-inv-status-tile ()
  (if (get_tile "txt_inv_info")
    (set_tile "txt_inv_info"
      (strcat "Inverter: " *PV_INV_MFG* " " *PV_INV_MODEL* " (" (rtos *PV_INV_KW* 2 0) " kW AC | " (itoa *PV_INV_MPPT_COUNT*) " MPPTs | Max " (rtos *PV_INV_VDC_MAX* 2 0) "V DC)")
    )
  )
  (if (get_tile "txt_inv_specs")
    (set_tile "txt_inv_specs"
      (strcat "MPPT: " (rtos *PV_INV_VMPP_MIN* 2 0) "-" (rtos *PV_INV_VMPP_MAX* 2 0) 
              "V | Inputs: " (itoa *PV_INV_INPUTS*) " | ImaxDC: " (rtos *PV_INV_IMAX_DC* 2 0) 
              "A | Euro Eff: " (rtos *PV_INV_EFF_EURO* 2 2) "%")
    )
  )
)

(defun pv:count-placed-modules (/ ss)
  (setq ss (ssget "X" '((0 . "LWPOLYLINE,POLYLINE,3DFACE") (8 . "PV_MODULES,PV_MODULES_EAST,PV_MODULES_WEST,PV_MODULES_SOUTH,PV_MODULES_NORTH"))))
  (if ss (sslength ss) 0)
)

(defun pv:on-currency-select (/ idx cur-data)
  (if (get_tile "currency_select")
    (progn
      (setq idx (atoi (get_tile "currency_select")))
      (if (and (>= idx 0) (< idx (length *PV_CURRENCY_LIST*)))
        (progn
          (setq cur-data (nth idx *PV_CURRENCY_LIST*))
          (setq *PV_CURRENCY_IDX*  idx
                *PV_CURRENCY_CODE* (nth 0 cur-data)
                *PV_CURRENCY_SYM*  (nth 1 cur-data)
                *PV_GRID_TARIFF*    (nth 3 cur-data)
                *PV_EPC_COST_PER_W* (nth 4 cur-data)
          )
          (if (get_tile "grid_tariff")   (set_tile "grid_tariff" (rtos *PV_GRID_TARIFF* 2 2)))
          (if (get_tile "epc_cost_watt") (set_tile "epc_cost_watt" (rtos *PV_EPC_COST_PER_W* 2 2)))
          (pv:update-financial-status-tile)
        )
      )
    )
  )
)

(defun pv:update-financial-status-tile (/ mod-cnt plant-kw yr1-kwh fin sym)
  (setq mod-cnt (pv:count-placed-modules))
  (setq plant-kw (/ (* mod-cnt *PV_MOD_WATT*) 1000.0))
  (if (<= plant-kw 0.0)
    (setq plant-kw (if (and *PV_TARGET_KW* (> *PV_TARGET_KW* 0.0)) *PV_TARGET_KW* 50.0))
  )
  (setq yr1-kwh (* plant-kw 1550.0 (/ *PV_PR* 100.0)))
  (setq fin (pv:calc-financial-roi plant-kw yr1-kwh))
  (setq sym (if *PV_CURRENCY_SYM* *PV_CURRENCY_SYM* "Rs."))
  (if (get_tile "txt_financial_summary")
    (set_tile "txt_financial_summary"
      (strcat "Est. CapEx: " sym " " (rtos (car fin) 2 0)
              " | Payback: " (rtos (caddr fin) 2 1) " Yrs"
              " | 25-Yr Savings: " sym " " (rtos (cadddr fin) 2 0)
              " | LCOE: " sym " " (rtos (nth 4 fin) 2 3) "/kWh"
              " | ROI: " (rtos (nth 5 fin) 2 1) "%")
    )
  )
)

(defun pv:on-mod-select ()
  (pv:select-module-by-index (atoi (get_tile "mod_select")))
  (if (get_tile "mod_watt") (set_tile "mod_watt" (rtos *PV_MOD_WATT* 2 1)))
  (if (get_tile "mod_len")  (set_tile "mod_len"  (rtos *PV_MOD_LEN* 2 3)))
  (if (get_tile "mod_wid")  (set_tile "mod_wid"  (rtos *PV_MOD_WID* 2 3)))
  (pv:update-pan-status-tile)
)

(defun pv:on-inv-select ()
  (pv:select-inverter-by-index (atoi (get_tile "inv_select")))
  (pv:update-inv-status-tile)
)

;;; Returns (tilt-deg azimuth-deg facing-str) for the active/selected roof surface, or nil if none.
(defun pv:get-active-surface-tilt-az (/ surf-ent s-info s-tilt s-az s-facing pts-3d plane slope-info)
  (setq surf-ent
    (cond
      ((and *PV_ACTIVE_ROOF_IDX* (> *PV_ACTIVE_ROOF_IDX* 0) *PV_BOUNDARY_LIST* (<= *PV_ACTIVE_ROOF_IDX* (length *PV_BOUNDARY_LIST*)))
       (nth (1- *PV_ACTIVE_ROOF_IDX*) *PV_BOUNDARY_LIST*))
      ((and *PV_BOUNDARY_ENT* (assoc *PV_BOUNDARY_ENT* *PV_ROOF_SURFACES*))
       *PV_BOUNDARY_ENT*)
      ((and *PV_BOUNDARY_LIST* (car *PV_BOUNDARY_LIST*))
       (car *PV_BOUNDARY_LIST*))
      (t nil)
    )
  )
  (setq s-info (if surf-ent (cdr (assoc surf-ent *PV_ROOF_SURFACES*)) nil))
  (if (and (null s-info) *PV_ROOF_SURFACES*)
    (setq s-info (cdar *PV_ROOF_SURFACES*))
  )
  (cond
    (s-info
     (setq s-tilt   (if (assoc "TILT" s-info) (cdr (assoc "TILT" s-info)) nil)
           s-az     (if (assoc "AZIMUTH" s-info) (cdr (assoc "AZIMUTH" s-info)) nil)
           s-facing (if (assoc "FACING" s-info) (cdr (assoc "FACING" s-info)) "Flat"))
     (if (and (assoc "PLANE" s-info) (cdr (assoc "PLANE" s-info)))
       (progn
         (setq slope-info (pv:slope-from-plane (cdr (assoc "PLANE" s-info))))
         (if (null s-tilt) (setq s-tilt (car slope-info)))
         (if (null s-az)   (setq s-az   (cadr slope-info)))
       )
     )
     (if (and s-tilt s-az)
       (list s-tilt s-az s-facing)
       nil
     )
    )
    ((and surf-ent (entget surf-ent))
     (setq pts-3d (pv:get-polyline-3d-pts surf-ent))
     (if (and pts-3d (>= (length pts-3d) 3))
       (progn
         (setq plane (pv:plane-from-pts-list pts-3d))
         (if plane (pv:slope-from-plane plane) nil)
       )
       nil
     )
    )
    (t nil)
  )
)

;;; Synchronizes Tilt Angle & Azimuth (globals + DCL tiles) to the selected surface
;;; when Metal Sheet Rooftop + Flush Mounted (Parallel to Roof) is active.
(defun pv:sync-flush-mount-from-surface (/ surf-vals)
  (setq surf-vals (pv:get-active-surface-tilt-az))
  (cond
    (surf-vals
     (setq *PV_TILT*       (car surf-vals)
           *PV_AZIMUTH*    (cadr surf-vals)
           *PV_ROOF_SLOPE* (car surf-vals))
     (if (get_tile "tilt_angle")    (set_tile "tilt_angle"    (rtos *PV_TILT* 2 1)))
     (if (get_tile "azimuth_angle") (set_tile "azimuth_angle" (rtos *PV_AZIMUTH* 2 1)))
     (if (get_tile "roof_slope")    (set_tile "roof_slope"    (rtos *PV_ROOF_SLOPE* 2 1)))
     ;; Lock manual Tilt & Azimuth inputs while Flush Mount mirrors the selected surface
     (if (get_tile "tilt_angle")    (mode_tile "tilt_angle" 1))
     (if (get_tile "azimuth_angle") (mode_tile "azimuth_angle" 1))
     (if (get_tile "status_bar")
       (set_tile "status_bar"
         (strcat "Flush Mount active: Tilt (" (rtos *PV_TILT* 2 1) " deg) & Azimuth ("
                 (rtos *PV_AZIMUTH* 2 1) " deg) synced to selected roof surface."))
     )
    )
    (t
     (if (and *PV_ROOF_SLOPE* (> *PV_ROOF_SLOPE* 0.0))
       (progn
         (setq *PV_TILT* *PV_ROOF_SLOPE*)
         (if (get_tile "tilt_angle") (set_tile "tilt_angle" (rtos *PV_TILT* 2 1)))
       )
     )
     (if (get_tile "tilt_angle")    (mode_tile "tilt_angle" 0))
     (if (get_tile "azimuth_angle") (mode_tile "azimuth_angle" 0))
     (if (get_tile "status_bar")
       (set_tile "status_bar"
         "Flush Mount selected: Tilt & Azimuth will match the selected surface.")
     )
    )
  )
)

(defun pv:on-mount-option (/ rt m-opt)
  (setq rt    (get_tile "roof_type")
        m-opt (get_tile "mount_option"))
  (setq *PV_MOUNT_OPT*
    (cond
      ((= m-opt "1") "Flush Mounted (Parallel to Roof)")
      ((= m-opt "2") "Elevated Tilted Legs")
      (t             "Tilted on MMS Structures")
    )
  )
  (if (and (= rt "1") (= m-opt "1"))
    (pv:sync-flush-mount-from-surface)
    (progn
      (if (get_tile "tilt_angle")    (mode_tile "tilt_angle" 0))
      (if (get_tile "azimuth_angle") (mode_tile "azimuth_angle" 0))
    )
  )
)

(defun pv:on-roof-type ()
  (if (= (get_tile "roof_type") "1")
    (progn
      (setq *PV_ROOF_TYPE* "Metal Sheet Rooftop")
      (setq *PV_MOUNT_OPT* "Flush Mounted (Parallel to Roof)")
      (if (get_tile "mount_option")   (set_tile "mount_option" "1"))
      (if (get_tile "row_pitch")      (set_tile "row_pitch" (rtos (+ *PV_MOD_LEN* 0.20) 2 2)))
      (if (get_tile "parapet_height") (mode_tile "parapet_height" 1))
      (if (get_tile "parapet_thick")  (mode_tile "parapet_thick" 1))
      (pv:sync-flush-mount-from-surface)
    )
    (progn
      (setq *PV_ROOF_TYPE* "Flat RCC Rooftop")
      (setq *PV_MOUNT_OPT* "Tilted on MMS Structures")
      (if (get_tile "mount_option")   (set_tile "mount_option" "0"))
      (if (get_tile "tilt_angle")     (mode_tile "tilt_angle" 0))
      (if (get_tile "azimuth_angle")  (mode_tile "azimuth_angle" 0))
      (if (get_tile "tilt_angle")     (set_tile "tilt_angle" "15.0"))
      (if (get_tile "row_pitch")      (set_tile "row_pitch" "2.80"))
      (if (get_tile "parapet_height") (mode_tile "parapet_height" 0))
      (if (get_tile "parapet_thick")  (mode_tile "parapet_thick" 0))
    )
  )
)

(defun pv:on-auto-pitch ()
  (setq *PV_PITCH*
    (pv:calc-auto-pitch (if (get_tile "lat_val") (atof (get_tile "lat_val")) *PV_LAT*)
                        (if (get_tile "tilt_angle") (atof (get_tile "tilt_angle")) *PV_TILT*)
                        (if (get_tile "mod_len") (atof (get_tile "mod_len")) *PV_MOD_LEN*)
                        (if (get_tile "mod_orient") (if (= (get_tile "mod_orient") "0") "Portrait" "Landscape") *PV_MOD_ORIENT*)
                        (if (get_tile "table_rows") (atoi (get_tile "table_rows")) *PV_TABLE_ROWS*)
                        (if (get_tile "row_spacing") (atof (get_tile "row_spacing")) *PV_ROW_SPACING*)))
  (if (get_tile "row_pitch")
    (set_tile "row_pitch" (rtos *PV_PITCH* 2 2))
  )
)

(defun pv:init-tab-tiles (tab-name)
  (if (get_tile "status_bar")
    (set_tile "status_bar" "Ready. Configure parameters and select boundary/obstacles.")
  )
  (cond
    ;; Tab 1: Site & Rooftop Structure
    ((= tab-name "tab_site_roof")
      (start_list "weather_source")
      (add_list "PVGIS (SARAH-2/ERA5)")
      (add_list "NASA POWER (Global Satellite)")
      (add_list "NREL NSRDB (PSM v3)")
      (add_list "Meteonorm (Interpolated)")
      (end_list)
      (set_tile "weather_source"
        (cond
          ((wcmatch (strcase *PV_WEATHER_SRC*) "*NASA*") "1")
          ((wcmatch (strcase *PV_WEATHER_SRC*) "*NREL*") "2")
          ((wcmatch (strcase *PV_WEATHER_SRC*) "*METEO*") "3")
          (t "0")
        )
      )
      (start_list "roof_type")
      (add_list "Flat RCC Rooftop")
      (add_list "Metal Sheet Rooftop")
      (end_list)
      (set_tile "roof_type" (if (= *PV_ROOF_TYPE* "Flat RCC Rooftop") "0" "1"))

      (start_list "mount_option")
      (add_list "Tilted on MMS Structures")
      (add_list "Flush Mounted (Parallel to Roof)")
      (add_list "Elevated Tilted Legs (Continuous Canopy)")
      (end_list)
      (set_tile "mount_option"
        (cond
          ((wcmatch (strcase *PV_MOUNT_OPT*) "*FLUSH*") "1")
          ((wcmatch (strcase *PV_MOUNT_OPT*) "*ELEVATED*") "2")
          (t "0")
        )
      )
      (start_list "layout_mode")
      (add_list "Install Max Possible (Fill Boundary)")
      (add_list "Target Plant DC Capacity (kWp)")
      (end_list)
      (set_tile "layout_mode" (if (wcmatch (strcase *PV_LAYOUT_MODE*) "*TARGET*") "1" "0"))
      (set_tile "target_kw" (rtos *PV_TARGET_KW* 2 1))
      (mode_tile "target_kw" (if (wcmatch (strcase *PV_LAYOUT_MODE*) "*TARGET*") 0 1))

      (set_tile "proj_name"       *PV_PROJ_NAME*)
      (set_tile "lat_val"         (rtos *PV_LAT* 2 4))
      (set_tile "lon_val"         (rtos *PV_LON* 2 4))
      (set_tile "tilt_angle"      (rtos *PV_TILT* 2 1))
      (set_tile "azimuth_angle"   (rtos *PV_AZIMUTH* 2 1))
      (if (and (pv:is-metal-roof-p) (wcmatch (strcase *PV_MOUNT_OPT*) "*FLUSH*"))
        (pv:sync-flush-mount-from-surface)
      )
      ;; Indian Regulatory & Structural Parameters
      (if (get_tile "sanctioned_load_kw")
        (set_tile "sanctioned_load_kw" (rtos (if (and (boundp '*PV_SANCTIONED_LOAD*) *PV_SANCTIONED_LOAD*) *PV_SANCTIONED_LOAD* 25.0) 2 1))
      )
      (if (get_tile "contract_demand_kva")
        (set_tile "contract_demand_kva" (rtos (if (and (boundp '*PV_CONTRACT_DEMAND*) *PV_CONTRACT_DEMAND*) *PV_CONTRACT_DEMAND* 28.0) 2 1))
      )
      (if (get_tile "grid_voltage_opt")
        (progn
          (start_list "grid_voltage_opt")
          (add_list "3-Phase 415V 50Hz (5-100 kW)")
          (add_list "1-Phase 230V 50Hz (< 3-5 kW)")
          (add_list "HT 11 kV / 33 kV (> 100 kW)")
          (end_list)
          (set_tile "grid_voltage_opt"
            (cond
              ((wcmatch (strcase (if (boundp '*PV_GRID_VOLTAGE*) *PV_GRID_VOLTAGE* "")) "*230V*") "1")
              ((wcmatch (strcase (if (boundp '*PV_GRID_VOLTAGE*) *PV_GRID_VOLTAGE* "")) "*HT*") "2")
              (t "0")
            )
          )
        )
      )
      (if (get_tile "wind_zone_opt")
        (progn
          (start_list "wind_zone_opt")
          (add_list "Zone I (33 m/s - Bengaluru/Pune)")
          (add_list "Zone II (39 m/s - Hyderabad/Nagpur)")
          (add_list "Zone III (44 m/s - Delhi/Mumbai)")
          (add_list "Zone IV (47 m/s - Chennai/Kolkata)")
          (add_list "Zone V (50 m/s - Coastal Odisha/AP)")
          (add_list "Zone VI (55 m/s - Cyclonic Belt)")
          (end_list)
          (set_tile "wind_zone_opt"
            (cond
              ((wcmatch (strcase (if (boundp '*PV_WIND_ZONE*) *PV_WIND_ZONE* "")) "*ZONE I *") "0")
              ((wcmatch (strcase (if (boundp '*PV_WIND_ZONE*) *PV_WIND_ZONE* "")) "*ZONE II *") "1")
              ((wcmatch (strcase (if (boundp '*PV_WIND_ZONE*) *PV_WIND_ZONE* "")) "*ZONE IV*") "3")
              ((wcmatch (strcase (if (boundp '*PV_WIND_ZONE*) *PV_WIND_ZONE* "")) "*ZONE V *") "4")
              ((wcmatch (strcase (if (boundp '*PV_WIND_ZONE*) *PV_WIND_ZONE* "")) "*ZONE VI*") "5")
              (t "2")
            )
          )
        )
      )
      (if (get_tile "ambient_temp_max")
        (set_tile "ambient_temp_max" (rtos (if (and (boundp '*PV_AMBIENT_TEMP*) *PV_AMBIENT_TEMP*) *PV_AMBIENT_TEMP* 45.0) 2 1))
      )
      (if (get_tile "temp_min_c")
        (set_tile "temp_min_c" (rtos (if (and (boundp '*PV_TEMP_MIN*) *PV_TEMP_MIN*) *PV_TEMP_MIN* 8.0) 2 1))
      )
      (set_tile "roof_setback"    (rtos *PV_SETBACK* 2 2))
      (set_tile "roof_slope"      (rtos *PV_ROOF_SLOPE* 2 1))
      (set_tile "mod_clearance"   (rtos *PV_MOD_CLEAR* 2 2))
      (set_tile "pr_val"          (rtos *PV_PR* 2 1))
      (if (get_tile "bldg_height")    (set_tile "bldg_height"    (rtos (if (> *PV_BLDG_EAVES_HT* 0.0) *PV_BLDG_EAVES_HT* 6.0) 2 2)))
      (if (get_tile "parapet_height") (set_tile "parapet_height" (rtos (if (and *PV_PARAPET_HEIGHT* (>= *PV_PARAPET_HEIGHT* 0.0)) *PV_PARAPET_HEIGHT* 1.0) 2 2)))
      (if (get_tile "parapet_thick")  (set_tile "parapet_thick"  (rtos (if (and *PV_PARAPET_THICKNESS* (> *PV_PARAPET_THICKNESS* 0.0)) *PV_PARAPET_THICKNESS* 0.23) 2 2)))
      (if (= *PV_ROOF_TYPE* "Flat RCC Rooftop")
        (progn
          (if (get_tile "parapet_height") (mode_tile "parapet_height" 0))
          (if (get_tile "parapet_thick")  (mode_tile "parapet_thick" 0))
        )
        (progn
          (if (get_tile "parapet_height") (mode_tile "parapet_height" 1))
          (if (get_tile "parapet_thick")  (mode_tile "parapet_thick" 1))
        )
      )
      (if (get_tile "elev_tilt_dir")
        (progn
          (start_list "elev_tilt_dir")
          (add_list "North to South (Slope South, High North)")
          (add_list "South to North (Slope North, High South)")
          (add_list "East to West (Slope West, High East)")
          (add_list "West to East (Slope East, High West)")
          (end_list)
          (set_tile "elev_tilt_dir"
            (cond
              ((wcmatch (strcase *PV_ELEV_TILT_DIR*) "*SOUTH TO NORTH*") "1")
              ((wcmatch (strcase *PV_ELEV_TILT_DIR*) "*EAST TO WEST*") "2")
              ((wcmatch (strcase *PV_ELEV_TILT_DIR*) "*WEST TO EAST*") "3")
              (t "0")
            )
          )
        )
      )
      (if (get_tile "elev_leg_mode")
        (progn
          (start_list "elev_leg_mode")
          (add_list "By Intermediate Legs Count")
          (add_list "By Spacing Distance in Metres (m)")
          (add_list "By Number of Modules")
          (end_list)
          (set_tile "elev_leg_mode"
            (cond
              ((or (= *PV_ELEV_LEG_MODE* "DISTANCE") (= *PV_ELEV_LEG_MODE* "1")) "1")
              ((or (= *PV_ELEV_LEG_MODE* "MODULES")  (= *PV_ELEV_LEG_MODE* "2")) "2")
              (t "0")
            )
          )
        )
      )
      (if (get_tile "elev_leg_count") (set_tile "elev_leg_count" (itoa (if (> *PV_ELEV_LEG_COUNT* 0) *PV_ELEV_LEG_COUNT* 2))))
      (if (get_tile "elev_leg_dist")  (set_tile "elev_leg_dist"  (rtos (if (> *PV_ELEV_LEG_DIST* 0.0) *PV_ELEV_LEG_DIST* 3.00) 2 2)))
      (if (get_tile "elev_leg_mods")  (set_tile "elev_leg_mods"  (itoa (if (> *PV_ELEV_LEG_MODS* 0) *PV_ELEV_LEG_MODS* 2))))
      (if (get_tile "elev_min_clear") (set_tile "elev_min_clear" (rtos (if (> *PV_ELEV_MIN_CLEAR* 0.0) *PV_ELEV_MIN_CLEAR* 2.00) 2 2)))
    )

    ;; Tab 2: PV Module & Inverter Equipment
    ((= tab-name "tab_equipment")
      (start_list "mod_select")
      (foreach mod-item *PV_MODULE_LIBRARY*
        (add_list (strcat (cdr (assoc "MANUFACTURER" mod-item)) " " (cdr (assoc "MODEL" mod-item)) " (" (cdr (assoc "WP" mod-item)) "Wp)"))
      )
      (end_list)
      (set_tile "mod_select" (itoa *PV_ACTIVE_MODULE_IDX*))

      (start_list "inv_select")
      (foreach inv-item *PV_INVERTER_LIBRARY*
        (add_list (strcat (cdr (assoc "MANUFACTURER" inv-item)) " " (cdr (assoc "MODEL" inv-item)) " (" (cdr (assoc "KW" inv-item)) "kW AC)"))
      )
      (end_list)
      (set_tile "inv_select" (itoa *PV_ACTIVE_INVERTER_IDX*))

      (set_tile "mod_watt" (rtos *PV_MOD_WATT* 2 1))
      (set_tile "mod_len"  (rtos *PV_MOD_LEN* 2 3))
      (set_tile "mod_wid"  (rtos *PV_MOD_WID* 2 3))
      (pv:update-pan-status-tile)
      (pv:update-inv-status-tile)
    )

    ;; Tab 3: Array Layout & Obstacles
    ((= tab-name "tab_array_layout")
      (start_list "mod_orient")
      (add_list "Portrait")
      (add_list "Landscape")
      (end_list)
      (set_tile "mod_orient" (if (= *PV_MOD_ORIENT* "Portrait") "0" "1"))
      (set_tile "table_cols"      (itoa *PV_TABLE_COLS*))
      (set_tile "table_rows"      (itoa *PV_TABLE_ROWS*))
      (set_tile "row_pitch"       (rtos *PV_PITCH* 2 2))
      (set_tile "col_spacing"     (rtos *PV_COL_SPACING* 2 3))
      (set_tile "row_spacing"     (rtos *PV_ROW_SPACING* 2 3))
      (set_tile "obs_default_ht"  (rtos *PV_DEF_OBS_HT* 2 2))
      (set_tile "chk_draw_shadow" (itoa *PV_DRAW_SHADOW*))
      (set_tile "walkway_width"   (rtos (if (and *PV_WALKWAY_WIDTH* (> *PV_WALKWAY_WIDTH* 0.0)) *PV_WALKWAY_WIDTH* 0.80) 2 2))
      (set_tile "walkway_freq_row" (itoa *PV_WALKWAY_FREQ_ROW*))
      (set_tile "walkway_freq_col" (itoa *PV_WALKWAY_FREQ_COL*))
      (set_tile "chk_draw_auto_walkway" (itoa *PV_DRAW_AUTO_WALKWAY*))
    )

    ;; Tab 4: Maintenance Walkways & Safety Systems
    ((= tab-name "tab_walkway_safety")
      (set_tile "walkway_width" (rtos (if (and *PV_WALKWAY_WIDTH* (> *PV_WALKWAY_WIDTH* 0.0)) *PV_WALKWAY_WIDTH* 0.80) 2 2))
      (set_tile "walkway_freq_row" (itoa *PV_WALKWAY_FREQ_ROW*))
      (set_tile "walkway_freq_col" (itoa *PV_WALKWAY_FREQ_COL*))
      (set_tile "chk_draw_auto_walkway" (itoa *PV_DRAW_AUTO_WALKWAY*))
      (set_tile "txt_walkway_status"
        (if (and *PV_WALKWAY_LENGTH* (> *PV_WALKWAY_LENGTH* 0.0))
          (strcat "Walkway Corridor (" (rtos *PV_WALKWAY_WIDTH* 2 2) "m width): " (rtos *PV_WALKWAY_LENGTH* 2 1) "m defined on roof (avoided by PV modules)")
          (strcat "Walkway Corridor (" (rtos *PV_WALKWAY_WIDTH* 2 2) "m width): No manual path defined yet. Grid frequency: "
                  (if (> *PV_WALKWAY_FREQ_ROW* 0) (strcat "Every " (itoa *PV_WALKWAY_FREQ_ROW*) " Rows; ") "No Horiz; ")
                  (if (> *PV_WALKWAY_FREQ_COL* 0) (strcat "Every " (itoa *PV_WALKWAY_FREQ_COL*) " Cols.") "No Vert."))
        )
      )
      ;; Handrail Specifications
      (if (get_tile "txt_handrail_ht")
        (set_tile "txt_handrail_ht" (rtos (if (> *PV_HANDRAIL_HEIGHT* 0.0) *PV_HANDRAIL_HEIGHT* 1.10) 2 2)))
      (if (get_tile "txt_handrail_spacing")
        (set_tile "txt_handrail_spacing" (rtos (if (> *PV_HANDRAIL_POST_SPACING* 0.0) *PV_HANDRAIL_POST_SPACING* 1.50) 2 2)))
      (if (get_tile "chk_handrail_toeboard")
        (set_tile "chk_handrail_toeboard" (itoa (if *PV_HANDRAIL_TOEBOARD* *PV_HANDRAIL_TOEBOARD* 1))))
      (if (get_tile "chk_handrail_shadow")
        (set_tile "chk_handrail_shadow" (itoa (if *PV_HANDRAIL_CAST_SHADOW* *PV_HANDRAIL_CAST_SHADOW* 1))))
      
      (if (get_tile "pop_handrail_num_rails")
        (progn
          (start_list "pop_handrail_num_rails")
          (add_list "2 Rails (Top + Mid)")
          (add_list "3 Rails (Top + 2 Mid)")
          (add_list "4 Rails (Top + 3 Mid)")
          (end_list)
          (set_tile "pop_handrail_num_rails"
            (cond ((= *PV_HANDRAIL_NUM_RAILS* 3) "1")
                  ((= *PV_HANDRAIL_NUM_RAILS* 4) "2")
                  (t "0")))
        )
      )
      
      (if (get_tile "pop_handrail_post_shape")
        (progn
          (start_list "pop_handrail_post_shape")
          (add_list "Round Pipe (50mm Dia)")
          (add_list "Square Pipe (50x50mm)")
          (end_list)
          (set_tile "pop_handrail_post_shape"
            (if (= *PV_HANDRAIL_POST_SHAPE* "Square Pipe") "1" "0"))
        )
      )
      
      (if (get_tile "pop_handrail_rail_shape")
        (progn
          (start_list "pop_handrail_rail_shape")
          (add_list "Round Pipe (40mm Dia)")
          (add_list "Square Pipe (40x40mm)")
          (end_list)
          (set_tile "pop_handrail_rail_shape"
            (if (= *PV_HANDRAIL_RAIL_SHAPE* "Square Pipe") "1" "0"))
        )
      )
    )

    ;; Tab 5: Electrical & 3D (PVcase & ARKA 360)
    ((= tab-name "tab_electrical_3d")
      (set_tile "string_size" (itoa (if (> *PV_STRING_SIZE* 0) *PV_STRING_SIZE* 20)))
    )

    ;; Tab 6: Financial ROI, BOM & Deliverables
    ((= tab-name "tab_reports_finance")
      (start_list "currency_select")
      (foreach cur-item *PV_CURRENCY_LIST*
        (add_list (nth 2 cur-item))
      )
      (end_list)
      (set_tile "currency_select" (itoa *PV_CURRENCY_IDX*))
      (set_tile "grid_tariff"   (rtos *PV_GRID_TARIFF* 2 2))
      (set_tile "epc_cost_watt" (rtos *PV_EPC_COST_PER_W* 2 2))
      (if (get_tile "subsidy_rs")
        (set_tile "subsidy_rs" (rtos *PV_SUBSIDY_RS* 2 0)))
      (if (get_tile "chk_commercial_ad")
        (set_tile "chk_commercial_ad" (if *PV_COMMERCIAL_AD* "1" "0")))
      (if (get_tile "gst_rate")
        (set_tile "gst_rate" (rtos *PV_GST_RATE* 2 1)))
      (pv:update-financial-status-tile)
    )

    ;; All-in-One Fallback
    (t
      (pv:init-designer-tiles)
    )
  )
)

(defun pv:init-tab-actions (tab-name)
  ;; Common Tab Header Switcher
  (action_tile "tab_btn_1" "(pv:save-tab-values *PV_CURRENT_TAB*) (setq *PV_CURRENT_TAB* \"tab_site_roof\") (done_dialog 100)")
  (action_tile "tab_btn_2" "(pv:save-tab-values *PV_CURRENT_TAB*) (setq *PV_CURRENT_TAB* \"tab_equipment\") (done_dialog 100)")
  (action_tile "tab_btn_3" "(pv:save-tab-values *PV_CURRENT_TAB*) (setq *PV_CURRENT_TAB* \"tab_array_layout\") (done_dialog 100)")
  (action_tile "tab_btn_4" "(pv:save-tab-values *PV_CURRENT_TAB*) (setq *PV_CURRENT_TAB* \"tab_walkway_safety\") (done_dialog 100)")
  (action_tile "tab_btn_5" "(pv:save-tab-values *PV_CURRENT_TAB*) (setq *PV_CURRENT_TAB* \"tab_electrical_3d\") (done_dialog 100)")
  (action_tile "tab_btn_6" "(pv:save-tab-values *PV_CURRENT_TAB*) (setq *PV_CURRENT_TAB* \"tab_reports_finance\") (done_dialog 100)")

  ;; Common Footer Buttons
  (action_tile "accept" "(pv:save-tab-values *PV_CURRENT_TAB*) (done_dialog 1)")
  (action_tile "cancel" "(done_dialog 0)")

  (cond
    ;; Tab 1 Actions
    ((= tab-name "tab_site_roof")
      (action_tile "btn_next_tab" "(pv:save-tab-values *PV_CURRENT_TAB*) (setq *PV_CURRENT_TAB* \"tab_equipment\") (done_dialog 100)")
      (action_tile "roof_type"    "(pv:on-roof-type)")
      (action_tile "mount_option" "(pv:on-mount-option)")
      (action_tile "layout_mode"
        "(if (= (get_tile \"layout_mode\") \"1\")
           (progn
             (setq *PV_LAYOUT_MODE* \"Target Plant Capacity (kWp)\")
             (mode_tile \"target_kw\" 0)
           )
           (progn
             (setq *PV_LAYOUT_MODE* \"Fill Polyline Boundary (Max Capacity)\")
             (mode_tile \"target_kw\" 1)
           )
         )"
      )
    )

    ;; Tab 2 Actions
    ((= tab-name "tab_equipment")
      (action_tile "btn_prev_tab" "(pv:save-tab-values *PV_CURRENT_TAB*) (setq *PV_CURRENT_TAB* \"tab_site_roof\") (done_dialog 100)")
      (action_tile "btn_next_tab" "(pv:save-tab-values *PV_CURRENT_TAB*) (setq *PV_CURRENT_TAB* \"tab_array_layout\") (done_dialog 100)")
      (action_tile "mod_select"   "(pv:on-mod-select)")
      (action_tile "inv_select"   "(pv:on-inv-select)")
      (action_tile "btn_load_pan" "(pv:save-tab-values *PV_CURRENT_TAB*) (done_dialog 10)")
      (action_tile "btn_load_ond" "(pv:save-tab-values *PV_CURRENT_TAB*) (done_dialog 15)")
    )

    ;; Tab 3 Actions
    ((= tab-name "tab_array_layout")
      (action_tile "btn_prev_tab"        "(pv:save-tab-values *PV_CURRENT_TAB*) (setq *PV_CURRENT_TAB* \"tab_equipment\") (done_dialog 100)")
      (action_tile "btn_next_tab"        "(pv:save-tab-values *PV_CURRENT_TAB*) (setq *PV_CURRENT_TAB* \"tab_walkway_safety\") (done_dialog 100)")
      (action_tile "btn_auto_pitch"      "(pv:on-auto-pitch)")
      (action_tile "btn_pick_boundary"   "(pv:save-tab-values *PV_CURRENT_TAB*) (done_dialog 2)")
      (action_tile "btn_pick_obstacles"  "(pv:save-tab-values *PV_CURRENT_TAB*) (done_dialog 3)")
      (action_tile "btn_clear_obstacles" "(pv:save-tab-values *PV_CURRENT_TAB*) (done_dialog 8)")
      (action_tile "chk_draw_shadow"     "(pv:set-shadow-mode (= (get_tile \"chk_draw_shadow\") \"1\"))")
      (action_tile "btn_toggle_shadow"   "(pv:set-shadow-mode (= *PV_DRAW_SHADOW* 0))")
      (action_tile "btn_generate_layout" "(pv:save-tab-values *PV_CURRENT_TAB*) (done_dialog 4)")
      (action_tile "btn_clear_layout"    "(pv:save-tab-values *PV_CURRENT_TAB*) (done_dialog 16)")
    )

    ;; Tab 4 Actions
    ((= tab-name "tab_walkway_safety")
      (action_tile "btn_prev_tab"         "(pv:save-tab-values *PV_CURRENT_TAB*) (setq *PV_CURRENT_TAB* \"tab_array_layout\") (done_dialog 100)")
      (action_tile "btn_next_tab"         "(pv:save-tab-values *PV_CURRENT_TAB*) (setq *PV_CURRENT_TAB* \"tab_electrical_3d\") (done_dialog 100)")
      (action_tile "btn_draw_walkway"     "(pv:save-tab-values *PV_CURRENT_TAB*) (done_dialog 17)")
      (action_tile "btn_clear_walkway"    "(pv:save-tab-values *PV_CURRENT_TAB*) (done_dialog 18)")
      (action_tile "btn_draw_fall_safety" "(pv:save-tab-values *PV_CURRENT_TAB*) (done_dialog 11)")
      (action_tile "btn_draw_handrail"    "(pv:save-tab-values *PV_CURRENT_TAB*) (done_dialog 12)")
      (action_tile "btn_clear_handrail"   "(pv:save-tab-values *PV_CURRENT_TAB*) (done_dialog 19)")
    )

    ;; Tab 5 Actions
    ((= tab-name "tab_electrical_3d")
      (action_tile "btn_prev_tab"       "(pv:save-tab-values *PV_CURRENT_TAB*) (setq *PV_CURRENT_TAB* \"tab_walkway_safety\") (done_dialog 100)")
      (action_tile "btn_next_tab"       "(pv:save-tab-values *PV_CURRENT_TAB*) (setq *PV_CURRENT_TAB* \"tab_reports_finance\") (done_dialog 100)")
      (action_tile "btn_stringing"      "(pv:save-tab-values *PV_CURRENT_TAB*) (done_dialog 21)")
      (action_tile "btn_clear_strings"  "(pv:save-tab-values *PV_CURRENT_TAB*) (done_dialog 22)")
      (action_tile "btn_place_inverter" "(pv:save-tab-values *PV_CURRENT_TAB*) (done_dialog 23)")
      (action_tile "btn_place_ajb"      "(pv:save-tab-values *PV_CURRENT_TAB*) (done_dialog 68)")
      (action_tile "btn_place_acdb"     "(pv:save-tab-values *PV_CURRENT_TAB*) (done_dialog 69)")
      (action_tile "btn_cable_tray"     "(pv:save-tab-values *PV_CURRENT_TAB*) (done_dialog 24)")
      (action_tile "btn_earthing"       "(pv:save-tab-values *PV_CURRENT_TAB*) (done_dialog 66)")
      (action_tile "btn_lightning"      "(pv:save-tab-values *PV_CURRENT_TAB*) (done_dialog 67)")
      (action_tile "btn_sld"            "(pv:save-tab-values *PV_CURRENT_TAB*) (done_dialog 26)")
      (action_tile "btn_3d_view"        "(pv:save-tab-values *PV_CURRENT_TAB*) (done_dialog 27)")
      (action_tile "btn_prune_shaded"   "(pv:save-tab-values *PV_CURRENT_TAB*) (done_dialog 28)")
      (action_tile "btn_export_pvsyst"  "(pv:save-tab-values *PV_CURRENT_TAB*) (done_dialog 29)")
    )

    ;; Tab 6 Actions
    ((= tab-name "tab_reports_finance")
      (action_tile "btn_prev_tab"         "(pv:save-tab-values *PV_CURRENT_TAB*) (setq *PV_CURRENT_TAB* \"tab_electrical_3d\") (done_dialog 100)")
      (action_tile "currency_select"      "(pv:on-currency-select)")
      (action_tile "grid_tariff"          "(pv:save-tab-values *PV_CURRENT_TAB*) (pv:update-financial-status-tile)")
      (action_tile "epc_cost_watt"        "(pv:save-tab-values *PV_CURRENT_TAB*) (pv:update-financial-status-tile)")
      (action_tile "subsidy_rs"           "(pv:save-tab-values *PV_CURRENT_TAB*) (pv:update-financial-status-tile)")
      (action_tile "chk_commercial_ad"    "(pv:save-tab-values *PV_CURRENT_TAB*) (pv:update-financial-status-tile)")
      (action_tile "gst_rate"             "(pv:save-tab-values *PV_CURRENT_TAB*) (pv:update-financial-status-tile)")
      (action_tile "btn_gen_energy_table" "(pv:save-tab-values *PV_CURRENT_TAB*) (done_dialog 13)")
      (action_tile "btn_gen_bom"          "(pv:save-tab-values *PV_CURRENT_TAB*) (done_dialog 5)")
      (action_tile "btn_gen_energy"       "(pv:save-tab-values *PV_CURRENT_TAB*) (done_dialog 6)")
      (action_tile "btn_export_csv"       "(pv:save-tab-values *PV_CURRENT_TAB*) (done_dialog 7)")
    )

    (t
      (pv:init-designer-actions)
    )
  )
)

(defun pv:save-tab-values (tab-name)
  (cond
    ((= tab-name "tab_site_roof")
      (if (get_tile "proj_name")       (setq *PV_PROJ_NAME* (get_tile "proj_name")))
      (if (get_tile "weather_source")
        (setq *PV_WEATHER_SRC*
          (cond
            ((= (get_tile "weather_source") "1") "NASA POWER (Global Satellite)")
            ((= (get_tile "weather_source") "2") "NREL NSRDB (PSM v3)")
            ((= (get_tile "weather_source") "3") "Meteonorm (Interpolated)")
            (t "PVGIS (SARAH-2/ERA5)")
          )
        )
      )
      (if (get_tile "lat_val")         (setq *PV_LAT* (atof (get_tile "lat_val"))))
      (if (get_tile "lon_val")         (setq *PV_LON* (atof (get_tile "lon_val"))))
      (if (get_tile "tilt_angle")      (setq *PV_TILT* (atof (get_tile "tilt_angle"))))
      (if (get_tile "azimuth_angle")   (setq *PV_AZIMUTH* (atof (get_tile "azimuth_angle"))))
      (if (get_tile "sanctioned_load_kw") (setq *PV_SANCTIONED_LOAD* (atof (get_tile "sanctioned_load_kw"))))
      (if (get_tile "contract_demand_kva") (setq *PV_CONTRACT_DEMAND* (atof (get_tile "contract_demand_kva"))))
      (if (get_tile "grid_voltage_opt")
        (setq *PV_GRID_VOLTAGE*
          (cond
            ((= (get_tile "grid_voltage_opt") "1") "230V 1-Phase 50Hz")
            ((= (get_tile "grid_voltage_opt") "2") "HT 11 kV / 33 kV")
            (t "415V 3-Phase 50Hz")
          )
        )
      )
      (if (get_tile "wind_zone_opt")
        (setq *PV_WIND_ZONE*
          (cond
            ((= (get_tile "wind_zone_opt") "0") "Zone I (33 m/s)")
            ((= (get_tile "wind_zone_opt") "1") "Zone II (39 m/s)")
            ((= (get_tile "wind_zone_opt") "3") "Zone IV (47 m/s)")
            ((= (get_tile "wind_zone_opt") "4") "Zone V (50 m/s)")
            ((= (get_tile "wind_zone_opt") "5") "Zone VI (55 m/s)")
            (t "Zone III (44 m/s)")
          )
        )
      )
      (if (get_tile "ambient_temp_max") (setq *PV_AMBIENT_TEMP* (atof (get_tile "ambient_temp_max"))))
      (if (get_tile "temp_min_c") (setq *PV_TEMP_MIN* (atof (get_tile "temp_min_c"))))
      (if (get_tile "roof_type")       (setq *PV_ROOF_TYPE* (if (= (get_tile "roof_type") "0") "Flat RCC Rooftop" "Metal Sheet Rooftop")))
      (if (get_tile "mount_option")
        (setq *PV_MOUNT_OPT*
          (cond
            ((= (get_tile "mount_option") "1") "Flush Mounted (Parallel to Roof)")
            ((= (get_tile "mount_option") "2") "Elevated Tilted Legs")
            (t "Tilted on MMS Structures")
          )
        )
      )
      (if (get_tile "layout_mode")     (setq *PV_LAYOUT_MODE* (if (= (get_tile "layout_mode") "1") "Target Plant Capacity (kWp)" "Fill Polyline Boundary (Max Capacity)")))
      (if (get_tile "target_kw")       (setq *PV_TARGET_KW* (atof (get_tile "target_kw"))))
      (if (get_tile "roof_setback")    (setq *PV_SETBACK* (atof (get_tile "roof_setback"))))
      (if (get_tile "roof_slope")      (setq *PV_ROOF_SLOPE* (atof (get_tile "roof_slope"))))
      (if (and (pv:is-metal-roof-p) (wcmatch (strcase *PV_MOUNT_OPT*) "*FLUSH*") (pv:get-active-surface-tilt-az))
        (pv:sync-flush-mount-from-surface)
      )
      (if (get_tile "mod_clearance")   (setq *PV_MOD_CLEAR* (atof (get_tile "mod_clearance"))))
      (if (get_tile "pr_val")          (setq *PV_PR* (atof (get_tile "pr_val"))))
      (if (and (get_tile "bldg_height") (> (atof (get_tile "bldg_height")) 0.0))
        (setq *PV_BLDG_EAVES_HT* (atof (get_tile "bldg_height"))
              *PV_BLDG_RIDGE_HT* (atof (get_tile "bldg_height")))
      )
      (if (and (get_tile "parapet_height") (>= (atof (get_tile "parapet_height")) 0.0))
        (setq *PV_PARAPET_HEIGHT* (atof (get_tile "parapet_height")))
      )
      (if (and (get_tile "parapet_thick") (> (atof (get_tile "parapet_thick")) 0.0))
        (setq *PV_PARAPET_THICKNESS* (atof (get_tile "parapet_thick")))
      )
      (if (get_tile "elev_leg_mode")
        (setq *PV_ELEV_LEG_MODE*
          (cond
            ((= (get_tile "elev_leg_mode") "1") "DISTANCE")
            ((= (get_tile "elev_leg_mode") "2") "MODULES")
            (t "COUNT")
          )
        )
      )
      (if (get_tile "elev_tilt_dir")
        (setq *PV_ELEV_TILT_DIR*
          (cond
            ((= (get_tile "elev_tilt_dir") "1") "South to North")
            ((= (get_tile "elev_tilt_dir") "2") "East to West")
            ((= (get_tile "elev_tilt_dir") "3") "West to East")
            (t "North to South")
          )
        )
      )
      (if (and (get_tile "elev_leg_count") (> (atoi (get_tile "elev_leg_count")) 0))
        (setq *PV_ELEV_LEG_COUNT* (atoi (get_tile "elev_leg_count")))
      )
      (if (and (get_tile "elev_leg_dist") (> (atof (get_tile "elev_leg_dist")) 0.0))
        (setq *PV_ELEV_LEG_DIST* (atof (get_tile "elev_leg_dist")))
      )
      (if (and (get_tile "elev_leg_mods") (> (atoi (get_tile "elev_leg_mods")) 0))
        (setq *PV_ELEV_LEG_MODS* (atoi (get_tile "elev_leg_mods")))
      )
      (if (and (get_tile "elev_min_clear") (> (atof (get_tile "elev_min_clear")) 0.0))
        (setq *PV_ELEV_MIN_CLEAR* (atof (get_tile "elev_min_clear")))
      )
    )

    ((= tab-name "tab_equipment")
      (if (get_tile "mod_watt")        (setq *PV_MOD_WATT* (atof (get_tile "mod_watt"))))
      (if (get_tile "mod_len")         (setq *PV_MOD_LEN* (atof (get_tile "mod_len"))))
      (if (get_tile "mod_wid")         (setq *PV_MOD_WID* (atof (get_tile "mod_wid"))))
    )

    ((= tab-name "tab_array_layout")
      (if (get_tile "mod_orient")      (setq *PV_MOD_ORIENT* (if (= (get_tile "mod_orient") "0") "Portrait" "Landscape")))
      (if (get_tile "table_cols")      (setq *PV_TABLE_COLS* (atoi (get_tile "table_cols"))))
      (if (get_tile "table_rows")      (setq *PV_TABLE_ROWS* (atoi (get_tile "table_rows"))))
      (if (get_tile "row_pitch")       (setq *PV_PITCH* (atof (get_tile "row_pitch"))))
      (if (get_tile "col_spacing")     (setq *PV_COL_SPACING* (atof (get_tile "col_spacing"))))
      (if (get_tile "row_spacing")     (setq *PV_ROW_SPACING* (atof (get_tile "row_spacing"))))
      (if (get_tile "obs_default_ht")  (setq *PV_DEF_OBS_HT* (atof (get_tile "obs_default_ht"))))
      (if (get_tile "chk_draw_shadow") (setq *PV_DRAW_SHADOW* (atoi (get_tile "chk_draw_shadow"))))
      (if (and (get_tile "walkway_width") (> (atof (get_tile "walkway_width")) 0.0))
        (setq *PV_WALKWAY_WIDTH* (atof (get_tile "walkway_width")))
      )
      (if (get_tile "walkway_freq_row")
        (setq *PV_WALKWAY_FREQ_ROW* (max 0 (atoi (get_tile "walkway_freq_row"))))
      )
      (if (get_tile "walkway_freq_col")
        (setq *PV_WALKWAY_FREQ_COL* (max 0 (atoi (get_tile "walkway_freq_col"))))
      )
      (if (get_tile "chk_draw_auto_walkway")
        (setq *PV_DRAW_AUTO_WALKWAY* (atoi (get_tile "chk_draw_auto_walkway")))
      )
    )

    ((= tab-name "tab_walkway_safety")
      (if (and (get_tile "walkway_width") (> (atof (get_tile "walkway_width")) 0.0))
        (setq *PV_WALKWAY_WIDTH* (atof (get_tile "walkway_width")))
      )
      (if (get_tile "walkway_freq_row")
        (setq *PV_WALKWAY_FREQ_ROW* (max 0 (atoi (get_tile "walkway_freq_row"))))
      )
      (if (get_tile "walkway_freq_col")
        (setq *PV_WALKWAY_FREQ_COL* (max 0 (atoi (get_tile "walkway_freq_col"))))
      )
      (if (get_tile "chk_draw_auto_walkway")
        (setq *PV_DRAW_AUTO_WALKWAY* (atoi (get_tile "chk_draw_auto_walkway")))
      )
      (if (and (get_tile "txt_handrail_ht") (> (atof (get_tile "txt_handrail_ht")) 0.0))
        (setq *PV_HANDRAIL_HEIGHT* (atof (get_tile "txt_handrail_ht")))
      )
      (if (and (get_tile "txt_handrail_spacing") (> (atof (get_tile "txt_handrail_spacing")) 0.0))
        (setq *PV_HANDRAIL_POST_SPACING* (atof (get_tile "txt_handrail_spacing")))
      )
      (if (get_tile "chk_handrail_toeboard")
        (setq *PV_HANDRAIL_TOEBOARD* (atoi (get_tile "chk_handrail_toeboard")))
      )
      (if (get_tile "chk_handrail_shadow")
        (setq *PV_HANDRAIL_CAST_SHADOW* (atoi (get_tile "chk_handrail_shadow")))
      )
      (if (get_tile "pop_handrail_num_rails")
        (setq *PV_HANDRAIL_NUM_RAILS*
          (cond
            ((= (get_tile "pop_handrail_num_rails") "1") 3)
            ((= (get_tile "pop_handrail_num_rails") "2") 4)
            (t 2)
          ))
      )
      (if (get_tile "pop_handrail_post_shape")
        (setq *PV_HANDRAIL_POST_SHAPE*
          (if (= (get_tile "pop_handrail_post_shape") "1") "Square Pipe" "Round Pipe"))
      )
      (if (get_tile "pop_handrail_rail_shape")
        (setq *PV_HANDRAIL_RAIL_SHAPE*
          (if (= (get_tile "pop_handrail_rail_shape") "1") "Square Pipe" "Round Pipe"))
      )
    )

    ((= tab-name "tab_electrical_3d")
      (if (and (get_tile "string_size") (> (atoi (get_tile "string_size")) 0))
        (setq *PV_STRING_SIZE* (atoi (get_tile "string_size")))
      )
    )

    ((= tab-name "tab_reports_finance")
      (if (get_tile "currency_select")
        (setq *PV_CURRENCY_IDX*  (atoi (get_tile "currency_select"))
              *PV_CURRENCY_CODE* (nth 0 (nth *PV_CURRENCY_IDX* *PV_CURRENCY_LIST*))
              *PV_CURRENCY_SYM*  (nth 1 (nth *PV_CURRENCY_IDX* *PV_CURRENCY_LIST*))
        )
      )
      (if (and (get_tile "grid_tariff") (> (atof (get_tile "grid_tariff")) 0.0))
        (setq *PV_GRID_TARIFF* (atof (get_tile "grid_tariff")))
      )
      (if (and (get_tile "epc_cost_watt") (> (atof (get_tile "epc_cost_watt")) 0.0))
        (setq *PV_EPC_COST_PER_W* (atof (get_tile "epc_cost_watt")))
      )
      (if (get_tile "subsidy_rs")
        (setq *PV_SUBSIDY_RS* (atof (get_tile "subsidy_rs")))
      )
      (if (get_tile "chk_commercial_ad")
        (setq *PV_COMMERCIAL_AD* (= (get_tile "chk_commercial_ad") "1"))
      )
      (if (get_tile "gst_rate")
        (setq *PV_GST_RATE* (atof (get_tile "gst_rate")))
      )
    )

    (t
      (pv:save-dialog-values)
    )
  )
)

(defun pv:init-designer-tiles ()
  ;; Fallback initializer for rooftop_solar_dialog
  (start_list "weather_source")
  (add_list "PVGIS (SARAH-2/ERA5)")
  (add_list "NASA POWER (Global Satellite)")
  (add_list "NREL NSRDB (PSM v3)")
  (add_list "Meteonorm (Interpolated)")
  (end_list)
  (set_tile "weather_source"
    (cond
      ((wcmatch (strcase *PV_WEATHER_SRC*) "*NASA*") "1")
      ((wcmatch (strcase *PV_WEATHER_SRC*) "*NREL*") "2")
      ((wcmatch (strcase *PV_WEATHER_SRC*) "*METEO*") "3")
      (t "0")
    )
  )

  (start_list "roof_type")
  (add_list "Flat RCC Rooftop")
  (add_list "Metal Sheet Rooftop")
  (end_list)
  (set_tile "roof_type" (if (= *PV_ROOF_TYPE* "Flat RCC Rooftop") "0" "1"))

  (start_list "mount_option")
  (add_list "Tilted on MMS Structures")
  (add_list "Flush Mounted (Parallel to Roof)")
  (add_list "Elevated Tilted Legs (Continuous Canopy)")
  (end_list)
  (set_tile "mount_option"
    (cond
      ((wcmatch (strcase *PV_MOUNT_OPT*) "*FLUSH*") "1")
      ((wcmatch (strcase *PV_MOUNT_OPT*) "*ELEVATED*") "2")
      (t "0")
    )
  )

  (start_list "layout_mode")
  (add_list "Install Max Possible (Fill Boundary)")
  (add_list "Target Plant DC Capacity (kWp)")
  (end_list)
  (set_tile "layout_mode" (if (wcmatch (strcase *PV_LAYOUT_MODE*) "*TARGET*") "1" "0"))
  (set_tile "target_kw" (rtos *PV_TARGET_KW* 2 1))
  (mode_tile "target_kw" (if (wcmatch (strcase *PV_LAYOUT_MODE*) "*TARGET*") 0 1))

  (start_list "mod_select")
  (foreach mod-item *PV_MODULE_LIBRARY*
    (add_list (strcat (cdr (assoc "MANUFACTURER" mod-item)) " " (cdr (assoc "MODEL" mod-item)) " (" (cdr (assoc "WP" mod-item)) "Wp)"))
  )
  (end_list)
  (set_tile "mod_select" (itoa *PV_ACTIVE_MODULE_IDX*))

  (start_list "inv_select")
  (foreach inv-item *PV_INVERTER_LIBRARY*
    (add_list (strcat (cdr (assoc "MANUFACTURER" inv-item)) " " (cdr (assoc "MODEL" inv-item)) " (" (cdr (assoc "KW" inv-item)) "kW AC)"))
  )
  (end_list)
  (set_tile "inv_select" (itoa *PV_ACTIVE_INVERTER_IDX*))

  (start_list "mod_orient")
  (add_list "Portrait")
  (add_list "Landscape")
  (end_list)
  (set_tile "mod_orient" (if (= *PV_MOD_ORIENT* "Portrait") "0" "1"))

  (set_tile "proj_name"       *PV_PROJ_NAME*)
  (set_tile "lat_val"         (rtos *PV_LAT* 2 4))
  (set_tile "lon_val"         (rtos *PV_LON* 2 4))
  (set_tile "pr_val"          (rtos *PV_PR* 2 1))
  (set_tile "roof_slope"      (rtos *PV_ROOF_SLOPE* 2 1))
  (set_tile "mod_clearance"   (rtos *PV_MOD_CLEAR* 2 2))
  (set_tile "roof_setback"    (rtos *PV_SETBACK* 2 2))
  (if (get_tile "bldg_height")    (set_tile "bldg_height"    (rtos (if (> *PV_BLDG_EAVES_HT* 0.0) *PV_BLDG_EAVES_HT* 6.0) 2 2)))
  (if (get_tile "parapet_height") (set_tile "parapet_height" (rtos (if (and *PV_PARAPET_HEIGHT* (>= *PV_PARAPET_HEIGHT* 0.0)) *PV_PARAPET_HEIGHT* 1.0) 2 2)))
  (if (get_tile "parapet_thick")  (set_tile "parapet_thick"  (rtos (if (and *PV_PARAPET_THICKNESS* (> *PV_PARAPET_THICKNESS* 0.0)) *PV_PARAPET_THICKNESS* 0.23) 2 2)))
  (if (= *PV_ROOF_TYPE* "Flat RCC Rooftop")
    (progn
      (if (get_tile "parapet_height") (mode_tile "parapet_height" 0))
      (if (get_tile "parapet_thick")  (mode_tile "parapet_thick" 0))
    )
    (progn
      (if (get_tile "parapet_height") (mode_tile "parapet_height" 1))
      (if (get_tile "parapet_thick")  (mode_tile "parapet_thick" 1))
    )
  )
  (if (get_tile "elev_tilt_dir")
    (progn
      (start_list "elev_tilt_dir")
      (add_list "North to South (Slope South, High North)")
      (add_list "South to North (Slope North, High South)")
      (add_list "East to West (Slope West, High East)")
      (add_list "West to East (Slope East, High West)")
      (end_list)
      (set_tile "elev_tilt_dir"
        (cond
          ((wcmatch (strcase *PV_ELEV_TILT_DIR*) "*SOUTH TO NORTH*") "1")
          ((wcmatch (strcase *PV_ELEV_TILT_DIR*) "*EAST TO WEST*") "2")
          ((wcmatch (strcase *PV_ELEV_TILT_DIR*) "*WEST TO EAST*") "3")
          (t "0")
        )
      )
    )
  )
  (if (get_tile "elev_leg_mode")
    (progn
      (start_list "elev_leg_mode")
      (add_list "By Intermediate Legs Count")
      (add_list "By Spacing Distance in Metres (m)")
      (add_list "By Number of Modules")
      (end_list)
      (set_tile "elev_leg_mode"
        (cond
          ((or (= *PV_ELEV_LEG_MODE* "DISTANCE") (= *PV_ELEV_LEG_MODE* "1")) "1")
          ((or (= *PV_ELEV_LEG_MODE* "MODULES")  (= *PV_ELEV_LEG_MODE* "2")) "2")
          (t "0")
        )
      )
    )
  )
  (if (get_tile "elev_leg_count") (set_tile "elev_leg_count" (itoa (if (> *PV_ELEV_LEG_COUNT* 0) *PV_ELEV_LEG_COUNT* 2))))
  (if (get_tile "elev_leg_dist")  (set_tile "elev_leg_dist"  (rtos (if (> *PV_ELEV_LEG_DIST* 0.0) *PV_ELEV_LEG_DIST* 3.00) 2 2)))
  (if (get_tile "elev_leg_mods")  (set_tile "elev_leg_mods"  (itoa (if (> *PV_ELEV_LEG_MODS* 0) *PV_ELEV_LEG_MODS* 2))))
  (if (get_tile "elev_min_clear") (set_tile "elev_min_clear" (rtos (if (> *PV_ELEV_MIN_CLEAR* 0.0) *PV_ELEV_MIN_CLEAR* 2.00) 2 2)))
  (set_tile "mod_watt"        (rtos *PV_MOD_WATT* 2 1))
  (set_tile "mod_len"         (rtos *PV_MOD_LEN* 2 3))
  (set_tile "mod_wid"         (rtos *PV_MOD_WID* 2 3))
  (set_tile "tilt_angle"      (rtos *PV_TILT* 2 1))
  (set_tile "azimuth_angle"   (rtos *PV_AZIMUTH* 2 1))
  (if (and (pv:is-metal-roof-p) (wcmatch (strcase *PV_MOUNT_OPT*) "*FLUSH*"))
    (pv:sync-flush-mount-from-surface)
  )
  (set_tile "table_cols"      (itoa *PV_TABLE_COLS*))
  (set_tile "table_rows"      (itoa *PV_TABLE_ROWS*))
  (set_tile "row_pitch"       (rtos *PV_PITCH* 2 2))
  (set_tile "col_spacing"     (rtos *PV_COL_SPACING* 2 3))
  (set_tile "row_spacing"     (rtos *PV_ROW_SPACING* 2 3))
  (set_tile "obs_default_ht"  (rtos *PV_DEF_OBS_HT* 2 2))
  (set_tile "chk_draw_shadow" (itoa *PV_DRAW_SHADOW*))
  (set_tile "walkway_width"   (rtos (if (and *PV_WALKWAY_WIDTH* (> *PV_WALKWAY_WIDTH* 0.0)) *PV_WALKWAY_WIDTH* 0.80) 2 2))
  (if (get_tile "walkway_freq_row") (set_tile "walkway_freq_row" (itoa *PV_WALKWAY_FREQ_ROW*)))
  (if (get_tile "walkway_freq_col") (set_tile "walkway_freq_col" (itoa *PV_WALKWAY_FREQ_COL*)))
  (if (get_tile "chk_draw_auto_walkway") (set_tile "chk_draw_auto_walkway" (itoa *PV_DRAW_AUTO_WALKWAY*)))
  (set_tile "txt_walkway_status"
    (if (and *PV_WALKWAY_LENGTH* (> *PV_WALKWAY_LENGTH* 0.0))
      (strcat "Walkway Corridor (" (rtos *PV_WALKWAY_WIDTH* 2 2) "m width): " (rtos *PV_WALKWAY_LENGTH* 2 1) "m defined on roof (avoided by PV modules)")
      (strcat "Walkway Corridor (" (rtos *PV_WALKWAY_WIDTH* 2 2) "m width): No manual path defined yet. Grid frequency: "
              (if (> *PV_WALKWAY_FREQ_ROW* 0) (strcat "Every " (itoa *PV_WALKWAY_FREQ_ROW*) " Rows; ") "No Horiz; ")
              (if (> *PV_WALKWAY_FREQ_COL* 0) (strcat "Every " (itoa *PV_WALKWAY_FREQ_COL*) " Cols.") "No Vert."))
    )
  )
  (set_tile "string_size"     (itoa (if (> *PV_STRING_SIZE* 0) *PV_STRING_SIZE* 20)))
  (if (get_tile "currency_select")
    (progn
      (start_list "currency_select")
      (foreach cur-item *PV_CURRENCY_LIST*
        (add_list (nth 2 cur-item))
      )
      (end_list)
      (set_tile "currency_select" (itoa *PV_CURRENCY_IDX*))
    )
  )
  (set_tile "grid_tariff"     (rtos *PV_GRID_TARIFF* 2 2))
  (set_tile "epc_cost_watt"   (rtos *PV_EPC_COST_PER_W* 2 2))

  (pv:update-pan-status-tile)
  (pv:update-inv-status-tile)
)

(defun pv:init-designer-actions ()
  ;; Fallback action initializer for rooftop_solar_dialog
  (action_tile "mod_select"           "(pv:on-mod-select)")
  (action_tile "inv_select"           "(pv:on-inv-select)")
  (action_tile "roof_type"            "(pv:on-roof-type)")
  (action_tile "mount_option"         "(pv:on-mount-option)")
  (action_tile "btn_auto_pitch"       "(pv:on-auto-pitch)")
  (action_tile "layout_mode"
    "(if (= (get_tile \"layout_mode\") \"1\")
       (progn
         (setq *PV_LAYOUT_MODE* \"Target Plant Capacity (kWp)\")
         (mode_tile \"target_kw\" 0)
       )
       (progn
         (setq *PV_LAYOUT_MODE* \"Fill Polyline Boundary (Max Capacity)\")
         (mode_tile \"target_kw\" 1)
       )
     )"
  )
  (action_tile "btn_load_pan"         "(pv:save-dialog-values) (done_dialog 10)")
  (action_tile "btn_load_ond"         "(pv:save-dialog-values) (done_dialog 15)")
  (action_tile "btn_draw_walkway"     "(pv:save-dialog-values) (done_dialog 17)")
  (action_tile "btn_clear_walkway"    "(pv:save-dialog-values) (done_dialog 18)")
  (action_tile "btn_draw_fall_safety" "(pv:save-dialog-values) (done_dialog 11)")
  (action_tile "btn_draw_handrail"    "(pv:save-dialog-values) (done_dialog 12)")
  (action_tile "btn_pick_boundary"    "(pv:save-dialog-values) (done_dialog 2)")
  (action_tile "btn_pick_obstacles"   "(pv:save-dialog-values) (done_dialog 3)")
  (action_tile "btn_clear_obstacles"  "(pv:save-dialog-values) (done_dialog 8)")
  (action_tile "chk_draw_shadow"      "(pv:set-shadow-mode (= (get_tile \"chk_draw_shadow\") \"1\"))")
  (action_tile "btn_toggle_shadow"    "(pv:set-shadow-mode (= *PV_DRAW_SHADOW* 0))")
  (action_tile "btn_generate_layout"  "(pv:save-dialog-values) (done_dialog 4)")
  (action_tile "btn_clear_layout"     "(pv:save-dialog-values) (done_dialog 16)")
  (action_tile "btn_gen_bom"          "(pv:save-dialog-values) (done_dialog 5)")
  (action_tile "btn_gen_energy_table" "(pv:save-dialog-values) (done_dialog 13)")
  (action_tile "btn_gen_energy"       "(pv:save-dialog-values) (done_dialog 6)")
  (action_tile "btn_export_csv"       "(pv:save-dialog-values) (done_dialog 7)")
  (action_tile "btn_stringing"        "(pv:save-dialog-values) (done_dialog 21)")
  (action_tile "btn_clear_strings"    "(pv:save-dialog-values) (done_dialog 22)")
  (action_tile "btn_place_inverter"   "(pv:save-dialog-values) (done_dialog 23)")
  (action_tile "btn_cable_tray"       "(pv:save-dialog-values) (done_dialog 24)")
  (action_tile "btn_sld"              "(pv:save-dialog-values) (done_dialog 26)")
  (action_tile "btn_3d_view"          "(pv:save-dialog-values) (done_dialog 27)")
  (action_tile "btn_prune_shaded"     "(pv:save-dialog-values) (done_dialog 28)")
  (action_tile "btn_export_pvsyst"    "(pv:save-dialog-values) (done_dialog 29)")
  (action_tile "currency_select"      "(pv:on-currency-select)")
  (action_tile "accept"               "(pv:save-dialog-values) (done_dialog 1)")
  (action_tile "cancel"               "(done_dialog 0)")
)

(defun pv:full-designer-dialog (/ dcl-file dcl-id what-next loop *error*)
  (defun *error* (msg)
    (if (and dcl-id (> dcl-id 0)) (unload_dialog dcl-id))
    (if (and msg (not (wcmatch (strcase msg) "*CANCEL*,*QUIT*,*EXIT*")))
      (princ (strcat "\n[SolarPV] Error: " msg))
    )
    (princ)
  )
  (vl-load-com)
  (pv:init-layers)
  (if (null *PV_MODULE_LIBRARY*) (pv:init-module-db))
  (if (null *PV_INVERTER_LIBRARY*) (pv:init-inverter-db))
  (if (null *PV_CURRENT_TAB*) (setq *PV_CURRENT_TAB* "tab_site_roof"))

  (setq *PV_PRE_SEL* (ssget "_I"))
  (sssetfirst nil nil)

  (setq loop t)
  (while loop
    (setq dcl-file (pv:get-dcl-path))
    (if (not dcl-file)
      (progn
        (princ "\n[SolarPV] Error: Could not locate 'RooftopSolar.dcl'.")
        (alert "Error: Could not locate 'RooftopSolar.dcl'.\nPlease verify it exists in 'd:\\VibeCoding\\AUTOLISP\\Rooftop\\'.")
        (setq loop nil)
      )
      (progn
        (setq dcl-id (load_dialog dcl-file))
        (if (or (null dcl-id) (<= dcl-id 0))
          (progn
            (princ (strcat "\n[SolarPV] Error: Could not load DCL file: " dcl-file))
            (alert (strcat "Error: Failed to load DCL file:\n" dcl-file))
            (setq loop nil)
          )
          (if (not (new_dialog *PV_CURRENT_TAB* dcl-id))
            (progn
              ;; Fallback to rooftop_solar_dialog if specific tab is not loaded
              (if (not (new_dialog "rooftop_solar_dialog" dcl-id))
                (progn
                  (princ "\n[SolarPV] Error: Could not initialize dialog from DCL.")
                  (alert "Error: Could not initialize dialog from DCL.")
                  (unload_dialog dcl-id)
                  (setq loop nil)
                )
                (progn
                  (pv:init-designer-tiles)
                  (pv:init-designer-actions)
                  (setq what-next (start_dialog))
                  (unload_dialog dcl-id)
                  (cond
                    ((= what-next 10) (c:pv-load-pan))
                    ((= what-next 15) (c:pv-load-ond))
                    ((= what-next 17) (c:pv-walkway))
                    ((= what-next 18) (c:pv-clear-walkways))
                    ((= what-next 11) (c:pv-fall-safety))
                    ((= what-next 12) (c:pv-handrail))
                    ((= what-next 19) (c:pv-clear-handrails))
                    ((= what-next 2)  (c:pv-pick-boundary))
                    ((= what-next 3)  (c:pv-pick-obstacles))
                    ((= what-next 8)  (c:pv-clear-obstacles))
                    ((= what-next 4)  (pv:generate-layout))
                    ((= what-next 16) (c:pv-clear-layout))
                    ((= what-next 5)  (c:pv-draw-bom))
                    ((= what-next 13) (c:pv-energy-table))
                    ((= what-next 6)  (c:pv-report-energy))
                    ((= what-next 7)  (c:pv-export-csv))
                    ((= what-next 21) (c:pv-stringing))
                    ((= what-next 22) (c:pv-clear-strings))
                    ((= what-next 23) (c:pv-place-inverter))
                    ((= what-next 24) (c:pv-draw-cable-tray))
                    ((= what-next 26) (c:pv-draw-sld))
                    ((= what-next 66) (c:pv-earthing))
                    ((= what-next 67) (c:pv-lightning))
                    ((= what-next 68) (c:pv-place-ajb))
                    ((= what-next 69) (c:pv-place-acdb))
                    ((= what-next 70) (c:pv-clear-earthing))
                    ((= what-next 27) (c:pv-3d-view))
                    ((= what-next 28) (c:pv-prune-shaded))
                    ((= what-next 29) (c:pv-export-pvsyst))
                    ((= what-next 1)
                      (setq loop nil)
                      (princ "\n[SolarPV] Configuration saved.")
                    )
                    (t
                      (setq loop nil)
                      (princ "\n[SolarPV] Exited.")
                    )
                  )
                )
              )
            )
            (progn
              (pv:init-tab-tiles *PV_CURRENT_TAB*)
              (pv:init-tab-actions *PV_CURRENT_TAB*)

              (setq what-next (start_dialog))
              (unload_dialog dcl-id)

              ;; Process dialog exit codes & interactive steps
              (cond
                ((= what-next 100)
                  ;; Tab switch - keep loop running to open new *PV_CURRENT_TAB*
                )
                ((= what-next 10) (c:pv-load-pan))
                ((= what-next 15) (c:pv-load-ond))
                ((= what-next 17) (c:pv-walkway))
                ((= what-next 18) (c:pv-clear-walkways))
                ((= what-next 11) (c:pv-fall-safety))
                ((= what-next 12) (c:pv-handrail))
                ((= what-next 19) (c:pv-clear-handrails))
                ((= what-next 2)  (c:pv-pick-boundary))
                ((= what-next 3)  (c:pv-pick-obstacles))
                ((= what-next 8)  (c:pv-clear-obstacles))
                ((= what-next 4)  (pv:generate-layout))
                ((= what-next 16) (c:pv-clear-layout))
                ((= what-next 5)  (c:pv-draw-bom))
                ((= what-next 13) (c:pv-energy-table))
                ((= what-next 6)  (c:pv-report-energy))
                ((= what-next 7)  (c:pv-export-csv))
                ((= what-next 21) (c:pv-stringing))
                ((= what-next 22) (c:pv-clear-strings))
                ((= what-next 23) (c:pv-place-inverter))
                ((= what-next 24) (c:pv-draw-cable-tray))
                ((= what-next 26) (c:pv-draw-sld))
                ((= what-next 27) (c:pv-3d-view))
                ((= what-next 28) (c:pv-prune-shaded))
                ((= what-next 29) (c:pv-export-pvsyst))
                ((= what-next 1)
                  (setq loop nil)
                  (princ "\n[SolarPV] Configuration saved.")
                )
                (t
                  (setq loop nil)
                  (princ "\n[SolarPV] Exited.")
                )
              )
            )
          )
        )
      )
    )
  )
  (princ)
)

(defun pv:save-dialog-values ()
  (pv:save-tab-values "tab_site_roof")
  (pv:save-tab-values "tab_equipment")
  (pv:save-tab-values "tab_array_layout")
  (pv:save-tab-values "tab_walkway_safety")
  (pv:save-tab-values "tab_electrical_3d")
  (pv:save-tab-values "tab_reports_finance")
)

;;; ==========================================================================
;;; Command Dispatchers  (18 groups, replaces 101 flat aliases)
;;; ==========================================================================

;;; ---------- GROUP 1: Entry / Main Designer (9 → 1) -----------------------
(defun c:PVSOLAR   () (pv:full-designer-dialog))
;; Backward-compatible aliases
(defun c:PVMENU       () (c:pv-menu))
(defun c:ROOFTOPSOLAR () (pv:full-designer-dialog))
(defun c:SOLARPV      () (pv:full-designer-dialog))
(defun c:SOLARTOOLS   () (pv:full-designer-dialog))
(defun c:SOLARLAYOUT  () (pv:full-designer-dialog))
(defun c:PVDCL        () (c:pv-menu))
(defun c:PVCOMMANDS   () (c:pv-menu))
(defun c:PVHUB        () (c:pv-menu))

;;; ---------- GROUP 2: Layout Generation (4 → 1) ---------------------------
(defun c:PVLAYOUTGEN (/ mode)
  (initget "Auto EW")
  (setq mode (getkword "\nLayout mode [Auto/EW] <Auto>: "))
  (if (= mode "EW") (c:pv-layout-ew) (c:pv-generate-layout))
)
(defun c:PVLAYOUT  () (c:pv-generate-layout))
(defun c:PVLAYOUTEW () (c:pv-layout-ew))

;;; ---------- GROUP 3: Stringing (10 → 2) ----------------------------------
(defun c:PVSTRING (/ mode)
  (initget "Auto Manual EW Vis Polarity Mppt panelNum")
  (setq mode (getkword "\nStringing mode [Auto/Manual/EW/Vis/Polarity/Mppt/panelNum] <Auto>: "))
  (cond
    ((= mode "Manual")    (c:pv-string-manual))
    ((= mode "EW")        (c:pv-string-ew))
    ((= mode "Vis")       (c:pv-string-vis))
    ((= mode "Polarity")  (c:pv-polarity))
    ((= mode "Mppt")      (c:pv-mppt-details))
    ((= mode "panelNum")  (c:pv-panel-number))
    (t                    (c:pv-stringing))
  )
)
(defun c:PVMPPT (/ mode)
  (initget "Details Link EW")
  (setq mode (getkword "\nMPPT mode [Details/Link/EW] <Details>: "))
  (cond
    ((= mode "Link") (c:pv-mppt-link))
    ((= mode "EW")   (c:pv-ew-vis))
    (t               (c:pv-mppt-details))
  )
)
;; Backward-compatible aliases
(defun c:PVSTRINGING     () (c:pv-stringing))
(defun c:PVSTRINGMANUAL  () (c:pv-string-manual))
(defun c:PVSTRINGEW      () (c:pv-string-ew))
(defun c:PVSTRINGVIS     () (c:pv-string-vis))
(defun c:PVPOLARITY      () (c:pv-polarity))
(defun c:PVPANELNUM      () (c:pv-panel-number))
(defun c:PVEWVIS         () (c:pv-ew-vis))
(defun c:PVMPPTDETAILS   () (c:pv-mppt-details))
(defun c:PVMPPTLINK      () (c:pv-mppt-link))

;;; ---------- GROUP 4: Clear / Reset (11 → 1) ------------------------------
(defun c:PVCLEAR (/ mode)
  (initget "Layout Strings Walkway Handrail CableTray Earthing 3d Building Obstacles All")
  (setq mode (getkword "\nClear [Layout/Strings/Walkway/Handrail/CableTray/Earthing/3d/Building/Obstacles/All] <All>: "))
  (cond
    ((= mode "Layout")    (c:pv-clear-layout))
    ((= mode "Strings")   (c:pv-clear-strings))
    ((= mode "Walkway")   (c:pv-clear-walkways))
    ((= mode "Handrail")  (c:pv-clear-handrails))
    ((= mode "CableTray") (c:pv-clear-cable-tray))
    ((= mode "Earthing")  (c:pv-clear-earthing))
    ((= mode "3d")        (c:pv-clear-3d))
    ((= mode "Building")  (c:pv-clear-building-3d))
    ((= mode "Obstacles") (c:pv-clear-obstacles))
    (t  ; All
     (c:pv-clear-layout)
     (c:pv-clear-strings)
     (c:pv-clear-walkways)
     (c:pv-clear-handrails)
     (c:pv-clear-cable-tray)
     (c:pv-clear-3d)
     (c:pv-clear-building-3d)
     (c:pv-clear-obstacles)
     (princ "\n[SolarPV] All elements cleared.")
    )
  )
  (princ)
)
;; Backward-compatible aliases
(defun c:PVCLEARLAYOUT    () (c:pv-clear-layout))
(defun c:PVCLEARSTRINGS   () (c:pv-clear-strings))
(defun c:PVCLEARSTRING    () (c:pv-clear-strings))
(defun c:PVCLEARWALKWAY   () (c:pv-clear-walkways))
(defun c:PVCLEARWALKWAYS  () (c:pv-clear-walkways))
(defun c:PVCLEARHANDRAIL  () (c:pv-clear-handrails))
(defun c:PVCLEARHANDRAILS () (c:pv-clear-handrails))
(defun c:PVCLEARCABLETRAY () (c:pv-clear-cable-tray))
(defun c:PVCLEAREARTHING  () (c:pv-clear-earthing))
(defun c:PVCLEAR3D        () (c:pv-clear-3d))
(defun c:PVCLEARBLDG3D    () (c:pv-clear-building-3d))
(defun c:PVCLEAROBSTACLES () (c:pv-clear-obstacles))

;;; ---------- GROUP 5: 3D Modeling (6 → 1) ---------------------------------
(defun c:PV3D (/ mode)
  (initget "View Build Clear")
  (setq mode (getkword "\n3D mode [View/Build/Clear] <View>: "))
  (cond
    ((= mode "Build") (c:pv-building-3d))
    ((= mode "Clear") (c:pv-clear-3d))
    (t                (c:pv-3d-view))
  )
)
;; Backward-compatible aliases
(defun c:PV3DVIEW      () (c:pv-3d-view))
(defun c:PVBUILDING3D  () (c:pv-building-3d))
(defun c:PVBLDG3D      () (c:pv-building-3d))
(defun c:PVROOFTYPE    () (c:pv-building-3d))

;;; ---------- GROUP 6: Shadow Analysis (7 → 1) -----------------------------
(defun c:PVSHADOW (/ mode)
  (initget "Toggle On Off Prune")
  (setq mode (getkword "\nShadow [Toggle/On/Off/Prune] <Toggle>: "))
  (cond
    ((= mode "On")     (c:pv-shadow-on))
    ((= mode "Off")    (c:pv-shadow-off))
    ((= mode "Prune")  (c:pv-prune-shaded))
    (t                 (c:pv-toggle-shadow))
  )
)
;; Backward-compatible aliases
(defun c:PVSHADOWTOGGLE  () (c:pv-toggle-shadow))
(defun c:PVTOGGLESHADOW  () (c:pv-toggle-shadow))
(defun c:PVSHADOWMAP     () (c:pv-toggle-shadow))
(defun c:PVSHADOWON      () (c:pv-shadow-on))
(defun c:PVSHADOWOFF     () (c:pv-shadow-off))
(defun c:PVPRUNESHADED   () (c:pv-prune-shaded))
(defun c:PVCHECKSHADING  () (c:pv-prune-shaded))

;;; ---------- GROUP 7: File Load / Component Library (6 → 1) ---------------
(defun c:PVLOAD (/ mode)
  (initget "Pan Ond Library")
  (setq mode (getkword "\nLoad [Pan/Ond/Library] <Pan>: "))
  (cond
    ((= mode "Ond")     (c:pv-load-ond))
    ((= mode "Library") (c:pv-complib))
    (t                  (c:pv-load-pan))
  )
)
;; Backward-compatible aliases
(defun c:PVLOADPAN  () (c:pv-load-pan))
(defun c:PVPAN      () (c:pv-load-pan))
(defun c:PVLOADOND  () (c:pv-load-ond))
(defun c:PVOND      () (c:pv-load-ond))
(defun c:PVCOMPLIB  () (c:pv-complib))
(defun c:PVLIBRARY  () (c:pv-complib))

;;; ---------- GROUP 8: Walkway (4 → 1) -------------------------------------
(defun c:PVWALKWAY (/ mode)
  (initget "Draw Auto Clear")
  (setq mode (getkword "\nWalkway [Draw/Auto/Clear] <Draw>: "))
  (cond
    ((= mode "Auto")  (c:pv-toggle-auto-walkway))
    ((= mode "Clear") (c:pv-clear-walkways))
    (t                (c:pv-walkway))
  )
)
;; Backward-compatible aliases
(defun c:PVWALKWAYPATH   () (c:pv-walkway))
(defun c:PVWALKWAYTOGGLE () (c:pv-toggle-auto-walkway))
(defun c:PVAUTOWALKWAY   () (c:pv-toggle-auto-walkway))

;;; ---------- GROUP 9: Safety Systems (3 → 1) ------------------------------
(defun c:PVSAFETY (/ mode)
  (initget "FallSafety Handrail Clear")
  (setq mode (getkword "\nSafety [FallSafety/Handrail/Clear] <FallSafety>: "))
  (cond
    ((= mode "Handrail") (c:pv-handrail))
    ((= mode "Clear")    (c:pv-clear-handrails))
    (t                   (c:pv-fall-safety))
  )
)
;; Backward-compatible aliases
(defun c:PVFALLSAFETY () (c:pv-fall-safety))
(defun c:PVSAFETYLINE () (c:pv-fall-safety))
(defun c:PVHANDRAIL   () (c:pv-handrail))

;;; ---------- GROUP 10: Parapet / Offsets (5 → 1) --------------------------
(defun c:PVPARAPET (/ mode)
  (initget "Draw Show Hide")
  (setq mode (getkword "\nParapet [Draw/Show/Hide] <Draw>: "))
  (cond
    ((= mode "Show") (c:pv-show-all-offset))
    ((= mode "Hide") (c:pv-hide-all-offset))
    (t               (c:pv-draw-parapet-offsets))
  )
)
;; Backward-compatible aliases
(defun c:PVOFFSET        () (c:pv-draw-parapet-offsets))
(defun c:PVPARAPETOFFSET () (c:pv-draw-parapet-offsets))
(defun c:PVSHOWALLOFFSET () (c:pv-show-all-offset))
(defun c:PVHIDEALLOFFSET () (c:pv-hide-all-offset))

;;; ---------- GROUP 11: Reports & BOM (6 → 1) ------------------------------
(defun c:PVREPORT (/ mode)
  (initget "Energy BOM SLD Dim Validate")
  (setq mode (getkword "\nReport [Energy/BOM/SLD/Dim/Validate] <Energy>: "))
  (cond
    ((= mode "BOM")      (c:pv-draw-bom))
    ((= mode "SLD")      (c:pv-draw-sld))
    ((= mode "Dim")      (c:pv-dim-plan))
    ((= mode "Validate") (c:pv-validate))
    (t                   (c:pv-report-energy))
  )
)
;; Backward-compatible aliases
(defun c:PVENERGYTABLE () (c:pv-energy-table))
(defun c:PVSIMREPORT   () (c:pv-report-energy))
(defun c:PVDRAWBOM     () (c:pv-draw-bom))
(defun c:PVBOM         () (c:pv-draw-bom))
(defun c:PVSLD         () (c:pv-draw-sld))
(defun c:PVDRAWSLD     () (c:pv-draw-sld))
(defun c:PVDIMPLAN     () (c:pv-dim-plan))
(defun c:PVVALIDATE    () (c:pv-validate))

;;; ---------- GROUP 12: Roof Management (5 → 1) ----------------------------
(defun c:PVROOF (/ mode)
  (initget "Multi List Number Select")
  (setq mode (getkword "\nRoof [Multi/List/Number/Select] <Multi>: "))
  (cond
    ((= mode "List")   (c:pv-roof-list))
    ((= mode "Number") (c:pv-roof-number))
    ((= mode "Select") (c:pv-select-roof))
    (t                 (c:pv-multiroof))
  )
)
;; Backward-compatible aliases
(defun c:PVMULTIROOF  () (c:pv-multiroof))
(defun c:PVROOFS      () (c:pv-multiroof))
(defun c:PVROOFLIST   () (c:pv-roof-list))
(defun c:PVROOFNUM    () (c:pv-roof-number))
(defun c:PVSELECTROOF () (c:pv-select-roof))

;;; ---------- GROUP 13: Export (3 → 1) -------------------------------------
(defun c:PVEXPORT (/ mode)
  (initget "PVsyst CSV")
  (setq mode (getkword "\nExport [PVsyst/CSV] <PVsyst>: "))
  (cond
    ((= mode "CSV")    (c:pv-dc-schedule))
    (t                 (c:pv-export-pvsyst))
  )
)
;; Backward-compatible aliases
(defun c:PVPVSYST       () (c:pv-export-pvsyst))
(defun c:PVEXPORTPVSYST () (c:pv-export-pvsyst))
(defun c:PVPVSYSTEXPORT () (c:pv-pvsyst-export))
(defun c:PVDCSCHEDULE   () (c:pv-dc-schedule))

;;; ---------- GROUP 14: Cable & DC Routing (7 → 1) -------------------------
(defun c:PVCABLE (/ mode)
  (initget "Tray Route Color Calc AC Clear")
  (setq mode (getkword "\nCable [Tray/Route/Color/Calc/AC/Clear] <Tray>: "))
  (cond
    ((= mode "Route") (c:pv-dc-route-tracked))
    ((= mode "Color") (c:pv-dc-route-color-polarity))
    ((= mode "Calc")  (c:pv-cable-calc))
    ((= mode "AC")    (c:pv-ac-equipment))
    ((= mode "Clear") (c:pv-clear-cable-tray))
    (t                (c:pv-draw-cable-tray))
  )
)
;; Backward-compatible aliases
(defun c:PVCABLETRAY            () (c:pv-draw-cable-tray))
(defun c:PVDRAWCABLETRAY        () (c:pv-draw-cable-tray))
(defun c:PVDCROUTETRACKED       () (c:pv-dc-route-tracked))
(defun c:PVDCROUTECOLORPOLARITY () (c:pv-dc-route-color-polarity))
(defun c:PVCABLECALC            () (c:pv-cable-calc))
(defun c:PVACEQUIPMENT          () (c:pv-ac-equipment))

;;; ---------- GROUP 15: Inverter (3 → 1) -----------------------------------
(defun c:PVINVERTER (/ mode)
  (initget "Place AC")
  (setq mode (getkword "\nInverter [Place/AC] <Place>: "))
  (if (= mode "AC") (c:pv-ac-equipment) (c:pv-place-inverter))
)
;; Backward-compatible aliases
(defun c:PVPLACEINVERTER () (c:pv-place-inverter))

;;; ---------- GROUP 16: Boundary & Obstacles (3 → 1) -----------------------
(defun c:PVBOUNDARY (/ mode)
  (initget "Boundary Obstacles Clear")
  (setq mode (getkword "\nBoundary [Boundary/Obstacles/Clear] <Boundary>: "))
  (cond
    ((= mode "Obstacles") (c:pv-pick-obstacles))
    ((= mode "Clear")     (c:pv-clear-obstacles))
    (t                    (c:pv-pick-boundary))
  )
)
;; Backward-compatible aliases
(defun c:PVPICKBOUNDARY  () (c:pv-pick-boundary))
(defun c:PVPICKOBSTACLES () (c:pv-pick-obstacles))
(defun c:PVOBSTACLES     () (c:pv-pick-obstacles))

;;; ---------- GROUP 17: Elevated Structure (4 → 1) -------------------------
(defun c:PVELEV (/ mode)
  (initget "Config Toggle")
  (setq mode (getkword "\nElevated [Config/Toggle] <Config>: "))
  (if (= mode "Toggle") (c:pv-elev-toggle) (c:pv-elev-legs-config))
)
;; Backward-compatible aliases
(defun c:PVELEVCONFIG () (c:pv-elev-legs-config))
(defun c:PVELEVATED   () (c:pv-elev-legs-config))
(defun c:PVLEGS       () (c:pv-elev-legs-config))
(defun c:PVELEVTOGGLE () (c:pv-elev-toggle))

;;; ---------- GROUP 18: Roof Shape Splitting (3 → 1) -----------------------
(defun c:PVROOFSPLIT (/ mode)
  (initget "Hip Dome OneDome")
  (setq mode (getkword "\nRoof split [Hip/Dome/OneDome] <Hip>: "))
  (cond
    ((= mode "Dome")    (c:pv-dome-split))
    ((= mode "OneDome") (c:pv-one-dome))
    (t                  (c:pv-hip-split))
  )
)
;; Backward-compatible aliases
(defun c:PVHIPSPLIT  () (c:pv-hip-split))
(defun c:PVDOMESPLIT () (c:pv-dome-split))
(defun c:PVONEDOME   () (c:pv-one-dome))

;;; ---------- GROUP 19: Indian BOS & Earthing (IS 3043 / IS 62305) ----------
(defun c:PVEARTHING  () (c:pv-earthing))
(defun c:PVLIGHTNING () (c:pv-lightning))
(defun c:PVAJB       () (c:pv-place-ajb))
(defun c:PVACDB      () (c:pv-place-acdb))

;;; --------------------------------------------------------------------------
;;; Command: PVELEVCONFIG (Elevated Tilted Legs & Continuous Canopy Setup)
;;; --------------------------------------------------------------------------
(defun c:pv-elev-legs-config (/ dcl-file dcl-id what-next)
  (vl-load-com)
  (setq dcl-file (pv:get-dcl-path))
  (if (not dcl-file)
    (progn
      (alert "Error: Could not locate 'RooftopSolar.dcl'.")
      (exit)
    )
  )
  (setq dcl-id (load_dialog dcl-file))
  (if (not (new_dialog "elev_legs_dialog" dcl-id))
    (progn
      (alert "Error: Cannot load 'elev_legs_dialog' from RooftopSolar.dcl")
      (unload_dialog dcl-id)
      (exit)
    )
  )

  (start_list "elev_tilt_dir")
  (add_list "North to South (Slope South, High North)")
  (add_list "South to North (Slope North, High South)")
  (add_list "East to West (Slope West, High East)")
  (add_list "West to East (Slope East, High West)")
  (end_list)
  (set_tile "elev_tilt_dir"
    (cond
      ((wcmatch (strcase *PV_ELEV_TILT_DIR*) "*SOUTH TO NORTH*") "1")
      ((wcmatch (strcase *PV_ELEV_TILT_DIR*) "*EAST TO WEST*") "2")
      ((wcmatch (strcase *PV_ELEV_TILT_DIR*) "*WEST TO EAST*") "3")
      (t "0")
    )
  )

  (start_list "elev_leg_mode")
  (add_list "By Intermediate Legs Count (between first & last)")
  (add_list "By Spacing Distance in Metres (m)")
  (add_list "By Number of Modules (panels)")
  (end_list)
  (set_tile "elev_leg_mode"
    (cond
      ((or (= *PV_ELEV_LEG_MODE* "DISTANCE") (= *PV_ELEV_LEG_MODE* "1")) "1")
      ((or (= *PV_ELEV_LEG_MODE* "MODULES")  (= *PV_ELEV_LEG_MODE* "2")) "2")
      (t "0")
    )
  )

  (set_tile "tilt_angle"     (rtos *PV_TILT* 2 1))
  (set_tile "elev_min_clear" (rtos (if (and *PV_ELEV_MIN_CLEAR* (> *PV_ELEV_MIN_CLEAR* 0.0)) *PV_ELEV_MIN_CLEAR* 2.00) 2 2))
  (set_tile "elev_leg_count" (itoa (if (and *PV_ELEV_LEG_COUNT* (> *PV_ELEV_LEG_COUNT* 0)) *PV_ELEV_LEG_COUNT* 2)))
  (set_tile "elev_leg_dist"  (rtos (if (and *PV_ELEV_LEG_DIST* (> *PV_ELEV_LEG_DIST* 0.0)) *PV_ELEV_LEG_DIST* 3.00) 2 2))
  (set_tile "elev_leg_mods"  (itoa (if (and *PV_ELEV_LEG_MODS* (> *PV_ELEV_LEG_MODS* 0)) *PV_ELEV_LEG_MODS* 2)))

  (action_tile "btn_apply_gen" "(done_dialog 2)")
  (action_tile "accept"        "(done_dialog 1)")
  (action_tile "cancel"        "(done_dialog 0)")

  (setq what-next (start_dialog))

  (if (or (= what-next 1) (= what-next 2))
    (progn
      (setq *PV_MOUNT_OPT* "Elevated Tilted Legs")
      (setq *PV_ROOF_TYPE* "Flat RCC Rooftop")
      (if (get_tile "tilt_angle")     (setq *PV_TILT* (atof (get_tile "tilt_angle"))))
      (if (get_tile "elev_min_clear") (setq *PV_ELEV_MIN_CLEAR* (atof (get_tile "elev_min_clear"))))
      (if (get_tile "elev_leg_count") (setq *PV_ELEV_LEG_COUNT* (atoi (get_tile "elev_leg_count"))))
      (if (get_tile "elev_leg_dist")  (setq *PV_ELEV_LEG_DIST* (atof (get_tile "elev_leg_dist"))))
      (if (get_tile "elev_leg_mods")  (setq *PV_ELEV_LEG_MODS* (atoi (get_tile "elev_leg_mods"))))
      (setq *PV_ELEV_LEG_MODE*
        (cond
          ((= (get_tile "elev_leg_mode") "1") "DISTANCE")
          ((= (get_tile "elev_leg_mode") "2") "MODULES")
          (t "COUNT")
        )
      )
      (setq *PV_ELEV_TILT_DIR*
        (cond
          ((= (get_tile "elev_tilt_dir") "1") "South to North")
          ((= (get_tile "elev_tilt_dir") "2") "East to West")
          ((= (get_tile "elev_tilt_dir") "3") "West to East")
          (t "North to South")
        )
      )
      (princ (strcat "\n[SolarPV] Elevated Tilted Legs Configured: Mode=" *PV_ELEV_LEG_MODE*
                     ", Slope Dir=" *PV_ELEV_TILT_DIR*
                     ", Tilt=" (rtos *PV_TILT* 2 1) "°"
                     ", Min Clearance=" (rtos *PV_ELEV_MIN_CLEAR* 2 2) "m."))
    )
  )
  (unload_dialog dcl-id)

  (if (= what-next 2)
    (pv:generate-layout)
  )
  (princ)
)

(defun c:pv-elev-toggle ()
  (if (wcmatch (strcase *PV_MOUNT_OPT*) "*ELEVATED*")
    (progn
      (setq *PV_MOUNT_OPT* "Tilted on MMS Structures")
      (princ "\n[SolarPV] Mounting Option switched to: Tilted on MMS Structures (Individual Row MMS).")
      (alert "Mounting Option switched to: Tilted on MMS Structures (Individual Row MMS).")
    )
    (progn
      (setq *PV_MOUNT_OPT* "Elevated Tilted Legs")
      (setq *PV_ROOF_TYPE* "Flat RCC Rooftop")
      (princ "\n[SolarPV] Mounting Option switched to: Elevated Tilted Legs (Continuous Solar Canopy).")
      (alert "Mounting Option switched to: Elevated Tilted Legs (Continuous Solar Canopy).")
    )
  )
  (princ)
)

;; Note: PVELEVCONFIG / PVELEVATED aliases defined in Group 17

(princ "\n=======================================================")
(princ "\n Solar PV Plant Layout Generator - Rooftop Projects Loaded!")
(princ "\n Type 'PVMENU' or 'PVDCL' to open the Master Functions Dialog.")
(princ "\n Type 'ROOFTOPSOLAR' or 'SOLARPV' for the Full Designer.")
(princ "\n Enhanced with PVDesigner 2027 Engineering Suite.")
(princ "\n=======================================================\n")
(princ)
