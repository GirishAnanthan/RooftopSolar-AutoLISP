# COMMAND CONSOLIDATION ANALYSIS

## Current State: 161 Command Functions

These commands will be grouped into logical clusters and merged into unified dispatcher functions.

---

## GROUP 1: MAIN ENTRY COMMANDS (8 commands → 1)

### Commands Merged:
```lisp
c:ROOFTOPSOLAR     → MERGED into c:PVSOLAR
c:RooftopSolar     → MERGED into c:PVSOLAR
c:SOLARPV          → MERGED into c:PVSOLAR
c:SOLARTOOLS       → MERGED into c:PVSOLAR
c:SOLARLAYOUT      → MERGED into c:PVSOLAR
c:PVMENU           → MERGED into c:PVSOLAR
c:PVDCL            → MERGED into c:PVSOLAR
c:PVCOMMANDS       → MERGED into c:PVSOLAR
c:PVHUB            → MERGED into c:PVSOLAR
```

### Merged Function:
```lisp
(defun c:PVSOLAR ( / mode)
  "Main dispatcher - handles all entry points
   Usage: PVSOLAR or type any alias
   Mode: 'designer (full dialog), 'menu (command menu), 'quick (last used)"
  
  (princ "\n[ Solar PV Plant Layout Generator ]")
  (pv:full-designer-dialog)
)
```

---

## GROUP 2: LAYOUT COMMANDS (4 commands → 1)

### Commands Merged:
```lisp
c:PVLAYOUT              → MERGED into c:PVLAYOUTGEN
c:pv-generate-layout    → MERGED into c:PVLAYOUTGEN
c:PVLAYOUTEW            → MERGED into c:PVLAYOUTGEN
c:pv-layout-ew          → MERGED into c:PVLAYOUTGEN
```

### Merged Function:
```lisp
(defun c:PVLAYOUTGEN ( / mode ss-bnd b-list ent b-pts res)
  "Layout generation dispatcher
   Usage: PVLAYOUT or PVLAYOUTEW
   Mode: nil (auto), 'ew (east-west layout)"
  
  (setq mode nil)  ; Default auto layout
  (cond
    ((= mode 'ew) (c:pv-layout-ew))
    (t (c:pv-generate-layout))
  )
)
```

---

## GROUP 3: STRINGING COMMANDS (10 commands → 2)

### Commands Merged:
```lisp
c:PVSTRING        → pv:stringing
c:PVSTRINGING     → pv:stringing
c:PVSTRINGMANUAL  → pv:string-manual
c:PVSTRINGEW      → pv:string-ew
c:PVSTRINGVIS     → pv:string-vis
c:PVPOLARITY      → pv-polarity
c:PVPANELNUM      → pv-panel-number
c:PVEWVIS         → pv-ew-vis
c:PVMPPTDETAILS   → pv-mppt-details
c:PVMPPTLINK      → pv-mppt-link
```

### Merged Function:
```lisp
(defun c:PVSTRINGING ( / mode)
  "Stringing operations dispatcher
   Usage: PVSTRING [mode]
   Modes: nil (auto), 'manual, 'ew, 'vis, 'polarity, 'mppt"
  
  (cond
    ((= mode 'manual) (c:pv-string-manual))
    ((= mode 'ew)     (c:pv-string-ew))
    ((= mode 'vis)    (c:pv-string-vis))
    ((= mode 'polarity) (c:pv-polarity))
    ((= mode 'mppt)   (c:pv-mppt-details))
    (t                (c:pv-stringing))
  )
)
```

---

## GROUP 4: CLEAR COMMANDS (12 commands → 1)

