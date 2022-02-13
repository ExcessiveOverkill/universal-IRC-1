{ USerial : Windows/DOS 16C450 or 16C550 or Mesa Serial port routines }

type
ComPortHardwareTypes = (STDComPort,MESAComPort,SSLBPPort,NOPort);

var
CharTimeOut : longint; { milliseconds }
ExitOnTimeout  : boolean;
TheBaudRateMul : real;
TheBaudRate : longint;
SerError : boolean;
ComPortHardwareType : ComPortHardwareTypes;

{$IFNDEF WINDOWS}
  {$I serial.pas }
  {I MesaUart.pas }
  {$I M32Uart.pas }
{$ENDIF}

procedure SerSetRTSHigh;
begin
{$IFDEF WINDOWS}
  Ser.RTS := true;
{$ELSE}
  case ComPortHardwareType of
    STDComPort: ForceRTSHigh(TheComPort);
  end;
{$ENDIF}
end;

procedure SerSetRTSLow;
begin
{$IFDEF WINDOWS}
  Ser.RTS := false;
{$ELSE}
  case ComPortHardwareType of
    STDComPort: ForceRTSLow(TheComPort);
  end;
{$ENDIF}
end;


{$IFDEF WINDOWS}
procedure SerTossChars;
var dummychar : char;
begin
  ser.Purge;
  repeat
    delay(10);
    if ser.WaitingData <> 0 then
    begin
      dummychar := char(ser.RecvByte(CharTimeOut));
    end;
    delay(10);
  until ser.WaitingData = 0;
end;

{$ELSE NOT WINDOWS}


procedure SerTossChars;
begin
  case ComPortHardwareType of
    STDComPort: TossChars(TheComPort,20);
    MESAComPort: MesaSerTossChars(TheComport);
  end;
end;

function STDBaudRateValid(comport : word; br,bm : real) : boolean;
var ourbaud,testbaud,ratio : real;
divisor : word;
begin
  STDBaudRateValid := true;
  ourbaud := br/bm;
  divisor := round(STDBRClock/round(br/bm*16.0));
  testbaud := StdBRClock / divisor /16.0;
  ratio := ourbaud / testbaud;
  if (ratio > 1.0) and (ratio > 1.03) then STDBaudRateValid := false;
  if (ratio < 1.0) and (ratio < 0.97) then STDBaudRateValid := false;
end;

function STDSetBaud(comport : word; br,bm : real) : boolean;
var ourbaud : real;
begin
  if STDBaudRateValid(comport,br,bm) then
  begin
    ourbaud := br/bm;
{$IFDEF WINDOWS}
    ser.Config(round(ourbaud),8,'N',0,false,false);
{$ELSE} { DOS }
    SetBaudRate(comport,round(ourbaud));
{$ENDIF}
    STDSetBaud := true;
  end
  else
  begin
    STDSetBaud := false;
    writeln('Invalid Baud Rate');
  end;
end;

{ dos }

function DosSerRecvChar(var c : char) : boolean;
var timeout : longint;
ourchar : char;
begin
  timeout := CharTimeOut;
  while ((port[TheComPort + LineStat] and DataReady) = 0) and (timeout <> 0) do timeout := timeout -1;
  if timeout <> 0 then
  begin
    ourchar := char(port[TheComPort + RecReg]);
    DosSerRecvChar := true;
    c := ourchar;
{$IFDEF SDEBUG}
    Hexprint(byte(ourchar),2);
    write(' ');
{$ENDIF}
  end
  else
  begin
    DosSerRecvChar := false;
    SerError := true;
    if ExitOnTimeout then Error(CharTimeoutErr);
  end;
end;

function DosSerRecvString(n : integer;var s : string) : boolean;
var
count : integer;
is : string;
timeout : longint;
ourchar : char;
charok : boolean;
begin
  DosSerRecvString := false;
  charok := true;
  is := '';
  for count := 1 to n do
  begin
    if DosSerRecvChar(ourchar) then
    begin
      is := is + ourchar;
    end else charok := false;
  end;
  DosSerRecvString := charok;
  s := is;
end;

procedure DosSerSendChar(c : char);
var dummy : char;
begin
  if SerType = TwoWire then
  begin
    ForceRTSHigh(TheComPort);
    {delay(1);}
  end;
  while (port[TheComPort + LineStat] and THRE) = 0 do {wait for xmit char} ;
  port[TheComPort + TrHReg] := byte(c);
{$IFDEF SDEBUG}
    DebugString := DebugString + HexString(longint(c),2) + ' ';
{$ENDIF}

  if SerType = TwoWire then
  begin
   WaitForXmitDone(TheComPort);
   ForceRTSLow(TheComPort);
   DosSerRecvChar(dummy);
  end;
end;

procedure DosSerSendString(s : string);
var i : integer;
begin
  DisableInterrupts;
  for i := 1 to length(s) do
  begin
    DosSerSendChar(s[i]);
  end;
  EnableInterrupts;
end;

