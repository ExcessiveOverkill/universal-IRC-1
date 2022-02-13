const
{ printer status bits @base + 1 }
PError = $08;
PSelect = $10;
PPaperOut = $20;
Pack = $40;
NPbusy = $80;
EPPTimeout = $01;

{ printer control bits @base + 2 }
NPstb = $01;
NPafd = $02;
Pinit = $04;
NPslin = $08;
EPPIdleControl = $04;

LPT1Base        = $3BC;
LPT2Base        = $378;
LPT3Base        = $278;
ContOfs = 2;
StatOfs = 1;
EPPDataOfs = 4;
EPPAddressOfs = 3;

var
EPPBasePort : word;
BaseAddr : longint;
DataPort : word;
ContPort : word;
StatPort : word;
EPPDataPort : word;
EPPAddressPort : word;
Shadow : byte;
ShadowAdd : byte;
UARTBaseAddress : word;

procedure EPPWriteData(d: byte);
begin
  port[EPPDataPort] := d;
  Shadow := d;
end;

procedure EPPWriteAddress(a : byte);
begin
  port[EPPAddressPort] := a;
  ShadowAdd := a;
end;

function EPPReadData : byte;
begin
  EPPReadData := port[EPPDataPort];
end;

function EPPReadAddress : byte;
begin
  EPPReadAddress := port[EPPAddressPort];
end;

procedure EPPInit(ourport:word);
var foodata : byte;
begin
  DataPort := ourport;
  ContPort := ourport + ContOfs;
  StatPort := ourport + StatOfs;
  EPPDataPort := ourport + EPPDataOfs;
  EPPAddressPort := ourport + EPPAddressOfs;
  port[ContPort] := EPPIdleControl;
  port[StatPort] := EPPTimeout;
  EPPWriteAddress($FF);
  EPPWriteAddress($FF);
  foodata := EPPReadData;
end;

procedure WriteEPP32(addr : word; data : longint);
var foodata : byte;
begin
  EPPWriteAddress($FF);
  EPPWriteAddress($FF);
  foodata := EPPReadData;
  EPPWriteAddress(lo(addr));
  EPPWriteAddress(hi(addr) or $80);
  EPPWriteData(LongIntByteRec(data).Byte0);
  EPPWriteData(LongIntByteRec(data).Byte1);
  EPPWriteData(LongIntByteRec(data).Byte2);
  EPPWriteData(LongIntByteRec(data).Byte3);
end;

function ReadEPP32(addr : word) : longint;
var foodata : longint;
begin
  EPPWriteAddress($FF);
  EPPWriteAddress($FF);
  foodata := EPPReadData;
  EPPWriteAddress(lo(addr));
  EPPWriteAddress(hi(addr) or $80);
  LongIntByteRec(foodata).Byte0  := EPPReadData;
  LongIntByteRec(foodata).Byte1  := EPPReadData;
  LongIntByteRec(foodata).Byte2 := EPPReadData;
  LongIntByteRec(foodata).Byte3 := EPPReadData;
  ReadEPP32 := foodata;
end;

procedure FastWriteEPP32(addr : word; data : longint);
begin
  EPPWriteAddress(lo(addr));
  EPPWriteAddress(hi(addr) or $80);
  EPPWriteData(LongIntByteRec(data).Byte0);
  EPPWriteData(LongIntByteRec(data).Byte1);
  EPPWriteData(LongIntByteRec(data).Byte2);
  EPPWriteData(LongIntByteRec(data).Byte3);
end;

function FastReadEPP32(addr : word) : longint;
var
foodata : longint;
begin
  EPPWriteAddress(lo(addr));
  EPPWriteAddress(hi(addr) or $80);
  LongIntByteRec(foodata).Byte0  := EPPReadData;
  LongIntByteRec(foodata).Byte1  := EPPReadData;
  LongIntByteRec(foodata).Byte2 := EPPReadData;
  LongIntByteRec(foodata).Byte3 := EPPReadData;
  FastReadEPP32 := foodata;
end;

function EPPCheckTimeout : boolean;
begin
  if port[Statport] and EPPTimeout = 0 then EPPCheckTimeout := false else EPPChecktimeout := true;
end;

procedure EPPZeroPort;  {parallel port outputs are all set to zero}
begin                   {so the remote card is not powered by the port}
  port[DataPort] := 0;
  port[ContPort] := 0;
end;