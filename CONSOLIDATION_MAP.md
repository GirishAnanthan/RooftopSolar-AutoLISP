# FUNCTION CONSOLIDATION MAP

## DUPLICATE FUNCTIONS TO REMOVE

### 1. pv:draw-3dface (Lines 990 and 4488)
```lisp
;; KEEP: Line 990 version
;; REMOVE: Line 4488 version
```

### 2. pv:get-roof-z (Lines 585 and 4535)
```lisp
;; KEEP: Line 585 version
;; REMOVE: Line 4535 version
```

### 3. pv:file-exists-p (Lines 1323 and 7040)
```lisp
;; KEEP: Line 1323 version
;; REMOVE: Line 7040 version
```

## CONSOLIDATION EXAMPLE

### Before (5 separate functions, ~95 lines):

```lisp
(defun pv:draw-lwpolyline (pts layer color closed / elist)
  ;; 20 lines
)

(defun pv:draw-3d-poly (pts layer color closed / z)
  ;; 25 lines
)

(defun pv:draw-line (p1 p2 layer color / elist z1 z2)
  ;; 15 lines
)

(defun pv:draw-line-3d (p1 p2 layer color / elist z1 z2)
  ;; 15 lines
)

(defun pv:draw-circle (center radius layer color / elist z)
  ;; 20 lines
)
```

### After (1 unified function, ~60 lines):

```lisp
(defun pv:draw-entity (entity-type points layer color options)
  "Unified drawing function
   entity-type: 'lwpolyline, '3dpoly, 'line, 'line3d, 'circle, '3dface
   points: list of points
   options: '((closed . t) (radius . 0.5) etc.)"

  (cond
    ((= entity-type 'lwpolyline)
     ;; lwpolyline code
    )
    ((= entity-type '3dpoly)
     ;; 3dpoly code
    )
    ((= entity-type 'line)
     ;; 2d line code
    )
    ((= entity-type 'line3d)
     ;; 3d line code
    )
    ((= entity-type 'circle)
     ;; circle code
    )
    ((= entity-type '3dface)
     ;; 3dface code
    )
  )
)
```

## SUMMARY

| Category | Current | Proposed | Savings |
|----------|---------|----------|---------|
| Commands | 161 | 25 | 136 |
| Drawing | 17 | 4 | 13 |
| Geometry | 10 | 3 | 7 |
| Dialogs | 12 | 4 | 8 |
| Components | 6 | 2 | 4 |
| Tables | 4 | 1 | 3 |
| **TOTAL** | **262** | **~88** | **~174** |