procedure DosSerOpen(comport : word; br,bm : real);
begin
  DefaultComInit(comport);
  EnableFifos(comport); { don't check if fifos are there because it sends garbage }
  STDSetBaud(comport,br,bm);
  TossChars(comport,20); { make real sure there are no pending chars }
end;

function DosCanRead(ms : integer) : boolean;
var ctimeout : longint;
begin
  if ms <> 0 then
  begin
    ctimeout := LoopsPermS * longint(ms);
    while ((port[TheComPort + LineStat] and DataReady = 0) and (ctimeout <> 0)) do ctimeout := ctimeout -1;
    if ctimeout <> 0 then DosCanRead := true else DosCanRead := false;
  end
  else if ((port[TheComPort + LineStat] and DataReady) <> 0) then DosCanRead := true else DosCanRead := false
end;
{$ENDIF WINDOWS}

{ all }

function SerOpen(var message : string) : boolean;
var openok : boolean;
begin
  message := '';
  SerOpen := false;
  openok := false;
{$IFDEF WINDOWS}

  {Writeln('Attempt to open serial port: ',TheComPort); }
  ser:=TBlockserial.Create;
  {ser.RaiseExcept:=True;}
  ser.Connect(TheComPort);
  ser.Config(round(TheBaudrate/TheBaudRateMul),8,'N',0,false,false);
  if ser.LastError = 0 then openok := true else message := TheComPort;
  SerTossChars;
  {$ELSE} { DOS }
  case ComPortHardwareType of
    MESAComPort:
    begin
      if MesaComportThere(TheComPort) then
      begin
        MesaSerOpen(TheComPort,TheBaudRate,TheBaudRateMul);
        openok := true;
      end;
      message := 'MesaCom port'
    end;

    STDComPort:
    begin
      if ComPortThere(TheComport) then
      begin
        DosSerOpen(TheComPort,TheBaudRate,TheBaudRateMul);
        openok := true;
      end;
      message := 'Dos Com port'
    end;
  end; { case }
{$ENDIF}
  if openok then
  begin
    message := message + ' open ok';
    SerOpen := true;
  end else message := message + ' open failed';
end;

procedure SerClose;
begin
{$IFDEF WINDOWS}
  ser.free;
{$ELSE} { DOS }
{$ENDIF}
end;

function SerRecvChar(var c : char) : boolean;
begin
{$IFDEF WINDOWS}
  SerError := true;
  c := char(ser.RecvByte(CharTimeOut));
  if ser.LastError = ErrTimeout then
  begin
    SerRecvChar := false;
    if ExitOnTimeout then Error(CharTimeoutErr);
  end
  else
  begin
    SerRecvChar := true;
    SerError := false;
  end;
{$ELSE} { DOS }
  case ComPortHardwareType of
    MESAComPort: SerRecvChar := MesaSerRecvChar(c);
    STDComPort: SerRecvChar := DosSerRecvChar(c);
  end;
{$ENDIF}
{$IFDEF SERDEBUG}
    Hexprint(byte(c),2);
    writeln;
{$ENDIF}

end;

function SerRecvString(n : integer;var s : string) : boolean;
var index : integer;
begin
  s := '';
{$IFDEF WINDOWS}
  s := ser.RecvBufferStr(n,CharTimeOut);
  if ser.LastError = ErrTimeout then SerRecvString := false else SerRecvString := true;
{$ELSE} { DOS }
  case ComPortHardwareType of
    MESAComPort: SerRecvString := MesaSerRecvString(n,s);
    STDComPort: SerRecvString := DosSerRecvString(n,s);
  end;
{$ENDIF}
{$IFDEF SERDEBUG}
  write('Recv Data: ');
  for index := 1 to length(s) do
  begin
    hexprint(byte(s[index]),2);
    write(',');
  end;
  writeln;
{$ENDIF}
end;

procedure SerSendChar(c : char);
begin
{$IFDEF WINDOWS}
  ser.SendByte(byte(c));
{$ELSE} { DOS }
  case ComPortHardwareType of
    MESAComPort: MesaSerSendChar(c);
    STDComPort: DosSerSendChar(c);
  end;
{$ENDIF}
end;

procedure SerSendString(s : string);
var index : integer;
begin
{$IFDEF SERDEBUG}
  write('Send Data: ');
  for index := 1 to length(s) do
  begin
    hexprint(byte(s[index]),2);
    write(',');
  end;
  writeln;
{$ENDIF}


{$IFDEF WINDOWS}
  ser.SendString(s);
{$ELSE}
  case ComPortHardwareType of
    MESAComPort: MesaSendString(s);
    STDComPort: DosSerSendString(s);
  end;
{$ENDIF}
end;

function SerCanRead(ms: longint) : boolean;
begin
{$IFDEF WINDOWS}
  SerCanRead := ser.CanReadEx(ms);
{$ELSE} { DOS }
  case ComPortHardwareType of
    MESAComPort: SerCanRead := MesaCanRead(ms);
    STDComPort: SerCanRead := DosCanRead(ms);
  end;
{$ENDIF}
end;

{fixed toss char reversed paramaters range check error 12-16-2009}
{don't setrtshigh/low in mesa mode 2-3-2010 }