### Commands Merged:
```lisp
c:PVCLEARLAYOUT      → pv-clear-layout
c:PVCLEARSTRINGS     → pv-clear-strings
c:PVCLEARSTRING      → pv-clear-strings
c:PVCLEARWALKWAY     → pv-clear-walkways
c:PVCLEARWALKWAYS    → pv-clear-walkways
c:PVCLEARHANDRAIL    → pv-clear-handrails
c:PVCLEARHANDRAILS   → pv-clear-handrails
c:PVCLEARCABLETRAY   → pv-clear-cable-tray
c:PVCLEAR3D          → pv-clear-3d
c:PVCLEARBLDG3D      → pv-clear-building-3d
c:PVCLEAROBSTACLES   → pv-clear-obstacles
```

### Merged Function:
```lisp
(defun c:PVCLEARALL ( / what)
  "Clear all or specific PV elements
   Usage: PVCLEARALL [what]
   Options: 'layout, 'strings, 'walkway, 'handrail, 'cabletray, 
            '3d, 'building, 'obstacles, or nil (all)"
  
  (cond
    ((= what 'layout)    (c:pv-clear-layout))
    ((= what 'strings)   (c:pv-clear-strings))
    ((= what 'walkway)   (c:pv-clear-walkways))
    ((= what 'handrail)  (c:pv-clear-handrails))
    ((= what 'cabletray) (c:pv-clear-cable-tray))
    ((= what '3d)        (c:pv-clear-3d))
    ((= what 'building)  (c:pv-clear-building-3d))
    ((= what 'obstacles) (c:pv-clear-obstacles))
    (t  ; Clear everything
     (c:pv-clear-layout)
     (c:pv-clear-strings)
     (c:pv-clear-walkways)
     (c:pv-clear-handrails)
     (princ "\n[SolarPV] All elements cleared."))
  )
)
```

---

## GROUP 5: 3D COMMANDS (6 commands → 1)

### Commands Merged:
```lisp
c:PV3D           → pv-3d-view
c:PV3DVIEW       → pv-3d-view
c:PVBUILDING3D   → pv-building-3d
c:PVBLDG3D       → pv-building-3d
c:PVROOFTYPE     → pv-building-3d
c:PVCLEARBLDG3D  → pv-clear-building-3d
```

### Merged Function:
```lisp
(defun c:PV3D (/ mode)
  "3D modeling dispatcher
   Usage: PV3D [mode]
   Modes: nil (view), 'build, 'clear"
  
  (cond
    ((= mode 'build)  (c:pv-building-3d))
    ((= mode 'clear)  (c:pv-clear-building-3d))
    (t                (c:pv-3d-view))
  )
)
```

---

## GROUP 6: SHADOW COMMANDS (8 commands → 1)

### Commands Merged:
```lisp
c:PVSHADOWTOGGLE   → pv-toggle-shadow
c:PVTOGGLESHADOW   → pv-toggle-shadow
c:PVSHADOWMAP      → pv-toggle-shadow
c:PVSHADOWON       → pv-shadow-on
c:PVSHADOWOFF      → pv-shadow-off
c:PVPRUNESHADED    → pv-prune-shaded
c:PVCHECKSHADING   → pv-prune-shaded
```

### Merged Function:
```lisp
(defun c:PVSHADOW ( / mode)
  "Shadow analysis dispatcher
   Usage: PVSHADOW [mode]
   Modes: nil (toggle), 'on, 'off, 'prune"
  
  (cond
    ((= mode 'on)    (c:pv-shadow-on))
    ((= mode 'off)   (c:pv-shadow-off))
    ((= mode 'prune) (c:pv-prune-shaded))
    (t               (c:pv-toggle-shadow))
  )
)
```

---

## GROUP 7: FILE LOAD COMMANDS (6 commands → 2)

### Commands Merged:
```lisp
c:PVLOADPAN    → pv-load-pan
c:PVPAN        → pv-load-pan
c:PVLOADOND    → pv-load-ond
c:PVOND        → pv-load-ond
c:PVCOMPLIB    → pv-complib
c:PVLIBRARY    → pv-complib
```

