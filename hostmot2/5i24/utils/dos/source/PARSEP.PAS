
function PadWithSpaces(sstring: string;padlength : integer): string;
var
tstring : string;
index : byte;
tooshort : integer;

begin
  tstring := sstring;
  tooshort := padlength - length(sstring);
  if tooshort > 0 then
  begin
    for index := 1 to tooshort do tstring := tstring + ' ';
  end;
  PadWithSpaces := tstring;
end;

procedure StripLeadingBlanks(var st: string);
begin
  while (((st[1] =' ') or (st[1] = chr(9))) and (length(st) >0)) do delete(st,1,1);
end { StripLeadingBlanks };

procedure StripLeadingChar(var st: string;achar :char);
begin
  while ((st[1] = achar) and (length(st) >0)) do delete(st,1,1);
end { StripLeadingChar };

procedure StripTrailingBlanks(var st: string);
begin
  while (copy(st,length(st),1)=' ') or (copy(st,length(st),1)=chr(9)) do delete(st,length(st),1);
end { StripTraiLingBlanks };

function ScanTillWhite(astr : string) : byte;
{ returns pos preceding first white space found, returns 0 for zero }
{ length string, or string length if no white space is found        }
var index,len : byte;
begin
  index := 0;
  len := length(astr);
  if len > 0 then
  begin
    while (astr[index +1] <> chr(32)) and (astr[index +1] <> chr(09)) and (index < len) do
    begin
      index := index +1;
    end;
  end;
  ScanTillWhite := index;
end;

function ScanTillChar(astr : string; achar : char) : byte;
{ returns pos preceding first white space found, returns 0 for zero }
{ length string, or string length if no white space is found        }
var index,len : byte;
begin
  index := 0;
  len := length(astr);
  if len > 0 then
  begin
    while (astr[index +1] <> achar) and (index < len) do
    begin
      index := index +1;
    end;
  end;
  ScanTillchar := index;
end;

function Strip(var rest: string): string;
var
first: string;
endst: integer;
begin
  StripLeadingBlanks(rest);
  endst := ScanTillWhite(rest);              { find position of first white space }
  first := copy(rest,1,endst);               { copy until white space or end }
  rest := copy(rest,endst+1,length(rest));   { delete stripped from rest }
  Strip := first;
end  { Strip };

function StripTillChar(var rest : string;achar : char): string;
var
first: string;
endst: integer;
begin
  StripLeadingChar(rest,achar);
  endst := ScanTillChar(rest,achar);         { find position of first achar}
  first := copy(rest,1,endst);               { copy until next achar or end }
  rest := copy(rest,endst+1,length(rest));   { delete stripped from rest }
  StripTillChar := first;
end  { StripTillChar };

function LowCase(c:char) : char;
var ourb : byte;
begin
  ourb := byte(c);
  if (ourb >64) and (ourb <= 90) then ourb := ourb + 32;
  LowCase := char(ourb);
end;

function UpString(s:string) : string;
var
index : byte;
begin
  for index := 1 to length(s) do
  s[index] := upcase(s[index]);
  UpString := s;
end;

function LowString(s:string) : string;
var
index : byte;
begin
  for index := 1 to length(s) do
  s[index] := LowCase(s[index]);
  LowString := s;
end;

function StripNumber( var astring : string): integer;
var
index : byte;
returnvar : integer;
retcode : integer;
begin
  index := 1;
  while ((astring[index] >= '0') and (astring[index] <= '9'))  do
  begin
    index := index + 1;
  end;
  val(copy(astring,1,index-1),returnvar,retcode);
  astring := copy(astring,index,length(astring)-(index-1));
  StripNumber := returnvar
end { StripNumber };

function StripLetter( var astring : string): string;
var
index : integer;
begin
  index := 1;
  while ((astring[index] < '0') or (astring[index] > '9'))  do
  begin
    index := index + 1;
  end;
  StripLetter := copy(astring,1,index-1);
  astring := copy(astring,index,length(astring)-(index-1));
end { StripLetter };
