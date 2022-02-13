type HRDoubleIntRec = record
  Word0  : word;
  Word1  : word;
  Word2  : word;
  Word3  : word;
end;


type HRDoublelongRec = record
  long0  : longint;
  long1  : longint;
end;

function HexWordRead(hexstring : string; var hexnumber : word): boolean;
var
hindex : byte;
charVal : integer;
{placeVal : integer;}
validhex : boolean;
const
hexChars : string = '0123456789ABCDEF';
begin
  hexNumber :=0;
  validhex := true;
  for hindex := 1 to length(hexstring) do
  begin
    if validhex then hexNumber := HexNumber * $10;
    charval := pos(upcase(hexstring[hindex]),hexChars) -1;
    if charval < 0 then
    begin
      validhex := false;
    end
    else
    begin
      hexnumber := hexnumber + charVal;
    end;
  end;
  HexWordRead := validhex;
end;

function HexByteRead(hexstring : string; var hexnumber : byte): boolean;
var
hindex : byte;
charVal : integer;
{placeVal : integer;}
validhex : boolean;
const
hexChars : string = '0123456789ABCDEF';
begin
  hexNumber :=0;
  validhex := true;
  for hindex := 1 to length(hexstring) do
  begin
    if validhex then hexNumber := HexNumber * $10;
    charval := pos(upcase(hexstring[hindex]),hexChars) -1;
    if charval < 0 then
    begin
      validhex := false;
    end
    else
    begin
      hexnumber := hexnumber + charVal;
    end;
  end;
  HexByteRead := validhex;
end;

function HexLongRead(hexstring : string; var hexnumber : longint): boolean;
var
hindex : byte;
charVal : integer;
validhex : boolean;
const
hexChars : string = '0123456789ABCDEF';
begin
  hexNumber :=0;
  validhex := true;
  for hindex := 1 to length(hexstring) do
  begin
    hexNumber := HexNumber * $10;
    charval := pos(upcase(hexstring[hindex]),hexChars) -1;
    if charval < 0 then
    begin
      validhex := false;
    end
    else
    begin
      hexnumber := hexnumber + charVal;
    end;
  end;
  HexLongRead := validhex;
end;
{$IFDEF COPROC}
function FPHexDoubleRead(hexstring : string; var hexnumber : comp): boolean;
var
hindex : byte;
charVal : integer;
validhex : boolean;
const
hexChars : string = '0123456789ABCDEF';
begin
  hexNumber :=0;
  validhex := true;
  for hindex := 1 to length(hexstring) do
  begin
    hexNumber := hexnumber * $10;
    charval := pos(upcase(hexstring[hindex]),hexChars) -1;
    if charval < 0 then
    begin
      validhex := false;
    end
    else
    begin
      hexnumber := hexnumber + charVal;
    end;
  end;

  FPHexDoubleRead := validhex;
end;
function HexDoubleRead(hexstring : string; var hexnumber : comp): boolean;
var
word0,word1,word2,word3 : word;
hindex,index : byte;
charVal : word;
validhex : boolean;
const
hexChars : string = '0123456789ABCDEF';
begin
  hexNumber := 0;
  word0 := 0;
  word1 := 0;
  word2 := 0;
  word3 := 0;
  validhex := true;
  for hindex := length(hexstring) downto 1 do
  begin
    index := length(hexstring) - hindex + 1;
    charval := pos(upcase(hexstring[hindex]),hexChars) -1;
    if charval < 0 then validhex := false;
    case index of
      1  : Word0 := word0 + (charval * $1   );
      2  : Word0 := Word0 + (charval * $10  );
      3  : Word0 := Word0 + (charval * $100 );
      4  : Word0 := Word0 + (charval * $1000);
      5  : Word1 := word1 + (charval * $1   );
      6  : Word1 := Word1 + (charval * $10);
      7  : Word1 := Word1 + (charval * $100);
      8  : Word1 := Word1 + (charval * $1000);
      9  : Word2 := word2 + (charval * $1   );
      10 : Word2 := Word2 + (charval * $10);
      11 : Word2 := Word2 + (charval * $100);
      12 : Word2 := Word2 + (charval * $1000);
      13 : Word3 := word3 + (charval * $1   );
      14 : Word3 := Word3 + (charval * $10  );
      15 : Word3 := Word3 + (charval * $100 );
      16 : Word3 := Word3 + (charval * $1000);
    end;
  end;
  HRDoubleIntRec(HexNumber).Word0  := word0;
  HRDoubleIntRec(HexNumber).Word1  := word1;
  HRDoubleIntRec(HexNumber).Word2  := word2;
  HRDoubleIntRec(HexNumber).Word3  := word3;
  HexDoubleRead := validhex;
end;

function BugHexDoubleRead(hexstring : string; var hexnumber : comp): boolean;
{can't set msb}
var
hindex : byte;
charVal : integer;
validhex : boolean;
const
hexChars : string = '0123456789ABCDEF';
begin
  hexNumber :=0;
  validhex := true;
  for hindex := 1 to length(hexstring) do
  begin
    hexNumber := HexNumber * $10;
    charval := pos(upcase(hexstring[hindex]),hexChars) -1;
    if charval < 0 then
    begin
      validhex := false;
    end
    else
    begin
      hexnumber := hexnumber + charVal;
    end;
  end;
  BugHexDoubleRead := validhex;
end;
{$ENDIF}