### Merged Function:
```lisp
(defun c:PVLOAD ( / type filepath)
  "Load PAN/OND files or component library
   Usage: PVLOAD [type]
   Types: 'pan, 'ond, 'lib"

  (cond
    ((= type 'pan) (c:pv-load-pan))
    ((= type 'ond) (c:pv-load-ond))
    ((= type 'lib) (c:pv-complib))
    (t (c:pv-load-pan))  ; Default
  )
)
```

---

## GROUP 8: WALKWAY COMMANDS (4 commands → 1)

### Commands Merged:
```lisp
c:PVWALKWAY        → pv-walkway
c:PVWALKWAYPATH    → pv-walkway
c:PVAUTOWALKWAY    → pv-toggle-auto-walkway
c:PVWALKWAYTOGGLE  → pv-toggle-auto-walkway
```

### Merged Function:
```lisp
(defun c:PVWALKWAY ( / mode)
  "Walkway operations dispatcher
   Usage: PVWALKWAY [mode]
   Modes: nil (manual), 'auto, 'toggle, 'clear"

  (cond
    ((= mode 'auto)   (c:pv-toggle-auto-walkway))
    ((= mode 'toggle) (c:pv-toggle-auto-walkway))
    ((= mode 'clear)  (c:pv-clear-walkways))
    (t                (c:pv-walkway))
  )
)
```

---

## GROUP 9: SAFETY COMMANDS (4 commands → 1)

### Commands Merged:
```lisp
c:PVFALLSAFETY   → pv-fall-safety
c:PVSAFETYLINE   → pv-fall-safety
c:PVHANDRAIL     → pv-handrail
```

### Merged Function:
```lisp
(defun c:PVSAFETY ( / mode)
  "Safety system dispatcher
   Usage: PVSAFETY [mode]
   Modes: nil (fall safety), 'handrail, 'clear"

  (cond
    ((= mode 'handrail) (c:pv-handrail))
    ((= mode 'clear)    (c:pv-clear-handrails))
    (t                  (c:pv-fall-safety))
  )
)
```

---

## GROUP 10: PARAPET COMMANDS (6 commands → 1)

### Commands Merged:
```lisp
c:PVOFFSET         → pv-draw-parapet-offsets
c:PVPARAPET        → pv-draw-parapet-offsets
c:PVPARAPETOFFSET  → pv-draw-parapet-offsets
c:PVSHOWALLOFFSET  → pv-show-all-offset
c:PVHIDEALLOFFSET  → pv-hide-all-offset
```

### Merged Function:
```lisp
(defun c:PVPARAPET ( / mode)
  "Parapet offset dispatcher
   Usage: PVPARAPET [mode]
   Modes: nil (draw), 'show, 'hide"

  (cond
    ((= mode 'show) (c:pv-show-all-offset))
    ((= mode 'hide) (c:pv-hide-all-offset))
    (t              (c:pv-draw-parapet-offsets))
  )
)
```

---

## GROUP 11: REPORTING COMMANDS (6 commands → 2)

### Commands Merged:
```lisp
c:PVENERGYTABLE  → pv-energy-table
c:PVSIMREPORT    → pv-report-energy
c:PVREPORT       → pv-report-energy
c:PVBOM          → pv-draw-bom
c:PVDRAWBOM      → pv-draw-bom
c:PVDIMPLAN      → pv-dim-plan
```

### Merged Function:
```lisp
(defun c:PVREPORT ( / type)
  "Reporting dispatcher
   Usage: PVREPORT [type]
   Types: 'energy, 'bom, 'dim"

  (cond
    ((= type 'energy) (c:pv-report-energy))
    ((= type 'bom)    (c:pv-draw-bom))
    ((= type 'dim)    (c:pv-dim-plan))
    (t                (c:pv-report-energy))
  )
)
```

---

## GROUP 12: ROOF MANAGEMENT (5 commands → 1)

