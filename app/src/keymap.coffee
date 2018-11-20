export keymap =
  # core
  'enter'             : 'accept'
  'esc'               : 'cancel'
  'ctrl o'            : 'open'
  'cmd o'             : 'open'
  # camera
  'ctrl -'            : 'zoom-out'                 # ZoomOut
  'cmd -'             : 'zoom-out'                 # ZoomOut
  'ctrl _'            : 'zoom-out'                 # ZoomOut
  'cmd _'             : 'zoom-out'                 # ZoomOut
  'ctrl ='            : 'zoom-in'                  # ZoomIn
  'cmd ='             : 'zoom-in'                  # ZoomIn
  'ctrl +'            : 'zoom-in'                  # ZoomIn
  'cmd +'             : 'zoom-in'                  # ZoomIn
  'ctrl 0'            : 'reset-zoom'               # ResetZoom
  'cmd 0'             : 'reset-zoom'               # ResetZoom
  'ctrl alt shift 0'  : 'reset-camera'             # ResetCamera
  'cmd alt shift 0'   : 'reset-camera'             # ResetCamera
  'ctrl down'         : 'pan-down'                 # PanDown
  'cmd down'          : 'pan-down'                 # PanDown
  'ctrl left'         : 'pan-left'                 # PanLeft
  'cmd left'          : 'pan-left'                 # PanLeft
  'ctrl right'        : 'pan-right'                # PanRight
  'cmd right'         : 'pan-right'                # PanRight
  'ctrl shift 0'      : 'reset-pan'                # ResetPan
  'cmd shift 0'       : 'reset-pan'                # ResetPan
  'ctrl up'           : 'pan-up'                   # PanUp
  'cmd up'            : 'pan-up'                   # PanUp
  'h'                 : 'center-graph'             # CenterGraph
  # navigation
  'ctrl esc'          : 'exit-graph'               # ExitGraph
  'cmd esc'           : 'exit-graph'               # ExitGraph
  'ctrl shift down'   : 'go-cone-down'             # GoConeDown
  'cmd shift down'    : 'go-cone-down'             # GoConeDown
  'ctrl shift left'   : 'go-cone-left'             # GoConeLeft
  'cmd shift left'    : 'go-cone-left'             # GoConeLeft
  'ctrl shift right'  : 'go-cone-right'            # GoConeRight
  'cmd shift right'   : 'go-cone-right'            # GoConeRight
  'ctrl shift up'     : 'go-cone-up'               # GoConeUp
  'cmd shift up'      : 'go-cone-up'               # GoConeUp
  'down'              : 'go-down'                  # GoDown
  'left'              : 'go-left'                  # GoLeft
  'right'             : 'go-right'                 # GoRight
  'shift left'        : 'go-prev'                  # GoPrev
  'shift right'       : 'go-next'                  # GoNext
  'up'                : 'go-up'                    # GoUp
  # nodes
  'backspace'         : 'remove-selected-nodes'       # RemoveSelectedNodes
  'ctrl a'            : 'select-all'                  # SelectAll
  'cmd a'             : 'select-all'                  # SelectAll
  'ctrl c'            : 'copy'                        # Copy
  'cmd c'             : 'copy'                        # Copy
  'ctrl x'            : 'cut'                         # Cut
  'cmd x'             : 'cut'                         # Cut
  'ctrl v'            : 'paste'                       # Paste
  'cmd v'             : 'paste'                       # Paste
  'ctrl e'            : 'unfold-selected-nodes'       # UnfoldSelectedNodes
  'cmd e'             : 'unfold-selected-nodes'       # UnfoldSelectedNodes
  'delete'            : 'remove-selected-nodes'       # RemoveSelectedNodes
  'enter'             : 'expand-selected-nodes'       # ExpandSelectedNodes
  'ctrl enter'        : 'edit-selected-nodes'         # EditSelectedNodes
  'cmd enter'         : 'edit-selected-nodes'         # EditSelectedNodes
  'f'                 : 'collapse-to-function'        # CollapseToFunction
  'ctrl space'        : 'zoom-visualization'          # ZoomVisualization
  'space'             : 'open-visualization-preview'  # OpenVisualizationPreview
  '^space'            : 'close-visualization-preview' # CloseVisualizationPreview
  'l'                 : 'autolayout-selected-nodes'   # AutolayoutSelectedNodes
  'ctrl l'            : 'autolayout-all-nodes'        # AutolayoutAllNodes
  'cmd l'             : 'autolayout-all-nodes'        # AutolayoutAllNodes
  # searcher
  'tab'               : 'searcher-open'             # SearcherOpen
  'shift tab'         : 'searcher-edit-expression'  # SearcherEditExpression
  # undo/redo
  'ctrl z'            : 'undo'
  'ctrl y'            : 'redo'
  'cmd z'             : 'undo'
  'cmd y'             : 'redo'
  # MockMonads
  'cmd m'             : 'mock-add-monad'
  'ctrl m'            : 'mock-add-monad'
  'cmd shift m'       : 'mock-clear-monads'
  'ctrl shift m'      : 'mock-clear-monads'
  # debug basegl
  'ctrl alt 0'        : 'debug-layer-0' # EnableDebugLayer
  'ctrl alt 1'        : 'debug-layer-1' # EnableDebugLayer
  'ctrl alt 2'        : 'debug-layer-2' # EnableDebugLayer
  'ctrl alt 3'        : 'debug-layer-3' # EnableDebugLayer
  'ctrl alt 4'        : 'debug-layer-4' # EnableDebugLayer
  'ctrl alt 5'        : 'debug-layer-5' # EnableDebugLayer
  'ctrl alt 6'        : 'debug-layer-6' # EnableDebugLayer
  'ctrl alt 7'        : 'debug-layer-7' # EnableDebugLayer
  'ctrl alt 8'        : 'debug-layer-8' # EnableDebugLayer
  'ctrl alt 9'        : 'debug-layer-9' # EnableDebugLayer

