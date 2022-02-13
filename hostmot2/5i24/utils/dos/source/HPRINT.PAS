procedure HexPrint(theData : longint; nibbles : byte);
var
shiftCount : integer;
const
hexChars : array[0..15] of char = ('0','1','2','3','4','5','6','7',
                                   '8','9','A','B','C','D','E','F');
begin
shiftCount := (nibbles * 4) -4;
  while shiftCount >= 0 do
  begin
    write(hexChars[((thedata shr shiftCount) and $000F)]);
    shiftCount := shiftCount - 4;
  end;
end;

function HexString(theData : longint; nibbles : byte) : string;
var
shiftCount : integer;
s : string;
const
hexChars : array[0..15] of char = ('0','1','2','3','4','5','6','7',
                                   '8','9','A','B','C','D','E','F');
begin
  s := '';
  shiftCount := (nibbles * 4) -4;
  while shiftCount >= 0 do
  begin
    s:=s+(hexChars[((thedata shr shiftCount) and $000F)]);
    shiftCount := shiftCount - 4;
  end;
  HexString := s;
end;