### Commands Merged:
```lisp
c:PVMULTIROOF   → pv-multiroof
c:PVROOFS       → pv-multiroof
c:PVROOFLIST    → pv-roof-list
c:PVROOFNUM     → pv-roof-number
c:PVSELECTROOF  → pv-select-roof
```

### Merged Function:
```lisp
(defun c:PVROOF ( / mode)
  "Roof management dispatcher
   Usage: PVROOF [mode]
   Modes: nil (multi), 'list, 'number, 'select"

  (cond
    ((= mode 'list)   (c:pv-roof-list))
    ((= mode 'number) (c:pv-roof-number))
    ((= mode 'select) (c:pv-select-roof))
    (t                (c:pv-multiroof))
  )
)
```

---

## GROUP 13: EXPORT COMMANDS (4 commands → 1)

### Commands Merged:
```lisp
c:PVPVSYST       → pv-export-pvsyst
c:PVPVSYSTEXPORT → pv-export-pvsyst
c:PVEXPORTPVSYST → pv-export-pvsyst
```

### Merged Function:
```lisp
(defun c:PVEXPORT ( / format)
  "Export dispatcher
   Usage: PVEXPORT [format]
   Formats: 'pvsyst, 'csv"

  (cond
    ((= format 'pvsyst) (c:pv-export-pvsyst))
    ((= format 'csv)    (c:pv-export-csv))
    (t                  (c:pv-export-pvsyst))
  )
)
```

---

## GROUP 14: CABLE COMMANDS (8 commands → 1)

### Commands Merged:
```lisp
c:PVCABLETRAY       → pv-draw-cable-tray
c:PVDRAWCABLETRAY   → pv-draw-cable-tray
c:PVCLEARCABLETRAY  → pv-clear-cable-tray
c:PVDCROUTETRACKED  → pv-dc-route-tracked
c:PVDCSCHEDULE      → pv-dc-schedule
c:PVDCROUTECOLORPOLARITY → pv-dc-route-color-polarity
c:PVCABLECALC       → pv-cable-calc
```

### Merged Function:
```lisp
(defun c:PVCABLE ( / mode)
  "Cable & routing dispatcher
   Usage: PVCABLE [mode]
   Modes: nil (tray), 'route, 'schedule, 'color, 'calc, 'clear"

  (cond
    ((= mode 'route)   (c:pv-dc-route-tracked))
    ((= mode 'schedule)(c:pv-dc-schedule))
    ((= mode 'color)   (c:pv-dc-route-color-polarity))
    ((= mode 'calc)    (c:pv-cable-calc))
    ((= mode 'clear)   (c:pv-clear-cable-tray))
    (t                 (c:pv-draw-cable-tray))
  )
)
```

---

## GROUP 15: INVERTER COMMANDS (3 commands → 1)

### Commands Merged:
```lisp
c:PVINVERTER        → pv-place-inverter
c:PVPLACEINVERTER   → pv-place-inverter
c:PVACEQUIPMENT     → pv-ac-equipment
```

### Merged Function:
```lisp
(defun c:PVINVERTER ( / mode)
  "Inverter placement & AC equipment
   Usage: PVINVERTER [mode]
   Modes: nil (place), 'ac"

  (cond
    ((= mode 'ac) (c:pv-ac-equipment))
    (t           (c:pv-place-inverter))
  )
)
```

---

## GROUP 16: OBSTACLE COMMANDS (3 commands → 1)

### Commands Merged:
```lisp
c:PVPICKOBSTACLES   → pv-pick-obstacles
c:PVOBSTACLES       → pv-pick-obstacles
c:PVPICKBOUNDARY    → pv-pick-boundary
```

### Merged Function:
```lisp
(defun c:PVBOUNDARY ( / mode)
  "Boundary & obstacle picker
   Usage: PVBOUNDARY [mode]
   Modes: nil (obstacles), 'boundary"

  (cond
    ((= mode 'boundary) (c:pv-pick-boundary))
    (t                  (c:pv-pick-obstacles))
  )
)
```

