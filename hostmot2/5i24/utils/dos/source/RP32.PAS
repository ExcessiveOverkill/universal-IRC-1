program ReadParam32;

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



procedure Usage;
begin
  writeln('Usage: rp32 HexRegisterOffset ');
  writeln;
  halt(2);
end;

procedure Error(err : integer);
begin
  writeln(errorrecord[err].errstr);
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
      thedata := Read32(themem);
      validparm := true;
      didit := true;
      HexPrint(TheData,8);
      write('  ');
    end;
  end;
  if not didit then write('Nothing done!!!');
  writeln;
end;

begin
  GetOurEnv;
  if not InitializeInterface(message) then bumout(message);
  if ParamCount < 1 then Usage;
  ScanParms;
end.
