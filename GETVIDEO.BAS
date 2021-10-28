DEFINT A-Z
DECLARE FUNCTION GetColumnCount ()
DECLARE FUNCTION GetVideoMode ()
DECLARE FUNCTION GetVideoRegenerationBufferSize& ()
DECLARE SUB Main ()

Main

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
 PRINT "Columns: "; GetColumnCount
 PRINT "Regeneration buffer size: "; GetVideoRegenerationBufferSize&
 PRINT "Video mode: "; GetVideoMode
END SUB

