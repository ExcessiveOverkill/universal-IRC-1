program WriteParam32;

{$IFDEF WINDOWS}
uses synaser,synautil,synaip,blcksock,dos,crt;
var
ser:TBlockSerial;
TheComPort : string;
IPAddr : string;
Socket : TUDPBlockSocket;
{$ELSE}
uses dos,crt;
var TheComPort : word;
{$ENDIF}

{$I SELECTC}
{$I SELECTIO}
{I SELECTP}
{$I SELECTPR}
{$I INTERFCE}

procedure Error(err : integer);
begin
  writeln(errorrecord[err].errstr);
  halt(2);
end;


procedure Usage;
begin
  writeln('Usage: wp32 HexRegisterOffset Hexdata32');
  writeln;
  halt(2);
end;


procedure ScanParms;
var
parm : word;
validparm : boolean;
didit : boolean;
themem : longint;
thedata : longint;
begin
  parm := 1;
  validparm := true;
  didit := false;
  while validparm and (parm <= ParamCount) do
  begin
    validparm := false;
    if HexLongRead(Paramstr(parm),themem) then
    begin
      parm := parm +1;
      if HexLongRead(Paramstr(parm),thedata) then
      begin
        parm := parm +1;
        Write32(themem,thedata);
        validparm := true;
        didit := true;
      end;
    end;
  end;
  if not didit then writeln('Nothing done!!!');
end;

begin
  GetOurEnv;
  if not InitializeInterface(message) then bumout(message);
  if paramcount <2 then Usage;
  ScanParms;
end.
