DEFINT A-Z

TYPE ScreenModeStr
 ColumnCount AS INTEGER
 Colors AS INTEGER
 Mode AS INTEGER
 RegenBufferSize AS LONG
 Supported AS INTEGER
 XPixels AS INTEGER
 YPixels AS INTEGER
END TYPE

DECLARE FUNCTION GetColumnCount ()
DECLARE FUNCTION GetVideoMode ()
DECLARE FUNCTION GetVideoRegenerationBufferSize& ()
DECLARE SUB DisplayResults ()
DECLARE SUB Main ()
DECLARE SUB ScanModes ()

DIM SHARED ColorError
DIM SHARED ScannedMode
DIM SHARED ScreenMode(0 TO 13) AS ScreenModeStr

Main
END

ColorNotSupported:
ColorError = -1
RESUME NEXT

ModeNotSupported:
ScreenMode(ScannedMode).Supported = 0
RESUME NEXT

SUB DisplayResults
 SCREEN 0: WIDTH 80, 25: COLOR 7, 0: CLS
 PRINT "  Screen: Width: Height: Colors: Mode: Columns: Regen:"
 FOR ScreenMode = LBOUND(ScreenMode) TO UBOUND(ScreenMode)
  IF ScreenMode(ScreenMode).Supported THEN
   PRINT SPC(7);
   PRINT USING "##"; ScreenMode;
   PRINT SPC(4);
   PRINT USING "###"; ScreenMode(ScreenMode).XPixels;
   PRINT SPC(5);
   PRINT USING "###"; ScreenMode(ScreenMode).YPixels;
   PRINT SPC(5);
   PRINT USING "###"; ScreenMode(ScreenMode).Colors;
   PRINT SPC(2);
   HexadecimalMode$ = HEX$(ScreenMode(ScreenMode).Mode)
   IF LEN(HexadecimalMode$) < 2 THEN HexadecimalMode$ = "0" + HexadecimalMode$
   PRINT USING "0x\\"; HexadecimalMode$;
   PRINT SPC(7);
   PRINT USING "##"; ScreenMode(ScreenMode).ColumnCount;
   PRINT SPC(2);
   PRINT USING "#####"; ScreenMode(ScreenMode).RegenBufferSize
  END IF
 NEXT ScreenMode
END SUB

FUNCTION GetColumnCount
 DEF SEG = &H40
 Count = PEEK(&H4B) * &H100
 GetColumnCount = Count OR PEEK(&H4A)
END FUNCTION

FUNCTION GetVideoMode
 DEF SEG = &H40
 GetVideoMode = PEEK(&H49)
END FUNCTION

FUNCTION GetVideoRegenerationBufferSize&
 DEF SEG = &H40
 Size& = PEEK(&H4D) * &H100&
 GetVideoRegenerationBufferSize& = Size& OR PEEK(&H4C)
END FUNCTION

SUB Main
 SCREEN 0: WIDTH 80, 25: COLOR 7, 0: CLS
 PRINT "Screen Mode Tester - by: Peter Swinkels, ***2012***"
 PRINT "Press any key to continue..."
 DO: LOOP WHILE INKEY$ = ""

 ScanModes
 DisplayResults
END SUB

SUB ScanModes
 FOR ScannedMode = LBOUND(ScreenMode) TO UBOUND(ScreenMode)
  ScreenMode(ScannedMode).Colors = 0
  ScreenMode(ScannedMode).ColumnCount = 0
  ScreenMode(ScannedMode).Mode = 0
  ScreenMode(ScannedMode).RegenBufferSize = 0
  ScreenMode(ScannedMode).Supported = 0
  ScreenMode(ScannedMode).XPixels = 0
  ScreenMode(ScannedMode).YPixels = 0
  ScreenMode(ScannedMode).Supported = -1

  ON ERROR GOTO ModeNotSupported:
  SCREEN ScannedMode
 
  IF ScreenMode(ScannedMode).Supported THEN
   ScreenMode(ScannedMode).ColumnCount = GetColumnCount
   ScreenMode(ScannedMode).Mode = GetVideoMode
   ScreenMode(ScannedMode).RegenBufferSize = GetVideoRegenerationBufferSize&
   ScreenMode(ScannedMode).XPixels = POINT(0) * 2
   ScreenMode(ScannedMode).YPixels = POINT(1) * 2
  
   ON ERROR GOTO ColorNotSupported
   FOR ColorV = 0 TO 255
    ColorError = 0
    COLOR ColorV
    IF ColorError THEN EXIT FOR
    ScreenMode(ScannedMode).Colors = ScreenMode(ScannedMode).Colors + 1
   NEXT ColorV
   ON ERROR GOTO 0

   IF ScreenMode(ScannedMode).Colors = 0 THEN ScreenMode(ScannedMode).Colors = 1
  END IF
 NEXT ScannedMode

 ON ERROR GOTO 0
END SUB