---

## GROUP 17: ELEVATED STRUCTURE (4 commands → 1)

### Commands Merged:
```lisp
c:PVELEVCONFIG   → pv-elev-legs-config
c:PVELEVATED     → pv-elev-legs-config
c:PVLEGS         → pv-elev-legs-config
c:PVELEVTOGGLE   → pv-elev-toggle
```

### Merged Function:
```lisp
(defun c:PVELEV ( / mode)
  "Elevated structure configuration
   Usage: PVELEV [mode]
   Modes: nil (config), 'toggle"

  (cond
    ((= mode 'toggle) (c:pv-elev-toggle))
    (t                (c:pv-elev-legs-config))
  )
)
```

---

## GROUP 18: ROOF SPLIT COMMANDS (3 commands → 1)

### Commands Merged:
```lisp
c:PVHIPSPLIT   → pv-hip-split
c:PVDOMESPLIT  → pv-dome-split
c:PVONEDOME    → pv-one-dome
```

### Merged Function:
```lisp
(defun c:PVROOFSPLIT ( / type)
  "Roof splitting for complex shapes
   Usage: PVROOFSPLIT [type]
   Types: 'hip, 'dome, 'one-dome"

  (cond
    ((= type 'hip)    (c:pv-hip-split))
    ((= type 'dome)   (c:pv-dome-split))
    ((= type 'one)    (c:pv-one-dome))
    (t                (c:pv-hip-split))
  )
)
```

---

## REMAINING SINGLETONS (Keep As-Is)

These commands are unique enough to keep:
```lisp
c:PVVALIDATE       ; String voltage validation
c:PVSLD            ; Single-line diagram
c:PVMPPTDETAILS    ; MPPT details display
c:PVMPPTLINK       ; MPPT linking
c:PV3D             ; Covered in group 5
```

---

## SUMMARY TABLE

| Group | Original Commands | Merged To | Savings |
|-------|-------------------|-----------|---------|
| 1. Entry Points | 9 | 1 | 8 |
| 2. Layout | 4 | 1 | 3 |
| 3. Stringing | 10 | 2 | 8 |
| 4. Clear All | 11 | 1 | 10 |
| 5. 3D | 6 | 1 | 5 |
| 6. Shadow | 7 | 1 | 6 |
| 7. File Load | 6 | 2 | 4 |
| 8. Walkway | 4 | 1 | 3 |
| 9. Safety | 3 | 1 | 2 |
| 10. Parapet | 5 | 1 | 4 |
| 11. Reports | 6 | 2 | 4 |
| 12. Roof Mgmt | 5 | 1 | 4 |
| 13. Export | 3 | 1 | 2 |
| 14. Cable | 7 | 1 | 6 |
| 15. Inverter | 3 | 1 | 2 |
| 16. Boundary | 3 | 1 | 2 |
| 17. Elevated | 4 | 1 | 3 |
| 18. Roof Split | 3 | 1 | 2 |
| **TOTAL** | **~100** | **~20** | **~80** |

---

## IMPLEMENTATION PRIORITY

### Phase 1 (Quick Wins - Low Risk):
1. Group 4: Clear commands (11 → 1)
2. Group 6: Shadow commands (7 → 1)
3. Group 1: Entry points (9 → 1)

### Phase 2 (Medium Risk):
4. Group 7: File load (6 → 2)
5. Group 8: Walkway (4 → 1)
6. Group 10: Parapet (5 → 1)

### Phase 3 (Higher Risk):
7. Group 3: Stringing (10 → 2)
8. Group 14: Cable (7 → 1)
9. Group 2: Layout (4 → 1)

---

## BACKWARD COMPATIBILITY

All old command names will still work via:
```lisp
;; Example: Old command still calls new dispatcher
(defun c:PVWALKWAY () (c:PVWALKWAY))
```

This maintains compatibility while reducing code redundancy.